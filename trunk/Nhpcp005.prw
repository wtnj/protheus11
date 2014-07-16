/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHPCP005        ³ Alexandre R. Bento    ³ Data ³ 20.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera arquivo TXT para Lista Critica                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"
#include "colors.ch"

User Function Nhpcp005()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,aCols")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cNovaLinha,aHeader,oMultiline")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,n_Pos,nSaldoB2,x,cForne,cForAux,nSalB2q")
SetPrvt("cArqExp,cArq,dData,nSalRet,nSalRef,nSalAna,nSalQua,nSalPro,nSalAca,cCod,nqtde")

nqtde   := 0
dData   := dDatabase
_cPerg  := "PCP005"
aMatriz := {}                                                                     
aPergs  := {}
aHeader := {}
aCols   := {}                         
aLocal  := {}

oRelato := Relatorio():New()
oRelato:cPerg := _cPerg

aAdd(aPergs,{"De Produto ?"        ,"C",15,0,"G",""            ,""	   	   ,"","","","SB1",""}) //mv_par01
aAdd(aPergs,{"Ate Produto?"        ,"C",15,0,"G",""            ,""	       ,"","","","SB1",""}) //mv_par02
aAdd(aPergs,{"De Grupo ?"          ,"C",06,0,"G",""            ,""	       ,"","","","SBM",""}) //mv_par03
aAdd(aPergs,{"Ate Grupo ?"         ,"C",06,0,"G",""            ,""         ,"","","","SBM",""}) //mv_par04
aAdd(aPergs,{"Selecionar Codigo ?" ,"N",01,0,"C","Cod. Cliente","Cod. WHB" ,"","","",""   ,""}) //mv_par05
aAdd(aPergs,{"Apenas Produtivos ?" ,"N",01,0,"C","Sim"         ,"Nao"      ,"","","",""   ,""}) //mv_par06
aAdd(aPergs,{"Baixas do Dia Ant ?" ,"N",01,0,"C","Sim"         ,"Nao"      ,"","","",""   ,""}) //mv_par07
aAdd(aPergs,{"Armazém Contem ?"    ,"C",20,0,"G",""            ,""         ,"","","",""   ,""}) //mv_par08

oRelato:AjustaSx1(aPergs)

//fCriaSX1()

If !Pergunte(_cPerg,.T.) //ativa os parƒmetros
	Return 
EndIf

aLocal := StrTokArr(mv_par08,";") //SEPARA A STRING ONDE TIVER ; E RETORNA UM ARRAY

/* A FUNCAO ACIMA SUBSTITUI O BLOCO EM COMENTARIO ABAIXO */
/*
FOR x:=1 TO LEN(mv_par08)
	nCONT := AT(";",mv_par08)	  //PREPARADO PARA VARIAS ponto e VIRGULAS
	nCONT := IF(nCONT==0 , LEN(mv_par08)+1 , nCONT)
	
	aAdd(aLocal,SUBSTR(mv_par08,1,nCONT-1))
	IF ( LEN(mv_par08) < nCONT+1 )
		EXIT
	ENDIF
	mv_par08  := ALLTRIM(SUBSTR(mv_par08,nCONT+1))
NEXT
*/

If Empty(aLocal)
	aLocal := {"22","32","33","42","52"}
EndIf

// Parametros Utilizados
// mv_par01 = Produto Inicial da op
// mv_par02 = Produto final   da op

Processa( {|| Gerando()   },"Gerando Dados ")

Processa( {|| RptDetail() },"Gerando Arquivo Txt...")
fCriaDBF()         

/*
TMP->(DbGoTop())
If Empty(TMP->D4_OP)
   MsgBox("Ordem de Producao nao Encontrada","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()

   Return
Endif
*/

If Len(aMatriz) <= 0

   	MsgBox("Arquivo Vazio!","Atencao","INFO")
   	If Select("TMP") > 0
	   	DbSelectArea("TMP")
	   	DbCloseArea()
   	EndIf
   
	If Select("TEMP") > 0
   		DbSelectArea("TEMP")
		DbCloseArea()
	EndIf

  	Return
EndIf

//Se existe dados para gerar o arquivo cria o mesmo
cARQEXP    := "C:\CLIENTES\ARQUIVO"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
cARQ       := FCreate(cARQEXP)
cNovaLinha := Chr(13) + Chr(10)
                    
