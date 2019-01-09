# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gtc android ios gtc-cross swarm evm all test clean
.PHONY: gtc-linux gtc-linux-386 gtc-linux-amd64 gtc-linux-mips64 gtc-linux-mips64le
.PHONY: gtc-linux-arm gtc-linux-arm-5 gtc-linux-arm-6 gtc-linux-arm-7 gtc-linux-arm64
.PHONY: gtc-darwin gtc-darwin-386 gtc-darwin-amd64
.PHONY: gtc-windows gtc-windows-386 gtc-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gtc:
	build/env.sh go run build/ci.go install ./cmd/gtc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gtc\" to launch gtc."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gtc.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gtc.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

gtc-cross: gtc-linux gtc-darwin gtc-windows gtc-android gtc-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gtc-*

gtc-linux: gtc-linux-386 gtc-linux-amd64 gtc-linux-arm gtc-linux-mips64 gtc-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-*

gtc-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gtc
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep 386

gtc-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gtc
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep amd64

gtc-linux-arm: gtc-linux-arm-5 gtc-linux-arm-6 gtc-linux-arm-7 gtc-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep arm

gtc-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gtc
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep arm-5

gtc-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gtc
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep arm-6

gtc-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gtc
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep arm-7

gtc-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gtc
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep arm64

gtc-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gtc
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep mips

gtc-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gtc
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep mipsle

gtc-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gtc
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep mips64

gtc-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gtc
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gtc-linux-* | grep mips64le

gtc-darwin: gtc-darwin-386 gtc-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gtc-darwin-*

gtc-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gtc
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-darwin-* | grep 386

gtc-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gtc
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-darwin-* | grep amd64

gtc-windows: gtc-windows-386 gtc-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gtc-windows-*

gtc-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gtc
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-windows-* | grep 386

gtc-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gtc
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gtc-windows-* | grep amd64
