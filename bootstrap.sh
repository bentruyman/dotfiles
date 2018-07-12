#!/usr/bin/env bash
set -e

# Private
_did_backup=
_copy_count=0
_link_count=0

# Constants
ARROW='>'

# Paths
dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
backup_dir="$dotfiles_dir/backups/$(date +%s)"

################################################################################
# File Management
################################################################################

get_src_path() {
  echo "$dotfiles_dir/files/$1"
}

get_dest_path() {
  echo "$HOME/.$1"
}

backup_file() {
  local file=$1
  _did_backup=1

  [[ -d $backup_dir ]] || mkdir -p "$backup_dir"
  mv "$file" "$backup_dir"
}

clone_repo() {
  if [[ ! -d "$2" ]]; then
    mkdir -p $(dirname $2)
    git clone --recursive "$1" "$2"
  fi
}

file_exists() {
  [[ -f "$1" ]] || [[ -d "$1" ]]
}

files_are_same() {
  [[ ! -L "$2" ]] && cmp --silent "$1" "$2"
}

files_are_linked() {
  if [[ ! -L "$2" ]] || [[ $(readlink "$2") != "$1" ]]; then
    return 1
  fi
}

copy_file() {
  local src_file
  local dest_file

  src_file=$(get_src_path "$1")
  dest_file=$(get_dest_path "$1")

  if ! files_are_same "$src_file" "$dest_file"; then
    file_exists "$dest_file" && backup_file "$dest_file"
    cp "$src_file" "$dest_file"
    _copy_count=$((_copy_count + 1))
    report_install "$src_file" "$dest_file"
  fi
}

link_file() {
  local src_file
  local dest_file

  src_file=$(get_src_path "$1")
  dest_file=$(get_dest_path "$1")

  if ! files_are_linked "$src_file" "$dest_file"; then
    file_exists "$dest_file" && backup_file "$dest_file"
    ln -sf "$src_file" "$dest_file"
    _link_count=$((_link_count + 1))
    report_install "$src_file" "$dest_file"
  fi
}

################################################################################
# Logging
################################################################################

report_header() {
  echo -e "\n\033[1m$*\033[0m";
}

report_success() {
  echo -e " \033[1;32m✔\033[0m  $*";
}

report_install() {
  report_success "$1 $ARROW $2"
}

################################################################################
# CLI
################################################################################

parse_args() {
  while :; do
    case $1 in
      -h|--help)
        show_help
        exit
        ;;
      --skip-intro)
          no_introduction=1
          skip_intro=1
          ;;
      --with-system)
          skip_system=0
          ;;
      --)
          shift
          break
          ;;
      -?*)
          printf 'Unknown option: %s\n' "$1" >&2
          exit
          ;;
      *)
          break
    esac

    shift
  done
}

show_help() {
  echo "bootstrap.sh"
  echo
  echo "Usage: ./bootstrap.sh [options]"
  echo
  echo "Options:"
  echo "  --with-system  Run system-specific scripts (homebrew, install apps, etc.)"
  echo "  --skip-intro   Skip the ASCII art introduction when running"
}

show_intro() {
  echo "     _               ___ _ _             "
  echo "    | |       _     / __|_) |            "
  echo "  __| | ___ _| |_ _| |__ _| | _____  ___ "
  echo " / _  |/ _ (_   _|_   __) | || ___ |/___)"
  echo "( (_| | |_| || |_  | |  | | || ____|___ |"
  echo " \____|\___/  \__) |_|  |_|\_)_____|___/ "
  echo "                       by: Ben Truyman   "
}

################################################################################
# Tasks
################################################################################

task_copy() {
  report_header "Copying files..."
  copy_file "gitconfig"
  copy_file "gitignore_global"
  echo "$_copy_count files copied"
}

task_link() {
  report_header "Linking files..."
  link_file "config"
  link_file "lib"
  link_file "mackup.cfg"
  link_file "tmux.conf"
  link_file "zlogin"
  link_file "zpreztorc"
  link_file "zshenv"
  link_file "zshrc"
  echo "$_link_count files linked"
}

task_system() {
  report_header "Executing platform setup scripts..."
  for script in "$dotfiles_dir/scripts/"setup_*.sh; do
    bash "$script"
  done
}

task_repos() {
  report_header "Installing repositories..."
  clone_repo https://github.com/creationix/nvm.git "$HOME/.nvm"
  clone_repo https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
  clone_repo https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
  clone_repo https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/plugins/zsh-syntax-highlighting"
}

# Let's go!
skip_intro=0
skip_system=1

parse_args "$@"

[[ $skip_intro -eq 0 ]] && show_intro
task_copy
task_link
[[ $skip_system -eq 0 ]] && task_system
task_repos

# Backup Results
[[ _did_backup -eq 1 ]] && {
  report_header "Backed up some files to:"
  echo "$backup_dir"
}

# Fin
report_header "Done!"
