/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! NHFAT037.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Gerar aviso de embarque para GM - General Motors        +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 27/05/2013                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"

User Function NHFAT037()

SetPrvt("_cArqDbf,cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")
SetPrvt("_cArqITP,_cArqgAE1,_cArqgAE2,_cArqAE3,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_gAE1,_caAE2,_aAE3,_aFTP,_aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cCGC,_cNotas,_clEmb,a_email,cPerg,_aGMs")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam,_cDoc")
SetPrvt("_cArqGM1,_cArqGM2,_cArqGM3,aGM1,aGM2")

cServer	 := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPassword:= Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMensagem:= 'Erro ao se conectar no servidor: '
CRLF     := chr(13)+chr(10)   // PULA LINHA
cMSG     := ""

cPerg     := "FAT035"
_lEmb     := .F. //verifica se gerou o aviso de embarque
nPbruto   :=  0
nFTP      := 0
_cArqDBF  :=SPACE(12)
_cArqFTP  :=SPACE(12)
_cArqITP  :=SPACE(12)
_cArqgAE1 :=SPACE(12)
_cArqgAE2 :=SPACE(12)
_cArqAE3  :=SPACE(12)
_cNotas   :=SPACE(200)
_cNome    := UsrFullName(__cUserID)
_aFile    := {}
_aGMs     := {}
cNovaLinha:= Chr(13) + Chr(10)
_cEdi     := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam     := "GMB"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
cARQEXP   := _cEDI + _cCam

While File(cARQEXP)
	
	_cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT"
	cARQEXP := _cEDI + _cCam
	
Enddo

cARQ  := FCreate(cARQEXP)

If Pergunte(cPerg,.T.)
	
	Processa({|| Gerando() }, "Gerando Aviso de Embarque para General Motors")
	
EndIf

If File( _cArqDBF )
	
	fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	fErase(_cArqITP)
	fErase(_cArqgGM1)
	fErase(_cArqgGM2)
	fErase(_cArqgAE1)
	fErase(_cArqgAE2)
	fErase(_cArqgAE1)
	fErase(_cArqgGM3)
	fErase(_cArqAE3)
	fErase(_cArqFTP)
	
Endif

//Manda e-mail de confirmação da geração do aviso de embarque da General Motors

If _lEmb //verifica se gerou o aviso de embarque
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	cMsg += '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> Aviso de Embarque General Motors </title>' + CRLF
	cMsg += '</head>' + CRLF
	cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF
	cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	cMsg += '<font size="2" face="Arial">Aviso de Embarque Enviado para General Motors as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
	cMsg += _cNotas+'</font>' + CRLF
	cMsg += CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Aviso de Embarque Gerado Por '+_cNome+'</font>' + CRLF
	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF
	
	IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
		
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'edenilsonas@whbbrasil.com.br'
		
	ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
		
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'edenilsonas@whbbrasil.com.br'
		
	Endif
	
	_aFile := { "\System\WHBL.BMP" }
	
	If lConectou
		
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '*** AVISO DE EMBARQUE PARA GENERAL MOTORS ***' +Upper(_cPlanta)+' ***** ';
		BODY cMsg;
		ATTACHMENT _aFile[1];
		RESULT lEnviado
		
		If !lEnviado
			
			Get mail error cMensagem
			Alert(cMensagem)
			
		EndIf
		
	else
		
		Alert("Erro ao se conectar no servidor: " + cServer)
		
	Endif
	
Endif

If File(cARQEXP)
	
	FClose(cARQ)
	
	if !_lEmb
		
		fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
		
	Endif
	
Endif

Return

Static Function Gerando()

IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
	
	If Mv_par01 == 1 // Sao Jose dos Campos
		
		_cCliente := "900004"
		_cLoja    := "02"
		_cPlanta  := " Sao Jose dos Campos"
		_cFabri  	:= "4J"
		_cCGC     := "59275792000150"
		_cDoca 	:= "D50"
		
	Endif
	
ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
	
	If Mv_par01 == 1 // Sao Jose dos Campos
		
		_cCliente := "900024"
		_cLoja    := "02"
		_cPlanta  := "Sao Jose dos Campos"
		_cFabri  	:= "4J"
		_cCGC     := "59275792000150"
		_cDoca 	:= "D30"
		
	Elseif Mv_par01 == 2 // Sorocaba
		
		_cCliente := "900024"
		_cLoja    := "02"
		_cPlanta  := "Sorocaba"
		_cCGC     := "59275792008991"
		_cDoca 	:= "A215
		
		
	Endif
	
