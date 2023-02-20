#!/bin/bash

# Set the name of the image and version to check and update
IMAGE_NAME=yekta-test/testimage
VERSION_TAG=1.0.1

# Set the name of the Harbor repository to use
HARBOR_REPO=harbor.yekta.lab

# Build the Docker image
cd /root/dockerFiles/.
docker build -t $IMAGE_NAME:$VERSION_TAG .

# Check if the image with the version tag exists in the repository
if docker pull $HARBOR_REPO/$IMAGE_NAME:$VERSION_TAG > /dev/null 2>&1; then
  echo "Image with version tag $VERSION_TAG exists in repository $HARBOR_REPO"
  
  # If the image with the version tag already exists, check if there are higher tags
  LAST_DIGIT=$(echo $VERSION_TAG | awk -F. '{print $3}')
  for (( i=$LAST_DIGIT+1; ; i++ ))
  do
    NEW_VERSION_TAG=$(echo $VERSION_TAG | awk -F. '{print $1"."$2"."'$i'}')
    if docker pull $HARBOR_REPO/$IMAGE_NAME:$NEW_VERSION_TAG > /dev/null 2>&1; then
      echo "Image with version tag $NEW_VERSION_TAG already exists in repository $HARBOR_REPO"
    else
      echo "Creating new version tag $NEW_VERSION_TAG"
      docker tag $IMAGE_NAME:$VERSION_TAG $HARBOR_REPO/$IMAGE_NAME:$NEW_VERSION_TAG
      docker push $HARBOR_REPO/$IMAGE_NAME:$NEW_VERSION_TAG
      echo "New version tag $NEW_VERSION_TAG created and pushed to repository $HARBOR_REPO"
      break
    fi
  done
else
  echo "Image with version tag $VERSION_TAG is not found in repository $HARBOR_REPO"
  
  # If the image with the version tag doesn't exist, create a new tag with the same version
  echo "Creating new version tag $VERSION_TAG"
  docker tag $IMAGE_NAME:$VERSION_TAG $HARBOR_REPO/$IMAGE_NAME:$VERSION_TAG
  docker push $HARBOR_REPO/$IMAGE_NAME:$VERSION_TAG
  echo "New version tag $VERSION_TAG created and pushed to repository $HARBOR_REPO"
fi
