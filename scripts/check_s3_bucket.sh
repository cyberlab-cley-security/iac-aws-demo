#!/bin/bash

# Arguments
NAME_PREFIX=$1
ACTOR_PREFIX=$2
REGION=$3
TF_DIR=$4   # Chemin vers le module Terraform bucket_s3

bucket_name="${NAME_PREFIX}-${ACTOR_PREFIX}-s3-tfstate"

# Check if the bucket exists
if aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
    echo "The bucket '$bucket_name' exists."
    echo "No need to create it, it will be used to store infrastructure tfstate."
else
    echo "The bucket '$bucket_name' does not exist."
    echo "'$bucket_name' Bucket S3 creation in progress..."

    # Init and apply Terraform in the correct directory
    terraform -chdir="$TF_DIR" init
    terraform -chdir="$TF_DIR" apply \
        -var="name_prefix=$NAME_PREFIX" \
        -var="actor=$ACTOR_PREFIX" \
        -var="region=$REGION" \
        -auto-approve
fi
