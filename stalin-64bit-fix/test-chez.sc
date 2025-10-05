#!/usr/bin/env scheme-script
;;; Test Chez Scheme basic functionality

(display "Chez Scheme test: ")
(write (+ 1 2 3 4 5))
(newline)
(display "Pointer size on this platform: ")
(write (foreign-sizeof 'void*))
(newline)
