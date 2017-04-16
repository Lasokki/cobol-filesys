       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHANGE-DIRECTORY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FOUND-KIDS PIC 9(4) VALUE 0.
       01 FOUND-FLAG PIC 9(1) VALUE 0.
       01 TARGET-IND PIC 9(2).
       COPY ERRORDEF.

       LINKAGE SECTION.
       COPY FILESYSTEM.
       01 CURRENT-ID PIC 9(2).
       01 CURRENT-IND PIC 9(2).
       01 TARGET-NAME PIC N(16).
       
       PROCEDURE DIVISION USING FILESYSTEM
               CURRENT-ID CURRENT-IND TARGET-NAME.
           
           IF ESIZE(CURRENT-IND) > 0 THEN
               MOVE 0 TO FOUND-FLAG
               MOVE 0 TO FOUND-KIDS
               MOVE 0 TO TARGET-IND

               PERFORM FIND-DIR
                   VARYING I FROM 1 BY 1
                   UNTIL I=16 OR FOUND-KIDS = ESIZE(CURRENT-IND)
                   OR FOUND-FLAG=1
           END-IF

           IF FOUND-FLAG=1 THEN
               MOVE EID(TARGET-IND) TO CURRENT-ID
               MOVE TARGET-IND TO CURRENT-IND
           ELSE
               DISPLAY ERRORMSG
           END-IF

           EXIT PROGRAM.   
           
       FIND-DIR.
           IF EPARENT(I)=CURRENT-ID THEN
               IF ENAME(I)=TARGET-NAME THEN
                   MOVE 1 TO FOUND-FLAG
                   MOVE I TO TARGET-IND
               END-IF
           END-IF.
