#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

[[ "$(uname -s)" == Linux ]] || die 'Este desinstalador é para Linux.'
[[ "$EUID" != 0 ]] || die 'Execute como usuário normal, sem sudo.'
command -v flock >/dev/null || die 'Instale o util-linux para usar o desinstalador.'

app_id=com.servix.Servix
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
[[ "$data_home" == /* ]] || data_home="$HOME/.local/share"
install_dir="$data_home/$app_id"
installed_bundle="$install_dir/bundle"
desktop_file="$data_home/applications/$app_id.desktop"

if [[ -e "$installed_bundle" || -L "$installed_bundle" ||
      -e "$desktop_file" || -L "$desktop_file" ]]; then
  [[ ! -L "$install_dir" ]] || die "O diretório de instalação é um link simbólico: $install_dir"
  mkdir -p -- "$install_dir"
  exec 9>"$install_dir/.install.lock"
  flock 9

  # Keep the profile directory, including the database and the shared installer lock.
  rm -rf -- "$installed_bundle"
  if [[ -f "$desktop_file" && ! -L "$desktop_file" ]] &&
     grep -Fqx 'Name=Servix' "$desktop_file" &&
     grep -Fqx "StartupWMClass=$app_id" "$desktop_file"; then
    rm -f -- "$desktop_file"
  elif [[ -e "$desktop_file" || -L "$desktop_file" ]]; then
    printf 'Atalho preservado porque não foi identificado como Servix: %s\n' "$desktop_file" >&2
  fi
fi

printf 'Servix desinstalado. Os dados do usuário foram preservados.\n'
