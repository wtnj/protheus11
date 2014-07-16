#include "rwmake.ch"                                                                                 
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch"      

user Function NHCFG017( __aCookies, __aPostParms, __nProcID, __aProcParms, __cHTTPPage )
	Return fAltUsr(__aProcParms)
Return

Static Function fAltUsr(aGet)

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
Local cErro := ''
Local cWarn := ''

Private N_ACC := 200 //-- maximo de acessos existentes

cNewPwd := PADR("WHB"+ALLTRIM(STR(YEAR(date()))),25)

cCodEmp := 'FN'
cCodFil := '01'
cModulo := 'EST'
aParamVar := {}
cRet    := 'false'

	prepare environment empresa cCodEmp filial cCodFil modulo cModulo
    
    //-- op = parametro que diz qual operacao sera feita

    //   op == all  => lista todos os usuarios
    //   op == alf  => lista todos os usuarios de forma rapida
    //   op == bli  => inativa todos os usuarios que nao acessaram o sistema a mais de 90 dias ou nunca entraram e foi cadastrtado a mais de 90 dias
    //   op == inc  => inclui novo usuario
	//   op == upd  => atualiza usuario existente    
	//   op == exc  => exclui o usuario
	//   op == exb  => exclui usuarios bloqueados

 	//-- usr = nome do usuario
 	//-- cod = codigo do usuario
    //-- blq = bloqueia ou desbloqueia usuario
    //-- pwd = troca a senha do usuario
    //-- pwt = troca a senha do usuario e define para trocar no primeiro acesso
    //-- ema = troca o email do usuario
    //-- nom = nome
    //-- set = setor
    //-- car = cargo
    //-- tel = ramal
    //-- prn = diretorio de impressao
    //-- emp = empresas separado por / (ex: "FN01/NH01")
    //-- acs = acessos simultaneos
    //-- acc = acessos (string 188 posicoes de S ou N)
    
    //-- n_max = limite maximo de usuarios a serem listados
    //-- n_min = a partir deste limite de usuarios a serem listados  
    
	_n := aScan(aGet,{|x| x[1]$'op'})
	If _n==0
		Return 'ERRO: Nenhuma operação especificada (falta parâmetro: op)'
	Else
		cOp := aGet[_n][2]
	Endif
	
	cXml := '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	if cOp$'oac'

		cXml += '<usr><access>'
		//-- lista os acessos
		aList := GetAccessList()
			
		for xA:=1 to len(aList)
			cXml += '<acc'+alltrim(str(aList[xA][1]))+'>'+EncodeUtf8(oemtoansi(aList[xA][2]))+'</acc'+alltrim(str(aList[xA][1]))+'>'
		next
			
		cXml += '</access></usr>'
	
		return cXml
	
	elseif cOp$'all/alf/bli/exb'

		cXml += '<usuarios>'
	
		//-- lista todos os usuarios de forma rapida c/ funcao FWSFALLUSERS()
		If cOP=='alf'
		
			aAllUsers := FWSFALLUSERS()

			For xU := 1 to len(aAllUsers)
			
				if aAllUsers[xU][2]<>'000000' //-- SE NAO FOR ADMINISTRADOR
					    				
    				//IF(ALLTRIM(aAllUsers[xU][3])$'ADRIANOSM')
    				//   ALERT('')
    				//ENDIF	

					
					dtultac := FWUsrUltLog(aAllUsers[xU][2])[1] //-- data do ultimo acesso

					aAllUsers[xU][4] := Iif( Valtype( Decodeutf8(aAllUsers[xU][4]) )=='U' , ClearStr(aAllUsers[xU][4]) , aAllUsers[xU][4])
					aAllUsers[xU][6] := Iif( Valtype( Decodeutf8(aAllUsers[xU][6]) )=='U' , ClearStr(aAllUsers[xU][6]) , aAllUsers[xU][6])
					aAllUsers[xU][7] := Iif( Valtype( Decodeutf8(aAllUsers[xU][7]) )=='U' , ClearStr(aAllUsers[xU][7]) , aAllUsers[xU][7])

					cXml += '<usr>'
					cXml += '<id>'+aAllUsers[xU][2]+'</id>'
					cXml += '<log>' +alltrim(aAllUsers[xU][3])+'</log>'
					cXml += '<nom>'  +alltrim(aAllUsers[xU][4])+'</nom>'
					cXml += '<set>' +alltrim(aAllUsers[xU][6])+'</set>'
					cXml += '<car>' +alltrim(aAllUsers[xU][7])+'</car>'
					cXml += '<ema>' +alltrim(aAllUsers[xU][5])+'</ema>'
					cXml += '<uac>'+dtoc(dtultac)+'</uac>'
					cXml += '</usr>'
				Endif
			Next								
		
		//-- bloqueia inativos a mais de 90 dias
		Elseif cop$'bli/exb'
		
			cMsgMail := '<table>'
            CaSSUNTO := ''
            
            aAllUsers := AllUsers()
	
			PswOrder(2) // Pesquisa poR LOGIN
			
			//-- percorre todos os usuarios 
			For xU := 1 to len(aAllUsers)
	                                              
				if aAllUsers[xU][1][1]<>'000000' //-- SE NAO FOR ADMINISTRADOR
					
					//-- bloqueia usuarios que nao acessaram a 90 dias ou mais
					//-- ou criados a mais de 90 dias e nunca acessaram

					dtultac := FWUsrUltLog(aAllUsers[xU][1][1])[1] //-- data do ultimo acesso

					If(empty(dtultac))
						dtultac := aAllUsers[xU][1][24] //-- data inclusao no sistema
						lNuncAc := .T.
					Else
						lNuncAc := .F.								
					Endif

					//-- se nao tiver bloqueado
					If !aAllUsers[xU][1][17]
					
						If !empty(dtultac) .and. dtultac < (date()-90) .and. cop$'bli'
						
							If PswSeek(alltrim(upper(aAllUsers[xU][1][2])),.T.)     
							
 								//Abro a Tabela de Senhas
								spf_CanOpen(cPswFile)                
								
								//Procuro pelo usuario Base
								nPswRec := spf_Seek( cPswFile , "3U"+aAllUsers[xU][1][1] , 1 ) 
										
								//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
								spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )
								
								//-- retira caracteres especiais
								cPswDet := strTran(cPswDet,CHR(129),"")
								cPswDet := strTran(cPswDet,CHR(157),"")
								cPswDet := strTran(cPswDet,CHR(141),"")								
								
								//-- codifica para nao dar erro
								cPswDet := ENCODEUTF8(cPswDet)
				                 
								//-- bloqueia o camarada
								cBlq := '<USR_MSBLQL order="6"><value>1</value></USR_MSBLQL>'
								
								cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<USR_MSBLQL',cpswdet), AT('</USR_MSBLQL>',cpswdet) - AT('<USR_MSBLQL',cpswdet)+13) , cBlq)
											
								// Efetua a atualização do arquivo 
								SPF_UPDATE(cPswFile,nPswRec, @cPswId , @cPswName , @cPswPwd , cPswDet )
											
 								cXml += '<usr>'
								cXml += '<log>'+aAllUsers[xU][1][2]+'</log>'
								cXml += '<nom>'+OEMTOANSI(aAllUsers[xU][1][4])+'</nom>'
								cXml += '<set>'+aAllUsers[xU][1][12]+'</set>'
								cXml += '<car>'+aAllUsers[xU][1][13]+'</car>'
								cXml += '<uac>'+dtoc(dtultac)+'</uac>'
								cXml += '<nac>'+Iif(lNuncAc,'S','-')+'</nac>'
								cXml += '</usr>'+chr(13)+chr(10)
								
								cMsgMail += '<tr>'
								cMsgMail += '<td>'+aAllUsers[xU][1][2]+'</td>'
								cMsgMail += '<td>'+OEMTOANSI(aAllUsers[xU][1][4])+'</td>'
								cMsgMail += '<td>'+aAllUsers[xU][1][12]+'</td>'
								cMsgMail += '<td>'+aAllUsers[xU][1][13]+'</td>'
								cMsgMail += '<td>'+dtoc(dtultac)+'</td>'
								cMsgMail += '<td>'+Iif(lNuncAc,'S','-')+'</td>'
								cMsgMail += '</tr>'
							Endif
						Endif

						cAssunto := '*** USUARIOS BLOQUEADOS AP11 ***'
													
					else
					
						if cop=='exb' .and. dtultac < ctod('01/01/2014')
						
							cAssunto := '*** USUARIOS EXCLUIDOS AP11 ***'
	
							If PswSeek(alltrim(upper(aAllUsers[xU][1][2])),.T.)     
							
								//Abro a Tabela de Senhas
								spf_CanOpen(cPswFile)                
								
								//Procuro pelo usuario Base
								nPswRec := spf_Seek( cPswFile , "3U"+aAllUsers[xU][1][1] , 1 ) 
										
								//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
								spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )
								
								//-- retira caracteres especiais
								cPswDet := strTran(cPswDet,CHR(129),"")
								cPswDet := strTran(cPswDet,CHR(157),"")
								cPswDet := strTran(cPswDet,CHR(141),"")								
								
								//-- codifica para nao dar erro
								cPswDet := ENCODEUTF8(cPswDet)
											
								// Efetua a atualização do arquivo 
								SPF_Delete(cPswFile,nPswRec)
								
								cMsgMail += '<tr>'
								cMsgMail += '<td>'+aAllUsers[xU][1][2]+'</td>'
								cMsgMail += '<td>'+OEMTOANSI(aAllUsers[xU][1][4])+'</td>'
								cMsgMail += '<td>'+aAllUsers[xU][1][12]+'</td>'
								cMsgMail += '<td>'+aAllUsers[xU][1][13]+'</td>'
								cMsgMail += '<td>'+dtoc(dtultac)+'</td>'
								cMsgMail += '<td>'+Iif(lNuncAc,'S','-')+'</td>'
								cMsgMail += '</tr>'
							Endif
						Endif					
					Endif					
				Endif
			Next
			
			cMsgMail += '</Table>'
			
			oMail := Email():New()
			oMail:cMsg := cMsgMail
			oMail:cAssunto := cAssunto
			oMail:cTo := 'joaofr@whbbrasil.com.br'
		
			oMail:Envia()

		Elseif cop=='all'
		
			aAllUsers := AllUsers()
			
			N_MIN := 1
			N_MAX := len(aAllUsers)
			
			_n := aScan(aGet,{|x| x[1]$'n_min'})
			If _n<>0
				N_MIN := val(aGet[_n][2])
			Endif
			
			_n := aScan(aGet,{|x| x[1]$'n_max'})
			If _n<>0
				N_MAX := val(aGet[_n][2])
			Endif

			If N_MAX >= len(aAllUsers)
				N_MAX := len(aAllUsers)
			Endif
	
			//-- percorre todos os usuarios 
			For xU := N_MIN to N_MAX
	                                              
				if aAllUsers[xU][1][1]<>'000000' //-- SE NAO FOR ADMINISTRADOR
                     
                    //-- empresas
					cEmps := ''
					
					For xE:=1 to len(aAllUsers[xU][2][6])
						cEmps += aAllUsers[xU][2][6][xE]+Iif(len(aAllUsers[xU][2][6])>xE,'/','')
					Next
		            
		            //-- trata acentuação
					aAllUsers[xU][1][4]  := Iif( Valtype( Decodeutf8(aAllUsers[xU][1][4] ))=='U' , ClearStr(aAllUsers[xU][1][4] ) , aAllUsers[xU][1][4] ) //-- nome
					aAllUsers[xU][1][12] := Iif( Valtype( Decodeutf8(aAllUsers[xU][1][12]))=='U' , ClearStr(aAllUsers[xU][1][12]) , aAllUsers[xU][1][12]) //-- setor
					aAllUsers[xU][1][13] := Iif( Valtype( Decodeutf8(aAllUsers[xU][1][13]))=='U' , ClearStr(aAllUsers[xU][1][13]) , aAllUsers[xU][1][13]) //-- cargo
					
					//-- TRATA OS ACESSOS PARA DIMINUIR A STRING E NAO DAR STRING OVERFLOW
					cAcc := ''
					nCnt := 0
					cAux := Substr(alltrim(aAllUsers[xU][2][5]),1,1)
					
					For xA:=1 to N_ACC
						iF cAux==Substr(alltrim(aAllUsers[xU][2][5]),xA,1)
							nCnt++
						Else
							cAcc += alltrim(str(nCnt))+cAux 
							cAux := Substr(alltrim(aAllUsers[xU][2][5]),xA,1)
							nCnt := 1
						Endif
					Next

					cAcc += alltrim(str(nCnt))+cAux 

					cXml += '<usr>'
					cXml += '<id>'+alltrim(aAllUsers[xU][1][1])+'</id>'
					cXml += '<log>'+alltrim(aAllUsers[xU][1][2])+'</log>'
					cXml += '<nom>'+alltrim(OEMTOANSI(aAllUsers[xU][1][4]))+'</nom>'
					cXml += '<set>'+alltrim(aAllUsers[xU][1][12])+'</set>'
					cXml += '<car>'+alltrim(aAllUsers[xU][1][13])+'</car>'
					cXml += '<ema>'+alltrim(aAllUsers[xU][1][14])+'</ema>'
					cXml += '<acs>'+alltrim(str(aAllUsers[xU][1][15]))+'</acs>'
					cXml += '<tel>'+alltrim(aAllUsers[xU][1][20])+'</tel>'
					cXml += '<blq>'+Iif(aAllUsers[xU][1][17],'S','N')+'</blq>'
					cXml += '<prn>'+alltrim(aAllUsers[xU][2][3])+'</prn>'
					cXml += '<emp>'+cEmps+'</emp>'
					cXml += '<acc>'+cAcc+'</acc>'
					cXml += '</usr>'
                     
				Endif
			Next
		Endif						
		
 		cXml += '</usuarios>'
			
		return cXML

	ElseIf cop$'inc/upd/exc'

		//-- ARRAY USADO PARA TESTES

		/*
		AGET := {{'inclui','1'}, ;
		{'log','A3x'},;
		{'usr','JOAOFR'},  ;
		{'nom','TESTE+INCLUSAO+PORTAL'}, ;
		{'set','INFORMATICA'}, ;
		{'car','ANALISTA+DE+SISTEMAS+MASTER'}, ;
		{'tel','1948'},     ;
		{'ema','joaofr%40whbbrasil.com.br'}, ;
		{'acs','10'},  ;
		{'prn','%5CRELATO%5CINFORMATICA%5C'}, ;
		{'blq','2'}}
	    */
	        
		//-- PROCURA O USUARIO
		_n := aScan(aGet,{|x| x[1]$'usr/cod' })
		If _n==0
			Return 'ERRO: nome de usuario ou codigo de usuario nao especificado para inclusao ou alteracao'
		Endif
		
		if aGet[_n][1]=='usr'
			PswOrder(2) // Pesquisa poR LOGIN
			If !PswSeek(alltrim(upper(aGet[_n,2])),.T.)     
			//IF !SPF_SEEK(CPSWFILE, '3U'+alltrim(upper(aGet[_n,2])),1)  
				Return 'ERRO: usuario '+aGet[_n,2]+' nao encontrado!'
			Endif
		else
			PswOrder(1) // Pesquisa por ID
			If !PswSeek(alltrim(upper(aGet[_n,2])),.T.)     
				Return 'ERRO: usuario ID:'+aGet[_n,2]+' nao encontrado!'
			Endif
		endif
		
		aUser := {PswRet(1)[1],PswRet(2)[1],PswRet(3)}
		
		cUsrId := aUser[1][1] // ID do usuario.

		//Abro a Tabela de Senhas
		spf_CanOpen(cPswFile)                
		
		//Procuro pelo usuario Base
		nPswRec := spf_Seek( cPswFile , "3U"+cUsrId , 1 ) 
				
		//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
		spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )
		
		//-- retira caracteres especiais
		cPswDet := strTran(cPswDet,CHR(129),"")
		cPswDet := strTran(cPswDet,CHR(157),"")
		cPswDet := strTran(cPswDet,CHR(141),"")		
		
		//-- codifica para nao dar erro
		cPswDet := ENCODEUTF8(cPswDet)
		
		if empty(cPswDet)
			Return 'Erro: encodeutf8 retornou nil!'
		endif
		
		If cOp=='exc'
		
			SPF_Delete(cPswFile,nPswRec)
		
		
		/* I N C L U S A O */
		
		ElseIf cOp=='inc'
		
			aVars := {'log',; // 1 login do novo usuario
				      'nom',; // 2 nome
				      'set',; // 3 setor
				      'car',; // 4 cargo
				      'tel',; // 5 ramal
				      'ema',; // 6 email 
				      'prn',; // 7 diretorio de impressao
				      'acs',; // 8 acessos simultaneos
				      'emp';  // 9 empresas separadas por / (ex: FN01/FN02/NH01/IT01)
				      }  
		
			aDados := {}
			
			For xD:=1 to len(aVars)
				_n := aScan(aGet,{|x| x[1]==aVars[xD] })
				If _n==0
					Return 'ERRO: Parâmetro necessário: ('+aVars[xD]+')'
				ElseIf empty(aGet[_n][2])
					Return 'ERRO: Parâmetro ('+aVars[xD]+') não especificado (em branco)!'
				Else
					aAdd(aDados,aGet[_n][2])
				Endif
			Next

			//-- VALIDA O LOGIN
			PswOrder(2) // Pesquisa por LOGIN
			If PswSeek(alltrim(upper(aDados[1])),.T.)     
				Return 'ERRO: Já existe usuário cadastrado com este login: '+aDados[1]+'!'
			Endif
			
			//-- REMOVE OS GRUPOS DO USUARIO BASE E CRIA GRUPO PADRAO
			
			cGroups := '<DATAGROUP modeltype="GRID" optional="1">'+;
                       '  <struct>'+;
                       '    <USR_GRUPO order="1"></USR_GRUPO>'+;
                       '    <USR_NOME order="2"></USR_NOME>'+;
                       '    <USR_PRIORIZA order="3"></USR_PRIORIZA>'+;
                       '  </struct>'+;
                       '  <items>'+;
                       '    <item id="1" deleted="0"  USR_GRUPO="000001" USR_NOME="Usuarios" USR_PRIORIZA="2" ></item>'+;
                       '  </items>'+;
                       '</DATAGROUP>'
			
			cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<DATAGROUP',cpswdet), AT('</DATAGROUP>',cpswdet) - AT('<DATAGROUP',cpswdet)+12) , cGroups)
            
			//MODULOS inc
			_n := aScan(aGet,{|x| x[1]=='mod' })
			If _n<>0

                aMod := strtokarr(aGet[_n,2],'/')

				cMod := '<PROTHEUSMENU modeltype="GRID" optional="1">'+;
				        '  <struct>'+;
				        '    <USR_ACESSO order="1"></USR_ACESSO>'+;
				        '    <USR_MODULO order="2"></USR_MODULO>'+;
				        '    <USR_ARQMENU order="5"></USR_ARQMENU>'+;
				        '    <USR_NIVEL order="6"></USR_NIVEL>'+;
				        '  </struct>'+;
				        '  <items>'

				aModulos := RetModName()  
				aAdd(aModulos,{99,'SIGACFG','Configurador',.F.,'',99})
				
				for xM:=1 to len(aModulos)
					cMod += '<item id="'+alltrim(str(aModulos[xM][1]))+'" deleted="0" >'
					cMod += iif (aScan(aMod,{|x| val(x)==aModulos[xM][1] })>0,'<USR_ACESSO>T</USR_ACESSO>','')
					cMod += '<USR_MODULO>'+alltrim(str(aModulos[xM][1]))+'</USR_MODULO>'
					   
					cMod += '<USR_ARQMENU>\SYSTEM\'+alltrim(aModulos[xM,2])+'.xnu</USR_ARQMENU>'
					cMod += '<USR_NIVEL>5</USR_NIVEL>'

			        cMod += '</item>'
				next

				cMod += '  </items>'+;
					    '</PROTHEUSMENU>'

				cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSMENU',cpswdet), AT('</PROTHEUSMENU>',cpswdet) - AT('<PROTHEUSMENU',cpswdet)+15) , cMod)
			
			Endif

			//-- REMOVE AS EMPRESAS DO USUARIO BASE E CRIA EMPRESAS SOLICITADAS
			
			cEmps := '<PROTHEUSFILIAL modeltype="GRID" optional="1">'+;
				     '  <struct>'+;
				     '    <USR_ACESSO order="1"></USR_ACESSO>'+;
				     '    <USR_GRPEMP order="2"></USR_GRPEMP>'+;
				     '    <USR_CODEMP order="3"></USR_CODEMP>'+;
				     '    <USR_CODUNG order="4"></USR_CODUNG>'+;
				     '    <USR_FILIAL order="5"></USR_FILIAL>'+;
				     '  </struct>'+;
				     '  <items>'

			aEmps := STRTOKARR(aDados[9],'/')
			
			For xE:=1 to len(aEmps)
				cEmps += '    <item id="'+alltrim(str(xE))+'" deleted="0">'+;
					     '      <USR_ACESSO>T</USR_ACESSO>'+;
					     '      <USR_GRPEMP>'+substr(aEmps[xE],1,2)+'</USR_GRPEMP>'+;
					     '      <USR_FILIAL>'+substr(aEmps[xE],3,2)+'</USR_FILIAL>'+;
					     '    </item>'
	        next

			cEmps +=  '  </items>'+;
				      '</PROTHEUSFILIAL>'
							
			cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSFILIAL',cpswdet), AT('</PROTHEUSFILIAL>',cpswdet) - AT('<PROTHEUSFILIAL',cpswdet)+17) , cEmps)
              
			//-- A C E S S O S
			_n := aScan(aGet,{|x| x[1]=='acc' })
			If _n<>0

				cAcc := '<PROTHEUSACCESS modeltype="GRID" optional="1">'+;
					    '  <struct>'+;
					    '    <USR_ACESSO order="1"></USR_ACESSO>'+;
					    '    <USR_CODACESSO order="2"></USR_CODACESSO>'+;
					    '  </struct>'+;
					    '  <items>'

				//-- limpa os acessos
				aUser[2][5] := ''
				
				For xA:=1 to len(aGet[_n][2])
				
					If xA > 190
						exit
					Endif
				
					cAcc += '<item id="'+alltrim(Str(xA))+'" deleted="0" '
					
					If Substr(aGet[_n][2],xA,1)=='S'
						cAcc += 'USR_ACESSO="T" '
						aUser[2][5] += 'S'
					Else
						aUser[2][5] += 'N'
					Endif
					
					cAcc += 'USR_CODACESSO="'+alltrim(Str(xA))+'"></item>'
				Next
				
				cAcc += '  </items>'+;
						'</PROTHEUSACCESS>'
						
				cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSACCESS',cpswdet), AT('</PROTHEUSACCESS>',cpswdet) - AT('<PROTHEUSACCESS',cpswdet)+17) , cAcc)					
				
			Endif

			// converte em objeto xml
			oXml:=XmlParser(cPswDet,"_",@cErro,@cWarn) 
			    
			if !empty(cErro)
				Return 'Erro ao gerar xml: '+cErro
			elseif !empty(cWarn)
				Return 'Warn ao gerar xml: '+cWarn
			Endif
			
			//-- login  
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CODIGO:_VALUE:TEXT:= aDados[1]
			aUser[1][2] := aDados[1]
			cPswName := aDados[1]
			
			//-- bloqueado = 'N'
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_MSBLQL:_VALUE:TEXT:= '2'
			aUser[1][17] := .F.
			
			//-- DATA INCLUSAO
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTINC:_VALUE:TEXT := dtos(date())
			
			//-- DATA ULTIMA ALTERACAO
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_DTALASTALT'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTALASTALT:_VALUE:TEXT := ''
            endif
             
			//-- HORA ULTIMA ALTERACAO
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_HRLASTALT'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_HRLASTALT:_VALUE:TEXT := ''
			endif
			
			//-- HOST NAME ULTIMO LOGON
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_CNLOGON'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_CNLOGON:_VALUE:TEXT := ''
			endif
			
			//-- DATA ULTIMO LOGON
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_DTLOGON'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTLOGON:_VALUE:TEXT := ''
			endif
			
			//-- HORA ULTIMO LOGON
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_HRLOGON'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_HRLOGON:_VALUE:TEXT := ''
			endif
			
			//-- IP ULTIMO LOGON
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_IPLOGON'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_IPLOGON:_VALUE:TEXT := ''
			endif
			
			//-- USUARIO SO ULTIMO LOGON
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_USERSOLOGON'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_USERSOLOGON:_VALUE:TEXT := ''
			endif
			
    		//-- data ultima alteracao de senha
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_DTCHGPSW'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTCHGPSW:_VALUE:TEXT := ''
			endif
			               
			//-- APAGA ULTIMAS SENHAS
			if ValType(XMLChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_ULTSPSW'))=='O'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_ULTSPSW:_VALUE:TEXT := ''
			endif
			
			//-- ********************
			
			//-- VERIFICA SE EXISTE O NODO
			If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_DTAVICHGPSW')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE,'_USR_DTAVICHGPSW','USR_DTAVICHGPSW','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW:REALNAME := '_DTAVICHGPSW'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW:_ORDER:TEXT := '2'

			Endif

			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_DATASTORAGE:_USR_DTAVICHGPSW:_VALUE:TEXT := DTOS(DATE())
	
			//-- ACESSOS SIMULTANEOS
			If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION,'_USR_QTDACESSOS')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION,'_USR_QTDACESSOS','USR_QTDACESSOS','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:REALNAME := 'USR_QTDACESSOS'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_ORDER:TEXT := '1'
				
			Endif
	
			//-- acessos simultaneos
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_VALUE:TEXT := aDados[8]
			aUser[1][15] := aDados[8]
		       
			//-- nome
			aDados[2] := strtran(urldecode(aDados[2]),"+",space(1))
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_NOME:_VALUE:TEXT:= aDados[2]
			aUser[1][4] := aDados[2]
			
			//-- setor
			// decodifica o parametro da url
			aDados[3] := strtran(urldecode(aDados[3]),"+",space(1))
		
			// VERIFICA SE EXISTE O NODO DO SETOR
			If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_DEPTO')==nil   
			
				// SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_DEPTO','USR_DEPTO','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:REALNAME := 'USR_DEPTO'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_ORDER:TEXT := '10'
				
			Endif
	
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_VALUE:TEXT := aDados[3]
			aUser[1][12] := aDados[3]
		
			//-- cargo
			//-- decodifica o parametro da url
			aDados[4] := strtran(urldecode(aDados[4]),"+",space(1))
		
			//-- VERIFICA SE EXISTE O NODO DO CARGO
			If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CARGO')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CARGO','USR_CARGO','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:REALNAME := 'USR_CARGO'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_ORDER:TEXT := '11'
				
			Endif
	
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_VALUE:TEXT := aDados[4]
			aUser[1][13] := aDados[4]
			
			//-- ramal
			
			//-- decodifica o parametro da url
			aDados[5] := strtran(urldecode(aDados[5]),"+",space(1))
		
			//-- VERIFICA SE EXISTE O NODO DO RAMAL
			If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA,'_USR_RAMAL')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA,'_USR_RAMAL','USR_RAMAL','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:REALNAME := 'USR_RAMAL'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_ORDER:TEXT := '5'
				
			Endif
	
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_VALUE:TEXT := aDados[5]
			aUser[1][20] := aDados[5]
			
			//-- EMAIL
			aDados[6] := strtran(urldecode(aDados[6]),"+",space(1))
			//-- VERIFICA SE EXISTE O NODO DO EMAIL
			If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_EMAIL')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_EMAIL','USR_EMAIL','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:REALNAME := 'USR_EMAIL'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_ORDER:TEXT := '9'
				
			Endif
	
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_VALUE:TEXT := aDados[6]
			aUser[1][14] := aDados[6]
			
			//-- diretorio de impressao

			//-- decodifica o parametro da url
			aDados[7] := strtran(urldecode(aDados[7]),"+",space(1))
		
			//-- VERIFICA SE EXISTE O NODO DO DIR IMP
			If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER,'_USR_DIRIMP')==nil   
			
				//-- SE NAO EXISTIRM CRIA O NOVO NODO
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER,'_USR_DIRIMP','USR_DIRIMP','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:REALNAME := 'USR_DIRIMP'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_ORDER:TEXT := '1'
				
			Endif
	
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_VALUE:TEXT := aDados[7]
			aUser[2][3] := aDados[7]
			

			//-- verifica se foi passado parametro pwd/pwt no Get
			_n := aScan(aGet,{|x| x[1]$'pwd/pwt' })
			If _n<>0
				cNewPwd := PadR(aGet[_n,2],25)
			Endif

			//-- NOVA SENHA
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_PSW:_VALUE:TEXT := cNewPwd
			oXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_PSWMD5:_VALUE:TEXT := MD5(cNewPwd,0)
			cPswPwd := MD5(cNewPwd,1)
			
			//-- define para trocar senha no prox logon				
			XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CHGPSW','USR_CHGPSW','NOD')
			XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW,'_ORDER','order','ATT')
			XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW,'_VALUE','value','NOD')
			
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:REALNAME := 'USR_CHGPSW'
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_VALUE:REALNAME := 'value'
			OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_ORDER:REALNAME := 'order'
				
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_ORDER:TEXT := '16'
			oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_VALUE:TEXT := 'T'

			//CONVERTE XML OBJETO PARA XML STRING
			cPswDet:= XMLSaveStr(oXml) 
			
			//-- tratamento xml
			If SUBSTR(cPswDet,1,5)<>'<?xml'
				cPswDet := '<?xml version="1.0" encoding="UTF-8"?>' + cPswDet
			Endif

			// Pega proximo codigo
			cNewCod := GetNextUsr( NIL , "999999" , .T. ) //Atribuindo o Novo user ID
			aUser[1][1] := cNewCod

			//Incluindo o novo usuario     
			nNewRec := spf_Insert( cPswFile , '3U'+cNewCod, upper(aDados[1]) , cPswPwd, cPswDet ) 

			return 'Usuário incluído com sucesso!'
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A L T E R A Ç Ã O ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		Elseif cOp=='upd'
		
			//MODULOS
			_n := aScan(aGet,{|x| x[1]=='mod' })
			If _n<>0

                aMod := strtokarr(aGet[_n,2],'/')

				cMod := '<PROTHEUSMENU modeltype="GRID" optional="1">'+;
				        '  <struct>'+;
				        '    <USR_ACESSO order="1"></USR_ACESSO>'+;
				        '    <USR_MODULO order="2"></USR_MODULO>'+;
				        '    <USR_ARQMENU order="5"></USR_ARQMENU>'+;
				        '    <USR_NIVEL order="6"></USR_NIVEL>'+;
				        '  </struct>'+;
				        '  <items>'

				aModulos := RetModName()  
				aAdd(aModulos,{99,'SIGACFG','Configurador',.F.,'',99})
				
				for xM:=1 to len(aModulos)
					cMod += '<item id="'+alltrim(str(aModulos[xM][1]))+'" deleted="0" >'
					cMod += iif (aScan(aMod,{|x| val(x)==aModulos[xM][1] })>0,'<USR_ACESSO>T</USR_ACESSO>','')
					cMod += '<USR_MODULO>'+alltrim(str(aModulos[xM][1]))+'</USR_MODULO>'
					   
					_nM := aScan(aUser[3][1],{|x| val(substr(x,1,2))==aModulos[xM][1]})
					If _nM<>0
						cMod += '<USR_ARQMENU>'+alltrim(substr(auser[3][1][_nM],4))+'</USR_ARQMENU>'
	            		cMod += '<USR_NIVEL>'+Iif(substr(auser[3][1][_nM],3,1)=='X','5',substr(auser[3][1][_nM],3,1))+'</USR_NIVEL>'
					Else
						cMod += '<USR_ARQMENU>\SYSTEM\'+alltrim(aModulos[xM,2])+'.xnu</USR_ARQMENU>'
						cMod += '<USR_NIVEL>5</USR_NIVEL>'
					Endif

			        cMod += '</item>'
				next

				cMod += '  </items>'+;
					    '</PROTHEUSMENU>'

				cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSMENU',cpswdet), AT('</PROTHEUSMENU>',cpswdet) - AT('<PROTHEUSMENU',cpswdet)+15) , cMod)
			
			Endif
			
			//-- REMOVE AS EMPRESAS DO USUARIO BASE E CRIA EMPRESAS SOLICITADAS
			_n := aScan(aGet,{|x| x[1]=='emp' })
			If _n<>0
			
				cEmps := '<PROTHEUSFILIAL modeltype="GRID" optional="1">'+;
					     '  <struct>'+;
					     '    <USR_ACESSO order="1"></USR_ACESSO>'+;
					     '    <USR_GRPEMP order="2"></USR_GRPEMP>'+;
					     '    <USR_CODEMP order="3"></USR_CODEMP>'+;
					     '    <USR_CODUNG order="4"></USR_CODUNG>'+;
					     '    <USR_FILIAL order="5"></USR_FILIAL>'+;
					     '  </struct>'+;
					     '  <items>'
	
				aEmps := STRTOKARR(aGet[_n][2],'/')
				
				aUser[2][6] := {} // zera array com as informacoes das empresas do usuario
				
				For xE:=1 to len(aEmps)
					cEmps += '    <item id="'+alltrim(str(xE))+'" deleted="0">'+;
							     '      <USR_ACESSO>T</USR_ACESSO>'+;
							     '      <USR_GRPEMP>'+substr(aEmps[xE],1,2)+'</USR_GRPEMP>'+;
							     '      <USR_FILIAL>'+substr(aEmps[xE],3,2)+'</USR_FILIAL>'+;
							     '    </item>'
					aAdd(aUser[2][6],aEmps[xE])
		        next
	
				cEmps +=  '  </items>'+;
					      '</PROTHEUSFILIAL>'
									
				cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSFILIAL',cpswdet), AT('</PROTHEUSFILIAL>',cpswdet) - AT('<PROTHEUSFILIAL',cpswdet)+17) , cEmps)
				
			Endif
			
			//-- A C E S S O S
			_n := aScan(aGet,{|x| x[1]=='acc' })
			If _n<>0

				cAcc := '<PROTHEUSACCESS modeltype="GRID" optional="1">'+;
					    '  <struct>'+;
					    '    <USR_ACESSO order="1"></USR_ACESSO>'+;
					    '    <USR_CODACESSO order="2"></USR_CODACESSO>'+;
					    '  </struct>'+;
					    '  <items>'

				//-- limpa os acessos
				aUser[2][5] := ''
				
				For xA:=1 to len(aGet[_n][2])
				
					If xA > 190
						exit
					Endif
				
					cAcc += '<item id="'+alltrim(Str(xA))+'" deleted="0" '
					
					If Substr(aGet[_n][2],xA,1)=='S'
						cAcc += 'USR_ACESSO="T" '
						aUser[2][5] += 'S'
					Else
						aUser[2][5] += 'N'
					Endif
					
					cAcc += 'USR_CODACESSO="'+alltrim(Str(xA))+'"></item>'
				Next
				
				cAcc += '  </items>'+;
						'</PROTHEUSACCESS>'
						
				cPswDet := STRTRAN(cPswDet, SUBSTR(CPSWDET, AT('<PROTHEUSACCESS',cpswdet), AT('</PROTHEUSACCESS>',cpswdet) - AT('<PROTHEUSACCESS',cpswdet)+17) , cAcc)					
				
			Endif

			oXml:=XmlParser(cPswDet,"_",@cErro,@cWarn) 
			    
			if !empty(cErro)
				Return 'ERRO: Erro ao gerar xml do usuário '+cPswName+': '+cErro
			elseif !empty(cWarn)
				Return 'ERRO: Warn ao gerar xml do usuário '+cPswName+': '+cWarn
			Endif   
			
			//-- pega as empresas para retornar no meu xml na tag <emps>
			/*
			IF VALTYPE( OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSFILIAL:_ITEMS:_ITEM)=='O'
				aEmps := { OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSFILIAL:_ITEMS:_ITEM }
			ElseIf VALTYPE( OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSFILIAL:_ITEMS:_ITEM)=='A'
				aEmps := OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSFILIAL:_ITEMS:_ITEM
			Else
				Return 'ERRO: Empresas não é um array nem objeto no xml do usuário!'
			Endif
			
			For xE:=1 to len(aEmps)
				
			Next
	        */
	        
			//-- verifica se foi passado parametro blq no Get
			_n := aScan(aGet,{|x| x[1]=='blq' })
			If _n<>0
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_MSBLQL:_VALUE:TEXT:= Iif(aGet[_n,2]=='1','1','2')
				aUser[1][17] := aGet[_n,2]=='1'
			Endif
		
			//-- TROCA O NOME
			_n := aScan(aGet,{|x| x[1]=='nom' })
			If _n<>0
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_NOME:_VALUE:TEXT:= aGet[_n,2]
				aUser[1][4] := aGet[_n,2]
			Endif
			
			//-- verifica se foi passado parametro pwd/pwt no Get
			_n := aScan(aGet,{|x| x[1]$'pwd/pwt' })
			If _n<>0
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_PSW:_VALUE:TEXT := PadR(aGet[_n,2],25)
				CPSWPWD := MD5(PadR(aGet[_n,2],25),1)
			Endif
				
			_n := aScan(aGet,{|x| x[1]=='pwt' })
			If _n<>0
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CHGPSW','USR_CHGPSW','NOD')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW,'_ORDER','order','ATT')
				XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW,'_VALUE','value','NOD')
				
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:REALNAME := 'USR_CHGPSW'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_VALUE:REALNAME := 'value'
				OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_ORDER:REALNAME := 'order'
					
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_ORDER:TEXT := '16'
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CHGPSW:_VALUE:TEXT := 'T'
			Endif
			
			_n := aScan(aGet,{|x| x[1]=='set' })
			If _n<>0   
			
				//-- decodifica o parametro da url
				aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO SETOR
				If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_DEPTO')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_DEPTO','USR_DEPTO','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:REALNAME := 'USR_DEPTO'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_ORDER:TEXT := '10'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_DEPTO:_VALUE:TEXT := aGet[_n,2]
				aUser[1][12] := aGet[_n,2]
			Endif           


			_n := aScan(aGet,{|x| x[1]=='ema' })
			If _n<>0   

				//-- decodifica o parametro da url
				aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO EMAIL
				If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_EMAIL')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_EMAIL','USR_EMAIL','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:REALNAME := 'USR_EMAIL'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_ORDER:TEXT := '9'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_EMAIL:_VALUE:TEXT := aGet[_n,2]
				aUser[1][14] := aGet[_n,2]
			Endif           
	                                        
			//-- cargo
			_n := aScan(aGet,{|x| x[1]=='car' })
			If _n<>0   
			
				//-- decodifica o parametro da url
				aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO CARGO
				If XmlChildEx(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CARGO')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER,'_USR_CARGO','USR_CARGO','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:REALNAME := 'USR_CARGO'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_ORDER:TEXT := '11'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_USR_CARGO:_VALUE:TEXT := aGet[_n,2]
				aUser[1][13] := aGet[_n,2]
			Endif           
		
		
			_n := aScan(aGet,{|x| x[1]=='tel' })
			If _n<>0   
			
				//-- decodifica o parametro da url
				aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO ramal
				If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA,'_USR_RAMAL')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA,'_USR_RAMAL','USR_RAMAL','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:REALNAME := 'USR_RAMAL'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_ORDER:TEXT := '5'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_USR_RAMAL:_VALUE:TEXT := aGet[_n,2]
				aUser[1][20] := aGet[_n,2]
			Endif        
	
			_n := aScan(aGet,{|x| x[1]=='acs' })
			If _n<>0   
			
				//-- decodifica o parametro da url
				//aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO SETOR
				If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION,'_USR_QTDACESSOS')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION,'_USR_QTDACESSOS','USR_QTDACESSOS','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:REALNAME := 'USR_QTDACESSOS'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_ORDER:TEXT := '1'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_RESTRICTION:_USR_QTDACESSOS:_VALUE:TEXT := aGet[_n,2]
				aUser[1][15] := val(aGet[_n,2])
			Endif 
				
			//-- DIRETORIO DE IMPRESSAO
			_n := aScan(aGet,{|x| x[1]=='prn' })
			If _n<>0   
			
				//-- decodifica o parametro da url
				aGet[_n,2] := strtran(urldecode(aGet[_n,2]),"+",space(1))
			
				//-- VERIFICA SE EXISTE O NODO DO DIR IMP
				If XmlChildEx(oxml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER,'_USR_DIRIMP')==nil   
				
					//-- SE NAO EXISTIRM CRIA O NOVO NODO
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER,'_USR_DIRIMP','USR_DIRIMP','NOD')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP,'_ORDER','order','ATT')
					XmlNewNode(oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP,'_VALUE','value','NOD')
					
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:REALNAME := 'USR_DIRIMP'
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_VALUE:REALNAME := 'value'
					OXML:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_ORDER:REALNAME := 'order'
						
					oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_ORDER:TEXT := '1'
					
				Endif
		
				oXml:_FWUSERACCOUNTDATA:_DATAUSER:_PROTHEUSDATA:_PROTHEUSPRINTER:_USR_DIRIMP:_VALUE:TEXT := aGet[_n,2]
				aUser[2][3] := aGet[_n,2]
			Endif 
			
			//CONVERTE XML OBJETO PARA XML STRING
			cPswDet:=XMLSaveStr(oXml) 
						           
			// Efetua a atualização do arquivo 
			SPF_UPDATE(cPswFile,nPswRec, @cPswId , @cPswName , @cPswPwd , cPswDet )

		endif
		
		cEmps := ''
		
		For xE:=1 to len(aUser[2][6])
			cEmps += aUser[2][6][xE]+Iif(len(aUser[2][6])>xE,'/','')
		Next

        //-- trata acentuação
		aUser[1][4]  := Iif( Valtype( Decodeutf8(aUser[1][4] ))=='U' , ClearStr(aUser[1][4] ) , aUser[1][4] ) //-- nome
		aUser[1][12] := Iif( Valtype( Decodeutf8(aUser[1][12]))=='U' , ClearStr(aUser[1][12]) , aUser[1][12]) //-- setor
		aUser[1][13] := Iif( Valtype( Decodeutf8(aUser[1][13]))=='U' , ClearStr(aUser[1][13]) , aUser[1][13]) //-- cargo
	 
		cXml += '<usr>'
		cXml += '<id>'  +alltrim(aUser[1][1])+'</id>'
		cXml += '<log>' +alltrim(aUser[1][2])+'</log>'
		cXml += '<nom>' +alltrim(aUser[1][4])+'</nom>'
		cXml += '<set>' +alltrim(aUser[1][12])+'</set>'
		cXml += '<car>' +alltrim(aUser[1][13])+'</car>'
		cXml += '<ema>' +alltrim(aUser[1][14])+'</ema>'
		cXml += '<acs>' +alltrim(str(aUser[1][15]))+'</acs>'
		cXml += '<tel>' +alltrim(aUser[1][20])+'</tel>'
		cXml += '<blq>' +Iif(aUser[1][17],'S','N')+'</blq>'
		cXml += '<prn>' +alltrim(aUser[2][3])+'</prn>'
		cXml += '<emp>' +cEmps+'</emp>'
		cXml += '<acc>' +substr(alltrim(aUser[2][5]),1,N_ACC)+'</acc>'
		
		//--MODULOS
		
		lFirstMod := .t.
		
		cXml += '<mod>'
		For xM:=1 to Len(aUser[3][1])
			If upper(substr(aUser[3,1,xM],3,1))<>'X'
				cXml += Iif(lFirstMod,'','/')+substr(aUser[3,1,xM],1,2)
				lFirstMod:=.f.
			Endif
		Next
		cXml += '</mod>'
		        		
		//-- traz tambem a lista de acessos
		If aScan(aGet,{|x| x[1]$'listacc'}) > 0
			
			cXml += '<access>'
			//-- lista os acessos
			aList := GetAccessList()
			
			for xA:=1 to len(aList)
				cXml += '<acc'+alltrim(str(aList[xA][1]))+'>'+EncodeUtf8(oemtoansi(aList[xA][2]))+'</acc'+alltrim(str(aList[xA][1]))+'>'
			next
			
			cXml += '</access>'
	
		Endif	
		

		cXml += '</usr>'
		
//		cXml := EncodeUtf8(oemtoansi(cXml))
		
		Return cXML

	ENDIF

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
	
        aAllUsers := FWSFALLUSERS()
		__cMaxUser	:= aAllUsers[ Len( aAllUsers ) , 2 ]
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

Static Function ClearStr(cStr)
		//-- retira caracteres especiais
		cStr := strTran(cStr,CHR(129),"")
		cStr := strTran(cStr,CHR(157),"")
		cStr := strTran(cStr,CHR(141),"")		
	
		cStr := encodeutf8(cStr)
Return cStr