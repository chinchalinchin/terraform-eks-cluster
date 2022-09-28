resource "aws_eks_cluster" "automation_library_cluster" {
  name     = "automation-library-cluster"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

}

output "endpoint" {
  value = aws_eks_cluster.automation_library_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}