#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Nhgp09()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NVALOR,_NDIAS,_NEMPRE,_CALCULO,_VALOR,_QTDE")

DbSelectArea("SRN")
DbSetOrder(1)
DbSelectArea("SR0")
DbSetOrder(1)
_nValor:=0.00
_nDias := 0
_nEmpre := 0.00
_calculo:= 0.00
   _nDias := 25
   _VALOR := 1.1
   _QTDE  := 2
   IF SRA->RA_MAT == "000745"
      _VALOR := 1.8
   Endif
   IF SRA->RA_MAT == "000503" .OR. SRA->RA_MAT == "001174" .OR. ;
      SRA->RA_MAT == "001181" .OR.  SRA->RA_MAT == "001188"
      _nDias := 20
   Endif
   IF SRA->RA_MAT == "001215" 
      _nDias := 24
   Endif
   IF SRA->RA_MAT == "000945" .OR. SRA->RA_MAT == "001543" .OR. ;
      SRA->RA_MAT == "001544" .OR. SRA->RA_MAT == "001545"
      _QTDE := 3
   Endif
   IF SRA->RA_MAT== "000415"
      _QTDE := 4
   Endif

   IF SRA->RA_MAT== "000344" .OR. SRA->RA_MAT== "000415" .OR. ;
      SRA->RA_MAT== "000431" .OR. SRA->RA_MAT== "000508" .OR. SRA->RA_MAT== "000510" .OR. ;
      SRA->RA_MAT== "000529" .OR. SRA->RA_MAT== "000561" .OR. SRA->RA_MAT== "000590" 
      _QTDE := 4
   Endif
   if SRA->RA_MAT== "000604" .OR. SRA->RA_MAT== "000651" .OR. SRA->RA_MAT== "000760" .OR. ;
      SRA->RA_MAT== "000821" .OR. SRA->RA_MAT== "000825" .OR. SRA->RA_MAT== "000835" 
      _QTDE := 4
   Endif

   If SRA->RA_MAT== "000847" .OR. SRA->RA_MAT== "000848" .OR. SRA->RA_MAT== "000849" .OR. ;
      SRA->RA_MAT== "000858" .OR. SRA->RA_MAT== "000894" .OR. SRA->RA_MAT== "000945" .OR. ;
      SRA->RA_MAT== "001063" .OR. SRA->RA_MAT== "001212" .OR. SRA->RA_MAT== "001216" 
      _QTDE := 4
   Endif
   if SRA->RA_MAT== "001259" .OR. SRA->RA_MAT== "001274" .OR. SRA->RA_MAT== "001285" .OR. ;
      SRA->RA_MAT== "001300" .OR. SRA->RA_MAT== "001395" .OR. SRA->RA_MAT== "001446" 
      _QTDE := 4
   Endif
   if SRA->RA_MAT== "001523" .OR. SRA->RA_MAT== "001529" .OR. SRA->RA_MAT== "001583" .OR. ;
      SRA->RA_MAT== "001654"
      _QTDE := 4
   Endif

   _nEmpre := (_nDias * _VALOR * _QTDE)
   if SRA->RA_CATFUNC == "H"
      _nValor := SRA->RA_HRSMES * SRA->RA_SALARIO * 0.06
   ELSE
      _nValor := SRA->RA_SALARIO * 0.06
   ENDIF
   _calculo := (_nEmpre - _nValor) 
   if _calculo > 0
      fGeraVerba("790",_calculo,,,,,,,,,.T.)
   end if
Return
