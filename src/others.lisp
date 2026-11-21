;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game other things
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree.others
  (:use :cl)
  (:nicknames :others)
  ;; (:import-from :cffi
  ;; 		:foreign-enum-value)
  (:export :draw-snail
	   :update-snail
	   :init-snail
	   :poke-snail))

(in-package :autumntree.others)

(defstruct snail
  (x 0.0 :type single-float)
  (y 0.0 :type single-float)
  (w 30.0 :type single-float)
  (h 8.0 :type single-float)
  (r (coerce (* raylib:+deg2rad+ -18.0) 'single-float) :type single-float)
  (maxx 0.0 :type single-float)
  (state :moving)
  (sdt 0.0 :type single-float))

(defparameter *snail* (make-snail :maxx 2000.0))
(defparameter +snail-poked-time+ 10.0)

(defun init-snail (x y maxx)
  (setf (snail-x *snail*) x)
  (setf (snail-y *snail*) y)
  (setf (snail-maxx *snail*) maxx))

(defun update-snail (dt)
  (if (equal (snail-state *snail*) :poked)
      (progn
	(setf (snail-sdt *snail*)
	      (max 0.0 (- (snail-sdt *snail*) dt)))
	(when (= 0.0 (snail-sdt *snail*))
	  (setf (snail-state *snail*) :moving)))
      (setf (snail-x *snail*) (min (snail-maxx *snail*)
				   (+ (snail-x *snail*) (* dt 2.0))))))

(defun poke-snail (x y)
  (let ((dx (- (snail-x *snail*) x))
	(dy (- (snail-y *snail*) y))
	)
    (when (< (+ (* dx dx) (* dy dy))
	     (* (snail-w *snail*) (snail-w *snail*) 1.5))
      (format t "snail poked~%")
      (setf (snail-state *snail*) :poked)
      (setf (snail-sdt *snail*) +snail-poked-time+))
    ))

(defun draw-snail (c c2)
  (unless (>= (snail-x *snail*) (snail-maxx *snail*))
    (let ((housedx (/ (snail-w *snail*) 4.0))
	  (housedy (/ (snail-h *snail*) 2.0)))
      (rlgl:begin rlgl:+triangles+)
      ;;    (break)
      (rlgl:color4ub (raylib:color-r c) (raylib:color-g c) (raylib:color-b c)
		     (raylib:color-a c))
      (util::deltoid_
       (if (equal (snail-state *snail*) :poked)
	   (- (snail-x *snail*) housedx)
	   (snail-x *snail*))
       (snail-y *snail*)
       (if (equal (snail-state *snail*) :poked)
	   (/ (snail-w *snail*) 3.0)
	   (snail-w *snail*))
       (snail-h *snail*)
       (snail-r *snail*))
      (rlgl:end)
      (raylib:draw-circle-v (raylib:make-vector2
			     :x (- (snail-x *snail*) (* housedx 0.5))
			     :y (- (snail-y *snail*) housedy))
			    (* housedx 0.8)
			    c2))))
