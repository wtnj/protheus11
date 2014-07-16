#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhacfun1()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

DbSelectArea("SRA")
SRA->(DbgoTop())
While SRA->(!Eof())
// 1
   if (SRA->RA_MAT == "000093" )
       SRA->RA_RACACOR := "8"
   endif
//2
   if (SRA->RA_MAT == "000268" )
       SRA->RA_RACACOR := "8"
   endif
//3
   if (SRA->RA_MAT == "000283" )
       SRA->RA_RACACOR := "8"
   endif                    
//4
   if (SRA->RA_MAT == "000309" )
       SRA->RA_RACACOR := "8"
   endif
//5
   if (SRA->RA_MAT == "000311" )
       SRA->RA_RACACOR := "8"
   endif
//6
   if (SRA->RA_MAT == "000479" )
       SRA->RA_RACACOR := "8"
   endif
//7
   if (SRA->RA_MAT == "000169" )
       SRA->RA_RACACOR := "8"
   endif
//8
   if (SRA->RA_MAT == "000637")
       SRA->RA_RACACOR := "8"
   endif
//9
   if (SRA->RA_MAT == "000661" )
       SRA->RA_RACACOR := "8"
   endif
//10
   if (SRA->RA_MAT == "000664" )
       SRA->RA_RACACOR := "8"
   endif
//11
   if (SRA->RA_MAT == "000667" )
       SRA->RA_RACACOR := "8"
   endif
//12
   if (SRA->RA_MAT == "000668" )
       SRA->RA_RACACOR := "8"
   endif
//13
   if (SRA->RA_MAT == "000669" )
       SRA->RA_RACACOR := "8"
   endif
//14
   if (SRA->RA_MAT == "000676" )
       SRA->RA_RACACOR := "8"
   endif
//15
   if (SRA->RA_MAT == "000680" )
       SRA->RA_RACACOR := "8"
   endif
//16
   if (SRA->RA_MAT == "000705" )
       SRA->RA_RACACOR := "8"
   endif
//17
   if (SRA->RA_MAT == "000721" )
       SRA->RA_RACACOR := "8"
   endif
//18
   if (SRA->RA_MAT == "000726" )
       SRA->RA_RACACOR := "8"
   endif
//19
   if (SRA->RA_MAT == "000745" )
       SRA->RA_RACACOR := "8"
   endif
//20
   if (SRA->RA_MAT == "000758" )
       SRA->RA_RACACOR := "8"
   endif
//21
   if (SRA->RA_MAT == "000776" )
       SRA->RA_RACACOR := "8"
   endif
//22
   if (SRA->RA_MAT == "000796" )
       SRA->RA_RACACOR := "8"
   endif
//23
   if (SRA->RA_MAT == "000822" )
       SRA->RA_RACACOR := "8"
   endif
//24
   if (SRA->RA_MAT == "000866" )
       SRA->RA_RACACOR := "8"
   endif
//25
   if (SRA->RA_MAT == "000869" )
       SRA->RA_RACACOR := "8"
   endif
//26
   if (SRA->RA_MAT == "000896" )
       SRA->RA_RACACOR := "8"
   endif
//27
   if (SRA->RA_MAT == "000903" )
       SRA->RA_RACACOR := "8"
   endif
//28
   if (SRA->RA_MAT == "000956" )
       SRA->RA_RACACOR := "8"
   endif
//29
   if (SRA->RA_MAT == "000958" )
       SRA->RA_RACACOR := "8"
   endif
//30   
   if (SRA->RA_MAT == "000968" )
       SRA->RA_RACACOR := "8"
   endif
//31
   if (SRA->RA_MAT == "000974" )
       SRA->RA_RACACOR := "8"
   endif
//32
   if (SRA->RA_MAT == "000996" )
       SRA->RA_RACACOR := "8"
   endif
//33
   if (SRA->RA_MAT == "001049" )
       SRA->RA_RACACOR := "8"
   endif

//34
   if (SRA->RA_MAT == "001063" )
       SRA->RA_RACACOR := "8"
   endif

//35
   if (SRA->RA_MAT == "001078" )
       SRA->RA_RACACOR := "8"
   endif
//36
   if (SRA->RA_MAT == "001090" )
       SRA->RA_RACACOR := "8"
   endif

//37
   if (SRA->RA_MAT == "001097" )
       SRA->RA_RACACOR := "8"
   endif


   SRA->(DbSkip())
Enddo
   MsgInfo("Encerrado")
Return
