# ! WARNING: BE CAREFUL USING THIS FILE AS IT GETS COMMITED TO VERSION CONTROL FOR CI PURPOSES!
# !      DO NOT INCLUDE SENSITIVE OR SECRET INFO IN IT!
# !      SENSITIVE INFO SHOULD BE PASSED IN USING ENVIRONMENT VARIABLES
# !      SEE: https://www.terraform.io/cli/config/environment-variables

# These variables are safe...
cluster_role_name = "AWSRoleForEKS"
node_role_name = "AmazonEKSNodeRole"
bastion_role_name = "AWSRoleForEKS"
ec2_ssh_key = "al_cluster_key"

# WARNING: These variables are just for show! See Above.
# vpc_id="vpc-xxxxx"
# public_subnet_ids = [
#     "subnet-xxxxx", 
#     "subnet-xxxxx"
# ]
# private_subnet_ids = [
#     "subnet-xxxx",
#     "subnet-xxxx"
# ]
# source_ips = [
#     "x.x.x.x/xx", 
#     "x.x.x.x/x.x"
# ]
