#!/bin/bash

set -euo pipefail

cNone='\033[00m'
cGreen='\033[01;32m'

# Directory for chart source.
cd deploy/charts

# Lint all charts and add dependencies if there are any.
if [ "$CIRCLE_BRANCH" != "main" ]; then
    echo -e "${cGreen}[!] Linting charts...${cNone}"
    echo
    for f in $(ls .); do
        helm dependency build "$f"
        echo
        helm lint ${f}
        echo
    done
    echo
fi

# Run tests if present.
if [ "$CIRCLE_BRANCH" != "main" ]; then
    echo -e "${cGreen}[!] Checking for chart unit tests...${cNone}"
    echo
    for f in $(ls .); do
        if [[ -d "$f/test" ]]; then
            echo -e "${cGreen}[!] Running unit tests for $f...${cNone}"
            bats "$f/test/unit"
            echo
        else
            echo "No unit tests found for $f."
            echo
        fi
    done
    echo
fi
