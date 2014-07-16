/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHQMT009  ³ Autor ³ João Felipe da Rosa    Data ³ 01/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Instrumentos                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ METROLOGIA                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch" 
#INCLUDE "protheus.ch"
//#Include "prtopdef.ch"    

User Function NHQMT009()

//mv_par01 de instrumento
//mv_par02 até instrumento
//mv_par03 contendo descricao
//mv_par04 de linha
//mv_par05 ate linha
//mv_par06 de c.custo
//mv_par07 ate c.custo
//mv_par08 de data
//mv_par09 ate data
//mv_par10 de status
//mv_par11 ate status

SetPrvt("CCADASTRO,AROTINA,_aMat")

cQuery    := ""
_aMat     := {}
nOpc      := 0 
_cPesq1   := Space(16) 
oDlg      := Nil   
oLbx      := Nil
_cPerg    := "QMT009" 
_cPesq    := ""
_cOrdn    := ""
_aOrd     := {"Status","Fabricante","Responsável","Localização"}
_cVar	  := Space(30)
_aLocaliz := {"Cod. Instr.", "Descrição", "Linha 1","C.Custo","Nº RNC"} 

IF !Pergunte(_cPerg,.T.)
	Return
EndIf

Processa({|| Gerando() }, OemToAnsi("Gerando Dados..."))

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE "Consulta de Instrumentos" FROM 0,0 TO 480,800 PIXEL

@ 048,005 LISTBOX oLbx FIELDS HEADER ;
"Nº Instrumento","Revisão","Descrição","Linha 1","Depto (C.C)","Localização","Status",;
"Responsável","Nome Resp","Data Calibração","Resp. Calibração","Nome Resp. Calib.","Nº RNC","Fabricante";
   SIZE 392,185 OF oDlg PIXEL ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())

oLbx:SetArray( _aMat )
oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;
                   _aMat[oLbx:nAt,2],;
                   _aMat[oLbx:nAt,3],;
                   _aMat[oLbx:nAt,4],;
                   _aMat[oLbx:nAt,5],;
                   _aMat[oLbx:nAt,6],;
                   _aMat[oLbx:nAt,7],;
                   _aMat[oLbx:nAt,8],;
                   _aMat[oLbx:nAt,9],;
                   _aMat[oLbx:nAt,10],;
                   _aMat[oLbx:nAt,11],;
                   _aMat[oLbx:nAt,12],;
                   _aMat[oLbx:nAt,13],;
                   _aMat[oLbx:nAt,14]}}  
oLbx:Refresh()                   
@ 18,010 SAY OemtoAnsi("Pesquisa Por: ") SIZE 100,008 PIXEL OF oDlg 
@ 18,050 COMBOBOX _cPesq ITEMS _aLocaliz SIZE 55,10 object oTipon
@ 33,010 SAY "Localizar : " SIZE 060,008 PIXEL OF oDlg 
@ 33,050 Get _cPesq1  Picture "@!" SIZE 060,008 PIXEL OF oDlg VALID fPesq()
@ 18,120 SAY OemtoAnsi("Ordenar Por: ") SIZE 100,008 PIXEL OF oDlg
@ 18,160 COMBOBOX _cOrdn ITEMS _aOrd SIZE 55,10 object oCOrd
@ 18,216 BUTTON "_Ir" Size 15,10 Action fOrdem(_cOrdn) object oBtn
//@ 18,250 BUTTON "Solic. Compras" Size 60,10 Action MATA110() object oBtn2
@ 18,335 BUTTON "Exp. Excel" Size 60,10 Action QMT009XLS(_aMat) object oBtn3
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_fDet(oLbx:nAt),nOpc:=1,,.T.},{||oDlg:End()}) CENTERED

Return 

//+-------------------------------------------------+
//| Seleciona os dados a serem mostrados no listbox |
//+-------------------------------------------------+
Static Function Gerando()
Local _cCod   := ""
Local _dCalib := CtoD("  /  /  ")
Local _cResp  := ""
Local _cNome  := "" 

cQuery := " SELECT QM2.QM2_INSTR, QM2.QM2_REVINS, QM2.QM2_DESC, QM2.QM2_LINHA1, "
cQuery += " QM2.QM2_DEPTO, QM2.QM2_LOCAL, QM2.QM2_STATUS, QM2.QM2_RESP,"
cQuery += " QAA.QAA_NOME, QM2.QM2_DESCR, QM2.QM2_FABR"
cQuery += " FROM "+RetSqlName("QM2")+" QM2, "+RetSqlName("QAA")+" QAA"
cQuery += " WHERE QAA.QAA_MAT = QM2.QM2_RESP"
cQuery += " AND QM2.QM2_INSTR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
//cQuery += " AND QM2.QM2_DESC LIKE '%"+ALLTRIM(MV_PAR03)+"%'"
cQuery += " AND QM2.QM2_LINHA1 BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"
cQuery += " AND QM2.QM2_DEPTO BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"
cQuery += " AND QM2.QM2_STATUS BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"'"
cQuery += " AND QM2.QM2_VALDAF BETWEEN '"+DTOS(MV_PAR08)+"' AND '"+DTOS(MV_PAR09)+"'"
/*
If MV_PAR10 == 1 //A CALIBRAR
	cQuery += " AND QM2.QM2_VALDAF > '"+DTOS(Date())+"'"
ELSEIF MV_PAR10 == 2 //CALIBRADOS
	cQuery += " AND QM2.QM2_VALDAF < '"+DTOS(Date())+"'"
ENDIF
*/
cQuery += " AND QM2.D_E_L_E_T_ = '' AND QM2.QM2_FILIAL = '"+xFilial("QM2")+"'"
cQuery += " AND QAA.D_E_L_E_T_ = '' AND QAA.QAA_FILIAL = '"+xFilial("QAA")+"'" 
cQuery += " ORDER BY QM2_FILIAL, QM2_INSTR, QM2_REVINS DESC"

