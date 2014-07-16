
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHQIE001 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 13/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo para indice de qualidade                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para a New Hubner                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ QEK,QER,QEL,QEU,QEJ                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterac. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "TopConn.ch"     
#include "rwmake.ch"     
#include "Font.ch"     
#include "Colors.ch"   

User Function Nhqie001() 

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD                                            
SetPrvt("_CCONTACRED,_CCONTADEB,cArqImp,_cArq,_aArq,lQtde,_cCod,_dDtAnt,x,cTxt,lOK,aRelease")
SetPrvt("_cCodCli,_cCodProd,_cNomCli,_cLojCli,_nQtde,_dData,aCols,aHeader,_cDoc,_cArqRel,aDiverg")
SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,_CORDEM,_CCABEC1,Lin,nMax,nTam,cKey")
SetPrvt("_cAno,_cMes,_cForne,_dDataI,_dDataF,cQuery,_cFor,_cProd,cChvMed,cSeek")
SetPrvt("aMatriz,_X,nI,x,aTamLab,lRet,aQuali,aIQP,aIndice,nMvDiAtr")
SetPrvt("nCtEnt,nCtDem,nQtdEnt,nNidi,nTotDem,nQtRej,nLtInsp,nLtSkip,nQtInsp,nQtSkip")

_cAno    := Space(04)
_cMes    := Space(02)
_cForne  := Space(06)           
_dDataI  := Space(08)
_dDataF  := Space(08)
aMatriz  := {}
aQuali   := {}                                           
aIndice  := {}
_cArq    := Space(12) 
_cArqRel := Space(08) 
_cNomCli :="" 
_dData   := ddatabase
_cCodProd:= Space(15)
_nQtde   := 0.00
_cCodCli :="" 
_cDoc    :="" 
lQtde    := .T. // Controla quebra de qtde por dia
_dDtAnt  := CtoD("//")
lOK      := .F. 
// Define as variaveis a serem zeradas p/ cada Fornecedor/Produto
nCtEnt	:= 0		// Numero total de entregas
nCtDem	:= 0		// Qtde de entregas demeritadas
nQtdEnt	:= 0		// Qtde total entregue (Tam. Lote)
nNidi		:= 0		// Qtde entregue * N. dias de atraso
nTotDem	:= 0		// Total de demeritos das entregas
nQtRej	:= 0		// Total de qtde. rejeitada do forn./item
nLtInsp	:= 0		// Total de lotes inspecionados
nLtSkip	:= 0		// Total de lotes em skip-lote
nQtInsp	:= 0		// Qtde. total (tam. lote) inspecionada
nQtSkip	:= 0		// Qtde. total (tam. lote) em skip-lote
nMvDiAtr := 0     // Pega o numero maximo de atrasos em dias do MV_QDIAIPO

 //Arquivo de classes A-Recebimento B-Processo C-Cliente      

@ 135,002 To 320,225 Dialog oDlg6 Title OemToAnsi("Geração do Indice de Qualidade")
@ 005,005 To 70,105

@ 20,015 Say OemToAnsi("Ano Refer.:") Size 60,10 Object oAno
oAno:SetFont(oFont)                                       
@ 35,015 Say OemToAnsi("Mês Refer.:") Size 60,10 Object oMes
oMes:SetFont(oFont)                                       

@ 20,060 Get _cAno Picture "@!" Size 20,10 Valid NaoVazio(_cAno) Object oAno
@ 35,060 Get _cMes Picture "@!" Size 20,10 Valid fMes() Object oMes
  	
@ 75,040 BMPBUTTON TYPE 1 ACTION fProcessa() 
@ 75,075 BMPBUTTON TYPE 2 ACTION Close(oDlg6)
ACTIVATE DIALOG oDlg6 CENTERED

Return
                                        
Static Function fMes()

