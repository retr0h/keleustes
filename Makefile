PKGS ?= $(shell go list ./... | /usr/bin/grep -v /vendor/)
PKGS_DELIM ?= $(shell echo $(PKGS) | sed -e 's/ /,/g')
VENDOR := vendor
GITCOMMIT := $(shell git rev-parse --short HEAD)
GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
GITCOMMIT := $(GITCOMMIT)-dirty
endif
VERSION := $(shell cat VERSION)
LDFLAGS := \ -s \
	-w \
	-X main.GITCOMMIT=${GITCOMMIT} \
	-X main.VERSION=${VERSION} \

test: fmt lint vet
	@echo "+ $@"
	go test -covermode=count ./...

fmt:
	@echo "+ $@"
	@gofmt -s -l . | grep -v $(VENDOR) | tee /dev/stderr

lint:
	@echo "+ $@"
	@golint ./... | grep -v $(VENDOR) | tee /dev/stderr

vet:
	@echo "+ $@"
	@go vet $(shell go list ./... | grep -v $(VENDOR))

clean:
	@echo "+ $@"
	@rm -rf ./build

build: clean
	@echo "+ $@"
	gox \
		-osarch="linux/amd64 darwin/amd64" \
		-ldflags="${LDFLAGS}" \
		-output="build/{{.Dir}}_{{.OS}}_{{.Arch}}"
