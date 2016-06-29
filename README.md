# netatalk-3
This builds a netatalk-3.1.8 container.

The included afp.conf is for reference.

The container is built with a directory at /Volumes that is assumed to be where the mountpoint for the shares will be, but really iy can be anywhere you would like it to be as long as you point the afp.conf to it.
The build of the netatalk package assumes that the afp.conf file will reside at /usr/local/etc/afp.conf. There is a simlink in place to a placeholder file in /usr/local/etc/afpconf. This should be overrided via docker volumes to a directory on your host that contains your afp.conf

A very simple example would be as follows:

docker run -p 548:548 -p 636:636 -p 5353:5353 -v /someDir:/Volumes -v /path/to/afpconf-dir:/usr/local/etc/afpconf