Endif

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery := cQuery + "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery := cQuery + "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
cQuery := cQuery + " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 "
cQuery := cQuery + " WHERE D2.D2_FILIAL = '" + xFilial('SD2')+ "' AND C5.C5_FILIAL = '" + xFilial('SC5')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND C6.C6_FILIAL = '" + xFilial('SC6')+ "' AND A7.A7_FILIAL = '" + xFilial('SA7')+ "'"
cQuery := cQuery + " AND D2.D2_EMISSAO BETWEEN '" + DTOS(Mv_par02) + "' AND '" + DTOS(Mv_par03) + "' "
cQuery := cQuery + " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' "
cQuery := cQuery + " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('542','503','573','613','605','576','526')"
cQuery := cQuery + " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
cQuery := cQuery + " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery := cQuery + " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"
cQuery := cQuery + " AND C6.C6_PRODUTO = D2.D2_COD"
cQuery := cQuery + " AND C6.C6_ITEM = D2.D2_ITEMPV"
cQuery := cQuery + " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '"
cQuery := cQuery + " ORDER BY D2.D2_DOC ASC"
TCQUERY cQuery NEW ALIAS "TRA1"
DbSelectArea("TRA1")

fCriaDBF()  // Cria arquivos temporarios de aviso de embarque para volks

TRA1->(DBGotop())
If Empty(TRA1->D2_DOC)

	Aviso("ASN - General Motors | Atenção","Não foi encontrado nenhuma nota fiscal neste periodo.", {"OK"},2)		
	FClose(cARQ)
	fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	TRA1->(DbCloseArea())
	XDBF->(DbCloseArea())
	GM1->(DbCloseArea())
	GM2->(DbCloseArea())
	AE1->(DbCloseArea())
	AE2->(DbCloseArea())
	GM3->(DbCloseArea())
	AE3->(DbCloseArea())
	FTP->(DbCloseArea())
	
	Return
	
Endif

While !TRA1->(EOF())
	
	RecLock("XDBF",.T.)
	XDBF->Nota    := TRA1->D2_DOC
	XDBF->Serie   := Alltrim(TRA1->D2_SERIE)
	XDBF->Dta     := Subs(TRA1->D2_EMISSAO,7,2)+"/"+Subs(TRA1->D2_EMISSAO,5,2)+"/"+Subs(TRA1->D2_EMISSAO,1,4)
	XDBF->Prodcli := TRA1->A7_CODCLI
	XDBF->Prodwhb := TRA1->D2_COD
	XDBF->Total   := TRA1->D2_TOTAL
	MsUnlock("XDBF")
	
	TRA1->(DbSkip())
	
Enddo

cMarca  := GetMark()
aCampos := {}

Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", "Nota      "     ,"@!"})
Aadd(aCampos,{"SERIE"     ,"C", "Serie"          ,"@!"})
Aadd(aCampos,{"DTA"       ,"C", "Data     "      ,"@!"})
Aadd(aCampos,{"PRODCLI"   ,"C", "Prod. Cliente"  ,"@!"})
Aadd(aCampos,{"PRODWHB"   ,"C", "Produto WHB    ","@!"})
Aadd(aCampos,{"TOTAL"     ,"N", "Total    "      ,"@e 999,999,999,999.99"})
Aadd(aCampos,{"ESPACO"    ,"C", "  "             ,"@!"})

XDBF->(DbGoTop())
cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcagm()', 0 , 4 },;
{"Desmarca Tudo" ,'U_fDesmargm()', 0 , 1 },;
{"Legenda"       ,'U_fLegGM()', 0 , 1 } }

MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)

ProcRegua(TRA1->(RecCount()))

TRA1->(DbGoTop())
XDBF->(DbGoTop())

