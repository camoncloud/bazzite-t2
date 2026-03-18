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

RUN echo "=== LISTADO /tmp ===" && \
    ls -la /tmp && \
    echo "=== LISTADO apple-bce-drv ===" && \
    ls -la /tmp/apple-bce-drv || true && \
    echo "=== FIND apple-bce-drv ===" && \
    find /tmp/apple-bce-drv -maxdepth 3 -type f || true && \
    test -f /tmp/apple-bce-drv/Makefile

RUN cd /tmp/apple-bce-drv && make
