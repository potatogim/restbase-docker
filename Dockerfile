FROM node:latest
MAINTAINER Ji-Hyeon Gim <potatogim@potatogim.net>

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

EXPOSE 7231

RUN git clone https://github.com/wikimedia/restbase.git
RUN cd restbase && npm install && cp config.example.yaml config.yaml
RUN useradd --home=/var/lib/restbase -M --user-group --system --shell=/usr/sbin/nologin -c "RESTBase for MediaWiki" restbase
RUN mkdir -p /var/lib/restbase
RUN chown restbase:restbase /var/lib/restbase
RUN mv restbase /usr/local/lib/restbase
RUN chown -R root.root /usr/local/lib/restbase

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /usr/local/lib/restbase

CMD /usr/local/bin/node /usr/local/lib/restbase/server.js
