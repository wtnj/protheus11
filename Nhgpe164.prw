/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE164 ºAutor  ³Marcos R Roquitski  º Data ³  25/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Programacao de Ferias.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºU/so       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "Font.ch"
#include "Colors.ch"   
#include "AP5MAIL.CH" 

User Function Nhgpe164()

SetPrvt("cCadastro,aRotina,_cFunc,_PerCadt,_Valeref")
SetPrvt("_dAquisi1, _dAquisi2, _nDiasven, _nDiaspro,_nDiasAbo,_cMail")


cCadastro := OemToAnsi("Alteração")
aRotina := {{ "Pesquisar"  ,"AxPesqui",0,1},;
            { "Altera"     ,"U_fPrgFer()",0,2},;
            { "Exclui"     ,"U_fPrgExc()",0,3}}
            
DbSelectArea("ZRG")
DbGotop()
            
mBrowse(,,,,"ZRG")

DbGotop()

Return(nil)    

// Lancamento da programacao de Ferias
User Function fPrgFer()

	If !fExistApr()
		Return
	Endif	
    
	SRA->(DbSetOrder(1))         
	If SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
		//If SRA->RA_SITFOLH == 'F'
		//	Alert('Já existe Ferias calculada para o Funcionario')
		//	Return
		//Endif			
	Endif

	
	_cCompra  := "N"
	_dAquisi1 := Ctod(Space(08))
	_dAquisi2 := Ctod(Space(08))
	_nDiasven := 0
	_nDiaspro := 0
	_dDatamax := Ctod(Space(08))
	_dDataIni := Ctod(Space(08))
	_dDataFim := Ctod(Space(08))
    _nDiasFer := 0
    _nDiasAbo := 0
    
	SRF->(DbSeek(xFilial("SRF")+ZRG->ZRG_MAT))
	If SRF->RF_MAT == ZRG->ZRG_MAT
		_dAquisi1 := SRF->RF_DATABAS
		_dAquisi2 := (SRF->RF_DATABAS + 364)
		_nDiasven := SRF->RF_DFERVAT - SRF->RF_DFERANT
		_nDiaspro := SRF->RF_DFERAAT
		_dDatamax := (SRF->RF_DATABAS + 684)
		_dDataIni := SRF->RF_DATAINI
		_dDataFim := (SRF->RF_DATAINI + SRF->RF_DFEPRO1)
		_cCompra  := SRF->RF_TEMABPE
		_nDiasFer := SRF->RF_DFEPRO1
		_nDiasAbo := SRF->RF_DABPRO1		
	Else
		Alert("Nao existe programacao de Ferias para este Funcionario, Verifique") 
		Return	
	Endif 
   
   _cFunc   := "Funcionario: " +ZRG->ZRG_MAT + " - " +ZRG->ZRG_NOME 
   
	@ 096,042 TO 450,500 DIALOG oDlg6 TITLE _cFunc
  
	@ 010,014 Say OemToAnsi("Periodo Aquisitivo") Size 60,10

	@ 025,014 Say OemToAnsi("Dias Vencidos    ") Size 60,10
	@ 025,120 Say OemToAnsi("Proporcional") Size 60,10
                                                      
	@ 040,014 Say OemToAnsi("Abono?") Size 60,10

	@ 060,014 Say OemToAnsi("Dias Abono") Size 70,10
	@ 060,120 Say OemToAnsi("Dias Ferias") Size 70,10
	
	@ 080,014 Say OemToAnsi("Inicio das Ferias") Size 70,10
	@ 080,120 Say OemToAnsi("Data maxima Saida") Size 70,10
	
	@ 100,014 Say OemToAnsi("Final das Ferias") Size 70,10
	

	@ 007,070 Get _dAquisi1 Size 40,10 When .F.
	@ 007,120 Get _dAquisi2 Size 40,10 When .F.
	@ 023,070 Get _nDiasVen Size 15,10 When .F.
	@ 023,170 Get _nDiasPro Size 15,10 When .F.

	@ 037,070 Get _cCompra  Picture "@!" Valid(fCompra()) Size 15,10
	@ 057,070 Get _nDiasAbo Picture "99" When .F. Size 15,10 
	@ 057,170 Get _nDiasFer Picture "99" When .F. Size 15,10

	@ 077,070 Get _dDataIni valid(fDataIni(@_dDataini)) Size 40,10
	@ 077,170 Get _dDataMax Size 40,10 When .f.
	@ 100,070 Get _dDataFim Size 40,10 When .f.
    
	@ 130,080 BMPBUTTON TYPE 01 ACTION fGrava()

	@ 130,120 BMPBUTTON TYPE 02 ACTION Close(oDlg6)

	ACTIVATE DIALOG oDlg6 CENTERED

