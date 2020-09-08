(export bencode)

(def (bencode x)
  (cond
   ((number? x)
    (display "i")
    (display x)
    (display "e"))
   ((list? x)
    (display "l")
    (display "e"))))
