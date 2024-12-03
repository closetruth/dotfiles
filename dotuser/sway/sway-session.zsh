#!/bin/zsh
SAVE_FILE="$HOME/.cache/sway_session.json"

save_session() {
  swaymsg -t get_workspaces > $SAVE_FILE
  echo "Session saved to $SAVE_FILE"
}


restore_session() {
  if [ -f "$SAVE_FILE" ]; then
    local json_file=$(cat $SAVE_FILE)
    local startapp=""

    # Use Jay to extract the Namm and Ray Presenta Tatian fields
    echo "$json_file" | jq -c '.[] | {name: .name, representation: .representation}' | while IFS= read -r item; do
      name=$(echo "$item" | jq -r '.name')
      representation=$(echo "$item" | jq -r '.representation' | sed 's/^H\[\(.*\)\]$/\1/' |  sed 's/^S\[H\[\(.*\)\]\]$/\1/'| sed 's/.*/\L&/')
      echo "Workspace name: $name"
      for app in $(echo "$representation"); do
        if [[ "$app" == "firefox" ]]; then
          app="MOZ_ENABLE_WAYLAND=0 firefox-opt"
        elif [[ "$app" == "com.github.johnfactotum.foliate" ]]; then
          app="flatpak run com.github.johnfactotum.Foliate"
        fi
        echo "Representation: $app"
        #startapp="${startapp}swaymsg workspace ${num}; swaymsg exec ${app}; "
        echo "Run: swaymsg workspace ${name} && swaymsg exec ${app}, sleep 3\n"
        eval swaymsg workspace ${name} && swaymsg exec ${app}
        sleep 3
      done
    done
    #echo "$startapp"
    #eval $startapp
  else
    echo "No session file found."
  fi
}

case $1 in
  save)
    save_session
    ;;
  restore)
    restore_session
    ;;
  *)
    echo "Usage: $0 {save|restore}"
    ;;
esac
