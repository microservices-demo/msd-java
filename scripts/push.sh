#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly labels=(
  msd_java_build_version="${BUILD_VERSION}"
  msd_java_build_commit="${TRAVIS_COMMIT}"
)

get_image_id() {
  local filters=()
  for l in "${labels[@]}" ; do
    filters+=(--filter "label=${l}")
  done

  docker image ls --quiet "${filters[@]}"
}

get_image_tags() {
  for image in $(get_image_id) ; do
    docker image inspect "${image}" --format '{{range .RepoTags}}{{.}} {{end}}'
  done
}

do_push() {
    local status=1;
    while [ "${status}" -gt 0 ] ; do
        echo "Pushing $1";
        docker push "$1";
        status="$?";
        if [[ "${status}" -gt 0 ]] ; then
            echo "Docker push failed with exit code ${status}";
        fi;
    done;
}

# When building on Travis, login if credentials are provided, bail otherwise as it's probably a fork
if [ -n "${TRAVIS+x}" ] && [ "${TRAVIS}" == "true" ] ; then
  if [ -n "${DOCKER_EMAIL+x}" ] && [ -n "${DOCKER_USER+x}" ] && [ -n "${DOCKER_PASS+x}" ] ; then
    docker login -e "${DOCKER_EMAIL}" -u "${DOCKER_USER}" -p "${DOCKER_PASS}"
  else
    exit
  fi
fi

for image in $(get_image_tags) ; do
  do_push "${image}"
done
