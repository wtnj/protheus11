/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE272 ºAutor  ³Marcos R. Roquitski º Data ³  17/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastra Lista de Funcionarios convocados para horas extrasº±±
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
user function Nhgpe272()

  // area atual
  local aArea := getArea()

	SetPrvt("CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
	SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
	SetPrvt("M_PAG,NOMEPROG,CPERG,cMarca")


  private _aGrupo, _clApelido, _clNome   
  // titulo do cadastro
  private cCadastro := "Plano de Recuperação de Produção Horas Extras"

  // funções
  private aRotina := { {"Legenda" ,      "U_Fgpe272l",0,1},;
                       {"Imprime",       "U_fImp272e",0,2},;
  					   {"Funcionarios",  "U_Fgpe272i",0,3}}

                      
                                                                                    
  _aGrupo   :=  {}
  _aGrupo   :=  pswret()
  _clApelido := _agrupo[1,2 ] // Apelido
  _clNome    := _agrupo[1,4 ] // Nome completo

  // abre o browse com os dados
  dbSelectArea("ZZ7")
  ZZ7->(dbSetOrder(2))
  SET FILTER TO ZZ7->ZZ7_DATA1 >= DATE()
  ZZ7->(dbGoTop())

  // abre o browse
  mBrowse(,,,,"ZZ7", nil, nil, nil, nil, nil, fCriaCor() )

  SET FILTER TO 
  ZZ7->(dbGoTop())
  
  // restaura a area
  restArea(aArea)

return nil

//
User Function Fgpe272l()       

Local aLegenda :=	{	{"BR_AZUL"    , "Aberto      " },;
						{"BR_VERMELHO", "Aprovado    " },;
						{"BR_VERDE"   , "Realizado   " }}

BrwLegenda("Plano de Recuperação de Produção Horas Extras", "Legenda", aLegenda)

Return  


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



User Function Fgpe272i()

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

If !Empty(ZZ7->ZZ7_DATA1) 
	fBuscaZZ8()
Else
	Alert('Programacao de horas extras NAO CADATRADA. Verifique com RH')
	Return
Endif	

//_aComData := {Dtoc(ZZ7->ZZ7_DATA1),Dtoc(ZZ7->ZZ7_DATA2),Dtoc(ZZ7->ZZ7_DATA3),Dtoc(ZZ7->ZZ7_DATA4)} 
//Aadd(aHeader,{"Matr"           , "ZZ8_MAT",   "@!"               ,10,0,"ExecBlock('fZz8Tipo',.F.,.F.)","","C","ZZ8"}) //03

Aadd(aHeader,{"Matr"           , "ZZ8_MAT",   "@!"               ,10,0,"ExecBlock('_vvSraMat',.F.,.F.)","","C","ZZ8"}) 
Aadd(aHeader,{"Nome"           , "ZZ8_NOME",  Repli("!",40)      ,40,0,".T.","","C","ZZ8"}) //03
Aadd(aHeader,{"C. Custo"       , "ZZ8_CC",    "@!"               ,12,2,"ExecBlock('fVlZ8017',.F.,.F.)",".T.","N","ZZ8"})
Aadd(aHeader,{"Hora Inicio"    , "ZZ8_HORAI", "99:99"            ,10,0,"ExecBlock('_vvSraHori',.F.,.F.)",".T.","C","ZZ8"}) //03 _vSraHori()
Aadd(aHeader,{"Hora Final"     , "ZZ8_HORAF", "99:99"            ,10,0,".T.","","C","ZZ8"}) //03

Define MsDialog oDialog Title OemToAnsi("Autorizacao de Horas Extras") From 010,030 To 550,860 Pixel 

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


//@ 025,290 COMBOBOX _cdData  ITEMS _aComData Size 70,8 OBJECT odData


@  40,006 To 220,410 Title OemToAnsi(" Seleciona Funcionarios ")  
@  50,006 TO 240,410 MULTILINE MODIFY Valid fMulti() DELETE OBJECT oMultiline 

@ 250,340 BMPBUTTON TYPE 13 ACTION fGrvAdt() // grava 13
@ 250,380 BMPBUTTON TYPE 02 ACTION fEnd()   //  cancela 02

                                    	
// oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center  // Valid fDialog()
ZZ8->(DbCloseArea())

Return           


//
Static Function fEnd()                                 
   Close(oDialog) 

Return

//
Static Function fMulti
Local _lRet   := .T.
Local _cMatl  := acols[n][1]


                
If Len(acols) == 0
   MsgBox("Favor Digitar a Matricula do Funcionario.","Atençao","ALERT")    
   _lRet := .F.
Else

   If Empty(acols[n][1]) .Or. Empty(acols[n][1]) 
      MsgBox("Matricula em branco, verifique.","Atençao","ALERT") 
      _lRet := .F.
   Endif

Endif   

Return(_lRet)



//
User Function xfZz8Tipo()
Local lRet := .T.
    /*
	If ZZ5->(Dbseek(xFilial("ZZ5")+M->ZZ4_TIPO ))// Acols[n][1]))	
		Acols[n][2] := ZZ5->ZZ5_DESCRI
	Else
		MsgBox("Tipo de despesa Nao Cadastrada!","Despesas","ALERT")
		lRet := .F.
	Endif
	*/
	oMultiline:Refresh()                  
Return(lRet)

//                                                      
User Function xfVlZ8017()
Local lRet := .T.
	oMultiline:Refresh()                  
	
Return(lRet)


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
	//Aadd(aCols,{Space(06),Space(40),Space(09),Space(05),Space(5),.F.})

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

// Validacao 
User Function _vvSraMat()
Local := _lRet := .F.
Local := _lMat := .T.

	M->ZZ8_MAT := StrZero(Val(M->ZZ8_MAT),6)

	If SRA->(DbSeek(xFilial("SRA")+M->ZZ8_MAT))
		If !Empty(SRA->RA_DEMISSA)
			Alert("Atencao, Funcionario Demitido. Verifique !")
			_lRet := .F.					
		//Elseif SRA->RA_SITFOLH == 'F'
		//	Alert("Atencao, Funcionario em Ferias. Verifique !")
		//	_lRet := .T.					
		Elseif SRA->RA_SITFOLH == 'A'
			Alert("Atencao, Funcionario Afastado. Verifique !")
			_lRet := .F.					
		Else		

			For _x:=1 to Len(aCols)
           
				If _x <> n
				
					If Alltrim(Acols[_x][1]) == Alltrim(M->ZZ8_MAT) //Acols[n][1]
					
						Alert("Atencao, Funcionario ja cadastrado. Verifique !")
						_lMat := .F.

					Endif
					
				Endif
			Next		
	    	If _lMat
				M->ZZ8_NOME := SRA->RA_NOME
				M->ZZ8_CC   := SRA->RA_CC
				Acols[n][2] := SRA->RA_NOME
				Acols[n][3] := SRA->RA_CC
				_lRet := .T.
			Endif	
		Endif	
	Else
		Alert("Atencao, Funcionario Nao Cadastrado. Verifique !")
		_lRet := .F.	
	Endif
	oMultiline:Refresh()
Return(_lRet)
 

// Validacao 
User Function _vvSraHori()
Local := _lRet := .T.

	/*
	If Empty(M->ZZ8_HORAI)
		Alert("Atencao, Cadastrar o inicio das Horas. Verifique !")
		_lRet := .F.	
	Endif
	
	If Val(Substr(M->ZZ8_HORAI,1,2)) >= 1 .AND. Val(Substr(M->ZZ8_HORAI,1,2)) <= 24
		_lRet := .T.	
	Else
		Alert("Atencao, Hora inicial fora da faixa. Verifique !")	
		_lRet := .F.	
	Endif
	oMultiline:Refresh()
	*/
Return(_lRet)



//
Static function xxfBuscaZZ8()
Local lRet := .f.
Local _dData := Ctod(Space(08))

	aCols := {}

	If Valtype(_cdData) == 'D'
		_dData := _cdData
	Else
	    _dData := Ctod(_cdData)
	Endif	

	// Seleciona ZZ8
	DbSelectArea("ZZ8") 
	ZZ8->(DbSetOrder(1)) 
	If ZZ8->(Dbseek(xFilial("ZZ8")+Dtos(_dData))) 
		While ZZ8->ZZ8_DATA == _dData 
			Aadd(aCols,{ZZ8->ZZ8_MAT,ZZ8->ZZ8_NOME,ZZ8->ZZ8_CC,ZZ8->ZZ8_HORAI,ZZ8->ZZ8_HORAF,.F.}) 
			ZZ8->(DbSkip()) 
		Enddo 
	Else 
		ZRG->(dBSetOrder(2)) 
		ZRG->(dbSeek(xFilial("ZRG")+_cCc)) 
		While !ZRG->(Eof()) .and. Alltrim(ZRG->ZRG_CC) == Alltrim(_cCc)
			Aadd(aCols,{ZRG->ZRG_MAT,ZRG->ZRG_NOME,ZRG->ZRG_CC,Space(05),Space(5),.F.})
			lRet := .t.
			ZRG->(DbSkip())
		Enddo	
	Endif
	ASORT (aCols,,, {|a, b| a < b })
Return


// Grava 
Static Function fGrvAdt()
Local _dDataCol := Ctod(Space(08))
Local _nNrFun := 0
Local _cStr := ''

	For _y:=1 to Len(aCols) 
		If !Empty(Acols[_y][1]) .And. !Acols[_y][len(aHeader)+1]  //nao pega quando a linha esta deletada 
			_nNrFun++ 
		Endif 
	Next _y
	
	If _nNrFun > ZZ7->ZZ7_QTP1
		Alert("Numero de Funcionarios Programado: "+Alltrim(Str(_nNrFun))+ ",  MAIOR que o Aprovado: "+Alltrim(Str(ZZ7->ZZ7_QTP1))+" Verifique!")
		Return

	Endif		

	//	
	DbSelectArea("ZZ8") 
	ZZ8->(DbSetOrder(3)) 
	ZZ8->(Dbseek(xFilial("ZZ8") + ZZ7->ZZ7_NRA)) 
	While !ZZ8->(Eof()) .AND. ZZ8->ZZ8_NRA == ZZ7->ZZ7_NRA 
		Reclock("ZZ8",.F.)
        ZZ8->(DbDelete())
        MsUnlock("ZZ8")
        ZZ8->(DbSkip())
	Enddo 

	// grava
	For _x:=1 to Len(aCols)

		_cMat  := StrZero(Val(Acols[_x][1]),12) // 000000002512 
		_cDai  := Alltrim(Str(Year(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA1))) + ' 00:00:00.000' 
		_cDaf  := Alltrim(Str(Year(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA2))) + ' 23:59:00.000' 
         
		_cQuery := "DELETE Db_Forponto.dbo.ACESSO_ESPECIAL WHERE ACES_COD_CRACHA = '" + _cMat + "' "
		_cQuery += " AND ACES_DAT_INICIO BETWEEN '" + _cDai + "' AND '" + _cDaf + "' "

		If (TCSQLExec(_cQuery) < 0)
    		Return MsgStop("TCSQLError() " + TCSQLError())
		EndIf

		
		//nRet1  := TCSQLEXEC("DELETE DbForponto.dbo.ACESSO_ESPECIAL WHERE ACES_COD_CRACHA = " + _cMat + " AND ACES_DAT_INICIO BETWEEN " + _cDai + " AND " + _cDaf )
		           
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada

			Reclock("ZZ8",.T.)
			ZZ8->ZZ8_FILIAL  := xFilial("ZZ8")
			ZZ8->ZZ8_MAT     := Acols[_x][1] // Matricual
			ZZ8->ZZ8_NOME    := Acols[_x][2] // Nome                
			ZZ8->ZZ8_CC      := Acols[_x][3] // Centro de Custo
			ZZ8->ZZ8_HORAI   := Acols[_x][4] // Hora Inicial       
			ZZ8->ZZ8_HORAF   := Acols[_x][5] // Hora Final       
			ZZ8->ZZ8_NUM     := ''           // Controle                
			ZZ8->ZZ8_DATA    := _cdData 
			ZZ8->ZZ8_NRA     := ZZ7->ZZ7_NRA
			MsUnlock("ZZ8")

			_cMat     := StrZero(Val(Acols[_x][1]),12) // 000000002512 
			_cDai     := Alltrim(Str(Year(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA1))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA1))) + ' 00:00:00.000' 
			_cAFi     := '1' 
			_cDaf     := Alltrim(Str(Year(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Month(ZZ7->ZZ7_DATA2))) + '-' + Alltrim(Str(Day(ZZ7->ZZ7_DATA2))) + ' 23:59:00.000' 
			_cAce     := '1'  
			_cV1      := ''
			_cAlo11   := '11' // portaria usinagem 
			_cAlo13   := '13' // rh fn 
			_cAlo14   := '14' // eng. fundicao 
			_cAlo15   := '15' // portaria fundicao 
			_cAlo17   := '17' // ponto fabrica 
			_cAlo18   := '18' // ponto fabrica 
			_cAlo19   := '19' // adm 
			_cAlo20   := '20' // acabamento 
			_cAlo21   := '21' // fusao 
			_cAlo33   := '33' // forjaria 
			_cAlo43   := '43' // Ponto virabrequim
			_cAlo54   := '54'
			_cAlo55   := '55
			_cAlo61   := '61
			_cAlo62   := '62
			_cAlo63   := '63
			_cAlo64   := '64
			_cAlo65   := '65
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
            
                                
			/*
			DELETE DbForponto.dbo.ACESSO_ESPECIAL 
			WHERE ACES_COD_CRACHA = '000000002512' 
			AND ACES_DAT_INICIO BETWEEN '2013-09-25 00:00:00.000' AND '2013-09-25 23:00:00.000' 
			*/

			nRet2  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo11+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet3  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo13+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet4  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo14+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet5  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo15+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet7  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo17+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet8  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo18+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet9  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo19+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRet0  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo20+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nReta  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo21+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
			nRetb  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo33+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")				
			nRetc  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo43+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")				
			nRetd  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo54+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")				
			nRete  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo55+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")				
			nRetf  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo61+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")							
			nRetg  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo62+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")							
			nReth  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo63+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")							
			nReti  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo64+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")							
			nRetj  := TCSQLEXEC("INSERT INTO Db_Forponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo65+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")																


		Endif   
		   
	Next _x
      
	Close(oDialog) 


Return


// Grava 
Static Function zzfGrvAdt()
Local _dDataCol := Ctod(Space(08))
Local _nNrFun := 0

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

			Reclock("ZZ8",.T.)
			ZZ8->ZZ8_FILIAL  := xFilial("ZZ8")
			ZZ8->ZZ8_MAT     := Acols[_x][1] // Matricual
			ZZ8->ZZ8_NOME    := Acols[_x][2] // Nome                
			ZZ8->ZZ8_CC      := Acols[_x][3] // Centro de Custo
			ZZ8->ZZ8_HORAI   := Acols[_x][4] // Hora Inicial       
			ZZ8->ZZ8_HORAF   := Acols[_x][5] // Hora Final       
			ZZ8->ZZ8_NUM     := ''           // Controle                
			ZZ8->ZZ8_DATA    := _cdData 
			ZZ8->ZZ8_NRA     := ZZ7->ZZ7_NRA
			MsUnlock("ZZ8")
  

			/*
			_cMat     := StrZero(Val(ZZ8->ZZ8_MAT),12) // 000000002512 
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

			//('000000002512','2013-08-19 00:00:00.000','1','2013-08-19 00:00:00.000','1','01','00002359','00000000','00000000','00000000','00000000','00000000','00000000','S','S')
			//nRet := TCSQLEXEC("INSERT INTO DbForponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cV1+"','"+_cAlo+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	
            */
            
		Endif   
		   
	Next _x
      
	Close(oDialog) 


   	//cQuery += " VALUES ('"+cUserTable+cArquivo+"','"+aCamposSX3[ni][1]+"','"+cType+"','"+alltrim(str(aCamposSX3[ni][3]))+"','"+alltrim(str(aCamposSX3[ni][4]))+"')"
	//nRet := TCSQLEXEC("INSERT INTO DbForponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"') ")	
	// nRet := TCSQLEXEC("INSERT INTO DbForponto.dbo.ACESSO_ESPECIAL VALUES ('"+_cMat+"','"+_cDai+"','"+_cAfi+"','"+_cDaf+"','"+_cAce+"','"+_cAlo+"','"+_cF1+"','"+_cF2+"','"+_cF3+"','"+_cF4+"','"+_cF5+"','"+_cF6+"','"+_cF7+"','"+_cV1+"','"+_cSa+"','"+_cDo+"') ")	

	/*

	nRet := TCSQLEXEC("INSERT INTO DbForponto.dbo.ACESSO_ESPECIAL VALUES ('000000002512','2013-08-09 00:00:00.000','1','2013-08-09 23:59:00.000','1','','19','02010230','00000000','00000000','00000000','00000000','00000000','00000000','','S','S') ")
					//VALUES ('000000002512','2013-08-09 00:00:00.000','1','2013-08-09 23:59:00.000','1','','19','02010230','00000000','00000000','00000000','00000000','00000000','00000000','','N','N') 
	If nRet != 0 
	 	ALERT(TCSQLERROR()) 
		RETURN 
	EndIf 

    */
    

Return



//
User Function fImp272e() 

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "M"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "AUTORIZAÇÃO DE HORAS EXCEDENTES"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SR0"
nTipo    := 0
n_pag    := 1
nPag     := 0
nomeprog := "NHGPE217"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE217"
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
Local i := 0, _nFun := 0

	titulo  := "AUTORIZAÇÃO DE HORAS EXCEDENTES EM: "+Dtoc(ZZ7->ZZ7_DATA1)+" a "+Dtoc(ZZ7->ZZ7_DATA2)
	Cabec1  := "Mat.   Nome                                      C. Custo                           Cargo                      H.Inicio   H.Final"
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)


	// Seleciona ZZ8
	DbSelectArea("ZZ8") 
	ZZ8->(DbSetOrder(3)) 
	ZZ8->(Dbseek(xFilial("ZZ8")+ZZ7->ZZ7_NRA)) 
	While ZZ8->ZZ8_NRA == ZZ7->ZZ7_NRA

		SRA->(DbSeek(xFilial("SRA")+ZZ8->ZZ8_MAT))
		If SRA->(Found())

			If Prow() > 56
				nPag := nPag + 1
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			Endif
			
			@ Prow()+1, 01 Psay ZZ8->ZZ8_MAT
			@ Prow()  , 08 Psay ZZ8->ZZ8_NOME
			@ Prow()  , 50 Psay ZZ8->ZZ8_CC

			If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))  			
				@ Prow()  , 62 Psay Substr(CTT->CTT_DESC01,1,21)
			Endif	

			If SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
				@ Prow()  , 85 Psay SRA->RA_CODFUNC + " " + SRJ->RJ_DESC
			Endif	

			@ Prow()  ,115 Psay ZZ8->ZZ8_HORAI 
			@ Prow()  ,125 Psay ZZ8->ZZ8_HORAF
			_nFun++ 
			
		Endif	
		
		ZZ8->(DbSkip()) 
	Enddo 
	@ Prow()+1, 000 PSAY __PrtThinLine() 
	@ Prow()+1, 001 Psay 'Nr. de Funcionarios: '+Transform(_nFun,"9999")
	@ Prow()+1, 000 PSAY __PrtThinLine() 	
	@ pRow()+6, 01 pSay "Curitiba, "+Alltrim(Str(Day(dDataBase)))+" de "+Mesextenso(Month(dDataBase)) + " de "+Alltrim(Str(Year(dDataBase)))+"."

	@ pRow()+5, 01 pSay "____________________________________________    _______________________________"


	@ pRow()+1,01 pSay "Gestor Direto"  	
	@ pRow()  ,50 pSay "Direto da Area"

	@ Prow()+2, 000 PSAY __PrtThinLine() 
	
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif

MS_FLUSH()
Return


User function _ffSolZz7()
Local lRet := .F.
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])
_cMail := ''

QAA->(DbsetOrder(6))
ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+_cLogin))
While !ZRJ->(Eof()) .AND. Alltrim(ZRJ->ZRJ_LOGIN) == _cLogin

	If ZRJ->ZRJ_SHE == 'S' .AND. Alltrim(ZRJ->ZRJ_CC) == Alltrim(M->ZZ7_CC)
		If QAA->(DbSeek(+_cLogin))
			_cMail := ALLTRIM(QAA->QAA_EMAIL)
		Endif
		lRet := .T.
		Exit
	Endif
	ZRJ->(DbSkip())

Enddo

If !lRet 
	MsgBox("Login: "+_cLogin+ " nao autorizado a solicitar Horas Excedentes, Favor Verificar !","Aprovacao","ALERT")

	lRet := .F.
Endif

Return(lRet)

