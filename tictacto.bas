1   ! TITTOE.BAS  19-Sep-81  01:07 PM
100   ! THE GAME OF TIT-TAT-TOE
      ! BASIC PLUS - FALL 1976 - PROGRAMMED BY MGPOOLE(171,0)
      ! THIS IS TITTOE.BAS AS CREATED ON 20-SEP-76
      !
      ! extended to Vax Basic during Nov 1984

      PRINT
      PRINT "The Game of Tit-Tat-Toe -- Computer vs Human"
      PRINT
      PRINT "The computer assumes you know how to play the game."
      PRINT "Each square of the board is given a code as"
      PRINT "indicated below."
      PRINT
      N$ = "-----------"
      PRINT "      1 : 2 : 3"
      PRINT "     "; N$
      PRINT "      4 : 5 : 6"
      PRINT "     "; N$
      PRINT "      7 : 8 : 9"
      PRINT
      PRINT "To make a move on a square, enter the"
      PRINT "code number for that square."

      !
      !   PROGRAM INTIALIZATION
      !
      RANDOMIZE
      G9% = 0%
      IF RND < 0.5 THEN F9% = 0% ELSE F0% = 1% END IF
      S1%, S2%, S3% = 0%
      DIM B$(9), Z%(4), T%(8%)
      MAT READ Z%
      MAT READ T%
      DATA         &
         1,3,7,9,  &
         14,112,896,146,292,584,546,168

280 RESTORE
295 N$="-----------"
300   !
      !   GAME INTIALIZATION - HUMAN INPUT
      !
      C% = 0%
      B$(B%) = " " FOR B% = 1% TO 9%
      G9% = G9% + 1%
      F9% = F9% + 1%
      PRINT
      PRINT "GAME"; G9%
      PRINT
      W1$, W2$ = "X"
      GOTO 390 IF F9% = F9%/2%*2%
      PRINT "You are X; the computer is O.  You move first."
      W1$ = "O"
330   INPUT "Enter your move"; M$
      IF LEN(M$)>1% OR M$ < "1" OR M$ > "9" THEN
         PRINT"ERROR - Invalid Entry"
         PRINT"Enter only a digit between 1 and 9."
         GOTO 330
340   M% = VAL(M$)
      IF B$(M%) <> " " THEN
         PRINT "ERROR - Position"; M%; "already taken."
         GOTO 330
350   C% = C% + 1%
      B$(M%) = "H"
      GOTO 400
390   W2$ = "O"
      PRINT "The computer is X; you are O.  Computer moves first."

400   !
      ! COMPUTERS MOVE
      !
      C% = C% + 1%
      M% = FNM%(C%)
      IF M% = 0% THEN PRINT "Computer concedes - you win"
      S2% = S2% + 1%
      PRINT
      GOTO 440
420   PRINT"Computer moves "; W1$; " in position"; ABS(M%);
      IF M% < 0% THEN PRINT " AND WINS!!!"
         S1% = S1% + 1%
         GOSUB 500
         GOTO 440
430   B$(ABS(M%)) = "C"
      PRINT
      G$ = FNG$
      IF C%=8% THEN PRINT "Your last move must be "; G$
         B$(VAL(G$))="H"
435   PRINT"The game is a draw." IF C%>=8%
      GOSUB 500
      GOTO 330 IF C%<8%
      S3% = S3% + 1%
440   PRINT"SCORE:   Computer"; S1%; "   Human"; S2%; "   Cat"; S3%
      PRINT
      INPUT "Do you want another game"; A$
450   A$ = edit$( A$, 2%+32%)
      GOTO 300 IF A$="YES"
      IF A$="NO" THEN PRINT"Bye"
      GOTO 999
460   INPUT"Enter YES or NO";A$
      GOTO 450

500 !
501 !   OUTPUT OF BOARD POSITION
502 !
510 DIM B9$(9)
    FOR B% = 1% TO 9%
       IF B$(B%)="C" THEN B9$(B%) = W1$ ELSE
          IF B$(B%)="H" THEN B9$(B%) = W2$ ELSE B9$(B%) = " "
