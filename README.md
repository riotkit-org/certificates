# certificates

Self-signed certificates generation never was so simple before.

### 1. Generating server certificate authority

```bash
make server@create_ca
```

Now copy the contents of `server/` directory, and keep in safe place.
Do not delete the contents from this directory, as you need the certificate to generate client certificates.

### 2. Generate client certificate

```bash
make client@generate_cert NAME=my-domain.org
```

Copy the contents of `clients/my-domain.org/` directory to a safe place and use in your application.
