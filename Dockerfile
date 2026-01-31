FROM debian:bookworm-slim

# Set environment variables
ENV USER=container
ENV HOME=/home/container
ENV DEBIAN_FRONTEND=noninteractive

# Create user and set working directory
RUN adduser --disabled-password --home /home/container container

WORKDIR /home/container

# Install packages (Combined and cleaned up to save space)
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
        curl \
        zip \
        unzip \
        jq \
        coreutils \
        toilet \
        ca-certificates && \ 
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Copy scripts with correct permissions for the 'container' user
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
COPY --chown=container:container ./functions /functions

# Ensure entrypoint is executable
RUN chmod +x /entrypoint.sh

USER container
ENV  USER=container HOME=/home/container

CMD ["/bin/bash", "/entrypoint.sh"]