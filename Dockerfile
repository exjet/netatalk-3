FROM ubuntu:16.04
MAINTAINER ExPrime <executorj@gmail.com>
COPY netatalk-3.1.9.tar.gz /netatalk/
COPY libgcrypt11_1.5.3-2ubuntu4.2_i386.deb /checkdeps/
COPY afpfs-ng_0.8.1-1_i386.deb /checkdeps/
COPY healthcheck.sh /health/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN set -x && \
     DEBIAN_FRONTEND="noninteractive" && \
    echo -e " \
    ldap-auth-config    ldap-auth-config/binddn    string    cn=proxyuser,dc=yourdomain,dc=com \n\
    ldap-auth-config    ldap-auth-config/bindpw    password \n    \
    ldap-auth-config    ldap-auth-config/dblogin    boolean    false \n\
    ldap-auth-config    ldap-auth-config/dbrootlogin    boolean    true \n\
    ldap-auth-config    ldap-auth-config/ldapns/base-dn    string    dc=yourdomain,dc=com \n\
    ldap-auth-config    ldap-auth-config/ldapns/ldap-server    string    ldap://10.10.10.10/ \n\
    ldap-auth-config    ldap-auth-config/ldapns/ldap_version    select    3 \n\
    ldap-auth-config    ldap-auth-config/move-to-debconf    boolean    true \n\
    ldap-auth-config    ldap-auth-config/override    boolean    true \n\
    ldap-auth-config    ldap-auth-config/pam_password    select    crypt \n\
    ldap-auth-config    ldap-auth-config/rootbinddn    string    cn=manager,dc=yourdomain,dc=com \n\
    ldap-auth-config    ldap-auth-config/rootbindpw    password    \n\
    libnss-ldap    libnss-ldap/binddn    string    cn=proxyuser,dc=yourdomain,dc=com \n\
    libnss-ldap    libnss-ldap/bindpw    password    \n\
    libnss-ldap    libnss-ldap/confperm    boolean    false \n\
    libnss-ldap    libnss-ldap/dblogin    boolean    false \n\
    libnss-ldap    libnss-ldap/dbrootlogin    boolean    true \n\
    libnss-ldap    libnss-ldap/nsswitch    note    \n\
    libnss-ldap    libnss-ldap/override    boolean    true \n\
    libnss-ldap    libnss-ldap/rootbinddn    string    cn=manager,dc=yourdomain,dc=com \n\
    libnss-ldap    libnss-ldap/rootbindpw    password    \n\
    libnss-ldap    shared/ldapns/base-dn    string    dc=yourdomain,dc=com \n\
    libnss-ldap    shared/ldapns/ldap-server    string    ldap://10.10.10.10/ \n\
    libnss-ldap    shared/ldapns/ldap_version    select    3 \n\
    libpam-ldap    libpam-ldap/binddn    string    cn=proxyuser,dc=yourdomain,dc=com \n\
    libpam-ldap    libpam-ldap/bindpw    password    \n\
    libpam-ldap    libpam-ldap/dblogin    boolean    false \n\
    libpam-ldap    libpam-ldap/dbrootlogin    boolean    false \n\
    libpam-ldap    libpam-ldap/override    boolean    true \n\
    libpam-ldap    libpam-ldap/pam_password    select    crypt \n\
    libpam-ldap    libpam-ldap/rootbinddn    string    cn=manager,dc=yourdomain,dc=com \n\
    libpam-ldap    libpam-ldap/rootbindpw    password    \n\
    libpam-ldap    shared/ldapns/base-dn    string    dc=yourdomain,dc=com \n\
    libpam-ldap    shared/ldapns/ldap-server    string    ldap://10.10.10.10/ \n\
    libpam-ldap    shared/ldapns/ldap_version    select    3 \n\
    libpam-runtime    libpam-runtime/profiles    multiselect    unix, ldap \n\
    " | debconf-set-selections && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get --quiet --yes install -qq --no-install-recommends \
      git \
      libpam-ldap \
      libnss-ldap \
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
      libgpg-error0:i386 \
      libfuse2:i386 \
      libc6:i386 \
      libncurses5:i386 \
      libreadline5:i386 \
      libtracker-sparql-1.0-dev \
      libtracker-miner-1.0-dev \
      wget \
      supervisor \
      checkinstall && \ 
      apt-get clean && \
    mkdir -p /etc/hostetc && \
    touch /etc/hostetc/nsswitch.conf && \
    touch /etc/hostetc/ldap.conf && \
    rm /etc/nsswitch.conf && \
    rm /etc/ldap.conf && \
    ln -s /etc/hostetc/ldap.conf /etc/ldap.conf && \
    ln -s /etc/hostetc/nsswitch.conf  /etc/nsswitch.conf && \
    touch /etc/hostetc/afp.conf && \
    ln -s /etc/hostetc/afp.conf /usr/local/etc/afp.conf && \
    mkdir /Volumes && \
    NETATALK_VERSION="3.1.9" && \
    cd /netatalk && \
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
RUN dpkg -i /checkdeps/libgcrypt11_1.5.3-2ubuntu4.2_i386.deb && \
    dpkg -i /checkdeps/afpfs-ng_0.8.1-1_i386.deb && \
    chmod 666 /dev/fuse
EXPOSE 548 636 5353/udp
CMD ["/usr/bin/supervisord"]
