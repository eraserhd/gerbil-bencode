(import :std/generic
        :std/text/utf8
        :gerbil/gambit/bytes)
(export write-bencode)

(defgeneric write-bencode)

(defmethod (write-bencode (x <integer>))
  (display "i")
  (display x)
  (display "e"))

(defmethod (write-bencode (x <null>))
  (display "le"))

(defmethod (write-bencode (x <pair>))
  (display "l")
  (for-each write-bencode x)
  (display "e"))

(defmethod (write-bencode (x <vector>))
  (display "l")
  (vector-for-each write-bencode x)
  (display "e"))

(defmethod (write-bencode (x <u8vector>))
  (display (u8vector-length x))
  (display ":")
  (write-bytes x))

(defmethod (write-bencode (x <string>))
  (write-bencode (string->utf8 x)))

(defmethod (write-bencode (x <hash-table>))
  (display "d")
  (hash-for-each (lambda (k v)
                   (write-bencode k)
                   (write-bencode v))
                 x)
  (display "e"))
