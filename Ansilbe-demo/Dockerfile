FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    make \
    g++ \
    build-essential \
    && mkdir /var/run/sshd \
    && useradd -ms /bin/bash ansible \
    && echo 'ansible:ansible' | chpasswd \
    && adduser ansible sudo \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
