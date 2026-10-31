;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;;
;;;; Autumn Tree game main func
;;;; Copyright (c) 2026 kiskami, Hungary Zalaegerszeg
;;;; License: GPL2
;;;;
(in-package :cl-user)
(defpackage autumntree
  (:use :cl)
  (:import-from :cffi
		:foreign-enum-value)
  (:import-from :autumntree.util
		:trapezlocal)
  (:export :main))

(in-package :autumntree)

(defconstant +2d-camera-max-buildings+ 100)

(defun main (&optional args)
  (declare (ignore args))
  (let ((screen-width 1280)
	(screen-height 1024)
	(color-skyblue (raylib:make-color :r 102 :g 191 :b 255 :a 255))
	(color-brown (raylib:make-color :r 127 :g 106 :b 79 :a 255))
	(color-dark-brown (raylib:make-color :r 76 :g 63 :b 47 :a 255))
	(color-raywhite (raylib:make-color :r 245 :g 245 :b 245 :a 255))
	(color-green (raylib:make-color :r 0 :g 228 :b 48 :a 255))
	(color-gray (raylib:make-color :r 130 :g 130 :b 130 :a 255))
	(color-dark-gray (raylib:make-color :r 80 :g 80 :b 80 :a 255)))
    (raylib:with-window ("Autumn Tree" (screen-width screen-height))
      (let* ((screen-center (raylib:make-vector2
			     :x (/ screen-width 2.0)
			     :y (/ screen-height 2.0)))
	     (camera (raylib:make-camera-2d
		      :target screen-center
		      :offset screen-center
		      :rotation 0.0
		      :zoom 1.0))
	     ;; (camera-target (raylib:camera-2d-target camera))
	     (faded-sky-blue
	       (raylib:fade color-skyblue 0.5)
;	       raylib:+skyblue+
	       )

	     (fontsize 12)
	     (border 30)
	     (halfborder (/ border 2))
	     (draw-width (- screen-width border border))
	     (draw-height (- screen-height border border))
	     (ground-height (floor (/ draw-height 6.0)))
	     (sky-height (- screen-height ground-height border border border))

	     (ground-color color-brown)
	     (sky-color faded-sky-blue)
	     (trunk-color color-dark-brown))
	
	(raylib:set-target-fps 30)	; conservative value
	(loop :until (raylib:window-should-close)
	      :do
		 (incf (raylib:camera-2d-zoom camera) (* (raylib:get-mouse-wheel-move) 0.05))
		 (setf (raylib:camera-2d-zoom camera) (raylib:clamp (raylib:camera-2d-zoom camera) 0.1 3.0))
		 (when (raylib:is-key-pressed #.(foreign-enum-value 'raylib:keyboard-key :r))
                   (setf (raylib:camera-2d-zoom camera) 1.0
			 (raylib:camera-2d-rotation camera) 0.0))

		 (when (raylib:is-key-pressed #. (foreign-enum-value 'raylib:keyboard-key :h))
		   (if (raylib:is-cursor-hidden)
		       (raylib:show-cursor)
		       (raylib:hide-cursor)))

		 (let ((mousepos (raylib:get-mouse-position)))
		   		   
		   (raylib:with-drawing
		     (raylib:clear-background color-raywhite)
		     (draw-ground border (- draw-height ground-height) ground-height draw-width ground-color)
		     (draw-sky border sky-height draw-width sky-color)

		     (draw-trunk-and-branches border
					      (- draw-width border border)
					      (- sky-height border)
					      ground-height
					      screen-width
					      screen-height
					      trunk-color)

		     (unless (raylib:is-cursor-hidden)
		       (raylib:draw-circle-v mousepos 5.0 color-green)
		       (raylib:draw-text (format nil "(~a ~a)"
						 (raylib:vector2-x mousepos)
						 (raylib:vector2-y mousepos))
					 halfborder
					 halfborder
					 fontsize
					 color-gray))
		     
		     (print-info (floor (raylib:vector2-x screen-center))
				 (- screen-height border (floor (/ ground-height 2)) border border)
				 fontsize)

		     (raylib:draw-text "Autumn Tree - Copyright (c) 2026 kiskami"
				       halfborder
				       (- screen-height halfborder (/ fontsize 2))
				       fontsize
				       color-dark-gray)
		     ))
	      )				; loop
	) 
      )
    ))

(defun draw-trunk-and-branches (border tree-width tree-height ground-height screen-width screen-height color)
  (let* ((base-x (floor (/ screen-width 2.0)))
	 (base-y (floor (- screen-height ground-height border border)))
	 (trunk-width (floor (/ tree-width 15.0)))
	 (half-trwidth (floor (/ trunk-width 2.0)))
	 (trunk-height (floor (/ tree-height 2.0))))
    (raylib:draw-rectangle (- base-x half-trwidth)
			   (- base-y trunk-height)
			   trunk-width
			   trunk-height
			   color)
    (trapezlocal (coerce base-x 'single-float)
		 (coerce (- base-y trunk-height) 'single-float)
		 (coerce (- trunk-width 40) 'single-float)
		 (coerce trunk-width 'single-float)
		 (coerce (floor (/ trunk-height 2.0)) 'single-float)
		 color
		 (coerce (* raylib:+deg2rad+ -85) 'single-float))
    ))



(defun draw-ground (b y gh dw c)
  (raylib:draw-rectangle b y dw (+ b gh) c)
  )

(defun draw-sky (b sh dw c)
  (raylib:draw-rectangle b b dw sh c)
  )

(defun print-info (x y fontsize)
  (let ((lh 30)
	(color-white (raylib:make-color :r 255 :g 255 :b 255 :a 255)))
    (raylib:draw-text "Poke the leaves with left mouse button"
		      (- x 95) y
		      fontsize
		      color-white)
    (raylib:draw-text "Zoom with mousewheel, reset with 'r'"
		      (- x 85) (+ y lh)
		      fontsize
		      color-white)
	
    (raylib:draw-text "Exit with 'ESC'"
		      (- x 55) (+ y lh lh)
		      fontsize
		      color-white))
)
