(import :std/test
        "bencode-test")

(run-tests! bencode-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))
