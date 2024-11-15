#!/bin/bash

########### Proyect Variables ###########
proyect_name="self-hosted-strapi"
#########################################

########## Stopping containers ##########
echo
echo "- Stopping all running containers. Time: "`date +%H:%M:%S`
echo
docker stop $(docker ps -q) > /dev/null 2>&1 
echo -e "- Stopping complete "`date +%H:%M:%S`
echo
#########################################

########### Delete Containers ###########
if [[ $(docker ps -a -q -f "name=${proyect_name}*") ]]; then
  echo "- Deleting all containers named with prefix ${proyect_name} Time: "`date +%H:%M:%S`
  echo
  docker rm -f $(docker ps -a -q -f "name=${proyect_name}*")  > /dev/null 2>&1
fi
#########################################

############ Delete Volumes #############
if [[ $(docker volume ls -q -f "name=${proyect_name}_db-volume") ]]; then
  read -p "- ${proyect_name} db volume found, do you want to delete it? (y/n)" -n 1 -r
  echo
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "- Deleting all volumes named with prefix ${proyect_name} . Time: "`date +%H:%M:%S`
    echo
    docker volume rm -f $(docker volume ls -q -f "name=${proyect_name}*") > /dev/null 2>&1
  else
    echo "- Deleting all volumes named with prefix ${proyect_name} except ${proyect_name}_db-volume. Time: "`date +%H:%M:%S`
    echo
    docker volume rm -f $(docker volume ls -q -f "name=${proyect_name}*"| grep -v "${proyect_name}_db-volume" | cut -d ' ' -f1) > /dev/null 2>&1
  fi
else
  echo "- Deleting all volumes named with prefix ${proyect_name} . Time: "`date +%H:%M:%S`
  echo
  docker volume rm -f $(docker volume ls -q -f "name=${proyect_name}*") > /dev/null 2>&1
fi
#########################################

######## Running docker-compose #########
case "${1}" in
  "" | dev*)
    docker compose --project-name $proyect_name -f docker-compose.yml up -d --build
    ;;
  prod*)
    ;;
  *)
    echo "- Wrong argument 💀"
    ;;
esac

############################################

echo
echo "- $proyect_name docker environment complete. Time: "`date +%H:%M:%S`
echo
