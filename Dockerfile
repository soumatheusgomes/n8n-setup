FROM n8nio/n8n:latest

ENV NODE_ENV=production

USER root
RUN chmod 777 /usr/local/lib/node_modules

RUN apk update && apk add --no-cache postgresql-client && rm -rf /var/cache/apk/*

RUN set -eux; \
    apkArch="$(apk --print-arch)"; \
    if [ "$apkArch" = "armv7" ]; then \
        apk --no-cache add --virtual build-dependencies python3 build-base && \
        apk del build-dependencies; \
    fi; \
    find /usr/local/lib/node_modules/n8n -type f \( -name "*.ts" -o -name "*.js.map" -o -name "*.vue" \) -delete && \
    rm -rf /root/.npm

RUN mkdir -p /home/node/.n8n/nodes
WORKDIR /home/node/.n8n/nodes
RUN cd /home/node/.n8n/nodes
RUN npm install n8n-nodes-browserless
RUN ls -lah

# Set a custom user to not have n8n run as root
USER root
WORKDIR /data
RUN apk --no-cache add su-exec
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN chmod 777 /usr/local/lib/node_modules
RUN chmod -R 777 /home/node/.n8n/nodes
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
