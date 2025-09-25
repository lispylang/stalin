(define (factorial n) (if (zero? n) 1 (* n (factorial (- n 1))))) (display (factorial 10)) (newline)
