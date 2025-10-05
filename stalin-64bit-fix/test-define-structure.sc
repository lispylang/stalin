#!/usr/bin/env scheme-script
;;; Test our define-structure implementation

(load "stalin-chez-compat.sc")

(display "Testing define-structure macro...")
(newline)

;; Test simple structure
(define-structure point x y)

(display "Structure defined successfully!")
(newline)

;; Try to create one
(define p (make-point 10 20))

(display "Point created: ")
(write p)
(newline)

(display "Point x: ")
(write (point-x p))
(newline)

(display "Point y: ")
(write (point-y p))
(newline)

(display "All tests passed!")
(newline)
