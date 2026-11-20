#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

[[ "$(uname -s)" == Darwin ]] || die 'Execute este desinstalador no macOS.'
[[ "$EUID" != 0 ]] || die 'Execute como usuário normal, sem sudo.'

installed_app="$HOME/Applications/Servix.app"
if [[ -e "$installed_app" || -L "$installed_app" ]]; then
  [[ -d "$installed_app" && ! -L "$installed_app" ]] ||
    die "O destino não é um pacote do Servix: $installed_app"
  bundle_id="$(plutil -extract CFBundleIdentifier raw -o - "$installed_app/Contents/Info.plist" 2>/dev/null || true)"
  [[ "$bundle_id" == com.servix.Servix ]] ||
    die "O destino não é um pacote do Servix: $installed_app"
  rm -rf -- "$installed_app"
fi

printf 'Servix desinstalado. Os dados do usuário foram preservados.\n'
