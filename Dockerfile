FROM ubuntu:latest

# Set environment variables for user and home directory
ENV USER=container
ENV HOME=/home/container

# Set the working directory
WORKDIR /home/container

# Copy the entrypoint script to the container
COPY ./entrypoint.sh /entrypoint.sh

# Update and install required packages
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
        curl \
        zip \
        unzip \
        jq \
        coreutils \
        figlet \
        lolcat \
        toilet \
        wget \
        software-properties-common && \
    adduser --disabled-password --home /home/container container && \
    wget -P /usr/share/figlet/ https://raw.githubusercontent.com/xero/figlet-fonts/refs/heads/master/DOS%20Rebel.flf

# Switch to non-root user
USER container

# Set the entrypoint
CMD ["/bin/bash", "/entrypoint.sh"]