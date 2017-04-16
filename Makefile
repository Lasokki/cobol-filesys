compile:
	cobc -std=cobol2002 -m -o MFMD MFMD.cob && cobc -std=cobol2002 -m -o LS LS.cob && cobc -std=cobol2002 -m -o CHANGE-DIRECTORY CD.cob && cobc -std=cobol2002 -x -o sos sos.cob 

clean:
	rm sos MFMD.so LS.so