515 NEXT B%
520 PRINT
    PRINT"      "; B9$(1%); " : "; B9$(2%); " : "; B9$(3%)
    PRINT"     "; N$
    PRINT"      "; B9$(4%); " : "; B9$(5%); " : "; B9$(6%)
    PRINT"     "; N$
    PRINT"      "; B9$(7%); " : "; B9$(8%); " : "; B9$(9%)
    PRINT
    RETURN
600 !
601 !   THE MOVE FUNCTION
602 !
610 DEF FNM%(C%)
    R%=INT(10*RND)
    R4%=INT(4*RND)+1%
    GOTO 620 IF C%>1%
    FNM% = 5% IF R%<=3%
    FNM% = Z%(R4%) IF 4 <= R% AND R% <= 7%
    FNM% = 2%*R4% IF R% = 8% OR R% = 9%
    GOTO 710
620 GOTO 660 IF C% > 2%
    GOTO 640 IF B$(5%) = "H"
    IF R% <= 4% THEN FNM% = 5%
    GOTO 710
630 G$=FNG$
    R1%=INT(LEN(G$)*RND)+1%
    FNM%=VAL(MID(G$,R1%,1%))
    GOTO 710
640 IF RND < .75 THEN FNM% = Z%(R4%) ELSE FNM% = 2%*R4%
650 GOTO 710
660 GOTO 630 IF C% = 3%
    GOTO 700 IF C% > 4%
670 L$=FNL$
    GOTO 630 IF L$=""
    G$=FNG$
    IF L$=G$ THEN FNM%=0%
    GOTO 710
680 T$=""
    FOR G% = 1% TO LEN(G$)
    J$=MID(G$,G%,1%)
    T$=T$+J$ IF INSTR(1%,L$,J$)=0%
    NEXT G%
690 R2%=INT(LEN(T$)*RND)+1%
    FNM%=VAL(MID(T$,R2%,1%))
    GOTO 710
700 W$=FNW$
    GOTO 670 IF W$=""
    FNM%=-VAL(W$)
710 FNEND
800 !
801 !   THE WIN, LOSE AND LEGAL MOVE FUNCTIONS
802 !
810 DEF FNG$
820 T$=""
    FOR B% = 1% TO 9%
    T$=T$+FND$(B%) IF B$(B%)=" "
    NEXT B%
825 FNG$=T$
    FNEND
830 DEF FNW%(D$)
    W%=0%
    FOR A% = 1% TO 9%
    W%=W%+2%^A% IF B$(A%)=D$
    NEXT A%
835 FOR T% = 1% TO 8%
    IF T%(T%)=(T%(T%) AND W%) THEN T9%=-1%
       GOTO 850
840 NEXT T%
    T9%=0%
850 FNW%=T9%
    FNEND
860 DEF FNW$
870 FOR Y% = 1% TO 9%
    GOTO 880 IF B$(Y%)<>" "
    B$(Y%)="C"
    IF FNW%('C')=0% THEN B$(Y%)=" " ELSE FNW$=FND$(Y%)
       GOTO 890
880 NEXT Y%
      FNW$=""
890   FNEND
900   DEF FNL$
910   T$ = ""
      FOR B1% =1% TO 9%
      GOTO 930 IF B$(B1%) <> " "
      B$(B1%)="C"
912   FOR B0% = 1% TO 9%
      GOTO 920 IF B$(B0%) <> " "
      B$(B0%) = "H"
914   IF FNW%("H") = -1% THEN T$ = T$ + FND$(B1%)
      B$(B0%) = " "
      B$(B1%) = " "
      GOTO 930
916   B$(B0%) = " "
920   NEXT B0%
      B$(B1%) = " "
930   NEXT B1%
940   FNL$ = T$
      FNEND
990   DEF FND$(X%) = NUM1$(X%)
999   END
