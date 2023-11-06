#!/usr/bin/env bash

set -euo pipefail

REUSABLE=false
CLEAN=false
NAME="compute-node-sim"

while getopts "rc" opt; do
  case $opt in
    r) REUSABLE=true; shift ;;
    c) CLEAN=true; shift ;;
    *) echo "Invalid option" >&2
       exit 1 ;;
  esac
done

if [ "$REUSABLE" != true ]; then
  NAME="${NAME}-$((1 + "$RANDOM" % 10))"
fi

function check_docker() {
  if ! command -v docker &> /dev/null; then
      echo "Docker is not installed. Please install Docker and try again."
      exit 1
  fi
}


function cleanup() {
    if [ "$REUSABLE" = true ]; then
        return
    fi

    container_id=$(docker inspect --format="{{.Id}}" "${NAME}" ||:)
    if [[ -n "${container_id}" ]]; then
        echo "Cleaning up container ${NAME}"
        docker rm --force "${container_id}"
    fi
}

function start_container() {
    container_status=$(docker ps --filter "name=${NAME}" --format '{{.Status}}' || false)
    echo "$container_status"
    if [[ -n "${container_status}" && "$REUSABLE" = true ]]; then
        echo "==> Reusing container"
        return
    fi

    docker build --tag "compute-node-sim" --build-arg USER --file Dockerfile .

    docker run -P -d --name "${NAME}" -v "$(pwd)":"/home/${USER}/ansible-workstation" "compute-node-sim"
    echo "==> Container started"
}

function exec_command() {
    docker exec ${NAME} ansible-playbook -v ~/ansible-workstation/main.yml
}

trap cleanup EXIT
trap cleanup ERR
check_docker
start_container
exec_command

