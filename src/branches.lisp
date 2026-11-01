;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game tree branches funcs and data
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree.branches
  (:use :cl)
  ;; (:import-from :cffi
  ;; 		:foreign-enum-value)
  (:export :prep-branches))

(in-package :autumntree.branches)

(defun prep-branches (border tree-width tree-height ground-height screen-width screen-height)
  (let* ((result '())
	 (base-x (floor (/ screen-width 2.0)))
	 (base-y (floor (- screen-height ground-height border border)))
	 (trunk-width (floor (/ tree-width 15.0)))
	 (half-trwidth (floor (/ trunk-width 2.0)))
	 (trunk-height (floor (/ tree-height 3.0))))
    ;; (push (list :rec
    ;; 		(- base-x half-trwidth)
    ;; 		(- base-y trunk-height)
    ;; 		trunk-width
    ;; 		trunk-height)
    ;; 	  result)
    (push (list :trapez
		(coerce base-x 'single-float)
		(coerce (- base-y trunk-height) 'single-float)
		(coerce (- trunk-width 40) 'single-float)
		(coerce trunk-width 'single-float)
		(coerce (floor (/ trunk-height 2.0)) 'single-float)
		(coerce (* raylib:+deg2rad+ -5) 'single-float)
		)
	  result)
    (push (list :trapez
		(coerce base-x 'single-float)
		(coerce (- base-y trunk-height) 'single-float)
		(coerce (- trunk-width 40) 'single-float)
		(coerce trunk-width 'single-float)
		(coerce (floor (/ trunk-height 2.0)) 'single-float)
		(coerce (* raylib:+deg2rad+ -5) 'single-float)
		)
	  result)
    result))
