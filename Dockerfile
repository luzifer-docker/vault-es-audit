FROM golang:alpine

ENV FILEBEAT_VERSION=v6.1.1

RUN set -ex \
 && apk --no-cache add build-base git ca-certificates \
 && mkdir -p /go/src/github.com/elastic \
 && git clone https://github.com/elastic/beats.git /go/src/github.com/elastic/beats \
 && git -C /go/src/github.com/elastic/beats fetch origin --tags \
 && git -C /go/src/github.com/elastic/beats reset --hard ${FILEBEAT_VERSION} \
 && go install -v github.com/elastic/beats/filebeat


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
