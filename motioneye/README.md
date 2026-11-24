# motioneye

This project provides a Docker-based deployment for **motionEye**, an open-source camera surveillance system. It automates the building and running of the motionEye container with proper volume mappings and network configurations.

## Project Structure

- `build.sh`: Handles cloning the official repository, updating to the latest version, and building the Docker image.
- `run.sh`: Handles environment preparation (creating local folders), cleaning up old containers, and launching the motionEye container.

## Technical Details

### Build Process (`build.sh`)
The build script ensures that the latest motionEye code is used by:
1. **Cloning/Updating**: It maintains a local copy of the motionEye repository in `/tmp/motioneye_git/`.
2. **Build Arguments**: It passes the current user's UID and GID as build arguments (`RUN_UID`, `RUN_GID`) to ensure that files created by the container have the correct permissions on the host.
3. **Network**: The build process utilizes the host network to ensure all required resources are accessible during the construction phase.

### Deployment Process (`run.sh`)
The run script automates the deployment with the following specifications:
- **Persistence**: 
    - Config files are mapped to `~/motioneye/config` (mapped to `/etc/motioneye` inside the container).
    - Video recordings are mapped to `~/motioneye/videos` (mapped to `/var/lib/motioneye` inside the container).
- **Networking**: The web interface is exposed on port `8765`.
- **System Sync**: The `/etc/localtime` file is mounted as read-only to synchronize the container's time with the host system.
- **Reliability**: The container is configured with a `restart: always` policy.

## Setup & Usage

### Prerequisites
- Docker installed and running.
- Git installed.

### Instructions

There are two ways to run the container:

#### Method 1: Using the provided scripts (Recommended)
These scripts automatically handle repository management and local directory setup.
1. **Build the Image**:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
2. **Run the Container**:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

#### Method 2: Using Docker Compose
Use this method if you prefer standard Docker Compose commands (requires the image to be built first via `./build.sh`).
1. **Build the Image**:
   ```bash
   ./build.sh
   ```
2. **Start the Container**:
   ```bash
   docker compose up -d
   ```

#### Access the Web UI
Open your browser and navigate to:
`http://<your-host-ip>:8765`
