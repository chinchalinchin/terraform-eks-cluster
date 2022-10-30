locals {
    rds_dbname                                          = "gitlabhq_production"
    rds_name                                            = "automation-library-gitlab-postgres"
    rds_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "rds"
                                                            Engine          = "postgresql"
                                                        }
    rds_size                                            = "db.t3.medium"
    rds_user                                            = "gitlab"
}