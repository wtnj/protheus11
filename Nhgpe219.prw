/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE219  ºAutor  ³Marcos R. Roquitski º Data ³  11/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de aprovacao Horas extras/funcionarios.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
     
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**********************************************************************************************************************************/
user function Nhgpe219()
       
  // area atual
  local aArea := getArea()

  private _aGrupo, _clApelido, _clNome   
  // titulo do cadastro
  private cCadastro := "Plano de Recuperação de Produção Horas Extras"

  // funções
  private aRotina := { {"Pesquisar",   "AxPesqui", 0, 1},;  // botao pesquisar
                       {"Visualizar",  "U_fgpe222s",0,2},;  // botao aprovacao
       	               {"Legenda" ,    "U_Fgpe217l",0,3},;  // botao legenda
                       {"Aprovar",     "U_fgpe219a",0,5}}   // botao aprovacao

  _aGrupo   :=  {}
  _aGrupo   :=  pswret()
  _clApelido := _agrupo[1,2 ] // Apelido
  _clNome    := _agrupo[1,4 ] // Nome completo

  // abre o browse com os dados
  dbSelectArea("ZZ7")
  ZZ7->(dbSetOrder(1))
  set filter to Empty(ZZ7->ZZ7_STATUS)
  ZZ7->(dbGoTop())


  // abre o browse
  mBrowse(,,,,"ZZ7", nil, nil, nil, nil, nil, fCriaCor() )

  set filter to 
  ZZ7->(dbGoTop())
  
  // restaura a area
  restArea(aArea)

return nil

//
Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_AZUL"    , "Aberto      " },;
						{"BR_VERMELHO", "Aprovado    " },;
						{"BR_VERDE"   , "Realizado   " }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZZ7_STATUS = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZZ7_STATUS = "A"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZZ7_STATUS = "R"' , aLegenda[3][1] } )

Return(uRetorno)

//
Static Function fEnd() 
   Close(oDialog) 

Return

// 
User Function fgpe219i()

If fExistApr()
	If MsgBox("Aprova Programacao de Horas Extras ","Aprovar","YESNO")
		DbSelectArea("ZZ7")
		Reclock("ZZ7",.F.)
		ZZ7->ZZ7_STATUS  := "A"
		MsUnlock("ZZ7")
	Endif
	ZZ7->(dbGoTop())
Endif

Return 

Static function fExistApr()
Local lRet := .F.
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])
_cMail := ''

QAA->(DbsetOrder(6))
ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+_cLogin))
While !ZRJ->(Eof()) .AND. Alltrim(ZRJ->ZRJ_LOGIN) == _cLogin

	If Alltrim(ZRJ->ZRJ_CC) == aLLTRIM(ZZ7->ZZ7_CC) .and. ZRJ->ZRJ_AHE == 'S'
		If QAA->(DbSeek(+_cLogin))
			_cMail := ALLTRIM(QAA->QAA_EMAIL)
		Endif
		lRet := .T.
		Exit
	Endif
	ZRJ->(DbSkip())

Enddo

If !lRet 
	MsgBox("Login: "+_cLogin+ " nao autorizado aprovar Horas Excedentes, Favor Verificar !","Aprovacao","ALERT")
	lRet := .F.
Endif

Return(lRet)



//
User Function Fgpe219a()

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cNum,_cCc,_cCdesc,_cdData")


DEFINE FONT oFont NAME "Arial" SIZE 10, -12
DEFINE FONT oFont10 NAME "Arial" SIZE 20, -10 

_lFlag     := .T.
lDialog    := .T. 
_cCc       := ZZ7->ZZ7_CC  
_cCdesc    := ZZ7->ZZ7_CDESC
aHeader    := {}        
aCols      := {}
_cMoeda    := Space(1)
nMax       := 1
_cdData    := ZZ7->ZZ7_DATA1 
_cdDataf   := ZZ7->ZZ7_DATA2
_aComData  := {}
_aGrupo    := {}
_aGrupo    :=  pswret()
_clApelido := _agrupo[1,2 ] // Apelido
_clNome    := _agrupo[1,4 ] // Nome completo


fBuscaZZ8()

Aadd(aHeader,{"Matr"           , "ZZ8_MAT",   "@!"               ,10,0,"ExecBlock('_vSraMat',.F.,.F.)","","C","ZZ8"}) 
Aadd(aHeader,{"Nome"           , "ZZ8_NOME",  Repli("!",40)      ,40,0,".T.","","C","ZZ8"}) //03
Aadd(aHeader,{"C. Custo"       , "ZZ8_CC",    "@!"               ,12,2,"ExecBlock('fVlZ8017',.F.,.F.)",".T.","N","ZZ8"})
Aadd(aHeader,{"Hora Inicio"    , "ZZ8_HORAI", "99:99"            ,10,0,"ExecBlock('_vSraHori',.F.,.F.)",".T.","C","ZZ8"}) //03 _vSraHori()
Aadd(aHeader,{"Hora Final"     , "ZZ8_HORAF", "99:99"            ,10,0,".T.","","C","ZZ8"}) //03

