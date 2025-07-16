# Builder stage: install required packages and create user
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server=1:8.9p1-3ubuntu0.5 \
    sudo=1.9.9-1ubuntu2.4 \
    passwd=1:4.11.1+dfsg1-2ubuntu2.3 \
    netcat-openbsd=1.218-4build1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Create a placeholder user (actual username and password set at runtime)
RUN useradd -m -s /bin/bash sshuser && \
    echo "sshuser:placeholder" > /tmp/pass && \
    chpasswd < /tmp/pass && \
    rm /tmp/pass


# Configure SSH server
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config

# Copy entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chown sshuser:sshuser /entrypoint.sh && chmod 500 /entrypoint.sh

# Final runtime stage: slim image with minimal packages
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server=1:8.9p1-3ubuntu0.5 \
    sudo=1.9.9-1ubuntu2.4 \
    passwd=1:4.11.1+dfsg1-2ubuntu2.3 \
    netcat-openbsd=1.218-4build1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY --from=builder /etc/ssh/sshd_config /etc/ssh/sshd_config
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/shadow /etc/shadow
COPY --from=builder /entrypoint.sh /entrypoint.sh

RUN chmod 550 /entrypoint.sh && \
    mkdir -p /run/sshd /home/sshuser && \
    chown sshuser:sshuser /home/sshuser

# Expose SSH port
EXPOSE 22

# Healthcheck on SSH port
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD nc -z 127.0.0.1 22 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
