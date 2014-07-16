/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MT100LOK ³ Autor ³  Alexandre R. Bento  ³ Data ³ 27/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ VALIDACAO ADICIONAL PARA ITEM NT ENTRADA	(almox e NCM )    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para Controle na digitacao da NF c/ almoxarifado em branco ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function MT100LOK()

Local _nCod    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})
Local _cLocal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_LOCAL"})
Local _cNCM    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_NCM"})
Local _cLote   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_LOTECTL"})
Local _cPedido := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_PEDIDO"})
Local _cItem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_ITEMPC"})
Local _nConta  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CONTA"})
Local _cTES    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TES"})
Local _cCF     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CF"})
Local _cTipo   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TP"})
Local _nCC     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CC"})
Local _nQtde   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_QUANT"})
Local _nCFis   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CLASFIS"})
Local _nIPI    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_IPI"})
Local _nTot    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TOTAL"})
Local _nUnit   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_VUNIT"})
Local _nNFOri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_NFORI"})
Local _nSerOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_SERIORI"})
Local _nItOri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_ITEMORI"})

Local _lRet   := .T.
Local _lAux   := .F.
Local _lFolTer:= .F.
Local _lEmpre := .F.
Local _nRecSC7, _nIndSC7
Local _nQuant := 0
Local CRLF    := chr(13)+chr(10)

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
	
	// OS 059796
	If date() < CtoD("06/01/2014") .AND. aCols[n][_cLocal]$"31"
		SC7->(dbsetorder(1))//filial + num + item
		If SC7->(dbseek(xFilial('SC7')+aCols[n][_cPedido]+aCols[n][_cItem]))
			If ALLTRIM(SC7->C7_SIGLA)$"MTP"
				Alert("SIGLA MTP - ENTRADA BLOQUEADA PELA MANUTENÇÃO!")
				Return .F.
			Endif
		Endif
	Endif
	// FIM OS 059796
	
	/******************* INVENTARIO *******************/
	//Verifica se produto está bloqueado para inventário
	If !aCols[n][len(aHeader)+1]
		If !U_E205BLQ(Acols[n][_nCod],Acols[n][_cLocal])
			_lRet := .F.
		EndIF
	EndIf
	/**************************************************/
	
	//-- VALIDAÇÃO NO ARMAZEM (PERNAMBUCO)
	//-- ADICIONADO EM 21/11/13 - DOUGLAS DOURADO
	
	//-- ATENÇÃO: SE FOR ADICIONAR ALGUM PRODUTO NA EXCEÇÃO, FALAR ANTES COM ERICA OU HESSLER, ISTO É UM PEDIDO DOS MESMOS
	/*
	If SM0->M0_CODIGO$"FN" .AND. Alltrim(SM0->M0_CODFIL)$"02" .AND. !Substr(Alltrim(Acols[n][_cLocal]),1,1)$"5"
	
	If Alltrim(Acols[n][_nCod])$"VWB01.3.0210.00/VWB01.3.0210.02/VWB03.4.0208.01/VWB03.4.0208.02"
	IF !Alltrim(Acols[n][_cLocal])$"36/37"
	MsgBox( "Na filial Pernambuco, o produto "+Alltrim(Acols[n][_nCod])+" só pode ser utilizado nos armazens 36 e 37 !", "P.E. MT100LOK ", "ALERT" )
	Return .F.
	ENDIF
	ELSE
	MsgBox( "Armazém NÃO começando com 5 NÃO pode ser utilizado na filial Pernambuco ! ", "P.E. MT100LOK ", "ALERT" )
	Return .F.
	EndIf
	
	EndIf
	*/
	//-- FIM VALIDAÇÃO
	
	//-- OS: 067251
	If Subs(Alltrim(Acols[n][_nCod]),1,4)$"PQ32" .And. Alltrim(Acols[n][_cCF])$"1556/2556"
		MsgBox("O grupo PQ32 é considerado compra para industrialização,favor utilizar TES apropriada!!!","Atencao","ALERT")
		_lRet := .F.
	Endif
	//-- FIM OS 067251
	
	//-- OS Nº: 044447
	If SM0->M0_CODIGO$"FN" .AND. aCols[n][_cLocal]$"35"
		MsgBox( "Armazém não pode ser utilizado! Armazém substituído pelo armazém 3F!", "P.E. MT100LOK (OS 044447)", "ALERT" )
		Return .F.
	Endif
	//FIM OS 044447
	
	
	If SM0->M0_CODIGO$"IT"
		
		//-- solicitado por valdelenems 06/01/2014
		SB1->(DbSetOrder(1)) //filial+cod
		SB1->(DbSeek(xFilial("SB1")+Acols[n][_NCOD]))
		
		IF SB1->B1_GRUPO$"FE31/FE32/FE33/FE35" .AND. ACOLS[n][_cLocal]$"31"
			Alert("Armazém não permitido, favor utilizar armazém 35!")
			return .f.
		Endif
		
	Endif
	
	
	If Acols[n][_nTot] <= 0 //Não permite que entre NF com valor zero
		MsgBox("Valor Total da Nota Zerado, Verifique !!!","Atencao","ALERT")
		Return(.F.)
	Endif
	
	If cTipo$"N"  // Nota do tipo normal
		If Acols[n][_nQtde] <= 0 .Or. Acols[n][_nUnit]  <= 0 //Não permite que entre NF com valor zero
			MsgBox("Valor Total da Nota Zerado, Verifique !!!","Atencao","ALERT")
			Return(.F.)
		Endif
		
		//-- chamado 033092
		If AllTrim(ACOLS[n][_cTES])$"127/124/059/060/061/125/128/129" .AND. !ALLTRIM(CESPECIE)=="NFS"
			MsgBox("Nota de serviço, favor lançar especie NFS","Atencao","ALERT")
			Return .F.
		Endif
		//-- fim chamado 033092
		
	Endif
	
	SF4->(DbSetOrder(1)) // Filial + pedido + item
	SF4->(DbSeek(xFilial("SF4")+Acols[n][_cTES]))
	
	If !Empty(Acols[n][_cPedido])
		If Alltrim(Acols[n][_nCC])$"ALMOXI/ALMOXARI"
			If !SF4->F4_ESTOQUE$"S"
				MsgBox("Divergencia entre Centro de Custo e TES, Verifique !!!","Atencao","ALERT")
				Return(.F.)
			Endif
		Else
			If SF4->F4_ESTOQUE$"S"
				MsgBox("Divergencia entre Centro de Custo e TES, Verifique !!!","Atencao","ALERT")
				Return(.F.)
			Endif
			
		Endif

		If !SF4->F4_DUPLIC$"S"
			MsgBox("Utilizar TES Apropriada para Operacao, Verifique !!!","Atencao","ALERT")
			Return(.F.)
		Endif

	Endif
	
	
	//-- OS Nº: 020835
	//-- DESC: para produtos do grupo EB02 que gerem duplicatas não permitir CFOP 1101 E 2101
	//-- Data: 25/07/2011
	//-- Autor: João Felipe da Rosa
	SB1->(dbsetorder(1))
	SB1->(dbseek(xFilial("SB1")+aCols[n][_nCod]))
	
	If ALLTRIM(SB1->B1_GRUPO)$"EB32" .and. SF4->F4_DUPLIC$"S"
		If Alltrim(Acols[n][_cCF])$"1101/2101"
			Alert("Lançar os produtos do grupo EB32 como aquisição de imobilizado!")
			Return .F.
		Endif
	Endif
	
	If SF4->F4_CF$"1252/2252" .And. !Alltrim(CESPECIE)$"NFCEE"
		Alert("Especie Incorreta, Utilize Especie NFCEE!")
		Return .F.
	Endif
	
	If ALLTRIM(SB1->B1_TIPO)$GetMv("MV_MT100LO") //Não permite entrar o tipo do produto declarado no parametro
		Alert("Proibido o Lançamento de Produtos com o Tipo MX, Falar com Leandro Almoxarifado!")
		Return .F.
	Endif
	
	
	//-- Fim OS 020835
	
	//   If Alltrim(Acols[n][_cTES])$"127" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM"
	//      MsgBox("Serviços voltados ao imobilizado não geram crédito de PIS/COFINS, utilize TES apropriada!!!","Atencao","ALERT")
	//      _lRet   := .F.
	//   Endif
	
	//Gerar a seguinte mensagem: " CENTRO DE CUSTO E TES INCOMPATIVEIS, UTILIZE "TES" APROPRIADA!!!
	//   If Alltrim(Acols[n][_cTES])$"124" .And. !Alltrim(Substring(Acols[n][_nCC],1,1))$"1" .And. !Subs(Alltrim(Acols[n][_nCod]),1,4)$"SA10" .And. !cTipo$"D"
	//      If !Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM"
	//	      MsgBox("CENTRO DE CUSTO E TES INCOMPATIVEIS, UTILIZE TES APROPRIADA!!!","Atencao","ALERT")
	//          _lRet   := .F.
	//      Endif
	//   Endif
	
	
	If Alltrim(Acols[n][_nCod])$"SA40.000001" .And. !Alltrim(Acols[n][_cTES])$"125/128/129"
		MsgBox(" Locações Devem ser Lançadas com a TES 125, 128 ou 129 !!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	
	
	If Alltrim(Acols[n][_cTES])$"127" .And. Alltrim(Substring(Acols[n][_nCC],1,1))$"1"
		MsgBox("CENTRO DE CUSTOS ADMINISTRATIVOS NÃO GERAM CRÉDITO DE PIS/COFINS, UTILIZE TES APROPRIADA","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CESPECIE)$"CTR/CTE" .And. SF4->F4_ESTOQUE$"S"
		SB2->(DbSetOrder(1)) // Filial + cod + local
		SB2->(Dbseek(xFilial("SB2")+Acols[n][_nCod]+Acols[n][_cLocal] ))
		If SB2->B2_QATU <= 0
			MsgBox("Não é Permitido Lançar Fretes em Produtos com Saldo de Estoque Zero","Atencao","ALERT")
			_lRet   := .F.
		Endif
	Endif
	
	If Subs(Alltrim(Acols[n][_nCod]),1,2)$"MD" .And. Alltrim(Acols[n][_cCF])$"1556/2556"
		MsgBox("O grupo MD é considerado compra para industrialização,favor utilizar TES apropriada!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(Acols[n][_cCF])$"1556/2556"
		MsgBox("Material Destinado ao Imobilizado, Favor Utilizar TES apropriada!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If cTipo$"N" .And. Alltrim(Acols[n][_nCod])$"MP01.000002/MP01.000003/MP01.000004/MP01.000013/MP01.000014/MP01.000015/MP01.000028/MP01.000029/MP01.000031/MP01.000033/MP01.000034/MP01.000037" .And.;
		!SF4->F4_CODIGO$"051/242/217/218"
		MsgBox("SUCATAS NÃO GERAM CREDITO DE PIS/COFINS CFE ART. 47 DA LEI 11.196/05","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(Acols[n][_cTES])$"480/481/482/485/486/487/489/164"
		MsgBox("Alterar a Base de Calculo do PIS e da COFINS para a Seguinte Condição: VALOR TOTAL - (MENOS) O VALOR DE ICMS","Atencao","ALERT")
	Endif
	
	//Criar o seguinte bloqueio: nas entradas de fretes sempre que o produto começar com "IM" permitir somente os TES 104/263/164
	If Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(CESPECIE)$"CTR/CTE" .And. !Alltrim(Acols[n][_cTES])$"104/263/164/165"
		MsgBox("Para Notas de Fretes usar TES 104, 263, 164 ou 165","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(Acols[n][_cTES])$"216"
		MsgBox("Verifique se Esse Material Trata-se de IMOBILIZADO!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(Acols[n][_cTES])$"104"
		MsgBox("Esta TES Só Pode Ser Utilizada Para Produtos Imobilizado ","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(Acols[n][_nCod])$"SA40.000001" .And. !Alltrim(Acols[n][_cTES])$"125/128/129"
		MsgBox("Locaçoes Devem ser lançadas com a TES 125, 128 ou 129","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If SF4->F4_CREDIPI$"S" .And. Acols[n][_nIPI] == 0
		MsgBox("O Percentual de IPI esta Zerado e a TES Credita IPI, Verifique !!!","Atencao","ALERT")
		Return(.F.)
	Endif
	
	If Alltrim(Acols[n][_nConta])$"401030050018" .And. !SF4->F4_PISCOF$"4"
		MsgBox("Atencao Esta Conta Contabil so Pode Ser Utilizada com TES que nao Considera o Pis e Cofins","Atencao","ALERT")
		_lRet   := .F.
		Return(.F.)
	Endif
	
	/*
	Bloqueio de conta contabil para entrada de notas - Solicitante: Ana Paula Palhuca
	*/
	
	If SM0->M0_CODIGO$"FN/NH" //.And. !_lRet
	  
		SB1->(DbSetOrder(1)) //filial+cod
		SB1->(DbSeek(xFilial("SB1")+Acols[n][_nCod]))
		
		SF4->(DbSetOrder(1)) // Filial + pedido + item
		SF4->(DbSeek(xFilial("SF4")+Acols[n][_cTES]))

		/*
		  Bloqueio RH - Solicitante: Marcio Thomann Stoco 
		*/
		/*
		If SB1->B1_TIPO$"MS"
			If DDataBase >= Ctod('13/05/2014') .and. DDataBase <= Ctod('31/05/2014') .and. !Alltrim(upper(cUsername))$"LUIZWJ" .and. SF4->F4_DUPLIC$"S"
				Aviso("Documento de Entrada | Atenção","A entrada de nota fiscal de mercadorias do tipo MS está bloqueada pela Controladoria / Gerência RH.", {"OK"},2)					
				_lRet   := .F.
			Else
				_lRet   := .T.
			Endif
		Endif
		*/

		//*****************************************************//
		// No tipo MM e almoxarifado 21 tem verba para entrar produtos
		/*
		If SB1->B1_TIPO$"MM" .And. Acols[n][_cLocal]$"21" 
			_lAux := .T.		
		Endif
		*/

		//If SB1->B1_TIPO$"MS/PQ/ML/MK/ME/MD/MM" .and. !Alltrim(Acols[n][_nCod])$"ML01.000013" .or. Alltrim(Acols[n][_nConta])$"401020020012/401020020010/401020020006/401020020007/401030010003/401030010004/401030010005/401030010006/401030010007/401030010008/401030010009/401030020002/401030020003/401030020004/401030050014/401030020005/401030020006/401030040001/401030040002/401030040003/401030040004/401030050003/401030050004/401030050005/401030050006/401030050007/401030050009/401030050010/401030050012/401030050013/401030050015/401030010012/401030050019/401030050021/401020010003/401020020002/401020020009/401030010002/401030050018/401030010010/401020020003"
		//If SB1->B1_TIPO$"MS/PQ/ML/MK/ME/MD/MG"  .and. (SB1->B1_TIPO$"MM" .and. !aCols[n][_cLocal]$"21") .and. !Alltrim(Acols[n][_nCod])$"ML01.000013" .or. Alltrim(Acols[n][_nConta])$"401020020012/401020020010/401020020006/401020020007/401030010003/401030010004/401030010005/401030010006/401030010007/401030010008/401030010009/401030020002/401030020003/401030020004/401030050014/401030020005/401030020006/401030040001/401030040002/401030040003/401030040004/401030050003/401030050004/401030050005/401030050006/401030050007/401030050009/401030050010/401030050012/401030050013/401030050015/401030010012/401030050019/401030050021/401020010003/401020020002/401030010002/401030050018/401030010010/401020020003"
		//If !_lAux .And. SB1->B1_TIPO$"MS/PQ/ML/MK/ME/MD/MM/MG" .and. !Alltrim(Acols[n][_nCod])$"ML01.000013" .or. Alltrim(Acols[n][_nConta])$"401020020012/401020020010/401020020006/401020020007/401030010003/401030010004/401030010005/401030010006/401030010007/401030010008/401030010009/401030020002/401030020003/401030020004/401030050014/401030020005/401030020006/401030040001/401030040002/401030040003/401030040004/401030050003/401030050004/401030050005/401030050006/401030050007/401030050009/401030050010/401030050012/401030050013/401030050015/401030010012/401030050019/401030050021/401020010003/401020020002/401030010002/401030050018/401030010010/401020020003"
		If SB1->B1_TIPO$"MS/PQ/ML/MK/ME/MD/MM/MG" .and. !Alltrim(Acols[n][_nCod])$"ML01.000013" .or. Alltrim(Acols[n][_nConta])$"401020020012/401020020010/401020020006/401020020007/401030010003/401030010004/401030010005/401030010006/401030010007/401030010008/401030010009/401030020002/401030020003/401030020004/401030050014/401030020005/401030020006/401030040001/401030040002/401030040003/401030040004/401030050003/401030050004/401030050005/401030050006/401030050007/401030050009/401030050010/401030050012/401030050013/401030050015/401030010012/401030050019/401030050021/401020010003/401020020002/401030010002/401030050018/401030010010/401020020003"
			If DDataBase >= Ctod('14/05/2014') .and. DDataBase <= Ctod('31/05/2014') .and. !Alltrim(upper(cUsername))$"LUIZWJ" .and. SF4->F4_DUPLIC$"S" // .and. !_lAux
				//Aviso("Documento de Entrada | Atenção","A entrada de nota fiscal para esta conta contabil está bloqueada pela Controladoria.", {"OK"},2)					
				Aviso("Documento de Entrada | Atenção","A entrada desta nota fiscal está bloqueada pela Controladoria.", {"OK"},2)									
				//MsgBox("Atencao A Entrada de NF para Esta Conta Contabil Esta BLOQUEADA pela Controladoria.","Atencao","ALERT")
				_lRet   := .F.
			Endif
		Endif
		
	Endif
	
	If Subs(Alltrim(Acols[n][_nCod]),1,2)$"MX/MS/ML/MK/CT" .And. SF4->F4_DUPLIC$"S" .And. !SF4->F4_PISCOF$"4" .And. Len(Alltrim(Acols[n][_nCod])) < 14
		MsgBox("Atencao Material nao da direito a Credito de PIS/COFINS, Verifique!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If CFORMUL$"N" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"MQ/MM/MG/KZ" .And. SF4->F4_DUPLIC$"S" .And. !SF4->F4_PISCOF$"3"
		MsgBox("Atencao MATERIAL GERA CREDITO DE PIS E COFINS, UTILIZE TES APROPRIADA! Verifique!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. !SF4->F4_PISCOF$"4" .And. !Alltrim(Acols[n][_nCod])$"IM02.000001/IM11.000001"
		MsgBox("Atencao Compras p/ o Imobilizado não Geram Credito de PIS/COFINS, verifique a TES!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If SF4->F4_CIAP$"S" .And. Alltrim(Acols[n][_nCod])$"IM19.000690/IM19.000362/IM19.000014/IM19.000015/IM19.000018/IM19.000021/IM19.000024/IM19.000025/IM19.000026/IM19.000028/IM19.000029/IM19.000030/IM19.000031/IM19.000134/IM19.000161/IM19.000162IM19.000186/IM19.000249/IM19.000266/IM19.000309/IM19.000253/IM19.000408/IM19.000428/IM19.000427/IM19.000422/IM19.000416/IM19.000436"
		MsgBox("Atencao Produtos de Construcao Civil nao Gera Credito de ICMS, Selecione TES Adequada!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	
	If SF4->F4_DUPLIC$"S" .And. !SF4->F4_PISCOF$"3" .And. Alltrim(Acols[n][_nCod])$"IM02.000001/IM11.000001"
		MsgBox("Atencao Produtos com créditos de PIS/COFINS, selecione uma das TES: 480/481/482/485/487/488, verifique a TES!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Subs(Alltrim(Acols[n][_nCod]),1,4)$"EB01/EB02/EB03/EB04/EC01" .And. CA100FOR$"002188/002791/000219/002187"
		MsgBox("Atencao Fornecedor Incompativel com o Produto, Utilizar tipo B, Verifique!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !CFORMUL$"S" .And. NMOEDACOR <>1  .And. !Alltrim(cUserName)$"LUCASPC/ADMINISTRADOR/DAYANACS/LEANDROP/LUIZWJ/LUIZADB/PAMELLASB/SAMUELC"
		MsgBox("Atencao Moeda nao pode Ser Diferente de 1, Verifique!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	//   VERIFICA e grava Situacao tributaria
	//   If Subs(Acols[n][_nCFis],1,1)==" " .Or. Subs(Acols[n][_nCFis],1,2)==" " .Or. Subs(Acols[n][_nCFis],1,3)==" "
	//      Acols[n][_nCFis]:= SF4->F4_SITTRIB
	//   Endif
	
	//   Atender a O.S. 050479
	If Subs(Alltrim(ACOLS[n][_nCFis]),1,1) <> '0' .And. SF4->F4_CF$"1352/2352"
		MsgBox(" Para Fretes Nacionais o Primeiro Caracter do Codigo CST eve ser igual a 0 (Zero)","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	
	//Verifica se a conta Contabil foi alterada na entrada da N.F.
	If Subs(Acols[n][_nConta],1,8)$"10104006/10104007/10104008/10104009" .And. !Alltrim(Acols[n][_cCF])$"1101/2101/3101/1949/2949/3949/1352/2352/1124/2124/1933/2933"
		MsgBox("Atencao Esta Conta Contabil so Pode Ser Utilizada na CFOP 1101/2101/3101/1949/2949/3949/1352/2352/1124/2124/1933/2933","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Alltrim(CESPECIE)$"CTR/CTE" .And. Alltrim(Acols[n][_cCF])$"1352/2352"
		MsgBox("CFOP Incompativel com a Especie do Documento","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CESPECIE)$"CTR/CTE" .And. !Alltrim(Acols[n][_cCF])$"1352/2352"
		MsgBox("CFOP Incompativel com a Especie do Documento","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CESPECIE)$"CTR" .And. !Alltrim(CSERIE)=="U"
		MsgBox("CTR deve ser Serie U Verifique o Documento","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Alltrim(CESPECIE)$"CTR" .And. Alltrim(CSERIE)=="U"
		MsgBox("Para Serie U deve ser Specie CTR Verifique o Documento","Atencao","ALERT")
		_lRet   := .F.
	Endif
	// Criar o seguinte bloqueio nas entradas: Sempre que o campo F1_C103FORM for NÃO e o campo F1_CESPECIE for SPED,
	//o campo F1_CHVNFE de ser diferente de vazio. Esta regra deve ser implantada a partir do dia 19/03/2012
	
	If !CFORMUL$"S" .And. Alltrim(CESPECIE)$"SPED/CTE" .And. Empty(aNfeDanfe[13])
		MsgBox(" Inclua a Chave de Acesso da NF-e","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	//-- os 057544
	
	If !CFORMUL$'S' .AND. Alltrim(CESPECIE)$"SPED/CTE"
		If cTipo$"D/B"  // Nota do tipo devolucao
			CCNPJ := Posicione("SA1",1,xFilial("SA1")+CA100FOR+CLOJA,'A1_CGC')
		Else
			CCNPJ := Posicione("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,'A2_CGC')
		Endif
		
		If !ALLTRIM(cCNPJ)$ALLTRIM(aNfeDanfe[13])
			alert("CNPJ do emitente deve estar contida na CHAVE NFE!")
			Return .F.
		Endif
		
	Endif
	
	//-- fim os 057544
	
	If !CFORMUL$"S" .And. Alltrim(CESPECIE)$"SPED/CTE" .And.( !ALLTRIM(CNFISCAL)$ALLTRIM(aNfeDanfe[13]) .Or. Len(ALLTRIM(aNfeDanfe[13])) != 44) //.And. ALLTRIM(aNfeDanfe[13])$"0/1/2/3/4/5/6/7/8/9"
		MsgBox(" Numero da Nota NÃO Confere Com a Chave de Acesso da NF-e, Favor verificar!!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Empty(Alltrim(CSERIE))
		If Subs(CSERIE,1,1) == " "
			MsgBox("Favor Retirar o Espaço Antes da Serie, Verifique o Documento","Atencao","ALERT")
			_lRet   := .F.
		Endif
	Endif
	
	
	If !cTipo$"B" .And. Alltrim(Acols[n][_cTES])$"293"
		MsgBox("TES Utilizada Somente para Tipo B","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(Acols[n][_cTES])$"127/124/059/060/061/125/128/129" .And. Alltrim(CESPECIE)$"SPED"
		MsgBox("Especie Incompativel Com a TES","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If !Alltrim(Acols[n][_cTES])$"127/124/125/128/059/060/061/129" .And. Alltrim(CSERIE)$"F"
		MsgBox("Serie Incompativel Com a TES","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	
	If Alltrim(Acols[n][_cTES])$"127/124/125/128/129" .And. (Empty(CSERIE) .or. CSERIE$"0/1/2/3/4/5/6/7/8/9")
		MsgBox("Escolha a Serie Apropriada para Notas de Serviços","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CSERIE)$"A/F/G" .And. !Alltrim(Acols[n][_cTES])$"125/124/127/059/061/097/128/129"
		MsgBox("Notas Fiscais de Serviço nao Geram Livro de Entradas Usar TES Adequada","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CSERIE)$"0/00/000"
		MsgBox("Serie Nao Permitida","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If Alltrim(CSERIE)=="NF"
		MsgBox("Serie Nao Permitida","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	
	//Criar bloqueio nas entradas de NF, que somente permita o lançamento de NF com serie "F"
	//somente com as seguintes TES(124/127/059). Quando for lançado diferente deve aparecer a
	// seguinte mensagem: " NOTAS FISCAIS DE SERVIÇO NÃO GERAM LIVRO DE ENTRADAS. USAR "TES" ADEQUADA.
	
	If (Ddatabase - DDEMISSAO) >= 30
		MsgBox("Data de emissão antiga, certifique-se que esta correto!!!","Atencao","ALERT")
	Endif
	
	
	If cTipo$"D" .And. !CFORMUL$"S"
		If SM0->M0_CODIGO == "NH"
			If !Acols[n][_cLocal]$"95"
				MsgBox("Escolher Almoxarifado Apropriado para Devoluções","Atencao","ALERT")
				_lRet   := .F.
			Endif
		ElseIf SM0->M0_CODIGO == "FN"
			If !Acols[n][_cLocal]$"26/36/46/56"
				MsgBox("Escolher Almoxarifado Apropriado para Devoluções","Atencao","ALERT")
				_lRet   := .F.
			Endif
		Endif
	Endif
	
	//Criar bloqueio para as notas de entradas de devolução tipo "D", somente seja permitido o
	//lançamento nos seguintes almoxarifados "Usinagem 95, Fundição 26/36/46/56".
	//Quando for laçando deve aparecer a seguinte mensagem " Escolher almoxarifado apropriado para devoluções"
	
	
	//Criar bloqueio na entrada das NF's de entrada da seguinte forma:
	//- Quando Centro de Custo = ALMOXI, somente permitir TES que atualizem estoque;
	//- Quando Centro de Custo ? ALMOXI, não permitir TES que atualizem estoque.
	
	
	//Fornecedores passados pelo Tadeu da contabilidade p/ nao pedir o pedido de compras
	If SM0->M0_CODIGO$"NH" .And. CA100FOR$"000553/004738/006876"  //libera quando for fornecedor fundicao 000666
		Return(.T.)
	Elseif SM0->M0_CODIGO$"FN" .And. CA100FOR$"002783/002686/002296/000356"  //libera quando for fornecedor WHB 000003
		Return(.T.)
	Endif
	
	If !Alltrim(CESPECIE)$"CTR/CTE" .And. !cTipo$"D" .And. !Empty(ALLTRIM(CNFISCAL)) //Verifica lote quando for nota de // N= normal  B = beneficiamento D= Devoluçao
		SB1->(Dbseek(xFilial("SB1")+Acols[n][_nCod] ))
		If SM0->M0_CODIGO == "NH"
			If Subs(Acols[n][_nCC],1,1)$"5" .And. !SB1->B1_TIPO$"PA/BN" //Usinagem cc inicando com 5
				MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
				_lRet   := .F.
			Endif
		ElseIf SM0->M0_CODIGO == "FN"
			
			//-- os: 054935
			//-- para NF que vem de SC com OS DO ATIVO, permite cc com segundo digito = 5
			
			lSCtemOS := .F.
			
			SC7->(dbsetorder(1))//filial + num + item
			If SC7->(dbseek(xFilial('SC7')+aCols[n][_cPedido]+aCols[n][_cItem]))
				SC1->(dbsetorder(1))//filial + num + item
				If SC1->(dbseek(xFilial('SC1')+SC7->C7_NUMSC+SC7->C7_ITEMSC))
					If !EMPTY(SC1->C1_NUMOS)
						lSCtemOS := .t.
					Endif
				Endif
			Endif
			
			If Subs(Acols[n][_nCC],2,1)$"5" .and. !lSCtemOS .And. !SB1->B1_TIPO$"PA/BN" .And. !Alltrim(Acols[n][_nCod])$"SA10.000005/SA10.000001" //fundicao cc iniciando com 4 ou 5
				MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao (PE: MT100LOK)","ALERT")
				_lRet   := .F.
			Endif
		Endif
	Endif
	
	If Empty(Acols[n][_cLocal])
		MsgBox("Atencao Falta Preencher o Campo Almoxarifado","Atencao","ALERT")
		_lRet   := .F.
		//	ElseIf Acols[n][_cLocal] == "98" //.And. SM0->M0_CODIGO == "NH" //so para atender a NH
		//	MsgBox("Atencao Numero do Almoxarifado 98 não é valido","Atencao","ALERT")
		//	_lRet   := .F.
	Endif
	
	If Empty(Acols[n][_cNCM]) .Or. Len(Alltrim(Acols[n][_cNCM]))<> 8
		MsgBox("Atencao Numero do NCM é Obrigatório com 8 digitos Favor Verificar","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	//   If cTipo$"B" .And. !cUfOrig$'PR' .And. Alltrim(Acols[n][_cCF]) < "2000"
	//--	  MsgBox("CFOP Incorreta Verifique !!!!","Atencao","ALERT")
	//--	  _lRet   := .F.
	//   Endif
	
	
	
	//*************
	If !Empty(Acols[n][_cPedido]) .And. !CFORMUL$"S"
		_nRecSC7 := SC7->(RECNO())
		_nIndSC7 := SC7->(IndexOrd())
		SC7->(DbSetOrder(1)) // Filial + pedido + item
		If SC7->(DbSeek(xFilial("SC7")+Acols[n][_cPedido]+Acols[n][_cItem]))
			
			//-- conforme reunião do dia 13/09/2012
			//-- com calobrise, glayson, p.shceibe,tulio, j.felipe
			//-- nao permitir quantidade da nota acima da qtde do pedido,
			//-- bem como valor un. da nf maior q valor un. do pc.
			If (SC7->C7_QUANT - SC7->C7_QUJE) < Acols[n][_nQtde]
				Alert("Quantidade da NF não pode ser maior que a quantidade do Pedido de Compras!")
				Return .f.
			Endif
			
			//-- Segundo depto Fiscal (Leandro P) no caso das INVOICES
			//-- é preciso altera o valor para mais, nestes casos a moedaé diferente de 1
			If SC7->C7_PRECO < Acols[n][_nUnit] .and. SC7->C7_MOEDA==1
				Alert("Valor unitário da NF não pode ser maior que o valor unitário do Pedido de Compras!")
				Return .f.
			Endif
			//-- fim reunião do dia 13/09/2012
			
			If Alltrim(SC7->C7_CC) <> Alltrim(aCols[n][_nCC])
				aCols[n][_nCC] :=  SC7->C7_CC
			Endif
			
			if Alltrim(SC7->C7_CONTA) <> Alltrim(aCols[n][_nConta])
				aCols[n][_nConta] :=  SC7->C7_CONTA
			Endif
			
			Acols[n][_cLocal] := SC7->C7_LOCAL
			//Verifica a entrada de PRODUTO, pois so pode entrar com pedido feito dentro do mes corrente Ref. a O.S. do Crisvaldo/Lazaro
			
			If (!SC7->C7_FORNECE$'002700/008805' .And. Subs(SC7->C7_PRODUTO,1,2)$"FE/OL/PQ/MQ/MM/MX/MS/SA/MK/ML/ME/MD/MF/CP/MP") .OR. ; //Bloqueia a entrada de nota com pedido antes do prazo pedido do campras Lazaro
				(Alltrim(Acols[n][_cLocal])$'21/24' .AND. Subs(SC7->C7_PRODUTO,1,2)$"EB") //Chamado 019269 do Portal
				
				//-- mes e ano da previsao nao pode ser maior que mes e ano da database
				If Substr(DTOS(SC7->C7_DATPRF),1,6) > Substr(DTOS(dDatabase),1,6) //   MONTH(SC7->C7_DATPRF) > MONTH(Ddatabase) .and. Year(SC7->C7_DATPRF) > Year(Ddatabase)
					MsgBox(" Nao é Permitido a Entrada de Material Antes do Previsto! Data Prevista:"+dtoc(SC7->C7_DATPRF)+"!!!"+Chr(13)+;
					" Pedido Com Bloqueio Pelo Comprador","Depto de Compras","STOP")
					SC7->(DbGoTo(_nRecSC7))     // Volta para o Ponto inicial
					SC7->(DbSetOrder(_nIndSC7)) // Volta para o indice anterior
					Return(.F.)
				Endif
			Endif
			
			//Verifica se a conta Contabil foi alterada na entrada da N.F.
			//		  If Acols[n][_nConta] <> SC7->C7_CONTA
			//	          MsgBox("Atencao Esta Conta Contabil nao Pode Ser Alterada","Atencao","ALERT")
			//	          _lRet   := .F.
			//		  Endif
			
			//Verifica se a qtde da autorizacao de entrega é maior que saldo a entregar
			If SC7->C7_TIPO == 2 // Autotizacao de entrega
				If Acols[n][_nQtde] > (SC7->C7_QUANT - SC7->C7_QUJE)
					MsgBox("Atencao Esta Autorizacao de Entrega/Pedido esta com Qtde Maior que o Saldo no Sistema, Avise o Compras","Atencao","ALERT")
					_lRet   := .F.
				Endif
			Endif
		Endif
		SC7->(DbGoTo(_nRecSC7))       // Volta para o Ponto inicial
		SC7->(DbSetOrder(_nIndSC7)) // Volta para o indice anterior
	Endif
	
	//-- Chamado 007916 do helpdesk
	//-- Chamado 008962 do helpdesk
	If !U_NHEST165(aCols[n][_nCC],aCols[n][_nConta],aCols[n][_nCod])
		Return .F.
	EndIf
	
	If cTipo$"N" //Verifica lote quando for nota de // N= normal  B = beneficiamento D= Devoluçao
		ZRA->(DbSetOrder(3)) // Filial + fornecedor + loja
		If ZRA->(DbSeek(xFilial("ZRA")+CA100FOR+CLOJA))
			_lFolTer := .T. //encontrou o fornrdor de terceiro
		Endif
	Endif
	
	If SM0->M0_CODIGO$"FN" .And. CA100FOR$"002899" .And. Acols[n][_nCod]$"PSA01.1.0050.00"
		MsgBox("Atencao Utilizar Tipo B da Nota, Verifique !!!","Atencao","ALERT")
		_lRet   := .F.
	Endif
	
	If SM0->M0_CODIGO$"NH" .And. CA100FOR$"000666/005664"  //libera quando for fornecedor fundicao 000666
		_lEmpre:= .T.
	Elseif SM0->M0_CODIGO$"FN" .And. CA100FOR$"000003/002188"  //libera quando for fornecedor WHB 000003
		_lEmpre:= .T.
	Endif
	
	If !_lEmpre
		If !_lFolTer  //libera quando foi folha de terceiros
			If !Alltrim(CESPECIE)$"CTR/CTE"
				If !cTipo$"C/D/P/I" //Verifica lote quando for nota de // N= normal  B = beneficiamento D= Devoluçao
					
					SF4->(DbSetOrder(1)) // Filial + pedido + item
					If SF4->(DbSeek(xFilial("SF4")+Acols[n][_cTES]))
						If SF4->F4_DUPLIC$"S"
							If Empty(Alltrim(Acols[n][_cPedido]))
								MsgBox("Atencao Favor Inserir o Numero do Pedido na Nota, Verifique !!!","Atencao","ALERT")
								_lRet   := .F.         //VOLTAR PARA FALSO
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	
	//valida a mov. da nota fiscal de gera estoque valida o lote
	SF4->(DbSetOrder(1)) // Filial + codigo
	SF4->(Dbseek(xFilial("SF4")+Acols[n][_cTES]))
	
	If SF4->F4_ESTOQUE == 'S'
		
		If cTipo$"N/B/D"
			If ALLTRIM(SB1->B1_RASTRO)$"L"
				//If SB1->B1_TIPO$"MA/MP/CP/CC/MC"
				If !UPPER(FUNNAME())$"NHEST139"
					
					If Empty(Acols[n][_cLote])
						Acols[n][_cLote] := U_NHEST002()
					EndIf
					
					If Empty(Acols[n][_cLote])
						MsgBox("Atencao Numero do Lote Incorreto, Favor Teclar ENTER no Codigo do produto para Gerar Lote Correto","Atencao","ALERT")
						Return .F.
					EndIf
					
				ENDIF
				//Endif
			Endif
		Endif
	Endif
	/*
	If !Upper(Alltrim(FUNNAME()))$"MATA116/MATA119"
	If SM0->M0_CODIGO == "NH"
	If SB1->B1_TIPO$"CC/MC/CP/MP"
	If Subs(Alltrim(Acols[n][_cLote]),1,4)$"AUTO"  .Or. Empty(Acols[n][_cLote])
	MsgBox("Atencao Numero do Lote Incorreto, Favor Teclar ENTER no Codigo do produto para Gerar Lote Correto","Atencao","ALERT")
	_lRet   := .F.
	Endif
	Endif
	Elseif SM0->M0_CODIGO == "FN"
	If SB1->B1_TIPO$"MA/MP/CP"
	If Subs(Alltrim(Acols[n][_cLote]),1,4)$"AUTO" .Or. Empty(Acols[n][_cLote])
	MsgBox("Atencao Numero do Lote Incorreto, Favor Teclar ENTER no Codigo do produto para Gerar Lote Correto","Atencao","ALERT")
	_lRet   := .F.
	Endif
	Endif
	Endif
	Endif
	*/
	
	If CFORMUL$"S"
		_nQuant := 0
		For _x:=1 to len(acols)
			
			_nQuant +=  Acols[_x][_nQtde]
		Next _x
		Alert(" Quantidade Total : "+ Transform(_nQuant,"@E 999,999,999.999"))//soma da qtde
		/* If Empty(F1_MENNOTA)
		Msgbox(" Favor preencher o campo mesagem da nota!!!!","Atencao","ALERT")
		_lRet   := .F.
		Endif
		*/
	Endif
	
	/**
	* Verifica a amarração embalagem x cliente/fornecedor na tabela ZDY
	*/
	//	SB1->(Dbseek(xFilial("SB1")+Acols[n][_nCod]))
	
	If SB1->B1_TIPO$'EB/EC'
		If Acols[n][_cLocal]$"32/33"
			ZDY->(dbSetOrder(1))// FILIAL + PRODUTO + CF + CLIFOR + LOJA
			
			If cTipo=="D" .or. cTipo=="B"
				If !ZDY->(dbSeek(xFilial("ZDY")+SB1->B1_COD+'C'+CA100FOR+CLOJA))
					MsgBox("Não existe amarração Embalagem x Cliente! Por favor, entre em contato com PCP para cadastrar ou utilize outro código de produto!","PE MT100LOK","ALERT")
					Return .f.
				EndIf
			Else
				If !ZDY->(dbSeek(xFilial("ZDY")+SB1->B1_COD+'F'+CA100FOR+CLOJA))
					MsgBox("Não existe amarração Embalagem x Fornecedor! Por favor, entre em contato com PCP para cadastrar ou utilize outro código de produto!","PE MT100LOK","ALERT")
					Return .f.
				EndIf
			EndIf
		EndIf
	EndIf
	
	//-- OS 056752
	If cTipo$"D" .And. CFORMUL$"S"
		If !Empty(aCols[n][_nNFOri]) .and. !Empty(aCols[n][_nSerOri]) .and. !Empty(aCols[n][_nItOri])
			SD2->(dbsetorder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			If SD2->(dbseek(xFilial("SD2")+aCols[n][_nNFOri]+aCols[n][_nSerOri]+ca100FOR+CLOJA+aCols[n][_nCod]+aCols[n][_nItOri]))
				If SD2->D2_LOCAL<>Acols[n][_cLocal]
					Alert("O Almoxarifado de Devolução deve ser o mesmo da NF Original ("+SD2->D2_LOCAL+")!")
					Return .f.
				Endif
			Endif
		Endif
	Endif
	// FIM OS 056752
	
Endif

Return(_lRet)

       
