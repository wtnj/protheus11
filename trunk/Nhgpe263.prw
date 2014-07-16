/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE263  ºAutor  ³Marcos R. Roquitski º Data ³  22/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recadastramento de vale transporte, veiculos                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
     
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**********************************************************************************************************************************/

User Function Nhgpe263()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","U_fgpe263i()",0,3}}

             
cCadastro := "Veiculos X Funcionarios"

mBrowse(,,,,"ZZ9",,,)

Return

/*
user function Nhgpe263()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,cMarca")

	private _aGrupo, _clApelido, _clNome   
	
	fgpe263i()        
                                                             
return nil
*/

//
User Function fgpe263i()
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

DbSelectArea("ZZ9")
ZZ9->(DbSetOrder(1))	


Aadd(aHeader,{"Veiculo"     , "ZZ9_VEIC",   "@!"               ,20,0,".T.","","C","ZZ9"}) 
Aadd(aHeader,{"Modelo"      , "ZZ9_MOD",    "@!"               ,10,0,".T.","","C","ZZ9"}) 
Aadd(aHeader,{"Placa"       , "ZZ9_PLACA",  "@R !!!-9999"      ,07,0,".T.","","C","ZZ9"}) 
Aadd(aHeader,{"Cor"         , "ZZ9_COR",    "@!"               ,15,0,".T.","","C","ZZ9"}) 


Define MsDialog oDialog Title OemToAnsi("** CADASTRO DE VEICULOS **") From 010,030 To 550,860 Pixel

@ 013,007 To  100,410 Title OemToAnsi("Dados Pessoais") //Color CLR_HBLUE

@ 027,010 Say "Matricula:" Size 030,8 Object _oMat
@ 025,040 Get _cMat Picture "@!" Valid _fFunc() F3 ("SRA") Size 050,10 Object _oMat
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


@ 105,007 To 230,410 Title OemToAnsi(" Veiculos utilizados ") 

@ 120,016 TO 220,400 MULTILINE MODIFY DELETE OBJECT oMultiline 

@ 250,340 BMPBUTTON TYPE 13 ACTION fGrvAdt()   // grava 13
@ 250,380 BMPBUTTON TYPE 02 ACTION fEnd()      // cancela 02

                                    	
Activate MsDialog oDialog Center

Return           

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

		aCols  := {}     

     	
		ZZ9->(DbSeek(xFilial("ZZ9")+_cMat)) 
		While ZZ9->(!EOF()) .and. ZZ9->ZZ9_MAT == SRA->RA_MAT 
			aAdd(aCols,{ZZ9->ZZ9_VEIC,ZZ9->ZZ9_MOD,ZZ9->ZZ9_PLACA,ZZ9->ZZ9_COR,.F.}) 
			ZZ9->(DbSkip()) 
		Enddo	

		If Len(Acols) <= 0
			aAdd(aCols,{"1",Space(15),Space(07),Space(15),.F.}) 			
		Endif
		
	Else

		Alert("** FUNCIONARIO NAO CADASTRADO **")
		_lRet := .F.
		
	Endif	
	oMultiline:Refresh()
Return _lRet


//
Static Function fEnd()                                                                                                                                                           
//	TZZ9->(DbCloseArea())
	Close(oDialog) 

Return


// Grava 
Static Function fGrvAdt() 
Local _dDataCol := Ctod(Space(08))

	DbSelectArea("ZZ9")
	If ZZ9->(DbSeek(xFilial("ZZ9")+SRA->RA_MAT)) 
		While ZZ9->(!EOF()) .and. ZZ9->ZZ9_MAT == SRA->RA_MAT 
			Reclock("ZZ9",.F.) 
			ZZ9->(DbDelete()) 
			MsUnlock("ZZ9")	
			ZZ9->(DbSkip()) 
		Enddo	
	Endif	
	ZZ9->(DbGotop())

	DbSelectArea("SRA")
	Reclock("SRA",.F.)   
	SRA->RA_ENDEREC   := _cEnde
	SRA->RA_COMPLEM   := _cComp
	SRA->RA_BAIRRO    := _cBair
	SRA->RA_MUNICIP   := _cMuni
	SRA->RA_CEP       := _cCep
	MsUnlock("SRA")

	DbSelectArea("ZZ9")
	For _x := 1 to Len(aCols)
           
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada

			Reclock("ZZ9",.T.)
			ZZ9->ZZ9_FILIAL  := xFilial("ZZ9")
			ZZ9->ZZ9_MAT     := SRA->RA_MAT
			ZZ9->ZZ9_NOME    := SRA->RA_NOME
			ZZ9->ZZ9_TIPO    := "1" // FUNCIONARIO
			ZZ9->ZZ9_VEIC    := Acols[_x][1]
			ZZ9->ZZ9_MOD     := Acols[_x][2]
			ZZ9->ZZ9_PLACA   := Acols[_x][3]
			ZZ9->ZZ9_COR     := Acols[_x][4]									
			MsUnlock("ZZ9")
            
		Endif   
		   
	Next _x

	Close(oDialog)	                           

Return

