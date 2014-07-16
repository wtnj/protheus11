/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT014  ºAutor ³João Felipe da Rosa º Data ³  28/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE APONTAMENTO DE HORAS POR MANUTENCAO           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include 'fivewin.ch'
#include "MSGRAPHI.CH"
#include 'topconn.ch'
#include "rwmake.ch"

User Function NHMNT014()   

cString   := "STJ"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o total de horas Apontadas")
cDesc2    := OemToAnsi("Por funcionário")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT014"
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO HORAS APONTADAS")                
cabec1    := OemToAnsi("  Mat     Funcionário              Serviço   Hs Apontadas  Hs Trabalhadas  %Utilização  Turno")    
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT014"
_cPerg    := "MNT014" 
aMat      := {}

// mv_par01 -> do Funcionario
// mv_par02 -> ate Funcionario
// mv_par03 -> de data
// mv_par04 -> ate data
// mv_par05 -> de Turno
// mv_par06 -> ate Turno
// mv_par07 -> de Servico
// mv_par08 -> até Servico
// mv_par09 -> de C.Custo
// mv_par10 -> até C.Custo
// mv_par11 -> Informação (1=relatório 2=grafico)
// mv_par12 -> De C. Trabalho
// mv_par13 -> Ate C. Trabalho

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

Pergunte(_cPerg,.F.) 

/*
If Val(Substr(mv_par03,1,2)) < 0 .Or. Val(Substr(mv_par03,1,2))> 12 .Or.;
   Val(Substr(mv_par04,1,2)) < 0 .Or. Val(Substr(mv_par04,1,2)) > 12
   
	Msgbox(OemtoAnsi("Atenção MesAno com Erro de Digitação!","Atenção","ALERT"))
 	Return(nil)

Else

	mv_par03 := Substr(mv_par03,4,4)+Substr(mv_par03,1,2)+'01'
	mv_par04 := Substr(mv_par04,4,4)+Substr(mv_par04,1,2)+'30'

EndIf
*/

titulo += " NO PERÍODO "+DtoC(mv_par03)+" - "+DtoC(mv_par04)
SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")

If mv_par11==1 //relatorio
	Processa( {|| RptDetail() },"Imprimindo...")
ElseIf mv_par11==2
	Processa( {|| fGrafico()  },"Gerando Gráfico...")
	Return
