/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT013 ³Autor  ³ Marcos R. Roquitski   ³ Data ³ 01/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera o arquivo de Aviso de Embarque p/ PSA-Peugeot/Citroen ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT013()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")   
SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,cFnl,_nNrCps")


Private cPerg := "ETQ   "                                
nPbruto  :=  0
_cArqDBF:=SPACE(12) 
_cArqFTP:=SPACE(12) 
_cArqITP:=SPACE(12)                                                           
_cArqAE1:=SPACE(12) 
_cArqNF2:=SPACE(12) 
_cArqAE2:=SPACE(12) 
_cArqAE4:=SPACE(12) 
_cArqAE3:=SPACE(12) 
_cArqTE1:=SPACE(12) 
_nNrCps := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFnl       := Chr(13) + Chr(10)
cARQEXP    := "C:\TEMP\TST"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"

/*
While File(cARQEXP)
   cARQEXP := SUBS(cARQEXP,1,20)+StrZero(Val(SUBS(cARQEXP,21,1))+1,1)+".TXT" 
Enddo
*/
                                                               
cARQ  := FCreate(cARQEXP)

If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Gerando Aviso de Embarque para PSA-Peugeot")
EndIf

If File( _cArqDBF )
   fErase(_cArqDBF)
Endif


Return

