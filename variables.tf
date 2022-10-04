### Credential, role and address variables
#### These variables must be passed in through environment variables!
####    Do not commit their values to version control!
variable "cluster_role_arn" {
    description = "IAM role arn for EKS cluster"
    type = string
}

variable "node_role_arn" {
    description = "IAM role arn for EKS Node Group"
    type = string
}

variable "vpc_id" {
    description = "Physical ID of the VPC into which the cluster will deploy"
    type = string
}

variable "subnet_ids"{
    description = "List of subnet IDs into which to cluster pods"
    type = list
}

variable "source_ips" {
    description = "IPs to whitelist for remote SSH access to pods"
    type = list
}

#### Defaultable variables
variable "ec2_ssh_key" {
    description = "Name of the public SSH key in the EC2 keyring. NOTE: this key must exist in the keyring before launching this Terraform moduel. Refer to QUICKSTART documentation for more information."
    type = string
    default = "al_cluster_key"
}

variable "node_count" {
    description = "Number of node groups to deploy"
    type = number 
    default = 2
}

variable "instance_type" {
    description = "Node instance type. Default is recommened by GitLab documentation. See: https://docs.gitlab.com/charts/installation/cloud/eks.html#scripted-cluster-creation"
    type = string
    default = "m5.xlarge"
}