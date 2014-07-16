/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELATORIO บAutor  ณJoใo Felipe da Rosa บ Data ณ 23/04/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CLASSE RELATORIO EM MODO TEXTO                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "msobjects.ch"

Class Relatorio
	
//	export:    
		var cString  as Character //tabela a ser usada no relat๓rio
		var cDesc1   as Character //descricao 1
		var cDesc2   as Character //descricao 2
		var cDesc3   as Character //descricao 3
		var cTamanho as Character //tamanho
		var ctitulo  as Character //titulo do relatorio
		var cNomePrg as Character //nome do programa
		var cCabec1  as Character //linha 1 do cabecalho
		var cCabec2  as Character //linha 2 do cabecalho
		var wnrel    as Character //igual ao nome do programa				
		var cPerg    as Character //nome do arquivo de perguntas
		var nTipo    as Numeric   //Tipo do relatorio
		var aReturn  as Array
		var m_pag    as Numeric
		var aOrd     as Array     //Ordem do relat๓rio devolvido pelo aReturn[8]

		method new() constructor  //metodo construtor
		method run(bFuncao)
		method cabec()
		method AjustaSx1(aPergs)

EndClass

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ METODO CONSTRUTOR ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method New() Class Relatorio

	::cString  := ""
	::cDesc1   := ""
	::cDesc2   := ""
	::cDesc3   := ""
	::cTamanho := "M"
	::cTitulo  := ""
	::cNomePrg := ""
	::cCabec1  := ""
	::cCabec2  := ""
	::wnrel    := ::cNomePrg
	::cPerg    := ""
	::aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	::m_pag    := 0
	::nTipo    := IIF(::aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM")) //Verifica se deve comprimir ou nao 
	::aOrd     := nil
	
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ INICIALIZA O RELATORIOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method Run(bFuncao) Class Relatorio

Private aReturn := ::aReturn
Private m_pag   := ::m_pag

	Pergunte(::cPerg,.F.)
            
	SetPrint(::cString,;
	         ::wnrel,;
	         ::cPerg,;
	         ::cTitulo,;
	         ::cDesc1,;
	         ::cDesc2,;
	         ::cDesc3,;
	         .F.,;
	         ::aOrd,,;
	         ::cTamanho) 

	if nlastKey ==27
	    Set Filter to
    	Return .F.
	Endif
	
	SetDefault(aReturn,::cString)

	RptStatus(bFuncao,"Imprimindo...")

	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(::wnrel) //Chamada do Spool de Impressao
	Endif                                          
	
	MS_FLUSH() //Libera fila de relatorios em spool
	
Return    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ฟ
//ณ CABECALHO DO RELATORIO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ู
Method Cabec() Class Relatorio
Private aReturn := ::aReturn
Private m_pag   := ::m_pag

	Cabec(::cTitulo,;
	      ::cCabec1,;
	      ::cCabec2,;
	      ::cNomePrg,;
	      ::cTamanho,;
	      ::nTipo) 
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCAO PARA CRIAR AS PERGUNTAS NO SX1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method AjustaSx1(aPergs) Class Relatorio
Local aArea  := getArea()
Local cPerg  := ""
Local x      := 0
Local aChars := {"1","2","3","4","5","6","7","8","9",;
                 "a","b","c","d","e","f","g","h","i",;
				 "j","k","l","m","n","o","p","q","r",;
	  			 "s","t","u","w","y","x","z"}

SetPrvt("cAlias,cPerg,aRegs,cUltPerg,i,j")

cPerg   := AllTrim(::cPerg)
While len(cPerg) < 10
	cPerg += " "
EndDo

aRegs   := {}
For x:=1 to len(aPergs)

	aadd(aRegs,{cPerg,; //pergunta
				StrZero(x,2),; //ordem
				aPergs[x][1],; //titulo pt
				aPergs[x][1],; //titulo en
				aPergs[x][1],; //titulo es
				"mv_ch"+aChars[x],;//var "mv_ch1"
				aPergs[x][2],; //tipo
				aPergs[x][3],; //tamanho
				aPergs[x][4],; //decimal
				0,; //X1_PRESEL
				aPergs[x][5],; //G / C 
				"",; //VALID
				"mv_par"+strzero(x,2),; //VAR01
				aPergs[x][6],aPergs[x][6],aPergs[x][6],; //DEF01 pt, DEF01 en, DEF01 es
				"","",; //CNT01 , VAR02
				aPergs[x][7],aPergs[x][7],aPergs[x][7],; //DEF02 pt, DEF02 en, DEF02 es
				"","",; //CNT02 , VAR03
				aPergs[x][8],aPergs[x][8],aPergs[x][8],; //DEF03 pt, DEF03 en, DEF03 es
				"","",; //CNT03 , VAR04
				aPergs[x][9],aPergs[x][9],aPergs[x][9],; //DEF04 pt, DEF04 en, DEF04 es
				"","",; //CNT04 , VAR05
				aPergs[x][10],aPergs[x][10],aPergs[x][10],; //DEF05 pt, DEF05 en, DEF05 es
				"",; //CNT05
				aPergs[x][11],; //f3
				"","","",; //PYME, GRPSXG, HELP
				aPergs[x][12],; //PICTURE
				""}) // IDFIL

Next

dbSelectArea("SX1")
dbSetOrder(1)

For x:=1 To Len(aRegs)
	
	//se encontrar, atualiza a pergunta
	If dbSeek(cPerg + aRegs[x][2])
		RecLock("SX1", .F.)
			For j:=1 to Len(aRegs[x])
				FieldPut(j, aRegs[x, j])
			Next
		MsUnlock("SX1")
		      
		//retira os duplicados
		dbSkip()
		While !eof() .and. SX1->X1_GRUPO==cPerg
		    If SX1->X1_ORDEM==aRegs[x][2]
		    	RecLock("SX1",.F.)
		    		dbDelete()
		    	MsUnlock("SX1")
		    EndIf
			dbSkip()
		EndDo
	
	//se nใo encontrar, inclui a pergunta		
	Else
		RecLock("SX1", .T.)
			For j:=1 to Len(aRegs[x])
				FieldPut(j, aRegs[x, j])
			Next
		MsUnlock("SX1")
	EndIf
	
	DbCommit()
Next

cUltPerg := aRegs[Len(aRegs)][2]

If dbSeek(cPerg + StrZero(Val(cUltPerg)+1,2))
	
	While !eof() .and. SX1->X1_GRUPO==cPerg
		If SX1->X1_ORDEM >= StrZero(Val(cUltPerg)+1,2)
	   		RecLock("SX1",.F.)
	      		SX1->(DbDelete())
	      	MsUnLock("SX1")
		EndIf	      	
      	dbSkip()
  EndDo

EndIf			

RestArea(aArea)

Return                     

