#!/bin/bash

sed -i "s|\${LENRA_SERVER_URL}|${LENRA_SERVER_URL}|g" index.html

/bin/bash -c "/opt/bitnami/scripts/nginx/entrypoint.sh $@"
