/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE243  �Autor  �Marcos R. Roquitski � Data �  10/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Recadastramento de vale transporte.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
     
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**********************************************************************************************************************************/
user function Nhgpe243()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,cMarca")

	private _aGrupo, _clApelido, _clNome   
	
	fgpe243i()        
                                                             
return nil

//
Static Function fgpe243i()
Local _aFields := {}
Local aCampos  := {}   

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cNum,_cCc,_cCdesc,_cdData,_cCarCor,_cCarPlaca,_cCarModelo,_cSic")

DEFINE FONT oFont NAME "Arial" SIZE 08, -12
DEFINE FONT oFont10 NAME "Arial" SIZE 08, -10 


_lFlag      := .T.
_cMat       := Space(06)
_cNome      := Space(40)
_cEnde      := Space(40)
_cComp      := Space(20)
_cBair      := Space(20)
_cMuni      := Space(20)
_cCarCor    := Space(15)
_cCarPlaca  := Space(08)
_cCarModelo := Space(20)
_cSic       := Space(11)
_cCep       := Space(08)
_cMetro     := Space(12) 
_aGrupo     :=  pswret()
_clApelido  := _agrupo[1,2 ] // Apelido
_clNome     := _agrupo[1,4 ] // Nome completo
_aMeio      := {}
_cArqDBF    := CriaTrab(NIL,.f.) + ".DBF"
aHeader     := {}        
aCols       := {}     
nMax        := 1        

aAdd(aCols,{"01","URBS",2,.F.}) 

Aadd(aHeader,{"Linha"           , "R0_MEIO",   "99"               ,20,0,"ExecBlock('_fSrn',.F.,.F.)","","C","SR0"}) //03
Aadd(aHeader,{"Descricao Linha" , "R0_DESC",   "@!"               ,40,0,".T.","","C","SR0"}) //03
Aadd(aHeader,{"Qtde"            , "R0_QDIAINF","99"               ,20,0,".T.","","N","SR0"}) //03
	


//��������������������������������������������������������������Ŀ
//� Criando Arquivo Temporario para posterior impressao          �
//����������������������������������������������������������������

/*
AADD(_aFields,{"OK"   ,"C", 02,0})         // Controle do browse
AADD(_aFields,{"COD"  ,"C", 02,0})         // Item do Release
AADD(_aFields,{"DESC" ,"C", 20,0})         // Item do Release
	
DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TSRN",.F.)
	
SRN->(DbGotop())	
While SRN->(!EOF()) 
	RecLock("TSRN",.T.)
      	TSRN->OK     := Space(02)
   		TSRN->COD    := SRN->RN_COD
   		TSRN->DESC   := SRN->RN_DESC
	MsUnlock("TSRN")
	SRN->(dbSkip())
Enddo
TSRN->(DbGotop())

cMarca  := GetMark()
While TSRN->(!EOF()) 
	RecLock("TSRN",.F.)
   	TSRN->OK := ''
	MsUnlock("TSRN")
	TSRN->(dbSkip())
Enddo
*/


aCampos := {}   
Aadd(aCampos,{"OK"   ,"OK"          ,"@!"})
Aadd(aCampos,{"COD"  ,"Linha"       ,"@!"})
Aadd(aCampos,{"DESC" ,"Descricao"   ,"@!"})


Define MsDialog oDialog Title OemToAnsi("** SOLICITACAO DE VALE TRANSPORTE  **") From 010,030 To 550,860 Pixel

@ 013,007 To  140,410 Title OemToAnsi("Dados Pessoais") //Color CLR_HBLUE

@ 027,010 Say "Matricula:" Size 030,8 Object _oMat
@ 025,040 Get _cMat Picture "@!" Valid _fFunc() F3 "SRA" Size 050,10 Object _oMat
_oMat:Setfont(oFont)

@ 027,100 Say "Nome:" Size 30,8 object _oNome 
@ 025,130 Get _cNome Picture "@!" When .F. Size 250,8 Object _oNome 
_oNome:Setfont(oFont10) 

@ 047,010 Say "Endereco:" Size 30,8 object _oEnde 
@ 045,040 Get _cEnde Picture "@!"  Size 300,10 Object _oEnde 
_oEnde:Setfont(oFont10) 

@ 067,010 Say "Compl.  :" Size 30,8 object _oComp 
@ 065,040 Get _cComp Picture "@!"  Size 200,10 Object _oComp 
_oComp:Setfont(oFont10) 

@ 067,300 Say "Cep:" Size 30,8 object _oCep
@ 065,330 Get _cCep Picture "@R 99999-999"  Size 50,10 Object _oCep
_oCep:Setfont(oFont10) 


@ 087,010 Say "Bairro   :" Size 50,8 object _oBair
@ 085,040 Get _cBair Picture "@!"  Size 150,10 Object _oBair
_oBair:Setfont(oFont10)                                                                         	

@ 087,220 Say "Cidade:" Size 50,8 object _oMuni
@ 085,240 Get _cMuni Picture "@!"  Size 150,10 Object _oMuni
_oMuni:Setfont(oFont10) 

