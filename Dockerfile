# Use the golang image to create the builder
FROM golang:1.20-alpine3.19 AS builder

# Set build arguments
ARG CN="no"
ARG appVer="appVer"
ARG commitId="commitId"

# Set environment variables
ENV TZ=Asia/Shanghai

# Install Node.js and npm
RUN apk add --no-cache nodejs npm
ENV NODE_OPTIONS=--openssl-legacy-provider
# Set the working directory
WORKDIR /server

# Clone the anylink repository
RUN apk add --no-cache git \
    && git clone https://github.com/bjdgyc/anylink.git /app \
    && apk del git

# Copy the build scripts and source code
COPY translate.sh /tmp/
RUN cp /app/docker/init_build.sh /tmp/
RUN cp -r /app/server/* /server/

RUN chmod +x /tmp/translate.sh
RUN sh /tmp/translate.sh

RUN cd /app/web && npm install && npm run build
RUN cp -r /app/web/ui /server/ui

# Run the build script
RUN sh /tmp/init_build.sh

# Use the alpine image for the final stage
FROM alpine:3.19

# Set environment variables
ENV TZ=Asia/Shanghai
ENV ANYLINK_IN_CONTAINER=true

# Set the working directory
WORKDIR /app

# Clone the anylink repository
RUN apk add --no-cache git \
    && git clone https://github.com/bjdgyc/anylink.git . \
    && apk del git

# Copy the build scripts and binaries from the builder stage
COPY --from=builder /server/anylink /app/
RUN cp docker/init_release.sh /tmp/
RUN cp docker/docker_entrypoint.sh server/bridge-init.sh /app/
RUN cp -r ./server/conf /app/conf

# Run the release script
RUN sh /tmp/init_release.sh

# Expose ports
EXPOSE 443 8800 443/udp

# Set the entrypoint
ENTRYPOINT ["/app/docker_entrypoint.sh"]
