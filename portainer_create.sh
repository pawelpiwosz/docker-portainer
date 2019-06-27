#! /bin/bash

# Check current state of Portainer and volume.

portainer_volume="portainer_data"
portainer_image="portainer/portainer:latest"
portainer_name="portainer"

# Check volume. If not exist, create

docker volume ls -f name=${portainer_volume}|grep ${portainer_volume} > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo -e "\nPortainer volume ${portainer_volume} exists."
else
  docker volume create ${portainer_data}
  if [[ $? == 0 ]]; then
    echo -e "\nVolume ${portainer_volume} created.\n"
  else
    echo -e "There were some problem with volume create process!"
    exit 1
  fi
fi

# Check the image

docker images ${prtainer_image}|grep portainer > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo -e "\nPortainer image ${portainer_image} exists."
else
  docker pull ${portainer_image}
  if [[ $? == 0 ]]; then
    echo -e "\nImage ${portainer_image} pulled.\n"
  else
    echo -e "There were some problem with pulling the image!"
    exit 1
  fi
fi

# Check if container is running and can be run

docker ps -a -f name=${portainer_name}|grep -i up > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo -e "\nContainer is already running."
  exit 0
else
  docker ps -a -f name=${portainer_name}|grep -i exited > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    docker rm ${portainer_name}
    echo -e "\nContainer exists, but is not running. Removing"
  fi
  docker run -d -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart always \
    -h portainer \
    --name portainer
    portainer/portainer
  fi