lRet := .T.
If Val(_cMes) < 1 .Or. Val(_cMes) > 12
   MsgBox("Mes Invalido, Favor verificar !!!","Atencao","STOP")
   lRet := .F.
Endif

If Len(Alltrim(_cAno)) <> 4
   MsgBox("Ano Invalido, Favor verificar !!!","Atencao","STOP")
   lRet := .F.
Endif

Return lRet


Static Function fProcessa()

	Processa({|| fGerando() }, "Selecionando Dados...")
	Processa({|| fGera() }, "Gerando Indice de Qualidade...")               
    DbSelectArea("TMP")
    DbCloseArea()
Return


Static Function fGerando()
                                         
_dDataI := _cAno+_cMes+"01"                                          
_dDataF := _cAno+_cMes+"31"                                          

cQuery := "SELECT * FROM " +  RetSqlName( 'QEK' ) 
cQuery := cQuery + " WHERE QEK_DTENTR BETWEEN '" + _dDataI + "' AND '" + _dDataF+ "' AND"
cQuery := cQuery + " D_E_L_E_T_ <> '*' " 	
cQuery := cQuery + " ORDER BY QEK_FORNEC,QEK_LOJFOR,QEK_PRODUT"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
//TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de digitaçao de string para date    
//TcSetField("TMP","C7_DATPRF","D") // Muda a data de preferencia de string para date
ALERT(CQUERY)

Return

Static Function fGera()

TMP->(DBGotop())            
If Empty(TMP->QEK_NTFISC)
   MsgBox("Nao Foi Encontrada Nenhum Registro para Ser Processado Verifique","Atencao","STOP")
   Return
Endif

// Define Tamanho do campo Laboratorio
aTamLab := Array(2)
aTamLab := TamSX3("QEL_LABOR")

// Parametro que indica o numero maximo de dias em atraso
 nMvDiAtr := GetMv("MV_QDIAIPO")


QEL->(dbSetOrder(1))
QER->(DbSetOrder(1))
QEU->(DbSetOrder(1))                               

_cFor  := TMP->QEK_FORNEC
_cLoja := TMP->QEK_LOJFOR
_cProd := TMP->QEK_PRODUT

While !TMP->(EOF()) 
        
   
   If _cFor+_cLoja+_cProd <> TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUT

      Aadd(aIndice,{_cFor,_cLoja,_cProd,nCtEnt,nCtDem,nQtdEnt,nNidi,nTotDem, nQtRej,nLtInsp,nLtSkip,nQtInsp,nQtSkip})
	 	// Define as variaveis a serem zeradas p/ cada Fornecedor/Produto
		nCtEnt	:= 0		// Numero total de entregas
		nCtDem	:= 0		// Qtde de entregas demeritadas
		nQtdEnt	:= 0		// Qtde total entregue (Tam. Lote)
		nNidi		:= 0		// Qtde entregue * N. dias de atraso
		nTotDem	:= 0		// Total de demeritos das entregas
		nQtRej	:= 0		// Total de qtde. rejeitada do forn./item
		nLtInsp	:= 0		// Total de lotes inspecionados
		nLtSkip	:= 0		// Total de lotes em skip-lote
		nQtInsp	:= 0		// Qtde. total (tam. lote) inspecionada
		nQtSkip	:= 0		// Qtde. total (tam. lote) em skip-lote
	   _cFor    := TMP->QEK_FORNEC
		_cLoja   := TMP->QEK_LOJFOR
		_cProd   := TMP->QEK_PRODUT

   Endif



//   While TMP->QEK_FILIAL+TMP->QEK_FORNEC+TMP->QEK_PRODUT == xFilial("QEK")+_cFor+_cProd 

		// Localiza o laudo geral da Entrega
		If !QEL->(dbSeek(xFilial("QEL")+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUT+;
		          TMP->QEK_DTENTR+TMP->QEK_LOTE+Space(aTamLab[1])))
			TMP->(DbSkip())
			Loop
		EndIf

	//	// Considera aqui a Data do Laudo
	//	If Dtos(QEL->QEL_DTLAUD) < _dDataI .Or. Dtos(QEL->QEL_DTLAUD) > _dDataF
	//		TMP->(DbSkip())
	//	   Loop
