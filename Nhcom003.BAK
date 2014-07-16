/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM003        ³ Sergio L Tambosi      ³ Data ³ 23.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Solicitação de Compras Detalhada             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// função elaborada com base no programa MATR140 (Sol.Compra original da Microsiga)

#include "rwmake.ch"
#INCLUDE "topconn.ch"   

//#Include "MATR140.CH"

User Function Nhcom003()

SetPrvt("WNREL,NCOL,CDESC1,CDESC2,CDESC3,LAUTO")
SetPrvt("TITULO,ARETURN,ALINHA,TAMANHO,NOMEPROG,NLASTKEY")
SetPrvt("CSTRING,M_PAG,LI,CPERG,ATAMSXG,ATAMSXG2,LAPR")
SetPrvt("CABEC1,CABEC2,CABEC3,CBCONT,AMESES,AORDEM")
SetPrvt("CALIASSC1,CARQIND,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04")
SetPrvt("MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR09,MV_PAR13,CQUERY,CQUERY1")
SetPrvt("CGRUPO,CDESCRI,MV_PAR08,I,CMESES,NANO,_cDescStatus,_cDescFuncao")
SetPrvt("NMES,J,CMES,CCAMPOS,NPOSLOJA,NCONTADOR,cFilterUser,nTotGer")
SetPrvt("NTAMNOME,NPOSNOME,NREG,MAXL,nRegSC1,uSolicit,uCodFor,uContato,uFone, uNomFor, cGeneric,_cFerUso")

// MAXL = número máximo de linhas por página
// Define Variaveis                                             
PRIVATE wnrel	:= "NHCOM003"
PRIVATE nCol	:= 0
PRIVATE cDesc1	:= "Emissao das Solicitacoes de Compras Cadastradas"
PRIVATE cDesc2	:= ""
PRIVATE cDesc3	:= ""
PRIVATE aTamSXG,aTamSXG2, nPosLoja, nPosNome, nTamNome
PRIVATE Titulo	:= "SOLICITAÇÃO DE COMPRA DETALHADA"
PRIVATE aReturn := {"Zebrado",10,"Administracao",2,2,1,"",0}
PRIVATE aLinha	:= {}
PRIVATE Tamanho	:= "G"
PRIVATE nomeprog:= "NHCOM003"
PRIVATE nLastKey:= 0
PRIVATE cString	:= "SC1"
PRIVATE M_PAG   := 1
PRIVATE li      := 99
//PRIVATE cPerg := "NHCOM003"
PRIVATE cPerg   := "COM003"
PRIVATE cCusto  := ""
nRegSC1         := 0
PRIVATE lApr    := .F.
nTotGer         := 0

