FROM debian:10-slim

RUN apt-get -y update && \
      apt-get -y install libgmp-dev libmpfr-dev libmpc-dev gettext wget libelf-dev texinfo bison flex sed make tar bzip2 patch gawk git gcc g++ xz && \
      apt-get -y install libpng-dev libjpeg62-turbo-dev && \
      apt-get -y install genisoimage wodim
