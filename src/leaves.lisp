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
	   :leave-state
	   :leave-g
	   :find-poked-leaves)
  )

(in-package :autumntree.leaves)

; https://www.schemecolor.com/fall-leaf.php
(defconstant +leafes-colors+ (list
			      '(129 140 29 255) ; dark wasabi
			      '(149 50 64 255) ; velvet
			      '(254 153 52 255) ; deep saffron
			      '(253 199 38 255) ; gold rush
			      ))

(defstruct leave
  (centerX 0.0 :type single-float)
  (centerY 0.0 :type single-float)
  (width 0.0 :type single-float)
  (height 0.0 :type single-float)
  (rot 0.0 :type single-float)
  color
  (state :created)
  (g 15.0 :type single-float)
  )

(defun prep-leaves (canopy-x canopy-y canopy-width canopy-height count halfx regions)
  (let* ((width (/ canopy-width 25.0))
	 (height (/ canopy-height 20.0))

	 ;; the last color in +leafes-colors+ is at least 50%
	 (gold-ratio (+ 50 (random 48)))
	 
	 (result (make-array count :element-type (type-of (make-leave)))))
    (format t "there will be ~D leaves~%" count)
    (loop
      :with i = 0
      :until (= i count)
      :do
	 (let ((x (+ canopy-x (random canopy-width)))
	       (y (+ canopy-y (random canopy-height)))
	       )
	   (if (in-regions x y regions)
	       (let ((angle (coerce (* raylib:+deg2rad+ (+ 10 (random 55))) 'single-float))) 
		 (setf (aref result i)
		       (make-leave :centerX x
				   :centerY y
				   :width width
				   :height height
				   :rot (if (> x halfx)
					    angle
					    (* -1 angle))
				   :color (leaf-color gold-ratio)
				   )
		       )
		 (setf i (1+ i)))
	       ;;(break)
	       ))
      )
    result))

(defun leaf-color (gold-ratio)
  (let* ((color-index (random 101))
	 (lc (length +leafes-colors+))
	 (rest (- 100 gold-ratio))
	 (c (if (<= color-index gold-ratio)
		(nth (1- lc) +leafes-colors+) ; gold color
		(nth (floor (/ (- color-index gold-ratio) (/ rest (1- lc)))) +leafes-colors+)))) ; the rest
    (when (not c) (break))
    c))

(defun in-regions (x y regions)
  ;;  (break)
  (some
   (lambda (r) (in-region x y (cdr r)))
   regions))

(defun in-region (x y region)
  ;; x y w h
  (let* ((rx (first region))
	 (ry (second region))
	 (rx2 (+ rx (third region)))
	 (ry2 (+ ry (fourth region))))
    (and
     (> x rx)
     (> y ry)
     (< x rx2)
     (< y ry2)))
  )

(defun find-poked-leaves (mousepos leaves)
  (let ((result '())
	(mx (raylib:vector2-x mousepos))
	(my (raylib:vector2-y mousepos)))
    (dotimes (i (length leaves))
      (let* ((l (aref leaves i))
	     (w (leave-width l))
	     (h (leave-height l))
	     (x (leave-centerX l))
	     (y (leave-centerY l))
	     (diff (min (/ w 2) (/ h 2))))
	(when (and
	       (> mx (- x diff))
	       (< mx (+ x diff))
	       (> my (- y diff))
	       (< my (+ y diff))
	       )
	  (push l result)
	  )))
    result))
