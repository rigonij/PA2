FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -mod=vendor -o api .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/api .
EXPOSE 8080
CMD ["./api"]