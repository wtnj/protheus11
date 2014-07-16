#INCLUDE "TOPCONN.CH"           
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHQMT007  ºAutor ³João Felipe         º Data ³  05/06/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE INSTRUMENTOS POR LINHA			              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ METROLOGIA                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHQMT007()   

cString   := "QM2"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a relação dos instrumentos por linha.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQMT007"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("INSTRUMENTOS À POR LINHA")
cabec1    := "   Departamento                           Instrumento                                                                                                    Dt. Rev.   Status   Validade          Local"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHQMT007"
_cPerg    := "QMT007" 
_aMat     := {}
 
// mv_par01 de instrumento
// mv_par02 até instrumento
// mv_par03 De linha
// mv_par04 Ate linha
// mv_par05 De Depto
// mv_par06 Ate Depto
// mv_par07 De Data 
// mv_par08 Ate Data
// mv_par09 De Status
// mv_par10 Ate Status            
// mv_par11 Exp p/ Excel ? (Sim/Nao)

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

If mv_par11==1 //excel sim
	Processa( {|| QMT007XLS() },"Importando...")
ElseIf mv_par11==2 //excel nao
	RptStatus({|| RptDetail()   },"Imprimindo...") 

	set filter to 
	//set device to screen
	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(wnrel) //Chamada do Spool de Impressao
	Endif                                          
	MS_FLUSH() //Libera fila de relatorios em spool
EndIf

TRA1->(DbCloseArea())

Return

Static Function Gerando()
Local cQuery

    //------------------
    // MONTA A QUERY                                    
    //------------------

    cQuery := "SELECT QM2.QM2_REVINS, QM2.QM2_DEPTO, QAD.QAD_DESC AS DESC01, QM2.QM2_INSTR, QM2.QM2_DESC, QM2.QM2_DATREV,"
    cQuery += " QM2.QM2_STATUS, QM2.QM2_VALDAF, QM2.QM2_LINHA1, QM2.QM2_LOCAL, CTT.CTT_DESC01 AS DESC02
    cQuery += " FROM "+RetSqlName("QM2")+" QM2,"+ RetSqlName("QAD")+" QAD,"+RetSqlName("CTT")+" CTT "
    cQuery += " WHERE QM2.QM2_INSTR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
    cQuery += " AND QM2.QM2_LINHA1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
    cQuery += " AND QM2.QM2_DEPTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
    cQuery += " AND QM2.QM2_VALDAF BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"
    cQuery += " AND QM2.QM2_STATUS BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
    cQuery += " AND QAD.QAD_CUSTO = QM2.QM2_DEPTO"
    cQuery += " AND CTT.CTT_CUSTO = QM2.QM2_LINHA1"
    cQuery += " AND QM2.QM2_FILIAL = '"+xFilial("QM2")+"' AND QM2.D_E_L_E_T_ = ' '"
    cQuery += " AND QAD.QAD_FILIAL = '"+xFilial("QAD")+"' AND QAD.D_E_L_E_T_ = ' '"
	cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT.D_E_L_E_T_ = ' '"    
    cQuery += " ORDER BY QM2.QM2_LINHA1, QM2.QM2_INSTR, QM2.QM2_REVINS"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	MemoWrit('C:\TEMP\QMT007.SQL',cQuery)
	 
	TcSetField("TRA1","QM2_DATREV","D")  // Muda a data de string para date
	TcSetField("TRA1","QM2_VALDAF","D")  // Muda a data de string para date
	
Return

Static Function RptDetail()
Local _cLinha := "ABOBRINHA"
Local _nTotLin := 0
Local _cCod    := ""

dBSelectArea("TRA1")
SetRegua(QM2->(RecCount()))
DbGoTop()

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While TRA1->(!Eof()) 
                        
	If Empty(TRA1->QM2_LINHA1)
		TRA1->(DbSkip())
		IncRegua()
		_cLinha := "ABACAXI"
		Loop
	EndIf
	
	If _cLinha <> TRA1->QM2_LINHA1
		
		//------------------------------------------------------
		// Pula os Instrumentos que nao tiverem ultima revisao  
		//------------------------------------------------------
		If _cCod == TRA1->QM2_INSTR
			TRA1->(DbSkip())
			Loop
		EndIf

		_cCod := TRA1->QM2_INSTR			

		If _nTotLin > 0
			@ Prow()+2,001 Psay "Total da Linha: "+Transform(_nTotLin,"@e 999999")
			_nTotLin := 0
			@ Prow()+1,000 PSAY __PrtThinLine()
		EndIf
		
		@Prow()+1 , 001 Psay "Linha: "+AllTrim(TRA1->QM2_LINHA1)+" - "+TRA1->DESC02
 		_cLinha := TRA1->QM2_LINHA1
 		While _cLinha == TRA1->QM2_LINHA1 .AND. TRA1->(!EOF())

		 	IncRegua()
		 	
			If Prow() > 60
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
			Endif
            
			@Prow()+1, 003 psay ALLTRIM(TRA1->QM2_DEPTO)+" - "+TRA1->DESC01
			@Prow()  , 040 psay ALLTRIM(TRA1->QM2_INSTR)+" - "+SUBSTR(TRA1->QM2_DESC,1,100)

			_nTotLin++

			@Prow()  , 154 Psay TRA1->QM2_DATREV
			@Prow()  , 168 Psay TRA1->QM2_STATUS
			@Prow()  , 174 Psay TRA1->QM2_VALDAF
			@Prow()  , 188 Psay TRA1->QM2_LOCAL
			TRA1->(DbSkip()) 
			
		EndDo
	EndIf
