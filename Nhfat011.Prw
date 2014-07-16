/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT011 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 11/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera o arquivo de Aviso de Embarque p/ Volks               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
Fábricas Volkswagen                          Códigos de fábrica      CNPJ's
Volkswagen do Brasil - Planta BUC (Curitiba)...057..(antigo 7).59104422010384
Volkswagen do Brasil - Planta Anchieta.........011..(antigo 1).59104422005704
Volkswagen do Brasil - Planta Taubaté..........013..(antigo 3).59104422002446
Volkswagen do Brasil - Planta São Carlos.......017..(antigo 4).59104422009882
Volkswagen do Brasil - Planta Resende..........018..(antigo 9).59104422009963
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                           
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"
User Function NHFAT011()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")   
SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cCGC,_cNotas,_clEmb,a_email,cPerg,_aVolks")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam,_cDoc")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMensagem := 'Erro ao se conectar no servidor: ' 
CRLF := chr(13)+chr(10)   // PULA LINHA  
cMSG := ""        
cPerg   := "ETQ   "                                
_lEmb   := .F. //verifica se gerou o aviso de embarque                                   
nPbruto :=  0
nFTP    := 0
_cArqDBF:=SPACE(12) 
_cArqFTP:=SPACE(12) 
_cArqITP:=SPACE(12)                                                           
_cArqAE1:=SPACE(12) 
_cArqNF2:=SPACE(12) 
_cArqAE2:=SPACE(12) 
_cArqAE4:=SPACE(12) 
_cArqAE3:=SPACE(12) 
_cArqTE1:=SPACE(12) 
_cNotas :=SPACE(200) 
_cNome  := UsrFullName(__cUserID)
_aFile  := {}
_aVolks := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cNovaLinha := Chr(13) + Chr(10)

//cARQEXP    := "V:\VOLKS\OUT\VLK"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam      := "VLK"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"
cARQEXP    := _cEDI + _cCam            


While File(cARQEXP)        
   _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
   cARQEXP := _cEDI + _cCam
Enddo

cARQ  := FCreate(cARQEXP)

//AjustaSx1()
//alert(cARQEXP)
If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Gerando Aviso de Embarque para Volks")
EndIf

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
   fErase(_cArqITP)  
   fErase(_cArqAE1)
   fErase(_cArqAE2)
   fErase(_cArqAE3)
   fErase(_cArqAE4)
   fErase(_cArqTE1)
   fErase(_cArqNF2)
   fErase(_cArqFTP)
  
Endif  

//Manda e-mail de confirmação da geração do aviso de embarque da volks

If _lEmb //verifica se gerou o aviso de embarque                                   
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

     cMsg += '<html>' + CRLF
	 cMsg += '<head>' + CRLF
	 cMsg += '<title> E X E M P L O </title>' + CRLF
	 cMsg += '</head>' + CRLF
     cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF	 
	 cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	 cMsg += '<font size="2" face="Arial">Aviso de Embarque Enviado para VOLKS as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
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
   	    a_email += 'HesslerR@whbusinagem.com.br;EloirH@whbbrasil.com.br;oliveira@whbusinagem.com.br;'	 
 	    a_email += 'jeova.silva@volkswagen.com.br;claudio.rogerio@volkswagen.com.br'
     ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao 	 
 	    a_email := 'lista-fiscal@whbbrasil.com.br;' 	 
 	 Endif   

     _aFile := { "\System\WHBL.BMP" }
	 If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE PARA VOLKS '+Upper(_cPlanta)+' ***** ';
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
   If Mv_par03 == 1 // Sao carlos
      _cCliente := "900001"
      _cLoja    := "03"                     
      _cPlanta  := " Sao carlos"   
      _cCGC     := "59104422009882"      
   Elseif Mv_par03 == 2 // taubate   
      _cCliente := "900001"
      _cLoja    := "02"
      _cPlanta  := " Taubate"      
      _cCGC     := "59104422002446"      
   Elseif Mv_par03 == 3 //audi   
      _cCliente := "900002"
      _cLoja    := "01"         
      _cPlanta  := " AUDI"         
      _cCGC     := "59104422010384"      
   Elseif Mv_par03 == 4 // sao bernardo   
      _cCliente := "900001"
      _cLoja    := "01"         
      _cPlanta  := " Sao Bernardo"        
      _cCGC     := "59104422005704"             
   Endif

ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao

   If Mv_par03 == 1 // Sao Bernardo
      _cCliente := "000012"
      _cLoja    := "01"                     
      _cPlanta  := " Sao Bernardo"
      _cCGC     := "59104422005704"       
   Elseif Mv_par03 == 2 // Sao Carlos
      _cCliente := "000012"
      _cLoja    := "02"
      _cPlanta  := " Sao Carlos"      
      _cCGC     := "59104422009882"
   Elseif Mv_par03 == 3 // AUDI   
      _cCliente := "000012"
      _cLoja    := "03"
      _cPlanta  := " AUDI"         
      _cCGC     := "59104422010384"
   Elseif Mv_par03 == 4 // Taubate
      _cCliente := "000012"
      _cLoja    := "04"
      _cPlanta  := " Taubate"      
      _cCGC     := "59104422002446"
   Endif