While File(cARQEXP)
   cARQEXP := SUBS(cARQEXP,1,19)+StrZero(Val(SUBS(cARQEXP,20,1))+1,1)+".TXT" 
Enddo
           
mostraBrowse()
Processa( {|| fGeraTXT() },"Gerando Arquivo TXT Txt...")

DbSelectArea("TMP")
DbCloseArea()

DbSelectArea("TEMP")
DbCloseArea()

MsgInfo("Arquivo Gerado com Sucesso!"+cNovaLinha+"Caminho do Arquivo " + carqexp)                                 

//Alert("Arquivo Txt Gerado com Sucesso")

Return

Static Function Gerando()    

	cQuery :="SELECT C2.C2_NUM,C2.C2_PRODUTO,C2.C2_DATPRI,C2.C2_DATPRF,B1.B1_LOCPAD,"
	cQuery += "D4.D4_COD,D4.D4_LOCAL,D4.D4_OP,D4.D4_QUANT,D4.D4_QTDEORI,B1.B1_DESC,B1.B1_TIPO,B1.B1_CODAP5,"
	cQuery += "B2.B2_QATU,B2.B2_LOCAL,B2.B2_QEMP,B5.B5_QE1,B5.B5_QE2,B1.B1_PE," //A5.A5_NOMEFOR,"
	cQuery += "(D4.D4_QTDEORI /((DATEDIFF ( DAY , C2.C2_DATPRI , C2.C2_DATPRF)+1))) AS CONSU"	
    cQuery +=  " FROM " + RetSqlName( 'SD4' ) +" D4, " + RetSqlName( 'SB1' ) +" B1, " // + RetSqlName( 'SC4' ) +" C4," 
    cQuery += RetSqlName( 'SC2' ) +" C2, " + RetSqlName( 'SB2' ) +" B2, "
    cQuery += RetSqlName( 'SB5' ) +" B5" // + RetSqlName( 'SA5' ) +" A5 "
    cQuery += " WHERE B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
    cQuery += " AND D4.D4_FILIAL = '" + xFilial("SD4")+ "' "
    cQuery += " AND C2.C2_FILIAL = '" + xFilial("SC2")+ "' "
    cQuery += " AND B2.B2_FILIAL = '" + xFilial("SB2")+ "' "     
    cQuery += " AND B5.B5_FILIAL = '" + xFilial("SB5")+ "' "   
    cQuery += " AND B1.B1_COD = D4.D4_COD AND B2.B2_COD = D4.D4_COD" // AND A5.A5_PRODUTO = D4.D4_COD "
    cQuery += " AND D4.D4_COD = B5.B5_COD AND B5.D_E_L_E_T_ = ' '"  // AND C4.D_E_L_E_T_ <> '*'"
    cQuery += " AND D4.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_  = ' '"   //AND A5.D_E_L_E_T_ <> '*' "
    cQuery += " AND C2.D_E_L_E_T_ = ' ' AND B2.D_E_L_E_T_ = ' '"   // AND C4.C4_PRODUTO = C2.C2_PRODUTO"
    cQuery += " AND SUBSTRING(D4.D4_OP,1,6) = C2.C2_NUM"
//    If !Empty(mv_par01) .And. !Empty(mv_par02)        
       cQuery += " AND D4.D4_COD >= '" + mv_par01 + "' AND D4.D4_COD <= '" + mv_par02 + "' "
//    Endif   
/*
    If !Empty(mv_par03)
       cQuery += " AND SUBSTRING(D4.D4_COD,1,4) IN " + Alltrim(mv_par03) + " "
    Endif
*/
    cQuery += " AND '" + DtoS(Ddatabase) + "' >= C2.C2_DATPRI AND '" + DtoS(Ddatabase) + "' <= C2.C2_DATPRF"
    cQuery += " AND D4.D4_QUANT <> 0 AND D4.D4_LOCAL = B2.B2_LOCAL"

	If mv_par06==1// Apenas produtivos == Sim
	    If SM0->M0_CODIGO == "NH"    
	       cQuery += " AND B1.B1_TIPO IN ('CC','MC','CP','MP')"
	    Else 
	       cQuery += " AND B1.B1_TIPO IN ('CC','MC','CP','MP','PA','PW')"
	    Endif
	Else
		cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	EndIf
	      
