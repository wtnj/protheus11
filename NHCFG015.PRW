/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCFG015 ºAutor  ³João Felipe da Rosa º Data ³  08/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GRAVA MENUS XNU NA TABELA (ZET)
			   GRAVA ACESSOS POR USUARIO EM TABELA (ZEO)
			   MOSTRA SENHA DO USUARIO
			   TESTE DE CONEXÃO COM O BANCO MYSQL                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include 'protheus.ch'
#include 'topconn.ch'
#INCLUDE "XMLXFUN.CH"

User Function NHCFG015() 

Private aModulos := RetModName()
Private cLogin := space(25)

	oDlg  := MsDialog():New(0,0,200,430,"Recupera Senha",,,,,,,,,.T.)

	oSay1 := TSay():New(20,10,{||'Nome do usuário:'},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,60,{|u| if(Pcount() > 0, clogin := u,cLogin)},oDlg,50,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .t. },,,,,,,"cLogin")

	oBtn1 := tButton():New(32 ,10,"0 = Fechar"                   ,oDlg,{||oDlg:End()},60,10,,,,.T.)
	oBtn2 := tButton():New(42 ,10,"1 = Conexão Mysql"    		 ,oDlg,{||testMysqlConn()},60,10,,,,.T.)
	oBtn3 := tButton():New(52 ,10,"2 = XNU => ZET"               ,oDlg,{||fXNU2ZET()},60,10,,,,.T.)
	oBtn4 := tButton():New(62 ,10,"3 = USR => ZEO"               ,oDlg,{|| fUsr2ZEO() },60,10,,,,.T.)
	oBtn5 := tButton():New(72, 10,"4 = LOGIN AP11 => Portal"     ,oDlg,{||Processa({||fAP102Portal()},'Atualizando base Portal WHB com informações do SIGACFG...')},60,10,,,,.T.)
	oBtn6 := tButton():New(82, 10,"5 = INF030 => CFG"            ,oDlg,{||Processa({||fConfigUsr()},'Cadastrando usuários automaticamente...')},60,10,,,,.T.)
	oBtn7 := tButton():New(32 ,90,"Senha Atual"					 ,oDlg,{||fSenha()  },40,10,,,,.T.)
	oBtn8 := tButton():New(42 ,90,"Endereço"					 ,oDlg,{|| processa({||fAtivaLL() } ,'ativando ... ')  },40,10,,,,.T.)
	
	oDlg:Activate(,,,.t.,{||.T.},,)

RETURN


Static Function fUsr2ZEO()    

	If msgyesno('Todos?')	
		aAllUsers := AllUsers()
		
		ProcRegua(len(aAllUsers))
		PswOrder(2) // Pesquisa por usuario	
		
		//-- percorre todos os usuarios e adiciona na matriz
		For xU := 1 to len(aAllUsers)
			IncProc()
			
			if aAllUsers[xU][1][1]<>'000000' .AND. !aAllUsers[xU][1][17] //-- SE NAO FOR ADMINISTRADOR e nao estiver bloqueado
	
				IF PswSeek(alltrim(upper(aAllUsers[xU][1][2])),.T.)     
					Processa({|| fGrvAcessos( { pswret(1),{},pswret(3) }) }, 'Copiando acessos dos usuarios para tabela ZEO')
				Endif
			endif
		
		next               
	Else		
		If empty(cLogin)
			alert('informe o login')
			return .f.
		Endif
	    
		PswOrder(2) // Pesquisa poR LOGIN
		If !PswSeek(alltrim(upper(cLogin)),.T.)     
			Return 'ERRO: usuario '+cLogin+' nao encontrado!'
		Endif

		ProcRegua(1)
		
		Processa({|| fGrvAcessos( { pswret(1),{},pswret(3) }) }, 'Copiando acessos dos usuarios para tabela ZEO')
		
	Endif	
	
Return

Static Function fXNU2ZET()
   	U_NHDELSXEF('ZET')
	Processa({|| fGrvAcessos() },'Copiando XNUs para tabela ZET')
return 

Static Function fGrvAcessos(aUsr)
Local cError    := ""
Local cWarning  := ""
Local oXml      := NIL
Local aMenus    := {} 
Local nPosMod   := 0

Local cSiglaModulo := ''

Private nNumModulo := 0
Private cNomeModulo := ''
Private lUsr2ZEO := .f.
Private cNomeMenu := ''

Default aUsr := nil

lUsr2ZEO := Valtype(aUsr)=='A'
                            
If lUsr2ZEO
	cLogin := alltrim(aUsr[1][1][2])
	aMenus := aUsr[3][1]
Else
	cLogin := ''
	aMenus := {}
    
	/*
	aArquivos := Directory("*.xnu")   
	
	For xA:=1 to len(aArquivos)
		aAdd(aMenus,'111\SYSTEM\'+aArquivos[xA][1])
	Next
	*/

	aAdd(aMenus,'111\SYSTEM\COM100.XNU')
	aAdd(aMenus,'111\SYSTEM\QMT100.XNU')
	aAdd(aMenus,'111\SYSTEM\FAT100.XNU')
	aAdd(aMenus,'111\SYSTEM\PCP100.XNU')
	aAdd(aMenus,'111\SYSTEM\FIN100.XNU')
	aAdd(aMenus,'111\SYSTEM\FIS100.XNU')
	aAdd(aMenus,'111\SYSTEM\CTB100.XNU')
	aAdd(aMenus,'111\SYSTEM\ESP100.XNU')
	aAdd(aMenus,'111\SYSTEM\ATF100.XNU')						
	
	
	
Endif

ProcRegua(len(aMenus))
 cMSGERRO := ''
