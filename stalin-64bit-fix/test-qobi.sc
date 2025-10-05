#!/usr/bin/env scheme-script
;;; Test if Chez can load QobiScheme

(load "../include/QobiScheme.sc")

(display "QobiScheme loaded successfully!")
(newline)
(display "Testing basic functionality...")
(newline)

;; Test some basic QobiScheme functions
(write (first '(1 2 3)))
(newline)
(write (rest '(1 2 3)))
(newline)

(display "QobiScheme test complete!")
(newline)