//   cQuery := cQuery + " AND (B2.B2_QATU - B2.B2_QEMP) < 0"
    cQuery += " ORDER BY D4.D4_COD ASC" 

   //	MemoWrit('C:\TEMP\PCP005.SQL',cQuery)                                                 
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"

Return                                   


Static Function RptDetail()
Local _cLocal := Space(02)

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))

SB2->(DbSetOrder(1)) //filial + codigo + local
SA1->(DbSetOrder(1)) //filial + fornecedor + loja

While TMP->(!Eof())

   IncProc("Gerando Arquivo Txt..." + TMP->D4_OP)
   
   If Subs(TMP->B1_CODAP5,1,1) == "R"
      cCod := TMP->B1_CODAP5
   Elseif Subs(TMP->B1_CODAP5,1,1) == "N"
      cCod := Space(03)+ Subs(TMP->B1_CODAP5,1,13)
   Else
      cCod := Space(01)+Subs(TMP->B1_CODAP5,1,14)
   Endif
  
   nSaldoB2 := 0
   nSalRet  := 0   
   nSalRef  := 0   
   nSalAna  := 0      
   nSalQua  := 0      
   nSalPro  := 0         
   nSalAca  := 0
   nBaixAnt := 0
  
  If SM0->M0_CODIGO == "FN" 
 	 _cLocal := ""
 	 For x:=1 to Len(aLocal)
 	 	_cLocal += Iif(x<Len(aLocal),aLocal[x]+"/",aLocal[x])
 	 Next
 	 
     SB2->(DbSeek(xFilial("SB2")+TMP->D4_COD)) // Tabela de saldos em estoque por Local 
  Else
     _cLocal := TMP->B1_LOCPAD
     SB2->(DbSeek(xFilial("SB2")+TMP->D4_COD+_cLocal)) // Tabela de saldos em estoque por Local 
  Endif
   
   If SB2->(Found())
   
      While SB2->(!EOF()) .And. TMP->D4_COD == SB2->B2_COD
      
		If SM0->M0_CODIGO == "NH" //Empresa Usinagem      
   		   If SB2->B2_LOCAL == _cLocal
     	      	nSaldoB2 :=  SB2->B2_QATU   // Saldo do almoxarifado padrao
     	   Elseif SB2->B2_LOCAL$"97" //Retrabalho
	       	    nSalRet := nSalRet + SB2->B2_QATU   // saldo do 97
	       Elseif SB2->B2_LOCAL$"00/99" //Refugo
	       	    nSalRef := nSalRef + SB2->B2_QATU   // saldo do 00 e 99  refugo
	       Elseif SB2->B2_LOCAL$"95/96" //Analise
	       	    nSalAna := nSalAna + SB2->B2_QATU   // saldo do 95 e 96  Analise
	       Elseif SB2->B2_LOCAL$"98" //Gate - Qualidade
	       	    nSalQua := nSalQua + SB2->B2_QATU   // saldo do 98 Qualidade
	       Elseif SB2->B2_LOCAL$"10" //Processo
	       	    nSalPro := nSalPro + SB2->B2_QATU   // saldo do 10 Processo
	       Elseif SB2->B2_LOCAL$"04" //Produto acabado
	       	    nSalAca := nSalAca + SB2->B2_QATU   // saldo do 04 Produto acabado
  	       Endif 	    
  	    Elseif SM0->M0_CODIGO == "FN" //Empresa Fundicao      


   		   If SB2->B2_LOCAL$Iif(mv_par06==1,_cLocal,"21/31/32/41/51")
     	      	nSaldoB2 +=  SB2->B2_QATU   // Saldo do almoxarifado padrao
     	   Elseif SB2->B2_LOCAL$"97" //Retrabalho
	    	    nSalRet := nSalRet + SB2->B2_QATU   // saldo do 97
	       Elseif SB2->B2_LOCAL$"30/39/40/49/50/59" //Refugo
	       	    nSalRef := nSalRef + SB2->B2_QATU   // saldo do 00 e 99  refugo
	       Elseif SB2->B2_LOCAL$"25/26/35/36/45/46/55/56" //Analise
	       	    nSalAna := nSalAna + SB2->B2_QATU   // saldo do 95 e 96  Analise
	       Elseif SB2->B2_LOCAL$"98" //Gate - Qualidade
	       	    nSalQua := nSalQua + SB2->B2_QATU   // saldo do 98 Qualidade
	       Elseif SB2->B2_LOCAL$"24/34/44/54" //Processo
	       	    nSalPro := nSalPro + SB2->B2_QATU   // saldo do 10 Processo
	       Elseif SB2->B2_LOCAL$"27/37/47/57" //Produto acabado
	       	    nSalAca := nSalAca + SB2->B2_QATU   // saldo do 04 Produto acabado
  	       Endif 	    
  	    
  	    Endif
  	      
	    SB2->(Dbskip())
	   Enddo   
   Endif
	
	If mv_par07==1 //Baixas do dia Ant ? Sim
		If SM0->M0_CODIGO=="NH"
			nBaixAnt := fBaixAnt(TMP->D4_COD,"'"+_cLocal+"'")    
		ElseIf SM0->M0_CODIGO=="FN"
			
			_cLocal := ""
			For x:=1 to Len(aLocal)
				_cLocal += "'"+aLocal[x]+"',"
			Next
			_cLocal := Substr(_cLocal,1,Len(_cLocal)-1)
		
			nBaixAnt := fBaixAnt(TMP->D4_COD,Iif(mv_par06==1,_cLocal,"'21','32','31','41','51'"))			
			
		EndIf
	EndIf

	n_Pos := Ascan(aMatriz,{|X|X[1] == TMP->D4_COD}) 
	
	If n_Pos == 0
		AADD(aMatriz,{TMP->D4_COD,dData,cCod,nSalPro,nSaldoB2,;
		nSalPro+nSaldoB2,TMP->CONSU,nSaldoB2/TMP->CONSU,StrZero(nSalQua,6),;
		StrZero(nSalAna+nSalRet+nSalQua,6),StrZero(nSalRef,6),StrZero(nSalAna,6),StrZero(nSalRet,6),;
		StrZero(nSalAca,6),1,nBaixAnt})
		
	Else
		aMatriz[n_Pos,7] := Round(aMatriz[n_Pos,7] + TMP->CONSU,0)
		aMatriz[n_Pos,8] := Round((nSaldoB2/aMatriz[n_Pos,7]),0)
	Endif
	
	TMP->(Dbskip())