/*
@ 107,010 Say "Carro Placa:" Size 35,8 object _oPlaca
@ 105,040 Get _cCarPlaca Picture "!!!-9999"  Size 40,10 Object _oPlaca
_oPlaca:Setfont(oFont10) 

@ 107,100 Say "Carro Cor:" Size 50,8 object _oCor
@ 105,130 Get _cCarCor Picture "@!"  Size 65,10 Object _oCor
_oCor:Setfont(oFont10) 

@ 107,200 Say "Carro Modelo:" Size 50,8 object _oModelo
@ 105,240 Get _cCarModelo Picture "@!"  Size 85,10 Object _oModelo
_oModelo:Setfont(oFont10) 
*/

@ 107,010 Say "SIC:" Size 50,8 object _oSic
@ 105,040 Get _cSic Picture "@!"  Size 80,10 Object _oSic
_oSic:Setfont(oFont10) 


@ 107,150 Say "Cartao Metropolitano:" Size 80,8 object _oMetro
@ 105,210 Get _cMetro Picture "@!"  Size 60,10 Object _oMetro
_oMetro:Setfont(oFont10) 


@ 145,007 To 230,410 Title OemToAnsi(" Linhas de Transporte ") 

@ 160,016 TO 220,400 MULTILINE MODIFY DELETE OBJECT oMultiline 


@ 250,340 BMPBUTTON TYPE 13 ACTION fGrvAdt()   // grava 13
@ 250,380 BMPBUTTON TYPE 02 ACTION fEnd()      // cancela 02

                                    	
Activate MsDialog oDialog Center

Return           

/*
Static Function fLimpa()

TSRN->(DbGotop())
cMarca  := GetMark()
While TSRN->(!EOF()) 
	RecLock("TSRN",.F.)
   	TSRN->OK := Space(02)
	MsUnlock("TSRN")
	TSRN->(dbSkip())
Enddo
dlgRefresh(oDialog)
TSRN->(DbGotop())
Return
*/


//
Static Function _fFunc()
Local _lRet := .T.
	_cMat := StrZero(Val(_cMat),6)


	If SRA->(DbSeek(xFilial("SRA")+_cMat))
		_cNome      := SRA->RA_NOME
		_cEnde      := SRA->RA_ENDEREC
		_cComp      := SRA->RA_COMPLEM
		_cBair      := SRA->RA_BAIRRO
		_cMuni      := SRA->RA_MUNICIP
		_cCarCor    := SRA->RA_ZCOR
		_cCarPlaca  := SRA->RA_ZPLACA
		_cCarModelo := SRA->RA_ZMODELO
		_cSic       := SRA->RA_SIC
		_cCep       := SRA->RA_CEP
		_cMetro     := SRA->RA_ZNCMET

	Else

		Alert("** FUNCIONARIO NAO CADASTRADO **")
		_lRet := .F.
		
	Endif	
	oMultiline:Refresh()
Return _lRet


//
Static Function fEnd()                                                                                                                                                           
	//TSRN->(DbCloseArea())
	Close(oDialog) 

Return

// Validacao 
User Function _fSrn()
Local := _lRet := .F.
	If SRN->(DbSeek(xFilial("SRN")+M->R0_MEIO))
		M->R0_DESC := SRN->RN_DESC
		Acols[n][2] := SRN->RN_DESC
		_lRet := .T.
	Else
		Alert("Atencao, MEIO DE TRANSPORTE INVALIDO. Verifique !")
		_lRet := .F.	
	Endif
	oMultiline:Refresh()
Return(_lRet)


// Grava 
Static Function fGrvAdt()
Local _dDataCol := Ctod(Space(08))

	DbSelectArea("SR0")
	If SR0->(DbSeek(xFilial("SR0")+SRA->RA_MAT))
		While SR0->(!EOF()) .and. SR0->R0_MAT == SRA->RA_MAT
			Reclock("SR0",.F.)   			
			SR0->(DbDelete())
			MsUnlock("SR0")	
			SR0->(DbSkip())		
		Enddo	
	Endif	

	DbSelectArea("SRA")
	Reclock("SRA",.F.)   
	SRA->RA_ENDEREC   := _cEnde
	SRA->RA_COMPLEM   := _cComp
	SRA->RA_BAIRRO    := _cBair
	SRA->RA_MUNICIP   := _cMuni
	SRA->RA_ZCOR      := _cCarCor 
	SRA->RA_ZPLACA    := _cCarPlaca
	SRA->RA_ZMODELO   := _cCarModelo
	SRA->RA_SIC       := _cSic
	SRA->RA_CEP       := _cCep
	SRA->RA_ZNCMET    := _cMetro
	MsUnlock("SRA")


	For _x := 1 to Len(aCols)
           
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada


			DbSelectArea("SR0")
			Reclock("SR0",.T.)
			SR0->R0_FILIAL  := xFilial("SR0")
			SR0->R0_MAT     := SRA->RA_MAT
			SR0->R0_MEIO    := Acols[_x][1]
			
			If Acols[_x][3] <= 0
				SR0->R0_QDIAINF := 2

			Else
				SR0->R0_QDIAINF := Acols[_x][3]

			Endif
			MsUnlock("SR0")
            
            
		Endif   
		   
	Next _x
	Commit
	
	fImp253()


	Close(oDialog)	                           