Endif

   cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI," 
   cQuery := cQuery + "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
   cQuery := cQuery + "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
   cQuery := cQuery + " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 " 
   cQuery := cQuery + " WHERE D2.D2_FILIAL = '" + xFilial('SD2')+ "' AND C5.C5_FILIAL = '" + xFilial('SC5')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND C6.C6_FILIAL = '" + xFilial('SC6')+ "' AND A7.A7_FILIAL = '" + xFilial('SA7')+ "'"
   cQuery := cQuery + " AND D2.D2_EMISSAO BETWEEN '" + DTOS(Mv_par01) + "' AND '" + DTOS(Mv_par02) + "' " 
   cQuery := cQuery + " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' " 
   cQuery := cQuery + " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('542','503','573','613','605','576','579','526','596')"
   cQuery := cQuery + " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE "
   cQuery := cQuery + " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA AND D2.D2_TIPO = 'N' "
   cQuery := cQuery + " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"  
   cQuery := cQuery + " AND C6.C6_PRODUTO = D2.D2_COD"       
   cQuery := cQuery + " AND C6.C6_ITEM = D2.D2_ITEMPV"          
   cQuery := cQuery + " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '" 
   cQuery := cQuery + " ORDER BY D2.D2_DOC ASC"    
//   MemoWrit('C:\TEMP\FAT011.SQL',cQuery)
   

// TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

U_CriaDBFV()  // Cria arquivos temporarios de aviso de embarque para volks

TMP->(DBGotop())            
If Empty(TMP->D2_DOC)
   Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
   FClose(cARQ)         
   fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
   TMP->(DbCloseArea())
   XDBF->(DbCloseArea())
   AE1->(DbCloseArea())
   AE2->(DbCloseArea())
   AE3->(DbCloseArea())
   AE4->(DbCloseArea())
   TE1->(DbCloseArea())
   NF2->(DbCloseArea())
   FTP->(DbCloseArea())
   Return
Endif

While !TMP->(EOF())
   RecLock("XDBF",.T.)
   XDBF->Nota    := TMP->D2_DOC
   XDBF->Serie   := Alltrim(TMP->D2_SERIE)
   XDBF->Dta     := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
   XDBF->Prodcli := TMP->A7_CODCLI
   XDBF->Prodwhb := TMP->D2_COD
   XDBF->Total   := TMP->D2_TOTAL
   //Transform(TMP->D2_TOTAL,"@e 999,999,999,999.99")
   MsUnlock("XDBF")
     
   TMP->(DbSkip())
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
aRotina := { {"Marca Tudo"    ,'U_fMarcavk()', 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarvk()', 0 , 1 },;
             {"Legenda"       ,'U_fLegVoks()', 0 , 1 } }

MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)

//Static Function fGera()

ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())
XDBF->(DbGoTop())

