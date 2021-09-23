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

RUN addgroup -S 65533 && \
    adduser -S 65533 -G 65533 -h /tmp

RUN mkdir -m 02775 /tmp/git && chown 65533:65533 /tmp/git

USER 65533:65533

WORKDIR /tmp
COPY --from=build /go/bin/git-sync ./

ENV HOME=/tmp
ENV GIT_SYNC_ROOT=/tmp/git

ENTRYPOINT ["./git-sync"]  
