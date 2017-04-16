       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMINAL-EMULATOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 USERINPUT PIC A(30).
       01 CMD PIC A(4).
       01 US-ARG1 PIC A(13).
       01 US-ARG2 PIC X(13).
       01 ARG1-COUNT PIC 9(2).
       01 ARG2-COUNT PIC 9(2).
       
       01 CURRENT-DIRECTORY PIC N(30).
       01 CURRENT-EID PIC 9(2) VALUE 0.
       01 CUR-IND PIC 9(2) VALUE 0.
       01 EID-COUNTER PIC 9(2) VALUE 1.

       01 SOS-PROMPT PIC N(40) .
       01 DIR-SEPARATOR PIC N(1) VALUE "/".
       01 PROMPT-END PIC N(1) VALUE ">".

      * FOR MF
       01 NEW-NAME PIC N(16).
       01 NEW-SIZE PIC 9(4).
       01 NEW-IND PIC 9(2).

       01 FILE-CODE PIC 9(1) VALUE 0.
       01 DIR-CODE PIC 9(1) VALUE 1.
       
       COPY FILESYSTEM.
       COPY ERRORDEF.

       01 EXIT-FLAG PIC 9(1) VALUE 0.

      * Processing of input 
       PROCEDURE DIVISION.

           MOVE 1 TO CUR-IND.
           MOVE 2 TO NEW-IND.
           *> Initialize root
           MOVE EID-COUNTER TO EID(CUR-IND).
           MOVE DIR-CODE TO ETYPE(CUR-IND).
           MOVE "/" TO ENAME(CUR-IND).
           MOVE 0 TO ESIZE(CUR-IND).
           MOVE EID(1) TO CURRENT-EID.
           MOVE "/" TO CURRENT-DIRECTORY.
           ADD 1 TO EID-COUNTER.
           
           DISPLAY "Welcome to SOS.".

           STRING CURRENT-DIRECTORY DELIMITED BY SPACE,
               PROMPT-END DELIMITED BY SPACE
               INTO SOS-PROMPT.
           
       MAIN-LOOP.
           PERFORM READ-INPUT UNTIL EXIT-FLAG EQUALS 1 
           STOP RUN.

       READ-INPUT.

           STRING CURRENT-DIRECTORY DELIMITED BY SPACE,
               PROMPT-END DELIMITED BY SPACE
               INTO SOS-PROMPT.
           
           *> STRING CURRENT-DIRECTORY DELIMITED BY SPACE,
           *>     DIR-SEPARATOR DELIMITED BY SPACE,
           *>     "asdf" DELIMITED BY SPACE,
           *>     DIR-SEPARATOR DELIMITED BY SPACE,
           *>     PROMPT-END DELIMITED BY SPACE
           *>     INTO SOS-PROMPT
           *> MOVE "asdf" TO CURRENT-DIRECTORY

           DISPLAY FUNCTION TRIM(SOS-PROMPT) NO ADVANCING.

           ACCEPT USERINPUT.

           UNSTRING USERINPUT DELIMITED BY SPACE
               INTO CMD US-ARG1 US-ARG2.

           *> An empty argument has 13 spaces, as much as is the size of ARG1/ARG2
           MOVE 0 TO ARG1-COUNT ARG2-COUNT
           INSPECT US-ARG1 TALLYING ARG1-COUNT FOR ALL SPACE.           
           INSPECT US-ARG2 TALLYING ARG2-COUNT FOR ALL SPACE.
           
           EVALUATE TRUE
               WHEN CMD EQUALS "md"
                   IF ARG1-COUNT < 13 AND ARG2-COUNT = 13 THEN
                       MOVE US-ARG1 TO NEW-NAME

                       CALL "MFMD" USING FILESYSTEM DIR-CODE
                           CURRENT-EID CUR-IND
                           EID-COUNTER NEW-IND NEW-NAME
                   ELSE
                       DISPLAY ERRORMSG

               WHEN CMD EQUALS "mf"
                   IF ARG1-COUNT < 13 AND ARG2-COUNT < 13 THEN
                       MOVE US-ARG1 TO NEW-NAME
                       MOVE US-ARG2 TO NEW-SIZE
                       CALL "MFMD" USING FILESYSTEM FILE-CODE
                           CURRENT-EID CUR-IND
                           EID-COUNTER NEW-IND NEW-NAME NEW-SIZE
                   ELSE
                       DISPLAY ERRORMSG

               WHEN CMD EQUALS "cd"
                   IF ARG1-COUNT < 13 AND ARG2-COUNT = 13 THEN
                       MOVE US-ARG1 TO NEW-NAME
                       
                       CALL "CHANGE-DIRECTORY" USING FILESYSTEM
                           CURRENT-EID CUR-IND NEW-NAME
                   ELSE
                       DISPLAY ERRORMSG
                   
               WHEN USERINPUT EQUALS "ls"
                   CALL "LS" USING FILESYSTEM CURRENT-EID
               WHEN USERINPUT EQUALS "find"
                   DISPLAY "\n"
               WHEN USERINPUT EQUALS "rm"
                   DISPLAY "\n"
               WHEN USERINPUT EQUALS "cp"
                   DISPLAY "\n"
               WHEN USERINPUT EQUALS "mv"
                   DISPLAY "\n"
               WHEN USERINPUT EQUALS "exit"
                   DISPLAY "Shell terminated."
                   SET EXIT-FLAG TO 1
               WHEN OTHER
                   DISPLAY ERRORMSG
           END-EVALUATE.
