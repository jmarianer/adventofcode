#lang racket
(define (slurp file) (port->string (open-input-file file)))

(define i2a (string-split (slurp "input2a") "\n\n"))
(define words (cdr (string-split (car i2a) #rx"[:,]")))
(define (count-word haystack needle)
 (- (length (string-split (string-append "xxx" haystack "xxx") needle)) 1))
(foldl + 0 (map (lambda (w) (count-word (cadr i2a) w)) words))

(define i2b (string-split (slurp "input2b") "\n\n"))
(define wordsb (cdr (string-split (car i2b) #rx"[:,]")))
(define words-both-directions
  (flatten (map
            (lambda (x) (list x (list->string (reverse (string->list x)))))
            wordsb)))
(define (lowercaseify word str)
  (string-replace str (regexp (string-append "(?i:" word ")")) (string-downcase word))
)
(define lowercase-symbols (foldl lowercaseify (cadr i2b) words-both-directions))
;;; (display lowercase-symbols)
(count char-lower-case? (string->list lowercase-symbols))