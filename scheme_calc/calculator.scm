#lang racket

(define vars (make-hash)) ; değişkenler burada tutulur

;; ifade çözümleyici
(define (eval-expr expr)
  (cond
    [(number? expr) expr]
    [(symbol? expr)
     (hash-ref vars expr
               (lambda ()
                 (displayln (string-append "Hata: Tanımsız değişken '" (symbol->string expr) "'"))
                 #f))]
    [(list? expr)
     (let* ([op (car expr)]
            [args (cdr expr)])
       (cond
         [(eq? op '+)
          (let ([a (eval-expr (car args))] [b (eval-expr (cadr args))])
            (if (and a b) (+ a b) #f))]
         [(eq? op '-)
          (let ([a (eval-expr (car args))] [b (eval-expr (cadr args))])
            (if (and a b) (- a b) #f))]
         [(eq? op '*)
          (let ([a (eval-expr (car args))] [b (eval-expr (cadr args))])
            (if (and a b) (* a b) #f))]
         [(eq? op '/)
          (let ([a (eval-expr (car args))] [b (eval-expr (cadr args))])
            (cond
              [(not (and a b)) #f]
              [(= b 0) (displayln "Hata: Sıfıra bölme!") #f]
              [else (/ a b)]))]
         [else (displayln "Hata: Geçersiz işlem") #f]))]
    [else #f]))

;; ana döngü
(define (repl)
  (displayln "Çıkmak için 'exit' yazın.")
  (let loop ()
    (display ">> ")
    (flush-output)
    (define input (read-line))
    (cond
      [(equal? input "exit") (void)]
      [(string-prefix? "print " input)
       (define expr (read (open-input-string (substring input 6))))
       (define result (eval-expr expr))
       (when result (displayln result))
       (loop)]
      [(string-contains? input "=")
       (define parts (string-split input "="))
       (define var (string->symbol (string-trim (first parts))))
       (define expr-str (string-trim (second parts)))
       (define expr (read (open-input-string expr-str)))
       (define val (eval-expr expr))
       (when val
         (hash-set! vars var val)
         (displayln (string-append (symbol->string var) " = " (number->string val))))
       (loop)]
      [else
       (define expr (read (open-input-string input)))
       (define result (eval-expr expr))
       (when result (displayln (string-append "Result: " (number->string result))))
       (loop)])))

(repl)
