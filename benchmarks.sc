;;; Performance benchmarks for Stalin Scheme compiler
;;; Tests various aspects of compiled code performance

(define (print-result name time)
  (display name)
  (display ": ")
  (display time)
  (display " ms")
  (newline))

;;; Fibonacci benchmark - recursive
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(define (benchmark-fib n)
  (let ((start (runtime)))
    (let ((result (fib n)))
      (let ((elapsed (- (runtime) start)))
        (print-result "Fibonacci" elapsed)
        result))))

;;; Factorial benchmark - recursive with tail call
(define (factorial-iter n acc)
  (if (= n 0)
      acc
      (factorial-iter (- n 1) (* n acc))))

(define (factorial n)
  (factorial-iter n 1))

(define (benchmark-factorial n)
  (let ((start (runtime)))
    (let ((result (factorial n)))
      (let ((elapsed (- (runtime) start)))
        (print-result "Factorial" elapsed)
        result))))

;;; Prime number sieve - Sieve of Eratosthenes
(define (sieve n)
  (let ((is-prime (make-vector (+ n 1) #t)))
    (vector-set! is-prime 0 #f)
    (vector-set! is-prime 1 #f)
    (let loop ((i 2))
      (when (<= i n)
        (when (vector-ref is-prime i)
          (let mark-multiples ((j (* i i)))
            (when (<= j n)
              (vector-set! is-prime j #f)
              (mark-multiples (+ j i)))))
        (loop (+ i 1))))
    (let count-primes ((i 0) (count 0))
      (if (> i n)
          count
          (count-primes (+ i 1)
                       (if (vector-ref is-prime i)
                           (+ count 1)
                           count))))))

(define (benchmark-sieve n)
  (let ((start (runtime)))
    (let ((result (sieve n)))
      (let ((elapsed (- (runtime) start)))
        (print-result "Prime Sieve" elapsed)
        result))))

;;; Matrix multiplication benchmark
(define (make-matrix rows cols val)
  (let ((m (make-vector rows)))
    (let loop ((i 0))
      (when (< i rows)
        (vector-set! m i (make-vector cols val))
        (loop (+ i 1))))
    m))

(define (matrix-multiply a b)
  (let* ((rows-a (vector-length a))
         (cols-a (vector-length (vector-ref a 0)))
         (cols-b (vector-length (vector-ref b 0)))
         (result (make-matrix rows-a cols-b 0)))
    (let loop-i ((i 0))
      (when (< i rows-a)
        (let loop-j ((j 0))
          (when (< j cols-b)
            (let loop-k ((k 0) (sum 0))
              (if (< k cols-a)
                  (loop-k (+ k 1)
                         (+ sum (* (vector-ref (vector-ref a i) k)
                                  (vector-ref (vector-ref b k) j))))
                  (vector-set! (vector-ref result i) j sum)))
            (loop-j (+ j 1))))
        (loop-i (+ i 1))))
    result))

(define (benchmark-matrix size)
  (let ((a (make-matrix size size 1.0))
        (b (make-matrix size size 2.0)))
    (let ((start (runtime)))
      (let ((result (matrix-multiply a b)))
        (let ((elapsed (- (runtime) start)))
          (print-result "Matrix Multiply" elapsed)
          result)))))

;;; List operations benchmark
(define (list-operations n)
  (let ((lst (let loop ((i 0) (acc '()))
               (if (= i n)
                   acc
                   (loop (+ i 1) (cons i acc))))))
    ;; Map operation
    (let ((squared (map (lambda (x) (* x x)) lst)))
      ;; Filter operation
      (let ((evens (filter even? squared)))
        ;; Fold operation
        (fold + 0 evens)))))

(define (benchmark-lists n)
  (let ((start (runtime)))
    (let ((result (list-operations n)))
      (let ((elapsed (- (runtime) start)))
        (print-result "List Operations" elapsed)
        result))))

;;; Ackermann function - stress test for deep recursion
(define (ackermann m n)
  (cond ((= m 0) (+ n 1))
        ((= n 0) (ackermann (- m 1) 1))
        (else (ackermann (- m 1) (ackermann m (- n 1))))))

(define (benchmark-ackermann m n)
  (let ((start (runtime)))
    (let ((result (ackermann m n)))
      (let ((elapsed (- (runtime) start)))
        (print-result "Ackermann" elapsed)
        result))))

;;; Quicksort benchmark
(define (quicksort lst)
  (if (null? lst)
      '()
      (let ((pivot (car lst))
            (rest (cdr lst)))
        (append (quicksort (filter (lambda (x) (< x pivot)) rest))
                (cons pivot
                      (quicksort (filter (lambda (x) (>= x pivot)) rest)))))))

(define (benchmark-quicksort n)
  (let ((lst (let loop ((i n) (acc '()))
               (if (= i 0)
                   acc
                   (loop (- i 1) (cons (modulo (* i 31415) 1000) acc))))))
    (let ((start (runtime)))
      (let ((result (quicksort lst)))
        (let ((elapsed (- (runtime) start)))
          (print-result "Quicksort" elapsed)
          (length result))))))

;;; Main benchmark runner
(define (run-benchmarks)
  (display "Stalin Scheme Performance Benchmarks")
  (newline)
  (display "=====================================")
  (newline)
  (newline)

  (display "Small benchmarks:")
  (newline)
  (benchmark-fib 35)
  (benchmark-factorial 1000)
  (benchmark-sieve 10000)
  (benchmark-matrix 100)
  (benchmark-lists 1000)
  (benchmark-ackermann 3 8)
  (benchmark-quicksort 1000)

  (newline)
  (display "Medium benchmarks:")
  (newline)
  (benchmark-fib 40)
  (benchmark-factorial 5000)
  (benchmark-sieve 100000)
  (benchmark-matrix 200)
  (benchmark-lists 10000)
  (benchmark-quicksort 10000)

  (newline)
  (display "Benchmarks complete!")
  (newline))

;;; Helper functions that may not be built-in
(define (runtime)
  ;; This should be replaced with actual runtime function
  ;; For now, return a placeholder
  0)

(define (even? n)
  (= (modulo n 2) 0))

(define (filter pred lst)
  (if (null? lst)
      '()
      (if (pred (car lst))
          (cons (car lst) (filter pred (cdr lst)))
          (filter pred (cdr lst)))))

(define (map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst)) (map f (cdr lst)))))

(define (fold f init lst)
  (if (null? lst)
      init
      (fold f (f (car lst) init) (cdr lst))))

(define (append lst1 lst2)
  (if (null? lst1)
      lst2
      (cons (car lst1) (append (cdr lst1) lst2))))

(define (length lst)
  (if (null? lst)
      0
      (+ 1 (length (cdr lst)))))

(define (modulo a b)
  (- a (* b (quotient a b))))

;;; Run the benchmarks
(run-benchmarks)