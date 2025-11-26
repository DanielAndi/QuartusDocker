# Quartus Docker Environment for DE10-Standard

This project facilitates the operation of the DE10-Standard board using Quartus Prime software deployed within a Docker container. This approach ensures a consistent, isolated environment (Ubuntu 20.04) for FPGA development and interaction.

## Overview

- **Target Board**: DE10-Standard
- **FPGA Device**: Cyclone V (5CSXFC6D6)
- **Software**: Quartus Prime (Lite Edition)
- **Environment**: Ubuntu 20.04 Docker Container

## System Architecture

To operate the DE10-Standard board, we deployed the Quartus Prime software within a Docker container. The setup requires specific configurations to ensure hardware access and GUI functionality:

- **Privileged Access**: The container runs with `--privileged` to ensure it has the necessary permissions to access hardware devices.
- **USB Mapping**: The USB bus is mapped into the container (`-v /dev/bus/usb:/dev/bus/usb`). This allows the container to interface directly with the USB-Blaster II JTAG cable connected to the host.
- **X11 Forwarding**: X11 forwarding is configured to enable the Graphical User Interface (GUI) of Quartus Prime to run inside the container while being displayed on the host machine.

## Workflow

1.  **Launch Container**: Use the provided scripts (e.g., `quartus-docker/run.sh`) to start the environment.
2.  **Target Device**: Inside Quartus, target the specific Cyclone V FPGA device: `5CSXFC6D6`.
3.  **Program FPGA**: Program the device with the Hardware Reference Design (`.sof` file).
4.  **HPS Interaction**: Interacting with the HPS (Hard Processor System) involves:
    -   Executing a cross-compiled user-space application (e.g., `HPS_FPGA_LED`) on the ARM core.
    -   This application communicates with the FPGA fabric to drive peripherals like LEDs.

## Usage

Scripts are located in the `quartus-docker` directory.

To run the container:
```bash
cd quartus-docker
./run.sh
```

