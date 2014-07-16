/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE235  ºAutor  ³Marcos R. Roquitski º Data ³  25/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Solicitacao de Vale Transporte.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ITESAPAR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe235()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_NVIAS,_CCATEG,I")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1    := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "SOLICITAÇÃO DE VALE TRANSPORTE"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
m_pag     := 1
nomeprog  := 'RHGP07'
cPerg     := 'RHGP07'
_nVias    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE235" 
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"") 

If LastKey() == 27 .or. nLastKey == 27 
   Return 
Endif 

SetDefault(aReturn,cString) 

If LastKey() == 27 .or. nLastKey == 27 
   Return
Endif

RptStatus({|| _fIt235()})

Return Nil


Static Function _fIt235()

DbSelectArea("SRA")
DbSetOrder(01)

DbSelectArea("SRJ")
DbSetOrder(01)

DbSelectArea("SR6")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

_cRjDesc := Space(30)

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   If SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC))
		_cRjDesc := SRJ->RJ_DESC
   Endif		   	
   
   If SRA->RA_CATFUNC=="H"
      _cCateg:="POR HORA."
   ElseIf SRA->RA_CATFUNC=="M"   
      _cCateg:="POR MES ."
   EndIf   
   IncRegua()

   For i:=1 to _nVias
      @ 1, 28 pSay "* * " + Alltrim(SM0->M0_NOMECOM) + " * *"

      @ pRow()+2, 20 pSay "SOLICITAÇÃO DE VALE TRANSPORTE"

	  @ pRow()+2, 01 pSay "EMPREGADO     : " + SRA->RA_NOMECMP 
	  @ pRow()+1, 01 pSay "FUNCAO        : " + SRA->RA_CODFUNC + "  " + _cRjDesc
	  @ pRow()+1, 01 pSay "MATRICULA     : " + SRA->RA_MAT
      @ pRow()+1, 01 pSay "CTPS NR       : " + SRA->RA_NUMCP + " SERIE: "+SRA->RA_SERCP + " UF: "+SRA->RA_UFCP
	        
      @ pRow()+3, 01 pSay "A"

      @ pRow()+2, 01 pSay Alltrim(SM0->M0_NOMECOM)
      @ pRow()+1, 01 pSay Alltrim(SM0->M0_ENDENT)  + "BAIRRO: " + Alltrim(SM0->M0_BAIRENT)
      @ pRow()+1, 01 pSay "PALMEIRA - PR" 

      @ pRow()+3, 01 pSay "[  ] Opto pela utilização                   [  ] Não opto pela utilização"
      @ pRow()+1, 01 pSay "     do Vale Transporte                          do Vale Transporte      "

      @ pRow()+2, 01 pSay "Nos termos do artigo 7o do Decreto nr. 95,247, de 17 de Novembro de 1987,"
      @ pRow()+1, 01 pSay "solicito o fornecimento do Vale Transporte e comprometo-me               "
	
      @ pRow()+2, 05 pSay "a) A utiliza-lo exclusivamente para meu efetivo deslocamento residen-    "
      @ pRow()+1, 05 pSay "   cia/trabalho e vice-versa.

      @ pRow()+2, 05 pSay "b) A renovar esta solicitação anualmente ou  sempre que ocorrer alte-    "
      @ pRow()+1, 05 pSay "	  ração no  meu  endereço  residencial ou  dos  serviços  e meios de    "
      @ pRow()+1, 05 pSay "   transporte mais adequados ao meu deslocamento residencia/trabalho     "
      @ pRow()+1, 05 pSay "   e vice-versa.                                                         "
      
      @ pRow()+2, 05 pSay "c) Autorizo a descontar até 6% (seis por cento) do meu salário mensal    "
      @ pRow()+1, 05 pSay "   para concorrer ao custeio do Vale Transporte. (Conforme artigo 9o.    "
      @ pRow()+1, 05 pSay "   do Decreto Nr. 95,247/87).                                            "
      
      @ pRow()+2, 05 pSay "d) Declaro estar ciente de que a  declaração falsa ou o uso  indevido    "
      @ pRow()+1, 05 pSay "   do Vale Transporte constitue falta grave (conforme parágrafo 3o.      "
      @ pRow()+1, 05 pSay "   do Artigo 7o. do Decreto Nr. 95,247/87).                              "



      @ pRow()+3, 01 pSay "Minha residência atual:"

      @ pRow()+2, 01 pSay "Endereço      : " + SRA->RA_ENDEREC
      @ pRow()+1, 01 pSay "Complemento   : " + SRA->RA_COMPLEM	
      @ pRow()+1, 01 pSay "Bairro        : " + SRA->RA_BAIRRO
      @ pRow()+1, 01 pSay "Cidade/Estado : " + SRA->RA_MUNICIP + " - " + SRA->RA_ESTADO    


      @ pRow()+3, 01 pSay "Descrição das linhas utilizadas 	Quantidade de Vales"
      @ pRow()+2, 01 pSay "_______________________________ 	___________________"
      @ pRow()+2, 01 pSay "_______________________________ 	___________________"
	
      @ pRow()+4, 01 pSay "Palmeira, "+Alltrim(Str(DAY(SRA->RA_ADMISSA))) + " de " + MesExtenso(MONTH(SRA->rA_ADMISSA)) + " de " + Alltrim(Str(Year(SRA->RA_ADMISSA)))


      @ pRow()+4, 01 pSay "_________________________________"
      @ pRow()+2, 01 pSay "EMPREGADO"

    
   Next
   SRA->(DbSkip())

Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return
