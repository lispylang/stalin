#!/usr/bin/env scheme-script
;;; Test super simple define-structure

(define (make-accessor type-name field-name idx)
  `(define (,(string->symbol
              (string-append (symbol->string type-name) "-" (symbol->string field-name))) obj)
     (vector-ref obj ,idx)))

(define (make-mutator type-name field-name idx)
  `(define (,(string->symbol
              (string-append "set-" (symbol->string type-name) "-" (symbol->string field-name) "!")) obj val)
     (vector-set! obj ,idx val)))

(define (generate-structure type-name fields)
  (let* ((type-str (symbol->string type-name))
         (constructor-name (string->symbol (string-append "make-" type-str)))
         (predicate-name (string->symbol (string-append type-str "?"))))

    (let ((accessors (let loop ((flds fields) (idx 1) (acc '()))
                      (if (null? flds)
                          acc
                          (loop (cdr flds)
                                (+ idx 1)
                                (cons (make-accessor type-name (car flds) idx) acc)))))
          (mutators (let loop ((flds fields) (idx 1) (acc '()))
                     (if (null? flds)
                         acc
                         (loop (cdr flds)
                               (+ idx 1)
                               (cons (make-mutator type-name (car flds) idx) acc))))))

      (eval
       `(begin
          (define (,constructor-name ,@fields)
            (vector ',type-name ,@fields))
          (define (,predicate-name obj)
            (and (vector? obj)
                 (> (vector-length obj) 0)
                 (eq? (vector-ref obj 0) ',type-name)))
          ,@accessors
          ,@mutators)
       (interaction-environment)))))

;; Test it
(generate-structure 'point '(x y))

(display "Structure defined!")
(newline)

(define p (make-point 10 20))
(display "Point created: ")
(write p)
(newline)

(display "Point-x: ")
(write (point-x p))
(newline)
