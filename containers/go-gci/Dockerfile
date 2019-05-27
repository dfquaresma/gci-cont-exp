FROM golang:1.11-alpine3.9 as builder

# Allows you to add additional packages via build-arg
ARG ADDITIONAL_PACKAGE
ARG CGO_ENABLED=0
ARG WATCHDOG_VERSION=0.5.1

RUN mkdir /handler
WORKDIR /handler

RUN apk --no-cache add curl git ${ADDITIONAL_PACKAGE} \
    && echo "Pulling watchdog binary and gci-proxy from Github." \
    && curl -sSL https://github.com/openfaas-incubator/of-watchdog/releases/download/$WATCHDOG_VERSION/of-watchdog > /handler/fwatchdog \
    && chmod +x /handler/fwatchdog \
    && curl -sSL https://github.com/dfquaresma/socc19/raw/master/containers/go-gci/gci-proxy > /handler/gci-proxy \
    && chmod +x /handler/gci-proxy

# Force the go compiler to use modules
ENV GO111MODULE=on
 
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
 
#This is the ‘magic’ step that will download all the dependencies that are specified in 
# the go.mod and go.sum file.
# Because of how the layer caching system works in Docker, the  go mod download 
# command will _ only_ be re-run when the go.mod or go.sum file change 
# (or when we add another docker instruction this line)
RUN go mod download

# Removing pre-installed packages.
RUN apk del curl git --no-cache

COPY . .

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*" -not -path "./function/vendor/*"))" || { echo "Run \"gofmt -s -w\" on your Golang code"; exit 1; }

RUN CGO_ENABLED=${CGO_ENABLED} GOOS=linux \
    go build --ldflags "-s -w" -a -installsuffix cgo -o handler . && \
    go test $(go list ./... | grep -v /vendor/) -cover

FROM alpine:3.9
RUN apk --no-cache add ca-certificates

# Add non root user
RUN addgroup -S app && adduser -S -g app app
RUN mkdir -p /home/app

WORKDIR /home/app

COPY --from=builder /handler/fwatchdog         .
COPY --from=builder /handler/function/  .
COPY --from=builder /handler/handler    .
COPY --from=builder /handler/gci-proxy  .

RUN chown -R app /home/app

USER app

ENV image_path="/home/app/samples/nasa.jpg"
ENV cascade_file="/home/app/data/facefinder"

ENV mode="http"
ENV YOUNG_GEN_SIZE_B="67108864"
ENV HANDLER_PORT="8083"
ENV PROXY_PORT="8082"
ENV upstream_url="http://127.0.0.1:${PROXY_PORT}"
ENV GODEBUG="gctrace=1"
ENV GOMAXPROCS="1"
ENV fprocess="./handler"
EXPOSE 8080

HEALTHCHECK --interval=2s CMD [ -e /tmp/.lock ] || exit 1

CMD ["sh","-c","nohup ./gci-proxy --port=${PROXY_PORT} --target=127.0.0.1:${HANDLER_PORT} --gci_target=127.0.0.1:${HANDLER_PORT} --gci_path=__gci --ygen=${YOUNG_GEN_SIZE_B} > /tmp/log & ./fwatchdog"]