For xM:=1 to Len( aMenus )
	
	incproc( Substr(aMenus[xM],4,50))

	If Substr( aMenus[xM] , 3,1 ) <> 'X' .AND. UPPER(Substr( aMenus[xM] , 5,6 ))$'SYSTEM'
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Descobre de qual módulo é o menu .xnu ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	cMenu := Substr(aMenus[xM],4,50)
    	cNomeMenu := StrTran(Upper(cMenu),'\SYSTEM\','')
    	cNomeMenu := Alltrim(StrTran(cNomeMenu,'.XNU',''))
    	
    	//-- filtra só compras para testar
    	
    	/*
    	If substr(cNomeMenu,1,3)!='COM' .AND. substr(cNomeMenu,5,4)!='COM'
    		Loop
    	Endif
    	*/
    	
    	
    	If Substr(cNomeMenu,1,4)=='SIGA'
    		cSiglaModulo := alltrim(Substr(cNomeMenu,5,4))
    	ElseIf len(cNomeMenu)==6
    		cSiglaModulo := Substr(cNomeMenu,1,3)
    	Else
    	    cMSGERRO += 'nome estranho: '+cNomeMenu+CHR(13)+CHR(10)
    	    Loop
    	Endif  
    	
    	//-- tratamento para modulos com 4 digitos na sigla
    	If cSiglaModulo$'PPA'
    		cSiglaModulo := 'PPAP'
    	Endif
    	If cSiglaModulo$'LOJ'
    		cSiglaModulo := 'LOJA'
    	Endif
    	If cSiglaModulo$'JUR'
    		cSiglaModulo := 'JURI'
    	Endif
		
		cNomeModulo := 'SIGA'+cSiglaModulo
		
		nPosMod := aScan( aModulos , { |x| Upper( AllTrim( x[2] ) ) == AllTrim(cNomeModulo) } )
		If (nPosMod==0)
			//-- pula o módulo configurador
			If !alltrim(cNomeModulo)$'SIGACFG/SIGAPHOTO'
				Alert(cMenu+' - Modulo nao encontrado: '+cNomeModulo)
			Endif
			Loop
		Else
			nNumModulo := aModulos[nPosMod][1]
		Endif
		
		cNomeModulo := PadR(cNomeModulo,8)
		
		If File(cMenu)
    		   			 	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetua a Abertura do Arquivo de menu .xnu
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	        FT_FUse(cMenu)
			FT_FGotop()
		  	Cxml := ''
		  			
			While ( !FT_FEof() )
				cXML += FT_FREADLN()					
				FT_FSkip()
			EndDo
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³Fecha o Arquivo .XNU
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FT_FUse()    
		    
		    cXML := StrTran(cXML,'>&','>')
		    
		    //tratamento tag fora de padrao xml    
		    IF AT('<ReservedWords',cXML)>0
	   			cXML := STRTRAN(cXML, SUBSTR(CXML, AT('<ReservedWords',cXML), AT('</ReservedWords>',cXML) - AT('<ReservedWords',cXML)+16) , '')
	   		ENDIF
		    
		    cXML := EncodeUTF8( cXML ) 
		    
			//-- abre o xml
			oXml := XmlParser(cXML,"_",@cError,@cWarning)

			If ValType(oXml) != "O"
			     cMSGERRO += cMenu+" - "+cError+CHR(13)+CHR(10)
			     Loop
			Endif  
			
			cApm := XmlChildEx( oXml , "_APMENU" )
			
			If (ValType(cApm)=='U')
				cMSGERRO+= cMenu+' - TAG APMENU NAO ENCONTRADA!'+chr(13)+chr(10)
				loop
			Endif
			
			cStr := ''
			
			If(ValType(oXml:_APMENU)!="O")
				cMSGERRO += cMenu+" - Tag APMENU não é objeto"+chr(13)+chr(10)
				loop
			Endif
		
			fRecursive(oXml:_APMENU,'      ')
			
    	EndIf
	Endif
Next

alert( cMSGERRO)

Return

Static Function fRecursive(oXml,cCodPai)
Local cStr := '' 
Local childs := nil
Local xA := 1     
Local cCod := ''

	cCodPai := PadR(cCodPai,6)

	//-- pega o(s) filho(s) do NODE oXml que contenha o nome _MENU
	//-- caso tenha somente um nó, retorna o objeto xml
	//-- senao retorna um array de objetos
	childs := XmlChildEx( oXml , "_MENU" )

	If ValType(childs)=='O' //-- se retornar um unico item, retorna como objeto
		childs := {childs} //entao colocamos num array
	Endif
	
	If ValType(childs)=='A'
		
		For xA:=1 to Len(childs)
			
			//-- desconsidera menus com status = hidden
			If XmlChildEx(childs[xA],'_STATUS')==nil .OR. childs[xA]:_STATUS:TEXT=="Hidden"
				Loop
			EndIF 
			
			If LEN(alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT)))==12 .AND. alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT))$'ATUALIZACOES/ATUALIZAÇÕES/ATUALIZACÕES/ATUALIZAÇOES'
				childs[xA]:_TITLE[1]:TEXT := 'Atualizações'

			ElseIf 'ESPECIFICO_WHB'$STRTRAN(alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT)),' ','_') .OR. ;
				   'ESPECIFICOS_WHB'$STRTRAN(alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT)),' ','_') .OR. ;
				   'ESPECÍFICO_WHB'$STRTRAN(alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT)),' ','_') .OR. ;
				   'ESPECÍFICOS_WHB'$STRTRAN(alltrim(UPPER(childs[xA]:_TITLE[1]:TEXT)),' ','_') 
				   
				childs[xA]:_TITLE[1]:TEXT := 'Específicos WHB'
            Endif
			
			If lUsr2ZEO

				
							
			Else
			
				ZET->(dbsetorder(3)) // ZET_FILIAL+ZET_MODULO+ZET_MENU+ZET_CODPAI+ZET_TITPT
				If ZET->(dbseek(xFilial('ZET')+cNomeModulo+'1'+cCodPai+childs[xA]:_TITLE[1]:TEXT))
					cCod := ZET->ZET_COD
					
					RecLock('ZET',.F.)
						ZET->ZET_PERTEN := ALLTRIM(ZET->ZET_PERTEN) + '/' + cNomeMenu
					MsUnlock('ZET') 
				Else
	
					cCod := GetSxeNum('ZET','ZET_COD')
	
					RecLock('ZET',.T.)
						ZET->ZET_FILIAL := XFILIAL('ZET')
						ZET->ZET_COD    := cCod
						ZET->ZET_MODULO := cNomeModulo
						ZET->ZET_NUMMOD := nNumModulo
						ZET->ZET_MENU   := '1'
						ZET->ZET_CODPAI := cCodPai
						ZET->ZET_TITPT  := childs[xA]:_TITLE[1]:TEXT
						ZET->ZET_TITES  := childs[xA]:_TITLE[2]:TEXT
						ZET->ZET_TITEN  := childs[xA]:_TITLE[3]:TEXT
						ZET->ZET_FUNCAO := ''
						ZET->ZET_TIPO   := ''
						ZET->ZET_ACCESS := ''
						ZET->ZET_OWNER  := ''
						ZET->ZET_PERTEN := cNomeMenu
					MsUnlock('ZET') 
					
					ConfirmSX8()
					
				Endif
			
			Endif
					
			//aAdd(aBase,childs[xA]:_TITLE[1]:TEXT)

			fRecursive(childs[xA],cCod)
			
			//aDel(aBase,Len(aBase))
			//aSize(aBase,Len(aBase)-1)
			
		Next
	EndIf
	
	//-- pega o(s) filho(s) do NODE oXml que contenha o nome _MENUITEM
	//-- caso tenha somente um nó, retorna o objeto xml
	//-- senao retorna um array de objetos
	childs := XmlChildEx( oXml , "_MENUITEM" )
	
	If ValType(childs)=='O' //-- se retornar um unico item, retorna como objeto
		childs := {childs}
	Endif
	
	If ValType(childs)=='A'
		
		For xA:=1 to Len(childs)
			
			//-- desconsidera menus com status = hidden
			If childs[xA]:_STATUS:TEXT=="Hidden"
				Loop
			EndIF      
			
			If lUsr2ZEO 
				
				ZET->(dbsetorder(2)) // filial + modulo + funcao
				If ZET->(dbseek(xFilial('ZET')+cNomeModulo+childs[xA]:_FUNCTION:TEXT))
					cCod := ZET->ZET_COD
				Else
					cMsgErro += 'Acesso não encontrado na tabela ZET. Modulo:'+cNomeModulo+' Funcao: '+childs[xA]:_FUNCTION:TEXT
					Loop
				Endif

				ZEO->(dbsetorder(1)) // filial + login + codzet
				If !ZEO->(dbSeek(xFilial('ZEO')+padr(cLogin,25)+cCod))
					RecLock('ZEO',.T.)
						ZEO->ZEO_FILIAL := xFilial('ZEO')
						ZEO->ZEO_LOGIN  := cLogin
						ZEO->ZEO_CODZET := cCod
						ZEO->ZEO_ACCESS := childs[xA]:_ACCESS:TEXT
					MsUnlock('ZEO')
				Endif
			
			Else

				ZET->(dbsetorder(2)) // filial + modulo + funcao
				If ZET->(dbseek(xFilial('ZET')+cNomeModulo+childs[xA]:_FUNCTION:TEXT))
					
					cCod := ZET->ZET_COD

					RecLock('ZET',.F.)
						ZET->ZET_PERTEN := ALLTRIM(ZET->ZET_PERTEN) + '/' + cNomeMenu
					MsUnlock('ZET') 

				Else
					
					cCod := GetSxeNum('ZET','ZET_COD')
					
					RecLock('ZET',.T.)
						ZET->ZET_FILIAL := XFILIAL('ZET')
						ZET->ZET_COD    := cCod
						ZET->ZET_MODULO := cNomeModulo
						ZET->ZET_NUMMOD := nNumModulo
						ZET->ZET_MENU   := '2'
						ZET->ZET_CODPAI := cCodPai
						ZET->ZET_TITPT  := childs[xA]:_TITLE[1]:TEXT
						ZET->ZET_TITES  := childs[xA]:_TITLE[2]:TEXT
						ZET->ZET_TITEN  := childs[xA]:_TITLE[3]:TEXT
						ZET->ZET_FUNCAO := childs[xA]:_FUNCTION:TEXT
						ZET->ZET_TIPO   := childs[xA]:_TYPE:TEXT
						ZET->ZET_ACCESS := ''
						ZET->ZET_OWNER  := ''
						ZET->ZET_PERTEN := cNomeMenu
					MsUnlock('ZET') 
					
					ConfirmSX8()
	
				Endif

			Endif				

			fRecursive(childs[xA],cCod)
			
		Next
	Endif	

Return cStr

Static Function fAP102Portal()

