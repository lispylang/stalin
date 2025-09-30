;; Factorial example - recursive
(define (factorial n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(write "Factorial of 10: ")
(write (factorial 10))
(newline)