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
		:trapezlocal
		:deltoidlocal)
  (:import-from :autumntree.branches
		:prep-branches)
  (:import-from :leaves
		:prep-leaves)
  (:export :main))

(in-package :autumntree)

(defun main (&optional args)
  (declare (ignore args))
  (let* ((screen-width 1280)
	 (screen-height 1024)
	 (color-skyblue (raylib:make-color :r 102 :g 191 :b 255 :a 255))
	 (color-brown (raylib:make-color :r 127 :g 106 :b 79 :a 255))
	 (color-dark-brown (raylib:make-color :r 76 :g 63 :b 47 :a 255))
	 (color-raywhite (raylib:make-color :r 245 :g 245 :b 245 :a 255))
	 (color-green (raylib:make-color :r 0 :g 228 :b 48 :a 255))
	 (color-gray (raylib:make-color :r 130 :g 130 :b 130 :a 255))
	 (color-dark-gray (raylib:make-color :r 80 :g 80 :b 80 :a 255))

	 (border 30)
	 (halfborder (/ border 2))
	 (draw-width (- screen-width border border))
	 (draw-height (- screen-height border border))
	 (ground-height (floor (/ draw-height 6.0)))
	 (sky-height (- screen-height ground-height border border border))

	 (tree-width (- draw-width border border))
	 (tree-height (- sky-height border))
	 (branches (prep-branches border
				  tree-width
				  tree-height
				  ground-height
				  screen-width
				  screen-height))
	 (leaves (prep-leaves (/ (- screen-width tree-width) 2.0)
			      (coerce border 'single-float)
			      (coerce tree-width 'single-float) 
			      (/ tree-height 2.0)
			      100
			      )))
    
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
	     (faded-sky-blue (raylib:fade color-skyblue 0.5))

	     (fontsize 12)

	     (ground-color color-brown)
	     (sky-color faded-sky-blue)
	     (trunk-color color-dark-brown))
	
	(raylib:set-target-fps 30)	; conservative value
	(raylib:hide-cursor)
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

		     (draw-trunk-and-branches branches trunk-color)

		     (draw-leaves leaves)
		     
		     (raylib:draw-circle-v mousepos 5.0 color-green)
		     (unless (raylib:is-cursor-hidden)
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

(defun draw-trunk-and-branches (branches color)
;  (break)
  (dolist (b branches)
    (cond
      ((equal (first b) :rec)
       (raylib:draw-rectangle (second b) (third b) (fourth b) (fifth b) color))
      ((equal (first b) :trapez)
       (trapezlocal (second b) (third b) (fourth b) (fifth b) (sixth b) color (seventh b)))))
  )

(defun draw-leaves (leaves)
  (dolist (l leaves)
    ;; centerx centery width height color &optional (rot 0.0)
    (deltoidlocal
     (leaves:leave-centerX l)
     (leaves:leave-centerY l)
     (leaves:leave-width l)
     (leaves:leave-height l)
     (leaves:leave-color l)
     (leaves:leave-rot l)
     )))

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
