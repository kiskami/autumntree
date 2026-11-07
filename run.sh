#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_PATH="$SCRIPT_DIR/autumntree"
REDIST_DIR="$SCRIPT_DIR/redist"
LD_LIBRARY_PATH="$REDIST_DIR:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
exec "$APP_PATH" "$@"