// Verifica as perguntas selecionadas                           
pergunte(cperg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Do Numero                                        ³
//³ mv_par02    Ate o Numero                                     ³
//³ mv_par03    Todas ou em Aberto                               ³
//³ mv_par04    A Partir da data de emissao                      ³
//³ mv_par05    Ate a data de emissao                            ³
//³ mv_par06    Do Item                                          ³
//³ mv_par07    Ate o Item                                       ³
//³ mv_par08    Campo Descricao do Produto.                      ³
//³ mv_par09    Imprime Empenhos ?                               ³
//³ mv_par10    Utiliza Amarracao ?  Produto   Grupo             ³
//³ mv_par11    Imprime Qtos Pedido Compra?                      ³
//³ mv_par12    Imprime Qtos Fornecedores?                       ³
//³ mv_par13    Impr. SC's Firmes, Previstas ou Ambas            ³
//³ mv_par14    Aprovacao ?                                      ³
//³ mv_par15    Total ?                                          ³
//³ mv_par16    Histórico de Compra ? (S/N)                      ³
//³ mv_par17    DE PRODUTO ?                                     ³
//³ mv_par18    ATE PRODUTO ?                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Verif. conteudo das variaveis Grupo Forn. (001) e Loja (002) 
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

cFilterUser := Alltrim(aReturn[7])
For x:= 1 to len (cFilterUser)

   If AT(".",cFilterUser) > 0
      cFilterUser := Stuff(cFilterUser,AT(".",cFilterUser),1," ") //elimina o ponto
   Elseif AT("$",cFilterUser) > 0
      cFilterUser := Stuff(cFilterUser,AT('"',cFilterUser),1,"") //elimina primeira ASPAS   
      cFilterUser := Stuff(cFilterUser,AT('"',cFilterUser),1,"") //elimina segunda ASPAS   
      cFilterUser := Subs(cFilterUser,AT("$",cFilterUser)+1,11)+ " LIKE '"+;
                     alltrim(Subs(cFilterUser,1,AT("$",cFilterUser)+1))+"'" 
      cFilterUser := Stuff(cFilterUser,AT("$",cFilterUser),1,"") //elimina o $                                  
   Elseif AT("=",cFilterUser) > 0                              
      If Subs(cFilterUser,AT("=",cFilterUser)+1,1) == "="
         cFilterUser := Stuff(cFilterUser,AT("=",cFilterUser),1," ") //elimina o ponto   
         cFilterUser := Stuff(cFilterUser,AT('"',cFilterUser),1,"'") //elimina primeira ASPAS            
         cFilterUser := Stuff(cFilterUser,AT('"',cFilterUser),1,"'") //elimina segunda ASPAS                     
      Endif
   Else   
      exit
   Endif   
   
Next x   

Processa({||Gera_Rel()},"Gerando Dados para a Impressao")

Return

//programa baseado no nhcom003 - Microsiga

Static Function Gera_Rel()

LOCAL cGrupo
LOCAL nContador
LOCAL j
LOCAL Cabec1	 := ""
LOCAL Cabec2	 := ""
LOCAL Cabec3	 := ""
LOCAL cbCont	 := 0
LOCAL aMeses	 := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
LOCAL aOrdem 	 := {},cMeses,nAno,nMes,cMes,cCampos,cDescri,i
LOCAL cAliasSC1  := "SC1"
LOCAL cArqInd	 := ""          
LOCAL uCont      := 1
Local _cObs      := Space(255)
Local _cProduto 
Local _lArova    := .F.

SZU->(DbSetOrder(2))

//Query para SQL                 
cQuery := "SELECT * "
cQuery += "FROM "	    + RetSqlName( 'SC1' ) 
cQuery += " WHERE "
cQuery += "C1_FILIAL='" + xFilial( 'SC1' )    	+ "' AND "
cQuery += "C1_NUM>='"   + MV_PAR01           	+ "' AND "
cQuery += "C1_NUM<='"   + MV_PAR02          	+ "' AND "
cQuery += "C1_EMISSAO>='"  + DTOS(MV_PAR04)   	+ "' AND "
cQuery += "C1_EMISSAO<='"  + DTOS(MV_PAR05)   	+ "' AND "
cQuery += "C1_ITEM>='"  + MV_PAR06          	+ "' AND "
cQuery += "C1_ITEM<='"  + MV_PAR07            	+ "' AND "
cQuery += "C1_PRODUTO BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"' AND "

If !Empty(cFilterUser)
    cQuery += cFilterUser + " AND "
Endif    
// todas as solicitações ou apenas em aberto
If mv_par03 == 2
	cQuery += "C1_QUANT<>C1_QUJE  AND "
EndIf
cQuery += "D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY " + SqlOrder(SC1->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'QRYSC1', .F., .T.)
aEval(SC1->(dbStruct()),{|x| If(x[2]!="C",TcSetField("QRYSC1",AllTrim(x[1]),x[2],x[3],x[4]),Nil)})

titulo := fMakeTit(QRYSC1->C1_ORCSOL,QRYSC1->C1_NUM)

uSolicit := QRYSC1->C1_SOLICIT

cabec(titulo,cabec1,,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
_cNumSC := QRYSC1->C1_NUM

While QRYSC1->(!EOF())	.And. QRYSC1->C1_FILIAL==xFilial("SC1");
	.And. QRYSC1->C1_NUM >= mv_par01 ;
	.And. QRYSC1->C1_NUM <= mv_par02

	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	// Filtra a data de emissao e os itens a serem impressos        
	If QRYSC1->C1_EMISSAO < mv_par04 .Or. QRYSC1->C1_EMISSAO > mv_par05
		dbSkip()
		Loop
	EndIf
   // Filtra Tipo de OPs Firmes ou Previstas                       
	If !MtrAValOP(mv_par13, 'SC1')
		dbSkip()
		Loop
	EndIf
	
	If QRYSC1->C1_ITEM < mv_par06 .Or. QRYSC1->C1_ITEM > mv_par07                       
		dbSkip()
		Loop
	EndIf

	/* -- comentado por João Felipe 20/04/2012
	If mv_par14 == 1
		// Pesquisa aprovacoes
		SZU->(DbSeek(xFilial("SZU")+QRYSC1->C1_NUM+QRYSC1->C1_ITEM))
		If SZU->(Found())
			While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == QRYSC1->C1_NUM+QRYSC1->C1_ITEM
	
				If SZU->ZU_STATUS == "A" //Aprovado
				Elseif SZU->ZU_STATUS == "B" // Aguardando
				Elseif SZU->ZU_STATUS == "C" // Rejeitado
				Endif	

				SZU->(DbSkip())
			Enddo
		Endif
	Endif
    */
    
	If li > 50 	.Or. QRYSC1->C1_NUM <> _cNumSC
		titulo := fMakeTit(QRYSC1->C1_ORCSOL,QRYSC1->C1_NUM)
		cabec(titulo,cabec1,,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		_cNumSC := QRYSC1->C1_NUM
	EndIf

	// Posiciona os arquivos no registro a ser impresso             
	cDescri := " "	
	dbSelectArea("SB1")
	dbSeek(xFilial()+QRYSC1->C1_PRODUTO)

	cGrupo   := SB1->B1_GRUPO
	cDescri  := SB1->B1_DESC
	cGeneric := SB1->B1_GENERIC
                                                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA APROVAÇÃO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
    lBloqAprv := .F.
	SZU->(DbSeek(xFilial("SZU")+QRYSC1->C1_NUM+QRYSC1->C1_ITEM))

	If SZU->(Found())
		
		While SZU->(!EOF()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM==QRYSC1->C1_NUM+QRYSC1->C1_ITEM

			//-- NIVEL 9 = NIVEL DE COMPRADOR, NAO BLOQUEIA PARA IMPRESSAO
			If SZU->ZU_STATUS == " " .AND. SZU->ZU_NIVEL < '9' .AND. SZU->ZU_ORIGEM == "SC1"
				
				aNomeado := U_SZVNomeado(SZU->ZU_LOGIN)
				cNomeado := ''
				For xN:=1 to len(aNomeado)
					cNomeado += aNomeado[xN]
					If (xN)<len(aNomeado)
						cNomeado+=','
					Endif
				Next
				
				li++                     
			    @ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+" *** FALTA APROVACAO - Aprovador: " + Alltrim(SZU->ZU_LOGIN) + (Iif(!empty(cNomeado),' (ou Nomeado(s): '+cNomeado+')',''))+" ***"
				li++
				@ li,000 PSAY "" //-- pula linha
	   		    lBloqAprv := .T.
			ElseIf SZU->ZU_STATUS$"C/B" 
				@ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+" CANCELADO PELO APROVADOR "+ALLTRIM(SZU->ZU_LOGIN)+" *** "
				li++
				@ li,000 PSAY "" //-- pula linha
				lBloqAprv := .T.
			Endif
		
			SZU->(dbskip())
		Enddo
		
 	Endif
 	
 	//-- se o item não tiver aprovação de todos, não permite impressão
 	If lBloqAprv
	    QRYSC1->(dbSkip())
		Loop
	Endif
 	
    /*
    
	If Substr(QRYSC1->C1_CONTA,1,5) == '10302' .or. Substr(SB1->B1_GRUPO,1,2) == 'IM'
		SZU->(DbSeek(xFilial("SZU")+QRYSC1->C1_NUM+QRYSC1->C1_ITEM))
		If !SZU->(Found())
			li++
			If SM0->M0_CODIGO$"FN/NH"			
			   @ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+"  *** FALTA APROVACAO - Aprovador: Tadeu Marcante    Ramal: 1341 - e-mail: tadeum@whbbrasil.com.br'
			else
			   @ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+"  *** FALTA APROVACAO - Aprovador: Hilderley Lopes de Oliveira  Ramal: 8521 - e-mail: hilderley@whbbrasil.com.br'			
			Endif   
			li++
			@ li,000 PSAY "" //-- pula linha
			QRYSC1->(dbSkip())
			Loop
		Else
			If SZU->ZU_STATUS == " " 
				li++     
				If SM0->M0_CODIGO$"FN/NH"
				   @ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+" *** FALTA APROVACAO - Aprovador: " + Alltrim(SZU->ZU_LOGIN) + ' Ramal: 1341 - e-mail: tadeum@whbbrasil.com.br'
				Else
				   @ li,000 PSAY " *** Item: "+QRYSC1->C1_ITEM+" *** FALTA APROVACAO - Aprovador: " + Alltrim(SZU->ZU_LOGIN) + ' Ramal: 8521 - e-mail: hilderley@whbbrasil.com.br'				
				Endif   
				li++
				@ li,000 PSAY "" //-- pula linha
				QRYSC1->(dbSkip())
				Loop
			ElseIf SZU->ZU_STATUS$"C/B" 
			
   			    QRYSC1->(dbSkip())
				Loop
			Endif	
 		Endif
    Endif     
    */
    
	If SM0->M0_CODIGO == 'FN'
		If QRYSC1->C1_EMISSAO >= Ctod('02/08/2011')

			If substr(QRYSC1->C1_CC,1,2) $ '33/34/AL'
			
				If substr(QRYSC1->C1_CC,1,2) == 'AL' .AND. substr(QRYSC1->C1_LOCAL,1,1) <> '3'
					li++
					lAprova := .f.
				Else
    
					IF Substr(QRYSC1->C1_PRODUTO,1,4) $ 'ME01/ME31/ME32/MK01/ML01/ML52/MM15/MS01/MS02/MS03/MS04/MS32/MS52/PQ01/PQ31/PQ50/'+;
											     'SA03/SA04/SA12/SA13/SA16/SA18/SA21/SA22/SA27/SA28/SA33/SA35/SA38/SA40/SA41/SA45/SA48/SA50' .and. EMPTY(QRYSC1->C1_NUMOS)

						SZU->(DbSeek(xFilial("SZU")+QRYSC1->C1_NUM+QRYSC1->C1_ITEM))
						//If !SZU->(Found())
						//	li++
						//	@ li,000 PSAY " *** FALTA APROVACAO - Aprovador: Reinaldo ou Valmir     Ramal: 1970 ou 1378 - e-mail: reinaldo@whbbrasil.com.br'
						//	li++
						//	QRYSC1->(dbSkip())
						//	Loop
						//Else
						If SZU->(FOUND())
							If SZU->ZU_STATUS == " "
								li++
								@ li,000 PSAY " *** FALTA APROVACAO - Aprovador: " + Alltrim(SZU->ZU_LOGIN) + ' Ramal: 1970 ou 1378 - e-mail: reinaldo@whbbrasil.com.br'
								li++
								QRYSC1->(dbSkip())
								Loop
							ElseIf SZU->ZU_STATUS$"C/B" 
			   				    QRYSC1->(dbSkip())
								Loop
							Endif	
						Endif
					Endif	
				Endif	
			Endif
		Endif	
    Endif

	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial()+QRYSC1->C1_PRODUTO) 
	if !EMPTY(A5_FORNECE)
		uCodFor:= A5_FORNECE
		uNomFor:= A5_NOMEFOR
		dbSelectArea("SA2")
		dbSeek(xFilial() + uCodFor)
		uContato:= A2_CONTATO
		uFone := A2_TEL
	else
		uCodFor  := "Sem Cadastro Produto/Fornecedor"		
		uContato := ""
		uFone    := "" 
		uNomFor  := Space(40)
	endif                                         
	
	dbSelectArea("SB2")
	dbSeek(xFilial()+QRYSC1->C1_PRODUTO+QRYSC1->C1_LOCAL)
	
	dbSelectArea("SB3")
	dbSeek(xFilial()+QRYSC1->C1_PRODUTO)
	
	dbSelectArea("SD4")
	dbSeek(xFilial()+QRYSC1->C1_PRODUTO)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+QRYSC1->C1_NUM+QRYSC1->C1_ITEM)

	dbSelectArea("SB5")
	dbSeek( xFilial()+QRYSC1->C1_PRODUTO ) 
	//concatena a descrisão SB1 com o complemento de produto SB5
	cDescri := cDescri + " " + SB5->B5_CEME
	
	// busca nome do centro de custo
	cCusto := " "
	dbSelectArea("CTT")
	dbSeek( xFilial()+QRYSC1->C1_CC )
	cCusto := " "+CTT->CTT_DESC01	

    //Mostra onde a ferramenta é utilizada	
    _cFerUso := " "
	dbSelectArea("ZDJ")
	dbSetOrder(2)	
	dbSeek( xFilial()+QRYSC1->C1_PRODUTO+QRYSC1->C1_CCU )
	If ZDJ->(Found())
	
	   //Busca a descricao do Centro de custo onde a ferramenta é usada
	   dbSelectArea("CTT")
	   dbSeek( xFilial()+QRYSC1->C1_CCU )

	   While ZDJ->(!Eof()) .And. QRYSC1->C1_PRODUTO+QRYSC1->C1_CCU == ZDJ->ZDJ_FERRAM+ZDJ->ZDJ_CC
	       
	      If Empty(_cFerUso)
	         _cFerUso := "Uso no CC: " + Alltrim(ZDJ->ZDJ_CC) + "-" +Alltrim(CTT->CTT_DESC01) + "  Op. "+ZDJ->ZDJ_OP 
	      Else
	         _cFerUso += ", "+ZDJ->ZDJ_OP 	      
	      Endif   
	      ZDJ->(Dbskip())
	   Enddo 
	
	Endif
	
	//seleciona a descricao conforme a necessidade do usuário (mv_par08)
	if mv_par08 = 'C1_DESCRI'
	   cDescri:= QRYSC1->C1_DESCRI
	endif   
	
	Impressao(cDescri)
	
    //-- Impressao das observacoes da solicitacao (caso exista)       
	li++
	@ li,000 PSAY "Observações:"
	
    _cObs := Alltrim(QRYSC1->C1_OBS)+" "+ _cFerUso 	
	If !Empty(QRYSC1->C1_FORNECE) .And. !Empty(QRYSC1->C1_LOJA)
	   SA2->(dbSeek(xFilial()+QRYSC1->C1_FORNECE+QRYSC1->C1_LOJA))
	   _cObs += " Comprar do Forncedor :"+SA2->A2_COD+"-"+SA2->A2_LOJA+" "+Alltrim(SA2->A2_NOME) 
	Endif

    For i:=1 To MlCount(_cObs,206)
    	IF !EMPTY(MemoLine(_cObs,206,i))
         	@ li,014 PSAY MemoLine(_cObs,206,i)   Picture "@!"
         	li++
        ENDIF
    Next

	If mv_par16==1 // historico de compra = sim
		//-- Impressao dos Consumos nos ultimos 12 meses                  
		@ li,000 PSAY REPLICATE("-",220)
		li++
		@ li,000 PSAY "Consumo últimos 12 meses: "

		cMeses := ""
		nAno := YEAR(dDataBase)
		nMes := MONTH(dDataBase)
		aOrdem := {}
		
		For j := nMes To 1 Step -1
			cMeses += aMeses[j]+"/"+Substr(Str(nAno,4),3,2)+Space(4)
			AADD(aOrdem,j)
		Next j
		nAno--
		For j := 12 To nMes+1 Step -1
			cMeses += aMeses[j]+"/"+Substr(Str(nAno,4),3,2)+Space(4)
			AADD(aOrdem,j)
		Next j
		li++
		@ li,035 PSAY Trim(cMeses)+"    Media C"
		li++
		nCol := 32
		
		cMesF := StrZero(aOrdem[len(aOrdem)],2)
		
		_dDtFim := date()
		_dDtIni := date()-356
		
		cQuery := " SELECT SUBSTRING(D3_EMISSAO,1,6) MESANO, SUM(D3_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("SD3")+" D3"
		cQuery += " WHERE D3_COD = '"+QRYSC1->C1_PRODUTO+"'"
		cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(_dDtIni)+"' AND '"+DtoS(_dDtFim)+"'"
		cQuery += " AND D3_TM >= '501'"
		cQuery += " AND D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"'"
		cQuery += " GROUP BY SUBSTRING(D3_EMISSAO,1,6)"
		cQuery += " ORDER BY SUBSTRING(D3_EMISSAO,1,6) DESC"
		
		If Select("TRA1") > 0
			TRA1->(dbclosearea())
		Endif
		
		TCQUERY cQuery NEW ALIAS "TRA1"
		
		TRA1->(DbGoTop())
		
		nSoma  := 0
		nValor := 0
		aMat   := {}
		
		//alimenta a matriz aMAt com o mes/ano e a quantidade consumida do produto
		While TRA1->(!EOF())
			aAdd(aMat,{TRA1->MESANO, TRA1->QUANT})
			TRA1->(dbSkip())
		EndDo
		
		TRA1->(dbCloseArea())
		
		If Empty(aMat)
			li++
			@ li,000 PSAY "Nao existe registro de consumo anterior deste item."
			li++
		Else
			For j := 1 To Len(aOrdem)
				
				_n := aScan(aMat,{|x| Substr(x[1],5,2)==ALLTRIM(StrZero(aOrdem[j],2))})
				
				If _n!=0
					nValor := aMat[_n][2]
				Else
					nValor := 0
				EndIf
				
				@ li,nCol PSAY  nValor  PicTure  PesqPict("SB3","B3_Q01",9) //"@E 99,999,99"
				nCol += 10
				
				nSoma += nValor
			Next j
			
			@ li,154 PSAY (nSoma/12) PicTure  PesqPict("SB3","B3_MEDIA",8) //"@E 9,999,99"
			li++
		EndIf
		
		//So roda quando for ferramenta, busca o historico de consumo da Usinagem
		
		If SM0->M0_CODIGO == "FN" .And. Substr(QRYSC1->C1_PRODUTO,1,4)$"FE31/FE32/FE33/FE34/FE35/FE36"
		                                                           
		   li++
		   @ li,035 PSAY Trim(cMeses)+"    Media C  - Usinagem"
		   li++
		   nCol := 32
		
		   cMesF := StrZero(aOrdem[len(aOrdem)],2)
		
		   _dDtFim := date()
		   _dDtIni := date()-356         
		                                                   
		   _cProduto := 'FE0'+Substr(QRYSC1->C1_PRODUTO,4,12)
		   
		   cQuery := " SELECT SUBSTRING(D3_EMISSAO,1,6) MESANO, SUM(D3_QUANT) AS QUANT "
		   cQuery += " FROM SD3NH0 D3"  
		   cQuery += " WHERE D3_COD = '"+_cProduto+"'"
		   cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(_dDtIni)+"' AND '"+DtoS(_dDtFim)+"'"
		   cQuery += " AND D3_TM >= '501'"
		   cQuery += " AND D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"'"
		   cQuery += " GROUP BY SUBSTRING(D3_EMISSAO,1,6)"
		   cQuery += " ORDER BY SUBSTRING(D3_EMISSAO,1,6) DESC"
		
		   TCQUERY cQuery NEW ALIAS "TRA1"
		
		   TRA1->(DbGoTop())
		
		   nSoma  := 0
		   nValor := 0
		   aMat   := {}
		
		   //alimenta a matriz aMAt com o mes/ano e a quantidade consumida do produto
		   While TRA1->(!EOF())
		      aAdd(aMat,{TRA1->MESANO, TRA1->QUANT})
			  TRA1->(dbSkip())
		   EndDo
		
		   TRA1->(dbCloseArea())
		
		   If Empty(aMat)
		      li++
			  @ li,000 PSAY "Nao existe registro de consumo anterior deste item."
			  li++
		   Else
		      For j := 1 To Len(aOrdem)
				
			     _n := aScan(aMat,{|x| Substr(x[1],5,2)==ALLTRIM(StrZero(aOrdem[j],2))})
				
				 If _n!=0
					nValor := aMat[_n][2]
				 Else
					nValor := 0
				 EndIf
				
				 @ li,nCol PSAY  nValor  PicTure  PesqPict("SB3","B3_Q01",9) //"@E 99,999,99"
				 nCol += 10
				
				 nSoma += nValor
			  Next j
			
			  @ li,154 PSAY (nSoma/12) PicTure  PesqPict("SB3","B3_MEDIA",8) //"@E 9,999,99"
		 	  li++
		   EndIf
		  
		Endif
		
		///////////////////////////////////////////////////////////////////		
		// Rotina para imprimir dados dos ultimos pedidos               
		if mv_par11 <> 1
		   mv_par11 := 1	
		endif   
		
		@ li,000 PSAY REPLICATE("-",220)
		li++
        
		If SELECT ("TMPE") > 0
			TMPE->(dbclosearea())
		Endif

		cQuery := "SELECT TOP 1 * FROM " + RetSqlName( 'SD1' ) +" SD1 (NOLOCK) "
		cQuery += "inner join "+ RetSqlName( 'SF4' ) +" SF4 (NOLOCK) "
		cQuery += "on SF4.F4_CODIGO   = SD1.D1_TES "
		cQuery += "and SF4.F4_DUPLIC = 'S' "
		cQuery += "and SF4.D_E_L_E_T_ = ' ' "
		cQuery += "where "
		cQuery += " SD1.D1_COD = '" + SB1->B1_COD + "' "
		cQuery += "     and SD1.D1_DTDIGIT <='"+dtos(DDATABASE)+"'"
		cQuery += "     and SD1.D1_ORIGLAN != 'LF' "
		cQuery += "     and SD1.D1_QUANT   != 0 "
		cQuery += "     and SD1.D1_REMITO   = '         ' "
		cQuery += "     and SD1.D_E_L_E_T_  = ' ' "
		cQuery += "     and SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
		cQuery += "     order by SD1.D1_DTDIGIT DESC,D1_NUMSEQ DESC"

		TCQUERY cQuery NEW ALIAS "TMPE"
	                    
		//-- verifica se existe ultima nf
		lUltNF := .T.
		
		If TMPE->(EOF())    
			lUltNF := .F.
		ENDIF
	
		//-- verifica se existe ultimo pedido
		lUltPC := .t.
		
		SC7->(dbSetOrder(4))
		Set SoftSeek On
		SC7->(dbSeek(xFilial()+QRYSC1->C1_PRODUTO+"z"))
		Set SoftSeek Off
		SC7->(dbSkip(-1))
		
		If xFilial('SC7')+QRYSC1->C1_PRODUTO != SC7->C7_FILIAL+SC7->C7_PRODUTO
			lUltPC := .f.
			//@ li,000 PSAY "Nao existem pedidos cadastrados para este item."
			//li+=2
		Endif
		
		@ li,000 PSAY "Última NF : "+Iif(lUltNF,TMPE->D1_DOC+'-'+TMPE->D1_SERIE+' Fornece: '+TMPE->D1_FORNECE+'/'+TMPE->D1_LOJA+'-'+Posicione("SA2",1,xFilial('SA2')+TMPE->D1_FORNECE+TMPE->D1_LOJA,"A2_NOME"),"")
		@ li,089 psay "Último Pedido : "+Iif(lUltPC,SC7->C7_NUM+' Fornece: '+SC7->C7_FORNECE+'/'+SC7->C7_LOJA+'-'+Posicione("SA2",1,xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"),"")

		li++

		if !lUltNF		
			@ li,000 PSAY "Nao existem entradas de NF para este item."
		eLSE
			nPosLoja := 52
			If aTamSXG[3]!= aTamSXG[1]
				nPosLoja += aTamSXG[4] - aTamSXG[3]
			Endif
			
			If aTamSXG[1] != aTamSXG[3]
				@ li,001 PSAY "It         Qtde  Vlr.Unitario   Vlr.Total    Emissao"
			Else
				@ li,001 PSAY "It         Qtde  Vlr.Unitario   Vlr.Total    Emissao"
			Endif
		eNDIF
		

		if !lUltPC
			@ li,110 PSAY "Nao existem pedidos cadastrados para este item."
		else
			nPosLoja := 52
			If aTamSXG[3]!= aTamSXG[1]
				nPosLoja += aTamSXG[4] - aTamSXG[3]
			Endif
			
			If aTamSXG[1] != aTamSXG[3]
				@ li,90 PSAY "It          Qtde Vlr.Unitario  Valor Total  Emissao     Neces.    Prz Cond Qtde Entr.      Saldo     Situação"
			Else
				@ li,90 PSAY "It          Qtde Vlr.Unitario  Valor Total  Emissao     Neces.    Prz Cond Qtde Entr.      Saldo     Situação"
			Endif
		
		ENDIF
		
		li++

		If lUltNF		
			@ li,001 PSAY TMPE->D1_ITEM
			@ li,006 PSAY TMPE->D1_QUANT  Picture PesqPict("SD1","D1_QUANT",10)
			@ li,018 PSAY TMPE->D1_VUNIT  Picture Right(PesqPict("SD1","D1_VUNIT"),12)
			@ li,030 PSAY TMPE->D1_TOTAL  Picture Right(PesqPict("SD1","D1_TOTAL"),12)
			@ li,044 PSAY STOD(TMPE->D1_EMISSAO)
                                                    
		EndIf
		
		TMPE->(dbclosearea())
		
		IF lUltPC

			nContador := 0
			While SC7->(!BOF()) .And. xFilial('SC7')+QRYSC1->C1_PRODUTO == SC7->C7_FILIAL+SC7->C7_PRODUTO 
				nContador++            
				If nContador > 1
					Exit
				EndIf
				@ li,90 PSAY SC7->C7_ITEM
				@ li,96 PSAY SC7->C7_QUANT  Picture PesqPict("SC7","C7_QUANT",10)
				@ li,107 PSAY SC7->C7_PRECO  Picture Right(PesqPict("SC7","c7_preco"),12)
				@ li,120 PSAY SC7->C7_TOTAL  Picture Right(PesqPict("SC7","c7_total"),12)
				@ li,133 PSAY SC7->C7_EMISSAO
				@ li,144 PSAY SC7->C7_DATPRF
				@ li,155 PSAY SC7->C7_DATPRF-SC7->C7_EMISSAO  Picture "999"
				@ li,158 PSAY "D"
				@ li,161 PSAY SC7->C7_COND
				@ li,165 PSAY SC7->C7_QUJE     Picture PesqPict("SC7","C7_QUJE",10)
				@ li,176 PSAY If(Empty(SC7->C7_RESIDUO),SC7->C7_QUANT-SC7->C7_QUJE,0)  Picture PesqPict("SC7","C7_QUJE",10)
				//@ li,196 PSAY If(Empty(SC7->C7_RESIDUO),'Nao','Sim')
				
			    If(!Empty(SC7->C7_RESIDUO))     
			      @ li,191 PSAY "Elim. Residuo"
			    Else  
				   if (SC7->C7_QUANT-SC7->C7_QUJE = 0)
					  @ li,191 PSAY "Fechado"
				   else
					  @ li,191 PSAY "Aberto"				
				   Endif	  
				endif
					
				li++
				dbSkip(-1)
			Enddo
		EndIf

		li++
		
	    nRegSC1 := QRYSC1->(GetArea())
		// query para selecionar as solicitações em aberto

		cQuery1 := "SELECT * "
	 	cQuery1 += "FROM " + RetSqlName( 'SC1' )  
		cQuery1 += " WHERE "
		cQuery1 += "C1_FILIAL='" + xFilial( 'SC1' ) + "' AND "
		cQuery1 += "C1_EMISSAO<='"  + DTOS(MV_PAR05)	+ "' AND "
		cQuery1 += "C1_NUM<>'"  + (QRYSC1->C1_NUM) + "' AND "	
	  	cQuery1 += "C1_PRODUTO='"  + (QRYSC1->C1_PRODUTO) + "' AND "
		cQuery1 += "C1_QUANT > C1_QUJE AND D_E_L_E_T_ <> '*'" 

	  	TCQUERY cQuery1 NEW ALIAS "SOL"  
	  	TcSetField("SOL","C1_DATPRF","D")  // Muda a data de string para date                                
		TcSetField("SOL","C1_EMISSAO","D")  // Muda a data de string para date                                  	
		SOL->(DBgotop())
		if !empty(SOL->C1_NUM) 
    	  //@ li,000 PSAY REPLICATE("-",220)
			//li++
			//@ li,000 PSAY "Sol.Compra em Aberto (Máx.3 sol.):"
			@ li,000 PSAY "Última Sol.Compra em Aberto :"		
			//li++  
			@ li,035 PSAY "Numero  It  Quant     Emissao     Necessidade     Fornecedor                                 Contato               Telefone   "		
			li++  		
			// imprime solicitacoes em aberto ate no maximo 3 (todas na mesma linha)
			uCont:=1
			//while SOL->(!Eof()) .and. uCont <= 3  
			while SOL->(!Eof()) .and. uCont <= 1  
				if uCont = 1
					@ li  ,035 PSAY SOL->C1_NUM
					@ li  ,043 PSAY SOL->C1_ITEM
					@ li  ,047 PSAY SOL->C1_QUANT
					@ li  ,057 PSAY DTOC(SOL->C1_EMISSAO)
					@ li  ,069 PSAY DTOC(SOL->C1_DATPRF)						
				else
					if uCont = 2
						@ li  ,085 PSAY SOL->C1_NUM
						@ li  ,093 PSAY SOL->C1_ITEM
						@ li  ,097 PSAY SOL->C1_QUANT
						@ li  ,107 PSAY DTOC(SOL->C1_EMISSAO)
						@ li  ,119 PSAY DTOC(SOL->C1_DATPRF)						
					else
						@ li  ,135 PSAY SOL->C1_NUM
						@ li  ,143 PSAY SOL->C1_ITEM
						@ li  ,147 PSAY SOL->C1_QUANT
						@ li  ,157 PSAY DTOC(SOL->C1_EMISSAO)
						@ li  ,169 PSAY DTOC(SOL->C1_DATPRF)						
					endif	
				endif	
				//li++
				uCont++ 
				dbSkip()
			enddo      
		else
			@ li,000 PSAY "Não existem solicitações de compra em aberto"
			li++
		endif                            
		// Imprime fornecedor, caso exista amarração produto fornecedor
		if !empty(uCodFor)
			@ li  ,085 PSAY substr(uNomFor,1,40)
			@ li  ,128 PSAY substr(uContato,1,15)
			@ li  ,150 PSAY uFone
		endif 
	
		RestArea(nRegSC1)   
	
		DbSelectArea("SOL")
		DbCloseArea()

	Endif		
	
	fAprElet()
	If li > 70 .and. lApr
	 	li=li+3
		@ ++li,000 PSAY "-------------------------------------------------    --------------------------------------------------    -------------------------------------------------------"
		@ ++li,000 PSAY "               "+PADC(ALLTRIM(uSolicit),15)+"                                         GERENTE                                                DIRETOR                  "		
	   	@ ++li,000 psay ""
		li:=80 

	Else
   		li++  
		@ li,000 Psay __PrtThinLine()
		li++

	Endif	
	
	QRYSC1->(dbSkip())
	
	dbSelectArea("SC1")
	RetIndex("SC1")
	If File(cArqInd+ OrdBagExt())
		FErase(cArqInd+ OrdBagExt() )
	EndIf

Enddo
@ li,183 PSAY "Total Geral: "
@ li,207 psay nTotGer Picture "@E 9,999,999.99" //-- Total geral
li++

if mv_par15==1
	@ li,001 psay "Obs.: Total Geral calculado sobre o preço da última compra."
endif

if li < 55	.and. lApr
 	li=li+3           
 	
	@ ++li,000 PSAY "__________________________________________________    __________________________________________________    ___________________________________________________"
	@ ++li,000 PSAY "                  "+PADC(ALLTRIM(uSolicit),15)+"                                    SUPERVISOR/GERENTE                                          DIRETOR"
	li:=80 
Endif

   
dbSelectArea("QRYSC1")
dbCloseArea()         

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO DO ITEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Impressao(cDescri)
Local j
Local nTotItem := 0

	// Impressao da Linha do Produto Solicitado                                                                                                                                                                 
	If mv_par15==1
		@ li,000 PSAY "Item  Código Produto   Descrição e Complemento do Produto        Saldo Atual  U.Med  Pto.Pedido     Qtd.Solic     Ultimo Preço  OS Ativo    Lead Time  Dt.Necess.  Dt.p/Comprar  C.Custo   "+Iif(!Empty(QRYSC1->C1_OS),"OS.Manut.",Space(9))+"Tipo SC.  Total do Item"
	Else
		@ li,000 PSAY "Item  Código Produto   Descrição e Complemento do Produto        Saldo Atual  U.Med  Pto.Pedido     Qtd.Solic     Preço Estim.    OS Ativo  Lead Time  Dt.Necess.  Dt.p/Comprar  C.Custo   "+Iif(!Empty(QRYSC1->C1_OS),"OS.Manut.",Space(9))+"Tipo SC.  Total do Item"
					 //                                                                                                                999,999,999.99
					 //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
					 //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       
	Endif		
      li++
	
	@ li,000 PSAY QRYSC1->C1_ITEM Picture PesqPict("SC1","C1_ITEM")
	@ li,006 PSAY QRYSC1->C1_PRODUTO
	@ li,023 PSAY SubStr(cDescri,1,40)
	
	@ li,065 PSAY SB2->B2_QATU Picture PesqPict("SB2","B2_QATU" ,11)
	@ li,081 PSAY QRYSC1->C1_UM
//	If cGeneric == '1'
		@ li,086 PSAY SB1->B1_EMIN Picture PesqPict("SB1","B1_EMIN" ,09)
//	Endif
	
	If SB1->B1_TIPO=="FE"
		nUPRC := U_MRPFVUFor(SB1->B1_COD,"N")[1] //Pega o preco da ultima entrada da ferramenta nova
	Else
		nUPRC := SB1->B1_UPRC
	EndIf
	
	// mostra quantidade parcial p/solicitação em aberto e quant total p/sol.fechada.
	if QRYSC1->C1_QUANT == QRYSC1->C1_QUJE
		@ li,097 PSAY QRYSC1->C1_QUANT Picture PesqPict("SC1","C1_QUANT",12)
		nTotItem := QRYSC1->C1_QUANT * Iif(mv_par15==1,nUPRC,QRYSC1->C1_VUNIT)
	else
		@ li,097 PSAY QRYSC1->C1_QUANT-QRYSC1->C1_QUJE	Picture PesqPict("SC1","C1_QUANT",12)
//		nTotItem := (QRYSC1->C1_QUANT-QRYSC1->C1_QUJE) * Iif(SB1->B1_TIPO=="FE",nUPRC,QRYSC1->C1_VUNIT)
		nTotItem := (QRYSC1->C1_QUANT-QRYSC1->C1_QUJE) * Iif(mv_par15==1,nUPRC,QRYSC1->C1_VUNIT)
	endif

	If mv_par15==2	
		@ li,112 PSAY QRYSC1->C1_VUNIT Picture "@E 99,999,999.99"
	Else
		@ li,112 PSAY nUPRC Picture "@E 99,999,999.99"
	Endif
	
	@ li,128 PSAY QRYSC1->C1_NUMOS Picture "@!"
	
	@ li,146 PSAY CalcPrazo(QRYSC1->C1_PRODUTO,QRYSC1->C1_QUANT) Picture "999"
	@ li,151 PSAY If(Empty(QRYSC1->C1_DATPRF),QRYSC1->C1_EMISSAO,QRYSC1->C1_DATPRF)
	@ li,164 PSAY If(Empty(QRYSC1->C1_DATPRF),QRYSC1->C1_EMISSAO,QRYSC1->C1_DATPRF)-CalcPrazo(QRYSC1->C1_PRODUTO,QRYSC1->C1_QUANT)
	@ li,177 PSAY ALLTRIM(QRYSC1->C1_CC)
	@ li,187 PSAY QRYSC1->C1_OS //-- NUMERO DA OS DE MANUT SE HOUVER
	
	If   QRYSC1->C1_CODMNT == '1'
		@ li,196 PSAY "Preventiva"	
	Elseif QRYSC1->C1_CODMNT == '2'
		@ li,196 PSAY "Corretiva "
	Else
		@ li,196 PSAY Space(10)
	Endif
	@ li,207 PSAY nTotItem Picture "@E 9,999,999.99" //-- Total por item
	nTotGer += nTotItem
	li++

	@ li,176 PSAY cCusto //-- DESCRICAO DO CENTRO DE CUSTO
	 
	// Impressao da Descricao Adicional do Produto (se houver)      
	For j:=40 TO Len(Trim(cDescri)) Step 40
		@ li, 24 PSAY SubStr(cDescri,j+1,40)
		li++
	Next j
	
Return .T.


Static Function fAprElet()
Local lRet := .F.,lAsin := .T.,lAsia := .T.

	SZU->(DbSetOrder(2))
	SZU->(DbSeek(xFilial("SZU")+QRYSC1->C1_NUM+QRYSC1->C1_ITEM))
	If SZU->(Found())
		li += 2
		
	  	@ li  ,000 psay "Aprovador      Status      Funcao                      Dt.Aprov.  Hora   Nr.Pc    Solicitante"
		li++
	  	@ li  ,000 psay "---------      ---------   --------------------        ---------- -----  -------  -----------"
		While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == QRYSC1->C1_NUM+QRYSC1->C1_ITEM
			_cDescStatus := Space(10)
			_cDescFuncao := Space(20)
			If SZU->ZU_STATUS == "A"
				_cDescStatus :=  "Aprovado  "
			Elseif SZU->ZU_STATUS == "B"			
				_cDescStatus :=  "Aguardando"
			Elseif SZU->ZU_STATUS == "C"			
				_cDescStatus :=  "Rejeitado "
			Endif	
			QAA->(DbSetOrder(6))
			QAA->(DbSeek(SZU->ZU_LOGIN))
			If QAA->(Found())
				SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
				If SRJ->(Found())
					_cDescFuncao := SRJ->RJ_DESC
				Endif
			Endif
		 	li++
 		  	@ li,000 psay SZU->ZU_LOGIN
 		  	@ li,015 psay _cDescStatus
 		  	@ li,027 psay _cDescFuncao
 		  	@ li,055 psay SZU->ZU_DATAPR
 		  	@ li,066 psay SZU->ZU_HORAPR
 		  	@ li,075 psay QRYSC1->C1_PEDIDO
 		  	@ li,082 psay QRYSC1->C1_SOLICIT
			If lAsin
	 		  	@ li,140 psay "------------------------------------"
				lAsin := .F.
	 		Else
				If lAsia
		 		  	@ li,155 psay "Assinatura"
					lAsia := .F.
		 		Endif  	
			Endif

			SZU->(DbSkip())
		Enddo
		li++
		@ li++,000 Psay __PrtThinLine()
    	lRet := .T.
    	lApr := .T.
    Else
    	lRet := .F.
    	lApr := .T.
	Endif  
	
Return(lRet) 

static function fMakeTit(cOrc,cNum)
Local cTit := "SOLICITAÇÃO DE COMPRA DETALHADA"  
                
//verifica situação das SC´s
cTit += Iif(cOrc <> 'O',' (COMPRAR)',' (ORÇAMENTO)')
cTit += ' SC Nº: ' + cNum

Return cTit
