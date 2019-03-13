# Dockerimage for Quasselcore

## Stateful usage (with UI Wizard)

By default, the core will be run in stateful mode.

If you use the core in this mode, you’ll have to make sure `/config` is stored
on a volume.

Example usage:

```bash
docker run \
  -v /path/to/quassel/volume:/config \
  k8r.eu/justjanne/quassel-docker:v0.13.1
```

## Stateless usage

To use Quassel in stateless mode, where it needs to be configured through
environment arguments, run it with the `--config-from-environment` argument.

`DB_BACKEND` defines the backend used for the database, this can be `SQLite` or
`PostgreSQL`. In case `SQLite` is used, the database will be stored in
`/root/.config/quassel-irc.org/quassel-storage.sqlite`. If `PostgreSQL` is used
instead, these variables determine the connection details: `DB_PGSQL_USERNAME`,
`DB_PGSQL_PASSWORD`, `DB_PGSQL_HOSTNAME`, `DB_PGSQL_PORT`, `DB_PGSQL_DATABASE`.

`AUTH_AUTHENTICATOR` defines the backend used for authentication, this can be
`Database` or `LDAP`. In case `LDAP` is used, the following environment
variables determine the connection details: `AUTH_LDAP_HOSTNAME`,
`AUTH_LDAP_PORT`, `AUTH_LDAP_BIND_DN`, `AUTH_LDAP_BIND_PASSWORD`,
`AUTH_LDAP_BASE_DN`, `AUTH_LDAP_FILTER`, `AUTH_LDAP_UID_ATTRIBUTE`.

Minimal example with SQLite:

```bash
docker run \
  -v /path/to/quassel/volume:/config \
  -e DB_BACKEND=SQLite \
  -e AUTH_AUTHENTICATOR=Database \
  k8r.eu/justjanne/quassel-docker:v0.13.1 \
  --config-from-environment
```

Full example with PostgreSQL and examples of other options:

```bash
docker run \
  -v /path/to/certificates/tls.crt:/tls.crt \
  -v /path/to/certificates/tls.key:/tls.key \
  -e DB_BACKEND=PostgreSQL \
  -e AUTH_AUTHENTICATOR=Database \
  -e DB_PGSQL_USERNAME=quassel \
  -e DB_PGSQL_PASSWORD=thesamecombinationasonmyluggage \
  -e DB_PGSQL_HOSTNAME=postgresql.default.svc.cluster.local \
  -e DB_PGSQL_PORT=5432 \
  -e DB_PGSQL_DATABASE=quassel \
  k8r.eu/justjanne/quassel-docker:v0.13.1 \
  --config-from-environment \
  --strict-ident \
  --ident-daemon \
  --ident-port "10113" \
  --ident-listen "::,0.0.0.0" \
  --ssl-cert /tls.crt \
  --ssl-key /tls.key \
  --require-ssl
```

## SSL

You can use the core with SSL, in this case you should either put a
`quasselCert.pem` file with the full certificate chain and private key into
the `/config` volume, or you can use the `--ssl-cert` and `--ssl-key`
arguments to use separate key and certificate.

## Ports

Per default, the container will listen on the port 4242 for connections.
This can be configured with `--port` and `--listen`.

If the `--ident-daemon` argument is passed, the ident daemon will additionally
listen on 10113. You can configure this with `--ident-port`.
