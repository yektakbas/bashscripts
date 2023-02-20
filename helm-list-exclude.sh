#!/bin/bash

# Get all deployed releases using Helm
releases=$(helm list -a --all-namespaces -o json | jq -r '.[].name')

# Loop through each release
for release in $releases; do

  # Skip releases that contain "gitlab", "drone", "k10", or "route" in the name
  if [[ $release == *"gitlab"* ]] || [[ $release == *"drone"* ]] || [[ $release == *"k10"* ]] || [[ $release == *"route"* ]]; then
    echo "Skipping release: $release"
    continue
  fi

  # Get the release namespace
  namespace=$(helm list -a --all-namespaces -o json | jq -r --arg RELEASE "$release" '.[] | select(.name==$RELEASE) | .namespace')

  # Delete the release
  echo "Deleting release: $release in namespace $namespace"
  helm delete $release -n $namespace

done
