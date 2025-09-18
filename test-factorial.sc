(define (factorial n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(write-string "Factorial test:")
(newline)
(write (factorial 5))
(newline)
(write (factorial 10))
(newline)