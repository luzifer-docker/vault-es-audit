#!/bin/sh

[ -e /config/filebeat.yml ] && cp /config/filebeat.yml /opt/filebeat/filebeat.yml

# filebeat refuses to work if config is writable for others than owner
chmod 644 /opt/filebeat/filebeat.yml

exec /opt/filebeat/filebeat "$@"
