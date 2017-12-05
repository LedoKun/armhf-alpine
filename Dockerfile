FROM arm32v6/alpine:3.6

MAINTAINER Rom Luengwattanapong <romamp100 at gmail dot com>

# Environment variables
ENV TZ=""
ENV LANG="C"
ENV LC_ALL="C"
ENV TERM="xterm"
ENV LD_LIBRARY_PATH="/lib:/usr/lib"

# Copy the qemu-arm-static binary
COPY bin/ /usr/bin/

# Build the image on Dockerhub
RUN [ "cross-build-start" ]

RUN apk add --update --no-cache openrc \
 && rm -rf /var/cache/apk/**

# Tell openrc its running inside a container, till now that has meant LXC
RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf \
# Tell openrc loopback and net are already there, since docker handles the networking
 && echo 'rc_provide="loopback net"' >> /etc/rc.conf \
# Allow passing of environment variables for init scripts
 && echo 'rc_env_allow="*"' >> /etc/rc.conf \
# no need for loggers
 && sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf \
# remove sysvinit runlevels
 && sed -i '/::sysinit:/d' /etc/inittab \
# can't get ttys unless you run the container in privileged mode
 && sed -i '/tty/d' /etc/inittab \
# can't set hostname since docker sets it
 && sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname \
# can't mount tmpfs since not privileged
 && sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh \
# can't do cgroups
 && sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh

RUN [ "cross-build-end" ]

WORKDIR /

ENTRYPOINT ["/sbin/init"]