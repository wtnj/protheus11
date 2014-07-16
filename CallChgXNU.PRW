/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALLCHGXNUบAutor  ณJoใo Felipe da Rosa บ Data ณ  14/03/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para montagem do menu do usuแrio          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACFG                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                                                                                     
#include "tbiconn.ch"
#INCLUDE 'PROTHEUS.CH'
              
User Function CallChgXNU()  
Private nModNum := PARAMIXB[4]

cNumMod := AllTrim(Str(nModNum))

//-- grava log de acesso por modulo
StartJob("U_NHLOGMOD()",GETENVSERVER(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,cNumMod,cUserName)

/*
IF !ALLTRIM(UPPER(cUserName))$'JOAOFR/AXX'
	return PARAMIXB[5]
Endif

If msgyesno("Menu padrใo?")
	return PARAMIXB[5]
ENDIF
*/

lCria := StartJob("U_NHQRYXNU()",GETENVSERVER(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,cNumMod,cUserName)

if !lCria
	return PARAMIXB[5]
Endif

Return '\SYSTEM\USERMENU\'+ALLTRIM(LOWER(cUserName))+'_'+alltrim(cNumMod)+'.xnu'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ grava log de acesso por modulo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function NHLOGMOD(cEmp,cFil,cNMod,cUsr)

	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES 'ZEU'
	
	ZEU->(dbsetorder(1)) // FILIAL + LOGIN + MODULO
	If ZEU->(DBSEEK(XFILIAL("ZEU")+padr(cUsr,30)+cNMod))
		RecLock('ZEU',.F.)
			ZEU->ZEU_DATA := date()
		Msunlock()
	Else
		RecLock('ZEU',.T.)
			ZEU->ZEU_FILIAL := xFilial('ZEU')
			ZEU->ZEU_LOGIN  := cUsr
			ZEU->ZEU_MODULO := cNMod
			ZEU->ZEU_DATA   := date()
		Msunlock()
	Endif
	
	reset environment

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA O XNU DO USUARIO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function NHQRYXNU(cEmp,cFil,cNMod,cUsr)
Local cAl  := getnextalias()
Local cStr := ''
Private cEOL := Chr(13)+chr(10)

Private cNumMod := cNMod
Private cUser   := cUsr
Private lExistZEO := .f.
	
PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES 'ZET'

//-- INICIA MONTAGEM DO XNU
		
cStr := '<ApMenu>' + cEOL
cStr += '	<DocumentProperties>' + cEOL
cStr += '		<Module>USERMENU</Module>' + cEOL
cStr += '		<Version>7.10</Version>' + cEOL
cStr += '	</DocumentProperties>' + cEOL

beginSql Alias cAl
	SELECT * FROM 
		%Table:ZET% 
	WHERE 
		ZET_NUMMOD = %Exp:cNumMod%
	AND ZET_CODPAI = %Exp:''%
	AND ZET_FILIAL = %xFilial:ZET%
	AND %NotDel%
	ORDER BY ZET_MENU,ZET_ORD,ZET_TITPT
endSql

While (cAl)->(!eof())
	cStr += getItens(cAl)
	(cAl)->(dbskip())
Enddo

(cAl)->(dbclosearea())

cStr += '</ApMenu>'

cARQ := FCreate('\SYSTEM\USERMENU\'+ALLTRIM(LOWER(cUser))+'_'+alltrim(cNumMod)+'.xnu')
FWrite(cArq, cStr )
FClose(cArq)

//ALERT('\system\USERMENU\'+ALLTRIM(LOWER(cUserName))+'.xnu')
reset environment

Return lExistZEO

Static Function getItens(cAlPar)
Local cStr := ''
Local cAl := getnextalias()

	If (cAlPar)->ZET_MENU=='1' //-- 1 = MENU, 2 = SUBMENU

		beginSql Alias cAl
		
			SELECT *, ' ' AS ZEO_ACCESS FROM %TABLE:ZET%
			WHERE ZET_NUMMOD = %Exp:cNumMod%
			AND ZET_CODPAI = %Exp:(cAlPar)->ZET_COD%
			AND ZET_MENU   = %Exp:'1'%
			AND ZET_FILIAL = %xFilial:ZET%
			AND ZET_BLQ<>'S'
			AND %NotDel%
			
			UNION
			
			SELECT 
				ZET.*, ZEO_ACCESS
			FROM 
				%Table:ZET% ZET,
				%Table:ZEO% ZEO
			WHERE 
				ZET_COD = ZEO_CODZET
			AND ZEO_LOGIN = %Exp:upper(alltrim(cUser))%
			AND ZET_NUMMOD = %Exp:cNumMod%
			AND ZET_FILIAL = %xFilial:ZET%
			AND ZEO_FILIAL = %xFilial:ZEO%
			AND ZET.%NotDel%
			AND ZEO.%NotDel%
			AND ZET.ZET_BLQ<>'S'
			AND ZET_CODPAI = %Exp:(cAlPar)->ZET_COD%
			
			ORDER BY ZET_MENU,ZET_ORD,ZET_TITPT
			
		endSql
		
		IF (CAL)->(!EOF())
	
			cStr += '<Menu Status="Enable">' + cEOL
			cStr += '<Title lang="pt">'+ALLTRIM(oemtoansi((cAlPar)->ZET_TITPT))+'</Title>' + cEOL
			cStr += '<Title lang="es">'+ALLTRIM(oemtoansi((cAlPar)->ZET_TITES))+'</Title>' + cEOL
			cStr += '<Title lang="en">'+ALLTRIM(oemtoansi((cAlPar)->ZET_TITEN))+'</Title>' + cEOL
			
			While (cAl)->(!eof())
				cStr += getItens(cAl)
				(cAl)->(dbskip())
			Enddo
					
			cStr += '</Menu>' + cEOL	
	
		ENDIF
		
		(cAl)->(dbclosearea())
				
	
		
	ElseIf (cAlPar)->ZET_MENU=='2' //-- 1 = MENU, 2 = SUBMENU

		cStr += '<MenuItem Status="Enable">' + cEOL
		cStr += '<Title lang="pt">'+ALLTRIM((cAlPar)->ZET_TITPT)+'</Title>' + cEOL
		cStr += '<Title lang="es">'+ALLTRIM((cAlPar)->ZET_TITES)+'</Title>' + cEOL
		cStr += '<Title lang="en">'+ALLTRIM((cAlPar)->ZET_TITEN)+'</Title>' + cEOL
		cStr += '<Function>'+(cAlPar)->ZET_FUNCAO+'</Function>' + cEOL
		cStr += '<Type>'+(cAlPar)->ZET_TIPO+'</Type>' + cEOL
		cStr += '<Access>'+(cAlPar)->ZEO_ACCESS+'</Access>' + cEOL
		cStr += '<Module>'+ALLTRIM(STR((cAlPar)->ZET_NUMMOD))+'</Module>' + cEOL
		cStr += '<Owner>99</Owner>' + cEOL
		cStr += '</MenuItem>' + cEOL
		
		lExistZEO := .t.

	Endif
	
Return cStr