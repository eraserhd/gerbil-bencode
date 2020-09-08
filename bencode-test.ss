(import :std/test
        "bencode")
(export bencode-test)

(def bencode-test
  (test-suite "test :eraserhd/bencode"
    (test-case "foo"
      (check (+ 2 2) => 4))))
