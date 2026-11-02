;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game tree leaves funcs and data
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree.leaves
  (:use :cl)
  (:nicknames :leaves)
  ;; (:import-from :cffi
  ;; 		:foreign-enum-value)
  (:export :prep-leaves
	   :leave-centerX
	   :leave-centerY
	   :leave-width
	   :leave-height
	   :leave-color
	   :leave-rot
	   :leave-state)
  )

(in-package :autumntree.leaves)

(defconstant +def-leave-color+ (raylib:make-color :r 253 :g 249 :b 0 :a 255)) ; yellow

(defstruct leave
  (centerX 0.0 :type single-float)
  (centerY 0.0 :type single-float)
  (width 0.0 :type single-float)
  (height 0.0 :type single-float)
  (rot 0.0 :type single-float)
  (color +def-leave-color+)
  (state :created)
  )

(defun prep-leaves (canopy-x canopy-y canopy-width canopy-height count halfx)
  (let* ((width (/ canopy-width 25.0))
	 (height (/ canopy-height 20.0))
	 (result '()))
    ;; deltoidlocal centerx centery width height color &optional (rot 0.0)
    (push
     (make-leave :centerX canopy-x :centerY (+ canopy-y 50) :width width :height height)
     result)
    (dotimes (i count)
      (let ((x (+ canopy-x (random canopy-width)))
	    (angle (coerce (* raylib:+deg2rad+ (random 35)) 'single-float)))
	(push
	 (make-leave :centerX x
		     :centerY (+ canopy-y (random canopy-height))
		     :width width
		     :height height
		     :rot (if (> x halfx)
			      angle
			      (* -1 angle))
		     )
	 result)))
    result))

