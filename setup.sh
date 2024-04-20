#!/bin/bash

# Check for the presence of the requirements.txt file
if [ ! -f "requirements.txt" ]; then
    echo "requirements.txt file not found!"
    exit 1
fi

# Set the name of the virtual environment
VENV_NAME="venv"

# Function to activate virtual environment
activate_venv() {
    echo "Activating the virtual environment..."
    source $VENV_NAME/bin/activate
}

# Function to install dependencies
install_deps() {
    echo "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt || { echo "Installation failed"; exit 1; }
}

# Check if the virtual environment already exists
if [ -d "$VENV_NAME" ]; then
    echo "Virtual environment already exists."
    activate_venv

    # Check for mismatched dependencies
    trap 'rm -f .current_requirements.txt' EXIT
    pip freeze > .current_requirements.txt
    DIFF=$(diff -u .current_requirements.txt requirements.txt | grep '^\+' | wc -l)
    if [ "$DIFF" -ne 0 ]; then
        echo "Dependencies in the virtual environment do not match requirements.txt."
        install_deps
    else
        echo "All dependencies are up to date."
    fi
else
    # Create the virtual environment using python3
    echo "Creating virtual environment..."
    python3 -m venv $VENV_NAME

    if [ ! -d "$VENV_NAME" ]; then
        echo "Failed to create virtual environment."
        exit 1
    fi

    activate_venv
    install_deps
fi

# Confirm the environment is ready
echo "To activate the virtual environment in the future, use the command: source $VENV_NAME/bin/activate"
echo "To deactivate an active virtual environment, use the command: deactivate"

# Make realtime
echo "Building the realtime executable..."
make -C realtime

# Check for the successful build of the realtime executable
if [ ! -x "realtime/main" ]; then
    echo "Failed to build the realtime executable."
    exit 1
fi

# Exiting script
exit 0
