       IDENTIFICATION DIVISION.
       PROGRAM-ID. MFMD.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FOUND PIC 9(4) VALUE 0.
       01 NAMECONFLICT PIC 9(1) VALUE 0.
       COPY ERRORDEF.

       LINKAGE SECTION.
       COPY FILESYSTEM.
       01 NEW-TYPE PIC 9(1).
           88 NEW-FILE VALUE 0.
           88 NEW-DIR VALUE 1.
       01 NEW-ID PIC 9(2).
       01 NEW-NAME PIC N(16).
       01 NEW-SIZE PIC 9(4).
       01 NEW-IND PIC 9(2).      
       01 TARGET-ID PIC 9(2).
       01 TARGET-IND PIC 9(2).
       
       PROCEDURE DIVISION USING FILESYSTEM
               NEW-TYPE
               TARGET-ID TARGET-IND
               NEW-ID NEW-IND
               NEW-NAME NEW-SIZE.

           MOVE 0 TO NAMECONFLICT.
           MOVE 0 TO FOUND.
           
           IF ESIZE(TARGET-IND) > 0 THEN
               MOVE 0 TO FOUND
               PERFORM CHECK-NAME
                   VARYING I FROM 1 BY 1
                   UNTIL I=16 OR FOUND = ESIZE(TARGET-IND)
                   OR NAMECONFLICT=1
           END-IF

           IF NAMECONFLICT=0 THEN
               IF NEW-FILE THEN
                   MOVE NEW-ID TO EID(NEW-IND)
                   MOVE NEW-TYPE TO ETYPE(NEW-IND)
                   MOVE TARGET-ID TO EPARENT(NEW-IND)
                   MOVE NEW-NAME TO ENAME(NEW-IND)
                   MOVE NEW-SIZE TO ESIZE(NEW-IND)
                   ADD 1 TO ESIZE(TARGET-IND)
               ELSE
                   MOVE NEW-ID TO EID(NEW-IND)
                   MOVE NEW-TYPE TO ETYPE(NEW-IND)
                   MOVE TARGET-ID TO EPARENT(NEW-IND)
                   MOVE NEW-NAME TO ENAME(NEW-IND)
                   ADD 1 TO ESIZE(TARGET-IND)
               END-IF
               ADD 1 TO NEW-IND
           ELSE
               DISPLAY ERRORMSG
           END-IF

           EXIT PROGRAM.   
           
       CHECK-NAME.
           IF EPARENT(I)=TARGET-ID THEN
               IF ENAME(I)=NEW-NAME THEN
                   MOVE 1 TO NAMECONFLICT
               END-IF
               ADD 1 TO FOUND.

