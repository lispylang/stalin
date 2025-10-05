#!/usr/bin/env scheme-script
;;; Test loading stalin.sc with Chez compatibility

(display "Loading Stalin-Chez compatibility layer...")
(newline)
(load "stalin-chez-compat.sc")

(display "Loading stalin.sc...")
(newline)

;; Set architecture to AMD64 (64-bit)
(define *architecture-name* "AMD64")

(load "../stalin.sc")

(display "Stalin.sc loaded successfully!")
(newline)

(display "Pointer size from Stalin: ")
(write *pointer-size*)
(newline)
