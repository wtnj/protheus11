
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHCFG009  บAutor  ณJoใo Felipe da Rosa  บ Data ณ 22/11/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MODULOS X USUARIOS                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CONFIGURADOR                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NHCFG009()

cString  := "SB1"    // Arquivo que ira fazer a filtragem
cDesc1   := "Usuarios Cadastrados no Protheus"
cDesc2   := ""
cDesc3   := ""
nOrdem   := 0
tamanho  := "M"   // Tamanho do Layout do Relatorio    "P/M/G"
limite   := 80   // Limites de Colunas do Relatorio
nPag     := 01
aReturn  := { "PREENCHER", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "NHCFG009"  // Nome do programa
aLinha   := { }
nLastKey := 0
titulo   := "Rela็ใo de Usuแrios por M๓dulo"                                     
Cabec1   := OemtoAnsi("Modulo")
Cabec2   := OemtoAnsi("  Nome                             Cargo                      Setor                       Ult. Acc.           Menu")
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1
wnrel    := "NHCFG009"
cPerg    := "CFG009"
aMat    := {} 
                                 
if !Pergunte(cPerg,.T.)
	return
Endif

SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

	
if nlastKey ==27
    Set Filter to
    Return
Endif
	
SetDefault(aReturn,cString)
	
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa( {|| fGera() } ,'Etapa 1/2 (Gerando)')

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCAO DE IMPRESSAO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGera()
    
	ProcRegua(1)
	IncProc('Etapa 1/2 (Gerando)')   

	aAllUsers := AllUsers()
	
	ProcRegua(len(aAllUsers))
	
	/*
	cAl := getnextalias()
	beginSql alias cAl   
		SELECT QAA_LOGIN 
		FROM %Table:QAA% QAA, 
		%Table:SRA% SRA
		WHERE QAA_MAT = RA_MAT
		AND RA_SITFOLH = 'D'
		AND RA_RG NOT IN (SELECT RA_RG FROM %table:SRA% WHERE D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D')
		AND RA_NOME NOT IN (SELECT RA_NOME FROM %table:SRA% WHERE D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D')
		AND QAA.%Notdel%
		AND SRA.%Notdel%
		AND QAA_LOGIN <> ''
	endSql

	While (cAl)->(!eof())
	
		(cAl)->(dbskip())
	Enddo
	*/ 
	
	//-- percorre todos os usuarios e adiciona na matriz
	For xU := 1 to len(aAllUsers)
		IncProc('Etapa 1/2 (Gerando)')   
		
		//-- pula o login de administrador
		If aAllUsers[xU][1][1]=='000000'
			Loop
		Endif
		
		//-- pula usuarios bloqueados
		If aAllUsers[xU][1][17]
			Loop
		Endif
		
		//-- percorre os menus do usuario
		For xA:=1 to len(aAllUsers[xU][3])
			//-- o menu gravado com o 3o caractere = X significa que o usuario nao tem acesso
			If Substr(aAllUsers[xU][3][xA],3,1)!='X'       
			
				aAdd(aMat,{aAllUsers[xU][1][1],; // 1 - id
						   Upper(OEMTOANSI(aAllUsers[xU][1][2])),; // 2 - login
						   Upper(OEMTOANSI(aAllUsers[xU][1][4])),; // 3 - nome 
 			          	   Upper(OEMTOANSI(aAllUsers[xU][1][13])),;// 4 - cargo
						   Upper(OEMTOANSI(aAllUsers[xU][1][12])),;// 5 - setor
						   Upper(Substr(aAllUsers[xU][3][xA],4,len(aAllUsers[xU][3][xA])-3)),; // 6 - menu
						   dtoc(FWUsrUltLog(aAllUsers[xU][1][1])[1]);  //7 - ultimo acesso
						   })
			Endif
		Next

	Next 
	      
	ProcRegua(len(aMat))

	aSort(aMat,,,{|x,y| x[6] + x[3] < y[6] + y[3]})	//ordena por menu + nome

	_cMod    := ''  // prefixo do modulo
	_cModulo := ''  // modulo
	_nCont   := 0   // contador
	_lPrim   := .T. // var aux. primeira vez
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	
	For x:=1 to len(aMat)
		
		IncProc('Etapa 2/2 (Imprimindo)')   
		
		//-- filtra os modulos se nao estiver vazio mv_par01
		If !Empty(mv_par01) .And. !mv_par01$aMat[x][6]
			Loop
		Endif
		
		//-- filtra o nome do usuario se nao estiver vazio mv_par02
		If !Empty(mv_par02) .And. !ALLTRIM(mv_par02)$aMat[x][3]
			Loop
		Endif
		 
		//-- Pula pagina
		If Prow() > 70
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		Endif

		//quebra por pagina - SIM
        If mv_par03 == 1 
			If _cModulo <> aMat[x][6] .and. !_lPrim
//			If _cMod <> Substr(aMat[x][6],10,3) .and. !_lPrim
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
			EndIf
		EndIf
		
		_lPrim := .F.
		//_cMod := Substr(aMat[x][6],10,3)	
		_cModulo := aMat[x][6]
					
/*		If _cModulo <> aMat[x][6]
		   	@ pRow()+2 , 000 pSay aMat[x][6] //modulo
			_cModulo := aMat[x][6]
		EndIf
 */
		@ pRow()+1 , 002 pSay substr(aMat[x][3],1,30) //nome usuario   
	   	@ pRow()   , 035 pSay IIF(EMPTY(aMat[x][4]),"-",substr(aMat[x][4],1,25)) //cargo			
	   	@ pRow()   , 062 pSay IIF(EMPTY(aMat[x][5]),"-",substr(aMat[x][5],1,25)) //depto
	   	@ pRow()   , 090 pSay IIF(EMPTY(aMat[x][7]),"-",aMat[x][7]) // ultimo acesso ao sistema
	   	@ pRow()   , 110 pSay aMat[x][6] // modulo
					
		_nCont++
	
	Next 	

   	@ pRow()+1 , 083 pSay 'Total de usuแrios: ' + alltrim(str(_nCont)) // contator

Return