#! /bin/bash

version="${1:-dev}"
ci_user="central_ci"
imgrepo="imyob-docker-public.jfrog.op/ops-ecs-service"

log() { echo "$(date '+%Y-%m-%dT%H:%M:%S') $*"; }

die () {
  echo "FATAL: $*" >&2
  exit 1
}

log "Building Docker image"
docker build -t "$imgrepo:$version" . || die "Unable to build Docker image"

[[ "$version" == "dev" ]] && exit 0

log "Logging in to Artifactory as \"$ci_user\""
docker login -u "$ci_user" \
    -p "$(aws s3 cp --sse aws:kms s3://myob-jfrog-api-keys/$ci_user/APIKEY -)" \
    imyob-docker-public.jfrog.io \
    || die "Unable to log in to Artifactory as \"$ci_user\""

log "Pushing Docker image to Artifactory"
docker push "imyob-docker-public.jfrog.io/ops-ecs-service:$version" \
    || die "Unable to push image to Artifactory"

log "Docker image successfully pushed to: $imgrepo:$version"