EndDo                                                                 
             

// Pega tambem no SB2 saldo em estoque os produto que não tem Orderm de Produção

cQuery1 := "SELECT B1.B1_COD,B1.B1_LOCPAD,B1.B1_DESC,B1.B1_TIPO,B1.B1_CODAP5,"
cQuery1 += "B2.B2_QATU,B2.B2_LOCAL,B2.B2_QEMP,B5.B5_QE1,B5.B5_QE2,B1.B1_PE" //A5.A5_NOMEFOR,"
cQuery1 += " FROM " + RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SB2' ) +" B2, "
cQuery1 +=  RetSqlName( 'SB5' ) +" B5" 
cQuery1 += " WHERE B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
cQuery1 += " AND B2.B2_FILIAL = '" + xFilial("SB2")+ "' "
cQuery1 += " AND B5.B5_FILIAL = '" + xFilial("SB5")+ "' "
cQuery1 += " AND B1.B1_COD = B2.B2_COD AND B1.B1_COD = B5.B5_COD AND B5.D_E_L_E_T_ = ' '" // AND C4.D_E_L_E_T_ <> '*'"
cQuery1 += " AND B2.D_E_L_E_T_ =  ' ' AND B1.D_E_L_E_T_ = ' '"
cQuery1 += " AND B1.B1_COD >= '" + mv_par01 + "' AND B1.B1_COD <= '" + mv_par02 + "' "

If mv_par06==1// Apenas produtivos == Sim
	If SM0->M0_CODIGO == "NH"
		cQuery1 += " AND B1.B1_TIPO IN ('CC','MC','CP','MP')"
	Else
		cQuery1 += " AND B1.B1_TIPO IN ('CC','MC','CP','MP','PA','PW')"
	Endif
Else
	cQuery1 += " AND B1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
EndIf

