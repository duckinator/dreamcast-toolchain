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
      printf "\n\n. /opt/toolchains/dc/kos/environ.sh\n" >> /etc/profile && \
      bash -c make

RUN cd /opt/toolchains/dc/kos-ports && \
      ./build-all.sh
