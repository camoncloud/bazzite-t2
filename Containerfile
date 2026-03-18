FROM ghcr.io/ublue-os/bazzite:stable

# instalar herramientas necesarias (sin romper kernel)
RUN dnf install -y \
    gcc \
    make \
    git \
    kernel-devel \
    kernel-headers \
    --setopt=install_weak_deps=False \
    --skip-broken \
    && dnf clean all

# copiar driver
COPY apple-bce-drv /tmp/apple-bce-drv

# debug + compilacion
RUN uname -r && \
    ls -d /usr/src/kernels/* || true && \
    ls -la /tmp/apple-bce-drv && \
    cd /tmp/apple-bce-drv && \
    make || (echo "MAKE FAILED" && exit 1)

# copiar modulo (solo si existe)
RUN mkdir -p /usr/lib/modules-extra && \
    if [ -f /tmp/apple-bce-drv/apple-bce.ko ]; then \
        cp /tmp/apple-bce-drv/apple-bce.ko /usr/lib/modules-extra/; \
    else \
        echo "Module not built"; exit 1; \
    fi

# cargar modulo automaticamente (forma correcta)
RUN mkdir -p /usr/lib/modules-load.d && \
    echo apple_bce > /usr/lib/modules-load.d/apple-bce.conf
