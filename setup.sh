#!/bin/bash
echo "Starting the setup script"
# Install Xcode Command Line Tools
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Xcode Command Line Tools installation initiated."
else
    echo "Xcode Command Line Tools already installed."
fi

# Install Homebrew
echo "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
else
    echo "Homebrew is already installed."
fi

# Check for rbenv and install it if missing
if ! command -v rbenv &>/dev/null; then
    echo "Installing rbenv for Ruby version management..."
    brew install rbenv
    eval "$(rbenv init -)"
fi

# Install Ruby 3.0.0 via rbenv if needed
if ! rbenv versions | grep -q 3.0.0; then
    echo "Installing Ruby 3.0.0 via rbenv..."
    rbenv install 3.0.0
fi
rbenv global 3.0.0

# # Check if xcode-install is already installed
# echo "Checking for xcode-install..."
# if ! gem list -i xcode-install &>/dev/null; then
#     echo "xcode-install not found. Installing xcode-install gem..."
#     sudo gem install xcode-install
#     echo "xcode-install gem installed successfully."
# else
#     echo "xcode-install gem is already installed."
# fi

# Prompt the user for Xcode version
read -p "Enter the Xcode version you want to install (or type 'skip' to skip installation): " XCODE_VERSION

# Check if XCODE_VERSION is not equal to "skip"
if [ "$XCODE_VERSION" != "skip" ]; then
    echo "Installing Xcode version $XCODE_VERSION..."
    # Assuming xcode-install is already installed
    if ! xcversion install "$XCODE_VERSION"; then
        echo "Failed to install Xcode version $XCODE_VERSION. Please check the version number and try again."
    else
        echo "Xcode version $XCODE_VERSION installed successfully."
    fi
else
    echo "Skipping Xcode installation."
fi

# Install CocoaPods
echo "Checking for CocoaPods..."
if ! command -v pod &>/dev/null; then
    echo "CocoaPods not found. Installing CocoaPods..."
    sudo gem install cocoapods
    echo "CocoaPods installed successfully."
else
    echo "CocoaPods is already installed."
fi

# Install NVM (Node Version Manager)
echo "Checking for NVM..."
if ! command -v nvm &>/dev/null; then
    echo "NVM not found. Installing NVM..."
    # Download and install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

    # Load NVM into the current shell session
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    echo "NVM installed successfully."
else
    echo "NVM is already installed."
fi

# Prompt user for the Node.js version to install
read -p "Enter the Node.js version you want to install (e.g., 16.20.2): " NODE_VERSION

# Install the specified version of Node.js using NVM and set it as the default
echo "Installing Node.js version $NODE_VERSION..."
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
echo "Node.js version $NODE_VERSION installed and set as the default."
echo "Check node version after installation, you may need to add NVM and Node to PATH for them to work properly"