TCQUERY cQuery NEW ALIAS "TRA1"

ProcRegua(RecCount("TRA1"))

QM6->(DbSetOrder(1))//QM6_FILIAL+QM6_INSTR+QM6_REVINS+dtos(QM6_DATA)+QM6_CSEQ
QAA->(DbSetOrder(1))//QAA_FILIAL+QAA_MAT
	
While TRA1->(!EoF())   
	
	IncProc(TRA1->QM2_INSTR)

	//SÓ PEGA OS INSTRUMENTOS DA ÚLTIMA REVISÃO
	If _cCod == TRA1->QM2_INSTR
		TRA1->(DbSkip())
		Loop
	EndIf
		
	_cCod   := TRA1->QM2_INSTR	
 	_dCalib := CtoD("  /  /  ")
 	_cResp  := ""
 	_cNome  := ""
	
	QM6->(DbGoTop())
	
	//PEGA OS DADOS DA ÚLTIMA CALIBRAÇÃO	
	IF QM6->(DbSeek(xFilial("QM6")+TRA1->QM2_INSTR+TRA1->QM2_REVINS))
		WHILE QM6->QM6_INSTR == TRA1->QM2_INSTR .AND. QM6->QM6_REVINS == TRA1->QM2_REVINS

		    _dCalib := QM6->QM6_DATA
        	
        	_cResp := QM6->QM6_RESP
        	IF QAA->(DBSEEK(xFilial("QAA")+QM6->QM6_RESP))
        		_cNome := QAA->QAA_NOME
        	ELSE
        		_cNome := ""
        	ENDIF
        	
			QM6->(DbSkip())
	    ENDDO 
	    
	ENDIF  
	
	//ADICIONA NA MATRIZ
	aAdd(_aMat,{TRA1->QM2_INSTR,; 
				TRA1->QM2_REVINS,;
				TRA1->QM2_DESC,;
				TRA1->QM2_LINHA1,;
				TRA1->QM2_DEPTO,;
				TRA1->QM2_LOCAL,;
				TRA1->QM2_STATUS,;
				TRA1->QM2_RESP,;
				TRA1->QAA_NOME,;
				_dCalib,;
				_cResp,;
				_cNome,;
				TRA1->QM2_DESCR,;
				TRA1->QM2_FABR})

	TRA1->(DbSkip())
EndDo

TRA1->(DBCLOSEAREA())

// Se o select não retornar valor adiciona um vetor vazio para não dar erro.
If Empty(_aMat)
	aAdd(_aMat,{"","","","","","","","","","","","","",""})
EndIf

Return

Static Function fPesq()
Local _nPc := 0

	If _cPesq == "Cod. Instr."
	    aSort(_aMat,,,{|x,y| x[1] > y[1]}) //ordena a matriz por codigo do instrumento
	    _nPc := Ascan(_aMat,{|x| AllTrim(_cPesq1) == Substr(x[1],1,len(ALLTRIM(_cPesq1))) }) //localiza o instrumento na matriz por codigo
    ElseIf _cPesq == "Descrição"
	    aSort(_aMat,,,{|x,y| x[3] > y[3]}) //ordena a matriz por descrição
	    _nPc := Ascan(_aMat,{|x| AllTrim(_cPesq1) == substr(x[3],1,len(ALLTRIM(_cPesq1))) }) //localiza a peca na matriz por descricao
	ElseIf _cPesq == "Linha 1"
	    aSort(_aMat,,,{|x,y| x[4] > y[4]}) //ordena a matriz por Linha 1
		_nPc := Ascan(_aMat,{|x| AllTrim(_cPesq1) == Substr(x[4],1,len(ALLTRIM(_cPesq1))) }) //localiza a peca na matriz por desc. fornecedor
	ElseIf _cPesq == "C.Custo"
	    aSort(_aMat,,,{|x,y| x[5] > y[5]}) //ordena a matriz por C.Custo
		_nPc := Ascan(_aMat,{|x| AllTrim(_cPesq1) == Substr(x[5],1,len(ALLTRIM(_cPesq1))) }) //localiza a peca na matriz por desc. fornecedor
	ElseIf _cPesq == "Nº RNC"
	    aSort(_aMat,,,{|x,y| x[13] > y[13]}) //ordena a matriz por RNC
		_nPc := Ascan(_aMat,{|x| AllTrim(_cPesq1) == Substr(x[13],1,len(ALLTRIM(_cPesq1))) }) //localiza a peca na matriz por desc. fornecedor
	EndIf

    oLbx:Reset()
    oLbx:SetArray( _aMat )
    oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;
                   _aMat[oLbx:nAt,2],; 
                   _aMat[oLbx:nAt,3],; 
                   _aMat[oLbx:nAt,4],; 
                   _aMat[oLbx:nAt,5],; 
                   _aMat[oLbx:nAt,6],; 
                   _aMat[oLbx:nAt,7],; 
                   _aMat[oLbx:nAt,8],; 
                   _aMat[oLbx:nAt,9],; 
                   _aMat[oLbx:nAt,10],;
                   _aMat[oLbx:nAt,11],;
                   _aMat[oLbx:nAt,12],;
                   _aMat[oLbx:nAt,13],;
                   _aMat[oLbx:nAt,14]}}

	If _nPc <> 0
		oLbx:nAt := _nPc //posiciona o registro na matriz
		oLbx:Refresh(.F.)  //atualiza a matriz para mostrar em tela
	EndIf

