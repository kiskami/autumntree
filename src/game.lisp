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
  (:export :main))

(in-package :autumntree)

(defconstant +2d-camera-max-buildings+ 100)

(defun main (&optional args)
  (declare (ignore args))
  (let ((screen-width 1280)
	(screen-height 1024))
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
	     (faded-sky-blue (raylib:fade raylib:+skyblue+ 0.5))

	     (fontsize 12)
	     (border 30)
	     (halfborder (/ border 2))
	     (draw-width (- screen-width border border))
	     (draw-height (- screen-height border border))
	     (ground-height (floor (/ draw-height 6.0)))
	     (sky-height (- screen-height ground-height border border border))

	     (ground-color raylib:+brown+)
	     (sky-color faded-sky-blue)
	     (trunk-color raylib:+darkbrown+))
	
	(raylib:set-target-fps 30)	; conservative value
	(loop :until (raylib:window-should-close)
	      :do
		 (incf (raylib:camera-2d-zoom camera) (* (raylib:get-mouse-wheel-move) 0.05))
		 (setf (raylib:camera-2d-zoom camera) (raylib:clamp (raylib:camera-2d-zoom camera) 0.1 3.0))
		 (when (raylib:is-key-pressed #.(foreign-enum-value 'raylib:keyboard-key :r))
                   (setf (raylib:camera-2d-zoom camera) 1.0
			 (raylib:camera-2d-rotation camera) 0.0))
		 
		 (raylib:with-drawing
		   (raylib:clear-background raylib:+raywhite+)
		   (draw-ground border (- draw-height ground-height) ground-height draw-width ground-color)
		   (draw-sky border sky-height draw-width sky-color)

		   (draw-trunk-and-branches border
					    (- draw-width border border)
					    (- sky-height border)
					    ground-height
					    screen-width
					    screen-height
					    trunk-color)

		   (print-info (floor (raylib:vector2-x screen-center))
			       (- screen-height border (floor (/ ground-height 2)) border border)
			       fontsize)

		   (raylib:draw-text "Autumn Tree - Copyright (c) 2026 kiskami"
				     halfborder
				     (- screen-height halfborder (/ fontsize 2))
				     fontsize
				     raylib:+darkgray+)
		   )
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
;    (break)
    (raylib:draw-rectangle (- base-x half-trwidth)
			   (- base-y trunk-height)
			   trunk-width
			   trunk-height
			   color)))



(defun draw-ground (b y gh dw c)
  (raylib:draw-rectangle b y dw (+ b gh) c)
  )

(defun draw-sky (b sh dw c)
  (raylib:draw-rectangle b b dw sh c)
  )

(defun print-info (x y fontsize)
  (let ((lh 30))
    (raylib:draw-text "Poke the leaves with left mouse button"
		      (- x 95) y
		      fontsize
		      raylib:+white+)
    (raylib:draw-text "Zoom with mousewheel, reset with 'r'"
		      (- x 85) (+ y lh)
		      fontsize
		      raylib:+white+)
	
    (raylib:draw-text "Exit with 'ESC'"
		      (- x 55) (+ y lh lh)
		      fontsize
		      raylib:+white+))
)

(defun main_ ()
  (let ((screen-width 800)
        (screen-height 450))
    (raylib:with-window ("raylib [core] example - 2d camera" (screen-width screen-height))
      (let ((player (raylib:make-rectangle :x 400.0 :y 280.0 :width 40.0 :height 40.0))
            (buildings (make-array +2d-camera-max-buildings+))
            (build-colors (make-array +2d-camera-max-buildings+)))
        (loop :for i :below +2d-camera-max-buildings+
              :for width :of-type single-float := (coerce (raylib:get-random-value 50 200) 'single-float)
              :for height :of-type single-float := (coerce (raylib:get-random-value 100 800) 'single-float)
              :do (setf (aref buildings i) (raylib:make-rectangle :x (- spacing 6000.0)
                                                                  :y (- screen-height 130.0 height)
                                                                  :width width
                                                                  :height height)
                        (aref build-colors i) (raylib:make-color :r (raylib:get-random-value 200 240)
                                                                 :g (raylib:get-random-value 200 240)
                                                                 :b (raylib:get-random-value 200 240)
                                                                 :a 255))
              :sum width :into spacing :of-type single-float)
        (let* ((camera (raylib:make-camera-2d
                        :target (raylib:make-vector2
                                 :x (+ (raylib:rectangle-x player) 20.0)
                                 :y (+ (raylib:rectangle-y player) 20.0))
                        :offset (raylib:make-vector2
                                 :x (/ screen-width 2.0)
                                 :y (/ screen-height 2.0))
                        :rotation 0.0
                        :zoom 1.0))
               (camera-target (raylib:camera-2d-target camera))
               (faded-sky-blue (raylib:fade raylib:+skyblue+ 0.5)))
          (raylib:set-target-fps 60)
          (loop :until (raylib:window-should-close)
                :do (cond
                      ((raylib:is-key-down #.(foreign-enum-value 'raylib:keyboard-key :right))
                       (incf (raylib:rectangle-x player) 2.0))
                      ((raylib:is-key-down #.(foreign-enum-value 'raylib:keyboard-key :left))
                       (decf (raylib:rectangle-x player) 2.0)))
                    (setf (raylib:vector2-x camera-target) (+ (raylib:rectangle-x player) 20.0)
                          (raylib:vector2-y camera-target) (+ (raylib:rectangle-y player) 20.0))
                    (cond
                      ((raylib:is-key-down #.(foreign-enum-value 'raylib:keyboard-key :a))
                       (incf (raylib:camera-2d-rotation camera) 1.0))
                      ((raylib:is-key-down #.(foreign-enum-value 'raylib:keyboard-key :s))
                       (decf (raylib:camera-2d-rotation camera) 1.0)))
                    (setf (raylib:camera-2d-rotation camera) (raylib:clamp (raylib:camera-2d-rotation camera) -40.0 40.0))
                    (incf (raylib:camera-2d-zoom camera) (* (raylib:get-mouse-wheel-move) 0.05))
                    (setf (raylib:camera-2d-zoom camera) (raylib:clamp (raylib:camera-2d-zoom camera) 0.1 3.0))
                    (when (raylib:is-key-pressed #.(foreign-enum-value 'raylib:keyboard-key :r))
                      (setf (raylib:camera-2d-zoom camera) 1.0
                            (raylib:camera-2d-rotation camera) 0.0))
                    (raylib:with-drawing
                      (raylib:clear-background raylib:+raywhite+)
                      (raylib:with-mode-2d camera
                        (raylib:draw-rectangle -6000 320 13000 8000 raylib:+darkgray+)
                        (loop :for building :across buildings
                              :for build-color :across build-colors
                              :do (raylib:draw-rectangle-rec building build-color))
                        (raylib:draw-rectangle-rec player raylib:+red+)
                        (raylib:draw-line (floor (raylib:vector2-x camera-target)) (* screen-height -10)
                                          (floor (raylib:vector2-x camera-target)) (* screen-height 10) raylib:+green+)
                        (raylib:draw-line (* screen-width -10) (floor (raylib:vector2-y camera-target))
                                          (* screen-width 10) (floor (raylib:vector2-y camera-target)) raylib:+green+))
                      (raylib:draw-text "SCREEN AREA" 640 10 20 raylib:+red+)
                      (raylib:draw-rectangle 0 0 screen-width 5 raylib:+red+)
                      (raylib:draw-rectangle 0 5 5 (- screen-height 10) raylib:+red+)
                      (raylib:draw-rectangle (- screen-width 5) 5 5 (- screen-height 10) raylib:+red+)
                      (raylib:draw-rectangle 0 (- screen-height 5) screen-width 5 raylib:+red+)
                      (raylib:draw-rectangle 10 10 250 113 faded-sky-blue)
                      (raylib:draw-rectangle-lines 10 10 250 113 raylib:+blue+)
                      (raylib:draw-text "Free 2d camera controls:"  20  20  10  raylib:+black+)
                      (raylib:draw-text "- Right/Left to move Offset"  40  40  10  raylib:+darkgray+)
                      (raylib:draw-text "- Mouse Wheel to Zoom in-out"  40  60  10  raylib:+darkgray+)
                      (raylib:draw-text "- A / S to Rotate"  40  80  10  raylib:+darkgray+)
                      (raylib:draw-text "- R to reset Zoom and Rotation"  40  100  10  raylib:+darkgray+))))))))