While !TRA1->(eof()) .And. !XDBF->(eof())
	
	
	If !EMPTY(XDBF->OK)
		
		IncProc("Gerando Aviso de Embarque " + _cPlanta)
		
		_nx := Ascan(_aGMs, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == TRA1->D2_DOC+TRA1->D2_SERIE+TRA1->D2_CLIENTE+TRA1->D2_LOJA+TRA1->D2_COD})
		
		If _nx <> 0
			_aGMs[_nx][08]:= _aGMs[_nx][08] + TRA1->D2_TOTAL
			_aGMs[_nx][10]:= _aGMs[_nx][10] + TRA1->D2_VALICM
			_aGMs[_nx][12]:= _aGMs[_nx][12] + TRA1->D2_VALIPI
			_aGMs[_nx][15]:= _aGMs[_nx][15] + TRA1->D2_QUANT
			_aGMs[_nx][20]:= _aGMs[_nx][20] + TRA1->D2_DESC
			_aGMs[_nx][21]:= _aGMs[_nx][21] + TRA1->D2_DESCON
			_aGMs[_nx][23]:= _aGMs[_nx][23] + TRA1->D2_BASEICM
		Else
			Aadd(_aGMs,{TRA1->D2_DOC,;
						TRA1->D2_SERIE,;
						TRA1->D2_CLIENTE,;
						TRA1->D2_LOJA,;
						TRA1->D2_COD,;
						TRA1->D2_EMISSAO,;
						TRA1->D2_ITEM,;
						TRA1->D2_TOTAL,;
						TRA1->D2_CF,;
						TRA1->D2_VALICM,;
						TRA1->D2_TES,;
						TRA1->D2_VALIPI,;
						TRA1->A7_CODCLI,;
						TRA1->A7_PCCLI,;
						TRA1->D2_QUANT,;
						TRA1->D2_UM,;
						TRA1->B1_POSIPI,;
						TRA1->D2_IPI,;
						TRA1->D2_PRCVEN,;
						TRA1->D2_DESC,;
						TRA1->D2_DESCON,;
						TRA1->D2_PICM,;
						TRA1->D2_BASEICM,;
						TRA1->C5_PBRUTO})
		Endif
		
	EndIf
	
	XDBF->(DbSkip())
	TRA1->(DbSkip())
	
EndDo

nFTP  := 1
_lEmb := .F. //verifica se gerou o aviso de embarque
_cDoc :=  Space(06)