While !TMP->(eof()) .And. !XDBF->(eof())     

   
   If !EMPTY(XDBF->OK)
      
	  IncProc("Gerando Aviso de Embarque" + _cPlanta)
      
      _nx := Ascan(_aVolks, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == TMP->D2_DOC+TMP->D2_SERIE+TMP->D2_CLIENTE+TMP->D2_LOJA+TMP->D2_COD})
   
	  If _nx <> 0
         _aVolks[_nx][08]:= _aVolks[_nx][08] + TMP->D2_TOTAL
         _aVolks[_nx][10]:= _aVolks[_nx][10] + TMP->D2_VALICM
         _aVolks[_nx][12]:= _aVolks[_nx][12] + TMP->D2_VALIPI
         _aVolks[_nx][15]:= _aVolks[_nx][15] + TMP->D2_QUANT                   
         _aVolks[_nx][20]:= _aVolks[_nx][20] + TMP->D2_DESC                           
         _aVolks[_nx][21]:= _aVolks[_nx][21] + TMP->D2_DESCON                  
         _aVolks[_nx][23]:= _aVolks[_nx][23] + TMP->D2_BASEICM                                    
	  Else
	     Aadd(_aVolks,{TMP->D2_DOC,TMP->D2_SERIE,TMP->D2_CLIENTE,TMP->D2_LOJA,TMP->D2_COD,TMP->D2_EMISSAO,TMP->D2_ITEM,TMP->D2_TOTAL,TMP->D2_CF,TMP->D2_VALICM,TMP->D2_TES,TMP->D2_VALIPI,;
	     TMP->A7_CODCLI,TMP->A7_PCCLI,TMP->D2_QUANT,TMP->D2_UM,TMP->B1_POSIPI,TMP->D2_IPI,TMP->D2_PRCVEN,TMP->D2_DESC,TMP->D2_DESCON,TMP->D2_PICM,TMP->D2_BASEICM})
      Endif   
	   
   EndIf
   XDBF->(DbSkip())
   TMP->(DbSkip())
EndDo    

nFTP  := 1
_lEmb := .F. //verifica se gerou o aviso de embarque                                   
_cDoc :=  Space(06)


For _nx:= 1 to len(_aVolks)

      //---------------  SEGMENTO AE1v0 - COMPLEMENTO DADOS DA NF 
       _lEmb := .T. //verifica se gerou o aviso de embarque                                                                      
      
       _cNotas := ALLTRIM(_cNotas) +" "+ _aVolks[_nx] [1] + CRLF  //documento                
       If _cDoc <> _aVolks[_nx][1] // Para não gerar o Segmento AE1 quando for a mesma nota fiscal
		   RecLock("AE1",.T.)               
		   AE1->IdentSeg   := "AE1"
		   AE1->NumNF      := Subs(_aVolks[_nx][1],4,6)
		   AE1->SerNF      := Subs(_aVolks[_nx][2],1,2)
		   AE1->DataNF     := Subs(_aVolks[_nx][6],3,6)
		   AE1->QItNf      := StrZero(Val(_aVolks[_nx][7]),3)                             
		   
		   AE1->VlToNF     := StrZero(_aVolks[_nx][8],17,2)
		   AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
	  	   AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
	  	   
		   AE1->QCDec      := "0"  // QTDE de casas decimais
		   AE1->CFO        := _aVolks[_nx][9]   // Alterado D2_CF
	//	   AE1->VlToICM    := Transform(TMP->D2_VALICM,"@e 99999999999999999.99")            
		   
		   AE1->VlToICM    := StrZero(_aVolks[_nx][10],17,2)
		   AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
	  	   AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
	  
		   AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
		   AE1->EspNF      := Iif(Alltrim(_aVolks[_nx][11]) == "613","02","00")
	
	//  AE1->VlIPI      := Transform(TMP->D2_VALIPI, "@e 99999999999999999.99")
	  	   AE1->VlIPI      := StrZero(_aVolks[_nx][12],17,2)
		   AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
	  	   AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter
	
	   // Codigo da fabrica *  011 = Sao Bernardo (anchieta)  013-Taubate  017=Sao Carlos 018-Resende  057-Curitiba
		   If _aVolks[_nx][3]+_aVolks[_nx][4] == "90000103" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001202"//sao carlos
	          AE1->CodFabEn   := "017"	    
	       ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000101" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001201" //sao bernardo          
	          AE1->CodFabEn   := "011"	                         
	       ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000201" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001203" // audi sao jose dos pinhais          
	          AE1->CodFabEn   := "057"	  
	       ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000104"  .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001204" // taubate          
	          AE1->CodFabEn   := "013"	           
	       Else
	          Alert("Atencao foi Selecionada uma Nota Fiscal que nao eh da VOLKS, Favor Rodar Novamente o Aviso de Embarque")
	          nFTP := 0
	          exit //forca a saida do programa
	   	   Endif
		   
		   AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
		   AE1->IdentPer   := "0000"
		   AE1->IdentFor   := Iif( Subs(_aVolks[_nx][5],1,2)$"EC/EB","REMESSA",Space(15))  //Para os codigo de embalagem colocar REMESSA
		   AE1->PlVeiTr    := Space(06)
		   AE1->HoEmb      := Space(04) 
	  	   AE1->Espaco     := Space(03)	   
		   MsUnlock("AE1")
		   
		   FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+IdentFor+PlVeiTr+HoEmb+Espaco)+cNovaLinha))    
	       nFTP += 1  //Controle de qtde de segmentos
	   Endif
	   _cDoc := _aVolks[_nx][1] // armazena a NF para controle do Segmento AE1 nao gerar repetido no arquivo EDI
	         
