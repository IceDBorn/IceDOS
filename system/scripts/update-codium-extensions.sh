#!/usr/bin/env bash

# list your extensions with: codium --list-extensions
EXTENSIONS=(
  "codezombiech.gitignore"
  "dbaeumer.vscode-eslint"
  "donjayamanne.githistory"
  "eamodio.gitlens"
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "formulahendry.auto-close-tag"
  "formulahendry.code-runner"
  "gruntfuggly.todo-tree"
  "jnoortheen.nix-ide"
  "markwylde.vscode-filesize"
  "ms-vscode.references-view"
  "nico-castell.linux-desktop-file"
  "pkief.material-icon-theme"
  "timonwong.shellcheck"
  "zhuangtongfa.material-theme"
  "ziyasal.vscode-open-in-github"
)

echo "Installing codium extensions..."
for extension in "${EXTENSIONS[@]}"; do
  # --force updates the extension if already installed
  codium --force --install-extension "$extension" > /dev/null
done
