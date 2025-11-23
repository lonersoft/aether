FROM ubuntu:latest

# Set environment variables for user and home directory
ENV USER=container
ENV HOME=/home/container

# Set the working directory
WORKDIR /home/container

# Copy the entrypoint script to the container
COPY ./entrypoint.sh /entrypoint.sh
COPY ./functions /functions

# Update and install required packages
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
        curl \
        zip \
        unzip \
        jq \
        coreutils \
        toilet \
        software-properties-common && \
    adduser --disabled-password --home /home/container container

# Switch to non-root user
USER container

# Set the entrypoint
CMD ["/bin/bash", "/entrypoint.sh"]