//---------------- SEGMENTO AE2v0 - DADOS DO ITEM                         
    
      // Retira os espacos do codigo do produto
       cCod := _aVolks[_nx][13] //TMP->A7_CODCLI //Codigo da amarracao prod x cliente
       nAux := AT(" ",cCod)
       While nAux <> 0
       
          cCod := Stuff(cCod,nAux,1,"")   
          nAux := AT(" ",cCod)
           
       Enddo
       

	   Reclock("AE2",.T.)
	   AE2->IdentSeg    := "AE2"
	   AE2->NumItNF     := StrZero(Val(_aVolks[_nx][7]),3)                             
	   AE2->NumPed      := _aVolks[_nx][14]

// R030103041R deve gerar o aviso de embarque c/ o seguinte código R030 103041 R e não R030 103041R passado pelo Luiz em 09/04/2010	   
//												R03   0103041R                330392                        R030   103041R 	   
	   If Subs(_aVolks[_nx][5],1,2)$"EC/EB"  //os codigo de embalagem nao tem espaco entre o codigo
	      AE2->CodItem     := Alltrim(cCod)
	   Else   
	      AE2->CodItem     := Iif(Alltrim(cCod)=="3055011171USI",Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,7)+Space(01)+Subs(Alltrim(cCod),11,10),Iif(Alltrim(cCod)$"R030103041R/R030103021CR",Subs(Alltrim(cCod),1,4)+Space(03)+Subs(Alltrim(cCod),5,6)+Subs(Alltrim(cCod),11,2),Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,10)))	   												
	   Endif   

//	   AE2->CodItem     := Iif(Alltrim(cCod)=="3055011171USI",Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,7)+Space(01)+Subs(Alltrim(cCod),11,10),Iif(Alltrim(cCod)=="R030103041R",Subs(Alltrim(cCod),1,4)+Space(03)+Subs(Alltrim(cCod),5,6)+Space(01)+Subs(Alltrim(cCod),11,1),Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,10)))	   												

  	   AE2->QINF        := StrZero(_aVolks[_nx][15],9,0)
//	   AE2->QINF        := Stuff(AE2->QINF,AT(".",AE2->QINF),1,"") //elimina o ponto
//  	   AE2->QINF        := Stuff(AE2->QINF,1,0,"0")  // Insere o primeiro caracter
 
	   AE2->UnMedNF     := _aVolks[_nx][16]
	   AE2->CodClasF    := _aVolks[_nx][17] //TMP->B1_POSIPI

       cIPI              := StrZero(_aVolks[_nx][18],5,2)
	   AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
   
  	   AE2->VlItem      := StrZero(_aVolks[_nx][19],17,2) //preco unitario
	   AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
  	   AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	   
	   AE2->QItEst      := StrZero(_aVolks[_nx][15],9,0)
	   
	   AE2->UnMedEs     := _aVolks[_nx][16] //TMP->D2_UM
	   AE2->QtUniCom    := StrZero(_aVolks[_nx][15],9,0)
	   AE2->UnMedCo     := _aVolks[_nx][16] //TMP->D2_UM
	   AE2->CodTpFo     := "P"  // P= Producao
//	   AE2->QtPerDe     := Transform(TMP->D2_DESC,"@e 99.99")

  	   cDesc             := StrZero(_aVolks[_nx][20],5,2)
	   AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
   
  	   AE2->VlToDes     := StrZero(_aVolks[_nx][21],17,2)
	   AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
  	   AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
  	   AE2->AlItem      := Space(04)
  	   AE2->Espaco      := Space(01)
	   
	   MsUnlock("AE2")

       FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+AlItem+Espaco)+cNovaLinha))      
       nFTP += 1  //Controle de qtde de segmentos


//-------------  SEGMENTO AE4v3 - DADOS COMPLEMENTARES DO ITEM                  


	   RecLock("AE4",.T.)             
	   AE4->IdentSeg  := "AE4"

  	   cICM            := StrZero(_aVolks[_nx][22],5,2)
	   AE4->AlICM     := Stuff(cICM,AT(".",cICM),1,"") //elimina o ponto
