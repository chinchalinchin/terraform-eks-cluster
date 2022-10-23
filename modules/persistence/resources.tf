resource "aws_kms_key" "rds_key" {
    description                                         = "KMS key for encrypting relational database service secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
}

resource "random_password" "gitlab_rds_password" {
  length                                                = 20
  special                                               = true
  numeric                                               = true
  upper                                                 = true
  lower                                                 = true
}


resource "aws_secretsmanager_secret" "gitlab_rds_password_secret"{
    description                                         = "Password for Gitlab RDS superuser"
    kms_key_id                                          = aws_kms_key.rds_key.id
    name                                                = "gitlab-rds-password"
}


resource "aws_secretsmanager_secret_version" "gitlab_rds_password_secret_version" {
    secret_id                                           = aws_secretsmanager_secret.gitlab_rds_password_secret.id
    secret_string                                       = random_password.gitlab_rds_password.result
}


resource "aws_db_subnet_group" "gitlab_rds_subnets" {
    name                                                = "gitlab-db-subnet-group"
    description                                         = "Subnet group for out-of-cluster RDS persistence (recommended by GitLab documentation)"
    subnet_ids                                          = var.vpc_config.private_subnet_ids
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "rds"
                                                        }
}


/**
 * For GitLab external DB requirements, see: https://docs.gitlab.com/charts/advanced/external-db/index.html
**/
resource "aws_db_instance" "gitlab_rds" {
    allocated_storage                                   = 20
    db_name                                             = "gitlabhq_production"
    db_subnet_group_name                                = aws_db_subnet_group.gitlab_rds_subnets.id
    engine                                              = "postgres"
    engine_version                                      = "13.7"
    kms_key_id                                          = aws_kms_key.rds_key.id
    instance_class                                      = "db.t3.medium"
    username                                            = "gitlab"
    password                                            = random_password.gitlab_rds_password.result
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "rds"
                                                        }
    vpc_security_group_ids                              = [
                                                            "need cluster ingress"
                                                        ]
}