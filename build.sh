sbcl --eval "(declaim (optimize (speed 3) (safety 1) (debug 0) (space 0)))" \
     --eval "(ql:quickload :autumntree)" \
     --eval "(sb-ext:save-lisp-and-die \"autumntree\" :toplevel #'autumntree:main :executable t :save-runtime-options t)" \
     "$@"
