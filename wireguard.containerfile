FROM debian:12

RUN apt-get update -y && \
    apt-get install -y wireguard-tools openssh-server iproute2 openresolv xxd iptables-persistent --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -A && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed -i 's/sysctl -q net.ipv4.conf.all.src_valid_mark=1/echo sysctl -q net.ipv4.conf.all.src_valid_mark=1/g' /usr/bin/wg-quick

RUN cat <<'EOF' >/entrypoint.sh
#!/bin/bash

set -e

A=$(head -c 4 /dev/urandom | xxd -p)

if [ $(sysctl net.ipv4.conf.all.src_valid_mark -n) -ne 1 ]; then
  echo You need to enable net.ipv4.conf.all.src_valid_mark
  exit;
fi

if [ ! -f "/wg0.conf" ]; then
  echo No config found at /wg0.conf
  exit;
fi

cp /wg0.conf /etc/wireguard/$A.conf
chmod 600 /etc/wireguard/$A.conf
echo $A
wg-quick up $A

mkdir /run/sshd
/usr/sbin/sshd

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
ssh-keyscan localhost >> ~/.ssh/known_hosts
chmod 600 ~/.ssh/authorized_keys ~/.ssh/known_hosts

PORT=${PORT:-8099}
echo Starting SSH SOCKS server on port ${PORT}...
ssh root@localhost -NvD 0.0.0.0:${PORT}
EOF

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
