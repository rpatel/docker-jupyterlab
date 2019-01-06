#!/bin/bash
set -e

# If absolute path for command is not provided (does not start with "/"),
# assume CMD is arguments for jupyter command
if [ "${1:0:1}" != "/" ]; then
  set -- /home/jupyter/.local/bin/jupyter "$@"
fi

if [[ -f /requirements.py3.txt ]]; then
  python3 -m pip install -U -r /requirements.py3.txt
fi

if [[ -f /requirements.py2.txt ]]; then
  python -m pip install -U -r /requirements.py2.txt
fi

exec "$@"
