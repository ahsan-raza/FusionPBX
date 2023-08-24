#!/bin/sh
set -e
# Settings
DEBIAN_TAG=12.1-slim
DEBIAN_DIGEST=sha256:a60c0c42bc6bdc09d91cd57067fcc952b68ad62de651c4cf939c27c9f007d1c5
FREESWITCH_VERSION=1.10.10~release~24~4cb05e7f4a~bookworm-1~bookworm+1
FREESWITCH_SHORT_VERSION=$(echo "$FREESWITCH_VERSION" | cut -d '~' -f 1)
FUSIONPBX_VERSION=3c10002d012a4b0929cb1cd8abc5a16297260b39
FUSIONPBX_VERSION_SHORT=$(echo "$FUSIONPBX_VERSION" | head -c 7)
# Build
docker build \
  --build-arg DEBIAN_TAG=${DEBIAN_TAG} \
  --build-arg DEBIAN_DIGEST=${DEBIAN_DIGEST} \
  --build-arg FREESWITCH_VERSION=${FREESWITCH_VERSION} \
  --build-arg FUSIONPBX_VERSION=${FUSIONPBX_VERSION} \
  --tag fusionpbx:latest \
  FusionPBX
# Tag
for tag in \
  "latest" \
  "fusionpbx-${FUSIONPBX_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION}-freeswitch-${FREESWITCH_SHORT_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION}-freeswitch-${FREESWITCH_SHORT_VERSION}-debian-${DEBIAN_TAG}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}-freeswitch-${FREESWITCH_SHORT_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}-freeswitch-${FREESWITCH_SHORT_VERSION}-debian-${DEBIAN_TAG}"
do
  echo "Tagging ${tag}"
  docker tag fusionpbx:latest "fusionpbx:${tag}"
  if [ -n "${DOCKER_REPO}" ] && [ -n "${DOCKER_USER}" ] && [ -n "${DOCKER_PASS}" ]; then
    docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}" "${DOCKER_REPO}"
    docker tag fusionpbx:latest "${DOCKER_REPO}/fusionpbx:${tag}"
    docker push "${DOCKER_REPO}/fusionpbx:${tag}"
  fi
done
