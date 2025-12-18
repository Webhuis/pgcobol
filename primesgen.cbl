       identification division.
       program-id. primesgen.

       environment division.
       configuration section.
       source-computer. linux-laptop.
       object-computer. linux-laptop.
       special-names.
           console is scherm.

       input-output section.
       file-control.
         select fprinter assign to "primes.prt";
         organization line sequential.

       data division.
       file section.
       fd fprinter.
       01 file-buffer pic x(132).

       working-storage section.
       01  filler               pic x(32) value "Start WS primesgen".

       01  printer.
        03 print-buffer     PIC X(132).
        03 line-number      PIC 99 value 99.
        03 page-number      PIC 9999 value zero.

       01  test-quot        pic 9(9).

      *    ui-operations methods and data
      *01 ui-session.
      * 03 ui-methods        pic x(32).
      *  88 start-session    value "start".
      *  88 write-primesui   value "write".
      *  88 display-primesui value "write".
      *  88 stop-session     value "stop".
      * 03 ui-method-result  pic 9(2)  value zero.
      * 03 primes-set.
      *  05 ui-ident        pic 9(9).
      *  05 ui-prime        pic 9(9).

      *    dalcb-operations methods and data
       01 primes.
        03 gen-methods      pic x(32).
         88 query-process   value "query".
         88 start-process   value "start".
         88 next-divider    value "get".
         88 write-prime     value "put".
         88 stop-process    value "stop".
        03 primes-result    pic 9(2)  value zero.
         88 init-primes-ok   value 1.
         88 first-divider-ok value 2.
         88 next-divider-ok  value 3.
      * 03 prime-sequence   pic 9(9).
      * 03 prime-number     pic 9(9).
        03 test-number      pic 9(9).
        03 test-number-sqr  pic 9(9)v9(9).
        03 test-divider     pic 9(9).
        03 test-rest        pic 9(9)v9(9).
        03 old-test-number  pic 9(9).
        03 old-ident        pic 9(9).
        03 new-ident        pic 9(9).

           copy primes-ui.

           copy primes-dal.

       linkage section.

           copy primes-session.

           procedure division using primes-session.
      *                             primes-ui, primes-dal.

           evaluate true

             when report-primes

               perform r90-start-primes-report
               if session-method-ok then
      *           move "report"      to methods
      *           perform r86-report-primes until dal-method-eof
                  perform r86-report-primes until session-method-eof

             when generate-primes

               perform r91-start-primes-generation
               if session-method-ok then
      *           move "generate"   to methods
                  perform r80-test-number until test-number = 999999999

             when other

               move "primesgen"   to program-name
               move "main"        to program-paragraph
               move 'log-message' to methods
               move 'Bad method, primes process failed.'
                 to program-message
               call "primesui" using primes-ui
           end-evaluate.

           perform r99-close-primes.

           exit program.

       r80-test-number.

           divide test-number by test-divider giving test-quot
                  remainder test-rest. 

           evaluate true
           when test-rest = 0
             perform r82-next-test-number
           when test-divider  > test-number-sqr
             perform r85-write-prime
             perform r82-next-test-number
           when other
             perform r89-get-next-divider.

       r82-next-test-number.

           add 2 to test-number.
           compute test-number-sqr = test-number ** 0.5 .
           move 1 to old-ident.
           perform r89-get-next-divider.

       r85-write-prime.

           move 'write'      to ui-methods.
           call "primes" using primes-dal.
           call "primesui" using primes-ui.
      *    display primes-result upon scherm.

       r86-report-primes.

           move 'write'       to ui-methods.
           move primes-data   to u-primes.
           call "primesui" using primes-ui.
           perform r94-fetch.
      *    display prime-number upon scherm.

       r89-get-next-divider.

           move 'get'        to gen-methods.
           call "primes" using primes.

       r90-start-primes-report.

           move 'connect'  to dal-methods.
           call "primes" using primes-dal.

           move "primesgen"   to program-name.
           move "r90-start-primes-report"        to program-paragraph.
           move 'log-message' to ui-methods.

           if dal-method-ok then
             move   'Database initialisation succeeeded.'
               to program-message
             call "primesui" using primes-ui
           else
             move 'Database initialisation failed.'
               to program-message
             call "primesui" using primes-ui
             move 1       to  session-result.

           move 'cursor'      to dal-methods.
           call "primes" using primes-dal.

           move "primesgen"   to program-name.
           move "r90-start-primes-report"        to program-paragraph.
           move 'log-message' to ui-methods.

           if dal-method-ok then
             move   'Cursor initialisation succeeeded.'
               to program-message
             call "primesui" using primes-ui
           else
             move 'Cursor initialisation failed.' to program-message
             call "primesui" using primes-ui
             move 1       to  session-result.

           if dal-method-ok                      then
              perform r94-fetch.

           if dal-method-ok                      then
              move 'Fetch first row ok.' to program-message
              move 0 to dal-result
           else
              move 'Fetch first row nok.' to program-message
                 move 1 to dal-result.

           move 'primesgen'         to program-name.
           call "primesui" using primes-ui.

       r91-start-primes-generation.

           move 'connect'  to dal-methods.
           call "primes" using primes-dal.

           move 'log-message' to ui-methods

           if dal-method-ok then
             move 2 to test-divider
             move 1 to old-ident
             move 3 to test-number
             compute test-number-sqr = test-number ** 0.5 
             move   'Database initialisation succeeeded.'
               to program-message
             call "primesui" using primes-ui
           else
             move 'Database initialisation failed.'
               to program-message
             call "primesui" using primes-ui
             move 1       to  session-result.

       r94-fetch.

           move 'next-prime'   to dal-methods.
           call "primes" using primes-dal.

           move "primesgen"          to program-name.
           move "r94-fetch"          to program-paragraph.
           move 'log-message'        to ui-methods.

           if dal-method-ok then
              next sentence
           else
             move 'Fetch failed.' to program-message
             call "primesui" using primes-ui
             move 1       to  session-result.

       r99-close-primes.

           move 'disconnect' to dal-methods.
           call "primes" using primes.

           move 'log-message' to methods

           if dal-method-ok then
             move   'Database close succeeeded.'
             to program-message
             call "primesui" using primes-ui
           else
             move 'Database close failed.'
               to program-message
             call "primesui" using primes-ui
             move 1       to  session-result.

