#!/usr/bin/env bash

# --------------------------------------------------
#
# Script to uninstall JBoss EAP.
#
# --------------------------------------------------

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

VERSION=0.0.1

# Change into the script's directory
# Using relative paths is safe!
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly script_dir
cd "${script_dir}"

usage() {
  cat <<EOF
Script to uninstall JBoss EAP.

USAGE:
    $(basename "${BASH_SOURCE[0]}") [FLAGS]

FLAGS:
    -f, --flag          Some flag
    -h, --help          Prints help information
    -v, --version       Prints version information
    --no-color          Uses plain text output
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

version() {
  msg "${BASH_SOURCE[0]} $VERSION"
  exit 0
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --version) version ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  return 0
}

parse_params "$@"
setup_colors

EAP_74_DIR=jboss-eap-7.4

KAFKA_VERSION=2.13-3.4.0
KAFKA_DIR=kafka_${KAFKA_VERSION}
KAFKA_TAR=kafka_${KAFKA_VERSION}.tgz

POSTGRESQL_VERSION=42.2.5
POSTGRESQL_JAR=postgresql-${POSTGRESQL_VERSION}.jar

MAPBOX_NAME=frdemo-mapbox

FRDEMO_NAME=first-responder-demo

msg "\n${CYAN}Remove${NOFORMAT} JBoss EAP 7.4"
rm -rf ${EAP_74_DIR}
msg "${GREEN}DONE${NOFORMAT}"

msg "\n${CYAN}Remove${NOFORMAT} Kafka ${KAFKA_VERSION}"
rm -rf ${KAFKA_TAR}
rm -rf ${KAFKA_DIR}
msg "${GREEN}DONE${NOFORMAT}"

msg "\n${CYAN}Remove${NOFORMAT} PostgreSQL ${POSTGRESQL_VERSION}"
rm -rf ${POSTGRESQL_JAR}
msg "${GREEN}DONE${NOFORMAT}"

msg "\n${CYAN}Remove${NOFORMAT} MapBox API mock"
rm -rf ${MAPBOX_NAME}
msg "${GREEN}DONE${NOFORMAT}"

msg "\n${CYAN}Remove${NOFORMAT} First Responder Demo"
rm -rf ${FRDEMO_NAME}
msg "${GREEN}DONE${NOFORMAT}"