//		EndIf

 		// Contabiliza no. de entregas
 		 nCtEnt := nCtEnt+1
		
		// Acumula Ocorrencias e Qtde. Lote - Inspec. e em Skip-Lote
		If TMP->QEK_VERIFI == 2	// Certificada
			nLtSkip := nLtSkip+1
			nQtSkip := nQtSkip+SuperVal(TMP->QEK_TAMLOT)
		Else
			nLtInsp := nLtInsp+1
			nQtInsp := nQtInsp+SuperVal(TMP->QEK_TAMLOT)
		EndIf

		// Acumula a Qtde. Rejeitada
		nQtRej := nQtRej+SuperVal(QEL->QEL_QTREJ)

		// Acumula valores para o calculo do IPO
		// Utiliza Dias em Atraso em modulo porque pode ser negativo
		nQtdEnt := nQtdEnt+SuperVal(TMP->QEK_TAMLOT)
		If QEK->QEK_DIASAT <> 0
			nNiDi := nNiDi+(SuperVal(TMP->QEK_TAMLOT)*;
					Iif(Abs(TMP->QEK_DIASAT)>nMvDiAtr,nMvDiAtr,Abs(TMP->QEK_DIASAT)))
		EndIf



		// Acumula pontos de demeritos oriundos das NCs
		cSeek := TMP->QEK_PRODUT+TMP->QEK_REVI+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+;
				   TMP->QEK_DTENTR+TMP->QEK_LOTE
		QER->(DbSeek(xFilial("QER")+cSeek))
		ProcRegua(QER->(RecCount()))
			
		While !QER->(Eof()) .And. QER->QER_FILIAL+QER->QER_PRODUT+QER->QER_REVI+QER->QER_FORNEC+QER->QER_LOJFOR+;
				Dtos(QER->QER_DTENTR)+QER->QER_LOTE==xFilial("QER")+cSeek 

			incProc("Produto : "+QER->QER_PRODUT)	// "Produto : "
			// Obtem chave de ligacao da medicao com os outros arquivos
			cChvMed := QER->QER_CHAVE
			// Verifica se a medicao tem NC
			//tabela de não conformidade
			IF QEU->(dbSeek(xFilial("QEU")+cChvMed))
				ProcRegua(QEU->(RecCount()))
				While !QEU->(Eof()) .And. QEU->QEU_FILIAL == xFilial("QEU") .And. QEU->QEU_CODMED == cChvMed 
			
	   			IncProc("Produto : " +QEU->QEU_CODMED)	// "Produto : "
					nI := Ascan(aMatriz, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == ;
					QER->QER_FORNEC+QER->QER_LOJFOR+QER->QER_PRODUT+QEU->QEU_CLASSE+QER->QER_LOTE})
					If nI <> 0
					   aMatriz[nI][6] := aMatriz[nI][6] + QEU->QEU_NUMNC   //Soma a qtde de nao conformidades
					Else
              	   Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"A",QER->QER_LOTE,;
              	                 Iif(QEU->QEU_CLASSE=="A",QEU->QEU_NUMNC,0),Val(TMP->QEK_TAMLOT)})
              	   Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"B",QER->QER_LOTE,;
              	                 Iif(QEU->QEU_CLASSE=="B",QEU->QEU_NUMNC,0),Val(TMP->QEK_TAMLOT)})
              	   Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"C",QER->QER_LOTE,;
              	                 Iif(QEU->QEU_CLASSE=="C",QEU->QEU_NUMNC,0),Val(TMP->QEK_TAMLOT)})
               Endif
					QEU->(dbSkip())
				EndDo
			Else       
				nI := Ascan(aMatriz, {|x| x[1]+x[2]+x[3]+x[5] == ;
				QER->QER_FORNEC+QER->QER_LOJFOR+QER->QER_PRODUT+QER->QER_LOTE})
				If nI == 0
				   //Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT," ",QER->QER_LOTE,0,Val(TMP->QEK_TAMLOT)})
				   Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"A",QER->QER_LOTE,0,Val(TMP->QEK_TAMLOT)})
              	Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"B",QER->QER_LOTE,0,Val(TMP->QEK_TAMLOT)})
              	Aadd(aMatriz,{QER->QER_FORNEC,QER->QER_LOJFOR,QER->QER_PRODUT,"C",QER->QER_LOTE,0,Val(TMP->QEK_TAMLOT)})
            Endif
			Endif	
			QER->(DbSkip())
	   EndDo
	//	TMP->(DbSkip())	
   //Enddo  
   TMP->(DbSkip())
