# SEE: https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files
# NOTE: ARNS OR IDS SHOULD BE PASSED IN USING ENVIRONMENT VARIABLES
#       SEE: https://www.terraform.io/cli/config/environment-variables
ec2_ssh_key = "al_cluster_key"
cluster_role_arn = "arn:aws:iam::<account_id>:role/<role_name>"
node_role_arn = "arn:aws:iam::<account_id>:role/<role_name>"
vpc_id="vpc-xxxxx"
subnet_ids = [
    "subnet-xxxxx", 
    "subnet-xxxxx"
]
source_ips = [
    "x.x.x.x/xx", 
    "x.x.x.x/x.x"
]
