FROM alpine:latest
MAINTAINER Xueshan Feng <xueshan.feng@gmail.com>
MAINTAINER Luke Bond <luke.n.bond@gmail.com>

ENV VERSION 0.6.0-1

RUN apk --update add \
   bash \
   curl \
   git \
   g++ \
   gnupg \
   make \
   openssh \
   openssl \
   openssl-dev \
   && rm -rf /var/cache/apk/*

RUN curl -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp
RUN cd /var/tmp/git-crypt-debian-$VERSION && make && make install PREFIX=/usr/local && rm -rf /var/tmp/git-crypt-debian-$VERSION

RUN adduser -D -g '' gitcrypt
USER gitcrypt

WORKDIR /repo
VOLUME /repo
VOLUME /home/gitcrypt
ENTRYPOINT ["/usr/local/bin/git-crypt"]

ARG BUILDDATE
ARG VCSREF
ARG VERSION

ENV BUILDDATE ${BUILDDATE}
ENV VCSREF ${VCSREF}
ENV VERSION ${VERSION}

LABEL \
  org.label-schema.name="git-crypt" \
  org.label-schema.description="git-crypt in a Docker container, making it easy to install without worrying about old openssl deps etc." \
  org.label-schema.usage="https://github.com/lukebond/docker-git-crypt/README.md" \
  org.label-schema.vcs-url="https://github.com/lukebond/docker-git-crypt" \
  org.label-schema.vcs-ref="${VCSREF}" \
  org.label-schema.build-date="${BUILDDATE}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.docker.schema-version="1.0" \
  org.label-schema.docker.cmd="docker run -it -rm --name git-crypt -v ${HOME}/.gnupg:/home/gitcrypt/.gnupg -v "$(pwd):/repo" quay.io/lukebond/git-crypt:v1.0.0 status"
