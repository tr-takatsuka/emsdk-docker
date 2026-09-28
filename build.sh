#!/usr/bin/env bash
# emsdk-docker: interactive script to pick EMSCRIPTEN_VERSION / BOOST_VERSION and run docker build.
# Works from WSL too.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOCKERFILE="Dockerfile"

if [[ ! -f "$DOCKERFILE" ]]; then
  echo "Error: $DOCKERFILE not found in $SCRIPT_DIR" >&2
  exit 1
fi

# Read the current defaults from the Dockerfile ARG lines.
DEFAULT_EMS_VERSION="$(grep -m1 '^ARG EMSCRIPTEN_VERSION=' "$DOCKERFILE" | cut -d'=' -f2)"
DEFAULT_BOOST_VERSION="$(grep -m1 '^ARG BOOST_VERSION=' "$DOCKERFILE" | cut -d'=' -f2)"
DEFAULT_EMS_VERSION="${DEFAULT_EMS_VERSION:-3.1.56}"
DEFAULT_BOOST_VERSION="${DEFAULT_BOOST_VERSION:-1.84.0}"

# Common version candidates (feel free to edit this list).
EMS_CANDIDATES=(3.1.56 3.1.74 4.0.21 4.0.23 5.0.7 6.0.10)  # 3.1.56=old default, 3.1.74=final 3.x, 4.0.23/5.0.7/6.0.10=latest (final) of 4.x/5.x/6.x
BOOST_CANDIDATES=(1.84.0 1.85.0 1.86.0 1.87.0 1.88.0 1.89.0 1.90.0 1.91.0-1 1.92.0)

# Make sure the default value is always in the candidate list.
ensure_contains() {
  local -n arr_ref=$1
  local val=$2
  local v
  for v in "${arr_ref[@]}"; do
    [[ "$v" == "$val" ]] && return 0
  done
  arr_ref=("$val" "${arr_ref[@]}")
}
ensure_contains EMS_CANDIDATES "$DEFAULT_EMS_VERSION"
ensure_contains BOOST_CANDIDATES "$DEFAULT_BOOST_VERSION"

# Let the user pick a version by number, or type a custom one.
# Prompts go to stderr; the chosen value is echoed to stdout.
choose_version() {
  local title="$1" default="$2"
  shift 2
  local candidates=("$@")

  >&2 echo ""
  >&2 echo "$title"
  local i=1 v
  for v in "${candidates[@]}"; do
    if [[ "$v" == "$default" ]]; then
      >&2 printf '  %d) %s  [default in Dockerfile]\n' "$i" "$v"
    else
      >&2 printf '  %d) %s\n' "$i" "$v"
    fi
    i=$((i + 1))
  done
  local custom_index=$i
  >&2 printf '  %d) enter a different version\n' "$custom_index"
  >&2 printf 'Choose a number [Enter for default %s]: ' "$default"

  local choice
  read -r choice || true

  if [[ -z "$choice" ]]; then
    echo "$default"
    return
  fi

  if [[ "$choice" == "$custom_index" ]]; then
    >&2 printf 'Enter a version (example: 4.0.21): '
    local custom
    read -r custom || true
    if [[ -z "$custom" ]]; then
      >&2 echo "No input given, using default: $default"
      echo "$default"
    else
      echo "$custom"
    fi
    return
  fi

  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice < custom_index )); then
    echo "${candidates[$((choice - 1))]}"
    return
  fi

  >&2 echo "Invalid input, using default: $default"
  echo "$default"
}

echo "=== emsdk-docker build settings ==="

EMS_VERSION="$(choose_version 'Choose EMSCRIPTEN_VERSION:' "$DEFAULT_EMS_VERSION" "${EMS_CANDIDATES[@]}")"
BOOST_VERSION="$(choose_version 'Choose BOOST_VERSION:' "$DEFAULT_BOOST_VERSION" "${BOOST_CANDIDATES[@]}")"

echo ""
printf 'Image tag [Enter for default emsdk]: '
read -r IMAGE_TAG || true
IMAGE_TAG="${IMAGE_TAG:-emsdk}"

echo ""
echo "Running docker build with:"
echo "  EMSCRIPTEN_VERSION = $EMS_VERSION"
echo "  BOOST_VERSION      = $BOOST_VERSION"
echo "  Image tag          = $IMAGE_TAG"
if [[ $# -gt 0 ]]; then
  echo "  Extra options      = $*"
fi
echo ""
printf 'Continue? [Y/n]: '
read -r CONFIRM || true
CONFIRM="${CONFIRM:-Y}"
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 1
fi

set -x
docker build \
  --build-arg EMSCRIPTEN_VERSION="$EMS_VERSION" \
  --build-arg BOOST_VERSION="$BOOST_VERSION" \
  -t "$IMAGE_TAG" \
  "$@" \
  "$SCRIPT_DIR"
