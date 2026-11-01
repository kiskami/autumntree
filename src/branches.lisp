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
  (let* ((base-x (floor (+ (/ screen-width 2.0) (/ screen-width 7.5))))
	 (base-y (floor (- screen-height ground-height border border)))
	 (trunk-width (floor (/ tree-width 7.0)))
	 (trunk-height (floor (/ tree-height 2.0))))
    ;; (push (list :rec
    ;; 		(- base-x half-trwidth)
    ;; 		(- base-y trunk-height)
    ;; 		trunk-width
    ;; 		trunk-height)
    ;; 	  result)

; trapez: centerX centerY topW bottomW height rot
    
    (list
     (list :trapez
	   (coerce base-x 'single-float)
	   (coerce (- base-y (/ trunk-height 2.0) -10) 'single-float)
	   (coerce (/ trunk-width 2.5) 'single-float)
	   (coerce trunk-width 'single-float)
	   (coerce trunk-height 'single-float)
	   (coerce (* raylib:+deg2rad+ -5) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x 10) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.15) ) 'single-float)
	   (coerce (/ trunk-width 5.0) 'single-float)
	   (coerce (/ trunk-width 2.5) 'single-float)
	   (coerce (floor (/ trunk-height 2.5)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 5) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x 10) 'single-float)
	   (coerce (- base-y (* trunk-height 1.5) ) 'single-float)
	   (coerce (/ trunk-width 8.0) 'single-float)
	   (coerce (/ trunk-width 5.0) 'single-float)
	   (coerce (floor (/ trunk-height 2.5)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -5) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x 25) 'single-float)
	   (coerce (- base-y (* trunk-height 1.8) ) 'single-float)
	   (coerce (/ trunk-width 16.0) 'single-float)
	   (coerce (/ trunk-width 8.0) 'single-float)
	   (coerce (floor (/ trunk-height 2.5)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -10) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x 5) 'single-float)
	   (coerce (- base-y (* trunk-height 1.85) ) 'single-float)
	   (coerce (/ trunk-width 25.0) 'single-float)
	   (coerce (/ trunk-width 10.0) 'single-float)
	   (coerce (floor (/ trunk-height 2.5)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 7) 'single-float)
	   )
     ;; first left side branch
     (list :trapez
	   (coerce (- base-x (* trunk-width 0.8)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.1) ) 'single-float)
	   (coerce (/ trunk-width 10) 'single-float)
	   (coerce (/ trunk-width 5) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -90) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 1.8)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.14) ) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (/ trunk-width 10) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -100) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 2.8)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.14) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -80) 'single-float)
	   )

     ;; second left side branch
     (list :trapez
	   (coerce (- base-x (* trunk-width 0.7)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.3) ) 'single-float)
	   (coerce (/ trunk-width 12) 'single-float)
	   (coerce (/ trunk-width 8) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -70) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 1.7)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.51) ) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (/ trunk-width 12) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -60) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 2)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.5) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -80) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 1.9)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.05) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -75) 'single-float)
	   )

     ;; third left side branch
     (list :trapez
	   (coerce (- base-x (* trunk-width 0.2)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.45) ) 'single-float)
	   (coerce (/ trunk-width 30) 'single-float)
	   (coerce (/ trunk-width 10) 'single-float)
	   (coerce (floor (/ trunk-height 3)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -40) 'single-float)
	   )
     (list :trapez
	   (coerce (- base-x (* trunk-width 0.54)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.65) ) 'single-float)
	   (coerce (/ trunk-width 50) 'single-float)
	   (coerce (/ trunk-width 30) 'single-float)
	   (coerce (floor (/ trunk-height 5.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ -30) 'single-float)
	   )
	   
     ;; first right side branch
     (list :trapez
	   (coerce (+ base-x (* trunk-width 0.6)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.1) ) 'single-float)
	   (coerce (/ trunk-width 12) 'single-float)
	   (coerce (/ trunk-width 5) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 75) 'single-float)
	   )
     (list :trapez
	   (coerce (+ base-x (* trunk-width 1.6)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.125) ) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (/ trunk-width 10) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 110) 'single-float)
	   )

     ;; second right side branch
     (list :trapez
	   (coerce (+ base-x (* trunk-width 0.4)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.15) ) 'single-float)
	   (coerce (/ trunk-width 25) 'single-float)
	   (coerce (/ trunk-width 15) 'single-float)
	   (coerce (floor (/ trunk-height 3.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 60) 'single-float)
	   )
     (list :trapez
	   (coerce (+ base-x (* trunk-width 1.0)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.24) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 3.7)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 85) 'single-float)
	   )

     ;; third right side branch
     (list :trapez
	   (coerce (+ base-x (* trunk-width 0.45)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.5) ) 'single-float)
	   (coerce (/ trunk-width 18) 'single-float)
	   (coerce (/ trunk-width 10) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 50) 'single-float)
	   )
     (list :trapez
	   (coerce (+ base-x (* trunk-width 1.35)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.78) ) 'single-float)
	   (coerce (/ trunk-width 25) 'single-float)
	   (coerce (/ trunk-width 18) 'single-float)
	   (coerce (floor (/ trunk-height 2.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 60) 'single-float)
	   )

     (list :trapez
	   (coerce (+ base-x (* trunk-width 1.2)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height 0.6) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 3.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 100) 'single-float)
	   )
     (list :trapez
	   (coerce (+ base-x (* trunk-width 1.6)) 'single-float)
	   (coerce (- base-y trunk-height (* trunk-height -0.02) ) 'single-float)
	   (coerce (/ trunk-width 40) 'single-float)
	   (coerce (/ trunk-width 20) 'single-float)
	   (coerce (floor (/ trunk-height 4.0)) 'single-float)
	   (coerce (* raylib:+deg2rad+ 65) 'single-float)
	   ))
    ))
