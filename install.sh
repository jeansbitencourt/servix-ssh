#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

[[ "$(uname -s)" == Linux ]] || die 'Este instalador é para Linux.'
[[ "$EUID" != 0 ]] || die 'Execute como usuário normal, sem sudo.'
command -v flutter >/dev/null || die 'Instale o Flutter e adicione-o ao PATH.'
command -v flock >/dev/null || die 'Instale o util-linux para usar o instalador.'

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
app_id=com.servix.Servix
binary_name=servix
icon_asset=data/flutter_assets/assets/branding/servix-icon.png
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
[[ "$data_home" == /* ]] || data_home="$HOME/.local/share"
install_dir="$data_home/$app_id"
applications_dir="$data_home/applications"
installed_bundle="$install_dir/bundle"
desktop_file="$applications_dir/$app_id.desktop"
executable="$installed_bundle/$binary_name"
icon_path="$installed_bundle/$icon_asset"
desktop_icon="${icon_path//\\/\\\\}"

# Escape both the Exec argument and the desktop entry string that contains it.
[[ "$executable" != *[$'\n\r\t=']* ]] || die 'O caminho de instalação tem caracteres incompatíveis com o atalho.'
desktop_exec="${executable//\\/\\\\\\\\}"
desktop_exec="${desktop_exec//\"/\\\\\"}"
desktop_exec="${desktop_exec//\$/\\\\\$}"
desktop_exec="${desktop_exec//\`/\\\\\`}"
desktop_exec="${desktop_exec//%/%%}"

mkdir -p -- "$install_dir" "$applications_dir"
exec 9>"$install_dir/.install.lock"
flock 9

stage="$(mktemp -d -- "$install_dir/.install.XXXXXXXX")"
desktop_stage=''
publishing=false
cleanup() {
  local status=$?
  if [[ "$publishing" == true && "$status" != 0 ]]; then
    # If the new bundle was moved out of staging, move it back before restoring.
    if [[ ! -e "$stage/bundle" ]]; then
      mv -T -- "$installed_bundle" "$stage/bundle" || return
    fi
    if [[ -e "$stage/previous" || -L "$stage/previous" ]]; then
      mv -T -- "$stage/previous" "$installed_bundle" || return
    fi
  fi
  rm -rf -- "$stage"
  if [[ -n "$desktop_stage" ]]; then
    rm -f -- "$desktop_stage"
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

flutter --no-color build linux --release | tee "$stage/build.log"
bundle="$(sed -n "s/^.*Built \(.*\/bundle\)\/$binary_name\$/\1/p" "$stage/build.log" | tail -n 1)"
[[ -n "$bundle" && -x "$bundle/$binary_name" && -f "$bundle/lib/libapp.so" &&
   -s "$bundle/$icon_asset" ]] || die 'O Flutter não informou um pacote Linux completo.'
cp -a -- "$bundle" "$stage/bundle"

# Create the menu entry on the same filesystem as its final location.
desktop_stage="$(mktemp -- "$applications_dir/.$app_id.XXXXXXXX.desktop")"
cat >"$desktop_stage" <<ENTRY
[Desktop Entry]
Type=Application
Name=Servix
GenericName=SSH Operations Center
Comment=Manage SSH connections and terminals
Comment[pt]=Gerencie conexões e terminais SSH
Exec=env -- "$desktop_exec"
Icon=$desktop_icon
Terminal=false
Categories=Network;RemoteAccess;
Keywords=SSH;Terminal;
StartupNotify=true
StartupWMClass=$app_id
ENTRY
chmod 0644 "$desktop_stage"
if command -v desktop-file-validate >/dev/null; then
  desktop-file-validate "$desktop_stage"
fi

publishing=true
if [[ -e "$installed_bundle" || -L "$installed_bundle" ]]; then
  mv -T -- "$installed_bundle" "$stage/previous"
fi
mv -T -- "$stage/bundle" "$installed_bundle"
mv -Tf -- "$desktop_stage" "$desktop_file"
publishing=false

# Retire the previous installer's launcher after the new one is in place.
legacy_id=com.controlpanel.control_panel
legacy_desktop="$applications_dir/$legacy_id.desktop"
if [[ -x "$data_home/$legacy_id/bundle/control_panel" && -f "$legacy_desktop" ]] &&
   grep -Fqx 'Name=ControlPanel' "$legacy_desktop" &&
   grep -Fqx "StartupWMClass=$legacy_id" "$legacy_desktop"; then
  mv -Tn -- "$legacy_desktop" "$legacy_desktop.bak" ||
    printf 'Não foi possível arquivar o atalho anterior.\n' >&2
fi

printf '\nServix instalado. Abra pelo menu de aplicativos.\n'
printf 'Executável: %s\nAtalho: %s\n' "$executable" "$desktop_file"