Local aUsrAP10 := {}
Local nCoun 
Local aUpdQAA := {}
Local aInf031 := {}
Local aInf032 := {}
Local cDelEmp := ''
Local cDelMod := ''

	aAllUsers := AllUsers()
	
	ProcRegua(len(aAllUsers))
	
	//-- percorre todos os usuarios e adiciona na matriz
	For xU := 1 to len(aAllUsers)
		IncProc()
		
		if aAllUsers[xU][1][1]<>'000000' .AND. !aAllUsers[xU][1][17] //-- SE NAO FOR ADMINISTRADOR e nao estiver bloqueado
			
			//-- monta um array com todos os modulos que o usuario tem acesso
			aInf031 := {}
			For xM:=1 to len(aAllUsers[xU][3])
				If substr(aAllUsers[xU][3][xM],3,1)!='X'
					aAdd(aInf031,substr(aAllUsers[xU][3][xM],1,2))
				Endif
			Next
			
			//-- monta um array com os acessos das empresas
			aInf032 := {}
			For xM:=1 to len(aAllUsers[xU][2][6])
				If alltrim(aAllUsers[xU][2][6][xM])=="@@@@" //todas as empresas
					aAdd(aInf032,'DP001')
					aAdd(aInf032,'FN001')
					aAdd(aInf032,'FN002')
					aAdd(aInf032,'ML0ML')
					aAdd(aInf032,'MP001')
					aAdd(aInf032,'NH001')
					aAdd(aInf032,'WF0WF')
					aAdd(aInf032,'WH0WH')
				Else
					aAdd(aInf032,substr(aAllUsers[xU][2][6][xM],1,2)+'0'+substr(aAllUsers[xU][2][6][xM],3,2))
				Endif
			Next

			aAdd(aUsrAP10,{aAllUsers[xU][1][ 2],; // 1 - LOGIN
						   aAllUsers[xU][1][ 4],; // 2 - NOME
						   aAllUsers[xU][1][12],; // 3 - SETOR
						   aAllUsers[xU][1][13],; // 4 - CARGO PROTHEUS
						   aAllUsers[xU][1][14],; // 5 - EMAIL PROTHEUS
						   aAllUsers[xU][1][20],; // 6 - RAMAL PROTHEUS
						   aInf031,;              // 7 - array com os modulos que o usuario tem acesso
						   aInf032;				  // 8 - array com as empresas que o usuário tem acesso
						   })
			

		endif
		
	Next

	U_mysqlConnect()
	     
	//-- SELECIONA os usuarios do portal que nao tem informado o login do protheus no cadastro
	cQuery := " SELECT id, str_login, str_matr, str_emp FROM usuario WHERE str_bloq<>'S' AND (str_loginprotheus='' OR str_loginprotheus IS NULL)"
	TCQUERY cQuery New Alias 'USR'
	
	ProcRegua(0)
	
	nCount := 0
	
	While USR->(!EOF())
		
		IncProc('Atualizando Portal ')
		
		nU := aScan(aUsrAP10,{|x| upper(alltrim(USR->str_login))==ALLTRIM(x[1]) }) // procura o usuario ap10 com mesmo login que o usuario do portal
		
		If nU<>0
			
			//-- ATUALIZA DADOS DO USUARIO DO PORTAL COM DADOS DO AP10
			cQryUpdate := " UPDATE usuario SET "
			cQryUpdate += " str_loginprotheus = '"+ALLTRIM(aUsrAP10[nU][1])+"',"
			cQryUpdate += " str_nomeprotheus  = '"+ALLTRIM(aUsrAP10[nU][2])+"',"
			cQryUpdate += " str_setorprotheus = '"+ALLTRIM(aUsrAP10[nU][3])+"',"
			cQryUpdate += " str_cargoprotheus = '"+ALLTRIM(aUsrAP10[nU][4])+"',"
			cQryUpdate += " str_emailprotheus = '"+ALLTRIM(aUsrAP10[nU][5])+"',"
			cQryUpdate += " str_ramalprotheus = '"+ALLTRIM(aUsrAP10[nU][6])+"'"
			cQryUpdate += " WHERE id = '"+ALLTRIM(STR(USR->id))+"'"
			
			nRet := TCSQLEXEC(cQryUpdate) 
			If nRet != 0
			 	ALERT(TCSQLERROR(),"UPDATE ERROR")
				RETURN
			EndIf
			
			If !Empty(USR->str_matr) .and. !Empty(USR->str_emp)
				aAdd(aUpdQAA,{USR->str_matr,ALLTRIM(aUsrAP10[nU][1]),USR->str_emp})
			Endif
			
			nCount++
			
		EndIf
		
		USR->(dbSkip())
	ENDDO
	
	USR->(dbclosearea())    
	             
	ProcRegua(len(aUsrAp10) + 1)
	IncProc('Atualizando (usr x emp) e (usr x mod)')
		
	For xU:=1 to len(aUsrAP10)
	
		IncProc()
		
		//-- atualiza inf031 - modulos x usuarios
		cDelMod := ''
		For xM:=1 to len(aUsrAP10[xU][7])   
			nRet := TCSQLEXEC( "INSERT IGNORE INTO inf031 (str_loginprotheus,str_nummod) VALUES ( '"+ALLTRIM(aUsrAP10[xU][1])+"', '"+aUsrAP10[xU][7][xM]+"');") 
			If nRet != 0
			 	ALERT(TCSQLERROR())
				RETURN
			EndIf
			
			cDelMod += "'"+aUsrAP10[xU][7][xM]+"'" + Iif(xM==len(aUsrAP10[xU][7]),'',',')
		Next  
		//-- deleta os modulos que nao estiverem configurados
		If !Empty(cDelMod)
			nRet := TCSQLEXEC( "DELETE FROM inf031 WHERE str_loginprotheus = '"+ALLTRIM(aUsrAP10[xU][1])+"' AND str_nummod not in("+cDelMod+");") 
			If nRet != 0
			 	ALERT(TCSQLERROR())
				RETURN
			EndIf
		Endif
		
		//-- atualiza inf032 - empresas x usuarios
		cDelEmp := ''
		For xM:=1 to len(aUsrAP10[xU][8])            
			nRet := TCSQLEXEC( "INSERT IGNORE INTO inf032 (str_loginprotheus,str_emp) VALUES ( '"+ALLTRIM(aUsrAP10[xU][1])+"', '"+aUsrAP10[xU][8][xM]+"');") 
			If nRet != 0
			 	ALERT(TCSQLERROR())
				RETURN
			EndIf
			
			cDelEmp += "'"+aUsrAP10[xU][8][xM]+"'" + Iif(xM==len(aUsrAP10[xU][8]),'',',')
		Next     
		//-- deleta as empresas que nao estiverem configuradas
		If !Empty(cDelEmp)
			nRet := TCSQLEXEC( "DELETE FROM inf032 WHERE str_loginprotheus = '"+ALLTRIM(aUsrAP10[xU][1])+"' AND str_emp not in("+cDelEmp+");") 
			If nRet != 0
			 	ALERT(TCSQLERROR())
				RETURN
			EndIf
		Endif
	Next        
	
//	fConfigUsr()
	
	U_mysqlClose()
	
	//-- atualiza tabela QAA
	
	//-- implementar
	
	ALERT(alltrim(str(nCount))+' Atualizados!')

Return       






// -- CONFIGURA USUARIO A PARTIR DA INF030 DO PORTAL



Static Function fConfigUsr()

Local cPswFile := "sigapss.spf" //Tabela de Senhas
Local cPswId   := ""
Local cPswName := ""
Local cPswPwd  := ""
Local cPswDet  := ""
Local lEncrypt := .F.
Local aPswDet
Local cOldPsw
Local cNewPsw
Local nPswRec

Private cLogin := Space(25)
Private cNome  := Space(30)
Private cSetor := Space(30)
Private cCargo := Space(30)
Private cEmail := Space(30) 
Private cMatri := Space(6)

IF Type( "cEmpAnt" ) <> "C"
	Private cEmpAnt := "01"
EndIF
IF Type( "cFilAnt" ) <> "C"
	Private cFilAnt := "01"
