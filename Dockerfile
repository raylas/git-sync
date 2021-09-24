#
# Build
#
FROM golang:1.17-alpine3.14 as build

WORKDIR /go/src/git-sync
COPY ./git-sync/ .

RUN go get -d -v ./... && \
    go mod vendor
RUN go install -v ./...
RUN go build -o /go/bin/git-sync ./cmd/git-sync/main.go

#
# App
#
FROM alpine:3.14 as app

RUN apk update && apk --no-cache add \
    ca-certificates \
    bash \
    curl \
    jq \
    openssh-client \
    git

COPY --from=build /go/bin/git-sync ./

RUN mkdir /root/git

ENV GIT_SYNC_ROOT=/root/git

ENTRYPOINT ["./git-sync"]  