Return(.T.)

Static Function fOrdem(_cOr)

	If _cOr == "Status"
	    aSort(_aMat,,,{|x,y| x[7] < y[7]}) //ordena a matriz por STATUS
	ElseIf _cOr == "Fabricante"
	    aSort(_aMat,,,{|x,y| x[14] < y[14]}) //ordena a matriz por FABRICANTE
    ElseIf _cOr == "Responsável"
	    aSort(_aMat,,,{|x,y| x[9] < y[9]}) //ordena a matriz por responsavel
	ElseIf _cOr == "Localização"
	    aSort(_aMat,,,{|x,y| x[6] < y[6]}) //ordena a matriz por local
	EndIf
	
    oLbx:Reset()
    oLbx:SetArray( _aMat )
    oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;
                   _aMat[oLbx:nAt,2],; 
                   _aMat[oLbx:nAt,3],; 
                   _aMat[oLbx:nAt,4],; 
                   _aMat[oLbx:nAt,5],; 
                   _aMat[oLbx:nAt,6],; 
                   _aMat[oLbx:nAt,7],; 
                   _aMat[oLbx:nAt,8],; 
                   _aMat[oLbx:nAt,9],; 
                   _aMat[oLbx:nAt,10],;
                   _aMat[oLbx:nAt,11],;
                   _aMat[oLbx:nAt,12],;
                   _aMat[oLbx:nAt,13],;
                   _aMat[oLbx:nAt,14]}}

	oLbx:Refresh(.F.)  //atualiza a matriz para mostrar em tela

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXPORTA PARA EXCEL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static function QMT009XLS(_aMat)
Local cExcel, _nOutFile 
Local _cLocal := Space(100)
Local _lRet   := .F.

	//define a tela
	oDlg2 := MSDialog():New(0,0,120,310,"Local do Arquivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
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

	_nOutFile := Fcreate(_cLocal+"nhqmt009.xls",0)
	
	If !File(_cLocal+"nhqmt009.xls")
		Alert("Arquivo não pode ser criado. Escolha outro local!")
		Return
	EndIf

	cExcel := '<html>'
	cExcel += '<head></head>'
	cExcel += '<body>'
	cExcel += '<table border="1">'
	
	//Cabecalho
	cExcel += '<tr style="background:#aabbcc">'
	cExcel += '<td>Cod. Instrumento</td>'
	cExcel += '<td>Revisão</td>'
	cExcel += '<td>Descrição</td>'
	cExcel += '<td>Linha 1</td>'
	cExcel += '<td>Depto (C.C)</td>'
	cExcel += '<td>Localização</td>'
	cExcel += '<td>Status</td>'
	cExcel += '<td>Responsável</td>'
	cExcel += '<td>Nome Resp.</td>'
	cExcel += '<td>Data Calibração</td>'
	cExcel += '<td>Resp. Calibração</td>'
	cExcel += '<td>Nome Resp. Calib.</td>'
	cExcel += '<td>Nº RNC</td>'
	cExcel += '<td>Fabricante</td>'
	cExcel += '</tr>'
	
	For _x := 1 to Len(_aMat)
		cExcel += '<tr>'
		
		For _y := 1 to Len(_aMat[_x])
			If ValType(_aMat[_x][_y]) == "C"
				cExcel += '<td>'+_aMat[_x][_y]+'</td>'
			ElseIf ValType(_aMat[_x][_y]) == "N"
				cExcel += '<td>'+Str(_aMat[_x][_y])+'</td>'
			ElseIf ValType(_aMat[_x][_y]) == "D"
				cExcel += '<td>'+DtoC(_aMat[_x][_y])+'</td>'
			Else
				cExcel += '<td></td>'
			EndIf
		Next
		
		cExcel += '</tr>'
	Next
	
	Fwrite(_nOutFile,cExcel)

	Fclose(_nOutFile)
   
	//Abre a página da ficha técnica
	ShellExecute( "open", "excel.exe",_cLocal+"NHQMT009.xls","",5 )
        
Return
