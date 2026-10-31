;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defsystem "autumntree"
  :version "0.1.0"
  :author "kiskami"
  :license "GPL2"
  :description "Autumn Lisp Game Jam 2026 project"
  :depends-on ("claw-raylib")
  :components ((:module "src"
			:components ((:file "game")))))
