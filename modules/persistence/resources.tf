resource "aws_kms_key" "persistence_key" {
    description                                         = "KMS key for encrypting relational database service secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
}


resource "random_password" "rds_password" {
  length                                                = 20
  special                                               = true
  numeric                                               = true
  upper                                                 = true
  lower                                                 = true
  override_special                                      = local.special_chars
}


resource "random_string" "random_id" {
    length                                              = 6
    special                                             = false
    override_special                                    = local.special_chars
}


resource "aws_secretsmanager_secret" "rds_password_secret"{
    description                                         = "Password for RDS superuser"
    kms_key_id                                          = aws_kms_key.persistence_key.id
    name                                                = "automation-library-postgresql-password-${random_string.random_id.result}"
}


resource "aws_secretsmanager_secret_version" "rds_password_secret_version" {
    secret_id                                           = aws_secretsmanager_secret.rds_password_secret.id
    secret_string                                       = random_password.rds_password.result
}


resource "aws_db_subnet_group" "rds_subnets" {
    name                                                = "automation-library-postgres-db-subnet-group"
    description                                         = "Subnet group for out-of-cluster RDS persistence"
    subnet_ids                                          = data.aws_subnets.cluster_private_subnets.ids
    tags                                                = local.rds_tags
}


resource "aws_security_group" "database_sg" {
    name                                                = "automation-library-postgres-db-access-sg"
    description                                         = "Bastion host security group"
    vpc_id                                              = data.aws_vpc.cluster_vpc.id
    tags                                                = local.rds_tags
}


resource "aws_security_group_rule" "database_ingress" {
    description                                         = "Restrict database access to VPC CIDR Block"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = [
                                                                data.aws_vpc.cluster_vpc.cidr_block
                                                        ]
    security_group_id                                   = aws_security_group.database_sg.id
} 


resource "aws_db_parameter_group" "cluster_rds_parameter_group" {
    family                                              = "postgres13"
    name                                                = local.rds_param_group_name

    parameter {
        name                                            = "log_statement"
        value                                           = "all"
    }

    parameter {
        name                                            = "log_min_duration_statement"
        value                                           = "1"
    }
}


/**
 * For GitLab external DB requirements, see: https://docs.gitlab.com/charts/advanced/external-db/index.html
**/
resource "aws_db_instance" "cluster_rds" {
    #checkov:skip=CKV_AWS_161: "Ensure RDS database has IAM authentication enabled"
    allocated_storage                                   = local.rds_storage
    auto_minor_version_upgrade                          = true
    backup_retention_period                             = 5
    # preferred_backup_window                             = "07:00-09:00"
    db_name                                             = local.rds_dbname
    db_subnet_group_name                                = aws_db_subnet_group.rds_subnets.id
    deletion_protection                                 = true
    enabled_cloudwatch_logs_exports                     = [ 
                                                            "postgresql" 
                                                        ]
    engine                                              = "postgres"
    engine_version                                      = "13.7"
    kms_key_id                                          = aws_kms_key.persistence_key.arn
    iam_database_authentication_enabled                 = true
    identifier                                          = local.rds_name
    instance_class                                      = local.rds_size
    monitoring_role_arn                                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_config.rds_monitor_role_name}"
    monitoring_interval                                 = local.rds_monitor_interval
    multi_az                                            = true 
    password                                            = random_password.rds_password.result
    parameter_group_name                                = aws_db_parameter_group.cluster_rds_parameter_group.name
    performance_insights_enabled                        = true
    performance_insights_kms_key_id                     = aws_kms_key.persistence_key.arn
    port                                                = 5432
    publicly_accessible                                 = false
    skip_final_snapshot                                 = true
    storage_encrypted                                   = true
    storage_type                                        = "gp2"
    tags                                                = local.rds_tags
    username                                            = local.rds_user
    vpc_security_group_ids                              = [
                                                            aws_security_group.database_sg.id
                                                        ]
}


resource "aws_ebs_volume" "cluster_volumes" {
  for_each                                              = local.availability_zones

  availability_zone                                     = "${var.region}${local.availability_zones[each.key]}"
  encrypted                                             = true
  kms_key_id                                            = aws_kms_key.persistence_key.arn
  size                                                  = local.ebs_volume_size
  tags                                                  = merge(
                                                            local.ebs_tags,
                                                            { 
                                                                "Name" = "${var.cluster_name}-volume-${var.region}${each.value}"
                                                            }
                                                        )
}