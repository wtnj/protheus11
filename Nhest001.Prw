/*                                         
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST001        ³ Alexandre R. Bento    ³ Data ³ 30.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Boletim de Entrada apartir da NF Entrada     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"
 //Recebe parametros do ponto de entrada SF1100I na sequencia: DATA DIGITACAO,NF,SERIE,FORNECEDOR,LOJA
User Function NhEst001(cPar01,cPar02,cPar03,cPar04,cPar05)  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,nQtde")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_NTGERAL")
SetPrvt("_NTPARCIAL,_CFORNECE,_CLOJA,_NTOTALF,_NAUX,lDivPed")
SetPrvt("_DDATA,_CARQNTX,_CORDEM,_NPER,_NPOS,_CCABEC1,M_PAG,_ca,_cb,_cc,cTipoNF")
SetPrvt("aAuxCombo1,aCombo1,cPedido,cINSP,cFornece,cSerie,cNF,cLoja,dDtDigi,_cNome")
SetPrvt("nBASEICM,nVALICM,nBRICMS,nICMSRET,nVALMERC,nDESCONT,nFRETE,nSEGURO,nDESPESA,nVALIPI,nVALBRUT")
SetPrvt("cNome,cEndereco,cMunicipio,cEst,cCGC,cItem,_cLogin")

cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Itens que vieram na nota fiscal de Entrada e tambem acusar")
cDesc3    := OemToAnsi("as divergencias com o Pedido de Compras.")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST001"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Boletim de Entrada" 
Cabec1    := " Dados do Fornecedor                                                  Nota Fiscal   Especie   Tipo da Nota   Emissao    Hora Entrega"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST001"             //Nome Default do relatorio em Disco
_cPerg    := "EST001"               //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aAuxCombo1:= {"N","D","B","I","P","C"}
aCombo1	  := {"Normal        ",;	//"Normal"
   		  	  "Devolucao     ",;	//"Devoluçao"
		  	  "Beneficiamento",;	//"Beneficiamento"
		  	  "C.ICMS        ",;	//"Compl.  ICMS"
   		  	  "C.IPI         ",;	//"Compl.  IPI"
			  "C.Preco/Frete "}	//"Compl. Preco/frete"

nBASEICM :=	0
nVALICM  := 0
nBRICMS  :=	0
nICMSRET :=	0
nVALMERC :=	0
nDESCONT :=	0
nFRETE   :=	0
nSEGURO  :=	0
nDESPESA :=	0
nVALIPI  := 0
nVALBRUT := 0
dDtDigi  := Ctod("//")
cNF      := Space(06)
cSerie   := Space(03)
cFornece := Space(06)
cLoja    := Space(02)            
_cLogin  := Space(15)

// Parametros Utilizados
// mv_par01 = Data da digitacao   
// mv_par02 = Numero da nota fiscal
// mv_par03 = Serie da nota fiscal
// mv_par04 = Fornecedor da nota fiscal
// mv_par05 = Loja da nota fiscal

// AjustaSX1() // Verifica os parametros
Pergunte(_cPerg,.F.)
For xD:=1 to 2
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")        

if valtype( cPar01 ) <> 'U'

   dDtDigi  := cPar01 
   cNF      := cPar02 
   cSerie   := cPar03
   cFornece := cPar04  
   cLoja    := cPar05
   _cNome   := Space(20)

Else //qdo impressao nao for via pto de entrada da nf pega os parametros do SX1
    dDtDigi  := Mv_Par01 
	cNF      := Mv_Par02 
	cSerie   := Mv_Par03 
	cFornece := Mv_Par04 
	cLoja    := Mv_Par05                   

Endif

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Set Filter To
   Return
Endif

             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D1_DOC)
   MsgBox("Nota Fiscal nao Encontrada","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| RptDetail() },"Gerando Dados para a Impressao")
Processa( {|| fPedido()   },"Gerando Dados para a Impressao")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
    DbCommitAll()
	Set Printer To
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Next

Return

Static Function Gerando()    

   cQuery := "SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,D1.D1_ITEM,D1.D1_LOCAL,"
   cQuery += "F1.F1_HORA,F1.F1_TIPO,F1.F1_ESPECIE,F1.F1_BASEICM,F1.F1_VALICM,F1.F1_USERLGI,F1.F1_USER,"
   cQuery += "F1.F1_VALIPI,F1.F1_BRICMS,F1.F1_ICMSRET,F1.F1_VALMERC,F1.F1_DESCONT,B1.B1_LOCAFIS,"
   cQuery += "F1.F1_FRETE,F1.F1_SEGURO,F1.F1_DESPESA,F1.F1_VALIPI,F1.F1_VALBRUT,F1.F1_CODPLAC,B1.B1_TIPO,B5.B5_CEME,"
   cQuery += "QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI,"
   cQuery += "'CLIENTE' = "
   cQuery += "CASE "
   cQuery += "  WHEN F1.F1_TIPO = 'N' THEN "
   cQuery += "        (SELECT A2.A2_NOME+"+"A2.A2_END+"+"A2.A2_MUN+"+"A2.A2_EST+"+"A2.A2_CGC "   
   cQuery += "         FROM " +RetSqlName('SA2') +" A2 "    
   cQuery += "        WHERE A2.D_E_L_E_T_ = ' ' AND A2.A2_COD = D1.D1_FORNECE "
   cQuery += "        AND A2.A2_LOJA = D1.D1_LOJA)" 
   cQuery += "  ELSE "
   cQuery += "        (SELECT A1.A1_NOME+"+"A1.A1_END+"+"A1.A1_MUN+"+"'     '+"+"A1.A1_EST+"+"A1.A1_CGC "   
   cQuery += "         FROM " +RetSqlName('SA1') +" A1 "       
   cQuery += "        WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = D1.D1_FORNECE "
   cQuery += "        AND A1.A1_LOJA = D1.D1_LOJA) "
   cQuery += "   END    "
   cQuery += " FROM " +RetSqlName('SD1') +" D1 "          
   cQuery += " INNER JOIN " +RetSqlName('SF1') +" F1 "          
   cQuery += " ON  D1.D1_FORNECE = F1.F1_FORNECE" 
   cQuery += " AND D1.D1_LOJA    = F1.F1_LOJA"
   cQuery += " AND D1.D1_TIPO    = F1.F1_TIPO" 
   cQuery += " AND F1.F1_DOC     = D1.D1_DOC"  
   cQuery += " AND F1.F1_SERIE   = D1.D1_SERIE" 
   cQuery += " AND D1.D1_DTDIGIT = F1.F1_DTDIGIT"
   cQuery += " AND F1.F1_FILIAL  = '" + xFilial("SF1")+ "'"
   cQuery += " AND F1.D_E_L_E_T_ = ''"  
   cQuery += " INNER JOIN " +RetSqlName('SB1') +" B1 "          
   cQuery += " ON D1.D1_COD = B1.B1_COD" 
   cQuery += " AND B1.B1_FILIAL  = '" + xFilial("SB1")+ "'"
   cQuery += " AND B1.D_E_L_E_T_ = ''"
   cQuery += " LEFT JOIN  " +RetSqlName('QEK') +" QEK "          
   cQuery += " ON D1.D1_DOC    = QEK.QEK_NTFISC" 
   cQuery += " AND D1.D1_SERIE = QEK.QEK_SERINF"
   cQuery += " AND D1.D1_COD   = QEK.QEK_PRODUT" 
   cQuery += " AND D1.D1_FORNECE = QEK.QEK_FORNEC" 
   cQuery += " AND D1.D1_LOJA  = QEK.QEK_LOJFOR" 
   cQuery += " AND D1.D1_DTDIGIT = QEK.QEK_DTENTR"  
   cQuery += " AND D1.D1_LOTECTL = QEK.QEK_LOTE" 
   cQuery += " AND D1.D1_QUANT = QEK.QEK_TAMLOT"
   cQuery += " AND QEK.QEK_FILIAL  = '" + xFilial("QEK")+ "'"
   cQuery += " AND QEK.D_E_L_E_T_ = ''"
   cQuery += " LEFT JOIN " +RetSqlName('SB5') +" B5 "          
   cQuery += " ON D1.D1_COD = B5.B5_COD"  
   cQuery += " AND B5.D_E_L_E_T_ = ''" 
   cQuery += " WHERE D1.D1_FILIAL  = '" + xFilial("SD1")+ "'"
   cQuery += " AND D1.D1_DTDIGIT ='" + Dtos(dDtDigi) + "'"  
   cQuery += " AND D1.D1_DOC = '" + cNF + "' AND D1.D1_SERIE = '" + cSerie + "'"
   cQuery += " AND D1.D1_FORNECE = '" + cFornece + "' AND D1.D1_LOJA = '" + cLoja +"'"
   cQuery += " GROUP BY D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,"
   cQuery += " D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,D1.D1_ITEM,D1.D1_LOCAL,"
   cQuery += " F1.F1_HORA,F1.F1_TIPO,F1.F1_ESPECIE,F1.F1_BASEICM,F1.F1_VALICM,F1.F1_USERLGI,F1.F1_USER,"
   cQuery += " F1.F1_VALIPI,F1.F1_BRICMS,F1.F1_ICMSRET,F1.F1_VALMERC,F1.F1_DESCONT,B1.B1_LOCAFIS,"
   cQuery += " F1.F1_FRETE,F1.F1_SEGURO,F1.F1_DESPESA,F1.F1_VALIPI,F1.F1_VALBRUT,B1.B1_TIPO,F1.F1_CODPLAC,"
   cQuery += " QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI,B5.B5_CEME"
   cQuery += " ORDER BY D1.D1_PEDIDO,D1.D1_ITEM ASC"
   


//TCQuery Abre uma workarea com o resultado da query
//   MemoWrit('C:\TEMP\EST001.SQL',cQuery)        
	TCQUERY cQuery NEW ALIAS "TMP"  

Return

Static Function RptDetail()

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))

cTipoNF	:= aCombo1[aScan(aAuxCombo1,TMP->F1_TIPO)]  // Tipo da nota fiscal
 
If ALLTRIM(UPPER(SM0->M0_CODIGO))$'FN/NH'
	If TMP->D1_LOCAL >= '20' .and. TMP->D1_LOCAL <= '29'
	   Titulo += Oemtoansi("  FUNDIÇÃO - WHB II")
	ElseIf TMP->D1_LOCAL >= '30' .and. TMP->D1_LOCAL <= '39'
	      Titulo += Oemtoansi("  USINAGEM - WHB III ")
	ElseIf TMP->D1_LOCAL >= '40' .and. TMP->D1_LOCAL <= '49'
	      Titulo += Oemtoansi("  FORJARIA - WHB IV ")
	ElseIf TMP->D1_LOCAL >= '50' .and. TMP->D1_LOCAL <= '59'
	      Titulo += Oemtoansi("  VIRABREQUIM  - WHB V")
	Endif      

Endif
	
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

QAA->(DbSetOrder(6))
//_cLogin := Subs(EMBARALHA(TMP->F1_USERLGI,1),1,AT(" ",EMBARALHA(TMP->F1_USERLGI,1)))

_cLogin := TMP->F1_USER

QAA->(DbSeek(_cLogin))
If QAA->(Found())
	_cNome := QAA->QAA_NOME
Endif

//-- os: 057879
iF EMPTY(_cNome)
	_cNome := UsrFullName(__cUserID)
Endif
//-- fim os: 057879

cNome        := substr(TMP->CLIENTE,0,40)
cEndereco    := substr(TMP->CLIENTE,41,40)
cMunicipio   := substr(TMP->CLIENTE,81,17)
cCGC         := substr(TMP->CLIENTE,098,14)

@ Prow() + 1, 001 Psay TMP->D1_FORNECE +" / " + TMP->D1_LOJA + " - " + cNome+ Space(15)+TMP->D1_DOC+"-"+TMP->D1_SERIE+"       "+TMP->F1_ESPECIE+"  "+Subs(CtipoNF,1,12)+Space(02)+Subs(TMP->D1_EMISSAO,7,2)+"/"+Subs(TMP->D1_EMISSAO,5,2)+"/"+Subs(TMP->D1_EMISSAO,1,4)+"      "+TMP->F1_HORA
@ Prow() + 1, 001 Psay cEndereco+"                             Valor Total: " + Transform(TMP->F1_VALBRUT,"@E 9,999,999.99")
@ Prow() + 1, 001 Psay cMunicipio 
@ Prow()    , 035 Psay "CNPJ/CGC: "
@ Prow()    , 046 Psay cCGC picture "@R 99.999.999/9999-99"
                                       
//Traz os dados do cadastro de veículos
SF1->(DbSetOrder(1))
SF1->(DbSeek(xFilial("SF1")+TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_FORNECE+TMP->D1_LOJA))

If !AllTrim(SF1->F1_CODPLAC)$"N/A"
	SO5->(DbSetOrder(1)) // O5_FILIAL+O5_PLACA
	SO5->(DbSeek(xFilial("SO5")+SF1->F1_CODPLAC))
	
	If SO5->(Found())
	
		@ Prow() + 1, 001 Psay "Transportadora: "  + Alltrim(SO5->O5_EMPRESA)
		@ Prow()    , 040 Psay "Placa: "  + Alltrim(SO5->O5_PLACA)
		@ Prow()    , 060 Psay "Motorista: " + Alltrim(SO5->O5_DESCRI)	
		@ Prow()    , 100 Psay "RG: " + Alltrim(SO5->O5_CHASSI)
		
		Do Case
			Case SO5->O5_MODTRAN=="1"
				@ Prow() +1 , 001 Psay "Modalidade: Carreta"
			Case SO5->O5_MODTRAN=="2"
				@ Prow() +1 , 001 Psay "Modalidade: Truck"
			Case SO5->O5_MODTRAN=="3"
				@ Prow() +1 , 001 Psay "Modalidade: Bug"
			Case SO5->O5_MODTRAN=="4"
				@ Prow() +1 , 001 Psay "Modalidade: Outro"
		EndCase
	
	EndIf
Endif	

@ Prow() + 1, 001 Psay "------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
//@ Prow() + 1, 001 Psay "Cod.Produto    Unid.  Descricao Produto                              Qtde Fisica   Vlr.Unit   Valor Total   C.Custo Lote"
@ Prow() + 1, 001 Psay "Cod.Produto    Unid.  Descricao Produto                              Qtde Fisica                            C.Custo Lote"
// Carrega variaveis p/ imprimir o rodape
nBASEICM :=	TMP->F1_BASEICM
nVALICM  := TMP->F1_VALICM
nBRICMS  :=	TMP->F1_BRICMS
nICMSRET :=	TMP->F1_ICMSRET
nVALMERC :=	TMP->F1_VALMERC
nDESCONT :=	TMP->F1_DESCONT
nFRETE   :=	TMP->F1_FRETE
nSEGURO  :=	TMP->F1_SEGURO
nDESPESA :=	TMP->F1_DESPESA
nVALIPI  := TMP->F1_VALIPI
nVALBRUT := TMP->F1_VALBRUT
cItem    := Space(01)
While TMP->(!Eof())

   	cInsp := Space(11)
   	IncProc("Imprimindo Boletim de Entrada... " + TMP->D1_DOC)
   	If cItem <> TMP->D1_ITEM
      	
      	cItem := TMP->D1_ITEM
      	
	   	If Prow() > 60
	      	_nPag := _nPag + 1
	      	Cabec1 := " "
	      	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
	      	@ Prow() + 1, 001 Psay "------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
			@ Prow() + 1, 001 Psay "Cod.Produto    Unid.  Descricao Produto                 Quantidade   Qtde Fisica   Vlr.Unit   Valor Total   C.Custo Lote"
//			@ Prow() + 1, 001 Psay "Cod.Produto    Unid.  Descricao Produto                              Qtde Fisica                            C.Custo Lote"
	   	Endif
	                                             
		@ Prow() + 1, 001 Psay TMP->D1_COD
		@ Prow()    , 017 Psay TMP->D1_UM  
		@ Prow()    , 023 Psay TMP->D1_DESCRI  	
		@ Prow()    , 054 Psay Transform(TMP->D1_QUANT,"@E 9,999,999.999")
		@ Prow()    , 070 Psay "_______"
		@ Prow()    , 077 Psay Transform(TMP->D1_VUNIT,"@E 9,999,999.9999")
		@ Prow()    , 091 Psay Transform(TMP->D1_TOTAL,"@E 9,999,999.9999")
		@ Prow()    , 108 Psay Alltrim(TMP->D1_CC)

		If TMP->B1_TIPO $("MC/CC/CP/MP/PI/MA")
			If TMP->QEK_VERIFI = 1
			   cInsp := 'Inspecionar'
			ElseIf TMP->QEK_VERIFI = 2 
			   cInsp := 'Skip Lote'
			Else
			   cInsp := 'Amarracao'                         
			Endif                                                       
		Endif

		@ Prow()    , 116 Psay Alltrim(TMP->D1_LOTECTL) +' '+ Subs(cInsp,1,8)

		//imprime descricao da SC
		If SC7->(dbSeek(xFilial("SC7")+TMP->D1_PEDIDO+TMP->D1_ITEMPC))
	  	   If SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
		      If !empty(SC1->C1_OBS)
			      @ Prow() +1, 001 Psay 'Obs. SC.: '
			      FOR _x := 1 to Len(ALLTRIM(SC1->C1_OBS))
				      If _x == 1
				      	@ Prow()   , 016 Psay SUBSTR(ALLTRIM(SC1->C1_OBS),_x,100)
				      Else
					    @ Prow()+1 , 016 Psay SUBSTR(ALLTRIM(SC1->C1_OBS),_x,100)
				      EndIf
 				      _x += 99
			      Next
			  EndIf
		      
	       EndIf
		EndIf

		If TMP->B5_CEME <> ''
			@ Prow()+1  , 001 Psay 'Desc.Completa: ' + Alltrim(Subs(TMP->B5_CEME,1,91)) + '   Almoxarifado= '+TMP->D1_LOCAL
		    If !Empty(TMP->B1_LOCAFIS)
			   @ Prow()  , 108 Psay OemtoAnsi('Localização: ')+TMP->B1_LOCAFIS  	
			Endif   
		Else
	       If !Empty(TMP->B1_LOCAFIS)
			   @ Prow()+1    , 001 Psay OemtoAnsi('Localização no Almoxarifado: ')+TMP->B1_LOCAFIS  	
		   Endif   
	
		Endif                                                             	
   Endif	   
   TMP->(Dbskip())   
EndDo                               		
      
Return(nil)      
                                 	
Static Function fPedido
Local lPedCom   := .F.
Local cProblema := Space(03)

 	@ Prow() + 1, 001 Psay __PrtFatLine()  //Imprime uma linha em negrito          
	@ Prow() + 1, 001 Psay "------------------------------------------------DIVERGENCIAS COM O PEDIDO DE COMPRAS --------------------------------------------"
	@ Prow() + 1, 001 Psay "Diverg. Numero     Descricao do Produto                   Quantidade      Vlr.Unit   Emissao   Entrega     S.C.     Solicitante"

   	SC7->(DbSetOrder(14))
	TMP->(DbGoTop())
   	ProcRegua(TMP->(RecCount()))
   	SC1->(DbSetOrder(1))
   	
    //_cNome := UsrFullName(__cUserID) //U_NhCfg001("02") //02-traz o nome completo do usuario
    
	While TMP->(!Eof())
                                                             
      	IncProc("Imprimindo Divergencia do Pedido... " + TMP->D1_DOC)
      	
      	If Prow() > 60
	      	_nPag := _nPag + 1
	    	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
			@ Prow() + 1, 001 Psay "------------------------------------------------DIVERGENCIAS COM O PEDIDO DE COMPRAS --------------------------------------------"
			@ Prow() + 1, 001 Psay "Diverg. Numero     Descricao do Produto                   Quantidade      Vlr.Unit   Emissao   Entrega     S.C.     Solicitante"
   		Endif
      
      	If SC7->(dbSeek(xFilial("SC7")+TMP->D1_PEDIDO+TMP->D1_ITEMPC))
	  	   	If SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
		      	lPedCom := .T.
	      	EndIf         
	      
			lDivPed   := .T.
			
			cProblema := ""
			
			If SC7->C7_QUANT <> TMP->D1_QUANT
		   	cProblema += "Q"
			Else
				cProblema += " "
			EndIf
		
			If IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) # TMP->D1_VUNIT
		 		cProblema := cProblema+"P"
			Else
		  		cProblema := cProblema+" "
			EndIf
			
			If DTOS(SC7->C7_DATPRF) <> TMP->D1_DTDIGIT
				cProblema := cProblema+"E"
			Else
				cProblema := cProblema+" "
			EndIf
		
		   	@ Prow() + 1, 001 Psay cProblema
		   	@ Prow()    , 009 Psay SC7->C7_NUM+"/"+SC7->C7_ITEM
		   	@ Prow()    , 020 Psay Subs(SC7->C7_DESCRI,1,30)
		   	@ Prow()    , 058 Psay TransForm(SC7->C7_QUANT,PesqPict("SC7","C7_QUANT",11))
		   	@ Prow()    , 070 Psay TransForm(SC7->C7_PRECO,PesqPict("SC7","C7_PRECO",13))
	//	   	@ Prow()    , 085 Psay DTOC(SC7->C7_EMISSAO)
	//     	@ Prow()    , 095 Psay DTOC(SC7->C7_DATPRF)   
		   	@ Prow()    , 085 Psay StrZero(Day(SC7->C7_EMISSAO),2) + "/" + StrZero(Month(SC7->C7_EMISSAO),2) + "/"+Subs(StrZero(Year(SC7->C7_EMISSAO),4),3,2)	   		   		   	
	//	   	@ Prow()    , 085 Psay DTOC(SC7->C7_EMISSAO)
		   	@ Prow()    , 095 Psay StrZero(Day(SC7->C7_DATPRF),2) + "/" + StrZero(Month(SC7->C7_DATPRF),2) + "/"+Subs(StrZero(Year(SC7->C7_DATPRF),4),3,2)	   		   		   	
		   	@ Prow()    , 105 Psay SC7->C7_NUMSC+"/"+SC7->C7_ITEMSC
		   	@ Prow()    , 117 Psay Iif(lPedCom,SubStr(SC1->C1_SOLICIT,1,11),"")
			           					 /* Iif(lPedCom,SC1->C1_CC,"")*/

		Endif             
		
	   	TMP->(Dbskip())
	   
   	Enddo

   	If !lDivPed 
   		@ Prow() + 2, 1  Psay  "  NOTA FISCAL SEM PEDIDO"
   	Endif
   
  	@ Prow() + 1, 001 Psay __PrtFatLine()  //Imprime uma linha em negrito         
	@ Prow() + 1, 001 Psay "-----------------------------------------------------  TOTAIS DA NOTA FISCAL  ----------------------------------------------------"
	@ Prow() + 1, 001 Psay " BASE DE CALCULO ICMS      VALOR DO ICMS    BASE CALC.ICMS SUBST.    VALOR ICMS SUBST.   VALOR TOTAL DOS PRODUTOS        DESCONTOS"
  	@ Prow() + 1, 003 Psay Transform(nBASEICM,"@E 999,999,999,999.99")
  	@ Prow()    , 025 Psay Transform(nVALICM, "@E 9,999,999,999.99")
  	@ Prow()    , 047 Psay Transform(nBRICMS, "@E 999,999,999,999.99")
	@ Prow()    , 069 Psay Transform(nICMSRET,"@E 9,999,999,999.99")
	@ Prow()    , 093 Psay Transform(nVALMERC,"@E 999,999,999,999.99")
	@ Prow()    , 114 Psay Transform(nDESCONT,"@E 9,999,999,999.99")
	@ Prow() + 1, 001 Psay __PrtThinLine()
  	@ Prow() + 1, 001 Psay "       VALOR DO FRETE           VALOR DO SEGURO     OUTRAS DESPESAS ACESSO.      VALOR TOTAL DO IPI          VALOR TOTAL DA NOTA"
	@ Prow() + 1, 001 Psay Transform(nFRETE,  "@E 99,999,999,999,999.99")
	@ Prow()    , 027 Psay Transform(nSEGURO, "@E 99,999,999,999,999.99")
	@ Prow()    , 053 Psay Transform(nDESPESA,"@E 99,999,999,999,999.99")
   	@ Prow()    , 079 Psay Transform(nVALIPI, "@E 99,999,999,999,999.99")
   	@ Prow()    , 108 Psay Transform(nVALBRUT,"@E 99,999,999,999,999.99")
 	@ Prow() + 1, 001 Psay __PrtFatLine()  //Imprime uma linha em negrito              	
  	@ Prow() + 1, 001 Psay "Divergencias -    Q - Quantidade             P - Preco          E - Entrega"
	@ Prow() + 1, 001 Psay "Observacoes  -    Amarraca - Falta Amarracao no Quality         Inspecio - Inspecionar          Skip Lote - Nao Inspecionar"
   
   	@ Prow() + 4, 001 Psay "             __________________                                      __________________"  
   	@ Prow() + 1, 001 Psay "             Recebimento Fiscal                                      Recebimento Fisico"
   	@ Prow() + 1, 011 Psay Padc(Alltrim(_cNome),25)
   	@ Prow() + 1, 001 Psay " "
Return

User Function MATR170()
	U_NHEST001(SF1->F1_DTDIGIT,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
RETURN