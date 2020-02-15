DAYS=1095
CA_ALGO=rsa:2048

help: ## Help
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

server@create_ca: ## Create CA (Certificate Authority), Params: CA_ALGO
	openssl genrsa -out server/rootCA.key 4096
	openssl req -x509 -new -nodes -newkey ${CA_ALGO} -key server/rootCA.key -sha256 -days ${DAYS} -out server/rootCA.crt
	@echo " server/rootCA.key is your key, that will be used to sign client keys. Keep it secret."

client@generate_cert: ## Generate a certificate for a client. Params: NAME
	@[[ "${NAME}" ]] || (echo "Please provide a valid NAME parameter" && exit 1)

	mkdir -p clients/${NAME}
	openssl genrsa -out clients/${NAME}/tls.key 4096
	openssl req -new -key clients/${NAME}/tls.key -out clients/${NAME}/tls.csr -subj "/C=US/ST=CA/O=Riotkit.org/CN=${NAME}"

	@echo " >> Creating a signed key at 'clients/${NAME}/tls.crt'"
	openssl x509 -req -in clients/${NAME}/tls.csr -CA server/rootCA.crt -CAkey server/rootCA.key -CAcreateserial -out clients/${NAME}/tls.crt -days ${DAYS} -sha256
	cp -pr server/rootCA.crt clients/${NAME}/ca.crt
