locals {
    rds_dbname                                          = "gitlabhq_production"
    rds_monitor_interval                                = 10
    rds_name                                            = "automation-library-gitlab-postgres"
    rds_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "rds"
                                                            Engine          = "postgresql"
                                                        }
    rds_size                                            = "db.t3.medium"
    rds_user                                            = "gitlab"
    special_chars                                       = "!#$%&*?"
}