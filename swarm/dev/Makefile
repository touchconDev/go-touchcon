.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/ethereum/go-ethereum/cmd/swarm
	go build -o bin/gtc     github.com/ethereum/go-ethereum/cmd/gtc
	go build -o bin/bootnode github.com/ethereum/go-ethereum/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/ethereum/go-ethereum/swarm/...
