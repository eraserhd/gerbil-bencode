(import :std/error
        :std/sugar
        :std/test
        :std/text/utf8
        "bencode")
(export bencode-test)

(def (encode x)
  (utf8->string
    (with-output-to-u8vector
      (lambda ()
        (write-bencode x)))))

(def (decode s)
  (with-input-from-u8vector (string->utf8 s)
    (lambda ()
      (read-bencode translate-u8vectors: utf8->string))))

(def bencode-test
  (test-suite "test :eraserhd/bencode"
    (test-case "write-bencode integers"
      (check (encode 0) => "i0e")
      (check (encode 42) => "i42e")
      (check (encode -42) => "i-42e"))
    (test-case "write-bencode lists"
      (check (encode []) => "le")
      (check (encode [1 -2 4]) => "li1ei-2ei4ee"))
    (test-case "write-bencode vectors"
      (check (encode #()) => "le")
      (check (encode #("hello" 42)) => "l5:helloi42ee"))
    (test-case "write-bencode utf8 strings"
      (check (encode "hello") => "5:hello")
      (check (encode "Hällö, Würld!") => "16:Hällö, Würld!")
      (check (encode "Здравей, Свят!") => "25:Здравей, Свят!"))
    (test-case "write-bencode u8vectors"
      (check (encode #u8(65 32 66)) => "3:A B"))
    (test-case "write-bencode hash tables"
      (check (encode (hash)) => "de")
      (check (encode (hash ("ham" "eggs"))) => "d3:ham4:eggse"))
    (test-case "read-bencode integers"
      (check (decode "i0e") => 0)
      (check (decode "i42e") => 42)
      (check (decode "i-42e") => -42)
      (check (try (decode "i-42") (catch (e) e)) ? io-error?))
    (test-case "read-bencode lists"
      (check (decode "le") => [])
      (check (decode "li1ei-2ei4ee") => [1 -2 4])
      (check (try (decode "l") (catch (e) e)) ? io-error?)
      (check (try (decode "li42e") (catch (e) e)) ? io-error?))
    (test-case "read-bencode dictionaries"
      (check (decode "de") => (hash))
      (check (decode "d3:ham4:eggse") => (hash ("ham" "eggs")))
      (check (try (decode "d") (catch (e) e)) ? io-error?)
      (check (try (decode "d3:ham") (catch (e) e)) ? io-error?))
    (test-case "read-bencode bytes"
      (check (decode "0:") => "")
      (check (decode "5:hello") => "hello")
      (check (try (decode "5:he") (catch (e) e)) ? io-error?)
      (check (try (decode "5:") (catch (e) e)) ? io-error?))))
