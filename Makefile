RELEASE_BINARY_NAME=terraform-state-ansible-module
MODULE_BINARY_NAME=terraform_state
PLUGINS_DIR=~/.ansible/plugins/modules

.PHONY: plugins-dir
plugins-dir:
	mkdir -p ${PLUGINS_DIR}

.PHONY: lint
lint:
	@which golint > /dev/null || go get -u golang.org/x/lint/golint
	golint

.PHONY: update-dependencies
update-dependencies:
	@which glide > /dev/null || go get -u github.com/Masterminds/glide
	glide up

.PHONY: build-linux
build-linux: plugins-dir
	CGO_ENABLED=0 GOOS=linux installsuffix=cgo go build -o ./${RELEASE_BINARY_NAME}-linux
	cp ./${RELEASE_BINARY_NAME}-linux ${PLUGINS_DIR}/${MODULE_BINARY_NAME}
	rm ./${RELEASE_BINARY_NAME}-linux

.PHONY: build-darwin
build-darwin: plugins-dir
	CGO_ENABLED=0 GOOS=darwin installsuffix=cgo go build -o ./${RELEASE_BINARY_NAME}-darwin
	cp ./${RELEASE_BINARY_NAME}-darwin ${PLUGINS_DIR}/${MODULE_BINARY_NAME}
	rm ./${RELEASE_BINARY_NAME}-darwin

# this rule must not be used directly
.PHONY: build-release
build-release:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-linux-amd64_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=linux GOARCH=386 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-linux-386_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=freebsd GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-freebsd-amd64_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=freebsd GOARCH=386 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-freebsd-386_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=openbsd GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-openbsd-amd64_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=openbsd GOARCH=386 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-openbsd-386_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-windows-amd64_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=windows GOARCH=386 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-windows-386_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=solaris GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-solaris-amd64_${RELEASE_VERSION}
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 installsuffix=cgo go build -o ${GOPATH}/bin/${RELEASE_BINARY_NAME}-darwin-amd64_${RELEASE_VERSION}

.PHONY: test
test:
	go test

.PHONY: test-verbose
test-verbose:
	go test -v ./...