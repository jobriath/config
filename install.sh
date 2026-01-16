#!/bin/bash

config=$(cd "$(dirname "$0")" || exit 1; pwd)

function install ()
{
  local machine_path=$1;
  local config_path=$2;

  mkdir -p "$(dirname "$machine_path")";

  if [ -L "$machine_path" ]
  then 
    echo "Symlink already exists at $machine_path";
    return;
  elif [ -f "$machine_path" ] 
  then 
    echo "Backing up existing file to $machine_path.bak";
    mv "$machine_path" "$machine_path.bak";
  fi

  echo "$machine_path -> $config_path";
  ln -s "$config_path" "$machine_path";
}

function install_personalrc ()
{
  local config_path="$config/personalrc"

  if [[ $(uname) == "GNU/Linux" || $(uname) == "Linux" ]]
  then
    local machine_path="$HOME/.personalrc"
    install "$machine_path" "$config_path"
    chmod u+x "$machine_path"
    augment_script "FUSILAGE TOMATO TERROR WANE" "$HOME/.profile" "$machine_path"

  elif [[ $(uname) == "Darwin" ]]
  then
    local machine_path="$HOME/.bash_profile"
    install "$machine_path" "$config_path"

  else
    echo "WARNING: Failed to determine OS type. Bash defaults may not work."
  fi
}

function augment_script ()
{
  local shibboleth=$1
  local script=$2
  local textToAdd=$3

  if [ "$(grep -c "$shibboleth" "$script")" = 0 ]
  then
    echo "Augmenting script $script"
    cp "$script" "$script.bak"
    cat >>"$script" <<EOD

# Snippet added by $config/install.sh
# Shibboleth: $shibboleth
$textToAdd
# End snippet
EOD
  else
    echo "$script already augmented"
  fi
}

function check_tmux_plugin_manager_is_installed ()
{
  if [ -f "$HOME/.tmux/plugins/tpm/tpm" ]
  then
    echo "tmux plugin manager installed."
  else
    echo "Installing tmux plugin manager."
    git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
    echo "Done."
  fi
}

function apply_git_config ()
{
  touch ~/.gitconfig

  git config --global core.excludesFile ~/.gitignore
  git config --global merge.conflictStyle zdiff3
  git config --global truecore.pager delta
  git config --global diff.algorithm histogram
  git config --global diff.colorMoved default
  git config --global diff.mnemonicPrefix true
  git config --global diff.colorMovedWD allow-indentation-change
  git config --global branch.sort -committerdate
  git config --global fetch.prune true
  git config --global fetch.pruneTags true
  git config --global changelog.date iso
  git config --global commit.verbose true
  git config --global column.ui auto
  git config --global push.default simple
  git config --global push.autoSetupRemote true
  git config --global push.followTags true
  git config --global help.autocorrect prompt
  git config --global rerere.enabled true
  git config --global rerere.autoupdate true
  git config --global init.defaultBranch main
}

function check_keyring_backend ()
{
  if ! grep -q PlaintextKeyring "$HOME/.local/share/python_keyring/keyringrc.cfg"
  then
    echo "If keyrings bother you, insert the following into ~/.local/share/python_keyring/keyringrc.cfg:"
    echo "   [backend]"
    echo "   default-keyring=keyrings.alt.file.PlaintextKeyring"
  fi
}

check_tmux_plugin_manager_is_installed
install "$HOME/.tmux.conf" "$config/tmux.conf";

install "$HOME/.vimrc" "$config/vimrc";

install_personalrc
install "$HOME/.commonrc" "$config/commonrc"
install "$HOME/.zshrc" "$config/zshrc"

install "$HOME/.gitignore" "$config/gitignore-global"
apply_git_config

check_keyring_backend

echo "Installation complete."