EndIf

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cFiltro := ""
Local aAux := {}
	
	dbSelectArea("ST1")
	
	dbGoTop()

	cFiltro := " ST1->T1_DISPONI == 'S' .AND. "
	cFiltro += " ST1->T1_CODFUNC >= mv_par01 .AND. "
	cFiltro += " ST1->T1_CODFUNC <= mv_par02 .AND. "
	cFiltro += " ST1->T1_TURNO   >= mv_par05 .AND. "
	cFiltro += " ST1->T1_TURNO   <= mv_par06 .AND. "
	cFiltro += " ST1->T1_CCUSTO  >= mv_par09 .AND. "
	cFiltro += " ST1->T1_CCUSTO  <= mv_par10"

	SET FILTER TO &(cFiltro)
	
	ProcRegua(RecCount())
	
	//PERCORRE A TABELA DE FUNCIONARIOS (ST1)
	While ST1->(!EOF())
	
		IncProc(ST1->T1_CODFUNC)
		
		//NA USINAGEM, MATRICULA ABAIXO DE 000334 SAO TERCEIROS
		If SM0->M0_CODIGO=="NH" .AND. ST1->T1_CODFUNC < '000334'
			ST1->(dbSkip())
			Loop
		EndIf

		aAux :=   {ST1->T1_CODFUNC,; //1 - MATRICULA
		           ST1->T1_NOME,;    //2 - NOME
		           ST1->T1_TURNO,;   //3 - TURNO
		           {},;              //4 - HORAS APONTADAS POR SERVICO
	    	       0,;               //5 - TOTAL DE HORAS APONTADAS
    	    	   0}                //6 - HORAS TRABALHADAS NO MES COM HORAS EXTRAS

		/********************************************************
		* MONTA A QUERY PARA TRAZER HORAS APONTADAS POR SERVICO *
		********************************************************/
		cQuery := " SELECT SUM((((CAST(SUBSTRING(TL.TL_HOFIM,1,2) AS FLOAT )*60)+ "
		cQuery += " (CAST(SUBSTRING(TL.TL_HOFIM,4,2) AS FLOAT )))/60) - "
		cQuery += " (((CAST(SUBSTRING(TL.TL_HOINICI,1,2) AS FLOAT )*60)+ (CAST(SUBSTRING(TL.TL_HOINICI,4,2) AS FLOAT )))/60)+ "
		cQuery += " ((CAST(TL.TL_DTFIM AS INT)-CAST(TL.TL_DTINICI AS INT))*24)) AS HORAAP, TJ.TJ_SERVICO"
		cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName("STJ")+" TJ"
		cQuery += " WHERE TJ.TJ_ORDEM = TL.TL_ORDEM" 
		cQuery += " AND   TJ.TJ_CENTRAB BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
		cQuery += " AND   TL.TL_CODIGO = '"+ST1->T1_CODFUNC+"'"
		cQuery += " AND   TL.TL_DTINICI BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		cQuery += " AND   TL.TL_DTFIM   BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		cQuery += " AND TL.D_E_L_E_T_ = '' AND TL.TL_FILIAL = '"+xFilial("STL")+"'"
		cQuery += " AND TJ.D_E_L_E_T_ = '' AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"'"
		cQuery += " GROUP BY TJ.TJ_SERVICO"
		cQuery += " ORDER BY TJ.TJ_SERVICO"
			
		TCQUERY cQuery NEW ALIAS "TRA1"
			
		WHILE TRA1->(!EOF())
			
			//FILTRA POR SERVIÇO
			If TRA1->TJ_SERVICO >= mv_par07 .AND. TRA1->TJ_SERVICO <= mv_par08 
	           	aAdd(aAux[4],{TRA1->TJ_SERVICO,TRA1->HORAAP}) //adiciona no array
    	       	aAux[5] += TRA1->HORAAP //acumula o total de horas apontadas
   			EndIf
   			
           	TRA1->(dbSkip())
		ENDDO
			
		dbCloseArea("TRA1") //FECHA A ÁREA DE TRABALHO TRA
			
		/****************************************************************
		* MONTA A QUERY PARA TRAZER O TOTAL DE HORAS TRABALHADAS NO MES *
		****************************************************************/
		cQuery := "SELECT SUM(RD.RD_HORAS) AS TOTAL "
		cQuery += " FROM "+RetSqlName('SRD')+" RD"
		cQuery += " WHERE RD.RD_MAT = '"+ST1->T1_CODFUNC+"'"
 		cQuery += " AND RD.RD_PD IN ('102','105','106','107','108','109','110','111')"
		cQuery += " AND	RD.RD_DATARQ BETWEEN '"+Substr(DTOS(mv_par03),1,6)+"' AND '"+Substr(dtos(mv_par04),1,6) +"'"
		cQuery += " AND RD.D_E_L_E_T_ = ' ' AND RD.RD_FILIAL = '"+xFilial('SRD')+"'"
		
		TCQUERY cQuery NEW ALIAS 'TRB1'
		
		If TRB1->(!EOF()) .AND. !EMPTY(TRB1->TOTAL)
			aAux[6] += TRB1->TOTAL //TRAZ O TOTAL DE HORAS TRABALHADAS DO FUNCIONARIO
		EndIf
		
		dbCloseArea("TRB1") //FECHA A ÁTRA DE TRABALHO TRB1
		
		if(aAux[5] > 0) //-- só adiciona se tiver hora apontada na planta
			aAdd(aMat,aAux)
        endif
        
		ST1->(dbSkip())
	EndDo

Return
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRANSFORMA INTEIRO EM HORA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ItoHora(nHora,nDigitos)
Local nHoras    := 0 
Local nMinutos  := 0 
Local cHora     := ""             
Local lNegativo := .F.

	lNegativo := ( nHora < 0 ) 
	nHora     := ABS( nHora ) 
	nHoras    := Int(nHora)
	nMinutos  := (nHora-nHoras)*60
	nDigitos := If( ValType( nDigitos )=="N", nDigitos, 2 ) - If( lNegativo, 1, 0 ) 
	cHora := If( lNegativo, "-", "" ) + StrZero( nHoras, nDigitos )+":"+StrZero( nMinutos, 2 )

