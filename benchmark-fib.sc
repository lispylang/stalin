;;; Simple Fibonacci benchmark for Stalin Scheme
;;; Used to test compiler optimization and performance

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(define (main)
  (display "Computing Fibonacci(40)...")
  (newline)
  (let ((result (fib 40)))
    (display "Result: ")
    (display result)
    (newline)
    (display "Expected: 102334155")
    (newline)))

(main)