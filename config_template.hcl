disable_mlock = true
ui            = true

listener "tcp" {
  address     = "0.0.0.0:3000"
  # proxy stuff
  tls_disable = "true"
}

storage "postgresql" {
  connection_url = "$DB_URL"
}

# TL;DR: Not an Honest Government Ads reference
api_addr = "$API_ADDRESS"
