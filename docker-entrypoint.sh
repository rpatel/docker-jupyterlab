#!/bin/bash
set -e

# Add local bin to PATH
export PATH=${HOME}/.local/bin:${PATH}

# Install Python 3 requirements
if [[ -f /requirements.py3.txt ]]; then
  python3 -m pip install -U -r /requirements.py3.txt
fi

# Install Python 2 requirements
if [[ -f /requirements.py2.txt ]]; then
  python -m pip install -U -r /requirements.py2.txt
fi

exec "$@"
