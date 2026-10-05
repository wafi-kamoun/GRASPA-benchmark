#!/usr/bin/env bash

# ==============================
# EDIT THESE PARAMETERS BEFORE RUNNING THE SCRIPT

ROBOT_IP=172.16.0.2
GRASP_SERVER_CONFIG=grasp_server_config.yaml
# No server 
# Set to use custom table height, otherwise default for config will be used
TABLE_HEIGHT="0.0"
# Set serial numbers of cameras
HAND_CAMERA_SERIAL=""
SETUP_CAMERA_SERIAL=""

# Use your custom image
IMAGE_NAME=ros_panda_server_lib_0.9.0

# ==============================
# DO NOT EDIT BELOW THIS LINE (unless you know what you’re doing)

# Create shared directory if it doesn't exist yet
SHARED_DIR_PATH="$PWD/shared"
MOUNT_POINT=/shared
if [[ -d "$SHARED_DIR_PATH" ]]; then
  echo "Directory $SHARED_DIR_PATH already exists"
else
  echo "Creating directory $SHARED_DIR_PATH"
  mkdir -p "$SHARED_DIR_PATH"
fi

echo "Mounting existing directory $SHARED_DIR_PATH in container path $MOUNT_POINT"

# Expose the X server on the host.
xhost +local:root

# Avoid name conflicts
CONTAINER_NAME=robot_reachability_calib
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

# --rm: Make the container ephemeral (delete on exit).
# -it: Interactive TTY.
docker run -it --rm \
  --privileged \
  --network=host \
  --name "$CONTAINER_NAME" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v "$SHARED_DIR_PATH":"$MOUNT_POINT" \
  -e DISPLAY="$DISPLAY" \
  -e RS2_USE_UVC_MEMCPY=1 \
  -e QT_X11_NO_MITSHM=1 \
  "$IMAGE_NAME" \
  /bin/bash -i -c "roslaunch panda_grasp_server GRASPA_reachability_calibration.launch \
    robot_ip:=${ROBOT_IP} \
    table_height:=${TABLE_HEIGHT} \
    grasp_server_config:=${GRASP_SERVER_CONFIG} \
    setup_camera_serial:=${SETUP_CAMERA_SERIAL} \
    hand_camera_serial:=${HAND_CAMERA_SERIAL} \
    initial_reset:=true"
# Revoke X access
xhost -local:root

echo "Changing permissions for $SHARED_DIR_PATH (if possible)"
chown -hR \"$(id -u)\":\"$(id -g)\" \"$SHARED_DIR_PATH\" 2>/dev/null || true
