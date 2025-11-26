FROM ubuntu:20.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
# libpng12 is often required for Quartus GUI (even 21.1 sometimes relies on older libs or plugins)
# We also install standard X11 libraries and build tools
RUN apt-get update && apt-get install -y \
    wget \
    locales \
    libglib2.0-0 \
    libfreetype6 \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    libxext6 \
    libxft2 \
    libncurses5 \
    libxml2 \
    libxtst6 \
    libxi6 \
    libxkbcommon-x11-0 \
    libxcb-xinerama0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-sync1 \
    libxcb-util1 \
    libxcb-xfixes0 \
    libx11-xcb1 \
    libdbus-1-3 \
    build-essential \
    sudo \
    libtcmalloc-minimal4 \
    && rm -rf /var/lib/apt/lists/*

# Install libpng12 manually (not in 20.04 repos)
# We extract it manually because dpkg sometimes fails with symlink issues in docker
RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
    && dpkg -x /tmp/libpng12.deb /tmp/libpng \
    && cp -r /tmp/libpng/lib/* /lib/ \
    && cp -r /tmp/libpng/usr/lib/* /usr/lib/ \
    && ldconfig \
    && rm -rf /tmp/libpng12.deb /tmp/libpng

# Generate locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create a user 'quartus' to match host user (will be overridden by run command but good to have)
# We give it sudo access for driver installation if needed inside (though usb access is via host)
RUN useradd -m -s /bin/bash quartus && echo "quartus:quartus" | chpasswd && adduser quartus sudo

# Create installation directory
RUN mkdir -p /opt/intelFPGA_lite && chown quartus:quartus /opt/intelFPGA_lite

# Set working directory
WORKDIR /home/quartus

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER quartus
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