//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	   
  	   AE4->BasICM    := StrZero(_aVolks[_nx][23],17,2)
	   AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"") //elimina o ponto
  	   AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter

  	   AE4->VlICMAp    := StrZero(_aVolks[_nx][10],17,2)
	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"") //elimina o ponto
  	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
	   
  	   AE4->VlIPIAp    := StrZero(_aVolks[_nx][12],17,2)
	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"") //elimina o ponto
  	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter

	   AE4->CodSiTr   := "00"
	   AE4->NumDesIt  := Space(30)
	   AE4->DatValDe  := Space(06)

	   AE4->PedRev   := Space(13)
	   AE4->PesoLiq  := Space(05)
	   AE4->MulPreco := Space(01)
	   AE4->PrecoTot := Space(12)

	   MsUnlock("AE4") 

       FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+PesoLiq+MulPreco+PrecoTot)+cNovaLinha))          
       nFTP += 1  //Controle de qtde de segmentos


//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 

/*	   RecLock("AE3",.T.)
	   AE3->IdentSeg := "AE3"
	   AE3->IdentFat := "57290355001585"
	   AE3->IdentCob := "57290355001585"
	   AE3->IdentEnt := Space(14)
	   AE3->Espaco   := Space(30)
	   MsUnlock("AE3")
       
       FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+Espaco)+cNovaLinha))             
       nFTP += 1  //Controle de qtde de segmentos    */
 
      RecLock("TE1",.T.)
	   TE1->IdentSeg := "TE1"
	   TE1->Texto1   := Space(40)
	   TE1->Texto2   := Space(40)
	   TE1->Texto3   := Space(40)
	   TE1->Espaco   := Space(05)
	   MsUnlock("TE1")
       
      FWrite(cArq,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))             
      nFTP += 1  //Controle de qtde de segmentos                                                
 
            
Next _nx    

If nFTP > 1
//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
   nFTP += 1  //Controle de qtde de segmentos
   RecLock("FTP",.T.)
   FTP->IdentSeg := "FTP"
   FTP->NumCont  := "00000"
   FTP->QtdeSeg  :=StrZero(nFTP,9)
   FTP->NumToVl  :="00000000000000000"
   FTP->CatOper  := Space(01)
   FTP->Espaco   := Space(36)
   MsUnlock("FTP")          
    
   FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                
   FClose(cARQ)            
Else
    Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
    FClose(cARQ)         
    fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
Endif  


//Close(oDlg)
TMP->(DbCloseArea())
XDBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())


Return
 

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "ETQ"

aRegs   := {}


// VERSAO 508
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Data Inicial       ?","Data Inicial       ?","Data Inicial       ?","mv_ch1","C",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Data Final         ?","Data Final         ?","Data Final         ?","mv_ch2","C",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Cliente            ?","Cliente            ?","Cliente            ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Loja               ?","Loja               ?","Loja               ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})



cUltPerg := aRegs[Len(aRegs)][2]

