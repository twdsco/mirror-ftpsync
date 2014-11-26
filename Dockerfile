FROM       debian:stable
MAINTAINER Paul Tagliamonte <paultag@debian.org>

RUN apt-get update && apt-get install -y \
    adduser \
    git \
    rsync

RUN adduser \
    --system \
    --home=/opt/ftp-master.debian.org/archvsync/ \
    --shell=/bin/bash \
    --no-create-home \
    --group \
    archvsync

RUN mkdir -p /opt/ftp-master.debian.org/
WORKDIR /opt/ftp-master.debian.org/
RUN git clone https://ftp-master.debian.org/git/archvsync.git/
RUN chown -R archvsync:archvsync ./archvsync
WORKDIR /opt/ftp-master.debian.org/archvsync/

ENV PATH /opt/ftp-master.debian.org/archvsync/bin:${PATH}

CMD ["ftpsync"]
