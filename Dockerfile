FROM rust:1-slim-bookworm AS mochi
RUN apt-get update && apt-get install -y --no-install-recommends pkg-config libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /m
COPY backend/mochi/ ./
RUN cargo build --release

FROM node:22-bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN npm install --no-audit --no-fund && npm run build
COPY --from=mochi /m/target/release/mochi /usr/local/bin/mochi
ENV NODE_ENV=production
ENV MOCHI_PORT=3005
ENV NODE_OPTIONS=--max-old-space-size=300
RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]
