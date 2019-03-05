FROM golang as builder

WORKDIR /src

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

ENTRYPOINT ["/xo"]
