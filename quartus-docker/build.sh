#!/bin/bash

# Get current user ID to map into container
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Build the image
docker build -t quartus-lite:21.1 .

echo "Build complete."
echo "To run the container and install Quartus:"
echo "1. Place your Quartus-lite-*.tar (extracted) or *.run file in the 'installer' subdirectory."
echo "2. Run: ./run_quartus.sh"