If !SX1->(DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
	SX1->(DbDelete())
	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf

dbSelectArea(_sAlias)

Return
                                     

User Function CriaDBFV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aITP,{"NumComu"    ,"C", 03,0})         // Numero Mensagem Comunicacao     M    A       3    0    4    6
AADD(_aITP,{"NumVer"     ,"C", 02,0})         // Numero da Versao da Mensagem    M    N       2    0    7    8
AADD(_aITP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    9   13
AADD(_aITP,{"IdentMov"   ,"C", 12,0})         // Ident. Geracao Movimento        M    N      12    0   14   25
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         // Identificacao do Transmissor    M    N      14    0   26   39
AADD(_aITP,{"IdentRec"   ,"C", 14,0})         // Identificacao do Receptor       M    N      14    0   40   53
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         // Codigo Interno Transmissor      O    A       8    0   54   61
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         // Codigo Interno Receptor         O    A       8    0   62   69
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         // Nome do Transmissor             O    A      25    0   70   94
AADD(_aITP,{"NomRece"    ,"C", 25,0})         // Nome do Receptor                O    A      25    0   95  119
AADD(_aITP,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A       9    0  120  128

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.) 

/*
Fábricas Volkswagen                                         Códigos de fábrica                  CNPJ's
Volkswagen do Brasil - Planta BUC (Curitiba)........057...(antigo 7).................59104422010384
Volkswagen do Brasil - Planta Anchieta..............011...(antigo 1).................59104422005704
Volkswagen do Brasil - Planta Taubaté...............013...(antigo 3).................59104422002446
Volkswagen do Brasil - Planta São Carlos.............017...(antigo 4)................59104422009882
Volkswagen do Brasil - Planta Resende................018...(antigo 9)................59104422009963
*/

RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "004"
   ITP->NumVer    := "15"
   ITP->NumCont   := "00001" // Fazer este numero sequencia atraves de MV_VOLKS
   cDtaHor         := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS
   ITP->IdentMov  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")  // DATA+HHMMSS tira o segundo :
   ITP->IdentTra  := SM0->M0_CGC  //empresa Usinagem OU Fundicao // filial pernambuco 01261681000295
   ITP->IdentRec  := _cCGC //Contem o CGC da fabrica da Voks  // "59104422005704" //CGC VOLKS Planta Anchieta
   ITP->CodIntTr  := Space(08)
   ITP->CodIntRe  := "TGABC"                                      
   ITP->NomTrans  := SM0->M0_CGC  //CGC empresa Usinagem OU Fundicao
   ITP->NomRece   := "TRANS GRANDE ABC"	
   ITP->Espaco    := Space(09)


MsUnlock("ITP")

  FWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
  DbSelectArea("ITP")
  DbCloseArea()
  
// Close ITP
// ------- Segmento AE1 -----------
_cArqAE1  := CriaTrab(NIL,.f.)
_cArqAE1 += ".DBF"
_aAE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE1,{"NumNF"      ,"C", 06,0})         //  NUMERO DA NF ORIGEM            M    N       6    0    4    9
AADD(_aAE1,{"SerNF"      ,"C", 04,0})         // SERIE DA NOTA FISCAL ORIGEM     M    A       4    0   10   13
AADD(_aAE1,{"DataNF"     ,"C", 06,0})         // DATA DA NOTA FISCAL             M    D       6    0   14   19
AADD(_aAE1,{"QItNf"      ,"C", 03,0})         // QTDE ITENS POR NOTA FISCAL      M    N       3    0   20   22
AADD(_aAE1,{"VlToNF"     ,"C", 17,2})         // VALOR TOTAL DA NOTA FISCAL      M    N      17    2   23   39
AADD(_aAE1,{"QCDec"      ,"C", 01,0})         // QUANTIDADE DE CASAS DECIMAIS    M    N       1    0   40   40
AADD(_aAE1,{"CFO"        ,"C", 05,0})         // CODIGO FISCAL DE OPERACAO       M    N       3    0   41   45
AADD(_aAE1,{"VlToICM"    ,"C", 17,2})         // VALOR TOTAL DO ICMS APLICADO    M    N      17    2   46   62
AADD(_aAE1,{"DataVen"    ,"C", 06,0})         // DATA VENCIMENTO DO DOCUMENTO    M    D       6    0   63   68
AADD(_aAE1,{"EspNF"      ,"C", 02,0})         // ESPECIE DA NOTA FISCAL          M    N       2    0   69   70
AADD(_aAE1,{"VlIPI"      ,"C", 17,2})         // VALOR IPI APLICADO              M    N      17    2   71   87
AADD(_aAE1,{"CodFabEn"   ,"C", 03,0})         // CODIGO DA FABRICA ENTREGA       O    A       3    0   88   90
AADD(_aAE1,{"DataPrNF"   ,"C", 06,0})         // DATA PREVISAO ENTREGA DA NF     O    D       6    0   91   96
AADD(_aAE1,{"IdentPer"   ,"C", 04,0})         // IDENT. DO PERIODO DE ENTREGA    O    N       4    0   97  100
AADD(_aAE1,{"IdentFor"   ,"C", 15,0})         // DESCRICAO DA NATUREZA OPERACAO  O    A      15    0  101  115
AADD(_aAE1,{"PlVeiTr"    ,"C", 06,0})         // DATA DE EMBARQUE DA MERCADORIA  O    A       6    0  116  121
AADD(_aAE1,{"HoEmb"      ,"C", 04,0})         // HORA DO EMBARQUE DA MERCADORIA  M    A       4    0  122  125
AADD(_aAE1,{"Espaco"     ,"C", 03,0})         // Espaco                          M    A       3    0  126  128

DbCreate(_cArqAE1,_aAE1)
DbUseArea(.T.,,_cArqAE1,"AE1",.F.) 
    
//---------------  SEGMENTO NF2v0 - COMPLEMENTO DADOS DA NF                    


