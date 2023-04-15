FROM n8nio/n8n:latest

ENV NODE_ENV=production

RUN chmod 777 /usr/local/lib/node_modules

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
	'armv7') apk --no-cache add --virtual build-dependencies python3 build-base;; \
	esac && \
	npm install -g --omit=dev npm n8n n8n-nodes-browserless && \
	case "$apkArch" in \
	'armv7') apk del build-dependencies;; \
	esac && \
	find /usr/local/lib/node_modules/n8n -type f -name "*.ts" -o -name "*.js.map" -o -name "*.vue" | xargs rm && \
	rm -rf /root/.npm

# Set a custom user to not have n8n run as root
USER root
WORKDIR /data
RUN apk --no-cache add su-exec
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN chmod 777 /usr/local/lib/node_modules
RUN chmod -R 777 /usr/local/lib/node_modules/n8n-nodes-browserless
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
