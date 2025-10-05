#!/usr/bin/env scheme-script
;;; Stalin → Chez Scheme Compatibility Layer - Version 2
;;; Simpler implementation focusing on getting Stalin to compile

;;; Load this first before any Stalin code

;;; ============================================================================
;;; Helper function
;;; ============================================================================

(define (iota-helper n)
  (let loop ((i 0) (acc '()))
    (if (>= i n)
        (reverse acc)
        (loop (+ i 1) (cons i acc)))))

;;; ============================================================================
;;; DEFINE-STRUCTURE support - Simple vector-based implementation
;;; ============================================================================

;;; Instead of complex macros, use a simpler runtime approach
;;; This creates procedures directly

(define-syntax define-structure
  (syntax-rules ()
    ((_ type-name field ...)
     (begin
       ;; We'll generate all the necessary functions manually
       ;; Constructor uses quasiquote for simplicity
       (eval
         `(begin
            (define (,(string->symbol (string-append "make-" (symbol->string 'type-name))) ,@'(field ...))
              (vector 'type-name ,@'(field ...)))

            (define (,(string->symbol (string-append (symbol->string 'type-name) "?")) obj)
              (and (vector? obj)
                   (> (vector-length obj) 0)
                   (eq? (vector-ref obj 0) 'type-name)))

            ,@(map (lambda (f idx)
                     `(define (,(string->symbol
                                  (string-append (symbol->string 'type-name) "-" (symbol->string f)))
                               obj)
                        (vector-ref obj ,idx)))
                   '(field ...)
                   (map (lambda (i) (+ i 1)) (iota-helper ,(length '(field ...)))))

            ,@(map (lambda (f idx)
                     `(define (,(string->symbol
                                  (string-append "set-" (symbol->string 'type-name) "-"
                                                 (symbol->string f) "!"))
                               obj val)
                        (vector-set! obj ,idx val)))
                   '(field ...)
                   (map (lambda (i) (+ i 1)) (iota-helper ,(length '(field ...)))))))
         (interaction-environment))))))

;;; Test it
(display "Testing simple define-structure...")
(newline)

(define-structure point x y)

(display "Structure defined!")
(newline)

(define p (make-point 10 20))
(display "Point created: ")
(write p)
(newline)

(display "Point-x: ")
(write (point-x p))
(newline)

(display "Point-y: ")
(write (point-y p))
(newline)

(display "Test passed!")
(newline)