Enddo

Alert( " matriz " +Strzero(Len(aMatriz)))

//orderna a matriz por fornecedor+loja+produto+classe
aMatriz := aSort(aMatriz,,, { | x,y | x[1]+x[2]+[3]+[4] < y[1]+y[2]+[3]+[4] } )

// Agrupa todos os produto por forncedor loja e classe
For x:= 1 to Len(aMatriz)
	
	nI := Ascan(aQuali, {|i| i[1]+i[2]+i[3]+i[4] == aMatriz[x][1]+aMatriz[x][2]+aMatriz[x][3]+aMatriz[x][4]})
   If nI <> 0
   	aQuali[nI][6] := aQuali[nI][6] + aMatriz[x][6] //soma as não conformidades
	   aQuali[nI][7] := aQuali[nI][7] + aMatriz[x][7] //soma os totais do lote
   Else
     	Aadd(aQuali,{aMatriz[x][1],aMatriz[x][2],aMatriz[x][3],aMatriz[x][4],aMatriz[x][5],aMatriz[x][6],aMatriz[x][7]})
   Endif
   
Next x

// Ordena vetor por fornecedor + loja
   aQuali := aSort(aQuali,,, { | x,y | x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] } )
   aIQP   := {}
	QEJ->(dbSetOrder(1))  //filial+classe +fator
	For X := 1 to Len(aQuali)
	   	   
	      //Calculo para achar o valor de cada classe( A B C)
  		nIA := Iif(aQuali[x][7]<>0, 100 - ((Iif(aQuali[x][6] <> 0,aQuali[x][6],0) /aQuali[x][7])*100), 0) 
  		   
  		QEJ->(dbSeek(xFilial("QEJ")+aQuali[x][4]+Str(nIA,6,2),.T.)) 
  		nI := Ascan(aIQP, {|i| i[1]+i[2]+i[3] == aQuali[x][1]+aQuali[x][2]+aQuali[x][3]})
  	   If nI == 0
   		 //         fornecedor   loja          produto      classe      Fator encontrado
         Aadd(aIQP,{aQuali[x][1],aQuali[x][2],aQuali[x][3],SuperVal(QEJ->QEJ_FATOR),aQuali[x][6]})
  	   Else  
  	       aIQP[nI][4] := aIQP[nI][4] + SuperVal(QEJ->QEJ_FATOR) //Faz a soma de todas as classes
  	       aIQP[nI][5] := aIQP[nI][5] + aQuali[x][6] //Faz a soma de todas as não conformidades
  	   Endif
	   
	Next X                    

	SA5->(dbSetOrder(1))  //filial+fornecedor+loja+produto
	For x:=1 to Len(aIQP)
	       
	   aIQP[x][4] := aIQP[x][4] / 3  //Divide por 3 para obter o IQP
      QEJ->(dbSeek(xFilial("QEJ")+"1"+Str(aIQP[x][4],6,2),.T.)) // Obtem o fator de IA na tabela QEJ codigo 1

      SA5->(dbSeek(xFilial("SA5")+aIQP[x][1]+aIQP[x][2]+aIQP[x][3])) // filial+fornecedor+loja+produto
      _nIQI := Val(SA5->A5_NOTAQ) + Val(QEJ->QEJ_FATOR) // Nota engenharia + fator IAMedia 
      // Atualiza automaticamente skip-lot conforme indice do fornecedor mais nota engenharia
      If SA5->A5_ATUAL = 'S'
         RecLock("SA5",.F.)
         	SA5->A5_SKPLOT := StrZero(_nIQI,2) //Atualiza skip-lote
     		SA5->(MsUnLock())	
      Endif                                                                            
      // Adiciona os totais de qtde e skip dos lotes
  		nI := Ascan(aIndice, {|i| i[1]+i[2]+i[3] == aIQP[x][1]+aIQP[x][2]+aIQP[x][3]})
   
	 //	QEV->(dbSetOrder(2))
	//	If !dbSeek(xFilial("QEV")+cFor+cProd+cIE230Ano+cIE230Mes)
