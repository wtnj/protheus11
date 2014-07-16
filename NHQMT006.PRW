#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHQMT006   ºAutor ³João Felipe         º Data ³  23/04/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INSTRUMENTOS A CALIBRAR						              º±±
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

User Function NHQMT006()   

cString   := "QM2"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a relação dos instrumentos a serem calibrados.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQMT006"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("INSTRUMENTOS À CALIBRAR")
cabec1    := " Departamento                     Instrumento                                              Local                       Responsavel                             Validade        Familia             Nº. Certif."
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHQMT006"
_cPerg    := "QMT006" 
_aMat     := {}
_aCabec   := {}

// mv_par01 de instrumento
// mv_par02 até instrumento
// mv_par03 de responsável
// mv_par04 até reponsável
// mv_par05 de data
// mv_par06 até data
// mv_par07 de depto
// mv_par08 ate depto
// mv_par09 de status
// mv_par10 ate status 
// mv_par11 exportar p/ excel ?    
// mv_par12 de Familia
// mv_par13 ate Familia
// mv_par14 Quebra por Familia ?

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

If mv_par11==1
	Processa( {|| U_NHMATXLS(_aCabec,_aMat) },"Importando...")
ElseIf mv_par11==2
	Processa( {|| RptDetail()     },"Imprimindo...") 

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
Local _cCod      := ""
Local _cCCDesc   := ""
Local _cNome     := "" 

    //------------------
    // MONTA A QUERY
    //------------------
    BeginSql Alias "TRA1"
    	SELECT
			QM2.QM2_REVINS ,  
			QM2.QM2_INSTR  , 
			QM2.QM2_DESC   , 
			QM2.QM2_DEPTO  ,
			QM2.QM2_VALDAF ,
			QM2.QM2_LOCAL  , 
			QM2.QM2_RESP   , 
			QM2.QM2_STATUS , 
			QM2.QM2_TIPO   ,
			(
				SELECT TOP 1 
					QM7.QM7_NRCERT
				FROM 
					%Table:QM7% QM7 (NOLOCK)
				WHERE
					QM2.QM2_INSTR = QM7.QM7_INSTR
					AND QM2.QM2_REVINS = QM7.QM7_REVINS
					AND QM7.%NOTDEL%
					AND QM7.QM7_FILIAL = %xFilial:QM7%
				ORDER BY 
					QM7.QM7_DATA DESC
			) CERTIF
			
    	FROM 
    		%Table:QM2% QM2 (NOLOCK)
    	WHERE 
    			QM2.QM2_INSTR  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND QM2.QM2_RESP   BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND QM2.QM2_VALDAF BETWEEN %Exp:DtoS(mv_par05)% AND %Exp:DtoS(mv_par06)%
			AND QM2.QM2_DEPTO  BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
			AND QM2.QM2_STATUS BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
   			AND QM2.QM2_TIPO   BETWEEN %Exp:mv_par12% AND %Exp:mv_par13%
			AND QM2.%notdel%
			AND QM2.QM2_FILIAL = %xFilial:QM2%
			AND QM2.QM2_INSTR+QM2.QM2_REVINS IN ( // SO PEGA A ULTIMA REVISAO
				SELECT 
					QMX.QM2_INSTR + MAX(QMX.QM2_REVINS)
				FROM
					%Table:QM2% QMX (NOLOCK)
				WHERE 
					QMX.D_E_L_E_T_ = ' '
				GROUP BY 
					QMX.QM2_INSTR
			)	
 		ORDER 
 			BY QM2_FILIAL,
 			QM2_INSTR,
 			QM2_REVINS
 		DESC
	EndSql
