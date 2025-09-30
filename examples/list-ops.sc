;; List operations example
(define (map-example)
  (let ((numbers '(1 2 3 4 5)))
    (write "Original list: ")
    (write numbers)
    (newline)
    (write "Doubled: ")
    (write (map (lambda (x) (* x 2)) numbers))
    (newline)))

(map-example)