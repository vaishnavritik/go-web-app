
# Stage 1: Build the Go application
FROM golang:1.22.5 AS builder

WORKDIR /app

# Copy dependency definition first
COPY go.mod ./
RUN go mod download

# Copy the application source
COPY . .

# Compile a Linux executable
RUN CGO_ENABLED=0 GOOS=linux go build -o go-web-app .

# Stage 2: Minimal runtime image
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

# Copy the binary and static HTML assets
COPY --from=builder /app/go-web-app ./go-web-app
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./go-web-app"]
