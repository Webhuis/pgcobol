       identification division.
       program-id. primesmain.

       environment division.
       configuration section.
       source-computer. linux-laptop.
       object-computer. linux-laptop.
       special-names.
           console is scherm.

       data division.
       working-storage section.
       01  filler               pic x(32) value "Start WS primesmain".
       01  commandline-args     pic x(32).
         88 execute-generate    value "generate".
         88 execute-report      value "report".

           copy primes-session.

           copy primes-ui.

       procedure division.

           accept commandline-args from command-line.
           move commandline-args to methods.
           move 'primesmain' to program-name.

           perform r90-start-session.

           evaluate true

             when report-primes

               move 'log-message' to ui-methods
               move 'Primes report generation starts.'
               to program-message
               call "primesui" using primes-ui

               move "report"    to methods

               perform r92-generate-primes

             when generate-primes

               move 'log-message' to ui-methods
               move 'Primes generation starts.'
               to process-message
               call "primesui" using primes-ui
             
               move 'generate' to methods
      *        perform r92-generate-primes

             when other

               move 'log-message' to ui-methods
               move 'Bad parameter, program initialisation failed.'
               to program-message
               call "primesui" using primes-ui

               move 'stop'     to ui-methods
               perform r99-stop-session

               stop run

           end-evaluate.

           move 'log-message' to ui-methods.
           move 'Primes run complete, program stops.'
           to program-message.
           call "primesui" using primes-ui.

           move 'stop'     to methods.
           perform r99-stop-session.
 
           stop run.

       r90-start-session.
            
           move 'start-session' to program-paragraph.
           move 'start'         to ui-methods.

           call "primesui" using primes-ui.

           if ui-method-ok                  then
    
             move 'log-message' to ui-methods
             move 'UI initialisation succeeded.'
             to program-message
             call "primesui" using primes-ui
    
           else
    
             display "Emergency console message program stops."
                upon scherm
             stop run.
    
           move 'log-message' to ui-methods.
           move commandline-args to program-message.
           call "primesui" using primes-ui.

       r92-generate-primes.

           call "primesgen" using primes-session.

       r99-stop-session.

           move 'stop' to ui-methods.
           call "primesui" using primes-ui.

