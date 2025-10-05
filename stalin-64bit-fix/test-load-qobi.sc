#!/usr/bin/env scheme-script
;;; Test loading QobiScheme with Chez compatibility

(display "Loading Stalin-Chez compatibility layer...")
(newline)
(load "stalin-chez-compat.sc")

(display "Attempting to load QobiScheme...")
(newline)
(include "QobiScheme")

(display "QobiScheme loaded successfully!")
(newline)
