locals {
    availability_zones                                  = {
        0 = "b"
        1 = "c"
    } 
    ebs_volume_size                                     = 200
    ebs_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "ebs"
                                                        }
    rds_dbname                                          = "gitlabhq_production"
    rds_monitor_interval                                = 10
    rds_param_group_name                                = "automation-library-gitlab-postgresql-param-group"
    rds_name                                            = "automation-library-gitlab-postgres"
    rds_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "rds"
                                                            Engine          = "postgresql"
                                                        }
    rds_size                                            = "db.t3.medium"
    rds_storage                                         = 50
    rds_user                                            = "gitlab"
    special_chars                                       = "!#$%&*?"
}