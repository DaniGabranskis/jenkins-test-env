FROM node:current-alpine3.20 AS builder_docker_and_node

WORKDIR /app

# Install Docker CLI
RUN apk update && apk add --no-cache \
    docker-cli \
    ca-certificates \
    curl

# Build test-env with jenkins, docker to make a test with docker container deploy and with nodejs to web server test
FROM jenkins/jenkins:lts AS test-env

WORKDIR /app

# Permissions for jenkins container
USER root

# Copy Docker CLI from builder
COPY --from=builder_docker_and_node /usr/bin/docker /usr/bin/docker

# Copy Node.js & npm from builder
COPY --from=builder_docker_and_node /usr/local/bin/node /usr/local/bin/node
COPY --from=builder_docker_and_node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder_docker_and_node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=builder_docker_and_node /usr/local/bin/npx /usr/local/bin/npx

# Change ownership to Jenkins user
RUN chown -R jenkins:jenkins /var/jenkins_home

# Switch back to Jenkins user
USER jenkins

COPY . .

EXPOSE 8080

