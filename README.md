# HashiCorp Vault Config

This repoistory containing config for our HashiCorp Vault instance, hosted somewhere.

## Instances

* Production: <https://bullshit-hq.vault.madebythepins.tk>
* Staging: <https://bullshit-hq-vault.staging.rtapp.tk>

## Testing config

```sh
# Edit the dotenv file
cp .env.example .evn
nano .env

# Run in Docker
docker-compose up -d

# set VAULT_ADDR into
export VAULT_ADDR='http://127.0.0.1:3000'

vault login -method=github token="ghp_randomBullshitKeyHere"
```

## Updating production instance

This workflow will generate an base64 of output of `time`
and redirect the resulting base64'd output into `.trigger-update`.

Please be reminded that each environment has its own Postgres database to avoid chaos.
