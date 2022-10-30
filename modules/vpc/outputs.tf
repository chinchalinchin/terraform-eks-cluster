output "rds-endpoint" {
    value                                               = aws_db_instance.gitlab_rds.endpoint
}


output "rds-id" {
    value                                               = aws_db_instance.gitlab_rds.id
}


output "rds-arn" {
    value                                               = aws_db_instance.gitlab_rds.arn
}