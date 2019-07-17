FROM debian:10-slim

RUN apt-get -y update && \
      apt-get -y install libgmp-dev libmpfr-dev libmpc-dev gettext wget libelf-dev texinfo bison flex sed make tar bzip2 patch gawk git gcc g++ xz-utils curl && \
      apt-get -y install libpng-dev libjpeg62-turbo-dev && \
      apt-get -y install genisoimage wodim && \
    mkdir -p /opt/toolchains/dc

RUN cd /opt/toolchains/dc && \
      git clone --depth=1 git://git.code.sf.net/p/cadcdev/kallistios kos && \
      git clone --depth=1 git://git.code.sf.net/p/cadcdev/kos-ports && \
    cd kos-ports && \
      git submodule update --init

RUN cd /opt/toolchains/dc/kos/utils/dc-chain && \
      ./download.sh --no-deps && ./unpack.sh --no-deps && make

RUN cd /opt/toolchains/dc/kos && \
      cp doc/environ.sh.sample ./environ.sh && \
      printf "\n\n. /opt/toolchains/dc/kos/environ.sh\n" >> /etc/profile

ENV BASH_ENV /opt/toolchains/dc/kos/environ.sh

RUN cd /opt/toolchains/dc/kos && \
      bash -c make

RUN cd /opt/toolchains/dc/kos-ports/utils && \
      ./build-all.sh

# Everything after this point is to set up fixuid, so files don't wind up
# owned by the wrong user.
# https://boxboat.com/2017/07/25/fixuid-change-docker-container-uid-gid/

# creates user "docker" with UID 1000, home directory /home/docker, and shell /bin/sh
# creates group "docker" with GID 1000
RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/bash --disabled-password --gecos "" docker

# install fixuid and configure it
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.1/fixuid-0.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# We make everything run via bash, which means it sources /etc/profile,
# which means it sources /opt/toolchains/dc/kos/environ.sh.
RUN printf "eval \$(/usr/local/bin/fixuid) && \"\$@\"\n" > /opt/entrypoint.sh

USER docker:docker

ENTRYPOINT ["bash", "/opt/entrypoint.sh"]