EndIF  

	U_mysqlConnect()

	//-- seleciona todas as pendencias do portal
	cQuery := " SELECT id_inf030, str_altera, str_mat, inf030.str_emp as emp_i30, str_loginprotheus, str_forma, str_logincopia, str_loginrede,str_email, "
	cQuery += " str_nummod, str_codzet, inf033.id as id_inf033, inf033.str_emp as emp_i33 "
	cQuery += " FROM inf030,inf033 "
	cQuery += " WHERE inf033.str_status = 'A'  AND inf030.str_status = 'A' AND inf033.id_inf030 = inf030.id ORDER BY inf030.id "
	TCQUERY cQuery New Alias 'I30'
	
	cIDInf030 := ''
	aMat := {}
	
	While I30->(!EOF())

		//-- se for criação de usuario
		If I30->str_altera == 'N'
              
			//-- Verifica se o login já está cadastrado
			PswOrder(2) // Pesquisa por login
			IF PswSeek(ALLTRIM(UPPER(I30->str_loginprotheus)),.T.)
				oMail          := Email():New()
				oMail:cMsg     := 'Tentativa de inclusão do usuário: '+ALLTRIM(UPPER(I30->str_loginprotheus))+' da Solic. Nº: '+STRZERO(I30->id_inf030,6)+' porém o login já existe cadastrado!'
				oMail:cAssunto := '*** SIGACFG - USUÁRIO JÁ EXISTE ***'  
				oMail:cTo      := 'joaofr@whbbrasil.com.br'
				oMail:Envia() 
				
				/*cIDInf030 := I30->id_inf030
				While I30->id_inf030==cIDInf030
					I30->(dbSkip())
				Enddo
				Loop		*/
			Endif
		Else

			PswOrder(2) // Pesquisa por usuario
			If !PswSeek(alltrim(upper(I30->str_loginprotheus)),.T.)

				oMail          := Email():New()
				oMail:cMsg     := 'O login '+alltrim(upper(I30->str_loginprotheus))+' da solicitação nº: '+I30->id_inf030+' para alteração de usuário não foi encontrado'
				oMail:cAssunto := '*** SIGACFG - LOGIN NÃO ENCONTRADO ***'  
				oMail:cTo      := 'joaofr@whbbrasil.com.br'
				oMail:Envia()
				
				/*
				While I30->id_inf030==cIDInf030
					I30->(dbSkip())
				Enddo
				Loop		
                */
			Endif
			
		EndIf
			
		aAdd(aMat,{ ALLTRIM(UPPER(I30->str_loginprotheus)),;
					I30->str_mat,;
					I30->emp_i30,; //empresa + filial do funcionario para buscar na SRA
					{},;
					{},;
					{},;
					I30->str_altera,; // flag se é alteração ou inclusao
					I30->id_inf030,; //-- id para marcar como status = o
					I30->str_loginrede,;
					I30->str_email })

		cIDInf030 := I30->id_inf030
		While I30->id_inf030==cIDInf030

			nMod := aScan(aMat[len(aMat),4],{|x| x==STRZERO(val(I30->str_nummod),2)+'5'+'/SYSTEM/EST010.XNU' })
			If nMod==0
				aAdd(aMat[len(aMat),4],STRZERO(val(I30->str_nummod),2)+'5'+'/SYSTEM/EST010.XNU')
			Endif
			
			nEmp := aScan(aMat[len(aMat),5],{|x| x== Substr(I30->emp_i33,1,2)+Substr(I30->emp_i33,4,2) })
			If nEmp==0
				aAdd(aMat[len(aMat),5],Substr(I30->emp_i33,1,2)+Substr(I30->emp_i33,4,2) )
			Endif
				
			aAdd(aMat[len(aMat),6],{I30->str_codzet,I30->emp_i33, I30->id_inf033})
			
			I30->(dbSkip())
		Enddo

	EndDo			
			
	U_mysqlClose()

	For xU:=1 to len(aMat)

		cLogin := aMat[xU][1]
		cEmail := aMat[xU][10]
		
		//-- BUSCA E ATUALIZA INFORMACOES VINDO DA FOLHA
		If !Empty(aMat[xU][2]) .AND. !Empty(aMat[xU][3])
				
			cQryRA := " SELECT TOP 1 RA_NOME, RA_SITFOLH, RA_CC, "
	 		cQryRA += "	(SELECT CTT_DESC01 FROM CTTFN0 WHERE CTT_CUSTO = RA_CC AND D_E_L_E_T_ = ' ') AS DESCCC, "
			cQryRA += " (SELECT Q3_DESCSUM FROM SQ3FN0 WHERE Q3_CARGO = RA_CARGO AND D_E_L_E_T_ = ' ') AS CARGO "
			cQryRA += " FROM SRA"+substr(aMat[xU][3],1,3)
			cQryRA += " WHERE RA_MAT='"+aMat[xU][2]+"'"
			cQryRA += " AND D_E_L_E_T_ = ' ' AND RA_FILIAL = '"+substr(aMat[xU][3],4,2)+"'";

			TCQUERY cQryRA NEW ALIAS 'TMPRA'
			
			If TMPRA->(!EOF())
				cNome  := TMPRA->RA_NOME
				cSetor := ALLTRIM(TMPRA->RA_CC)+' '+DESCCC
				cCargo := TMPRA->CARGO

				If !Empty(cLogin)
					//-- ATUALIZA INFORMAÇÕES DO QAA
					cQryQAA := " UPDATE QAA"+substr(aMat[xU][3],1,3)
					cQryQAA += " SET QAA_LOGIN = '"+cLogin+"',"
					cQryQAA += " QAA_APELID = '"+cLogin+"'"
					cQryQAA += " WHERE QAA_MAT = '"+cMatri+"'"
					cQryQAA += " AND QAA_LOGIN != '' "
					cQryQAA += " AND QAA_FIM = '' "
					cQryQAA += " AND D_E_L_E_T_ = '' "
					cQryQAA += " AND QAA_FILIAL = '"+substr(aMat[xU][3],4,2)+"' "  

					nRet := TCSQLEXEC(cQryQAA) 
					If nRet != 0
					 	ALERT(TCSQLERROR())
						RETURN
					EndIf					
							
				Endif
				
				If !Empty(cEmail)
					//-- ATUALIZA INFORMAÇÕES DO QAA
					cQryQAA := " UPDATE QAA"+substr(aMat[xU][3],1,3)
					cQryQAA += " SET QAA_EMAIL = '"+cEmail+"'"
					cQryQAA += " WHERE QAA_MAT = '"+cMatri+"'"
					cQryQAA += " AND QAA_LOGIN != '' "
					cQryQAA += " AND QAA_FIM = '' "
					cQryQAA += " AND D_E_L_E_T_ = '' "
					cQryQAA += " AND QAA_FILIAL = '"+substr(aMat[xU][3],4,2)+"' "  

					nRet := TCSQLEXEC(cQryQAA) 
					If nRet != 0
					 	ALERT(TCSQLERROR())
						RETURN
					EndIf					
				
				Endif
	
			EndIf
				
			TMPRA->(dbclosearea())
			
		EndIf
			
		PswOrder(2) // Pesquisa por login
			
		//-- se for criação de usuario
		If aMat[xU][7] == 'N'
			PswSeek('JOAOFR',.T.)
		Else 
			PswSeek(cLogin,.T.)
		Endif

		//Abro a Tabela de Senhas
		spf_CanOpen(cPswFile) 
			
		aUser := PswRet(1)
		cUsrId := aUser[1][1] // ID do usuario.
		//Procuro pelo usuario Base
		nPswRec := spf_Seek( cPswFile , "2U"+cUsrId , 1 ) 
			
		//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
		spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )
			
		// mostra o password 
		// Alert(SUBSTR(PSWENCRIPT(CPSWPWD,1),9,20))
			
		//Converto o conteudo da string cPswDet em um Array
		aPswDet := Str2Array( @cPswDet , @lEncrypt )
			
		If aMat[xU][7] == 'N'

			aPswDet[1,1]  := GetNextUsr( NIL , "999999" , .T. ) //Atribuindo o Novo user ID
			aPswDet[1,2]  := cLogin //Atribuindo o Nome do novo usuario
	
			//-- O B S.: A senha padrao é o próprio ID do cadastro
			cNewPsw	  	  := PswEncript('S2012',0) //Encriptando a senha para o novo usuario
			
			aPswDet[1,3]  := cNewPsw //Atribuindo a nova senha ao novo usuario
			aPswDet[2,3]  := "\RELATO\" //Atribuindo o diretorio de impressao ao novo usuario
			aPswDet[1,22] := cEmpAnt+cFilAnt+aPswDet[1,1] //Atribuindo o vinculo funcional ao novo usuario

	        aPswDet[3]    := aMat[xU][4] // MENUS XNU
    	    aPswDet[2][6] := aMat[xU][5] // EMPRESAS
			aPswDet[1,15] := 1           // numero de acessos simultaneos
		Else
			//-- atualiza menus e empresas		                 
			
			//-- percorre todos os menus a serem configurados
			For xM:=1 to len(aMat[xU][4])
				//-- busca posicao do menu
				nMod := aScan(aPswDet[3],{|x| Substr(x,1,2)==Substr(aMat[xU][4][xM],1,2) })
				If nMod<>0
					//-- verifica se ja nao esta configurado
					If Substr(aPswDet[3][nMod],3,1)=='X'
						//aPswDet[3][nMod] := Substr(aPswDet[3][nMod],1,2)+'5'+Substr(aPswDet[3][nMod],4,len(aPswDet[3][nMod])-4)
						aPswDet[3][nMod] := UPSTRTRAN(aPswDet[3][nMod],'X','5',1,1)
					Endif
				Endif
			Next
			
			//-- percorre as empresas a configurar
			For xM:=1 to len(aMat[xU][5])
				//-- verifica se ja nao esta configurada
				nEmp := aScan(aPswDet[2][6],{|x| alltrim(x)==alltrim(aMat[xU][5][xM]) })
				If nEmp==0
					aAdd(aPswDet[2][6],alltrim(aMat[xU][5][xM]))
				Endif
			Next
		
		EndIf
		
		aPswDet[1,4]  := cNome   //Atribuindo o nome completo ao novo usuario
		aPswDet[1,12] := cSetor  //Atribuindo o Departamento ao novo usuario
		aPswDet[1,13] := cCargo  //Atribuindo o cargo ao novo usuario
		aPswDet[1,14] := cEmail  //Atribuindo o email ao novo usuario
		
		If !Empty(aMat[xU][6])

			For xZ := 1 to Len(aMat[xU][6])

				cQryZEO := " IF NOT EXISTS ( SELECT ZEO_LOGIN FROM ZEO"+Substr(aMat[xU][6][xZ][2],1,3)
				cQryZEO += " WHERE ZEO_LOGIN='"+cLogin+"' AND ZEO_CODZET='"+aMat[xU][6][xZ][1]+"' AND ZEO_FILIAL = '"+Substr(aMat[xU][6][xZ][2],4,2)+"' ) "
				cQryZEO += " INSERT INTO ZEO"+Substr(aMat[xU][6][xZ][2],1,3)+" (ZEO_FILIAL,ZEO_LOGIN,ZEO_ACCESS,ZEO_CODZET,D_E_L_E_T_,R_E_C_N_O_) " 
		 		cQryZEO += " VALUES( '"+Substr(aMat[xU][6][xZ][2],4,2)+"','"+cLogin+"','xxxxxxxxxx','"+aMat[xU][6][xZ][1]+"','',COALESCE( (SELECT MAX(R_E_C_N_O_)+1 FROM ZEO"+Substr(aMat[xU][6][xZ][2],1,3)+"),1))"
		 		cQryZEO += " ELSE UPDATE ZEO"+Substr(aMat[xU][6][xZ][2],1,3)+" SET D_E_L_E_T_ = '' "
				cQryZEO += " WHERE ZEO_LOGIN='"+cLogin+"' AND ZEO_CODZET='"+aMat[xU][6][xZ][1]+"' AND ZEO_FILIAL = '"+Substr(aMat[xU][6][xZ][2],4,2)+"'"
			
				nRet := TCSQLEXEC(cQryZEO) 
				If nRet != 0
				 	ALERT(TCSQLERROR())
					RETURN
				EndIf
			
			Next
					
		EndIf
			
		//Convertendo as informacoes no novo usuario para gravacao
		cPswDet 	  := Array2Str( @aPswDet , @lEncrypt )

		//Incluindo o novo usuario
		If aMat[xU][7]=='N'
			spf_Insert( cPswFile , "1U"+aPswDet[1,1] , Upper("1U"+aPswDet[1,2]) , "1U"+aPswDet[1,3] , cPswDet )
		Else
			SPF_UPDATE( cPswFile , nPswRec ,@cPswId , @cPswName , @cPswPwd ,cPswDet)
		Endif

		//-- atualiza flag no portal
		U_mysqlConnect()

		If 0 != TCSQLEXEC(" UPDATE inf030 SET str_status='O' WHERE id = '"+ALLTRIM(STR(aMat[xU][8]))+"'") 	
		 	ALERT(TCSQLERROR())
			RETURN
		EndIf
		
		For xM:=1 to len(aMat[xU][6])
			If 0 != TCSQLEXEC(" UPDATE inf033 SET str_status='O' WHERE id = '"+ALLTRIM(STR(aMat[xU][6][xM][3]))+"'") 
			 	ALERT(TCSQLERROR())
				RETURN
			EndIf
		Next    
			
		If 0 != TCSQLEXEC(" UPDATE usuario SET str_loginprotheus='"+cLogin+"' WHERE str_login = '"+ALLTRIM(aMat[xU][9])+"'") 
		 	ALERT(TCSQLERROR())
			RETURN
		EndIf
			
			
		U_mysqlClose()
                                                  

		oMail          := Email():New()
		If aMat[xU][7]=='N'
			oMail:cMsg     := 'Usuario incluido no sistema Protheus ('+cLogin+') '+cNome
			oMail:cAssunto := '*** SIGACFG - NOVO USUÁRIO CADASTRADO ***'  
		ELSE
			oMail:cMsg     := 'Usuario alterado no sistema Protheus ('+cLogin+') '+cNome
			oMail:cAssunto := '*** SIGACFG - USUÁRIO ALTERADO ***'  
		Endif
		oMail:cTo      := 'joaofr@whbbrasil.com.br'
		oMail:Envia()

	Next

