      *    three-tier-operations methods
      *    business session tier
       01 primes-session.
        03 methods                 pic x(32).
         88 report-primes          value "report".
         88 generate-primes        value "generate".
         88 start-primes           value "start".
         88 stop-primes            value "stop".
         88 invalid-method         value "bad".
      * 03  primes-data.
      *  05 primes-sequence        pic 9(9).
      *  05 prime-number           pic 9(9).
        03  session-result         pic 9(2)  value zero.
         88 session-method-ok      value 0.
         88 session-method-nok     value 1.
         88 session-method-eof     value 9.
