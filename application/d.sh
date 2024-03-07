docker build -t bankbetch/example-go:0.0.1 .

# docker buildx build --platform linux/amd64,linux/arm64 -t bankbetch/example-go:0.0.1 --push .