cQuery1 += " ORDER BY B1.B1_COD ASC"

TCQUERY cQuery1 NEW ALIAS "TEMP"

While TEMP->(!Eof())

   IncProc("Gerando Arquivo Txt..." + TEMP->B1_COD)

   n_Pos:=Ascan(aMatriz,{|X|X[1] == TEMP->B1_COD})             
   
   If n_Pos <> 0
      //Pula registro que já existe na matriz gerado pela OP
      //aMatriz[nPos][15] -> FLAG de controle 1= gerado apartir da OP C/ Consumo 2= gerado de SB2 sem consumo
      If aMatriz[n_Pos][15] == 1
         DbSelectArea("TEMP")
         TEMP->(Dbskip())  
         Loop
      Endif
   Endif
   
   If Subs(TEMP->B1_CODAP5,1,1) == "R"
      cCod := TEMP->B1_CODAP5 
   Elseif Subs(TEMP->B1_CODAP5,1,1) == "N"         
      cCod := Space(03)+ Subs(TEMP->B1_CODAP5,1,13)
   Else
      cCod := Space(01)+Subs(TEMP->B1_CODAP5,1,14)
   Endif
  
   nSaldoB2 := 0
   nSalRet  := 0   
   nSalRef  := 0   
   nSalAna  := 0      
   nSalQua  := 0      
   nSalPro  := 0         
   nSalAca  := 0
   nBaixAnt := 0
   
  If SM0->M0_CODIGO == "FN" 
 	 
 	 _cLocal := ""
 	 For x:=1 to Len(aLocal)
 	 	_cLocal += Iif(x<Len(aLocal),aLocal[x]+"/",aLocal[x])
 	 Next
 	 
     SB2->(DbSeek(xFilial("SB2")+TEMP->B1_COD)) // Tabela de saldos em estoque por Local 
  Else
	 _cLocal := TEMP->B1_LOCPAD    
     SB2->(DbSeek(xFilial("SB2")+TEMP->B1_COD+_cLocal)) // Tabela de saldos em estoque por Local 
  Endif
   
  If SB2->(Found())

      While SB2->(!EOF()) .And. TEMP->B1_COD == SB2->B2_COD

		If SM0->M0_CODIGO == "NH" //Empresa Usinagem      
   		   If SB2->B2_LOCAL == _cLocal
     	      nSaldoB2 :=  SB2->B2_QATU   // Saldo do almoxarifado padrao
     	   Elseif SB2->B2_LOCAL$"97" //Retrabalho
	       	    nSalRet := nSalRet + SB2->B2_QATU   // saldo do 97
	       Elseif SB2->B2_LOCAL$"00/99" //Refugo
	       	    nSalRef := nSalRef + SB2->B2_QATU   // saldo do 00 e 99  refugo
	       Elseif SB2->B2_LOCAL$"95/96" //Analise
	       	    nSalAna := nSalAna + SB2->B2_QATU   // saldo do 95 e 96  Analise
	       Elseif SB2->B2_LOCAL$"98" //Gate - Qualidade
	       	    nSalQua := nSalQua + SB2->B2_QATU   // saldo do 98 Qualidade
	       Elseif SB2->B2_LOCAL$"10" //Processo
	       	    nSalPro := nSalPro + SB2->B2_QATU   // saldo do 10 Processo
	       Elseif SB2->B2_LOCAL$"04" //Produto acabado
	       	    nSalAca := nSalAca + SB2->B2_QATU   // saldo do 04 Produto acabado
  	       Endif 	    

  	    Elseif SM0->M0_CODIGO == "FN" //Empresa Fundicao      

   		   If SB2->B2_LOCAL$Iif(mv_par06==1,_cLocal,"21/32/31/41/51")
     	      nSaldoB2 +=  SB2->B2_QATU   // Saldo do almoxarifado padrao
     	   Elseif SB2->B2_LOCAL$"97" //Retrabalho
	       	    nSalRet := nSalRet + SB2->B2_QATU   // saldo do 97
	       Elseif SB2->B2_LOCAL$"30/39/40/49/50/59" //Refugo
	       	    nSalRef := nSalRef + SB2->B2_QATU   // saldo do 00 e 99  refugo
	       Elseif SB2->B2_LOCAL$"25/26/35/36/45/46/55/56" //Analise
	       	    nSalAna := nSalAna + SB2->B2_QATU   // saldo do 95 e 96  Analise
	       Elseif SB2->B2_LOCAL$"98" //Gate - Qualidade
	       	    nSalQua := nSalQua + SB2->B2_QATU   // saldo do 98 Qualidade
	       Elseif SB2->B2_LOCAL$"24/34/44/54" //Processo
	       	    nSalPro := nSalPro + SB2->B2_QATU   // saldo do 10 Processo
	       Elseif SB2->B2_LOCAL$"27/37/47/57" //Produto acabado
	       	    nSalAca := nSalAca + SB2->B2_QATU   // saldo do 04 Produto acabado
  	       Endif 	    
  	    
  	    Endif

        SB2->(Dbskip())
	  Enddo   
   Endif

    If mv_par07==1 //Baixas do dia ant ? Sim
		If SM0->M0_CODIGO=="NH"
			nBaixAnt := fBaixAnt(TEMP->B1_COD,"'"+_cLocal+"'")    
		ElseIf SM0->M0_CODIGO=="FN"
		
			_cLocal := ""
			For x:=1 to Len(aLocal)
				_cLocal += "'"+aLocal[x]+"',"
			Next
			_cLocal := Substr(_cLocal,1,Len(_cLocal)-1)
		
			nBaixAnt := fBaixAnt(TEMP->B1_COD,Iif(mv_par06==1,_cLocal,"'21','31','41','51'"))
		EndIf
	EndIf

   If n_Pos == 0
      AADD(aMatriz,{TEMP->B1_COD,dData,cCod,nSalPro,nSaldoB2,;
                    nSalPro+nSaldoB2,0,nSaldoB2,StrZero(nSalQua,6),;
                    StrZero(nSalAna+nSalRet+nSalQua,6),StrZero(nSalRef,6),StrZero(nSalAna,6),StrZero(nSalRet,6),;
                    StrZero(nSalAca,6),0,nBaixAnt})
                    
   Else          
       aMatriz[n_Pos,8]:= Round(aMatriz[n_Pos,8] + nSaldoB2,0)
   Endif                                          
		   
   TEMP->(Dbskip())   