Return(cHora)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REALIZA A IMPRESSAO DO RELATORIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function RptDetail()  
Local _nTotalAp := 0
Local _nTotalMs := 0

	ProcRegua(Len(aMat))
	
	Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    

	aSort(aMat,,,{|x,y|x[2] < y[2]}) //ordena por nome do funcionario
	
	For x:=1 to Len(aMat)
	
		IncProc(aMat[x][1])
		
		If Prow() > 60
			Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)
		Endif  
	
		@ Prow()+1 , 002 Psay aMat[x][1]              //TRA1->T1_CODFUNC
		@ Prow()   , 010 Psay Substr(aMat[x][2],1,35) //TRA1->T1_NOME
		@ Prow()   , 047 Psay ItoHora(aMat[x][5],5)   //ItoHora(TRA1->HORAP,5)
		@ Prow()   , 062 Psay ItoHora(aMat[x][6],5)   //ItoHora(TRA1->TOTAL,5)
	    @ Prow()   , 077 Psay Transform((aMat[x][5]*100)/aMat[x][6],"@e 999.99") + "%" //Transform((TRA1->HORAP*100)/TRA1->TOTAL, "@e 99,99") + " %"    
		@ Prow()   , 089 Psay aMat[x][3]              //TRA1->T1_TURNO
		
		For y:=1 to Len(aMat[x][4])
			@ Prow()+1 , 035 Psay aMat[x][4][y][1]   //SERVICO
			@ Prow()   , 047 Psay ItoHora(aMat[x][4][y][2],5) //Hora por serviço     
		    @ Prow()   , 077 Psay Transform((aMat[x][4][y][2]*100)/aMat[x][6],"@e 999.99") + "%" //Transform((TRA1->HORAP*100)/TRA1->TOTAL, "@e 99,99") + " %"    			
		Next		    

		_nTotalAp += aMat[x][5] //TRA1->HORAP //soma o total de horas apontadas
		_nTotalMs += aMat[x][6] //TRA1->TOTAL //soma o total
		
		@ Prow()+1,000 PSAY ""

	Next
	
	@ Prow()+1,000 PSAY __PrtThinLine()
	@ Prow()+1,046 Psay ItoHora(_nTotalAp,5)
	@ Prow()  ,061 Psay ItoHora(_nTotalMs,5)
	@ Prow()  ,076 Psay Transform((_nTotalAp*100)/_nTotalMs, "@e 999.99") + " %"

Return 

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ GRAFICO ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function fGrafico()
Local cTit      := "HORAS APONTADAS NO PERÍODO "+DtoC(mv_par03)+" - "+DtoC(mv_par04)
Local bOk       := {||oDlgGraf:End()}
Local bCanc     := {||oDlgGraf:End()}
Local bEnchoice := {||EnchoiceBar(oDlgGraf,bOk,bCanc)}
Local nCbx      := 4
Local cCbx      := "Linha"
Local aCbx      := { "Linha","Área","Pontos","Barras","Piramid","Cilindro",;
				"Barras Horizontal","Piramid Horizontal","Cilindro Horizontal",;
				"Pizza","Forma","Linha rápida","Flexas","GANTT","Bolha"}

Private aSize   := MsAdvSize()
//Private aTabela := {}

//	aTabela		:= {{"tit 1", "tit 2",}}

	For x:=1 to Len(aMat)
		For y:=1 to Len(aMat[x][4])
		    aAdd(aMat[x][4][Y],(aMat[x][4][y][2]*100)/aMat[x][6]) //adiciona o percentual por servico no array
		Next
	Next

	aSort(aMat,,,{|x,y|x[2] < y[2]}) //ordena por nome do funcionario

