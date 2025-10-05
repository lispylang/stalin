#!/usr/bin/env scheme-script
;;; Modified Stalin that forces AMD64 architecture

(include "../include/QobiScheme")

;;; Override architecture detection to force AMD64
(define (current-architecture-name) "AMD64")

;;; Now include the rest of Stalin
(include "../stalin.sc")
