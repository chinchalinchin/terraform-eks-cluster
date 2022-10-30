# ! WARNING: BE CAREFUL USING THIS FILE AS IT GETS COMMITED TO VERSION CONTROL FOR CI PURPOSES!
# !      DO NOT INCLUDE SENSITIVE OR SECRET INFO IN IT!
# !      SENSITIVE INFO SHOULD BE PASSED IN USING ENVIRONMENT VARIABLES
# !      SEE: https://www.terraform.io/cli/config/environment-variables

# These variables are safe to commit...
cluster_name                = "automation-library-cluster"
private_domain              = "bah-automation-library.com"
public_domain               = "bahmulticloud.com"
region                      = "us-east-1"
ssh_key                     = "automation_library_key"
iam_config = {
    cluster_role_name       = "AWSRoleForEKS"
    node_role_name          = "AmazonEKSNodeRole"
    ebs_role_name           = "AmazonEBSforEKSRole"
    rds_monitor_role_name   = "rds-monitoring-role"
    bastion_profile_name    = "AWSRoleforECS"
}
eks_config  = {
    node_count              = 2
    instance_type           = "m5.xlarge"
}
bastion_config = {
    ami                     = "ami-0b0ea68c435eb488d"
}