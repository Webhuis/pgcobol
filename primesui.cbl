       identification division.
       program-id. primesui.

       environment division.
       configuration section.
       source-computer. linux-laptop.
       object-computer. linux-laptop.
       special-names.
           console is scherm.

       input-output section.
       file-control.
         select fprinter assign to "primes.prt"
                organization is sequential
                file status is primes-prt-status.

       data division.
       file section.
       fd fprinter
            label records omitted
            linage 56,
            footing 2,
      *     top     2,
            bottom  2.
       01 file-buffer        pic x(132).

       working-storage section.
       01  filler               pic x(32) value "start ws primesui".

       01 primes-table.
        03 primes-cel         occurs 6 indexed primes-idx.
         05 t-ident           pic z(9).
         05 filler            pic x(2).
         05 t-prime           pic z(9).
         05 filler            pic x(2).
       01 table-header.
        03 cel-header         occurs 6.
         05 filler            pic x(9) value 'Sequence'.
         05 filler            pic x(2) value space.
         05 filler            pic x(9) value 'Prime'.
         05 filler            pic x(2) value space.

       01  printer.
        03 print-buffer      pic x(132).
        03 primes-prt-status pic x(2).
        03 page-number       pic 9(4) value 1.
        03 print-new-page    pic 9    value 1.
         88 new-page                  value 1.

       01 primes-heading.
        03 filler            pic x(118) value 'primes overview'.
      * 03 filler            pic x(06)  value 'page: '.
      * 03 page-number       pic z(3)9  value 1.

       01 primes-footing.
        03 filler            pic x(118) value space.
        03 filler            pic x(06)  value 'page: '.
        03 f-page-number     pic z(3)9  value 1.

       01 primes-line.
        03 primes-row     pic x(132).

       01 primes-total.
           03 primes-count   pic 9(8).

       linkage section.

           copy primes-ui.

       procedure division using primes-ui.

      *    move 'primesui'   to program-name.

           evaluate true
             when start-ui
               perform r90-start-primesui
             when write-ui
               perform r92-write-primesui
             when stop-ui
               perform r99-stop-primesui
             when message-ui
               perform r98-message-ui
             when other
               move 1 to ui-method-result
           end-evaluate.

           exit program.

       r90-start-primesui.

           move 'start-primesui' to program-paragraph.
           move 'start-printer' to program-message

           open output fprinter.

           if primes-prt-status  =    '00'             then
             move 0              to   ui-method-result
             set primes-idx to 1
             move 'Open printer Ok' to program-message
             perform r98-message-ui
           else
             move 1 to ui-method-result
             move 'Open printer Nok' to program-message
             display primes-prt-status upon scherm.

       r92-write-primesui.

           move u-sequence         to   t-ident(primes-idx)
           move u-number           to   t-prime(primes-idx)
           set  primes-idx         up by 1.
           if  new-page                 then
               perform r93-new-page.

           if  primes-idx          = 7                then
               move primes-table   to   print-buffer
               write file-buffer   from print-buffer
               set primes-idx      to 1.
           if  linage-counter      =    53            then
               perform r94-eop.

       r93-new-page.

           move primes-heading to   print-buffer
           write file-buffer   from print-buffer
      *    after advancing page
           move table-header   to   print-buffer
           write file-buffer   from print-buffer
           move  zero          to   print-new-page.

       r94-eop.

           move page-number     to f-page-number.
           move ' '             to print-buffer.
           write file-buffer    from print-buffer.
           move primes-footing  to print-buffer.
           write file-buffer    from print-buffer.
           add    1             to page-number.
           move   1             to print-new-page.

       r98-message-ui.

           display process-message upon scherm.

       r99-stop-primesui.

           move 0               to u-sequence.
           move 0               to u-number.
           perform r92-write-primesui until new-page.
           move 'stop-primesui' to program-paragraph.
           move 'close printer' to program-message.
           perform r98-message-ui

           close fprinter.

           move primes-prt-status to ui-method-result.
           if primes-prt-status = '00' then
             next sentence
           else
             display primes-prt-status upon scherm.

