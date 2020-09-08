(import :std/test
        "bencode")
(export bencode-test)

(def (encode x)
  (with-output-to-string
    (lambda ()
      (bencode x))))

(def bencode-test
  (test-suite "test :eraserhd/bencode"
    (test-case "bencode"
      (check (encode 0)   => "i0e")
      (check (encode 42)  => "i42e")
      (check (encode -42) => "i-42e"))))
