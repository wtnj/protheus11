#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhhome()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,ARETURN,NOMEPROG,NLASTKEY,M_PAG,_NQSTFFX1")
SetPrvt("_NQSTFFX2,_NQSTFFX3,_NQSTFFX4,_NQSTFFX5,_NQSTFFX6,_NQSTFFX7")
SetPrvt("_NQEXFFX1,_NQEXFFX2,_NQEXFFX3,_NQEXFFX4,_NQEXFFX5,_NQEXFFX6")
SetPrvt("_NQEXFFX7,_NQSTDFX1,_NQSTDFX2,_NQSTDFX3,_NQSTDFX4,_NQSTDFX5")
SetPrvt("_NQSTDFX6,_NQSTDFX7,_NQEXDFX1,_NQEXDFX2,_NQEXDFX3,_NQEXDFX4")
SetPrvt("_NQEXDFX5,_NQEXDFX6,_NQEXDFX7,_NIDADE,")

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem  :=0
tamanho :="P"
limite  := 80
cbtxt   := SPACE(10)
cbcont  := 0
titulo  :=""
cDesc1  :=""
cDesc2  :=""
cDesc3  :=""
cString :="SRA"
aReturn := { "Branco", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RHHOME"
nLastKey:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Saida                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSavScr1 := SaveScreen(3,0,24,79)
cSavCur1 := SetCursor(0)
cSavRow1 := ROW()
cSavCol1 := COL()
cSavCor1 := SetColor("bg+/b,,,")
wnrel    := "RHHOME"
//Pergunte("RHTT01",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
m_pag    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,"RHTT01",Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return Nil
Endif

#IFDEF WINDOWS
    RptStatus({|| fRC_TTT()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(fRC_TTT)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF

Set Filter to
If aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(WnRel)
Endif

MS_FLUSH()
RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function fRC_TTT
Static Function fRC_TTT()
DbSelectArea("SRB")
DbSetOrder(1)
DbSelectArea("SRA")
DbSetOrder(1)
SRA->(SetRegua(LASTREC()))
SRA->(DbGoTop())
_nQStFFx1:=_nQStFFx2:=_nQStFFx3:=_nQStFFx4:=_nQStFFx5:=_nQStFFx6:=_nQStFFx7:=0
_nQExFFx1:=_nQExFFx2:=_nQExFFx3:=_nQExFFx4:=_nQExFFx5:=_nQExFFx6:=_nQExFFx7:=0
_nQStDFx1:=_nQStDFx2:=_nQStDFx3:=_nQStDFx4:=_nQStDFx5:=_nQStDFx6:=_nQStDFx7:=0
_nQExDFx1:=_nQExDFx2:=_nQExDFx3:=_nQExDFx4:=_nQExDFx5:=_nQExDFx6:=_nQExDFx7:=0
While SRA->(! Eof())
   IncRegua()
   If SRA->RA_SITFOLH$"DT" 
      SRA->(DbSkip())
      Loop
   EndIf
   If ! Empty(SRA->RA_ASMEDIC)
      _nIdade:=Int((dDataBase-SRA->RA_NASC)/365.25+0.002)
      If SubStr(SRA->RA_ASMEDIC,2,1)=="1"
         If _nIdade<=mv_par02
            _nQStFFx1:=_nQStFFx1+1
         ElseIf _nIdade<=mv_par04
            _nQStFFx2:=_nQStFFx2+1
         ElseIf _nIdade<=mv_par06
            _nQStFFx3:=_nQStFFx3+1
         ElseIf _nIdade<=mv_par08
            _nQStFFx4:=_nQStFFx4+1
         ElseIf _nIdade<=mv_par10
            _nQStFFx5:=_nQStFFx5+1
         ElseIf _nIdade<=mv_par12
            _nQStFFx6:=_nQStFFx6+1
         ElseIf _nIdade<=mv_par14
            _nQStFFx7:=_nQStFFx7+1
         EndIf
      ElseIf SubStr(SRA->RA_ASMEDIC,2,1)=="2"
         If _nIdade<=mv_par02
            _nQExFFx1:=_nQExFFx1+1
         ElseIf _nIdade<=mv_par04
            _nQExFFx2:=_nQExFFx2+1
         ElseIf _nIdade<=mv_par06
            _nQExFFx3:=_nQExFFx3+1
         ElseIf _nIdade<=mv_par08
            _nQExFFx4:=_nQExFFx4+1
         ElseIf _nIdade<=mv_par10
            _nQExFFx5:=_nQExFFx5+1
         ElseIf _nIdade<=mv_par12
            _nQExFFx6:=_nQExFFx6+1
         ElseIf _nIdade<=mv_par14
            _nQExFFx7:=_nQExFFx7+1
         EndIf
      EndIf   
   EndIf
   SRB->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
   If SRA->RA_FILIAL==SRB->RB_FILIAL .AND. SRA->RA_MAT==SRB->RB_MAT
      If ! Empty(SRB->RB_ASMEDIC)
         _nIdade:=Int((dDataBase-SRB->RB_DTNASC)/365.25+0.002)
         If SubStr(SRB->RB_ASMEDIC,2,1)=="1"
            If _nIdade<=mv_par02
               _nQStDFx1:=_nQStDFx1+1
            ElseIf _nIdade<=mv_par04
               _nQStDFx2:=_nQStDFx2+1
            ElseIf _nIdade<=mv_par06
               _nQStDFx3:=_nQStDFx3+1
            ElseIf _nIdade<=mv_par08
               _nQStDFx4:=_nQStDFx4+1
            ElseIf _nIdade<=mv_par10
               _nQStDFx5:=_nQStDFx5+1
            ElseIf _nIdade<=mv_par12
               _nQStDFx6:=_nQStDFx6+1
            ElseIf _nIdade<=mv_par14
               _nQStDFx7:=_nQStDFx7+1
            EndIf
         ElseIf SubStr(SRB->RB_ASMEDIC,2,1)=="2"
            If _nIdade<=mv_par02
               _nQExDFx1:=_nQExDFx1+1
            ElseIf _nIdade<=mv_par04
               _nQExDFx2:=_nQExDFx2+1
            ElseIf _nIdade<=mv_par06
               _nQExDFx3:=_nQExDFx3+1
            ElseIf _nIdade<=mv_par08
               _nQExDFx4:=_nQExDFx4+1
            ElseIf _nIdade<=mv_par10
               _nQExDFx5:=_nQExDFx5+1
            ElseIf _nIdade<=mv_par12
               _nQExDFx6:=_nQExDFx6+1
            ElseIf _nIdade<=mv_par14
               _nQExDFx7:=_nQExDFx7+1
            EndIf
         EndIf   
      EndIf
   EndIf
   SRA->(DbSkip())
EndDo

@ pRow()   ,01 pSay "RELATORIO"
@ pRow()+3 ,02 pSay "Funcionarios"
@ pRow()   ,32 pSay "Standard"
@ pRow()   ,52 pSay "Executivo"
@ pRow()+1 ,02 pSay "Faixa Etaria"
@ pRow()+1 ,02 pSay mv_par01 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par02 Picture "999"
@ pRow()   ,32 pSay _nQStFFx1 Picture "999"
@ pRow()   ,52 pSay _nQExFFx1 Picture "999"
@ pRow()+1 ,02 pSay mv_par03 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par04 Picture "999"
@ pRow()   ,32 pSay _nQStFFx2 Picture "999"
@ pRow()   ,52 pSay _nQExFFx2 Picture "999"
@ pRow()+1 ,02 pSay mv_par05 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par06 Picture "999"
@ pRow()   ,32 pSay _nQStFFx3 Picture "999"
@ pRow()   ,52 pSay _nQExFFx3 Picture "999"
@ pRow()+1 ,02 pSay mv_par07 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par08 Picture "999"
@ pRow()   ,32 pSay _nQStFFx4 Picture "999"
@ pRow()   ,52 pSay _nQExFFx4 Picture "999"
@ pRow()+1 ,02 pSay mv_par09 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par10 Picture "999"
@ pRow()   ,32 pSay _nQStFFx5 Picture "999"
@ pRow()   ,52 pSay _nQExFFx5 Picture "999"
@ pRow()+1 ,02 pSay mv_par11 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par12 Picture "999"
@ pRow()   ,32 pSay _nQStFFx6 Picture "999"
@ pRow()   ,52 pSay _nQExFFx6 Picture "999"
@ pRow()+1 ,02 pSay mv_par13 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par14 Picture "999"
@ pRow()   ,32 pSay _nQStFFx7 Picture "999"
@ pRow()   ,52 pSay _nQExFFx7 Picture "999"
@ pRow()+4 ,02 pSay "Dependentes"
@ pRow()   ,32 pSay "Standard"
@ pRow()   ,52 pSay "Executivo"
@ pRow()+1 ,02 pSay "Faixa Etaria"
@ pRow()+1 ,02 pSay mv_par01 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par02 Picture "999"
@ pRow()   ,32 pSay _nQStDFx1 Picture "999"
@ pRow()   ,52 pSay _nQExDFx1 Picture "999"
@ pRow()+1 ,02 pSay mv_par03 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par04 Picture "999"
@ pRow()   ,32 pSay _nQStDFx2 Picture "999"
@ pRow()   ,52 pSay _nQExDFx2 Picture "999"
@ pRow()+1 ,02 pSay mv_par05 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par06 Picture "999"
@ pRow()   ,32 pSay _nQStDFx3 Picture "999"
@ pRow()   ,52 pSay _nQExDFx3 Picture "999"
@ pRow()+1 ,02 pSay mv_par07 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par08 Picture "999"
@ pRow()   ,32 pSay _nQStDFx4 Picture "999"
@ pRow()   ,52 pSay _nQExDFx4 Picture "999"
@ pRow()+1 ,02 pSay mv_par09 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par10 Picture "999"
@ pRow()   ,32 pSay _nQStDFx5 Picture "999"
@ pRow()   ,52 pSay _nQExDFx5 Picture "999"
@ pRow()+1 ,02 pSay mv_par11 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par12 Picture "999"
@ pRow()   ,32 pSay _nQStDFx6 Picture "999"
@ pRow()   ,52 pSay _nQExDFx6 Picture "999"
@ pRow()+1 ,02 pSay mv_par13 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par14 Picture "999"
@ pRow()   ,32 pSay _nQStDFx7 Picture "999"
@ pRow()   ,52 pSay _nQExDFx7 Picture "999"
Return Nil