//	                       1     2     3      4      5       6       7     8       9     10       11     12      13
//	      Aadd(aIndice,{_cFor,_cLoja,_cProd,nCtEnt,nCtDem,nQtdEnt,nNidi,nTotDem, nQtRej,nLtInsp,nLtSkip,nQtInsp,nQtSkip})
			RecLock("QEV",.T.)
			QEV->QEV_FILIAL	:= xFilial("QEV")
			QEV->QEV_ANO		:= _cAno
			QEV->QEV_MES		:= _cMes
			QEV->QEV_FORNEC	:= aIQP[x][1]
		//	QEV->QEV_LOJA   	:= aIQP[x][2]
			QEV->QEV_PRODUT	:= aIQP[x][3]
			If nI <> 0
				QEV->QEV_LOTENT	:=	aIndice[ni][4]
				QEV->QEV_LOTDEM	:=	aIndice[ni][5]//nCtDem
				QEV->QEV_LOTINS	:=	aIndice[ni][10]//nLtInsp
				QEV->QEV_LOTSKP	:=	aIndice[ni][11]//nLtSkip
				QEV->QEV_QTDINS	:=	aIndice[ni][12]//nQtInsp
				QEV->QEV_QTDSKP	:=	aIndice[ni][13]//nQtSkip
				QEV->QEV_QTDREJ	:=	aIndice[ni][9]//nQtRej
			Endif	
		// QEV->QEV_LOTENT	:=	0
//			QEV->QEV_LOTDEM	:=	0
//			QEV->QEV_LOTINS	:=	0
//			QEV->QEV_LOTSKP	:=	0
//			QEV->QEV_QTDINS	:=	0
//			QEV->QEV_QTDSKP	:=	0
//			QEV->QEV_QTDREJ	:=	0
  			QEV->QEV_IQP		:=	aIQP[x][4] //QEJ->QEJ_VLSUP //Fator de IQP
//			QEV->QEV_IQD		:=	0
//			QEV->QEV_IQS		:=	nIQS
			QEV->QEV_IQI		:=	_nIQI // Fator de IQI 1=A;2=B;3=C +IA
//			QEV->QEV_IPO		:=	0
//			QEV->QEV_ITR		:=	0
//			QEV->QEV_IES		:=	0
//			QEV->QEV_IPR		:=	0
//			QEV->QEV_IQF		:=	0
//			QEV->QEV_IQPA		:= 
//			QEV->QEV_IQDA		:= nTotDem	
//			QEV->QEV_IQIA		:= 
//			QEV->QEV_IPOA		:= nIPOa
//			QEV->QEV_IQFA		:= nIQFa
			QEV->QEV_DTGER		:=	dDataBase
			QEV->(MsUnLock())

   Next x


Return

