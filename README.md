BQJdbcConnectionString
============

This package helps build the connection string required to use OHDSI [DatabaseConnector](https://github.com/OHDSI/DatabaseConnector) with BigQuery

Dependencies
============
Requires R (version 3.1.0 or higher), and jsonlite

Installation
=============
You will need to install devtools and run the following commands in R

```r
    library(devtools)
    install_github("jdposada/BQJdbcConnectionStringR")
```

How to use
=============
 Example of usage with DatabaseConnector

```r
jsonPath <- "/Users/jdposada/.config/gcloud/application_default_credentials.json"
bqDriverPath <- "/Users/jdposada/BqJdbcDrivers"

connectionString <-  createBQConnectionString(projectId = "som-rit-starr",
                                              defaultDataset = "jdposada_explore",
                                              authType = 2,
                                              jsonCredentialsPath = jsonPath,
                                              bqDriverPath = bqDriverPath)

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms="bigquery",
                                                                connectionString=connectionString,
                                                                user="",
                                                                password='',
                                                                pathToDriver = bqDriverPath)

# Create a connection
connection <- connect(connectionDetails)

# Test with a sql query to the concept table
sql = "select * from starr-omop-deid.concept limit 10;"
concepts <- querySql(connection, sql)

```