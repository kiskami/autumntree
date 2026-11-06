;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game utility funcs
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree.util
  (:use :cl)
  (:nicknames :util)
  ;; (:import-from :cffi
  ;; 		:foreign-enum-value)
  (:export :trapezlocal
           :deltoid-batch
	   :lerp-color))

(in-package :autumntree.util)

(defun float-nonzero-p (x &optional (epsilon 1e-7))
  (>= (abs x) epsilon))

(defun rotate-point (x y px py angleRad)
  (if (float-nonzero-p angleRad)
      (let ((s (sin angleRad))
	    (c (cos angleRad))
	    (tx (- x px))
	    (ty (- y py)))
	(list (+ px
		 (- (* tx c) (* ty s))
		 )
	      (+ py
		 (+ (* tx s) (* ty c))))
	)
      (list x y)))

(defun trapezlocal (centerX centerY topW bottomW height color &optional (rot 0.0))
  (declare (single-float centerX centerY topW bottomW height rot))
  (let* (
	 (v0 (list (+ centerX (/ (- 0 topW) 2.0)) (+ centerY (/ (- 0 height) 2.0))))
	 (v1 (list (+ centerX (/ topW 2.0)) (+ centerY (/ (- 0 height) 2.0))))
	 (v2 (list (+ centerX (/ (- 0 bottomW) 2.0)) (+ centerY (/ height 2.0))))
	 (v3 (list (+ centerX (/ bottomW 2.0)) (+ centerY (/ height 2.0))))
	 (v0r (rotate-point (first v0) (second v0) centerX centerY rot))
	 (v1r (rotate-point (first v1) (second v1) centerX centerY rot))
	 (v2r (rotate-point (first v2) (second v2) centerX centerY rot))
	 (v3r (rotate-point (first v3) (second v3) centerX centerY rot))
;;	 (color-orange (raylib:make-color :r 255 :g 161 :b 0 :a 255))
	 (c (raylib:make-color :r (first color) :g (second color) :b (third color) :a (fourth color)))
	 )
;;    (raylib:draw-circle-v center 5.0 color-orange)
    (raylib:draw-triangle (raylib:make-vector2 :x (first v0r) :y (second v0r))
			  (raylib:make-vector2 :x (first v2r) :y (second v2r))
			  (raylib:make-vector2 :x (first v1r) :y (second v1r))
			  c)
    (raylib:draw-triangle (raylib:make-vector2 :x (first v1r) :y (second v1r))
			  (raylib:make-vector2 :x (first v2r) :y (second v2r))
			  (raylib:make-vector2 :x (first v3r) :y (second v3r))
			  c)
    )
  )

(defun deltoid_ (centerx centery width height &optional (rot 0.0))
  (declare (single-float centerx centery width height rot))
  (let* (
	 (halfW (/ width 2.0))
	 (halfH (/ height 2.0))
	 (v0 (list (- centerX halfW) centerY))
	 (v1 (list centerX (- centerY halfH)))
	 (v2 (list (+ centerX halfW) centerY))
	 (v3 (list centerX (+ centerY halfH)))
	 (v0r (rotate-point (first v0) (second v0) centerX centerY rot))
	 (v1r (rotate-point (first v1) (second v1) centerX centerY rot))
	 (v2r (rotate-point (first v2) (second v2) centerX centerY rot))
	 (v3r (rotate-point (first v3) (second v3) centerX centerY rot))
;;	 (color-black (raylib:make-color :r 0 :g 0 :b 0 :a 255))
;;	 (c (raylib:make-color :r (first color) :g (second color) :b (third color) :a (fourth color)))
	 )
;;   (raylib:draw-circle-v center 3.0 color-black)

    ;; (raylib:draw-triangle v1r v0r v2r c)
    ;; (raylib:draw-triangle v2r v0r v3r c)

    (rlgl:vertex2f (first v1r) (second v1r))
    (rlgl:vertex2f (first v0r) (second v0r))
    (rlgl:vertex2f (first v2r) (second v2r))

    (rlgl:vertex2f (first v2r) (second v2r))
    (rlgl:vertex2f (first v0r) (second v0r))
    (rlgl:vertex2f (first v3r) (second v3r))
    )
  )

(defun deltoid-batch (leaves)
  (rlgl:begin rlgl:+triangles+)
  (dotimes (i (length leaves))
    (let* ((l (aref leaves i))
	   (cx (leaves:leave-centerX l))
	   (cy (leaves:leave-centerY l))
	   (w (leaves:leave-width l))
	   (h (leaves:leave-height l))
	   (c (if (leaves:leave-gcolor l)
		  (leaves:leave-gcolor l)
		  (leaves:leave-color l)))
	   (r (leaves:leave-rot l))
	   )
      ;; centerx centery width height color &optional (rot 0.0)

      (rlgl:color4ub
        (first c)
	(second c)
	(third c)
	(fourth c)
       )
      
      (deltoid_ cx cy w h
;;       (leaves:leave-color l)
       r
       )	
      )
    )
  (rlgl:end))

(defun lerp-color (color1 color2 cl)
  (let ((cl_ (min 1.0 (max 0.0 cl))))
    (list
     (round (+ (first color1) (* cl_ (- (first color2) (first color1)))))
     (round (+ (second color1) (* cl_ (- (second color2) (second color1)))))
     (round (+ (third color1) (* cl_ (- (third color2) (third color1)))))
     (fourth color2)
     ;;(round (+ (fourth color1) (* cl_ (- (third color2) (fourth color1)))))
     ))
  )
