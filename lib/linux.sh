#!/usr/bin/env bash
# shellcheck shell=bash
#
# Linux-specific phase functions. Sourced by setup.sh on Linux.
# Targets headless Ubuntu 22.04 LTS server. Dev tools only.

linux_preflight() {
  # Linuxbrew prerequisites: https://docs.brew.sh/Homebrew-on-Linux#requirements
  local apt_packages=(
    build-essential
    ca-certificates
    curl
    file
    gawk
    git
    procps
  )

  local missing=()
  local pkg
  for pkg in "${apt_packages[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done

  if (( ${#missing[@]} > 0 )); then
    report "Installing apt prerequisites: ${missing[*]}"
    sudo apt-get update
    sudo apt-get install -y "${missing[@]}"
  fi
}

linux_postdotfiles() {
  # Intentional no-op; macOS uses this phase to link launch agents.
  :
}

linux_postpackages() {
  # Intentional no-op; macOS uses this phase for system defaults and Dock.
  :
}