/*
    cQuery := "SELECT QM2.QM2_INSTR, QM2.QM2_DESC, QM2.QM2_REVINS,  QM2.QM2_DEPTO,"
    cQuery += " QM2.QM2_VALDAF,QM2.QM2_LOCAL, QM2.QM2_RESP, QM2.QM2_STATUS, QM2.QM2_TIPO"
    cQuery += " FROM "+RetSqlName("QM2")+" QM2"
    cQuery += " WHERE QM2.QM2_INSTR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"    
    cQuery += " AND QM2.QM2_TIPO BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	cQuery += " AND QM2.D_E_L_E_T_ = ' ' AND QM2.QM2_FILIAL = '"+xFilial('QM2')+"'"
    cQuery += " ORDER BY QM2_FILIAL, QM2_INSTR, QM2_REVINS DESC"

	TCQUERY cQuery NEW ALIAS "TRA1"  
*/	
	TRA1->(DbGoTop())

	TCSETFIELD("TRA1","QM2_VALDAF","D") //Muda de string para data

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

	While TRA1->(!Eof()) //seleciona os instrumentos
		
		aAdd(_aMat,{TRA1->QM2_DEPTO,;
				    Substr(Posicione("CTT",1,xFilial('CTT')+TRA1->QM2_DEPTO,"CTT_DESC01"),1,26),;
				    ALLTRIM(TRA1->QM2_INSTR),;
				    TRA1->QM2_REVINS,;
				    SUBSTR(TRA1->QM2_DESC,1,65),;
				    TRA1->QM2_LOCAL,;
				    TRA1->QM2_RESP,;
				    Substr(Posicione("SRA",1,xFilial('SRA')+AllTrim(TRA1->QM2_RESP),"RA_NOME"),1,24),;
				    TRA1->QM2_VALDAF,;
				    TRA1->QM2_TIPO,;
				    TRA1->CERTIF})
	
		TRA1->(DbSkip())

	EndDo
	
	If mv_par11==1 //se for exportar p/ excel
		_aCabec   := {"Departamento","Descrição","Instrumento","Revisão","Descrição","Local","Responsavel","Nome Resp.","Validade","Familia","Nº Certif."}
	EndIf
	
	aSort(_aMat,,,{|x,y| x[1]+x[3] < y[1]+y[3]}) //ordena por depto + instrumento

Return

Static Function RptDetail()  
Local _nTotal := 0 
Local cFam    := Iif(Len(_aMat)>0,_aMat[1][10],'')
	
	For x := 1 to len(_aMat)

		If (mv_par14==1 .AND. cFam!=_aMat[x][10]) .or. Prow() > 55 
			_nPag  := _nPag + 1
			cFam := _aMat[x][10]
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		EndIf			

		@Prow()+2, 001 psay _aMat[x][1] 			// cc
		@Prow()  , 010 psay " "+Substr(_aMat[x][2],1,20) // desc cc
		@Prow()  , 035 psay _aMat[x][3] 			// instrmento
		@Prow()  , 050 psay " - "+_aMat[x][4] 		// revisao
		@Prow()  , 057 psay Substr(_aMat[x][5],1,30) // desc instr
		@Prow()  , 092 psay _aMat[x][6]  			//local
		@Prow()  , 120 psay _aMat[x][7]  			// mat resp
		@Prow()  , 130 psay _aMat[x][8]  			// nome resp
		@Prow()  , 160 psay _aMat[x][9]  			// validade
		@Prow()  , 176 psay _aMat[x][10] 			// familia
		@Prow()  , 196 psay _aMat[x][11] 			// nr certif
		
		_nTotal++

    Next                                                      J

	@ Prow()+1,000 PSAY __PrtThinLine()
	@ Prow()+1,001 psay "Total: "+ Str(_nTotal,8)

Return(nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMATXLS  ºAutor  ³João Felipe da Rosa º Data ³  30/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EXPORTA MATRIZ PARA EXCEL                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMATXLS(aCabec,aMat)
Local cExcel, _nOutFile 
Local _cLocal := Space(100)
Local _lRet   := .F.

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

	_nOutFile := Fcreate(_cLocal+"InsACalib.xls",0)
	
	If !File(_cLocal+"InsACalib.xls")
		Alert("Arquivo não pode ser criado. Escolha outro local!")
		Return
	EndIf

	cExcel := '<html>'
	cExcel += '<head></head>'
	cExcel += '<body>'
	cExcel += '<table border="1">'
	
	If !empty(aCabec)
		//Cabecalho
		cExcel += '<tr>'
	    for x:=1 to Len(aCabec)
			cExcel += '<td style="background:#aabbcc">'+aCabec[x]+'</td>'
		next
		cExcel += '</tr>'
	EndIf
	
	If !empty(aMat)
		For _x := 1 to Len(aMat)
			
			cExcel += '<tr>'
			For _y := 1 to Len(aMat[_x])
				If ValType(aMat[_x][_y]) == "C"
					cExcel += '<td>="'+aMat[_x][_y]+'"</td>'
				ElseIf ValType(aMat[_x][_y]) == "N"
					cExcel += '<td>="'+Str(aMat[_x][_y])+'"</td>'
				ElseIf ValType(aMat[_x][_y]) == "D"
					cExcel += '<td>="'+DtoC(aMat[_x][_y])+'"</td>'
				Else
					cExcel += '<td>&nbsp;</td>'
				EndIf
			Next
			cExcel += '</tr>'
		Next
	EndIf
		
	Fwrite(_nOutFile,cExcel)

	Fclose(_nOutFile)
   
	//Abre a página da ficha técnica
	ShellExecute( "open", "excel.exe",_cLocal+"InsACalib.xls","",5 )

Return