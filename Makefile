APP_DIR := projet-react
NPM := cd $(APP_DIR) &&

.PHONY: install dev test test-coverage lint build docker-build up down logs clean

install:
	$(NPM) npm ci


NEEDS_INSTALL := dev test test-coverage lint build
$(NEEDS_INSTALL): $(APP_DIR)/node_modules

$(APP_DIR)/node_modules: $(APP_DIR)/package-lock.json
	$(NPM) npm ci
	@touch $(APP_DIR)/node_modules

dev:
	$(NPM) npm run dev

test:
	$(NPM) npm test

test-coverage:
	$(NPM) npm run test:coverage

lint:
	$(NPM) npm run lint

build:
	$(NPM) npm run build

docker-build:
	docker compose build

up:
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f

clean:
	rm -rf $(APP_DIR)/node_modules $(APP_DIR)/dist $(APP_DIR)/coverage
