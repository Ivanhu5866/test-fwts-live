FROM ubuntu:jammy
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy-security main universe" >> /etc/apt/sources.list
RUN apt update && apt -y install build-essential ubuntu-image && apt-get -y build-dep livecd-rootfs
COPY pc-amd64-gadget/prime /pc-amd64-gadget/prime
COPY fwts-livecd-rootfs /fwts-livecd-rootfs
RUN cd /fwts-livecd-rootfs && debian/rules binary && \
    dpkg -i /livecd-rootfs_*_amd64.deb
VOLUME /image
ENTRYPOINT ubuntu-image classic -a amd64 -d -p ubuntu-cpc -s noble -i 850M -O /image \
    --extra-ppas firmware-testing-team/ppa-fwts-stable /pc-amd64-gadget/prime && \
    xz /image/pc.img
