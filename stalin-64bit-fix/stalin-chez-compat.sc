#!/usr/bin/env scheme-script
;;; Stalin → Chez Scheme Compatibility Layer
;;; Provides stub implementations of Stalin-specific features for Chez

;;; ============================================================================
;;; Helper functions
;;; ============================================================================

(define (iota n)
  "Generate list (0 1 2 ... n-1)"
  (let loop ((i 0) (acc '()))
    (if (>= i n)
        (reverse acc)
        (loop (+ i 1) (cons i acc)))))

;;; ============================================================================
;;; PRIMITIVE-PROCEDURE support
;;; ============================================================================

;;; In Stalin, (primitive-procedure name) returns a procedure
;;; We stub the most commonly used ones
;;; NOTE: name can be either quoted or unquoted symbol

(define-syntax primitive-procedure
  (syntax-rules (pointer-size clocks-per-second rand-max)
    ;; Handle special cases that need to be known at compile time
    ((_ pointer-size) (lambda () 8))
    ((_ clocks-per-second) (lambda () 1000000))
    ((_ rand-max) (lambda () 2147483647))
    ;; Generic fallback for runtime lookup
    ((_ name) (primitive-procedure-runtime 'name))))

(define (primitive-procedure-runtime name)
  (case name
    ;; Architecture/system info
    ((pointer-size)
     (lambda () 8))  ; 64-bit pointers

    ((clocks-per-second)
     (lambda () 1000000))  ; CLOCKS_PER_SEC typical value

    ((rand-max)
     (lambda () 2147483647))  ; RAND_MAX = 2^31 - 1

    ;; Type predicates - return the actual Scheme procedures
    ((boolean?) boolean?)
    ((char?) char?)
    ((eof-object?) eof-object?)
    ((eq?) eq?)
    ((exact?) exact?)
    ((inexact?) inexact?)
    ((input-port?) input-port?)
    ((integer?) integer?)
    ((negative?) negative?)
    ((not) not)
    ((null?) null?)
    ((number?) number?)
    ((output-port?) output-port?)
    ((positive?) positive?)
    ((procedure?) procedure?)
    ((real?) real?)
    ((string?) string?)
    ((symbol?) symbol?)
    ((vector?) vector?)
    ((zero?) zero?)

    ;; Math functions
    ((acos) acos)
    ((asin) asin)
    ((atan) atan)
    ((ceiling) ceiling)
    ((cos) cos)
    ((exp) exp)
    ((expt) expt)
    ((floor) floor)
    ((log) log)
    ((max) max)
    ((min) min)
    ((quotient) quotient)
    ((remainder) remainder)
    ((round) round)
    ((sin) sin)
    ((sqrt) sqrt)
    ((tan) tan)
    ((truncate) truncate)

    ;; Bitwise operations (Chez has these)
    ((bitwise-and) bitwise-and)
    ((bitwise-not) bitwise-not)
    ((bitwise-or) bitwise-ior)  ; Chez uses bitwise-ior
    ((bitwise-xor) bitwise-xor)

    ;; String operations
    ((string-length) string-length)
    ((string-ref) string-ref)
    ((string-set!) string-set!)
    ((make-string) make-string)

    ;; Vector operations
    ((vector-length) vector-length)
    ((vector-ref) vector-ref)
    ((vector-set!) vector-set!)
    ((make-vector) make-vector)

    ;; I/O operations
    ((read-char) read-char)
    ((write-char) write-char)
    ((peek-char) peek-char)
    ((char-ready?) char-ready?)
    ((open-input-file) open-input-file)
    ((open-output-file) open-output-file)
    ((close-input-port) close-input-port)
    ((close-output-port) close-output-port)
    ((standard-input-port) (lambda () (current-input-port)))
    ((standard-output-port) (lambda () (current-output-port)))

    ;; Special
    ((apply) apply)
    ((call-with-current-continuation) call-with-current-continuation)
    ((panic) (lambda (msg) (error 'stalin msg)))

    ;; Unsupported primitives - return stubs
    ((fork) (lambda () (error 'primitive-procedure "fork not supported in Chez")))
    ((mutex) (lambda () (error 'primitive-procedure "mutex not supported in Chez")))
    ((make-displaced-vector) (lambda args (error 'primitive-procedure "make-displaced-vector not supported")))
    ((pointer?) (lambda (x) #f))  ; No pointers in pure Scheme
    ((structure?) (lambda (x) #f))  ; Handled by define-structure below
    ((make-structure) (lambda args (vector 'structure)))
    ((structure-ref) (lambda (s i) (vector-ref s i)))
    ((structure-set!) (lambda (s i v) (vector-set! s i v)))

    (else
     (lambda args
       (error 'primitive-procedure
              (format "Unknown primitive: ~a" name))))))

;;; ============================================================================
;;; FOREIGN-PROCEDURE and FOREIGN-FUNCTION support
;;; ============================================================================

;;; Define foreign type constants used in foreign-function declarations
(define INT 'int)
(define UNSIGNED-INT 'unsigned-int)
(define LONG 'long)
(define UNSIGNED-LONG 'unsigned-long)
(define CHAR 'char)
(define UNSIGNED-CHAR 'unsigned-char)
(define SHORT 'short)
(define UNSIGNED-SHORT 'unsigned-short)
(define FLOAT 'float)
(define DOUBLE 'double)
(define VOID 'void)
(define VOID* 'void*)
(define STRING 'string)
(define BOOLEAN 'boolean)
(define STRUCT 'struct)
(define POINTER 'pointer)
(define FUNCTION 'function)

;;; Stalin's foreign-procedure syntax:
;;;   (foreign-procedure (arg-types ...) return-type "name" ["header"])
;;;
;;; For our purposes, we create stubs that return reasonable defaults

(define-syntax foreign-procedure
  (syntax-rules (no-return int char* file* void void*)
    ;; 3-argument form (no header)
    ((_ (arg-types ...) return-type name)
     (lambda args #f))

    ;; No-return procedures (like exit)
    ((_ (arg-types ...) no-return name header)
     (lambda args
       (display (format "STUB: foreign-procedure ~a called with args: ~a~%" name args))
       (exit 0)))

    ;; int return type
    ((_ (arg-types ...) int name header)
     (lambda args
       (display (format "STUB: foreign-procedure ~a called~%" name))
       0))

    ;; Generic fallback with header
    ((_ (arg-types ...) return-type name header)
     (lambda args
       (display (format "STUB: foreign-procedure ~a called~%" name))
       #f))))

;;; Stalin's foreign-function syntax:
;;;   (foreign-function name (arg-types ...) return-type "C-name")
;;;
;;; Used for FFI declarations (like Xlib)

(define-syntax foreign-function
  (syntax-rules ()
    ((_ name (arg-types ...) return-type c-name)
     (define name
       (lambda args
         #f)))))

;;; Stalin's foreign-define syntax:
;;;   (foreign-define name value)
;;;
;;; Used to define foreign constants

(define-syntax foreign-define
  (syntax-rules ()
    ((_ name value)
     (define name value))))

;;; ============================================================================
;;; DEFINE-STRUCTURE support
;;; ============================================================================

;;; Stalin's define-structure creates record types
;;; Runtime implementation using eval for symbol manipulation
;;; Stalin naming: (define-structure point x y)
;;;   Creates: make-point, point?, point-x, point-y, set-point-x!, set-point-y!

(define (make-struct-accessor type-name field-name idx)
  `(define (,(string->symbol
              (string-append (symbol->string type-name) "-" (symbol->string field-name))) obj)
     (vector-ref obj ,idx)))

(define (make-struct-mutator type-name field-name idx)
  `(define (,(string->symbol
              (string-append "set-" (symbol->string type-name) "-" (symbol->string field-name) "!")) obj val)
     (vector-set! obj ,idx val)))

(define (generate-structure-definition type-name fields)
  (let* ((type-str (symbol->string type-name))
         (field-list (if (pair? fields) fields (list fields)))
         (constructor-name (string->symbol (string-append "make-" type-str)))
         (predicate-name (string->symbol (string-append type-str "?"))))

    (let ((accessors (let loop ((flds field-list) (idx 1) (acc '()))
                      (if (null? flds)
                          acc
                          (loop (cdr flds)
                                (+ idx 1)
                                (cons (make-struct-accessor type-name (car flds) idx) acc)))))
          (mutators (let loop ((flds field-list) (idx 1) (acc '()))
                     (if (null? flds)
                         acc
                         (loop (cdr flds)
                               (+ idx 1)
                               (cons (make-struct-mutator type-name (car flds) idx) acc))))))

      (eval
       `(begin
          (define (,constructor-name ,@field-list)
            (vector ',type-name ,@field-list))
          (define (,predicate-name obj)
            (and (vector? obj)
                 (> (vector-length obj) 0)
                 (eq? (vector-ref obj 0) ',type-name)))
          ,@accessors
          ,@mutators)
       (interaction-environment)))))

(define-syntax define-structure
  (syntax-rules ()
    ((_ type-name field ...)
     (generate-structure-definition 'type-name '(field ...)))))

;;; ============================================================================
;;; INCLUDE support
;;; ============================================================================

;;; Stalin uses (include "filename") without extension
;;; Chez needs full path and uses load

(define *stalin-include-paths*
  '("."
    "./include"  ; Local include (Chez-compatible versions)
    "../include"
    "/Applications/lispylang/stalin/include"
    "/Applications/lispylang/stalin/stalin-64bit-fix/include"))

(define (find-include-file filename)
  (let ((extensions '("" ".sc" ".scm")))
    (let loop-paths ((paths *stalin-include-paths*))
      (if (null? paths)
          #f
          (let loop-exts ((exts extensions))
            (if (null? exts)
                (loop-paths (cdr paths))
                (let ((full-path (string-append (car paths) "/" filename (car exts))))
                  (if (file-exists? full-path)
                      full-path
                      (loop-exts (cdr exts))))))))))

(define-syntax include
  (syntax-rules ()
    ((_ filename)
     (let ((path (find-include-file filename)))
       (if path
           (load path)
           (error 'include (format "Cannot find file: ~a" filename)))))))

;;; ============================================================================
;;; Additional compatibility helpers
;;; ============================================================================

;;; Stalin's `system` procedure
(define system
  (lambda (cmd)
    (display (format "STUB: system ~a~%" cmd))
    0))

;;; Stalin's string->uninterned-symbol
(define string->uninterned-symbol
  (lambda (str)
    (gensym (string->symbol str))))

;;; bit operations aliases
(define bit-not bitwise-not)
(define bit-and bitwise-and)
(define bit-or bitwise-ior)
(define bit-xor bitwise-xor)

;;; List operations that Stalin expects
(define first car)
(define second cadr)
(define third caddr)
(define fourth cadddr)
(define (fifth x) (car (cddddr x)))
(define (sixth x) (cadr (cddddr x)))
(define (seventh x) (caddr (cddddr x)))
(define (eighth x) (cadddr (cddddr x)))
(define rest cdr)

(define (last x)
  (if (null? (cdr x))
      (car x)
      (last (cdr x))))

;;; panic function
(define panic
  (lambda (msg)
    (error 'stalin msg)))

;;; fuck-up function (yes, Stalin uses this)
(define (fuck-up)
  (panic "This shouldn't happen"))

;;; Forward declarations for functions used before defined in QobiScheme
(define (meta c) c)  ; Will be redefined by QobiScheme
(define (control c) c)  ; Will be redefined by QobiScheme

;;; ============================================================================
;;; Pre-define functions that Scheme-to-C-compatibility expects
;;; ============================================================================

;;; These need to be defined before loading Scheme-to-C-compatibility
;;; because it has syntax that Chez doesn't accept

(define (write-level) #f)
(define (write-pretty) #f)
(define (set-write-level! p?) (void))
(define (set-write-pretty! p?) (void))
(define (collect-all) (void))
(define (collect-info) '(0))

(display "Stalin-Chez compatibility layer loaded successfully!")
(newline)
(display "Pointer size: ")
(write ((primitive-procedure pointer-size)))
(newline)
