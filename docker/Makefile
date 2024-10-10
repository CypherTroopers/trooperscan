SYSTEM = $(shell uname -s) 
# HOST = host.docker.internal
HOST = 10.0.0.137
DOCKER_IMAGE = cypherium-explorer:v2
BS_CONTAINER_NAME = cph-explorer
PG_CONTAINER_NAME = postgres
PG_CONTAINER_IMAGE = postgres:12.5
THIS_FILE = $(lastword $(MAKEFILE_LIST))

ifeq ($(SYSTEM), Linux)
	HOST=localhost
endif

DB_URL = postgresql://root:tx2SYF5V9r7ci%25DMLFtk%5EAEy95138S%25v@10.0.0.137:5432/explorer?ssl=true
BLOCKSCOUT_CONTAINER_PARAMS = -e 'MIX_ENV=prod' \
															 -e 'DATABASE_URL=$(DB_URL)'

# Cypherium RPC URL
CYHPHERIUM_RPC_URL = "https://pubnodes.cypherium.io/"
BLOCKSCOUT_CONTAINER_PARAMS += -e 'ETHEREUM_JSONRPC_HTTP_URL=$(CYHPHERIUM_RPC_URL)'

ifeq ($(SYSTEM), Linux)
	BLOCKSCOUT_CONTAINER_PARAMS += --network=host
endif
ifdef NETWORK
	BLOCKSCOUT_CONTAINER_PARAMS += -e 'NETWORK=$(NETWORK)'
endif
ifdef SUBNETWORK
	BLOCKSCOUT_CONTAINER_PARAMS += -e 'SUBNETWORK=$(SUBNETWORK)'
endif
ifdef LOGO
	BLOCKSCOUT_CONTAINER_PARAMS += -e 'LOGO=$(LOGO)'
endif
ifdef LOGO_FOOTER
	BLOCKSCOUT_CONTAINER_PARAMS += -e 'LOGO_FOOTER=$(LOGO_FOOTER)'
endif

# 環境変数の設定
ifdef CYHPHERIUM_SPECIFIC_VARIABLE
	BLOCKSCOUT_CONTAINER_PARAMS += -e 'CYHPHERIUM_SPECIFIC_VARIABLE=$(CYHPHERIUM_SPECIFIC_VARIABLE)'
endif

HAS_BLOCKSCOUT_IMAGE := $(shell docker images | grep -sw ${DOCKER_IMAGE})
build: 
	@echo "==> Checking for blockscout image $(DOCKER_IMAGE)"
ifdef HAS_BLOCKSCOUT_IMAGE
	@echo "==> Image exist. Using $(DOCKER_IMAGE)"
else
	@echo "==> No image found trying to build one..."
	@docker build --build-arg COIN="$(COIN)" -f ./Dockerfile -t $(DOCKER_IMAGE) ../
endif

migrate_only:
	@echo "==> Running migrations"
	@docker run --rm \
					$(BLOCKSCOUT_CONTAINER_PARAMS) \
					$(DOCKER_IMAGE) /bin/sh -c "echo $$MIX_ENV && mix do ecto.create, ecto.migrate"

migrate: build postgres
	@$(MAKE) -f $(THIS_FILE) migrate_only

PG_EXIST := $(shell docker ps -a --filter name=${PG_CONTAINER_NAME} | grep ${PG_CONTAINER_NAME})
PG_STARTED := $(shell docker ps --filter name=${PG_CONTAINER_NAME} | grep ${PG_CONTAINER_NAME})
postgres:
ifdef PG_EXIST
	@echo "==> Checking PostgreSQL container"
ifdef PG_STARTED
	@echo "==> PostgreSQL Already started"
	@$(MAKE) -f $(THIS_FILE) migrate_only
else
	@echo "==> Starting PostgreSQL container"
	@docker start $(PG_CONTAINER_NAME)
	@$(MAKE) -f $(THIS_FILE) migrate_only
endif
else
	@echo "==> Creating new PostgreSQL container"
	@docker run -d --name $(PG_CONTAINER_NAME) \
					-e POSTGRES_PASSWORD="" \
					-e POSTGRES_USER="postgres" \
					-e POSTGRES_HOST_AUTH_METHOD="trust" \
					-p 5432:5432 \
					$(PG_CONTAINER_IMAGE)
	@sleep 1
	@$(MAKE) -f $(THIS_FILE) migrate_only
endif

start:
	@echo "==> Starting blockscout"
	@docker run -d --restart always --name $(BS_CONTAINER_NAME) \
					$(BLOCKSCOUT_CONTAINER_PARAMS) \
					-p 80:80 -p 443:443 \
					$(DOCKER_IMAGE) /bin/sh -c "mix phx.server"

run: start

.PHONY: build \
				migrate \
				start \
				postgres \
				run 
