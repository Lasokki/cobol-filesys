      * Filesystem table for SOS
       01 FILESYSTEM.
           05 ENTITY OCCURS 16 TIMES INDEXED BY I.
               10 EID PIC 9(2) VALUE 0. *> 0 for unassigned, 1-16 for other
               10 ETYPE PIC 9(1). *> 0 for file, 1 for directory
                   88 EFILE VALUE 0.
                   88 EDIR VALUE 1.
               10 EPARENT PIC 9(2).
               10 ENAME PIC N(16).
               10 ESIZE PIC 9(4).
