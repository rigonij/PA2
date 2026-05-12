FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -mod=vendor -o api .

FROM alpine:latest
RUN apk add --no-cache tzdata ca-certificates
ENV TZ=Europe/Paris
WORKDIR /app
COPY --from=builder /app/api .
EXPOSE 8080
CMD ["./api"]