Return


Static function fExistApr()
Local lRet := .T.
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])
_cMail := ''

QAA->(DbsetOrder(6))
ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+PadR(_cLogin,TamSx3("ZRJ_LOGIN")[1])))
While !ZRJ->(Eof()) .AND. Alltrim(ZRJ->ZRJ_LOGIN) == _cLogin

	If Alltrim(ZRJ->ZRJ_CC) == "<todos>"
		lRet := .T.
		If QAA->(DbSeek(+_cLogin))
			_cMail := ALLTRIM(QAA->QAA_EMAIL)
		Endif

		Exit
	Endif

	If Alltrim(ZRJ->ZRJ_CC) == aLLTRIM(ZRG->ZRG_CC)
		If QAA->(DbSeek(+_cLogin))
			_cMail := ALLTRIM(QAA->QAA_EMAIL)
		Endif
		lRet := .T.
		Exit
	Endif
	ZRJ->(DbSkip())

Enddo

If !lRet 
	MsgBox("Login nao autorizado para alterar este Centro de Custo, Favor Verificar !","Centro de Custo","ALERT")
	lRet := .F.
Endif


Return(lRet)
//
Static Function fGrava()
	RecLock("SRF",.f.)
	SRF->RF_DATAINI := _dDataIni
	SRF->RF_TEMABPE := _cCompra
	SRF->RF_DFEPRO1 := _nDiasFer 
	SRF->RF_DABPRO1 := _nDiasAbo                    
	MsUnLock("SRF")

	//Email164i()

    Close(oDlg6)
Return 
 

// Lancamento da programacao de Ferias
User Function fPrgExc()
	If !fExistApr()
		Return
	Endif	

	SRA->(DbSetOrder(1))         

	If SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
		If SRA->RA_SITFOLH == 'F'
			Alert('Já existe Ferias calculada para o Funcionario')
			Return
		Endif			
	Endif

	_cCompra  := "N"
	_dAquisi1 := Ctod(Space(08))
	_dAquisi2 := Ctod(Space(08))
	_nDiasven := 0
	_nDiaspro := 0
	_dDatamax := Ctod(Space(08))
	_dDataIni := Ctod(Space(08))
	_dDataFim := Ctod(Space(08))
    _nDiasFer := 0

	SRF->(DbSeek(xFilial("SRF")+ZRG->ZRG_MAT))
	If SRF->RF_MAT == ZRG->ZRG_MAT
		_dAquisi1 := SRF->RF_DATABAS
		_dAquisi2 := (SRF->RF_DATABAS + 364)
		_nDiasven := SRF->RF_DFERVAT - SRF->RF_DFERANT		
		_nDiaspro := SRF->RF_DFERAAT
		_dDatamax := (SRF->RF_DATABAS + 684)
		_dDataIni := SRF->RF_DATAINI
		_dDataFim := (SRF->RF_DATAINI + SRF->RF_DFEPRO1)
		_cCompra  := SRF->RF_TEMABPE
		_nDiasFer := SRF->RF_DFEPRO1
		_nDiasAbo := SRF->RF_DABPRO1
	Else
		Alert("Nao existe programacao de Ferias para este Funcionario, Verifique")
		Return	
	Endif
   
   _cFunc   := "Funcionario: " +ZRG->ZRG_MAT + " - " +ZRG->ZRG_NOME
   
	@ 096,042 TO 450,500 DIALOG oDlg6 TITLE _cFunc


	@ 010,014 Say OemToAnsi("Periodo Aquisitivo") Size 60,10

	@ 025,014 Say OemToAnsi("Dias Vencidos    ") Size 60,10
	@ 025,120 Say OemToAnsi("Proporcional") Size 60,10
                                                      
	@ 040,014 Say OemToAnsi("Abono?") Size 60,10


	@ 060,014 Say OemToAnsi("Dias Abono") Size 70,10
	@ 060,120 Say OemToAnsi("Dias Ferias") Size 70,10
	
	@ 080,014 Say OemToAnsi("Inicio das Ferias") Size 70,10
	@ 080,120 Say OemToAnsi("Data maxima Saida") Size 70,10
	
	@ 100,014 Say OemToAnsi("Final das Ferias") Size 70,10

	@ 007,070 Get _dAquisi1 Size 40,10 When .F.
	@ 007,120 Get _dAquisi2 Size 40,10 When .F.

	@ 023,070 Get _nDiasVen Size 15,10 When .F.
	@ 023,170 Get _ndiasPro Size 15,10 When .F.

	@ 037,070 Get _cCompra  Picture "@!" Size 15,10 When .F.
	
	@ 057,070 Get _nDiasAbo Picture "99" When .F. Size 15,10 
	@ 057,170 Get _nDiasFer Picture "99" Size 15,10 When .F.

	@ 077,070 Get _dDataIni Size 40,10 When .F.
	@ 077,170 Get _dDataMax Size 40,10 When .f.
	@ 100,070 Get _dDataFim Size 40,10 When .f.

	@ 130,080 BMPBUTTON TYPE 01 ACTION fExPrg()
	@ 130,120 BMPBUTTON TYPE 02 ACTION Close(oDlg6)

	ACTIVATE DIALOG oDlg6 CENTERED

