/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA265TDOK บAutor  ณJoใo Felipe da Rosa บ Data ณ  06/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LOCALIZAวรO : Function A265TudoOK - Fun็ใo de Valida็ใo da บฑฑ
ฑฑบ 		 ณ				 digita็ใo da distribui็ใo de produtos.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ			 ณ	EM QUE PONTO: Na valida็ใo ap๓s a confirma็ใo, antes da   บฑฑ
ฑฑบ			 ณ				  grava็ใo da distribui็ใo, deve ser utilizadoบฑฑ
ฑฑบ			 ณ				  para valida็๕es adicionais para a INCLUSรO  บฑฑ
ฑฑบ			 ณ				  da distribui็ใo do produto, ou atualizar    บฑฑ
ฑฑบ			 ณ				  algum dado no array aCols utilizado         บฑฑ
ฑฑบ			 ณ				  no Browse.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA265TDOK()
Local nPosData := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_DATA"}) 
Local nPosEstorno := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_ESTORNO"}) 
Local nPosCorrida := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_CORRIDA"}) 

	for xD:=1 to len(aCols)
	
		If !aCols[xD][len(aheader)+1] .AND. aCols[xD][nPosEstorno]!='S'//nao pega quando deletado nem quando estornado
			If Month(aCols[xD][nPosData]) <> Month(M->DA_DATA)
				Alert('Nใo ้ permitida distribui็ใo de produtos fora do m๊s da entrada da NF! Por favor, altere a data do ํtem '+strzero(xD,4)+'!')
				Return .F.
			EndIf
		EndIf 
		
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Empty(AllTrim(aCols[xD][nPosCorrida])) .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01'
			Alert('Para materia prima da forjaria ้ obrigatorio preencher o campo CORRIDA !')
			Return .F.			
		endif 
		
		//Incluir Valida็ใo da Aprova็ใo Laboratorio
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Empty(M->DA_LIBOK) .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01' .AND. Alltrim(M->DA_LOCAL)=='42'
			Alert('Material estแ pendente para aprova็ใo da qualidade ! Nใo ้ possivel endere็ar sem aprova็ใo !')
			Return .F.			
		endif 
		//------------------------------------------
		
		//Incluir Valida็ใo da Aprova็ใo Laboratorio
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Alltrim(M->DA_LIBOK)=='N' .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01' .AND. Alltrim(M->DA_LOCAL)=='42'
			Alert('Material foi reprovado pela qualidade !')
			Return .F.			
		endif 
		//------------------------------------------

	next

Return .T.