/*
	For nX:=1 To Len(aMat)
		Aadd(aTabela,{	aMat[nX][2],;
			     	    Transform(aMat[nX][3],"@e 99,999,999,999.99")})
	Next
*/

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	oDlgGraf := MsDialog():New(aSize[7],0,aSize[6],aSize[5],cTit,,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	// Layout da janela
	oSay1 := TSay():New(20,5,{||cTit},oDlgGraf,,oFont1,,,,.T.,,)
	
	//group
	oGroup := tGroup():New(30,5,16,(aSize[5]/2)-5,,oDlgGraf,,,.T.)
	
	@ 040,005 LISTBOX oLbx FIELDS HEADER ;
	"Matricula","Nome","Hs Apont.","Hs Trab.","%","Turno";
     SIZE 190,200 OF oDlgGraf PIXEL ON DBLCLICK( fAtuGraf(nCbx))//,oDlg:End())
	
	oLbx:SetArray(aMat)
	oLbx:bLine := {|| {aMat[oLbx:nAt,1],;  // MATRICULA
	                   aMat[oLbx:nAt,2],;  // NOME
	                   aMat[oLbx:nAt,5],;  // HORA AP
	                   aMat[oLbx:nAt,6],;  // HORA TRAB
	                   Transform((aMat[oLbx:nAt,5]*100)/aMat[oLbx:nAt,6],"@e 999.99") +"%",;  // %
	                   aMat[oLbx:nAt,3]}}  // TURNO
	
	oLbx:Refresh()

	oSBox := TScrollBox():New(oDlgGraf,040,200,200, (aSize[5]/2)-205,.T.,.T.,.T.)

	@ 0,0 MSGRAPHIC oGraphic SIZE 300, 200 OF oSBox PIXEL
	
	oGraphic:SetMargins(50,0,0,0)
	
	// Habilita a legenda
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	nSerie  := oGraphic:CreateSerie(nCbx)
	
	If nSerie != GRP_CREATE_ERR
		aEval(aMat[oLbx:nAt,4],{|e| oGraphic:Add(nSerie ,ROUND(e[3],2),Transform(e[1],"@!"),CLR_HGREEN)})
	Else
		IW_MSGBOX("Não foi possível criar a série.","Não foi possível criar a série.","STOP") //"Não foi possível criar a série."
	Endif
	                             
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
//	oGraphic:SetTitle( "MÉDIA: "+cMedia,"", CLR_HBLUE , A_LEFTJUST , GRP_FOOT )
	
	//oGraphic:SetTitle( "", cTit, CLR_GREEN, A_RIGHTJUS , GRP_FOOT  ) //"Datas"
	
	@ 245, (aSize[5]/2)-45  BUTTON "&Salva BMP"      SIZE 40,14 OF oDlgGraf PIXEL ACTION GrafSavBmp( oGraphic ) //"&Salva BMP"
	@ 245, (aSize[5]/2)-90  BUTTON o3D PROMPT "&2D"  SIZE 40,14 OF oDlgGraf PIXEL ACTION f3d2d()
//	@ 245, (aSize[5]/2)-135 BUTTON "Rotação &-"      SIZE 40,14 OF oDlgGraf WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .T. ) // nRotation tem que estar entre 1 e 30 passos //"Rotação &-"
//	@ 245, (aSize[5]/2)-180 BUTTON "Rotação &+"      SIZE 40,14 OF oDlgGraf WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .F. ) // nRotation tem que estar entre 1 e 30 passos //"Rotação &+"
	@ 245, (aSize[5]/2)-135 BUTTON "S&howAxis"       SIZE 40,14 OF oDlgGraf PIXEL ACTION oGraphic:lAxisVisib := !oGraphic:lAxisVisib
	@ 238, (aSize[5]/2)-195 TO 262 ,(aSize[5]/2)-140 LABEL 'Zoom' OF oDlgGraf  PIXEL
	@ 245, (aSize[5]/2)-190 BUTTON "&In"             SIZE 20,14 OF oDlgGraf PIXEL ACTION oGraphic:ZoomIn()
	@ 245, (aSize[5]/2)-165 BUTTON "&Out"            SIZE 20,14 OF oDlgGraf PIXEL ACTION oGraphic:ZoomOut()
	@ 245, (aSize[5]/2)-275 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 075, 120 OF oDlgGraf PIXEL ON CHANGE fAtuGraf(oSer:nAt)
	
	//@ 202, 050 TO 204 ,400 LABEL '' OF oDlgGraf  PIXEL
	
	If !__lPyme
		@ 264, (aSize[5]/2)-45 BUTTON "&Email" SIZE 40,14 OF oDlgGraf PIXEL ACTION PmsGrafMail(oGraphic,"Mat",{cTit},{"",""},1) // E-Mail
	Endif       
	
//	@ 264, (aSize[5]/2)-45 BUTTON "&Sair" SIZE 40,14 OF oDlgGraf PIXEL ACTION oDlgGraf:End() //"&Sair"
	
	oDlgGraf:Activate(,,,.F.,{||.T.},,bEnchoice)

Return    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MUDA O GRÁFICO DE 3D PARA 2D E VICE VERSA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function f3d2d()
      
	oGraphic:l3D := !oGraphic:l3D
	o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D")

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ ATUALIZA O GRAFICO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
Static Function fAtuGraf(nCbx)
    
	oGraphic:End()
	
	@ 0,0 MSGRAPHIC oGraphic SIZE 300, 200 OF oSBox PIXEL
		
	oGraphic:SetMargins(50,0,0,0)
	
	// Habilita a legenda
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	nSerie  := oGraphic:CreateSerie(nCbx)
	
	If nSerie != GRP_CREATE_ERR
		aEval(aMat[oLbx:nAt,4],{|e| oGraphic:Add(nSerie ,ROUND(e[3],2),Transform(e[1],"@!"),CLR_HGREEN)})
	Else
		IW_MSGBOX("Não foi possível criar a série.","Não foi possível criar a série.","STOP") //"Não foi possível criar a série."
	Endif
	                             
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
//	oGraphic:SetTitle( "MÉDIA: "+cMedia,"", CLR_HBLUE , A_LEFTJUST , GRP_FOOT )
	
Return
