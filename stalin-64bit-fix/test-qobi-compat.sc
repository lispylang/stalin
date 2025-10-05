#!/usr/bin/env scheme-script
;;; Test loading QobiScheme with Chez compatibility layer

(load "stalin-chez-compat.sc")

(display "Loading QobiScheme.sc...")
(newline)

(include "QobiScheme")

(display "QobiScheme loaded successfully!")
(newline)

;; Test some basic functions
(display "Testing first: ")
(write (first '(1 2 3)))
(newline)

(display "Testing rest: ")
(write (rest '(1 2 3)))
(newline)

(display "All tests passed!")
(newline)
