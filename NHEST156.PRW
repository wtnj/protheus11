
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST156  ºAutor  ³João Felipe da Rosa º Data ³  03/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DE RMA                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ETOQUE / CUSTOS                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHEST156()
Local aPergs := {}
Private oRelato

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SB1"
    oRelato:cPerg    := "EST156"
	oRelato:cNomePrg := "NHEST156"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"

	//descricao
	oRelato:cDesc1   := "Este relatorio apresenta os ítens de retorno de retrabalho"
	oRelato:cDesc2   := "dos clientes."

	//titulo
	oRelato:cTitulo  := "RELAÇÃO DE RETORNO DE MATERIAL (RMA)"

	//cabecalho
	oRelato:cCabec1  := " Número  Data        Código           Descrição                       Quant.   Motivo               Responsável"
		    
	aAdd(aPergs,{"De Produto ?"  ,"C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par01
	aAdd(aPergs,{"Ate Produto?"  ,"C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par02
	aAdd(aPergs,{"De Grupo ?"    ,"C",06,0,"G",""      ,""	     ,"","","","SBM",""}) //mv_par03
	aAdd(aPergs,{"Ate Grupo ?"   ,"C",06,0,"G",""      ,""       ,"","","","SBM",""}) //mv_par04
	aAdd(aPergs,{"De Cliente ?"  ,"C",06,0,"G",""      ,""	     ,"","","","SA1",""}) //mv_par05
	aAdd(aPergs,{"Ate Cliente ?" ,"C",06,0,"G",""      ,""       ,"","","","SA1",""}) //mv_par06
	aAdd(aPergs,{"De Loja ?"     ,"C",02,0,"G",""      ,""	     ,"","","","",""}) //mv_par07
	aAdd(aPergs,{"Ate Loja ?"    ,"C",02,0,"G",""      ,""       ,"","","","",""}) //mv_par08
	aAdd(aPergs,{"De Data ?"     ,"D",08,0,"G",""      ,""	     ,"","","","","99/99/9999"}) //mv_par09
	aAdd(aPergs,{"Ate Data ?"    ,"D",08,0,"G",""      ,""       ,"","","","","99/99/9999"}) //mv_par10
	aAdd(aPergs,{"Refugo ?"      ,"N",01,0,"C","Usinagem" ,"Fundido"  ,"Ambos","","","",""}) //mv_par11

	oRelato:AjustaSx1(aPergs)
	
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cCliLoj := ""
Local aTot    := {0,0}

	Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

	oRelato:Cabec()

	While TRA1->(!EoF())
	
		If cCliLoj!= TRA1->ZAH_CLIE+TRA1->ZAH_LOJA

			@Prow() + Iif(cCliLoj=="",1,2), 001 psay "Cliente: "+TRA1->ZAH_CLIE+" - "+TRA1->ZAH_LOJA+" - "+Substr(TRA1->A1_NOME,1,30)
			@Prow()+1 , 000 psay ""
			
			cCliLoj := TRA1->ZAH_CLIE+TRA1->ZAH_LOJA			
			
		EndIf
		
		//usinado
		While TRA1->(!EOF()) .AND. TRA1->ZAH_TDEV==1
		
			@Prow()+1, 001 psay TRA1->ZAH_NUM
			@Prow()  , 009 psay DtoC(TRA1->ZAH_DATA)
			@Prow()  , 021 psay TRA1->ZAI_PROD+Space(2)+Substr(TRA1->B1_DESC,1,20)
			@Prow()  , 066 psay TRA1->ZAI_QUANT Picture "@e 999,999.99"
			@Prow()  , 079 psay Iif(TRA1->ZAH_TDEV==1,"Ref. Usinagem",Iif(TRA1->ZAH_TDEV==2,"Ref. Fundido",""))
			@Prow()  , 100 psay Substr(TRA1->QAA_NOME,1,25)
			     
			aTot[1] += TRA1->ZAI_QUANT
			
			TRA1->(DbSkip())
		
		EndDo
		
		@Prow()+2 , 039 psay "TOTAL REFUGO USINAGEM: "+ Transform(aTot[1],"@e 999,999,999.99")
		@Prow()+1 , 000 psay ""
				
		//fundido
		While TRA1->(!EOF()) .AND. TRA1->ZAH_TDEV==2
		
			@Prow()+1, 001 psay TRA1->ZAH_NUM
			@Prow()  , 009 psay DtoC(TRA1->ZAH_DATA)
			@Prow()  , 021 psay TRA1->ZAI_PROD+Space(2)+Substr(TRA1->B1_DESC,1,20)
			@Prow()  , 066 psay TRA1->ZAI_QUANT Picture "@e 999,999.99"
			@Prow()  , 079 psay Iif(TRA1->ZAH_TDEV==1,"Ref. Usinagem",Iif(TRA1->ZAH_TDEV==2,"Ref. Fundido",""))
			@Prow()  , 100 psay Substr(TRA1->QAA_NOME,1,25)
			     
			aTot[2] += TRA1->ZAI_QUANT
			
			TRA1->(DbSkip())
		
		EndDo
		
		@Prow()+2 , 040 psay "TOTAL REFUGO FUNDIDO: "+ Transform(aTot[2],"@e 999,999,999.99")
		
	EndDo

	TRA1->(dbCloseArea())
		
Return(nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS PARA A IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery

	cQuery := " SELECT ZAH.ZAH_NUM, ZAH.ZAH_DATA, ZAH.ZAH_CLIE, ZAH.ZAH_LOJA, ZAH.ZAH_TDEV,  "
	cQuery += " A1.A1_NOME, ZAI.ZAI_PROD, B1.B1_DESC, ZAI.ZAI_QUANT, ZAI.ZAI_VOLUME, ZAH.ZAH_RESP, QAA.QAA_NOME "
	cQuery += " FROM "+RetSqlName("ZAH")+" ZAH, "+RetSqlName("ZAI")+" ZAI, "+RetSqlName("SA1")+" A1, "
	cQuery += RetSqlName("SB1")+" B1,  "+RetSqlName("QAA")+" QAA "
	cQuery += " WHERE ZAH.ZAH_NUM = ZAI.ZAI_NUM "
	cQuery += " AND ZAI.ZAI_PROD = B1.B1_COD "
	cQuery += " AND ZAH.ZAH_CLIE = A1.A1_COD "
	cQuery += " AND ZAH.ZAH_LOJA = A1.A1_LOJA "
	cQuery += " AND ZAH.ZAH_RESP = QAA.QAA_MAT " 
	cQuery += " AND ZAH.ZAH_TDEV IN (1,2) "
	cQuery += " AND ZAI.ZAI_PROD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND ZAH.ZAH_CLIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"	
	cQuery += " AND ZAH.ZAH_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"	
	cQuery += " AND ZAH.ZAH_DATA BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"	
	
	If mv_par11==1 //usinagem
		cQuery += " AND ZAH.ZAH_TDEV = '1'"
	ElseIf mv_par11==2 //fundido
		cQuery += " AND ZAH.ZAH_TDEV = '2'"
	EndIf
			
	cQuery += " AND ZAH.ZAH_FILIAL = '"+xFilial("ZAH")+"' AND ZAH.D_E_L_E_T_ = ''" 
	cQuery += " AND QAA.QAA_FILIAL = '"+xFilial("QAA")+"' AND QAA.D_E_L_E_T_ = ''" 
	cQuery += " AND ZAI.ZAI_FILIAL = '"+xFilial("ZAI")+"' AND ZAI.D_E_L_E_T_ = ''" 
	cQuery += " AND A1.A1_FILIAL = '"+xFilial("SA1")+"' AND A1.D_E_L_E_T_ = ''" 
	cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''" 			
	cQuery += " ORDER BY ZAH.ZAH_CLIE, ZAH.ZAH_LOJA, ZAH.ZAH_TDEV, ZAH.ZAH_DATA"
	
	//MemoWrit('C:\TEMP\NHEST156.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1" //cria variavel para armazenar valor da query 
	
	TCSETFIELD("TRA1","ZAH_DATA","D")
	
	TRA1->(DbGotop()) //Manda o "ponteiro" de leitura da query para o TOPO    
	
Return