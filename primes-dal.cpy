      *    three-tier-operations methods
      *    business dal tier
       01 primes-dal.
        03 dal-methods             pic x(32).
         88 next-prime             value "next-prime".
         88 next-divider           value "next-divider".
         88 write-prime            value "write".
         88 db-cursor              value "cursor".
         88 db-connect             value "connect".
         88 db-disconnect          value "disconnect".
         88 invalid-method         value "bad".
        03  primes-data.
         05 primes-sequence        pic 9(9).
         05 prime-number           pic 9(9).
        03  dal-result             pic 9(2)  value zero.
         88 dal-method-ok          value 0.
         88 dal-method-nok         value 1.
         88 dal-method-eof         value 99.
      * 03 primes-table.
      *  05 ident                  pic s9(9).
      *  05 prime                  pic s9(9).
 
