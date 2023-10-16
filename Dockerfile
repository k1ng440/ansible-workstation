FROM ubuntu:latest AS base

ARG USER=${USER}

WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirror\.limda\.net\/Ubuntu\//' /etc/apt/sources.list
RUN touch /etc/apt/apt.conf.d/99verify-peer.conf \
    && echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo curl git build-essential python3 python3-pip && \
    apt-get update && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

RUN pip install ansible

RUN useradd -m ${USER}
RUN adduser ${USER} sudo
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers
USER ${USER}
WORKDIR /home/${USER}
RUN ls -alh

CMD ["tail", "-f", "/dev/null"]
