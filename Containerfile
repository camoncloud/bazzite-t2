FROM ghcr.io/ublue-os/bazzite:stable

# Dependencias de compilacion
RUN dnf install -y \
    gcc \
    make \
    kernel-devel \
    git \
    && dnf clean all

# Copiar codigo fuente del driver
COPY apple-bce-drv /tmp/apple-bce-drv

# Compilar el modulo
RUN cd /tmp/apple-bce-drv && \
    make

# Copiar el modulo compilado a una ruta persistente dentro de la imagen
RUN mkdir -p /usr/lib/modules-extra && \
    cp /tmp/apple-bce-drv/apple-bce.ko /usr/lib/modules-extra/apple-bce.ko

# Servicio para cargar el modulo al arrancar
RUN mkdir -p /usr/lib/systemd/system && \
    printf '%s\n' \
    '[Unit]' \
    'Description=Load Apple BCE module' \
    'After=systemd-modules-load.service' \
    '' \
    '[Service]' \
    'Type=oneshot' \
    'ExecStart=/usr/sbin/insmod /usr/lib/modules-extra/apple-bce.ko' \
    'RemainAfterExit=yes' \
    '' \
    '[Install]' \
    'WantedBy=multi-user.target' \
    > /usr/lib/systemd/system/apple-bce.service

RUN systemctl enable apple-bce.service
