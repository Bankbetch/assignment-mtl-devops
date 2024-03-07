
FROM --platform=$BUILDPLATFORM golang:1.20 as builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -installsuffix cgo -o build .
FROM scratch

WORKDIR /app
COPY --from=builder /app/build .
EXPOSE 8080
CMD ["./build"]