Define MsDialog oDialog2 Title OemToAnsi("Autorizacao de Horas Extras") From 010,030 To 550,860 Pixel 

@ 013,007 To  52,410 Title OemToAnsi("  Horas Extras") //Color CLR_HBLUE

@ 027,010 Say "C. Custo:" Size 030,8 Object oNum
@ 025,035 Get _cCc Picture "@!" When .F. Size 050,10 Object oCc
oCc:Setfont(oFont)

@ 027,100 Say "Descrição:" Size 30,8 object oCdesc
@ 025,130 Get _cCdesc Picture "@!" When .F. Size 110,8 Object oCdesc
oCdesc:Setfont(oFont)

@ 027,260 Say "Periodo:" Size 30,8 object odData
@ 025,285 Get _cdData  Picture "@!" When .f. Size 40,8 Object odData


@ 027,332 Say "Ate" Size 30,8 object odData
@ 025,345 Get _cdDataf Picture "@!" When .f. Size 40,8 Object odDataf


@  40,006 To 220,410 Title OemToAnsi(" Seleciona Funcionarios ")  
@  50,006 TO 240,410 MULTILINE OBJECT oMultiline 

@ 250,340 BMPBUTTON TYPE 13 ACTION fGrvAdt() // grava 13
@ 250,380 BMPBUTTON TYPE 02 ACTION fEnd2()   //  cancela 02
                                   	

Activate MsDialog oDialog2 Center 

ZZ8->(DbCloseArea())

Return           


//
Static function fBuscaZZ8()
Local lRet := .f.
_cCc       := ZZ7->ZZ7_CC  
_cdData    := ZZ7->ZZ7_DATA1
_cNra      := ZZ7->ZZ7_NRA

	aCols := {}
	
	If Valtype(_cdData) == 'D'
		_dData := _cdData
	Else
	    _dData := Ctod(_cdData)
	Endif	

	// Seleciona ZZ8
	DbSelectArea("ZZ8") 
	ZZ8->(DbSetOrder(3)) 
	ZZ8->(Dbseek(xFilial("ZZ8")+_cNra)) 
	While ZZ8->ZZ8_NRA == _cNra
		Aadd(aCols,{ZZ8->ZZ8_MAT,ZZ8->ZZ8_NOME,ZZ8->ZZ8_CC,ZZ8->ZZ8_HORAI,ZZ8->ZZ8_HORAF,.F.})
		ZZ8->(DbSkip()) 
	Enddo 
   

	ASORT (aCols,,, {|a, b| a < b })

Return


// Grava 
Static Function fGrvAdt()
Local _dDataCol := Ctod(Space(08))
Local _nNrFun := 0

If fExistApr()

  If MsgBox("Aprova Programacao de Horas Extras ","Aprovar","YESNO")

	For _y:=1 to Len(aCols) 
		If !Empty(Acols[_y][1]) .And. !Acols[_y][len(aHeader)+1]  //nao pega quando a linha esta deletada 
			_nNrFun++ 
		Endif 
	Next _y
	
	If _nNrFun > ZZ7->ZZ7_QTP1
		Alert("Numero de Funcionarios Programado: "+Alltrim(Str(_nNrFun))+ ",  MAIOR que o Aprovado: "+Alltrim(Str(ZZ7->ZZ7_QTP1))+" Verifique!")
		Return

	Endif		

	// grava
	For _x:=1 to Len(aCols)
           
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada

			_cMat     := StrZero(Val(Acols[_x][1]),12) // 000000002512 
			_cDai     := Alltrim(Str(Year(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA1))) + ' 00:00:00.000' 
			_cAFi     := '1' 
			_cDaf     := Alltrim(Str(Year(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA2))) + ' 00:00:00.000' 
			_cAce     := '1'  
			_cV1      := ''
			_cAlo     := '01' 
			_cF1      := '00002359' 
			_cF2      := '00000000' 
			_cF3      := '00000000' 
			_cF4      := '00000000' 
			_cF5      := '00000000' 
			_cF6      := '00000000' 
			_cF7      := '00000000' 
			_cV1      := '' 
			_cSa      := 'S' 
			_cDo      := 'S' 

			nRet := TCSQLEXEC("INSERT INTO DbForponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	

		Endif   
		   
	Next _x

	DbSelectArea("ZZ7")
	Reclock("ZZ7",.F.)
	ZZ7->ZZ7_STATUS  := "A"
	MsUnlock("ZZ7") 
	COMMIT
	
	ZZ7->(dbGoTop())

  Endif

Endif
  
Close(oDialog2) 

Return

//
Static Function fEnd2()
   Close(oDialog2) 

Return
