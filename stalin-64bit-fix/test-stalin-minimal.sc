#!/usr/bin/env scheme-script
;;; Test if we can load stalin.sc core without QobiScheme

(load "stalin-chez-compat.sc")

(display "Attempting to load stalin.sc without QobiScheme...")
(newline)

;;; Define minimal QobiScheme stubs that stalin.sc needs
(define (gensym string) (string->symbol (string-append string "-gen")))
(define (no-cursor) #f)
(define (no-version) #f)
(define (notify format-string . args)
  (display (apply format #f format-string args))
  (newline))
(define (split-into-lines s) (list s))
(define (notify-pp format-string . args) (apply notify format-string args))
(define (notify-pp3 format-string . args) (apply notify format-string args))
(define (terminate) (exit -1))

(display "Basic stubs defined, now loading stalin.sc (this will likely fail at include line)...")
(newline)

;;; Try to load stalin.sc
;;; This will fail when it hits (include "QobiScheme") but let's see how far we get

(load "../stalin.sc")

(display "Stalin.sc loaded successfully!")
(newline)
