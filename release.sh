#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec zip -x '.git/*' .gitignore 'tmp/*' '*.html' '*.fasl' '*~'  -r -9 autumntree-`date +%F`.zip .
