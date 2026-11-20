#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

[[ "$(uname -s)" == Darwin ]] || die 'Execute este instalador no macOS.'
[[ "$EUID" != 0 ]] || die 'Execute como usuário normal, sem sudo.'
command -v flutter >/dev/null || die 'Instale o Flutter e adicione-o ao PATH.'
xcode-select -p >/dev/null || die 'Configure o Xcode antes de compilar.'

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
install_dir="$HOME/Applications"
installed_app="$install_dir/Servix.app"
bundle_id=com.servix.Servix
if [[ -e "$installed_app" || -L "$installed_app" ]]; then
  current_id="$(plutil -extract CFBundleIdentifier raw -o - "$installed_app/Contents/Info.plist" 2>/dev/null || true)"
  [[ "$current_id" == "$bundle_id" ]] || die "O destino já existe: $installed_app"
fi

mkdir -p -- "$install_dir"
stage="$(mktemp -d "$install_dir/.servix-install.XXXXXXXX")"
staged_app="$stage/Servix.app"
previous_app="$stage/previous.app"
cleanup() {
  local status=$?
  if [[ "$status" != 0 && -e "$previous_app" ]]; then
    if [[ -e "$installed_app" || -L "$installed_app" ]]; then
      printf 'Versão anterior preservada em %s\n' "$previous_app" >&2
      return
    fi
    mv -- "$previous_app" "$installed_app" || return
  fi
  rm -rf -- "$stage"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

flutter --no-color build macos --release | tee "$stage/build.log"
bundle="$(sed -nE 's/^.*Built (.*\/Servix\.app)( \([^)]*\))?$/\1/p' "$stage/build.log" | tail -n 1)"
[[ -n "$bundle" && -x "$bundle/Contents/MacOS/Servix" ]] ||
  die 'O Flutter não informou um pacote macOS completo.'

ditto "$bundle" "$staged_app"
codesign --verify --deep --strict "$staged_app"

if [[ -e "$installed_app" || -L "$installed_app" ]]; then
  mv -- "$installed_app" "$previous_app"
fi
mv -- "$staged_app" "$installed_app"
printf '\nServix instalado. Abra pelo Finder em %s\n' "$installed_app"
