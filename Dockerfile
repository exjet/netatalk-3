FROM ubuntu:16.04
MAINTAINER ExPrime <executorj@gmail.com>

RUN apt update && \
    apt install -y \
      git \
      build-essential \
      libevent-dev \
      libssl-dev \
      libgcrypt11-dev \
      libkrb5-dev \
      libpam0g-dev \
      libwrap0-dev \
      libdb-dev \
      libtdb-dev \
      libmysqlclient-dev \
      avahi-daemon \
      libavahi-client-dev \
      libacl1-dev \
      libldap2-dev \
      libcrack2-dev \
      systemtap-sdt-dev \
      libdbus-1-dev \
      libdbus-glib-1-dev \
      libglib2.0-dev \
      tracker \
      libtracker-sparql-1.0-dev \
      libtracker-miner-1.0-dev \
      wget \
      checkinstall && \ 
      apt clean && \
    mkdir -p /netatalk && \
    mkdir /Volumes && \
    NETATALK_VERSION="3.1.8" && \
    cd /netatalk && \
    wget https://sourceforge.net/projects/netatalk/files/netatalk/$NETATALK_VERSION/netatalk-$NETATALK_VERSION.tar.gz && \
    tar -xvf netatalk-$NETATALK_VERSION.tar.gz && \
    cd netatalk-$NETATALK_VERSION && \
    ./configure \
        --with-init-style=debian-systemd \
        --without-libevent \
        --without-tdb \
        --with-cracklib \
        --enable-krbV-uam \
        --with-pam-confdir=/etc/pam.d \
        --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
        --with-tracker-pkgconfig-version=1.0 && \
        make && \
        make install && \
        rm -rf /netatalk

EXPOSE 548 636 5353/udp
COPY afp.conf /usr/local/etc/afp.conf
CMD ["/usr/local/sbin/afpd", "-d"]