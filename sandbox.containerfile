FROM debian:12

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dbus-x11 \
    weston \
    xterm \
    sudo \
    firefox-esr \
    pcmanfm \
    fonts-noto-cjk --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

ARG USER=user
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $USER && \
    useradd -m -u $UID -g $GID -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

ENV SHELL=/bin/bash \
    WAYLAND_DISPLAY=wayland-1 \
    MOZ_ENABLE_WAYLAND=1 \
    HOME=/home/$USER \
    DISPLAY=
    
ENTRYPOINT ["weston", "--fullscreen"]
