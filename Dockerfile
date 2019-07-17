FROM debian:10-slim

RUN apt-get -y update && \
      apt-get -y install libgmp-dev libmpfr-dev libmpc-dev gettext wget libelf-dev texinfo bison flex sed make tar bzip2 patch gawk git gcc g++ xz-utils && \
      apt-get -y install libpng-dev libjpeg62-turbo-dev && \
      apt-get -y install genisoimage wodim && \
    mkdir -p /opt/toolchains/ && \
    printf "\n\n. /opt/toolchains/dc/kos/environ.sh\n" >> /etc/profile

COPY toolchain-setup.sh /opt/toolchains/setup.sh

RUN /opt/toolchains/setup.sh
