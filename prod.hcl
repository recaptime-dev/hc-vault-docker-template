#disable_mlock = true
ui            = true

listener "tcp" {
  address     = "0.0.0.0:3000"
  # proxy stuff
  tls_disable = "true"
}

storage "postgresql" {
  connection_url = "postgres://user:pass@host:12345/db"
}

# TL;DR: Not an Honest Government Ads reference
api_addr = "https://bullshit-hq.vault.mafebythepins.tk"
