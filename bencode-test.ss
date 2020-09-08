(import :std/test
        "bencode")
(export bencode-test)

(def (encode x)
  (with-output-to-string
    (lambda ()
      (bencode x))))

(def bencode-test
  (test-suite "test :eraserhd/bencode"
    (test-case "bencode integers"
      (check (encode 0)   => "i0e")
      (check (encode 42)  => "i42e")
      (check (encode -42) => "i-42e"))
    (test-case "bencode lists"
      (check (encode []) => "le")
      (check (encode [1 -2 4]) => "li1ei-2ei4ee"))
    (test-case "bencode strings"
      (check (encode "hello") => "5:hello")
      (check (encode "Hällö, Würld!") => "16:Hällö, Würld!")
      (check (encode "Здравей, Свят!") => "25:Здравей, Свят!"))))
