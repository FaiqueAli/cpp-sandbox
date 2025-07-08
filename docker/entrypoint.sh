#!/bin/bash
set -euo pipefail

# Defaults for environment variables
SSH_USER="${SSH_USER:-sshuser}"
SSH_PASSWORD="${SSH_PASSWORD:-}"

if [[ -z "$SSH_PASSWORD" ]]; then
  echo "ERROR: Environment variable SSH_PASSWORD must be set and non-empty!" >&2
  exit 1
fi

# If user does not exist, create it (handles dynamic usernames)
if ! id "$SSH_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$SSH_USER"
fi

# Set password for SSH_USER
echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# Prepare SSH directory and authorized_keys
SSH_DIR="/home/${SSH_USER}/.ssh"
mkdir -p "$SSH_DIR"
chown "$SSH_USER:$SSH_USER" "$SSH_DIR"
chmod 700 "$SSH_DIR"

# If authorized_keys exists, ensure ownership and permissions are correct
if [[ -f "$SSH_DIR/authorized_keys" ]]; then
  chown "$SSH_USER:$SSH_USER" "$SSH_DIR/authorized_keys"
  chmod 600 "$SSH_DIR/authorized_keys"
fi

# Generate SSH host keys if they do not exist (important!)
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -A
fi

echo "Starting sshd for user: $SSH_USER"

# Start sshd daemon in foreground (daemon mode -D)
exec /usr/sbin/sshd -D


###how to execute 
# docker build -t secure-ssh-minimal-linux .

# docker run -d --rm -p 2222:22   -e SSH_USER=testuser   -e SSH_PASSWORD=testpwd   --name ssh-secure   secure-ssh-container

# ssh -p 2222 testuser@localhost
# --> testpwd



#########################OBJECTIVE#########################
#########################OBJECTIVE#########################
#########################OBJECTIVE#########################

# Creates a minimal SSH server inside a Docker container.

# Allows dynamic creation of a non-root user via environment variables (MYUSER_NAME, MYUSER_PASSWORD).

# Disables root login and tightens SSH security settings (no TCP forwarding, no X11 forwarding).

# Generates SSH host keys at container start to prevent key-related errors.

# Enables password-based SSH authentication for the created user.

# Runs the SSH daemon as the container’s main process.

# Provides a secure way to access the container via SSH without using root credentials.

# Suitable for testing SSH access or running SSH-dependent services inside containers.

# Includes a health check to monitor SSH server availability.