EndDo                                                                 

aMatriz := asort(aMatriz,,,{|x,y| x[8]< y[8]})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ROTINA DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImprime()

For x:= 1 to Len(aMatriz)
    
   If !Empty(aMatriz[x][1])
	   @ Prow() + 1, 001 Psay aMatriz[x][2]   // Data
	   @ Prow()    , 016 Psay aMatriz[x][3]   // codigo ap5
	   @ Prow()    , 030 Psay aMatriz[x][4]   // Saldo Processo
	   @ Prow()    , 040 Psay aMatriz[x][5]   // Saldo Atual
	   @ Prow()    , 050 Psay aMatriz[x][6]   // Saldo Atual
	   @ Prow()    , 060 Psay Transform(aMatriz[x][7],"@E 9,999,999") // dias de consumo  	
	   @ Prow()    , 070 Psay Transform(aMatriz[x][8],"@E 9,999,999") // nSaldoB2/TMP->CONSU			
	   @ Prow()    , 080 Psay aMatriz[x][9]   // Saldo Atual
	   @ Prow()    , 090 Psay aMatriz[x][10]  // Saldo Atual
	   @ Prow()    , 100 Psay aMatriz[x][11]  // Saldo Atual				
	   @ Prow()    , 110 Psay aMatriz[x][12]  // Saldo Atual				
	   @ Prow()    , 120 Psay aMatriz[x][13]  // Saldo Atual				
	   @ Prow()    , 130 Psay aMatriz[x][14]  // Saldo Atual								
	Endif
Next
      
Return(nil)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA AS BAIXAS DO DIA ANTERIOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fBaixAnt(cCod,cLocal)
Local nQuant := 0

	If select('TRA1') > 0
		TRA1->(dbCloseArea())
	Endif

   	cQuery := "SELECT SUM(D3_QUANT) AS QUANT "
   	cQuery += " FROM "+RetSqlName("SD3")+" D3"
   	cQuery += " WHERE D3_COD = '"+cCod+"'"
    cQuery += " AND D3_LOCAL IN ("+alltrim(cLocal)+")"
    cQuery += " AND D3_TM > '500'"
    cQuery += " AND D3_EMISSAO = '"+DtoS(dDatabase-1)+"'"
    cQuery += " AND D_E_L_E_T_ = ''"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(dbGoTop())
	
	nQuant := Iif(Empty(TRA1->QUANT),0,TRA1->QUANT)
	
	TRA1->(dbCloseArea())