_cArqNF2  := CriaTrab(NIL,.f.)
_cArqNF2 += ".DBF"
_aNF2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aNF2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aNF2,{"VlDesAc"    ,"C", 17,2})         // VALOR DESPESAS ACESSORIAS       O    N      17    2    4   20
AADD(_aNF2,{"VlFrete"    ,"C", 17,2})         // VALOR DO FRETE                  O    N      17    2   21   37
AADD(_aNF2,{"VlSegu"     ,"C", 17,2})         // VALOR DO SEGURO                 O    N      17    2   38   54
AADD(_aNF2,{"VlDesc"     ,"C", 17,2})         // VALOR DO DESCONTO DA NF         O    N      17    2   55   71
AADD(_aNF2,{"Espaco"     ,"C", 57,0})         // Espaco                          M    A      57    0   72  128

DbCreate(_cArqNF2,_aNF2)
DbUseArea(.T.,,_cArqNF2,"NF2",.F.) 


/*               SEGMENTO NF3v0 - ALTERNATIVAS VCTO C/ DESC. NF                 

   Seq  Elem  Nome                            Uso  Tipo  Tam  Dec  Posicao
   ---  ----  ------------------------------  ---  ----  ---  ---  --------

     1  0001  Identificacao Tipo de Segmento  M    A       3    0    1    3
     2  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0    4    9
     3  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   10   13
     4  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   14   19
     5  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   20   23
     6  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   24   29
     7  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   30   33
     8  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   34   39
     9  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   40   43
    10  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   44   49
    11  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   50   53
    12  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   54   59
    13  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   60   63
    14  9999  Espaco                          M    A      65    0   64  128

*/



//---------------- SEGMENTO AE2v0 - DADOS DO ITEM                         

_cArqAE2  := CriaTrab(NIL,.f.)
_cArqAE2 += ".DBF"
_aAE2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE2,{"NumItNF"    ,"C", 03,0})         // NUMERO DO ITEM NA NOTA FISCAL   M    N       3    0    4    6
AADD(_aAE2,{"NumPed"     ,"C", 12,0})         // NUMERO DO PEDIDO DE COMPRA      M    A      12    0    7   18
AADD(_aAE2,{"CodItem"    ,"C", 30,0})         // CODIGO DO ITEM                  M    A      30    0   19   48
AADD(_aAE2,{"QINF"       ,"C", 09,0})         // QTDE ITEM UNIDADE NOTA FISCAL   M    N       9    0   49   57
AADD(_aAE2,{"UnMedNF"    ,"C", 02,0})         // UNIDADE MEDIDA NOTA FISCAL      M    A       2    0   58   59
AADD(_aAE2,{"CodClasF"   ,"C", 10,0})         // CODIGO DE CLASSIFICACAO FISCAL  M    N      10    0   60   69
AADD(_aAE2,{"AliIPI"     ,"C", 04,2})         // ALIQUOTA IPI                    M    N       4    2   70   73
AADD(_aAE2,{"VlItem"     ,"C", 12,2})         // VALOR DO ITEM                   M    N      12    2   74   85
AADD(_aAE2,{"QItEst"     ,"C", 09,0})         // QTDE ITEM UNIDADE ESTOQUE       O    N       9    0   86   94
AADD(_aAE2,{"UnMedEs"    ,"C", 02,0})         // UNIDADE MEDIDA ESTOQUE          O    A       2    0   95   96
AADD(_aAE2,{"QtUniCom"   ,"C", 09,0})         // QTDE UNIDADE DE COMPRA          O    N       9    0   97  105
AADD(_aAE2,{"UnMedCo"    ,"C", 02,0})         // UNIDADE MEDIDA COMPRA           O    A       2    0  106  107
AADD(_aAE2,{"CodTpFo"    ,"C", 01,0})         // CODIGO DO TIPO DE FORNECIMENTO  O    A       1    0  108  108
AADD(_aAE2,{"QtPerDe"    ,"C", 04,2})         // QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2  109  112
AADD(_aAE2,{"VlToDes"    ,"C", 11,2})         // VALOR TOTAL DESCONTO ITEM       O    N      11    2  113  123
AADD(_aAE2,{"AlItem"     ,"C", 04,0})         // ALTERACAO TECNICA DO ITEM       O    N       4    0  124  127
AADD(_aAE2,{"Espaco"     ,"C", 01,0})         // ESPACO                          O    N       1    0  128  128

DbCreate(_cArqAE2,_aAE2)
DbUseArea(.T.,,_cArqAE2,"AE2",.F.) 


//-------------  SEGMENTO AE4v3 - DADOS COMPLEMENTARES DO ITEM                  

