;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defsystem "autumntree"
  :version "0.1.0"
  :author "kiskami"
  :license "GPL2"
  :description "Autumn Tree game - Autumn Lisp Game Jam 2026 project"
  :depends-on ("claw-raylib" "claw-raylib.rlgl")
  :components ((:module "src"
			:components ((:file "game" :depends-on ("util"))
				     (:file "util")))))
