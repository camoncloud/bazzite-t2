FROM ghcr.io/ublue-os/bazzite:latest

# dependencias para compilar
RUN rpm-ostree install \
    kernel-devel \
    gcc \
    make \
    git

# copiar driver
COPY apple-bce-drv /tmp/apple-bce

# compilar driver
RUN cd /tmp/apple-bce && \
    make && \
    mkdir -p /usr/lib/modules-extra && \
    cp apple-bce.ko /usr/lib/modules-extra/

# cargar módulo en arranque
RUN echo apple_bce > /usr/lib/modules-load.d/apple-t2.conf