_cArqAE4  := CriaTrab(NIL,.f.)
_cArqAE4 += ".DBF"
_aAE4 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE4,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE4,{"AlICM"      ,"C", 04,0})         // ALIQUOTA ICMS                   M    N       4    2    4    7
AADD(_aAE4,{"BasICM"     ,"C", 17,2})         // BASE DE CALCULO DO ICMS         M    N      17    2    8   24
AADD(_aAE4,{"VlICMAp"    ,"C", 17,2})         // VALOR DO ICMS APLICADO          M    N      17    2   25   41
AADD(_aAE4,{"VlIPIAp"    ,"C", 17,2})         // VALOR DO IPI APLICADO           M    N      17    2   42   58
AADD(_aAE4,{"CodSiTr"    ,"C", 02,0})         // CODIGO DE SITUACAO TRIBUTARIA   M    A       2    0   59   60
AADD(_aAE4,{"NumDesIt"   ,"C", 30,0})         // NUMERO DESENHO DO ITEM          O    A      30    0   61   90
AADD(_aAE4,{"DatValDe"   ,"C", 06,0})         // DATA DE VALIDADE DESENHO        O    D       6    0   91   96
AADD(_aAE4,{"PedRev"     ,"C", 13,0})         // pedido DA REVENDA               O    A      13    0   97  109
AADD(_aAE4,{"PesoLiq"    ,"C", 05,0})         // peso liquido do item            O    A       5    0  110  114
AADD(_aAE4,{"MulPreco"   ,"C", 01,0})         // MULTIPLICADOR DE PRECO UNIT     O    A       1    0  115  115
AADD(_aAE4,{"PrecoTot"   ,"C", 12,2})         // Preco total da mercadoria       M    A      12    2  116  127


DbCreate(_cArqAE4,_aAE4)
DbUseArea(.T.,,_cArqAE4,"AE4",.F.) 
  
 
//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 


_cArqAE3  := CriaTrab(NIL,.f.)
_cArqAE3 += ".DBF"
_aAE3 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE3,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE3,{"IdentFat"   ,"C", 14,0})         // IDENT. LOCAL FATURAMENTO        M    N      14    0    4   17
AADD(_aAE3,{"IdentCob"   ,"C", 14,0})         // IDENT. DO LOCAL DE COBRANCA     M    N      14    0   18   31
AADD(_aAE3,{"IdentEnt"   ,"C", 14,0})         // IDENT. LOCAL DE ENTREGA         M    A      14    0   32   45
AADD(_aAE3,{"Espaco"     ,"C", 30,0})         // Espaco                          M    A      83    0   46  128

DbCreate(_cArqAE3,_aAE3)
DbUseArea(.T.,,_cArqAE3,"AE3",.F.)       
    
 

//--------------- SEGMENTO TE1v0 - TEXTO LIVRE                          

_cArqTE1  := CriaTrab(NIL,.f.)
_cArqTE1 += ".DBF"
_aTE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aTE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aTE1,{"Texto1"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0    4   43
AADD(_aTE1,{"Texto2"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   44   83
AADD(_aTE1,{"Texto3"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   84  123
AADD(_aTE1,{"Espaco"     ,"C", 05,0})         // Espaco                          M    A       5    0  124  128

DbCreate(_cArqTE1,_aTE1)
DbUseArea(.T.,,_cArqTE1,"TE1",.F.) 
   

//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
                    
                    
_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aFTP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    4    8
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})         // Quantidade de Segmentos         M    N       9    0    9   17
AADD(_aFTP,{"NumToVl"    ,"C", 17,0})         // Numero Total de Valores         O    N      17    2   18   34
AADD(_aFTP,{"CatOper"    ,"C", 01,0})         // Categoria da Operacao           O    A       1    0   35   35
AADD(_aFTP,{"Espaco"     ,"C", 93,0})         // Espaco                          M    A      93    0   36  128

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.) 
  

// ------- Segmento para mostrar no browse -----------

_cArqDBF  := CriaTrab(NIL,.f.)
//_cArqDBF += ".DBF"
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 03,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto new hubner
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDBF",.F.) 
  
INDEX ON XDBF->NOTA TO (_carqDBF)

Return                                

User Function fLegVoks()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

//marca todas as notas
User Function fMarcavk()

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
User Function fDesMarvk()

   XDBF->(DbGoTop())
   While !XDBF->(eof())     
      
      RecLock("XDBF")
         XDBF->OK := "  "
      MsUnlock("XDBF")
      XDBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