Return nQuant

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GERA O ARQUIVO TXT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGeraTxt()

For x:= 1 to Len(aMatriz)
    
   If !Empty(aMatriz[x][1])
	   
	   RecLock("XDBF",.T.)    
	   
	   dData := dtos(dDatabase)
	   aMatriz[x][2] = Subs(dData,7,2)+Subs(dData,5,2)+Subs(dData,3,2)
	            
	   XDBF->DATATU    := aMatriz[x][2]   // Data
	   XDBF->PRODUTO   := Iif(mv_par05==1,aMatriz[x][3],aMatriz[x][1])  // codigo ap5 ou WHB conforme mv_par05
	   XDBF->PROCESSO  := StrZero(aMatriz[x][4],6) // Saldo Processo
  	   XDBF->ESTOQUE   := strZero(aMatriz[x][5],6) // Saldo Atual
  	   XDBF->TOTDISP   := StrZero(aMatriz[x][6],6) // Saldo DISPONIVEL
	   XDBF->CONSUMO   := StrZero(aMatriz[x][7],4) // dias de consumo  	
  	   XDBF->DIASEST   := StrZero(aMatriz[x][8],4) // nSaldoB2/TMP->CONSU			
  	   XDBF->SALQUA    := aMatriz[x][9]  // Saldo qualidade
	   XDBF->SALBLO    := aMatriz[x][10] // Saldo bloqueado
  	   XDBF->SALREF    := aMatriz[x][11] // Saldo Refugo
       XDBF->SALANA    := aMatriz[x][12] // Saldo Analise
	   XDBF->SALRET    := aMatriz[x][13] // Saldo Retrabalho
	   XDBF->SALACA    := aMatriz[x][14] // Saldo Acabado
	   MsUnlock("XDBF") 
     
      FWrite(cArq,(DATATU+Space(01)+PRODUTO+Space(01)+PROCESSO+Space(01)+ESTOQUE+Space(01)+TOTDISP+Space(01)+CONSUMO+Space(01)+;	   
             DIASEST+Space(01)+SALQUA+Space(01)+SALBLO+Space(01)+SALREF+Space(01)+SALANA+Space(01)+SALRET+Space(01)+SALACA)+cNovaLinha)          
      
	Endif   
Next
                                           
DbSelectArea("XDBF")
DbCloseArea()

FClose(cARQ)         

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaDBF()

_cArqDBF  := CriaTrab(NIL,.f.)
_aDBF := {}
                                                  // Nome       
AADD(_aDBF,{"Datatu"     ,"C", 06,0})         // Data do arquivo
AADD(_aDBF,{"Produto"    ,"C", 15,0})         // Produto
AADD(_aDBF,{"Processo"   ,"C", 06,0})         // Estoque em processo
AADD(_aDBF,{"Estoque"    ,"C", 06,0})         // Salso disponivel em estoque
AADD(_aDBF,{"ToTDisp"    ,"C", 06,0})         // Total estoque disponivel (almox 10 + 02/03)
AADD(_aDBF,{"Consumo"    ,"C", 04,0})         // Consumo
AADD(_aDBF,{"DiasEst"    ,"C", 04,0})         // Dias de estoque
AADD(_aDBF,{"SalQua"     ,"C", 06,0})         // Saldo de estoque no almox 98 (qualidade)
AADD(_aDBF,{"SalBlo"     ,"C", 06,0})         // Saldo de estoque no almox 95 96 97 98 (bloqueado)
AADD(_aDBF,{"SalRef"     ,"C", 06,0})         // Saldo de estoque no almox 99 00 (refugo)
AADD(_aDBF,{"SalAna"     ,"C", 06,0})         // Saldo de estoque no almox 95 96 (Analise)
AADD(_aDBF,{"SalRet"     ,"C", 06,0})         // Saldo de estoque no almox 97 (retrabalho)
AADD(_aDBF,{"SalAca"     ,"C", 06,0})         // Saldo de estoque no almox 04 (acabado)

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDBF",.F.) 

