(declaim (optimize (speed 3) (safety 1) (debug 0) (space 0)))
(ql:quickload :autumntree)
(sb-ext:save-lisp-and-die
 (concatenate 'string "autumntree" #+os-windows ".exe")
				   :toplevel #'autumntree:main
				   :executable t
				   :save-runtime-options t)
