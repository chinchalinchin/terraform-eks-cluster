#### Non-defaultable variables
#### NOTE: These variables must be passed in through environment variables!
####    Do not commit their values to version control!
variable "vpc_id" {
    description = "Physical ID of the VPC into which the cluster will deploy"
    type = string
}

variable "public_subnet_ids"{
    description = "List of public subnet IDs into which the cluster will deploy"
    type = list
}

variable "private_subnet_ids" {
    description = "List of private subnet IDs into which the cluster will deploy"
    type = list
}

variable "source_ips" {
    description = "IPs to whitelist for remote SSH access to pods and ingress into the bastion host"
    type = list
}

#### Defaultable variables
variable "cluster_role_name" {
    description = "IAM role name for EKS cluster"
    type = string
    default = "AWSRoleForEKS"
}

variable "node_role_name" {
    description = "IAM role name for EKS Node Group"
    type = string
    default = "AmazonEKSNodeRole"
}

variable "bastion_role_name" {
    description = "IAM role name for the EC2 bastion host instance profile"
    type = string
    default = "AWSRoleforEC2"
}

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

variable "bastion_ami" {
    description = "AMI image to use for the bastion host. Defaults to us-east-1 Ubuntu 16.04. See the following to find the image in your region: https://cloud-images.ubuntu.com/locator/ec2/"
    type = string
    default = "ami-0b0ea68c435eb488d"
}