# Copyright Manetu Inc. All Rights Reserved.

PROJECT_NAME := manetu-login-policy
GO_FILES := $(shell find . -name '*.go' | grep -v /vendor/ | grep -v _test.go)

.PHONY: all clean lint test goimports staticcheck tests sec-scan

all: lint test race staticcheck goimports sec-scan

lint: ## Run unittests
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	@go vet

test: ## Run unittests
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	@go test -cover -coverprofile=coverage.out -coverpkg=./... ./...

race: ## Run data race detector
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	@go test ./... -race -short .

staticcheck: ## Run data race detector
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	@staticcheck -f stylish  ./...

goimports: ## Run goimports
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	$(eval goimportsdiffs = $(shell goimports -l .))
	@if [ -n "$(goimportsdiffs)" ]; then\
		echo "goimports shows diffs for these files:";\
		echo "$(goimportsdiffs)";\
		exit 1;\
	fi

clean: ## Remove previous build
	@printf "\033[36m%-30s\033[0m %s\n" "### make $@"
	@rm go.sum

sec-scan: ## Run gosec; see https://github.com/securego/gosec
	@gosec ./...

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