Return

Static Function fExPrg()
	RecLock("SRF",.f.)
	SRF->RF_DATAINI := Ctod(Space(08))
	SRF->RF_TEMABPE := ''
	SRF->RF_DFEPRO1 := 0
	SRF->RF_DABPRO1 := 0
	MsUnLock("SRF")
    Close(oDlg6)
Return 


Static Function fDataIni()
Local lRet := .T.
    
	If _dDataIni == Ctod(Space(08))
		Alert("Data inicio das Ferias vazio, Corrija !")
		lRet := .F.
	Endif   


	If SRA->RA_TNOTRAB $ '007/008/009/010'
		_dDataFim := (_dDataIni + _nDiasFer -1)
		Return(lRet)
	Endif


	If Dow(_dDataIni) <> 2 
		Alert("Ferias, sempre com inicio na Segunda-Feira. Corrija!")
		lRet := .F.
	Endif
	


	If  (_dDataIni - 10) < DATE()
		Alert("Programacao de Ferias, devera ser solicitada ** COM 10 DIAS** de antecedencia!")
		lRet := .F.
	Endif	



	//-- feriados 
	If Substring(Dtos(_dDataIni),5,4) $ '0101/0421/0603/0907/0908/1210/1102/1511/2512' 

		If Dow(_dDataIni) == 2
			_dDataIni := _dDataIni + 1
		Else
			Alert("Inicio de Ferias nao pode iniciar no feriado. Corrija!")
			lRet := .F.
		Endif	

	Endif

	_dDataFim := (_dDataIni + _nDiasFer -1)


Return(lRet) 


// - 
Static Function fCompra()
Local lRet := .F.

	If		_cCompra == "S"
		lRet := .T.
		_nDiasAbo := 10
		_nDiasFer := 20

	Elseif  _cCompra == "N"
		lRet := .T.
		_nDiasAbo := 0
		_nDiasFer := 30

	Else
		Alert("Abono pecuniario, deve responder (S/N)")

	Endif

Return(lRet)

Static Function fDias()
Local lRet := .F.

	If _cCompra == "S"
		If _nDiasFer >= 10 .and. _nDiasFer <= 20
			lRet := .T.
		Else
			Alert("Dias de Ferias Superior ao Permitido, Verifique")
		Endif
	Else
		If _nDiasFer >= 10 .and. _nDiasFer <= 30
			lRet := .T.
		Else
			Alert("Dias de Ferias Superior ao Permitido, Verifique")
		Endif
	Endif	

Return(lRet)


Static Function Email164i()
Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
Local lConectou
Local lEnviado
Local cMsg      := ""

cMsg := _cFunc + chr(13)+chr(10)
cMsg += "Abono         : " + _cCompra + chr(13)+chr(10)
cmSG += "Dias Abono    : " + Alltrim(Str(_nDiasAbo)) + chr(13)+chr(10)
cMsg += "Dias de Ferias: " + Alltrim(Str(_nDiasFer)) + chr(13)+chr(10)
cMsg += "Data Inicio   : " + Alltrim(Dtoc(_dDataIni)) + chr(13)+chr(10)

oMail          := Email():New()
oMail:cMsg     := cMsg
oMail:cAssunto := "*** PROGRAMACAO DE FERIAS *** " + _cFunc 
oMail:cTo      := _cMail
                                                                                 
oMail:Envia()

Return(.T.)
