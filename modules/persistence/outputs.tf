output "rds-endpoint" {
    value                                               = aws_db_instance.cluster_rds.endpoint
}

output "ebs-arns" {
    value                                               = values(aws_ebs_volume.cluster_volumes)[*].arn
}