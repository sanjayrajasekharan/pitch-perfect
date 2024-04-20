#!/bin/bash

# Check for arguments

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

find_python() {
    if command -v python3 &>/dev/null; then
        echo "python3"
    elif command -v python &>/dev/null; then
        echo "python"
    else
        echo "No suitable Python interpreter found." >&2
        exit 1
    fi
}

check_scaling_main() {
    if ! [ -x "realtime/main" ]; then
        echo "realtime/main is not built. Run setup.sh" >&2
        exit 1
    fi
}

PYTHON=$(find_python)

check_scaling_main

samples_temp="./.samples"
samples_scaled_temp="./.samples_scaled"

trap 'rm -f "$samples_temp" "$samples_scaled_temp"' EXIT

"$PYTHON" converters/txter.py "$1" "$samples_temp"
if [ $? -ne 0 ]; then
    echo "Failed to generate samples, exiting." >&2
    exit 1
fi

if ! cat "$samples_temp" | realtime/main > "$samples_scaled_temp"; then
    echo "Scaling failed, exiting." >&2
    exit 1
fi

"$PYTHON" converters/waver.py "$samples_scaled_temp" "$2"
if [ $? -ne 0 ]; then
    echo "Failed to process scaled samples, exiting." >&2
    exit 1
fi

echo "Processing complete."

