
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT047 ºAutor  ³ João Felipe da Rosaº Data ³  21/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE INSUMOS DAS OSs DE DISPOSITIVOS               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS / DISPOSITIVOS                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"

User Function NHMNT047()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZAO"
    oRelato:cPerg    := "MNT047"
	oRelato:cNomePrg := "NHMNT047"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Apresenta os insumos "
	oRelato:cDesc2   := "das Ordens de Serviço de Dispositivos"
	oRelato:cDesc3   := "" 
	
	//tamanho        
//	oRelato:cTamanho := "M"  //default "M"

	//titulo
	oRelato:cTitulo  := "INSUMOS DAS OS'S DE DISPOSITIVOS"

	aAdd(aPergs,{"De Ordem ?"       ,"C", 6,0,"G","" ,"" ,"","","","ZBO",""}) //mv_par01
	aAdd(aPergs,{"Ate Ordem ?"      ,"C", 6,0,"G","" ,"" ,"","","","ZBO",""}) //mv_par02
	aAdd(aPergs,{"De Data ?"        ,"D", 8,0,"G","" ,"" ,"","","",""   ,"99/99/9999"}) //mv_par03
	aAdd(aPergs,{"Ate Data ?"       ,"D", 8,0,"G","" ,"" ,"","","",""   ,"99/99/9999"}) //mv_par04
	aAdd(aPergs,{"De Matricula ?"   ,"C", 6,0,"G","" ,"" ,"","","","QAA",""})   //mv_par05
	aAdd(aPergs,{"Ate Matricula ?"  ,"C", 6,0,"G","" ,"" ,"","","","QAA",""})   //mv_par06
	aAdd(aPergs,{"Tipo ?"           ,"N", 1,0,"C","Produto" ,"MDO" ,"Ambos","","",""   ,"9999"}) //mv_par07
	
	oRelato:AjustaSx1(aPergs)		    

	//cabecalho      
	oRelato:cCabec1  := " ORDEM   MATRICULA        NOME                                   DT INICIO      DT FIM     HORA INI    HORA FIM    TOTAL "
    oRelato:cCabec2  := "          PRODUTO         DESCRIÇÃO                              QUANTIDADE"
		    
	oRelato:Run({||Imprime()})
	

Return

Static Function Imprime()
Local aMat     := {}
Local cDesc    := ""
Local nTotHora := 0

	QAA->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	ZBO->(dbSetOrder(1))//ZBO_FILIAL+ZBO_ORDEM
	ZBP->(dbSetORder(1))//ZBP_FILIAL+ZBP_ORDEM
	
	ZBO->(dbGoTop())
	
	SetRegua(ZBO->(RecCount()))
	
	oRelato:cTitulo  := "INSUMOS DAS OS'S DE DISPOSITIVOS DE "+DtoC(MV_PAR03)+" ATÉ "+DTOC(mv_par04)

	//Percorre todas as Ordens de Serviço de Dispositivos
	WHILE ZBO->(!eof())
	
		IncRegua()
	
		//filtra por ordem
		IF ZBO->ZBO_ORDEM < mv_par01 .OR. ZBO->ZBO_ORDEM > mv_par02
			ZBO->(dbSkip())
			Loop
		EndIf
		
		//filtra por data
		If ZBO->ZBO_DATINI < mv_par03 .OR. ZBO->ZBO_DATINI > mv_par04
			ZBO->(dbSkip())
			Loop
		EndIf
		
		//se nao encontrar insumo pula a ordem
		If !ZBP->(dbSeek(xFilial("ZBP")+ZBO->ZBO_ORDEM))
			ZBO->(dbSkip())
			Loop
		EndIf
		
		//percorre todos os insumos da ordem
		While ZBP->(!EOF()) .AND. ZBP->ZBP_ORDEM==ZBO->ZBO_ORDEM
			
			If mv_par07==1 .and. ZBP->ZBP_TIPO!="P"//só prdutos
				ZBP->(dbSkip())
				Loop
			ElseIf mv_par07==2 .and. ZBP->ZBP_TIPO!="M"//só mao de obra
				ZBP->(dbSkip())
				Loop
			EndIf
            
			If mv_par07==2 .OR. mv_par07==3//só mdo
				//filtra por matricula
				If ZBP->ZBP_CODIGO < mv_par05 .or. ZBP->ZBP_CODIGO > mv_par06
					ZBP->(dbSkip())
					Loop
				EndIf
			EndIf
			
			cDesc:=""
			If(ZBP->ZBP_TIPO=="P")
				If SB1->(dbSeek(xFilial("SB1")+AllTrim(ZBP->ZBP_CODIGO)))
					cDesc := SB1->B1_DESC
				EndIf
			ElseIf ZBP->ZBP_TIPO=="M"
				If QAA->(dbSeek(xFilial("QAA")+AllTrim(ZBP->ZBP_CODIGO)))
					cDesc := QAA->QAA_NOME
				EndIf
			EndIf
			
			aAdd(aMat,{ZBP->ZBP_ORDEM,;
			           ZBP->ZBP_CODIGO+" "+cDesc,;
			           ZBP->ZBP_QUANT,;
			           ZBP->ZBP_DATINI,;
			           ZBP->ZBP_DATFIM,;
			           ZBP->ZBP_HORINI,;
			           ZBP->ZBP_HORFIM,;
			           ZBP->ZBP_TIPO})

			ZBP->(dbSkip()) 
		EndDo
	     
		ZBO->(dbSkip())
	ENDDO
	
	oRelato:Cabec()
	nTotHora := 0
	
	For x:=1 to Len(aMat)
		
		If Prow() > 60
			oRelato:Cabec()
		EndIf
		
		@ Prow()+1 , 001 Psay aMat[x][1] //Ordem
//		cOrdem := aMat[x][1]
		
//		While x<Len(aMat) .and. cOrdem==aMat[x][1]
			@ Prow()   , 010 Psay Substr(aMat[x][2],1,50) //Codigo + Desc
			
			If aMat[x][8]=="P"
				@ Prow()   , 065 Psay aMat[x][3] Picture PesqPict("ZBP","ZBP_QUANT")//quant
			ElseIf aMat[x][8]=="M"
				@ Prow()   , 065 Psay aMat[x][4] // dat ini
				@ Prow()   , 079 Psay aMat[x][5] // dat fim
				@ Prow()   , 093 Psay aMat[x][6] // hor ini
				@ Prow()   , 104 Psay aMat[x][7] // hor fim
				
				cTDif := fTDif(aMat[x][4],aMat[x][5],aMat[x][6],aMat[x][7])
				nTotHora += HoraToInt(cTDif)
				@ Prow()   , 115 Psay cTDif // diferenca do tempo
				
			EndIf

//			x++
//		EndDo
		
		//@Prow() +1,000 psay __PrtThinLine()
		
	Next	
	@Prow() +1,000 psay __PrtThinLine()
	@Prow() +1,001 psay "TOTAL:"
	
	@ Prow()   , 115 Psay IntToHora(nTotHora) // total de horas
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA A DIFERENCA DE TEMPO ENTRE DUAS DATAS E HORAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTDif(dDtIni,dDtFim,cHrIni,cHrFim)

Local nDias  := dDtFim - dDtIni
Local nHoras := HoraToInt(cHrFim) - HoraToInt(cHrIni) + (nDias*24)

Return IntToHora(nHoras)