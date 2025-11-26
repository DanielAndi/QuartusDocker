#!/bin/bash
set -e

# Dynamic Quartus Detection
QUARTUS_ROOT=$(find /opt/intelFPGA_lite -maxdepth 1 -name "2*" -type d | sort -V | tail -n 1)

if [ -z "$QUARTUS_ROOT" ]; then
    echo "Quartus installation not found in /opt/intelFPGA_lite."
    echo "Looking for installer in /installer..."
    
    # Look for setup.sh or .run file
    if [ -f "/installer/setup.sh" ]; then
        echo "Found setup.sh, launching installer..."
        echo "IMPORTANT: Install to /opt/intelFPGA_lite/<version> (default)"
        /installer/setup.sh
        # Re-check for directory after install
        QUARTUS_ROOT=$(find /opt/intelFPGA_lite -maxdepth 1 -name "2*" -type d | sort -V | tail -n 1)
    elif ls /installer/Quartus-lite-*.run 1> /dev/null 2>&1; then
        INSTALLER=$(ls /installer/Quartus-lite-*.run | head -n 1)
        echo "Found run file: $INSTALLER"
        echo "Launching installer..."
        $INSTALLER
        # Re-check for directory after install
        QUARTUS_ROOT=$(find /opt/intelFPGA_lite -maxdepth 1 -name "2*" -type d | sort -V | tail -n 1)
    else
        echo "No installer found. Please mount the installer directory to /installer"
        echo "or install manually."
    fi
fi

# Setup Environment Variables
if [ -n "$QUARTUS_ROOT" ]; then
    echo "Detected Quartus at: $QUARTUS_ROOT"
    export QSYS_ROOTDIR="$QUARTUS_ROOT/quartus/sopc_builder/bin"
    export QUARTUS_ROOTDIR="$QUARTUS_ROOT/quartus"
    export PATH=$PATH:$QUARTUS_ROOT/quartus/bin:$QUARTUS_ROOT/quartus/linux64
    
    # This is CRITICAL: Add Quartus libraries to LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$QUARTUS_ROOT/quartus/linux64:$LD_LIBRARY_PATH
fi

# Check if we want to run quartus specifically
if [ "$1" = "quartus" ]; then
    # Use the wrapper script which handles even more env vars
    if [ -f "$QUARTUS_ROOTDIR/bin/quartus" ]; then
        exec "$QUARTUS_ROOTDIR/bin/quartus"
    else
        echo "Quartus binary not found. Falling back to shell."
        exec /bin/bash
    fi
fi

exec "$@"
