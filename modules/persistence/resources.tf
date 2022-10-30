resource "aws_kms_key" "rds_key" {
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
    kms_key_id                                          = aws_kms_key.rds_key.id
    name                                                = "automation-library-postgresql-password-${random_string.random_id.result}"
}


resource "aws_secretsmanager_secret_version" "gitlab_rds_password_secret_version" {
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


/**
 * For GitLab external DB requirements, see: https://docs.gitlab.com/charts/advanced/external-db/index.html
**/
resource "aws_db_instance" "rds" {
    allocated_storage                                   = 20
    db_name                                             = local.rds_dbname
    db_subnet_group_name                                = aws_db_subnet_group.rds_subnets.id
    enabled_cloudwatch_logs_exports                     = [ 
                                                            "postgresql" 
                                                        ]
    engine                                              = "postgres"
    engine_version                                      = "13.7"
    kms_key_id                                          = aws_kms_key.rds_key.arn
    identifier                                          = local.rds_name
    instance_class                                      = local.rds_size
    monitoring_role_arn                                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_config.rds_monitor_role_name}"
    monitoring_interval                                 = local.rds_monitor_interval
    password                                            = random_password.rds_password.result
    performance_insights_enabled                        = true
    performance_insights_kms_key_id                     = aws_kms_key.rds_key.arn
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