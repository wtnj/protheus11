
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MT100TOK ³ Autor ³  Alexandre R. Bento  ³ Data ³ 11/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Na inclusão da nota fiscal de entrada de qualquer tipo     ³±±
±±³          ³ Verificar saldo disponivel do orcamento do mesmo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "AP5MAIL.CH"

User Function MT100TOK()

SetPrvt("_nOrcam,cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF, cMSG,_cCod,_cDescri,_nTotal,_nTES,nX,_lValida,_cConta,_cLocal") 

cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)   // PULA LINHA  
cMSG := ""        
_cCod    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})                 
_cDescri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_DESCRI"})                 
_nTotal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TOTAL"})                   
_nTES    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TES"})                   
_cConta  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CONTA"})                   
_nOrcam  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_NUMORC"})
_cLocal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_LOCAL"})

nX       := 1
_lValida := .T.

If Len(ALLTRIM(CNFISCAL)) >= 1 .And. Len(ALLTRIM(CNFISCAL)) < 9 .And. cFormul<>"S" 
   MsgBox(" O Numero da Nota Deve Conter 9 Digitos","Atencao","STOP")
   Return(.F.)
Endif

If cTipo$"N/I/P/C" 
   SA2->(DbSeek(xFilial("SA2")+CA100FOR+CLOJA )) 
   If SA2->A2_EMITNFE$"S" .And. !Alltrim(CESPECIE)$"SPED"
      MsgBox(" Verificar Especie, Divergente do Cadastro do Fornecedor","Atencao","STOP")
   ElseIf SA2->A2_EMITNFE$"N" .And. Alltrim(CESPECIE)$"SPED"
      MsgBox(" Verificar Especie, Divergente do Cadastro do Fornecedor","Atencao","STOP")
   Endif                                	
Elseif cTipo$"B/D"
   SA1->(DbSeek(xFilial("SA1")+CA100FOR+CLOJA )) 
   If SA1->A1_EMITNFE$"S" .And. !Alltrim(CESPECIE)$"SPED"
      MsgBox(" Verificar Especie, Divergente do Cadastro do Fornecedor","Atencao","STOP")
   ElseIf SA1->A1_EMITNFE$"N" .And. Alltrim(CESPECIE)$"SPED"
      MsgBox(" Verificar Especie, Divergente do Cadastro do Fornecedor","Atencao","STOP")
   Endif   

Endif


//recebe um array na posicao 1= num pedido 2=inclui(.T.) 3=Altera(.T.) 4=Exclui(.T.)
//******************************************
//If nTipoped == 1 // so executa no pedido de compras
	//recebe um array na posicao 1= num pedido 2=inclui(.T.) 3=Altera(.T.) 4=Exclui(.T.)
     ZAK->(DbSetOrder(1))//filial + mesano + tipo
     SB1->(DbSetOrder(1))//filial + produto     
     For nX :=1 To Len( aCols )      
     
        If !Acols[nX][len(aHeader)+1]  //nao pega quando a linha esta deletada        
           SF4->(DbSeek(xFilial("SF4")+ Acols[nX][_nTES])) 
	        If SF4->F4_DUPLIC$"S" 
	           SB1->(DbSeek(xFilial("SB1")+ Acols[nX][_cCod] )) // pega o tipo do Codigo do produto                    
	           
	           If Subs(Alltrim(Acols[nX][_cConta]),1,6) <> "104020" 
	              If Subs(Alltrim(Acols[nX][_cConta]),1,8) <> "10104006" //nao pega conta de novos projetos       		   
				      If ZAK->(Dbseek(xFilial("ZAK")+Strzero(Month(dDataBase),2) + "/"+Strzero(Year(dDataBase),4)+ SB1->B1_TIPO ))  
				         If inclui
				            If ZAK->ZAK_SLD >  Acols[nX][_nTotal]
					           Reclock("ZAK",.F.)
					              ZAK->ZAK_SLD -= Acols[nX][_nTotal]
						       MsUnlock("ZAK")
						       Acols[nX][_nOrcam] := ZAK->ZAK_NUMORC     
					        Else
					           MsgBox(" Saldo para o Tipo "+ SB1->B1_TIPO  + " Insuficiente","Atencao","STOP")
					           Femail()
					           _lValida := .F.
					        Endif
					     Endif 
				      Endif   
				  Endif
			   Endif	  
			Endif
			/*
			If SM0->M0_CODIGO$"FN" .AND. Alltrim(SM0->M0_CODFIL)$"02" .AND. !Substr(Alltrim(Acols[nX][_cLocal]),1,1)$"5"	
			   	If Alltrim(Acols[nX][_cCod])$"VWB01.3.0210.00/VWB01.3.0210.02/VWB03.4.0208.01/VWB03.4.0208.02" 
			   		IF !Alltrim(Acols[nX][_cLocal])$"36/37"
					   	MsgBox( "Na filial Pernambuco, o produto "+Alltrim(Acols[nX][_cCod])+" só pode ser utilizado nos armazens 36 e 37 !", "P.E. MT100TOK ", "ALERT" )
						Return .F.		    		   		
				    ENDIF
			    ELSE
				    MsgBox( "Armazém NÃO começando com 5 NÃO pode ser utilizado na filial Pernambuco ! ", "P.E. MT100TOK ", "ALERT")
					Return .F.		    		   			    
			   	EndIf						   	
			EndIf
			*/    
		Endif	
	 Next nX

Return(_lValida) 

Static Function Femail()

	   	    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
            SA2->(DbSeek(xFilial("SA2")+CA100FOR+CLOJA )) 
            
			cMsg := '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title> E X E M P L O </title>' + CRLF
			cMsg += '</head>' + CRLF
			cMsg += '<b><font size="3" face="Arial">Email enviado atraves do Sistema Protheus</font></b>' + CRLF
			cMsg += '<font size="2" face="Arial">Entrada da Nota '+CNFISCAL +'-'+ CSERIE +' Recusada por Falta de Saldo no Orcamento.</font>' + CRLF
			cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
			cMsg += '<tr>'
			cMsg += '<td width="15%">'
			cMsg += '<font size="2" face="Arial">Produto</font></td>'
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Arial">Descricao</font></td>'
			cMsg += '<td width="10%">'
			cMsg += '<font size="2" face="Arial">Forn/Loja</font></td>' 
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Arial">Razao Social</font></td>'
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'
		    cMsg += '<td width="15%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[nX][_cCod] + '</font></td>'
		    cMsg += '<td width="30%">'
	    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[nX][_cDescri] + '</font></td>'
		    cMsg += '<td width="10%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + CA100FOR + '-' + CLOJA + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SA2->A2_NOME + '</font></td>'
		    cMsg += '</tr>' + CRLF
			cMsg += '</table>'
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF
  	    	              
	 
	 	    a_email := 'alexandrerb@whbbrasil.com.br'
 		  
	  	    If lConectou
				Send Mail from 'protheus@whbbrasil.com.br' To a_email;
				SUBJECT '***** NAO EXISTE SALDO PARA ENTRADA DO PRODUTO  ***** ';
				BODY cMsg;   
				RESULT lEnviado
			  If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
    		  EndIf                             
	  	    else
			  Alert("Erro ao se conectar no servidor: " + cServer)		
		    Endif

Return


                       
