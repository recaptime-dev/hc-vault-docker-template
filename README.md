# HashiCorp Vault Config

This repoistory containing documentation for our HashiCorp Vault instance hosted somewhere, possibly in Railway in the near future. This repository is also serves as starting point to deploy your own Vault instance on any Dokcerfile-supported PaaS service, with Postgres as the storage backend.

## Local Development

The easy way of running HashiCorp Vault locally (or in Gitpod) is using Docker Compose. When running, an single Vault node with Postgres will be used, thugh you can customize our `config_template.hcl` to add more configuration and `docker-compose.template.yml` to even bring MongoDB and add more nodes.

1. Right after cloning and `cd` into it, run `./scripts/compose-init` to generate `docker-compose.yml` and `.env`. If Bash and coreutils is nt installed on your Linux system (posibly you're using Alpine Linux), please install it based on your distribution's package manager docs.
    * To use an different template, prefix `COMPOSE_TEMPLATE_TYPE=template` where `template` can be `gitpodify` (aka `dirvolume`), `local`, and `ghcr.io`.
2. Customize the `docker-compose.yml` and `.env` files based on your liking, and ensure that your configuration matches what's in the Compose file, especially for `POSTGRES_*` stuff for initializing Postgres database.
3. Run with `docker-compose up -d` then `docker-compose logs --follow=all --tail` to track the logs, and allow our bootstrap script to automagically do database migrations and configuration generation before starting the Vault server.
4. Navigate to `http://localhost:3000` and complete the storage initialization and unsealing process.
   * If you have the Vault CLI installed, please see [`docs/init-vault.md`](docs/init-vault.md).
   * Don't have Vault installed? [See the installation docs](https://www.vaultproject.io/docs/install) or use the web terminal at `http://localhost:3012` and follow the instructions above.
5. Enjoy yur local Vault instance! To shut down, run `docker-compose stop`. (Remember that Vault will seals its storage and you need the unseal keys again when you do `docker-compose start`.)

## Deployment

The deployment docs is being wrking on, so contributions are welcome!

### With Railway

WIP

### With Okteto Cloud

WIP

## Docs for team members

See the [`docs/internal` directory](docs/internal) for URLs of our Vault instances, among other things.

## License

MIT
