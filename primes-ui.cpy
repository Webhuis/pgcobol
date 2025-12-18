      *    three-tier-operations methods
      *    ui part, methods available to all objects
       01 primes-ui.
        03 ui-methods              pic x(32).
         88 write-ui               value "write".
         88 message-ui             value "log-message".
         88 start-ui               value "start".
         88 stop-ui                value "stop".
        03 process-message.
         05 program-name           pic x(20).
         05 program-line.
          07 program-paragraph     pic x(20).
          07 program-message       pic x(92).
        03 u-primes.
         05 u-sequence             pic 9(9).
         05 u-number               pic 9(9).
        03 ui-method-result        pic 9(2)  value zero.
         88 ui-method-ok           value 0.
         88 ui-method-nok          value 1.
