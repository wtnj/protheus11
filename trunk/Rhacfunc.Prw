#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhacfunc()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

DbSelectArea("SRA")
SRA->(DbgoTop())
While SRA->(!Eof())
// 1
   if (SRA->RA_MAT == "000595" )
       SRA->RA_RACACOR := "6"
   endif
//2
   if (SRA->RA_MAT == "000139" )
       SRA->RA_RACACOR := "6"
   endif
//3
   if (SRA->RA_MAT == "000016" )
       SRA->RA_RACACOR := "4"
   endif                    
//4
   if (SRA->RA_MAT == "000047" )
       SRA->RA_RACACOR := "4"
   endif
//5
   if (SRA->RA_MAT == "000128" )
       SRA->RA_RACACOR := "4"
   endif
//6
   if (SRA->RA_MAT == "000261" )
       SRA->RA_RACACOR := "4"
   endif
//7
   if (SRA->RA_MAT == "000266" )
       SRA->RA_RACACOR := "4"
   endif
//8
   if (SRA->RA_MAT == "000314" )
       SRA->RA_RACACOR := "4"
   endif
//9
   if (SRA->RA_MAT == "000340" )
       SRA->RA_RACACOR := "4"
   endif
//10
   if (SRA->RA_MAT == "000367" )
       SRA->RA_RACACOR := "4"
   endif
//11
   if (SRA->RA_MAT == "000399" )
       SRA->RA_RACACOR := "4"
   endif
//12
   if (SRA->RA_MAT == "000400" )
       SRA->RA_RACACOR := "4"
   endif
//13
   if (SRA->RA_MAT == "000409" )
       SRA->RA_RACACOR := "4"
   endif
//14
   if (SRA->RA_MAT == "000488" )
       SRA->RA_RACACOR := "4"
   endif
//15
   if (SRA->RA_MAT == "000574" )
       SRA->RA_RACACOR := "4"
   endif
//16
   if (SRA->RA_MAT == "000629" )
       SRA->RA_RACACOR := "4"
   endif
//17
   if (SRA->RA_MAT == "000709" )
       SRA->RA_RACACOR := "4"
   endif
//18
   if (SRA->RA_MAT == "000724" )
       SRA->RA_RACACOR := "4"
   endif
//19
   if (SRA->RA_MAT == "000755" )
       SRA->RA_RACACOR := "4"
   endif
//20
   if (SRA->RA_MAT == "000852" )
       SRA->RA_RACACOR := "4"
   endif
//21
   if (SRA->RA_MAT == "000857" )
       SRA->RA_RACACOR := "4"
   endif
//22
   if (SRA->RA_MAT == "000864" )
       SRA->RA_RACACOR := "4"
   endif
//23
   if (SRA->RA_MAT == "000894" )
       SRA->RA_RACACOR := "4"
   endif
//24
   if (SRA->RA_MAT == "000901" )
       SRA->RA_RACACOR := "4"
   endif
//25
   if (SRA->RA_MAT == "000952" )
       SRA->RA_RACACOR := "4"
   endif
//26
   if (SRA->RA_MAT == "000955" )
       SRA->RA_RACACOR := "4"
   endif
//27
   if (SRA->RA_MAT == "000970" )
       SRA->RA_RACACOR := "4"
   endif
//28
   if (SRA->RA_MAT == "000979" )
       SRA->RA_RACACOR := "4"
   endif
//29
   if (SRA->RA_MAT == "001000" )
       SRA->RA_RACACOR := "4"
   endif
//30   
   if (SRA->RA_MAT == "001010" )
       SRA->RA_RACACOR := "4"
   endif
//31
   if (SRA->RA_MAT == "001012" )
       SRA->RA_RACACOR := "4"
   endif
//32
   if (SRA->RA_MAT == "001016" )
       SRA->RA_RACACOR := "4"
   endif
//33
   if (SRA->RA_MAT == "001017" )
       SRA->RA_RACACOR := "4"
   endif

//34
   if (SRA->RA_MAT == "001019" )
       SRA->RA_RACACOR := "4"
   endif

//35
   if (SRA->RA_MAT == "001020" )
       SRA->RA_RACACOR := "4"
   endif
//36
   if (SRA->RA_MAT == "001021" )
       SRA->RA_RACACOR := "4"
   endif

//37
   if (SRA->RA_MAT == "001064" )
       SRA->RA_RACACOR := "4"
   endif

//38
   if (SRA->RA_MAT == "001077" )
       SRA->RA_RACACOR := "4"
   endif


//39
   if (SRA->RA_MAT == "001083" )
       SRA->RA_RACACOR := "4"
   endif

//40
   if (SRA->RA_MAT == "001089" )
       SRA->RA_RACACOR := "4"
   endif
//41
   if (SRA->RA_MAT == "001109" )
       SRA->RA_RACACOR := "4"
   endif

   SRA->(DbSkip())
Enddo
   MsgInfo("Encerrado")
Return
