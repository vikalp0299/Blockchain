# Builder stage
FROM node:16 AS builder

WORKDIR /usr/src/app

# Copy source files with proper ownership
COPY --chown=node:node package.json ./
COPY --chown=node:node package-lock.json ./
COPY --chown=node:node tsconfig.json ./
COPY --chown=node:node src ./src

# Install dependencies
RUN npm ci

# Build and generate shrinkwrap
RUN npm run package

# Production stage
FROM node:16 AS production

# Build argument for chaincode server port
ARG CC_SERVER_PORT=5999

# Install tini for proper signal handling
RUN wget -q https://github.com/krallin/tini/releases/download/v0.19.0/tini-arm64 -O /tini && \
    chmod +x /tini

WORKDIR /usr/src/app

# Copy compiled code and dependencies from builder
COPY --chown=node:node --from=builder /usr/src/app/dist ./dist
COPY --chown=node:node --from=builder /usr/src/app/package.json ./
COPY --chown=node:node --from=builder /usr/src/app/npm-shrinkwrap.json ./

# Copy docker entrypoint script
COPY --chown=node:node docker/docker-entrypoint.sh ./docker/docker-entrypoint.sh

# Install production dependencies only
RUN npm ci --omit=dev

# Set environment variables
ENV PORT=${CC_SERVER_PORT}
ENV NODE_ENV=production

# Expose the chaincode server port
EXPOSE ${CC_SERVER_PORT}

# Switch to non-root user
USER node

# Use tini as entrypoint with docker-entrypoint.sh
ENTRYPOINT ["/tini", "--", "./docker/docker-entrypoint.sh"]
