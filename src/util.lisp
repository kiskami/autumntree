;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game utility funcs
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree.util
  (:use :cl)
  (:import-from :cffi
		:foreign-enum-value)
  (:export :trapezlocal))

(in-package :autumntree.util)

(defun float-nonzero-p (x &optional (epsilon 1e-7))
  (>= (abs x) epsilon))

(defun rotate-point (pt pivot angleRad)
  (if (float-nonzero-p angleRad)
      (let ((s (sin angleRad))
	    (c (cos angleRad))
	    (tx (- (raylib:vector2-x pt) (raylib:vector2-x pivot)))
	    (ty (- (raylib:vector2-y pt) (raylib:vector2-y pivot))))
	(raylib:make-vector2 :x (+ (raylib:vector2-x pivot)
				   (- (* tx c) (* ty s))
				   )
			     :y (+ (raylib:vector2-y pivot)
				   (+ (* tx s) (* ty c))))
	)
      pt))

(defun trapezlocal (centerX centerY topW bottomW height color &optional (rot 0.0))
  (declare (single-float centerX centerY topW bottomW height rot))
  (let* ((center (raylib:make-vector2 :x centerX :y centerY))
	 (v0 (raylib:make-vector2 :x (+ centerX (/ (- 0 topW) 2.0)) :y (+ centerY (/ (- 0 height) 2.0))))
	 (v1 (raylib:make-vector2 :x (+ centerX (/ topW 2.0)) :y (+ centerY (/ (- 0 height) 2.0))))
	 (v2 (raylib:make-vector2 :x (+ centerX (/ (- 0 bottomW) 2.0)) :y (+ centerY (/ height 2.0))))
	 (v3 (raylib:make-vector2 :x (+ centerX (/ bottomW 2.0)) :y (+ centerY (/ height 2.0))))
	 (v0r (rotate-point v0 center rot))
	 (v1r (rotate-point v1 center rot))
	 (v2r (rotate-point v2 center rot))
	 (v3r (rotate-point v3 center rot))
	 (color-orange (raylib:make-color :r 255 :g 161 :b 0 :a 255)))
    (raylib:draw-circle-v center 5.0 color-orange)
    (raylib:draw-triangle v0r v2r v1r color)
    (raylib:draw-triangle v1r v2r v3r color)
    )
  )
