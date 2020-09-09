(import :std/error
        :std/generic
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

(def (read-bencode translate-u8vectors: (translate-u8vectors identity))
  (def (read-rest-of-integer)
    (let loop ((accum 0)
               (negative? #f))
      (let (b (read-u8))
        (when (eof-object? b)
          (raise-io-error 'read-bencode "unexpected eof in integer"))
        (let (c (integer->char b))
          (case c
            ((#\-)
             (loop accum #t))
            ((#\e)
             (if negative?
               (- accum)
               accum))
            (else
             (loop (+ (* accum 10) (digit-value c)) negative?)))))))
  (def (read-rest-of-list)
    (with-list-builder (push!)
      (let loop ()
        (let (b (read-u8))
          (when (eof-object? b)
            (raise-io-error 'read-bencode "unexpected eof in list"))
          (unless (char=? #\e (integer->char b))
            (push! (read-rest-of b))
            (loop))))))
  (def (read-rest-of-dictionary)
    (let ((table (make-hash-table)))
      (let loop ((b (read-u8)))
        (if (char=? #\e (integer->char b))
          table
          (let ((key (read-rest-of b))
                (value (read-rest-of (read-u8))))
            (hash-put! table key value)
            (loop (read-u8)))))))
  (def (read-rest-of-size-prefix b)
    (let loop ((size (digit-value (integer->char b))))
      (let ((c (integer->char (read-u8))))
        (if (char=? #\: c)
          size
          (loop (+ (* 10 size) (digit-value c)))))))
  (def (read-rest-of-bytes b)
    (let* ((size (read-rest-of-size-prefix b))
           (bytes (make-u8vector size))
           (bytes-read (read-u8vector bytes)))
      (when (not (= size bytes-read))
        (raise-io-error 'read-bencode "unexpected eof in bytes"))
      (translate-u8vectors bytes)))
  (def (read-rest-of b)
    (if (eof-object? b)
      b
      (case (integer->char b)
        ((#\i) (read-rest-of-integer))
        ((#\l) (read-rest-of-list))
        ((#\d) (read-rest-of-dictionary))
        (else  (read-rest-of-bytes b)))))
  (read-rest-of (read-u8)))
