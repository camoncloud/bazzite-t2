FROM ghcr.io/ublue-os/bazzite:stable

RUN dnf install -y \
    gcc \
    make \
    git \
    kernel-devel \
    kernel-headers \
    --setopt=install_weak_deps=False \
    --skip-broken \
    && dnf clean all

COPY apple-bce-drv /tmp/apple-bce-drv

RUN echo "=== kernels ===" && \
    find /usr/src/kernels -mindepth 1 -maxdepth 1 -type d

RUN KDIR=$(find /usr/src/kernels -mindepth 1 -maxdepth 1 -type d | head -n 1) && \
    echo "Using kernel dir: $KDIR" && \
    make -C "$KDIR" M=/tmp/apple-bce-drv modules

RUN mkdir -p /usr/lib/modules-extra && \
    cp /tmp/apple-bce-drv/*.ko /usr/lib/modules-extra/

RUN mkdir -p /usr/lib/modules-load.d && \
    echo apple_bce > /usr/lib/modules-load.d/apple-bce.conf