Return









Static function fAtivaLL()

	aProd := {{	'SCA10.1.0339.00',.t.,.t.}}
					
	procregua(len(aProd))
	
	for xP:=1 to Len(aProd)
		fatvControle(aProd[xP][1],aProd[xP][2],aProd[xP][3])
	next

	Alert('ok')

Return

Static Function fatvControle(cProd,lLote,lLocaliz)
Local cLote := '2E15-1'
Local cLocaliz := '01'
Local dDtIni := CtoD('30/04/2012')
Local nSomaSBK := 0
Local nSomaSBJ := 0
Local nSomaSB8 := 0
Local nSomaSBF := 0

	SB1->(dbsetorder(1)) //B1_FILIAL + B1_COD
	
	If !SB1->(dbseek(xFilial('SB1')+cProd))
		alert('nao encontrado '+cProd)
		return
	endif
	
	SB9->(dbsetorder(1)) // B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
	
	//-- Saldo inicial por endereço
	SBK->(dbsetorder(3)) // BK_FILIAL+BK_COD+BK_LOCAL+DTOS(BK_DATA)
	//-- Saldo inicial por lote
	SBJ->(dbsetorder(1)) // BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)
	//-- MOVIMENTACOES			
	SD3->(dbSetOrder(3)) //D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ+D3_CF

	SDB->(dbsetorder(1))//DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
	SDA->(dbsetorder(1))//DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA 
	SD5->(dbsetorder(3))//D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE

	BEGIN TRANSACTION 
	
	incproc(SB1->B1_COD)
	
	/*
	If lLote .and. SB1->B1_RASTRO=='L'
		lLote := .f.
	Endif
	
	If lLocaliz .and. SB1->B1_LOCALIZ=='S'
		lLocaliz := .f.
	Endif
	*/
	
	Reclock('SB1',.f.)
		If lLote
			SB1->B1_RASTRO  := 'L'
			SB1->B1_FORMLOT := '001'
		Endif
		
		If lLocaliz
			SB1->B1_LOCALIZ := 'S'
		Endif
	Msunlock('SB1')

	SB2->(dbsetorder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	SB2->(dbseek(xFilial('SB2')+SB1->B1_COD))
					
	While SB2->(!EOF()) .AND. SB2->B2_FILIAL==xFilial('SB2') .AND. SB2->B2_COD== SB1->B1_COD
		    
		//------------------
	  	//-- SALDOS INICIAIS
	  	//------------------
	  	
		//-- posiciona SB9
		If !SB9->(dbSeek(xFilial('SB9')+SB1->B1_COD+SB2->B2_LOCAL+DtoS(dDTIni)))
			Alert('Erro! Produto: '+SB1->B1_COD+' sem saldo inicial (SB9) no armazém: '+SB2->B2_LOCAL)
			SB2->(dbSkip())
			Loop
		Endif
	  	
	  	If lLocaliz
	  	
		  	nSomaSBK := 0
		  	
		    If !SBK->(dbseek(xFilial('SBK')+SB1->B1_COD+SB2->B2_LOCAL+DTOS(dDtIni)))

				//-- INCLUI O SALDO POR ENDEREÇO NO ENDEREÇO 01
				RECLOCK('SBK',.T.)
				   	SBK->BK_FILIAL   := xFilial("SBK")
					SBK->BK_COD      := SB1->B1_COD
					SBK->BK_LOCAL    := SB2->B2_LOCAL
					SBK->BK_LOTECTL  := Iif(lLote,cLote,'')
					SBK->BK_DATA     := dDtIni
					SBK->BK_QINI     := SB9->B9_QINI
					SBK->BK_LOCALIZ  := cLocaliz
				MSUNLOCK('SBK')
		    
		    Else
		    
		    	//-- corrige saldos iniciais negativos
		    	cQuery := "UPDATE "+RetSqlName("SBK")
		    	cQuery += " SET BK_QINI=0 "
		    	cQuery += " WHERE BK_COD='"+SB1->B1_COD+"' AND BK_LOCAL='"+SB2->B2_LOCAL+"'"
		    	cQuery += " AND BK_FILIAL = '"+xFilial("SBK")+"' AND BK_QINI < 0 AND D_E_L_E_T_ = '' "
		    	cQuery += " AND BK_DATA = '"+DTOS(dDtIni)+"'"
		    	     
		    	TCSQLExec(cQuery)
		    	
		    	While SBK->(!EOF()) .AND. SBK->BK_FILIAL==xFilial('SBK') .AND. SBK->BK_COD==SB1->B1_COD .AND. SBK->BK_LOCAL==SB2->B2_LOCAL .AND. SBK->BK_DATA==dDtIni
		    		nSomaSBK += SBK->BK_QINI
		    		SBK->(dbSkip())
		    	EndDo
		    	
		    	//-- Verifica se a soma dos saldos do BK é diferente do saldo inicial (SB9)
		    	If nSomaSBK <> SB9->B9_QINI
		    	
		    		//-- Se for, altera a quantidade inicial do primeiro registro do SBK com a diferença
		    		SBK->(dbseek(xFilial('SBK')+SB1->B1_COD+SB2->B2_LOCAL+DTOS(dDtIni)))
					
					Reclock('SBK',.F.)
						SBK->BK_QINI += (SB9->B9_QINI-nSomaSBK)
					MsUnlock('SBK')
		    	
		    	EndIf
		    
		    EndIf
		    
		Endif
		
		If lLote	
		   	
			lSBJ := .F.
			nSomaSBJ := 0
			
		   	// BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)
		   	If SBJ->(dbSeek(xFilial('SBJ')+SB1->B1_COD+SB2->B2_LOCAL))

		    	//-- corrige saldos iniciais negativos
		    	cQuery := "UPDATE "+RetSqlName("SBJ")
		    	cQuery += " SET BJ_QINI=0 "
		    	cQuery += " WHERE BJ_COD='"+SB1->B1_COD+"' AND BJ_LOCAL='"+SB2->B2_LOCAL+"'"
		    	cQuery += " AND BJ_FILIAL = '"+xFilial("SBJ")+"' AND BJ_QINI < 0 AND D_E_L_E_T_ = '' "
		    	cQuery += " AND BJ_DATA = '"+DTOS(dDtIni)+"'"
		    	     
		    	TCSQLExec(cQuery)

		    	//-- corrige saldos iniciais negativos
		    	cQuery := "UPDATE "+RetSqlName("SBJ")
		    	cQuery += " SET BJ_LOTECTL='"+cLote+"' "
		    	cQuery += " WHERE BJ_COD='"+SB1->B1_COD+"' AND BJ_LOCAL='"+SB2->B2_LOCAL+"'"
		    	cQuery += " AND BJ_FILIAL = '"+xFilial("SBJ")+"' AND D_E_L_E_T_ = '' "
		    	cQuery += " AND BJ_DATA = '"+DTOS(dDtIni)+"'"
		    	cQuery += " AND BJ_LOTECTL = '' "
		    	     
		    	TCSQLExec(cQuery)


		   		While SBJ->(!EOF()) .AND. SBJ->BJ_FILIAL==xFilial('SBJ') .AND. SBJ->BJ_COD==SB1->B1_COD .AND. SBJ->BJ_LOCAL==SB2->B2_LOCAL

		   			If SBJ->BJ_DATA==dDtIni
		   				lSBJ := .T.
						nSomaSBJ += SBJ->BJ_QINI
		   			EndIf
		   			
		   			SBJ->(dbskip())
		   		EndDo
        	EndIf
        	    	
			If !lSBJ
				
				RecLock("SBJ",.T.)
					SBJ->BJ_FILIAL  := xFilial("SBJ")
					SBJ->BJ_COD     := SB1->B1_COD
					SBJ->BJ_LOCAL   := SB2->B2_LOCAL
					SBJ->BJ_DATA    := dDtIni
					SBJ->BJ_DTVALID := dDtIni
					SBJ->BJ_LOTECTL := cLote
					SBJ->BJ_NUMLOTE := Space(06)
					SBJ->BJ_QINI    := SB9->B9_QINI
				MsUnlock()

		   	Else
			   	
			   	SBJ->(dbSeek(xFilial('SBJ')+SB1->B1_COD+SB2->B2_LOCAL))

		   		While SBJ->(!EOF()) .AND. SBJ->BJ_FILIAL==xFilial('SBJ') .AND. SBJ->BJ_COD==SB1->B1_COD .AND. SBJ->BJ_LOCAL==SB2->B2_LOCAL

		   			If SBJ->BJ_DATA==dDtIni
						RecLock("SBJ",.F.)
							SBJ->BJ_QINI += (SB9->B9_QINI - nSomaSBJ)
						MsUnlock()
		   			EndIf
		   			
		   			SBJ->(dbskip())
		   		EndDo
	
		   	Endif
			
		Endif
		
		//--------------
		// MOVIMENTACOES
		//--------------

		//-- MOVIMENTO SD1		
		cQuery := " SELECT D1_QUANT, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_TIPO, D1_DTDIGIT, D1_LOTECTL, D1_NUMSEQ, D1_ITEM, D1_QTSEGUM, D1_TES "
		cQuery += " FROM "+RetSqlName("SD1")+" D1, "+RETSQLNAME("SF4")+" F4"
		cQuery += " WHERE D1_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND D1_LOCAL = '"+SB2->B2_LOCAL+"'"
		cQuery += " AND D1.D_E_L_E_T_ = ' ' AND D1_FILIAL = '"+xFilial("SD1")+"'"
		cQuery += " AND D1_DTDIGIT >= '"+DTOS(dDtIni)+"' AND D1_ORIGLAN <> 'LF' AND "
		cQuery += Iif(Empty(xFilial("SF4")),"D1_TES=F4_CODIGO","D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_ = ''"
		
		TCQUERY cQuery NEW ALIAS "QRYSD1"
		
		WHILE QRYSD1->(!EOF())
			
			If lLocaliz
			
				If !SDB->(dbseek(xFilial("SDB")+SB1->B1_COD+SB2->B2_LOCAL+QRYSD1->D1_NUMSEQ+QRYSD1->D1_DOC+QRYSD1->D1_SERIE+QRYSD1->D1_FORNECE+QRYSD1->D1_LOJA)) .and. ;
  				   !SDA->(dbseek(xFilial("SDA")+SB1->B1_COD+SB2->B2_LOCAL+QRYSD1->D1_NUMSEQ+QRYSD1->D1_DOC+QRYSD1->D1_SERIE+QRYSD1->D1_FORNECE+QRYSD1->D1_LOJA))

				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD1->D1_QUANT,0,2) // 2UM

				     CriaSDB(SB1->B1_COD,;
				     		 SB2->B2_LOCAL,;
				     		 QRYSD1->D1_QUANT,;
				     		 cLocaliz,;
				     		 nil,; //cNumSerie
				     		 QRYSD1->D1_DOC,;
				     		 QRYSD1->D1_SERIE,;
				     		 QRYSD1->D1_FORNECE,;
				     		 QRYSD1->D1_LOJA,;
				     		 QRYSD1->D1_TIPO,;
				     		 'SD1',;//cOrigem
				     		 STOD(QRYSD1->D1_DTDIGIT),;
				     		 Iif(lLote,cLote,''),;
				     		 SPACE(6),;//cNumLote
				     		 QRYSD1->D1_NUMSEQ,;//cNumSeq
				     		 QRYSD1->D1_TES,;
				     		 'D',;
				     		 QRYSD1->D1_ITEM,;
				     		 .F.,0,nQuant2UM,0)
				Endif
				
			Endif
			
			If lLote
			
				If !SD5->(dbSeek(xFilial('SD5')+QRYSD1->D1_NUMSEQ+SB1->B1_COD+SB2->B2_LOCAL))
				
				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD1->D1_QUANT,0,2) // 2UM

					 //GravaSD5("SD5",cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,cDoc,cSerie,cOp,cTm,cCliFor,cLoja,cLoteFor,nQuant,nQuant2UM,dData,dDtValid,nPotencia)

					 GravaSD5("SD5",SB1->B1_COD,;
					 			SB2->B2_LOCAL,;
				       		  cLote,;
				       		  Space(6),;
				       		  QRYSD1->D1_NUMSEQ,;//cNumSeq,   
				       		  QRYSD1->D1_DOC,;//cDoc,
				       		  QRYSD1->D1_SERIE,;//cSerie,
							  NIL,;//cOp,
				       		  QRYSD1->D1_TES,;//cTm,
				       		  QRYSD1->D1_FORNECE,;//cCliFor,
				       		  QRYSD1->D1_LOJA,;//cLoja,
				       		  NIL,;//cLoteFor,
				       		  QRYSD1->D1_QUANT,;//nQuant,	]
				       		  nQuant2UM,;
				       		  STOD(QRYSD1->D1_DTDIGIT),;
  				       		  STOD(QRYSD1->D1_DTDIGIT)+365,;
				       		  0)				    

				Endif  
				
			Endif
			
			QRYSD1->(dbskip())
			
		ENDDO
		
		QRYSD1->(dbclosearea())
		
		// Movimento do SD2
		cQuery := " SELECT D2_DOC, D2_SERIE, D2_CLIENTE,D2_LOJA,D2_EMISSAO,D2_TIPO, D2_TES,D2_CF,D2_QUANT,D2_NUMSEQ, D2_ITEM FROM "+RETSQLNAME("SD2")+", "+RETSQLNAME("SF4")
		cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_LOCAL='"+SB2->B2_LOCAL+"' AND "+RETSQLNAME("SD2")+".D_E_L_E_T_ <> '*' AND D2_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO >= '"+DTOS(dDtIni)+"'"
		cQuery += " AND "+IF(Empty(xFilial("SF4")),"D2_TES=F4_CODIGO","D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
		cQuery += " ORDER BY D2_EMISSAO,D2_NUMSEQ"

		TCQUERY cQuery NEW ALIAS "QRYSD2"
		
		WHILE QRYSD2->(!EOF())
		
			If lLocaliz
			
				If !SDB->(dbseek(xFilial("SDB")+SB1->B1_COD+SB2->B2_LOCAL+QRYSD2->D2_NUMSEQ+QRYSD2->D2_DOC+QRYSD2->D2_SERIE+QRYSD2->D2_CLIENTE+QRYSD2->D2_LOJA))
	
				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD2->D2_QUANT,0,2) // 2UM
				     CriaSDB(SB1->B1_COD,;
				     		 SB2->B2_LOCAL,;
				     		 QRYSD2->D2_QUANT,;
				     		 cLocaliz,;
				     		 nil,; //cNumSerie
				     		 QRYSD2->D2_DOC,;
				     		 QRYSD2->D2_SERIE,;
				     		 QRYSD2->D2_CLIENTE,;
				     		 QRYSD2->D2_LOJA,;
				     		 QRYSD2->D2_TIPO,;
				     		 'SD2',;//cOrigem
				     		 STOD(QRYSD2->D2_EMISSAO),;
				     		 Iif(lLote,cLote,''),;
				     		 SPACE(6),;//cNumLote
				     		 QRYSD2->D2_NUMSEQ,;//cNumSeq
				     		 QRYSD2->D2_TES,;
				     		 'M',;
				     		 QRYSD2->D2_ITEM,;
				     		 .F.,0,nQuant2UM,0)
				Endif
				
			Endif
			
			If lLote
			
				If !SD5->(dbSeek(xFilial('SD5')+QRYSD2->D2_NUMSEQ+SB1->B1_COD+SB2->B2_LOCAL))
				
				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD2->D2_QUANT,0,2) // 2UM

					 GravaSD5("SD5",SB1->B1_COD,;
					 		  SB2->B2_LOCAL,;
				       		  cLote,;
				       		  Space(6),;
				       		  QRYSD2->D2_NUMSEQ,;//cNumSeq,   
				       		  QRYSD2->D2_DOC,;//cDoc,
				       		  QRYSD2->D2_SERIE,;//cSerie,
							  NIL,;//cOp,
				       		  QRYSD2->D2_TES,;//cTm,
				       		  QRYSD2->D2_CLIENTE,;//cCliFor,
				       		  QRYSD2->D2_LOJA,;//cLoja,
				       		  NIL,;//cLoteFor,
				       		  QRYSD2->D2_QUANT,;//nQuant,	]
				       		  nQuant2UM,;
				       		  STOD(QRYSD2->D2_EMISSAO),;
  				       		  STOD(QRYSD2->D2_EMISSAO)+365,;
				       		  0)				    
				     
				Endif  
				
			Endif
			
			QRYSD2->(dbskip())
			
		ENDDO

		QRYSD2->(dbclosearea())

		// Movimento do SD3
		cQuery := " SELECT D3_ITEM,D3_OP, D3_EMISSAO,D3_TM,D3_CF,D3_DOC,D3_QUANT,D3_NUMSEQ,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SD3")
		cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='"+SB2->B2_LOCAL+"' AND "+RETSQLNAME("SD3")+".D_E_L_E_T_ <> '*' AND D3_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND D3_ESTORNO=' ' AND D3_EMISSAO >= '"+DTOS(dDtIni)+"'"
		cQuery += " ORDER BY D3_EMISSAO,D3_NUMSEQ"

		TCQUERY cQuery NEW ALIAS "QRYSD3"
		
		WHILE QRYSD3->(!EOF())
			
			If lLocaliz
			
				lCria := .f.
				
				If !SDB->(dbseek(xFilial("SDB")+SB1->B1_COD+SB2->B2_LOCAL+QRYSD3->D3_NUMSEQ+QRYSD3->D3_DOC))
					lCria := .T.
				Else
				
					If !ALLTRIM(SDB->DB_TM)$ALLTRIM(QRYSD3->D3_TM) .and. ( (SDB->DB_TM < '500' .AND. QRYSD3->D3_TM >'500') .OR. (SDB->DB_TM > '500' .AND. QRYSD3->D3_TM < '500'))
						SDB->(DBSKIP())
						
						IF SDB->(!EOF()) .AND. SDB->DB_FILIAL==xFilial('SDB') .AND. SDB->DB_NUMSEQ==QRYSD3->D3_NUMSEQ
							IF !ALLTRIM(SDB->DB_TM)$ALLTRIM(QRYSD3->D3_TM) .and. ( (SDB->DB_TM < '500' .AND. QRYSD3->D3_TM >'500') .OR. (SDB->DB_TM > '500' .AND. QRYSD3->D3_TM < '500'))
								lCria := .t.
							ENDIF
						Else
							lCria := .t.
						Endif
						
					Endif
					
				Endif
				
				If lCria
	
				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD3->D3_QUANT,0,2) // 2UM
				     CriaSDB(SB1->B1_COD,;
				     		 SB2->B2_LOCAL,;
				     		 QRYSD3->D3_QUANT,;
				     		 cLocaliz,;
				     		 nil,; //cNumSerie
				     		 QRYSD3->D3_DOC,;
				     		 '',;
				     		 '',;
				     		 '',;
				     		 '',;
				     		 'SD3',;//cOrigem
				     		 STOD(QRYSD3->D3_EMISSAO),;
				     		 cLote,;
				     		 SPACE(6),;//cNumLote
				     		 QRYSD3->D3_NUMSEQ,;//cNumSeq
				     		 QRYSD3->D3_TM,;
				     		 Iif(QRYSD3->D3_TM > '500','M','D'),;
				     		 QRYSD3->D3_ITEM,;
				     		 .F.,0,nQuant2UM,0)
				Endif

			Endif
			
			If lLote
				
				lCria := .f.

				If !SD5->(dbSeek(xFilial('SD5')+QRYSD3->D3_NUMSEQ+SB1->B1_COD+SB2->B2_LOCAL))
					lCria := .T.
				Else
				
					If !ALLTRIM(SD5->D5_ORIGLAN)$ALLTRIM(QRYSD3->D3_TM) .and. ( (SD5->D5_ORIGLAN < '500' .AND. QRYSD3->D3_TM >'500') .OR. (SD5->D5_ORIGLAN > '500' .AND. QRYSD3->D3_TM < '500'))
						SD5->(DBSKIP())
						
						IF SD5->D5_NUMSEQ==QRYSD3->D3_NUMSEQ
							IF !ALLTRIM(SD5->D5_ORIGLAN)$ALLTRIM(QRYSD3->D3_TM) .and. ( (SD5->D5_ORIGLAN < '500' .AND. QRYSD3->D3_TM >'500') .OR. (SD5->D5_ORIGLAN > '500' .AND. QRYSD3->D3_TM < '500'))
								lCria := .t.
							ENDIF
						Else
							lCria := .t.
						Endif
						
					Endif
					
				Endif
				
				If lCria
				
				     nQuant2UM := ConvUM(SB1->B1_COD,QRYSD3->D3_QUANT,0,2) // 2UM

					 GravaSD5("SD5",SB1->B1_COD,;
					 			SB2->B2_LOCAL,;
				       		  cLote,;
				       		  Space(6),;
				       		  QRYSD3->D3_NUMSEQ,;//cNumSeq,   
				       		  QRYSD3->D3_DOC,;//cDoc,
				       		  '',; // QRYSD1->D1_SERIE,;//cSerie,
							  NIL,;//cOp,
				       		  QRYSD3->D3_TM,;//cTm,
				       		  '',;//cCliFor,
				       		  '',;//cLoja,
				       		  NIL,;//cLoteFor,
				       		  QRYSD3->D3_QUANT,;//nQuant,	]
				       		  nQuant2UM,;
				       		  STOD(QRYSD3->D3_EMISSAO),;
  				       		  STOD(QRYSD3->D3_EMISSAO)+365,;
				       		  0)				    

				Endif
				
			Endif
			
			QRYSD3->(dbskip())
			
		ENDDO

		QRYSD3->(dbclosearea())
				
		SB2->(dbskip())

	Enddo
	
	If lLocaliz .AND. lLote

    	//-- corrige saldos iniciais sem lote
    	cQuery := "UPDATE "+RetSqlName("SBK")
    	cQuery += " SET BK_LOTECTL = '"+cLote+"' "
    	cQuery += " WHERE BK_COD='"+SB1->B1_COD+"' AND BK_LOCAL='"+SB2->B2_LOCAL+"'"
    	cQuery += " AND BK_FILIAL = '"+xFilial("SBK")+"' AND D_E_L_E_T_ = '' "
    	cQuery += " AND BK_DATA = '"+DTOS(dDtIni)+"'"
    	cQuery += " AND BK_LOTECTL = '' "
    	     
    	TCSQLExec(cQuery)

    	//-- corrige movimentacoes sem lote
    	cQuery := "UPDATE "+RetSqlName("SDB")
    	cQuery += " SET DB_LOTECTL = '"+cLote+"' "
    	cQuery += " WHERE DB_PRODUTO ='"+SB1->B1_COD+"' AND DB_LOCAL='"+SB2->B2_LOCAL+"'"
    	cQuery += " AND DB_FILIAL = '"+xFilial("SDB")+"' AND D_E_L_E_T_ = '' "
    	cQuery += " AND DB_DATA >= '"+DTOS(dDtIni)+"'"
    	cQuery += " AND DB_LOTECTL = '' "

    	TCSQLExec(cQuery)
	
	Endif
		
	END TRANSACTION

