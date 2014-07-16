/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE237  ºAutor  ³Marcos R. Roquitski º Data ³  25/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ DECLARAÇÃO DE SALÁRIO-FAMÍLIA FINS DE IMPOSTO DE RENDA.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ITESAPAR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe237()

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
titulo    := "DECLARAÇÃO DE SALÁRIO-FAMÍLIA PARA FINS DE IMPOSTO DE RENDA"
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
wnrel := "NHGPE237" 
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

      @ pRow()+3, 20 pSay "DECLARAÇÃO DE ENCARGOS DE FAMÍLIA PARA FINS DE"
      @ pRow()+1, 20 pSay "            IMPOSTO DE RENDA"

      @ pRow()+3, 01 pSay "NOME DA EMPRESA : " + Alltrim(SM0->M0_NOMECOM) 
	  @ pRow()+1, 01 pSay "ENDERECO        : " + SM0->M0_ENDENT  
	  @ pRow()+1, 01 pSay "CNPJ            : " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") 
      @ pRow()+1, 01 pSay "BAIRRO          : " + SM0->M0_BAIRENT + "CIDADE: PALMEIRA UF: PR" 


      @ pRow()+3, 01 pSay "Em obediência a legislação de Imposto de Renda,  venho  pela presente" 
      @ pRow()+1, 01 pSay "informar-lhes que tenho como encargo de  família  as  pessoas  abaixo" 
      @ pRow()+1, 01 pSay "relacionadas:" 


      @ pRow()+3, 01 pSay "DEPENDENTES CONSIDERADOS COMO ENCARGOS DE FAMÍLIA"
      @ pRow()+2, 01 pSay "NOME COMPLETO                            PARENTESCO     NASCIMENTO"
      @ pRow()+1, 01 pSay "------------------------------------------------------------------"
            
      @ pRow()+1, 01 pSay " "
      
      _cGraupar := ''		      
      _cNome    := ''
      
	  SRB->(DbSeek(xFilial("SRB") + SRA->RA_MAT))	                                                    
	  While SRB->(!EOF()) .AND. SRA->RA_MAT == SRB->RB_MAT

		 If SRB->RB_GRAUPAR == "C"
               _cGraupar := "Conjuge      "
	     Elseif SRB->RB_GRAUPAR == "F"
       	      _cGraupar := "Filho         "
	     Elseif SRB->RB_GRAUPAR == "E"
	          _cGraupar := "Enteado       "	    
	     Elseif SRB->RB_GRAUPAR == "P"
		      _cGraupar := "Companheira(o)"	    
	     Elseif SRB->RB_GRAUPAR == "O"
		      _cGraupar := "Outros        "
		 Else
		      _cGraupar := '              '
		 Endif
		 _cNome := Substr(SRB->RB_NOME,1,40)
	     @ pRow()+1, 01 pSay _cNome + " " + _cGraupar + " " + DTOC(SRB->RB_DTNASC)
		 SRB->(DbSkip())
			 
	  Enddo

      @ pRow()+3, 01 pSay "Declaro sob as penas da lei, que as informações aqui  prestadas   são"
      @ pRow()+1, 01 pSay "verdadeiras e de minha inteira responsabilidade, não cabendo V.Sa.(s)"
      @ pRow()+1, 01 pSay "(fonte pagadora) qualquer responsabilidade perante a fiscalização.   "

      @ pRow()+3, 01 pSay "Palmeira, "+Alltrim(Str(DAY(SRA->RA_ADMISSA))) + " de " + MesExtenso(MONTH(SRA->rA_ADMISSA)) + " de " + Alltrim(Str(Year(SRA->RA_ADMISSA)))


      @ pRow()+4, 01 pSay "_________________________________"
      @ pRow()+2, 01 pSay "   (Assinatura do Declarante)"


	  @ pRow()+2, 01 pSay "EMPREGADO     : " + SRA->RA_NOMECMP 
      @ pRow()+1, 01 pSay "ENDERECO      : " + SRA->RA_ENDEREC
      @ pRow()+1, 01 pSay "COMPLEMENTO   : " + SRA->RA_COMPLEM	
      @ pRow()+1, 01 pSay "BAIRRO        : " + SRA->RA_BAIRRO
      @ pRow()+1, 01 pSay "CIDADE/ESTADO : " + SRA->RA_MUNICIP + " - " + SRA->RA_ESTADO    
      @ pRow()+1, 01 pSay "CTPS NR       : " + SRA->RA_NUMCP + "SERIE: "+SRA->RA_SERCP + "UF: "+SRA->RA_UFCP
      @ pRow()+1, 01 pSay "C.P.F         : " + TRANSFORM(SRA->RA_CIC,"@R 999.999.999-99")

    
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