For _nx:= 1 to len(_aGMs)
	
	_lEmb := .T. //verifica se gerou o aviso de embarque
	
	/* Gravação do Segmento GM1 */
	RecLock("GM1",.T.)
	GM1->IdentSeg  := "GM1"
	GM1->NumAsn    := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,2)),1) // Número do ASN
	GM1->FuncMen   := "9" 				  					                    	    	            // Função da Mensagem
	GM1->PeBru 	   := StrZero(_aGMs[_nx][24],12)   					        	                        // Peso Bruto
	GM1->UnMePeBr  := _aGMs[_nx][16]	                									            // Unidade de Medida Peso Bruto
	GM1->PeLi 	   := StrZero(_aGMs[_nx][24],12)                                                        // Peso Líquido
	GM1->UnMePeLi  := _aGMs[_nx][16]                  			    		                            // Unidade de Medida Peso líquido
	GM1->TotEmb    := StrZero(_aGMs[_nx][15],9)     					    		                    // Qtde total do embarque
	GM1->NumTrans  := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,2)),1) // Número da Transportador
	GM1->UnMeQem   := _aGMs[_nx][16]                   						                            // Unidade de Medida da quantidade embarcada
	GM1->Esp 	   := Space(58)
	MsUnlock("BGM")
	
	fWrite(cArq,(GM1->(IdentSeg+NumAsn+FuncMen+PeBru+UnMePeBr+PeLi+UnMePeLi+TotEmb+NumTrans+UnMeQem+Esp)+cNovaLinha))
	nFtp += 1
	
	/* Gravação do Segmento GM1 */
	RecLock("GM2",.T.)
	GM2->IdentSeg  	:= "GM2"
	GM2->QualEqui 	:= "TE"
	GM2->IdentEquip := "RODOVIARIO"
	GM2->Esp 		:= space(105)
	MsUnlock("GM2")
	
	fWrite(cArq,(GM2->(IdentSeg+QualEqui+IdentEquip+Esp)+cNovaLinha))
	nFtp += 1
	
	//---------------  SEGMENTO AE1v0 - COMPLEMENTO DADOS DA NF
	_cNotas := ALLTRIM(_cNotas) +" "+ _aGMs[_nx] [1] + CRLF                //documento
	If _cDoc <> _aGMs[_nx][1]                                              // Para não gerar o Segmento AE1 quando for a mesma nota fiscal

		RecLock("AE1",.T.)
		AE1->IdentSeg   := "AE1"
		AE1->NumNF      := Subs(_aGMs[_nx][1],4,6)
		AE1->SerNF      := Subs(_aGMs[_nx][2],1,2)
		AE1->DataNF     := Subs(_aGMs[_nx][6],3,6)
		AE1->QItNf      := StrZero(Val(_aGMs[_nx][7]),3)
		
		AE1->VlToNF     := StrZero(_aGMs[_nx][8],17,2)
		AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"")     //elimina o ponto
		AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")                      // Insere o primeiro caracter
		
		AE1->QCDec      := "0"                                             // QTDE de casas decimais
		AE1->CFO        := _aGMs[_nx][9]                                   // Alterado D2_CF
		AE1->VlToICM    := StrZero(_aGMs[_nx][10],17,2)
		AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"")   //elimina o ponto
		AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")                     // Insere o primeiro caracter
		AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
		AE1->EspNF      := iif(Alltrim(_aGMs[_nx][11]) == "613","02","00")
		AE1->VlIPI      := StrZero(_aGMs[_nx][12],17,2)
		AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"")       //elimina o ponto
		AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")                       // Insere o primeiro caracter
		
		If _aGMs[_nx][3]+_aGMs[_nx][4] == "90000402"

			AE1->CodFabEn   := "4J "

		ElseIf _aGMs[_nx][3]+_aGMs[_nx][4] == "90002402"

			AE1->CodFabEn   := "4J "

		ElseIf _aGMs[_nx][3]+_aGMs[_nx][4] == "90002403"

			AE1->CodFabEn   := "09 "

		Else

			Aviso("ASN - General Motors | Atenção","Foi Selecionada uma Nota Fiscal que nao e da GM, Favor Rodar Novamente o Aviso de Embarque.", {"OK"},2)				
			_nFTP := 0
			exit                                                              //forca a saida do programa

		Endif
		
		AE1->DataPrNF   := iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
		AE1->IdentPer   := "0000"
		AE1->DescCfop   := Space(20)
		AE1->Espaco     := Space(10)
		MsUnlock("AE1")
		
		FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+Espaco)+cNovaLinha))
		nFTP += 1  //Controle de qtde de segmentos

	Endif

	_cDoc := _aGMs[_nx][1]                                              // armazena a NF para controle do Segmento AE1 nao gerar repetido no arquivo EDI
	
	// Retira os espacos do codigo do produto
	cCod := _aGMs[_nx][13]                                              //Codigo da amarracao prod x cliente
	nAux := AT(" ",cCod)

	While nAux <> 0
		
		cCod := Stuff(cCod,nAux,1,"")
		nAux := AT(" ",cCod)
		
	Enddo
	
	// SEGMENTO AE2v0 - DADOS DO ITEM
	Reclock("AE2",.T.)
	AE2->IdentSeg    := "AE2"
	AE2->NumItNF     := StrZero(Val(_aGMs[_nx][7]),3)
	AE2->NumPed      := _aGMs[_nx][14]
	
	AE2->CodItem     := Alltrim(cCod)
	
	AE2->QINF        := StrZero(_aGMs[_nx][15],9,0)
	AE2->UnMedNF     := _aGMs[_nx][16]
	AE2->CodClasF    := _aGMs[_nx][17]
	
	cIPI             := StrZero(_aGMs[_nx][18],5,2)
	AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"")                   //elimina o ponto
	
	AE2->VlItem      := StrZero(_aGMs[_nx][19],17,2)                    //preco unitario
	AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"")     //elimina o ponto
	AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")                      // Insere o primeiro caracter
	
	AE2->QItEst      := StrZero(_aGMs[_nx][15],9,0)
	
	AE2->UnMedEs     := _aGMs[_nx][16]
	AE2->QtUniCom    := StrZero(_aGMs[_nx][15],9,0)
	AE2->UnMedCo     := _aGMs[_nx][16]
	AE2->CodTpFo     := "P"                                             // P= Producao
	
	cDesc             := StrZero(_aGMs[_nx][20],5,2)
	AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"")                 //elimina o ponto
	
	AE2->VlToDes     := StrZero(_aGMs[_nx][21],17,2)
	AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"")   //elimina o ponto
	AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")                     // Insere o primeiro caracter
	AE2->Espaco      := Space(01)
	
	MsUnlock("AE2")
	
	FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
	// SEGMENTO GM3v0 - DADOS ADICIONAIS DO ITEM GM.
	RecLock("GM3",.T.)
	GM3->IdentSeg:= "GM3"
	GM3->UnAcu   := "UN "
	GM3->QtdeEmb := StrZero(_aGMs[_nx][15],12)
	GM3->AnoReg  := Subs(Dtos(dDatabase),1,4)                           //Str(Year(Database))
	GM3->Espaco  := Space(106)
	MsUnlock("GM3")
	
	FWrite(cArq,(GM3->(IdentSeg+UnAcu+QtdeEmb+AnoReg+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
	// SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.
	RecLock("AE3",.T.)
	AE3->IdentSeg := "AE3"
	AE3->IdentFat := Repl("0",14)
	AE3->IdentCob := Repl("0",14)
	AE3->IdentEnt := _cDoca //Space(14)
	AE3->TipTrans := "RODO"
	AE3->Espaco   := Space(79)
	MsUnlock("AE3")
	
	FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+TipTrans+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
Next _nx

If nFTP > 1
	
	// SEGMENTO FTPv0 - Segmento Final Mensagem
	nFTP += 1                                                           //Controle de qtde de segmentos
	RecLock("FTP",.T.)
	FTP->IdentSeg := "FTP"
	FTP->NumCont  := "00000"
	FTP->QtdeSeg  :=StrZero(nFTP,9)
	FTP->NumToVl  :="00000000000000000"
	FTP->CatOper  := Space(01)
	FTP->Espaco   := Space(93)
	MsUnlock("FTP")
	
	FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))
	FClose(cARQ)
 
	Aviso("ASN - General Motors | Atenção","Aviso de embarque gerado com sucesso."+CRLF+;
                       "Nota Fiscal No: "+AE1->NumNF+CRLF+;
                       "Serie da Nota : "+AE1->SerNF+CRLF+;
                       "Data  da  Nota: "+subs(_aGMs[1][6],7,2)+"/"+subs(_aGMs[1][6],5,2)+"/"+subs(_aGMs[1][6],1,4), {"OK"},2)	

Else
	
	FClose(cARQ)
	fErase(cArQEXP)                                                     // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	
Endif

//Close(oDlg)
TRA1->(DbCloseArea())
XDBF->(DbCloseArea())
GM1->(DbCloseArea())
GM2->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
GM3->(DbCloseArea())
AE3->(DbCloseArea())
FTP->(DbCloseArea())

Return

Static Function fCriaDBF()

/*****************************************************
 Criando Arquivos Temporarios para posterior impressao
******************************************************/
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}

