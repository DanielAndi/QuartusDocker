#!/bin/bash

# Path to the installer files (relative to this script)
INSTALLER_DIR="$(pwd)/installer"
# Path where Quartus will be installed (persistent volume)
INSTALL_DIR="$(pwd)/quartus_data"

mkdir -p "$INSTALL_DIR"

# Allow X11 access (check if xhost exists first)
if command -v xhost &> /dev/null; then
    xhost +local:docker
else
    echo "Warning: xhost not found. GUI might not work if not already configured."
fi

echo "Starting Quartus Container..."
echo "If this is the first run, the installer will launch."
echo "Make sure to install to: /opt/intelFPGA_lite/<version>"

# Force libxcb usage if needed or fix potential QT issues
docker run -it --rm \
    --privileged \
    --security-opt seccomp=unconfined \
    --net=host \
    -e DISPLAY=$DISPLAY \
    -e QT_DEBUG_PLUGINS=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$INSTALLER_DIR":/installer \
    -v "$INSTALL_DIR":/opt/intelFPGA_lite \
    -v /dev/bus/usb:/dev/bus/usb \
    quartus-lite:21.1 \
    /bin/bash -c "rm -f /opt/intelFPGA_lite/*/quartus/linux64/libstdc++.so.6; /usr/local/bin/entrypoint.sh quartus"
