       IDENTIFICATION DIVISION.
       PROGRAM-ID. LS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FOUND PIC 9(4) VALUE 0.

       LINKAGE SECTION.
       COPY FILESYSTEM.
       01 TARGET PIC 9(2).
       
       PROCEDURE DIVISION USING FILESYSTEM TARGET.

           IF ESIZE(TARGET) > 0 THEN
               MOVE 0 TO FOUND.
               PERFORM LIST-ENTITIES
                   VARYING I FROM 1 BY 1
                   UNTIL I=16 OR FOUND = ESIZE(TARGET).
           EXIT PROGRAM.

       LIST-ENTITIES.
           IF EPARENT(I)=EID(TARGET) THEN
               DISPLAY FUNCTION TRIM(ENAME(I)) NO ADVANCING

               IF ETYPE(I)=1 THEN
                   DISPLAY "/" NO ADVANCING
               END-IF

               DISPLAY " " NO ADVANCING
               DISPLAY ESIZE(I)
               ADD 1 TO FOUND.