Return












/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³GetNextUsr    ³Autor ³Marinaldo de Jesus   ³ Data ³25/11/2008³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Obter usuario valido para inclusao no sigapss.spf            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>             						 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>             						 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³void                                                 	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observa‡„o³                                                      	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico 													 ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function GetNextUsr( cUser , cMaxUser , lNewUser )

Local aAllUsers 
Local bPswSeek

Static __cMaxUser

PswOrder(1)

IF ((Empty( __cMaxUser ) .and. Empty( cMaxUser )) .or. Empty( cUser ))	
	IF ( Select( "SX6" ) > 0 )
		aAllUsers	:= AllUsers()
		__cMaxUser	:= aAllUsers[ Len( aAllUsers ) , 1 , 1 ]
		IF ( lNewUser )
			cUser	:= __cMaxUser
		EndIF
		aAllUsers	:= NIL
	EndIF	
EndIF

DEFAULT cUser	 := ID_USER_ADMINISTRATOR
DEFAULT cMaxUser := __cMaxUser
DEFAULT lNewUser := .F.

cUser			 := Soma1( cUser )

bPswSeek  	     := Iif(lNewUser,{ || PswSeek( @cUser ) },{ || !PswSeek( @cUser ) })

While ( Eval( bPswSeek ) )
	cUser := Soma1( cUser )
	IF (( lNewUser ) .and. ( cUser > cMaxUser ))
		cUser := Space( 6 )
		Exit
	EndIF