Return


//
Static Function fImp253()

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Solicitacao de Vale Transporte"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SR0"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE243"


//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := "NHGPE243"
wnRel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27 
   Return 
Endif 

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| fContrato()})

Return Nil

//
Static Function fContrato()
Local i := 0

	@ 1, 25 Psay "SOLICITA��O DE VALE TRANSPORTE"

	@ Prow()+2, 00 Psay "Nome: "+SRA->RA_NOME+" Portador(a) do R.G : "+SRA->RA_RG+" e da"
	@ Prow()+1, 00 Psay "C.T.P.S n� "+SRA->RA_NUMCP+", s�rie  "+SRA->RA_SERCP+" ,inscrito no C.P.F./M.F sob o No. "+SRA->RA_CIC

	@ Prow()+2, 00 Psay "Minha Residencia Atual:"

	@ Prow()+2, 00 Psay "Rua   : " + SRA->RA_ENDEREC + " "+SRA->RA_COMPLEM
	@ Prow()+1, 00 Psay "Bairro: " + SRA->RA_BAIRRO + " Cidade: "+SRA->RA_MUNICIP+ " UF: "+SRA->RA_ESTADO+ " CEP: "+SRA->RA_CEP


	@ Prow()+2, 00 Psay "(  ) Opto pela utiliza��o do Vale-Transporte"
	@ Prow()+2, 00 Psay "(  ) Nao opto pela utiliza��o do Vale-Transporte" 


	@ Prow()+3, 00 Psay "Declaro que as linhas abaixo discriminadas s�o as mais adequadas ao trajeto"

	@ Prow()+2, 00 Psay "residencia/trabalho e vice versa:"

	@ Prow()+3, 00 Psay " Linha Descri��o                            Quantidade"	
	@ Prow()+1, 00 Psay ""	


	If SR0->(DbSeek(xFilial("SR0")+SRA->RA_MAT))
		While SR0->(!EOF()) .and. SR0->R0_MAT == SRA->RA_MAT
			If SRN->(DbSeek(xFilial("SRN")+SR0->R0_MEIO))
				@ Prow()+1, 04 Psay SRN->RN_COD
				@ Prow()  , 07 Psay SRN->RN_DESC 			
				@ Prow()  , 50 Psay SR0->R0_QDIAINF Picture "999"
			Endif
			SR0->(DbSkip())
		Enddo	
	Endif	

	@ Prow()+3, 24 Psay "TERMO DE COMPROMISSO DE VALE-TRANSPORTE"

	@ Prow()+2, 00 Psay "Autorizo  a  empresa  a  descontar  at�  o  limite de 6% do meu sal�rio mensal," 
	@ Prow()+1, 00 Psay "conforme  legisla��o  vigente  LEI N� 7.418,  destinado a cobrir o fornecimento"
	@ Prow()+1, 00 Psay "de vales transporte por mim utilizados."

	@ Prow()+2, 00 Psay "Declaro  que   as   linhas   acima  discriminadas  s�o   verdadeiras  e atuais." 

	@ Prow()+2, 00 Psay "A declara��o  falsa  ou  o  uso indevido do benef�cio caracteriza a rescis�o do"
	@ Prow()+1, 00 Psay "contrato  individual  de trabalho por justa causa, ato de improbidade, conforme"
	@ Prow()+1, 00 Psay "art., 482 da CLT."
                                                   
	@ Prow()+2, 00 Psay "Autorizo,  tamb�m,  que na  hip�tese de existirem cr�ditos em meu cart�o quando" 
	@ Prow()+1, 00 Psay "da consulta  realizada  pela  empregadora,  esta  creditar� apenas a quantidade"
	@ Prow()+1, 00 Psay "faltante  para  se  completar os vales-transporte que utilizo a cada m�s. E nos"
	@ Prow()+1, 00 Psay "dias  em  que  me  deslocar ao trabalho por outro meio de transporte n�o �nibus"
	@ Prow()+1, 00 Psay "coletivo, autorizo a empresa  a deduzir no m�s subsequente a quantidade de vale"
	@ Prow()+1, 00 Psay "transporte que n�o foram utilizados no m�s.

	@ Prow()+2, 00 Psay "Em  caso  de  perda,  roubo   ou   extravio  do  meu  cart�o   vale-transporte,"
	@ Prow()+1, 00 Psay "comprometo-me  a  fazer  solicita��o  de  um  novo  cart�o  e,  posteriormente,"
	@ Prow()+1, 00 Psay "apresentar no RH da empregadora."


	@ pRow()+4, 35 pSay "Curitiba, "+Alltrim(Str(Day(dDataBase)))+" de "+Mesextenso(Month(dDataBase)) + " de "+Alltrim(Str(Year(dDataBase)))+"."

	@ pRow()+4, 01 pSay "____________________________________________"


	@ pRow()+1,01 pSay SRA->RA_NOME + " Mtr: "+SRA->RA_MAT



If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif

MS_FLUSH()
Return



