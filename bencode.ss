(import :std/generic
        :std/text/utf8
        :gerbil/gambit/bytes)
(export bencode)

(defgeneric bencode)

(defmethod (bencode (x <integer>))
  (display "i")
  (display x)
  (display "e"))

(defmethod (bencode (x <null>))
  (display "le"))

(defmethod (bencode (x <pair>))
  (display "l")
  (for-each bencode x)
  (display "e"))

(defmethod (bencode (x <u8vector>))
  (display (u8vector-length x))
  (display ":")
  (write-bytes x))

(defmethod (bencode (x <string>))
  (bencode (string->utf8 x)))
