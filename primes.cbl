       identification division.
       program-id. primes.

       environment division.
       configuration section.
       source-computer. linux-laptop.
       object-computer. linux-laptop.
       special-names.
           console is scherm.

       data division.
       working-storage section.
       01  filler               pic x(32) value "Start WS primes".
       01 DATASRC PIC X(64) value
          "pgsql://localhost:5432/primes&default_schema=primes".
       01 DBUSR     PIC X(64)  value "primes_user".
       01 DBPWD     PIC X(64)  value "pr1mes_user".
       01 CUR-STEP    PIC X(16).
       01 primes-row.
        03 r-ident          pic 9(9) comp-3.
        03 r-prime          pic 9(9) comp-3.
       01 prime-count       pic 9(9).
       01 prime_seq         pic 9(9).
       01 divider           pic 9(9).

       01 primes.
        03 primes-result    pic 9(2)  value zero.
         88 init-primes-ok   value 1.
         88 first-divider-ok value 2.
         88 next-divider-ok  value 3.
        03 test-number      pic 9(9).
        03 test-number-sqr  pic 9(9)v9(9).
        03 test-divider     pic 9(9).
        03 test-rest        pic 9(9)v9(9).
        03 old-test-number  pic 9(9).
        03 old-ident        pic 9(9).
        03 new-ident        pic 9(9).

       EXEC SQL
           INCLUDE primes-table
       END-EXEC.

       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.

       EXEC SQL AT primes
           DECLARE primescursor CURSOR FOR
             SELECT * FROM primes
       END-EXEC.

           copy primes-ui.

       linkage section.

           copy primes-dal.

           procedure division using primes-dal.

           evaluate true
             when next-prime
               perform r80-get-next-prime
             when next-divider
               perform r81-get-next-divider
             when write-prime
               perform r83-write-prime
             when db-connect
               perform s00-connect
             when db-cursor
               perform s01-cursor
             when db-disconnect
               perform s99-disconnect
             when other
               move 1 to dal-result
           end-evaluate.
  
           exit program.

       r80-get-next-prime.

           perform s02-fetch.

       r81-get-next-divider.

           add 1 to old-ident giving new-ident.
      *    display "gen-methods: " gen-methods.
      *    display "primes.cbl ident: " old-ident " " new-ident.

           EXEC SQL at primes
             SELECT prime INTO :test-divider FROM primes
                    WHERE ident = :new-ident
           END-EXEC.

           if SQLCODE = 0   then
             next sentence
      *      display "select new-divider ok: " test-divider upon scherm
           else
             display SQLCODE upon scherm
             display "select new-divider nok" upon scherm.

      *    display "primes.cbl test-divider: " test-divider.

           move new-ident to old-ident.

       r83-write-prime.

           EXEC SQL at primes
             INSERT INTO primes ( prime ) VALUES ( :prime )
           END-EXEC.

           if SQLCODE = 0   then
             next sentence
      *      display SQLCODE upon scherm
      *      display "primes.cbl insert next prime and new-ident ok: "
      *               prime-number upon scherm
           else
             display SQLCODE upon scherm
             display "primes.cbl insert next prime nok: "
                      prime-number upon scherm.


      *    EXEC SQL at primes
      *      COMMIT
      *    END-EXEC.

           if SQLCODE = 0   then
             next sentence
      *      display SQLCODE upon scherm
      *      display "commit ok: " upon scherm
           else
             display SQLCODE upon scherm
             display "commit nok: " upon scherm.

       r90-generate-primes.

           perform s00-connect.

           if dal-method-ok                      then

             move 'log-message' to process-message

             EXEC SQL at primes
               insert into primes ( prime ) values ( 2 )
             END-EXEC.

             if SQLCODE = 0   then
               move 0 to dal-result
               move 1 to primes-sequence
               move 2 to prime-number
               move 'Initial insert ok.'
                 to process-message
             else
               move
                'Initial insert failed, terminating program.'
                 to process-message
               move 1 to dal-result.
 
           move 'log-message' to program-message.
           call "primesui" using primes-ui.



       r99-stop-primes.

           perform s99-disconnect.

       s00-connect.
           MOVE 'CONNECT' TO CUR-STEP.
           EXEC SQL
              connect TO :DATASRC AS primes USER :DBUSR USING :DBPWD
           END-EXEC.
           move 'log-message' to process-message.
           if SQLCODE = 0   then
              move 0 to dal-result
              move 'Database initialisation ok.'
              to program-message
               call "primesui" using primes-ui
           else
              move
               'Database initialisation failed, terminating program.'
               to program-message
               call "primesui" using primes-ui
               move 1 to dal-result.

       s01-cursor.

           move 'primes'            to program-name.

           EXEC SQL at primes START TRANSACTION END-EXEC.

           if SQLCODE = 0   then
              move 'Start transaction ok.'
                to program-message
           else
              move 'Start transaction nok.'
                to program-message
              move 1 to dal-result.

           move 'log-message' to program-message.
           call "primesui" using primes-ui.

      *      display "start transaction nok" upon scherm.

           if dal-method-ok                      then

             EXEC SQL OPEN primescursor END-EXEC.

              if SQLCODE = 0   then
                 move 'Start primescursur ok.'
                   to program-message
              else
                 move 'Start primescursor nok.'
                   to program-message
                 move 1 to dal-result.


           move 'primes'            to program-name.
           move 'log-message' to program-message.
           call "primesui" using primes-ui.

      *    if dal-method-ok                      then
      *       perform s02-fetch.

      *    if SQLCODE = 0   then
      *       move 'Fetch first row ok.' to program-message
      *       move 0 to dal-result
      *       move r-ident     to    primes-sequence
      *       move r-prime     to    prime-number
      *    else
      *       move 'Fetch first row nok.' to program-message
      *          move 1 to dal-result.

      *    move 'primes'            to program-name.
      *    move 'log-message' to program-message.
      *    call "primesui" using primes-ui.

       s02-fetch.

           EXEC SQL FETCH primescursor INTO :primes-row END-EXEC.

           if SQLCODE = 0   then
              move r-ident     to    primes-sequence
              move r-prime     to    prime-number
              move 0 to dal-result
           else
              move 'Fetch row nok.' to program-message
              move 1 to dal-result
              move 'primes'            to program-name
              move 's02-fetch'         to program-paragraph
              move 'log-message' to ui-methods
              call "primesui" using primes-ui.

       s99-disconnect.

           MOVE 'DISCONNECT' TO CUR-STEP.
           EXEC SQL connect RESET primes END-EXEC.

           move 'log-message' to process-message.

           if SQLCODE = 0   then
              move 0 to dal-result
              move 'Close database ok.'
              to process-message
               call "primesui" using primes-ui
           else
               move 'Database initialisation failed, ending program.'
               to process-message
               call "primesui" using primes-ui
               move 1 to dal-result.
           display "s99 disconnect from database" upon scherm.
           display SQLCODE upon scherm.
