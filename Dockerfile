FROM golang:alpine

ENV FILEBEAT_VERSION=v7.11.1

RUN set -ex \
 && apk --no-cache add \
      build-base \
      git \
      ca-certificates \
 && mkdir -p /go/src/github.com/elastic \
 && git clone -b ${FILEBEAT_VERSION} \
      https://github.com/elastic/beats.git \
      /go/src/github.com/elastic/beats \
 && cd /go/src/github.com/elastic/beats/filebeat \
 && go install -mod=readonly


FROM alpine

LABEL maintainer Knut Ahlers <knut@ahlers.me>

RUN set -ex \
 && apk --no-cache add ca-certificates

COPY --from=0 /go/bin/filebeat /opt/filebeat/filebeat

ADD fields.yml /opt/filebeat/
ADD filebeat.yml /opt/filebeat/
ADD start.sh /opt/filebeat/

WORKDIR /opt/filebeat

VOLUME ["/var/log/vault", "/config"]

ENTRYPOINT ["sh", "/opt/filebeat/start.sh"]
CMD ["--"]
