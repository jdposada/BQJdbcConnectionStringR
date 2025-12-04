# Created by: jdposada
# Created on: 3/27/20
library(jsonlite)



createBQConnectionString <- function(projectId='',
                                     defaultDataset='',
                                     authType = 2,
                                     jsonCredentialsPath = '',
                                     accountEmail = '',
                                     timeOut = 1000,
                                     logLevel = 0,
                                     logPath = '',
                                     proxyHost = '',
                                     proxyPort = '',
                                     proxyPwd = '',
                                     proxyUser = '',
                                     hostPort="jdbc:bigquery://https://www.googleapis.com/bigquery/v2:443"){

#' Build a connection string using the JDBC symba driver
#' https://www.simba.com/products/BigQuery/doc/JDBC_InstallGuide/content/jdbc/config-intro-online.htm
#' @details
#' This is a helper function to ease the process of creating a connection string for the JDBC BigQuery Driver.
#'
#' @param projectId This is the project where you will connect and the submitted SQL queries jobs will be executed. This is not neccesarilly the project where the datasets you are interested lives, but rather the project you have permissions to execute jobs.
#' @param defaultDataset This is the dataset where tables referenced on SQL code without a project or dataset id in the name will be created.
#' @param authType 0 to use a service account and 2 (default) to use a pregenerated refresh token.
#' @param jsonCredentialsPath This is the path with the json credentials. It can be from the pregenerated refresh token
  #' or the service account
#' @param accountEmail This is the account email for the service account if authType = 0
#' @param timeOut The length of time, in seconds, that the driver waits for a query to retrieve the results of an executed job
#' @param logLevel 0 for desabling 6 to log everything. Details here https://www.simba
  #' .com/products/BigQuery/doc/JDBC_InstallGuide/content/jdbc/options/loglevel.htm
#' @param logPath The full path to the folder where the driver saves log files when logging is enabled.
#' @param proxyHost The IP address or host name of your proxy server.
  #' @param proxyPort The listening port of your proxy server.
  #' @param proxyPwd The password, if needed, for proxy server settings.
  #' @param proxyUser The user name, if needed, for proxy server settings.
#' @param hostPort   Host and port the driver is connecting. This parameter usually does not change and its default value work
#'
#' @export

  ## TODO: throwing exceptions for neccessary paramters and create an R package

  projectId <- paste0("ProjectId=", projectId)
  defaultDataset <- paste0("DefaultDataset=", defaultDataset)

  if (authType == 2){
    credentials <- jsonlite::fromJSON(jsonCredentialsPath)
    clientId <- paste0("OAuthClientId=", credentials$client_id)
    refreshToken <- paste0("OAuthRefreshToken=", credentials$refresh_token)
    clientSecret <- paste0("OAuthClientSecret=", credentials$client_secret)
    keyPath <- ''
    accountEmail <- ''
  }
  else if (authType == 0){
    clientId <- ''
    refreshToken <- ''
    clientSecret <- ''
    keyPath <- paste0("OAuthPvtKeyPath=", jsonCredentialsPath)
    accountEmail <- paste0("OAuthServiceAcctEmail=", accountEmail)
  }
  else{
    print('Only service account or pregenerated tokens supported')
    return(FALSE)
  }

  authType <- paste0("OAuthType=", toString(authType))

  timeOut <- paste0("Timeout=", toString(timeOut))

  # default parameters to ensure we can retrieve large ammounts of data
  largeResults <- "AllowLargeResults=0" # this is enabled for a value of 1
  highThroughput <- "EnableHighThroughputAPI=1" # enabled with 1

  # Enabling query cache by default possibly reduces the cost
  queryCache <- "UseQueryCache=1" # 1 enables the use of cached queries

  # Logging
  if (logLevel > 0 & logPath != ''){
    logPath <- paste0("LogPath=", logPath)
  }

  logLevel <- paste0("LogLevel=", toString(logLevel))

  # Proxy configuration
  if (proxyHost != '' & proxyPort != '') {proxyHost <- paste0("ProxyHost=", proxyHost)}
  if (proxyPort != '' & proxyHost != '') {proxyPort <- paste0("ProxyPort=", proxyPort)}
  if (proxyUser != '' & proxyHost != '' & proxyPort != '') {proxyUser <- paste0("ProxyUser=", proxyUser)}
  if (proxyPwd != '' & proxyHost != '' & proxyPort != '') {proxyPwd <- paste0("ProxyPassword=", proxyPwd)}

  connectionString <- paste(c(hostPort,
                            projectId,
                            defaultDataset,
                            authType,
                            clientId,
                            refreshToken,
                            clientSecret,
                            accountEmail,
                            keyPath,
                            timeOut,
                            largeResults,
                            highThroughput,
                            queryCache,
                            logLevel,
                            logPath,
                            proxyHost,
                            proxyPort,
                            proxyUser,
                            proxyPwd,
                            "EnableSession=1"
                            ), collapse=";")

  connectionString <- gsub(pattern = ';{2,}', replacement = ';', connectionString)
  return(connectionString)

}
