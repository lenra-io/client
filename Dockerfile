FROM bitnami/nginx

ARG LENRA_SERVER_URL
ENV LENRA_SERVER_URL=${LENRA_SERVER_URL:-'http://localhost:4000'}

USER 0

RUN chown -R 1001:0 /app

USER 1001

COPY entrypoint.sh /entrypoint.sh

COPY --chown=1001:0 build/web /app

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
