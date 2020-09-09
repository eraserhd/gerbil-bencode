(import :std/generic
        :std/misc/list
        :std/text/utf8
        :gerbil/gambit/bytes
        :gerbil/gambit/ports)
(export write-bencode
        read-bencode)

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

(def (digit-value c)
  (- (char->integer c)
     (char->integer #\0)))

(def (read-bencode)
  (def (read-integer)
    (let loop ((accum 0)
               (negative? #f))
      (let ((c (integer->char (read-u8))))
        (case c
          ((#\-)
           (loop accum #t))
          ((#\e)
           (if negative?
             (- accum)
             accum))
          (else
           (loop (+ (* accum 10) (digit-value c)) negative?))))))
  (def (read-list)
    (with-list-builder (push!)
      (let loop ()
        (let ((b (read-u8)))
          (if (char=? #\e (integer->char b))
            (read-u8)
            (begin
              (push! (read-rest-of b))
              (loop)))))))
  (def (read-dictionary)
    (let ((table (make-hash-table)))
      (read-u8)
      table))
  (def (read-rest-of b)
    (if (eof-object? b)
      b
      (case (integer->char b)
        ((#\i) (read-integer))
        ((#\l) (read-list))
        ((#\d) (read-dictionary)))))
  (read-rest-of (read-u8)))
