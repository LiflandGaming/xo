FROM golang as builder

ENV GOBIN $GOPATH/bin
WORKDIR /src

# install goimports
RUN go get -u golang.org/x/tools/cmd/goimports && cp $GOBIN/goimports /

# cache dependencies
COPY go.sum .
COPY go.mod .
RUN go list -e $(go list -f '{{.Path}}' -m all 2>/dev/null)


# build the app
ADD . /src
RUN go build -o xo .

# do a release container
FROM alpine as release
RUN apk add --no-cache \
	libc6-compat
COPY --from=builder /src/xo .
COPY --from=builder /goimports /bin/

ENTRYPOINT ["/xo"]
