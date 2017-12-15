FROM arm32v6/alpine

MAINTAINER Rom Luengwattanapong <romamp100 at gmail dot com>

# Environment variables
ENV TZ=""
ENV LANG="C"
ENV LC_ALL="C"
ENV TERM="xterm"
ENV LD_LIBRARY_PATH="/lib:/usr/lib"

# Copy the qemu-arm-static binary
COPY bin/ /usr/bin/