aAdd(_aITP,{"IdentSeg"   ,"C", 03,0})
aAdd(_aITP,{"NumComu"    ,"C", 03,0})
aAdd(_aITP,{"NumVer"     ,"C", 02,0})
aAdd(_aITP,{"NumCont"    ,"C", 05,0})
aAdd(_aITP,{"IdentGer"   ,"C", 12,0})
aAdd(_aITP,{"IdentTra"   ,"C", 14,0})
aAdd(_aITP,{"IdentRec"   ,"C", 14,0})
aAdd(_aITP,{"CodIntTr"   ,"C", 08,0})
aAdd(_aITP,{"CodIntRe"   ,"C", 08,0})
aAdd(_aITP,{"NomTrans"   ,"C", 25,0})
aAdd(_aITP,{"NomRece"    ,"C", 25,0})
aAdd(_aITP,{"Espaco"     ,"C", 09,0})

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.)

// Monta o Arquivo Temporário do ITP
RecLock("ITP",.T.)
ITP->IdentSeg  := "ITP"
ITP->NumComu   := "ASN"
ITP->NumVer    := "00"
ITP->NumCont   := Space(05)
cDtaHor        := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")   // DATA+HHMMSS
ITP->IdentGer  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")                           // DATA+HHMMSS tira o segundo :
ITP->IdentTra  := IIF(SM0->M0_CODIGO == "NH","73355174000140","01261681000104") // CGC DO FORNECEDOR
ITP->IdentRec  := _cCGC
ITP->CodIntTr  := space(08)
ITP->CodIntRe  := "AT&T    "
ITP->NomTrans  := SubStr(AllTrim(SM0->M0_NOMECOM),1,25)
ITP->NomRece   := "GENERAL MOTORS DO BRASIL "
ITP->Espaco    := Space(09)
MsUnlock("ITP")

fWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentGer+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha))

nFtp += 1
DbSelectArea("ITP")
ITP->( DbCloseArea() )

// Segmento GM1v0 - Dados do ASN GM (1 em cada ITP)
_cArqGM1 := CriaTrab(NIL,.f.)
_cArqGM1 += ".DBF"
aGM1 := {}

aAdd(aGM1,{"IdentSeg"    ,"C",03,0})
aAdd(aGM1,{"NumAsn"      ,"C",12,0})
aAdd(aGM1,{"FuncMen"     ,"C",01,0})
aAdd(aGM1,{"PeBru"    	 ,"C",12,0})
aAdd(aGM1,{"UnMePeBr"    ,"C",03,0})
aAdd(aGM1,{"PeLi"      	 ,"C",12,0})
aAdd(aGM1,{"UnMePeLi"    ,"C",03,0})
aAdd(aGM1,{"TotEmb"      ,"C",09,0})
aAdd(aGM1,{"NumTrans"    ,"C",12,0})
aAdd(aGM1,{"UnMeQEm"     ,"C",03,0})
aAdd(aGM1,{"Esp"         ,"C",58,0})

DbCreate(_cArqGM1,aGM1)
DbUseArea(.T.,,_cArqGM1,"GM1",.F.)

// Segmento GM2v2 - Dados do Equipamento Utilizado
_cArqGM2 := CriaTrab(NIL,.F.)
_cArqGM2 += ".DBF"
aGM2 := {}

aAdd(aGM2,{"IdentSeg"   ,"C",03,0})
aAdd(aGM2,{"QualEqui"   ,"C",03,0})
aAdd(aGM2,{"IdentEquip" ,"C",17,0})
aAdd(aGM2,{"Esp"        ,"C",105,0})

DbCreate(_cArqGM2,aGM2)
DbUseArea(.T.,,_cArqGM2,"GM2",.F.)

// Segmento AE1
_cArqgAE1:= CriaTrab(NIL,.f.)
_cArqgAE1+= ".DBF"
_gAE1    := {}
AADD(_gAE1,{"IdentSeg"   ,"C", 03,0})
AADD(_gAE1,{"NumNF"      ,"C", 06,0})
AADD(_gAE1,{"SerNF"      ,"C", 04,0})
AADD(_gAE1,{"DataNF"     ,"C", 06,0})
AADD(_gAE1,{"QItNf"      ,"C", 03,0})
AADD(_gAE1,{"VlToNF"     ,"C", 17,2})
AADD(_gAE1,{"QCDec"      ,"C", 01,0})
AADD(_gAE1,{"CFO"        ,"C", 03,0})
AADD(_gAE1,{"VlToICM"    ,"C", 17,2})
AADD(_gAE1,{"DataVen"    ,"C", 06,0})
AADD(_gAE1,{"EspNF"      ,"C", 02,0})
AADD(_gAE1,{"VlIPI"      ,"C", 17,2})
AADD(_gAE1,{"CodFabEn"   ,"C", 03,0})
AADD(_gAE1,{"DataPrNF"   ,"C", 06,0})
AADD(_gAE1,{"IdentPer"   ,"C", 04,0})
AADD(_gAE1,{"DescCfop"   ,"C", 20,0})
AADD(_gAE1,{"Espaco"     ,"C", 10,0})

DbCreate(_cArqgAE1,_gAE1)
DbUseArea(.T.,,_cArqgAE1,"AE1",.F.)

