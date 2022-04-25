FROM node:16-slim  AS development

RUN apt update && apt install -y ca-certificates

# Create and change to the app directory.
WORKDIR /app

# Copying this separately prevents re-running npm install on every code change.
COPY package.json package-lock.json ./
RUN npm install

# Copy local code to the container image.
COPY . .

RUN npm run build


FROM debian:stable AS tailscale

RUN apt update && apt install -y ca-certificates wget

WORKDIR /app

ENV TSFILE=tailscale_1.22.2_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
    tar xzf ${TSFILE} --strip-components=1


FROM node:16-slim  AS production

RUN apt update && apt install -y ca-certificates

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY --from=development /app/lib ./lib
COPY --from=development /app/tailscale/bootstrap /var/runtime/bootstrap
COPY --from=tailscale /app/tailscaled /var/runtime/tailscaled
COPY --from=tailscale /app/tailscale /var/runtime/tailscale
RUN mkdir -p /var/run && ln -s /tmp/tailscale /var/run/tailscale && \
    mkdir -p /var/cache && ln -s /tmp/tailscale /var/cache/tailscale && \
    mkdir -p /var/lib && ln -s /tmp/tailscale /var/lib/tailscale && \
    mkdir -p /var/task && ln -s /tmp/tailscale /var/task/tailscale


# Configure and document the service HTTP port.

ENTRYPOINT ["/var/runtime/bootstrap"]