EndDo

@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil)


Static Function QMT007XLS()
Local cExcel, _nOutFile 
Local _cLocal  := Space(100)
Local _lRet    := .F.
Local _cLinha  := "ABOBRINHA"
Local _nTotLin := 0
Local _cCod    := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TELA PARA SOLICITACAO DO CAMINHO A SER SALVO O ARQUIVO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDlg2 := MSDialog():New(0,0,120,310,"Local do Arquivo",,,,,,,,,.T.)
    
	//contorno
	oGroup := tGroup():New(005,005,40,153,,oDlg2,,,.T.)
		
	oSay4 := TSay():New(20,10,{||"Local"},oDlg2,,,,,,.T.,,)
	
	oGet1 := tGet():New(18,30,{|u| if(Pcount() > 0, _cLocal:= u,_cLocal)},oDlg2,118,8,"@!",/*valid*/,;
		,,,,,.T.,,,/* when */,,,,,,,"_cLocal")
    
	//botoes
    oBt1 := tButton():New(45,88,"Ok",oDlg2,{||oDlg2:End()},30,10,,,,.T.)      
    oBt2 := tButton():New(45,123,"Cancelar",oDlg2,{||_lRet:=.T.,oDlg2:End()},30,10,,,,.T.)

	oDlg2:Activate(,,,.T.,{||,.T.},,{||})
	    
	If _lRet 
		Return
	EndIf	
	
	_cLocal := Alltrim(_cLocal)
	If !Right(_cLocal,1)$"\"
		_cLocal += "\"
	EndIf

	_nOutFile := Fcreate(_cLocal+"InsPorLinha.xls",0)
	
	If !File(_cLocal+"InsPorLinha.xls")
		Alert("Arquivo não pode ser criado. Escolha outro local!")
		Return
	EndIf

	cExcel := '<html>'
	cExcel += '<head></head>'
	cExcel += '<body>'
	cExcel += '<table border="1">'

	cExcel += '<tr style="background:#666666; color:#ffffff">'
	cExcel += '<td>Departamento</td>'
	cExcel += '<td>Desc. Depto</td>'
	cExcel += '<td>Instrumento</td>'
	cExcel += '<td>Desc. Instrumento</td>'
	cExcel += '<td>Data Revisão</td>'
	cExcel += '<td>Status</td>'
	cExcel += '<td>Validade da Calibração</td>'
	cExcel += '<td>Localização</td>'
	cExcel += '</tr>'
		
	ProcRegua(QM2->(RecCount()))

	While TRA1->(!Eof()) 
	                        
		If Empty(TRA1->QM2_LINHA1)
			TRA1->(DbSkip())
			IncProc()
			_cLinha := "ABACAXI"
			Loop
		EndIf
		
		If _cLinha <> TRA1->QM2_LINHA1
			
			//------------------------------------------------------
			// Pula os Instrumentos que nao tiverem ultima revisao  
			//------------------------------------------------------
			If _cCod == TRA1->QM2_INSTR
				TRA1->(DbSkip())
				Loop
			EndIf
	
			_cCod := TRA1->QM2_INSTR			
	
			If _nTotLin > 0
				cExcel += '<tr>'
				cExcel += '<td colspan="8" style="background:#cccccc">'
				cExcel += 'Total da Linha: '+Transform(_nTotLin,"@e 999999")
				cExcel += '</td>'
				cExcel += '</tr>'

				_nTotLin := 0
			EndIf
			
			/*			
			cExcel += '<tr>'
			cExcel += '<td colspan="8" style="background:#666666; color:#ffffff">'
			cExcel += 'Linha: '+AllTrim(TRA1->QM2_LINHA1)+" - "+TRA1->DESC02
			cExcel += '</td>'
			cExcel += '</tr>'
			*/
			_cLinha := TRA1->QM2_LINHA1
				 		
	 		While _cLinha == TRA1->QM2_LINHA1 .AND. TRA1->(!EOF())
	
			 	IncProc()
			 	
				cExcel += '<tr>'
				cExcel += '<td>'+ALLTRIM(TRA1->QM2_DEPTO)+'</td>'
				cExcel += '<td>'+TRA1->DESC01+'</td>'
				cExcel += '<td>'+ALLTRIM(TRA1->QM2_INSTR)+'</td>'
				cExcel += '<td>'+SUBSTR(TRA1->QM2_DESC,1,100)+'</td>'
				cExcel += '<td>'+DtoC(TRA1->QM2_DATREV)+'</td>'
				cExcel += '<td>'+TRA1->QM2_STATUS+'</td>'
				cExcel += '<td>'+DtoC(TRA1->QM2_VALDAF)+'</td>'
				cExcel += '<td>'+TRA1->QM2_LOCAL+'</td>'
				cExcel += '</tr>'
				
				_nTotLin++
	
				TRA1->(DbSkip()) 
				
			EndDo
		EndIf
	EndDo
	
	If _nTotLin > 0
		cExcel += '<tr>'
		cExcel += '<td colspan="8" style="background:#cccccc">'
		cExcel += 'Total da Linha: '+Transform(_nTotLin,"@e 999999")
		cExcel += '</td>'
		cExcel += '</tr>'

		_nTotLin := 0
	EndIf

	cExcel += '</table>'
	
	Fwrite(_nOutFile,cExcel)

	Fclose(_nOutFile)
   
	//Abre a página da ficha técnica
	ShellExecute( "open", "excel.exe",_cLocal+"InsPorLinha.xls","",5 )

Return                 