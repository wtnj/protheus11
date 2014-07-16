/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE236  ºAutor  ³Marcos R. Roquitski º Data ³  25/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ DECLARAÇÃO DE SALÁRIO-FAMÍLIA.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ITESAPAR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe236()

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
titulo    := "DECLARAÇÃO DE SALÁRIO-FAMÍLIA"
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
wnrel := "NHGPE236" 
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"") 

If LastKey() == 27 .or. nLastKey == 27 
   Return 
Endif 

SetDefault(aReturn,cString) 

If LastKey() == 27 .or. nLastKey == 27 
   Return
Endif

RptStatus({|| _fIt236()})

Return Nil


Static Function _fIt236()

SRB->(DbSetOrder(1))
SRA->(DbSetOrder(1))
SRJ->(DbSetOrder(1))
SR6->(DbSetOrder(1))

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


   For i := 1 to _nVias
   
      @ 1, 28 pSay "* * " + Alltrim(SM0->M0_NOMECOM) + " * *" 

      @ pRow()+3, 20 pSay "DECLARAÇÃO DE SALÁRIO-FAMÍLIA" 
      @ pRow()+1, 20 pSay "	 TERMO DE RESPONSABILIDADE  " 

      @ pRow()+3, 01 pSay "NOME DA EMPRESA : " + Alltrim(SM0->M0_NOMECOM) 
	  @ pRow()+1, 01 pSay "NOME DECLARANTE : " + SRA->RA_MAT + " " + SRA->RA_NOMECMP 
      @ pRow()+1, 01 pSay "CTPS NR         : " + SRA->RA_NUMCP + " SERIE: "+SRA->RA_SERCP + " UF: "+SRA->RA_UFCP 

      @ pRow()+3, 01 pSay "BENEFICIÁRIOS"
      @ pRow()+2, 01 pSay "NOME DO BENEFICIÁRIO 	                    NASCIMENTO"
      @ pRow()+1, 01 pSay "---------------------------------------------------"
            
      @ pRow()+1, 01 pSay " "
      
	  SRB->(DbSeek(xFilial("SRB") + SRA->RA_MAT))	                                                    
	  While SRB->(!EOF()) .AND. SRA->RA_MAT == SRB->RB_MAT

	  	 If (Year(DATE()) - Year(SRB->RB_DTNASC)) < 15
		     @ pRow()+1, 01 pSay Substr(SRB->RB_NOME,1,40) + " " + DTOC(SRB->RB_DTNASC)
		 Endif	
		 SRB->(DbSkip())
			 
	  Enddo

      @ pRow()+3, 01 pSay "Pelo presente TERMO DE RESPONSABILIDADE  declaro estar ciente de  que"
      @ pRow()+1, 01 pSay "deverei comunicar imediatamente  a ocorrência dos seguintes fatos que"
      @ pRow()+1, 01 pSay "determinam a perda do direito ao salário-família:                    "


      @ pRow()+2, 08 pSay "	- FALECIMENTO DO FILHO                                              "
      @ pRow()+1, 08 pSay "	- CESSAÇÃO DA INVALIDEZ DO FILHO INVÁLIDO                           "
      @ pRow()+1, 08 pSay "	- SENTENÇA JUDICIAL QUE DETERMINE O PAGAMENTO A OUTRA PESSOA        "
                                                                                              
                                                                                               
      @ pRow()+2, 01 pSay "A falta de comunicação desses fatos sujeitar-me-á à devolução     dos"
      @ pRow()+1, 01 pSay "valores recebidos indevidamente, às penalidades previstas no Art. 171"
      @ pRow()+1, 01 pSay "do Código Penal e à rescisão por justa causa, nos termos  do Art. 482"
      @ pRow()+1, 01 pSay "da CLT.                                                              "
	
	
      @ pRow()+2, 01 pSay "Comprometo-me também, sob pena de suspensão do benefício, a entregar "
      @ pRow()+1, 01 pSay "anualmente os seguintes documentos, nos termos do Art. 84 do Decreto "
      @ pRow()+1, 01 pSay "3.048/99:                                                            "
	
      @ pRow()+2, 01 pSay "	Filhos menores de sete anos:"
      @ pRow()+1, 01 pSay "	 - Caderneta de vacinação, no mês de novembro."
      @ pRow()+1, 01 pSay "	Filhos maiores de sete anos:"
      @ pRow()+1, 01 pSay "	 - Comprovante de frequência escolar nos meses de maio e novembro."

	
      @ pRow()+3, 01 pSay "Palmeira, "+Alltrim(Str(DAY(SRA->RA_ADMISSA))) + " de " + MesExtenso(MONTH(SRA->rA_ADMISSA)) + " de " + Alltrim(Str(Year(SRA->RA_ADMISSA)))


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
