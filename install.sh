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

install "$HOME/.stack/config.yaml" "$config/stack-config.yaml"

check_keyring_backend

git config --global core.excludesfile "$(readlink -f .gitignore-global)"

echo "Installation complete."
