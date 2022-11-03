## Gitlab

### Helm Chart

TODO: explain what values need updated in _.sample.values.yml_

```shell
helm install automation-library-gitlab -f ./helm/gitlab/values.yml
```


## Jira

### Setup

**Create database in RDS named `jira`**
 
SSH into bastion host, establish an admin session with **PostgreSQL** and provision a new database,

```
ssh -i <path-to-private-key> ubuntu@<bastion-dns>
psql --host <rds-host> --port <rds-port> --dbname <rds-default-db> --username <rds-username> -W
CREATE DATABASE jira;
\q
```

If not using the default user for the **Jira Helm** installation, you must then `GRANT` access to the **Jira** user. See [postgresql GRANT documentation](https://www.postgresql.org/docs/current/sql-grant.html) for more information.

### Helm Chart

TODO: explain what values need update in _.sample.values.yml_

```shell
helm install automation-library-jira -f ./helm/jira/values.yml
```