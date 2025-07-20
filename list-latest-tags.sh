#!/bin/bash

REGION="us-west-2"
PREFIX="vinoth/k8s/v4"

# Get all repositories with the specified prefix
repos=$(aws ecr describe-repositories \
  --region "$REGION" \
  --query "repositories[?starts_with(repositoryName, \`$PREFIX\`)].repositoryName" \
  --output text)

# Loop through each repository and get the latest tag
for repo in $repos; do
  latest_tag=$(aws ecr describe-images \
    --region "$REGION" \
    --repository-name "$repo" \
    --query "sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]" \
    --output text)

  if [[ "$latest_tag" == "None" || -z "$latest_tag" ]]; then
    echo "$repo: (no tag found)"
  else
    echo "$repo: $latest_tag"
  fi
done
