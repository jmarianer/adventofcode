#lang racket
(define (slurp file) (port->string (open-input-file file)))

(define (individual-monster a)
  (cond
    [(eq? a #\x) 0]
    [(eq? a #\A) 0]
    [(eq? a #\B) 1]
    [(eq? a #\C) 3]
    [(eq? a #\D) 5]
    [else (error a)]
    ))

(define i1a (string->list (slurp "input1a")))
(foldl + 0 (map individual-monster i1a))

(define (get-tuples lst l)
  (if (empty? lst)
      '()
      (let-values ([(f r) (split-at lst l)])
        (cons f (get-tuples r l))
        )
      )
  )

(define (multiple-monsters ms)
  (let* ([monster-count (count
                         (lambda (x) (not (eq? x #\x)))
                         ms)]
         [add-on (* monster-count (- monster-count 1))])
         (foldl + add-on (map individual-monster ms))))


(define i1b (string->list (slurp "input1b")))
(foldl + 0 (map multiple-monsters (get-tuples i1b 2)))

(define i1c (string->list (slurp "input1c")))
(foldl + 0 (map multiple-monsters (get-tuples i1c 3)))