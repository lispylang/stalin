;; Fibonacci example - iterative
(define (fib n)
  (letrec ((iter (lambda (a b count)
                   (if (= count 0)
                       a
                       (iter b (+ a b) (- count 1))))))
    (iter 0 1 n)))

(write "Fibonacci of 20: ")
(write (fib 20))
(newline)