EndDo

If (lNewUser)
	__cMaxUser		:= cUser
EndIf	

Return( cUser )


































User Function NHDELSXEF(cAlias)
Local aOldArea := GetArea()

	//-- LIMPA O SXE 
	Use SXE alias NHXE NEW
	NHXE->(dbgotop())
	Locate For NHXE->XE_ALIAS==cAlias
	If Found()
		While NHXE->(!EOF()) .AND. NHXE->XE_ALIAS==cAlias
			IF NHXE->(Rlock())
				NHXE->(dbdelete())
				NHXE->(dbcommit())
				NHXE->(dbunlock())
			Endif
		
			NHXE->(dbskip())
		EndDo
	Endif
	NHXE->(dbclosearea())

	//-- LIMPA O SXF
	Use SXF ALIAS NHXF NEW
	NHXF->(dbgotop())
	Locate For NHXF->XF_ALIAS==cAlias
	If Found()
		While NHXF->(!EOF()) .AND. NHXF->XF_ALIAS==cAlias
		 	If NHXF->(Rlock())
				NHXF->(dbdelete())
				NHXF->(dbcommit())
				NHXF->(dbunlock())
			Endif
 		
			NHXF->(dbskip())
		EndDo
	Endif
	NHXF->(dbclosearea())

	RestArea(aOldArea)
	
