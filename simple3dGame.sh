#!/bin/sh
echo -ne '\033c\033]0;simple3dGame\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/simple3dGame.x86_64" "$@"
