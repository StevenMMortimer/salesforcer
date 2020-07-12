
# salesforcer_token <- readRDS("salesforcer_token.rds")
# sf_auth(token = salesforcer_token)

username <- Sys.getenv("SALESFORCER_USERNAME")
password <- Sys.getenv("SALESFORCER_PASSWORD")
security_token <- Sys.getenv("SALESFORCER_SECURITY_TOKEN")

sf_auth(username = username,
        password = password,
        security_token = security_token)
