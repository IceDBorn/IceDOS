#!/usr/bin/env bash

# list your extensions with: codium --list-extensions
EXTENSIONS=(
  "markwylde.vscode-filesize"
  "pkief.material-icon-theme"
  "zhuangtongfa.material-theme"
  "gruntfuggly.todo-tree"
  "nico-castell.linux-desktop-file"
  "eamodio.gitlens"
  "donjayamanne.githistory"
  "codezombiech.gitignore"
  "ziyasal.vscode-open-in-github"
  "editorconfig.editorconfig"
  "dbaeumer.vscode-eslint"
  "esbenp.prettier-vscode"
  "jnoortheen.nix-ide"
  "formulahendry.code-runner"
  "formulahendry.auto-close-tag"
  "ms-vscode.references-view"
  "timonwong.shellcheck"
)

echo "Installing codium extensions..."
for extension in "${EXTENSIONS[@]}"; do
  # --force updates the extension if already installed
  HOME=~/.steam-session codium --force --install-extension "$extension" > /dev/null
done