Static Function Gerando()
   
	cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI," 
	cQuery := cQuery + "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
	cQuery := cQuery + "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
	cQuery := cQuery + " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 " 
	cQuery := cQuery + " WHERE D2.D2_EMISSAO BETWEEN '" + DTOS(Mv_par01) + "' AND '" + DTOS(Mv_par02) + "' " 
	cQuery := cQuery + " AND D2.D2_CLIENTE = '" + Mv_par03 + "' AND D2.D2_LOJA = '" + Mv_par04 + "' " 
	cQuery := cQuery + " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('613','605')"
	cQuery := cQuery + " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
	cQuery := cQuery + " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
	cQuery := cQuery + " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"
	cQuery := cQuery + " AND D2. D_E_L_E_T_ <> '*' AND C5. D_E_L_E_T_ <> '*' AND C6. D_E_L_E_T_ <> '*' AND B1. D_E_L_E_T_ <> '*' AND A7. D_E_L_E_T_ <> '*'" 
	cQuery := cQuery + " ORDER BY D2.D2_DOC ASC"    

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
	DbSelectArea("TMP")

	fCriaDBF()  // Cria arquivos temporarios de aviso de embarque para PSA-Peugeot

	TMP->(DBGotop())            
	While !TMP->(EOF())
	   RecLock("DBF",.T.)
	   DBF->Nota    := TMP->D2_DOC
	   DBF->Serie   := TMP->D2_SERIE
	   DBF->Dta     := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
	   DBF->Prodcli := TMP->A7_CODCLI
	   DBF->Prodwhb := TMP->D2_COD
	   DBF->Total   := TMP->D2_TOTAL
	   MsUnlock("DBF")
     
	   TMP->(DbSkip())
	Enddo
     

	cMarca  := GetMark()
	aCampos := {}   
	
	Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"})
	Aadd(aCampos,{"NOTA"      ,"C", "Nota"           ,"@!"})
	Aadd(aCampos,{"SERIE"     ,"C", "Serie"          ,"@!"})
	Aadd(aCampos,{"DTA"       ,"C", "Data"           ,"@!"})
	Aadd(aCampos,{"PRODCLI"   ,"C", "Prod. Cliente"  ,"@!"})
	Aadd(aCampos,{"PRODWHB"   ,"C", "Prod. WHB"      ,"@!"})
	Aadd(aCampos,{"TOTAL"     ,"N", "Total"          ,"@e 999,999,999,999.99"})
	Aadd(aCampos,{"ESPACO"    ,"C", "  "             ,"@!"})

	DBF->(DbGoTop())
	cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
	aRotina := { {"Marca Tudo"    ,'U_fMaTodos()', 0 , 4 },;
	             {"Desmarca Tudo" ,'U_fMaParc()', 0 , 1 },;
	             {"Legenda"       ,'U_fLege()', 0 , 1 } }

	MarkBrow("DBF","OK" ,"DBF->OK",aCampos,,cMarca)

	ProcRegua(TMP->(RecCount()))

	TMP->(DbGoTop())
	DBF->(DbGoTop())
	nFTP := 1
	While !TMP->(eof()) .And. !DBF->(eof())     
	
		   
		If !EMPTY(DBF->OK)
      
			IncProc("Gerando Aviso de Embarque")

			/*--------------- ITPv0 - SEGMENTO INICIAL MENSAGEM --------------*/
			cLin := "ITP"
			cLin := cLin + "ASN"			
			cLin := cLin + "02"
			cLin := cLin + "00000"
			cLin := cLin + Substr(Dtos(Date()),3,6) + "010101"
			cLin := cLin + "73355174000140" // CGC WHB
			cLin := cLin + "59104422005704" //CGC PSA
			cLin := cLin + Space(08)
			cLin := cLin + Space(08)  
			cLin := cLin + "73355174000140"+Space(11)  //Identificacao do new hubner
			cLin := cLin + Space(25)
			cLin := cLin + Space(09)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))
			nFTP += 1  //Controle de qtde de segmentos


			/*--------------- BGMv0 - DADOS GERAIS DO DOCUMENTO --------------*/
			_nNrCps++			
			cLin := "BGM"
			cLin := cLin + StrZero((_nNrCps*100),12)
			cLin := cLin + "9  "
			cLin := cLin + Substr(Dtos(Date()),3,6) + "010101"
			cLin := cLin + Substr(Dtos(Date()),3,6) + "010101"
			cLin := cLin + "KGM"
			cLin := cLin + StrZero((TMP->C5_PBRUTO * 100),12)
			cLin := cLin + "KGM"
			cLin := cLin + StrZero((TMP->C5_PBRUTO * 100),12)
			cLin := cLin + "C62"			
			cLin := cLin + "000000000001"			
			cLin := cLin + "CRN"						
			cLin := cLin + Space(30)
			cLin := cLin + Space(08)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))

			/*--------------- BG1v0 - DADOS GERAIS E IDENTIFICACOES-----------*/
			cLin := "BG1"
			cLin := cLin + Substr(Dtos(Date()),3,6) + "010101"
			cLin := cLin + "90062336400000" + Space(06)
			cLin := cLin + "15129UV1V1" + Space(07)
			cLin := cLin + Space(76)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- DTLv1 - ENDERECOS E TRANSPORTE -----------------*/
			cLin := "DLT"
			cLin := cLin + "000000000000"
			cLin := cLin + "006090203633400000" + Space(02)
			cLin := cLin + "00709876543200000" + Space(03)
			cLin := cLin + Space(10)
			cLin := cLin + Space(10)
			cLin := cLin + Space(20)
			cLin := cLin + "000"
			cLin := cLin + "000"
			cLin := cLin + "000       "			
			cLin := cLin + Space(03)
			cLin := cLin + Space(03)
			cLin := cLin + Space(10)			
			cLin := cLin + Space(01)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- EQDv0 - DETALHES DE EQUIPAMENTOS-----------*/

			cLin := "EQD"
			cLin := cLin + "TE "
			cLin := cLin + Space(17)
			cLin := cLin + Space(105)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- EQDv0 - DETALHES DE EQUIPAMENTOS-----------*/

			cLin := "EQD"
			cLin := cLin + "TE "
			cLin := cLin + Space(17)
			cLin := cLin + Space(105)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- CPSv0 - DETALHES Do ITEM ----------------*/

			_nNrCps++
			cLin := "CPS"
			cLin := cLin + StrZero((_nNrCps*100),4)
			cLin := cLin + Space(121)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- PACv0 - DADOS DA EMBALAGEM --------------*/

			cLin := "PAC"
			cLin := cLin + StrZero((TMP->C5_VOLUME1 * 100),6)               
			cLin := cLin + Space(17)
			cLin := cLin + StrZero(((TMP->D2_QUANT / TMP->C5_VOLUME1) * 100),10)
			cLin := cLin + "KGM"
			cLin := cLin + Space(08)
			cLin := cLin + Space(81)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))

			/*--------------- RFFv0 - DADOS ETIQUETA TRANSPORTADOR ----*/

			cLin := "RFF"
			cLin := cLin + Space(17)
			cLin := cLin + Space(108)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			/*--------------- GIRv0 - DETALHES DOS PACOTES ------------*/

			cLin := "GIR"
			cLin := cLin + Space(17)
			cLin := cLin + Space(09)
			cLin := cLin + Space(17)
			cLin := cLin + Space(82)			
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))

			/*--------------- LINv1 - DADOS DO ITEM -------------------*/

			cLin := "LIN"
			cLin := cLin + Space(30)
			cLin := cLin + StrZero((TMP->D2_QUANT * 100),12)
			cLin := cLin + "KGM"
			cLin := cLin + StrZero((TMP->D2_QUANT * 100),12)
			cLin := cLin + "KGM"
			cLin := cLin + TMP->A7_PCCLI + Space(10)
			cLin := cLin + "0000"
			cLin := cLin + "BR"
			cLin := cLin + Space(29)
			cLin := cLin + cFnl
			FWrite(cArq,cLin,Len(cLin))


			//-------------  SEGMENTO FTXv0 - Texto Livre-----------------*/

			cLin := "FTX"
			cLin := cLin + Space(35)
			cLin := cLin + Space(35)
			cLin := cLin + Space(55)
			cLin := cLin + cFnl
    
			FWrite(cArq,cLin,Len(cLin))                
            
		Endif
		DBF->(DbSkip())
		TMP->(DbSkip())

	EndDo    

	If nFTP > 1

		//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem 
		cLin := "FTP"
		cLin := cLin + "00000"
		cLin := cLin + StrZero(nFTP,9)
		cLin := cLin + "00000000000000000"
		cLin := cLin + Space(01)
		cLin := cLin + Space(93)
		cLin := cLin + cFnl
    
		FWrite(cArq,cLin,Len(cLin))
		FClose(cARQ)

	Else
	    Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
	    FClose(cARQ)         
	    fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	Endif
	DbSelectArea("TMP")
    DbCloseArea()
    DbSelectArea("DBF")
    DbCloseArea()

 //	Close TMP 
//	Close DBF 

Return
                                     

Static Function fCriaDBF()

// ------- Segmento para mostrar no browse -----------

_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 02,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto new hubner
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.) 
  

Return                                



User Function fLege()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

//marca todas as notas
User Function fMaTodos()

   DBF->(DbGoTop())
   While !DBF->(eof())     
      
      RecLock("DBF")
         DBF->OK := cMarca
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return

//desmarca todas as notas
User Function fMaParc()

   DBF->(DbGoTop())
   While !DBF->(eof())     
      
      RecLock("DBF")
         DBF->OK := "  "
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
