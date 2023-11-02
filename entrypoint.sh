#!/bin/bash

sed -i "s|\${LENRA_SERVER_DOMAIN}|${LENRA_SERVER_DOMAIN}|g" /opt/bitnami/nginx/conf/server_blocks/nginx.conf
sed -i "s|\${LENRA_SERVER_URL}|${LENRA_SERVER_URL}|g" index.html
sed -i "s|\${SENTRY_CLIENT_DSN}|${SENTRY_CLIENT_DSN}|g" index.html
sed -i "s|\${ENVIRONMENT}|${ENVIRONMENT}|g" index.html
sed -i "s|\${OAUTH_CLIENT_ID}|${OAUTH_CLIENT_ID}|g" index.html
sed -i "s|\${OAUTH_BASE_URL}|${OAUTH_BASE_URL}|g" index.html
sed -i "s|\${OAUTH_REDIRECT_URL}|${OAUTH_REDIRECT_URL}|g" index.html

/bin/bash -c "/opt/bitnami/scripts/nginx/entrypoint.sh $@"
