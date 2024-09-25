#!/bin/bash

REGION="us-west-2"

# Step 1: Get all repositories starting with 'reponamespace/'
repos=$(aws ecr describe-repositories --region $REGION --query 'repositories[?starts_with(repositoryName, `reponamespace/`)].repositoryName' --output text)

# Check if any repositories were found
if [ -z "$repos" ]; then
    echo "No repositories found with prefix 'reponamespace/'"
    exit 1
fi

# Step 2: Iterate over each repository
for repo in $repos; do
    echo "Processing repository: $repo"

    # Step 3: List all image digests in the repository
    images=$(aws ecr list-images --repository-name $repo --region $REGION --query 'imageIds[*].imageDigest' --output text)

    if [ -z "$images" ]; then
        echo "No images found in repository: $repo"
        continue
    fi

    # Create a directory to store scan results for this repository
    mkdir -p "scan_results/$repo"

    for digest in $images; do
        echo "Fetching scan findings for image: $digest"

        # Step 4: Get the scan findings for each image
        scan_result=$(aws ecr describe-image-scan-findings --repository-name $repo --image-id imageDigest=$digest --region $REGION --output json)

        # Step 5: Save the result to a file
        echo $scan_result | jq '.' > "scan_results/$repo/${digest}_scan_findings.json"
        echo "Scan findings saved to scan_results/$repo/${digest}_scan_findings.json"
    done
done