// SEGMENTO AE2v0 - DADOS DO ITEM
_cArqgAE2:= CriaTrab(NIL,.f.)
_cArqgAE2+= ".DBF"
_gAE2    := {}
AADD(_gAE2,{"IdentSeg"   ,"C", 03,0})
AADD(_gAE2,{"NumItNF"    ,"C", 03,0})
AADD(_gAE2,{"NumPed"     ,"C", 12,0})
AADD(_gAE2,{"CodItem"    ,"C", 30,0})
AADD(_gAE2,{"QINF"       ,"C", 09,0})
AADD(_gAE2,{"UnMedNF"    ,"C", 02,0})
AADD(_gAE2,{"CodClasF"   ,"C", 10,0})
AADD(_gAE2,{"AliIPI"     ,"C", 04,2})
AADD(_gAE2,{"VlItem"     ,"C", 12,2})
AADD(_gAE2,{"QItEst"     ,"C", 09,0})
AADD(_gAE2,{"UnMedEs"    ,"C", 02,0})
AADD(_gAE2,{"QtUniCom"   ,"C", 09,0})
AADD(_gAE2,{"UnMedCo"    ,"C", 02,0})
AADD(_gAE2,{"CodTpFo"    ,"C", 01,0})
AADD(_gAE2,{"QtPerDe"    ,"C", 04,2})
AADD(_gAE2,{"VlToDes"    ,"C", 11,2})
AADD(_gAE2,{"Espaco"     ,"C", 05,0})

DbCreate(_cArqgAE2,_gAE2)
DbUseArea(.T.,,_cArqgAE2,"AE2",.F.)

// Segmento GM3v0 - DADOS ADICIONAIS DO ITEM GM
_cArqGM3 := CriaTrab(NIL,.F.)
_cArqGM3 += ".DBF"
aGM3 := {}

aAdd(aGM3,{"IdentSeg", "C" , 03,0})
aAdd(aGM3,{"UnAcu"   , "C" , 03,0})
aAdd(aGM3,{"QtdeEmb" , "C" , 12,0})
aAdd(aGM3,{"AnoReg"  , "C" , 04,0})
aAdd(aGM3,{"Espaco"  , "C" , 126,0})

DbCreate(_cArqGM3,aGM3)
DbUseArea(.T.,,_cArqGM3,"GM3",.F.)

// SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.
_cArqAE3 := CriaTrab(NIL,.F.)
_cArqAE3 += ".DBF"
aAE3 := {}

aAdd(aAE3,{"IdentSeg", "C" , 03,0})
aAdd(aAE3,{"IdentFat", "C" , 14,0})
aAdd(aAE3,{"IdentCob", "C" , 14,0})
aAdd(aAE3,{"IdentEnt", "C" , 14,0})
aAdd(aAE3,{"TipTrans", "C" , 04,0})
aAdd(aAE3,{"Espaco"  , "C" , 79,0})

DbCreate(_cArqAE3,aAE3)
DbUseArea(.T.,,_cArqAE3,"AE3",.F.)

// SEGMENTO FTPv0 - Segmento Final Mensagem
_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}

AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})
AADD(_aFTP,{"NumCont"    ,"C", 05,0})
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})
AADD(_aFTP,{"NumToVl"    ,"C", 17,0})
AADD(_aFTP,{"CatOper"    ,"C", 01,0})
AADD(_aFTP,{"Espaco"     ,"C", 93,0})

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.)

// Segmento para mostrar no browse
_cArqDBF  := CriaTrab(NIL,.f.)
_aDBF := {}

AADD(_aDBF,{"OK"         ,"C", 02,0})
AADD(_aDBF,{"Nota"       ,"C", 09,0})
AADD(_aDBF,{"Serie"      ,"C", 03,0})
AADD(_aDBF,{"Dta"        ,"C", 10,0})
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})
AADD(_aDBF,{"Total"      ,"N", 17,2})
AADD(_aDBF,{"Espaco"     ,"C", 63,0})

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDBF",.F.)

INDEX ON XDBF->NOTA TO (_carqDBF)

Return

User Function fLegGM()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
{ "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

//marca todas as notas
User Function fMarcagm()

XDBF->(DbGoTop())
While !XDBF->(eof())
	
	RecLock("XDBF")
	XDBF->OK := cMarca
	MsUnlock("XDBF")
	XDBF->(Dbskip())

Enddo

MarkBRefresh()

Return

//desmarca todas as notas
User Function fDesMargm()

XDBF->(DbGoTop())
While !XDBF->(eof())
	
	RecLock("XDBF")
	XDBF->OK := "  "
	MsUnlock("XDBF")
	XDBF->(Dbskip())

Enddo

MarkBRefresh()

Return
