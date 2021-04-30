# HashiCorp Vault Config

This repoistory containing secrets and config for our
HashiCorp Vault instance, hosted somehwere in Railway. Please use our `code-server`
instance on Divio at the following URL in the card below to
ensure no secrets were leaked on your machine.

---
**URL**: <https://hcv-config.code-server.repohubdev.tk>
**Password**: Found in Env Vars settings page and in the live server logs
**Repo**: <https://github.com/code-server-boilerplates/hashicorp-vault> (soon)
**Signed-in GitHub User**: [ThePinsTeam](https://github.com/thepinsteam)
---

_TL;DR: Please keep the Postgres database info, among other things, secret._

## Testing config

```sh
# test prod config (NOT RECOMMENDED)
vault server -dev -config prod.hcl

# in another session, unseal the vault 3 times using
# three of five unsealing keys, these unseal keys can
# be found in our Bitwarden org vault, under the
# HashiCorp Vault Shitfuckery Collection.
vault unseal <KEY-1>
vault unseal <KEY-2>
vault unseal <KEY-3>

# then authenicate using your GitHub PAT with read:org
# permissions
vault login -method=github token="ghp_randomShitfuckeryKeyHere"
```

## Updating production instance

This workflow will generate an base64 of output of `time`
and redirect the resulting base64'd output into `.trigger-update`. Check the `staging` environment's deploy logs for
any sort of errors and it's on `thepinsteam-hcvault-staging.up.railway.app` if you ever attempting to login.
