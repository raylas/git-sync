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

RUN echo "git-sync:x:65533:65533::/tmp:/sbin/nologin" >> /etc/passwd
RUN chmod 0666 /etc/passwd
RUN echo "git-sync:x:65533:git-sync" >> /etc/group
RUN mkdir -m 02775 /tmp/git && chown 65533:65533 /tmp/git

USER 65533:65533

ENV HOME=/tmp
WORKDIR /tmp

ENV GIT_SYNC_ROOT=/tmp/git

ENTRYPOINT ["./git-sync"]  
