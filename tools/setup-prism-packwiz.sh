#!/usr/bin/env bash
set -euo pipefail

pack_url='https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml'
bootstrap_url='https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar'

if [[ -n "${PRISM_ROOT:-}" ]]; then
  prism_root="$PRISM_ROOT"
elif [[ "${OSTYPE:-}" == darwin* ]]; then
  prism_root="$HOME/Library/Application Support/PrismLauncher"
elif [[ -n "${XDG_DATA_HOME:-}" ]]; then
  prism_root="$XDG_DATA_HOME/PrismLauncher"
else
  prism_root="$HOME/.local/share/PrismLauncher"
fi

instance_dir="$prism_root/instances/Open-Air-Settlement"
minecraft_dir="$instance_dir/minecraft"

if [[ -e "$instance_dir/instance.cfg" ]]; then
  echo "An Open-Air Settlement instance already exists at: $instance_dir" >&2
  echo 'Inspect it instead of overwriting it.' >&2
  exit 1
fi

mkdir -p "$minecraft_dir"
curl --fail --location "$bootstrap_url" --output "$minecraft_dir/packwiz-installer-bootstrap.jar"

cat > "$instance_dir/instance.cfg" <<'EOF'
InstanceType=OneSix
JoinServerOnLaunch=false
OverrideCommands=true
OverrideConsole=false
OverrideGameTime=false
OverrideJavaArgs=false
OverrideJavaLocation=false
OverrideMemory=false
OverrideNativeWorkarounds=false
OverrideWindow=false
PreLaunchCommand="$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml
iconKey=default
name=Open-Air Settlement
notes=Packwiz-managed shared pack. The pre-launch command syncs the current GitHub release.
EOF

cat > "$instance_dir/mmc-pack.json" <<'EOF'
{
  "formatVersion": 1,
  "components": [
    {
      "uid": "net.minecraft",
      "version": "1.21.1",
      "important": true
    },
    {
      "uid": "net.fabricmc.fabric-loader",
      "version": "0.19.3"
    }
  ]
}
EOF

echo "Created $instance_dir"
echo 'Next: open Prism, sign in once if needed, and launch Open-Air Settlement.'