INDEX ON XDBF->Datatu TO (_cArqDBF)

Return        

Static Function mostraBrowse()
Local bOk         := {||fGrvTxt()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Private aSize    := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Aadd(aHeader,{"Codigo"     , "D4_COD"     , "@!"             ,15,0,".F.","","D","XDBF"}) //01  CODIGO DO PRODUTO
Aadd(aHeader,{"Data"       , "D3_EMISSAO" , "99/99/9999"     ,10,0,".F.","","D","XDBF"}) //02    DATATU
Aadd(aHeader,{"Produto"    , "D3_COD"     , "@!"             ,15,0,".F.","","C","XDBF"}) //03  PRODUTO
Aadd(aHeader,{"Processo"   , "PROCESSO"   , "@E 99999999.99" ,11,2,".T.","","N","XDBF"}) //04
Aadd(aHeader,{"Saldo"      , "D3_QUANT"   , "@E 99999999.99" ,11,2,".F.","","N","SD3"}) //05
Aadd(aHeader,{"Disponivel" , "D3_QUANT"   , "@E 99999999.99" ,11,2,".F.","","N","SD3"}) //06
Aadd(aHeader,{"Consumo"    , "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","SD3"}) //07      
Aadd(aHeader,{"Dias Est."  , "DIASEST"    , "@!"             , 5,0,".F.","","C","XDBF"}) //08      
Aadd(aHeader,{"Saldo Qual" , "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","SD3"}) //09      
Aadd(aHeader,{"Sld Bloq"   , "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","SD3"}) //10      
Aadd(aHeader,{"Sld Ref"    , "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","SD3"}) //11      
Aadd(aHeader,{"Sld Analise", "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","XDBF"}) //12      
Aadd(aHeader,{"Sld Retrab" , "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","XDBF"}) //13      
Aadd(aHeader,{"Sld Acabado", "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","XDBF"}) //14      

If mv_par07==1 //Baixas do dia ant ? Sim
	Aadd(aHeader,{"Baixas "+DtoC(dDatabase-1), "D3_QUANT"   , "@E 9999999999"  ,11,2,".F.","","N","SD3"}) //14      
EndIf

                                      
/******************
* carrega o acols *
******************/
For x:= 1 to Len(aMatriz)
	Aadd(aCols,{aMatriz[x][1],aMatriz[x][2],aMatriz[x][3],aMatriz[x][4],aMatriz[x][5],aMatriz[x][6],aMatriz[x][7],aMatriz[x][8],aMatriz[x][9],aMatriz[x][10],aMatriz[x][11],aMatriz[x][12],aMatriz[x][13],aMatriz[x][14]})
	If mv_par07==1 //Baixas do dia ant ? Sim
		Aadd(aCols[len(aCols)],aMatriz[x][16])
	EndIf
next

aCols := asort(aCols,,,{|x,y| x[1] < y[1]})
  
bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}

oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"GERA ARQUIVO P/ LISTA CRITICA",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 30,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY OBJECT oMultiline
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline

oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return
                                           
Static Function fGrvTxt()

For x:= 1 to Len(aMatriz)
	aMatriz[x][1]  = aCols[x][1]
	aMatriz[x][2]  = aCols[x][2]
	aMatriz[x][3]  = aCols[x][3]
	aMatriz[x][4]  = aCols[x][4]
	aMatriz[x][5]  = aCols[x][5]
	aMatriz[x][6]  = aCols[x][4] + aCols[x][5]
	aMatriz[x][7]  = aCols[x][7]
	aMatriz[x][8]  = aCols[x][8]
	aMatriz[x][9]  = aCols[x][9]
	aMatriz[x][10] = aCols[x][10]
	aMatriz[x][11] = aCols[x][11]
	aMatriz[x][12] = aCols[x][12]
	aMatriz[x][13] = aCols[x][13]
	aMatriz[x][14] = aCols[x][14]
	If mv_par07==1
		aMatriz[x][15] = aCols[x][15]
	EndIf
next
Close(oDlg)
return

Static Function fEnd() 
  Close(oDlg) 
Return