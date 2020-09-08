(import :std/generic)
(export bencode)

(defgeneric bencode)

(defmethod (bencode (x <integer>))
  (display "i")
  (display x)
  (display "e"))

(defmethod (bencode (x <null>))
  (display "le"))
