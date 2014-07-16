/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE233  ºAutor  ³Marcos R. Roquitski º Data ³  25/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contrato de Trabalho a Titulo de Experiencia.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ITESAPAR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe234()

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
titulo    := "AUTORIZAÇÃO DE DESCONTO"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
m_pag     := 1
nomeprog  := 'RHGP07'
cPerg     := 'RHGP07'
_nVias    := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE234"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| _fIt233()})

Return Nil


Static Function _fIt233()

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

      @ pRow()+2, 20 pSay "CONTRATO DE TRABALHO A TÍTULO DE EXPERIÊNCIA"

      @ pRow()+3, 01 pSay "EMPREGADORA   : " + Alltrim(SM0->M0_NOMECOM) 
	  @ pRow()+1, 01 pSay "CNPJ          : " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") 
	  @ pRow()+1, 01 pSay "ENDERECO      : " + SM0->M0_ENDENT  
      @ pRow()+1, 01 pSay "BAIRRO        : " + SM0->M0_BAIRENT + "CIDADE: PALMEIRA UF: PR" 

	  @ pRow()+2, 01 pSay "EMPREGADO     : " + SRA->RA_NOMECMP 
      @ pRow()+1, 01 pSay "CTPS NR       : " + SRA->RA_NUMCP + "SERIE: "+SRA->RA_SERCP + "UF: "+SRA->RA_UFCP
	  @ pRow()+2, 01 pSay "FUNCAO        : " + SRA->RA_CODFUNC + "  " + _cRjDesc
	  @ pRow()+1, 01 pSay "VIGÊNCIA      : 45 " + "Periodo: " + DTOC(SRA->RA_ADMISSA) + " a " + DTOC(SRA->RA_ADMISSA + 45)
	  @ pRow()+1, 01 pSay "REMUNERAÇÃO   : R$ " + TRANSFORM(SRA->RA_SALARIO,"@E 999,999.99") + " POR: MES"
	  @ pRow()+1, 01 pSay "HORAS         :44,00 SEMANAL"
   
      @ pRow()+4, 01 pSay "AUTORIZAÇÃO DE DESCONTO"	

      @ pRow()+4, 01 pSay "Autorizo a " + Alltrim(SM0->M0_NOMECOM) + " a descontar de meus vencimentos os eventos, abaixo: 

      @ pRow()+4, 01 pSay "Convenio médico_____________________________: (     ) Sim     (   ) Não"
      @ pRow()+2, 01 pSay "Convênio Farmácia___________________________: (     ) Sim     (   ) Não"
      @ pRow()+2, 01 pSay "Convênio Odontológico_______________________: (     ) Sim     (   ) Não" 
      @ pRow()+2, 01 pSay "Contribuições ao sindicato da Categoria_____: (     ) Sim     (   ) Não"
      @ pRow()+2, 01 pSay "Auxilio Refeição____________________________: (     ) Sim     (   ) Não"
	 
	
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
