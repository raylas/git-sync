# git-sync

[![build](https://github.com/raylas/git-sync/actions/workflows/build.yml/badge.svg)](https://github.com/raylas/git-sync/actions/workflows/build.yml)

A custom Docker image variant of [kubernetes/git-sync](https://github.com/kubernetes/git-sync) that adds some useful tooling and runs on Alpine.

## Usage
Clone the upstream repo:
```sh
$ make clone
```

Build for linux/amd64:
```sh
$ make build-amd64
```

Build for linux/arm64:
```sh
$ make build-arm64
```

Clean up:
```sh
$ make clean
```