Return

User Function mysqlConnect() 

Local cDbConn := 'MYSQL/PORTAL'
Local cSrvConn := '192.168.1.55'
Local nHndConn
Local cTopConType := 'TCPIP'
	
	TCConType(cTopConType)            

	nHndConn := TcLink(cDbConn,cSrvConn)
	
	If (nHndConn  < 0 ) // teste de conexão 
	     Alert ("Erro de conexão!"+STR(nHndConn) )
		oMail          := Email():New()
		oMail:cMsg     := 'Falha na conexão Protheus => Mysql ('+STR(nHndConn)+')'
		oMail:cAssunto := '*** SIGACFG - FALHA CONEXÃO PROTHEUS X MYSQL ***'  
		oMail:cTo      := 'joaofr@whbbrasil.com.br'
		oMail:Envia()
	EndIf 
	  
Return

User Function mysqlClose(nHndConn)

	TCUNLINK(nHndConn)

Return

USER FUNCTION CONNMYSQL()

Private cLogin := space(25)

	oDlg  := MsDialog():New(0,0,100,300,"Recupera Senha",,,,,,,,,.T.)

	oSay1 := TSay():New(20,10,{||'Nome do usuário:'},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,60,{|u| if(Pcount() > 0, clogin := u,cLogin)},oDlg,50,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .t. },,,,,,,"cLogin")

	oBtn1 := tButton():New(32,10,"Fechar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	oBtn2 := tButton():New(32,60,"Senha Atual",oDlg,{||fSenha()},40,10,,,,.T.)
		
	oDlg:Activate(,,,.t.,{||.T.},,)


RETURN                                             

Static Function fSenha()
Local cPswFile := "sigapss.spf" //Tabela de Senhas
Local cPswId   := ""
Local cPswName := ""
Local cPswPwd  := ""
Local cPswDet  := ""
Local lEncrypt := .F.
Local aPswDet
Local cOldPsw
Local cNewPsw
Local nPswRec
Local cUsrId 

//Abro a Tabela de Senhas
spf_CanOpen(cPswFile) 

PswOrder(2) // Pesquisa por usuario
PswSeek(alltrim(upper(cLogin)),.T.)     
aUser := PswRet(1)
cUsrId := aUser[1][1] // ID do usuario.

//Procuro pelo usuario Base
nPswRec := spf_Seek( cPswFile , "2U"+cUsrId , 1 ) 

//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )

Alert(SUBSTR(PSWENCRIPT(CPSWPWD,1),9,20))

Return

Static function testMysqlConn()
Local cDbPortal := 'MYSQL/PORTAL'
Local cSrvPortal := '192.168.1.55'
Local nHndPortal
Local cTopConType := 'TCPIP'

TCConType(cTopConType)            

nHndPortal := TcLink(cDbPortal,cSrvPortal)

If (nHndPortal  < 0 ) // teste de conexão 
     Alert ("Erro de conexão!"+STR(nHndPortal) )
EndIf 
  
cQuery := " SELECT COUNT(*) quant FROM chamado WHERE str_status IN ('A','P')"

TCQUERY cQuery New Alias 'QRY'


Alert('Conexão com MYSQL OK! '+CHR(13)+CHR(10)+'Informática possui '+ ALLTRIM(Str( QRY->quant)) +' chamados pendentes!')

QRY->(dbclosearea())

TCUNLINK(nHndPortal)

Return