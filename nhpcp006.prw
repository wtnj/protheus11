/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHPCP006        ³ Sergio L. Tambosi   ³ Data ³ 03/12/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de Produção (O.P) do Produto.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaPcp                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhpcp006()  

   setPrvt("etiqpapel")
   //configura para 4,6 ou 8 etiquetas
	etiqpapel := 4

   AjustaSx1()

   If !Pergunte('PCP006',.T.)
      Return(nil)
   Endif   

   Processa({|| Gerando() },"Gerando Dados para a Impressao")
   DbSelectArea("TMP")
   DbCloseArea()
            
   DbSelectArea("DBF")
   DbCloseArea()
   
Return(nil)


Static Function Gerando()
   
cQuery := "SELECT C2.C2_NUM,C2.C2_PRODUTO, A7.A7_CODCLI, C2.C2_CODCLI,B1.B1_DESC,C2.C2_QUANT, A7.A7_CLIENTE, A1.A1_NOME, B5.B5_QE1 "  
cQuery += "FROM " +  RetSqlName( 'SC2' ) +" C2, " +  RetSqlName( 'SA1' ) +" A1, " +  RetSqlName( 'SA7' ) +" A7, " +  RetSqlName( 'SB5' ) +" B5, " +  RetSqlName( 'SB1' ) +" B1 "
cQuery += "WHERE A1.A1_FILIAL = '" + xFilial("SA1")+ "' "
cQuery += "AND A7.A7_FILIAL = '" + xFilial("SA7")+ "' "     
cQuery += "AND B5.B5_FILIAL = '" + xFilial("SB5")+ "' " 
cQuery += "AND C2.C2_FILIAL = '" + xFilial("SC2")+ "' " 
cQuery += "AND B1.B1_FILIAL = '" + xFilial("SB1")+ "' " 
cQuery += "AND C2.C2_PRODUTO BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
cQuery += "AND C2_LOJA = A1_LOJA "
cQuery += "AND C2_CODCLI = A1_COD "
cQuery += "AND C2_IMPRESS <> 'S' "
cQuery += "AND A7.A7_PRODUTO = C2.C2_PRODUTO "
cQuery += "AND B1.B1_COD = C2.C2_PRODUTO "
cQuery += "AND A1.A1_COD = A7.A7_CLIENTE "
cQuery += "AND A1.A1_LOJA = A7.A7_LOJA "
cQuery += "AND B5.B5_COD = C2.C2_PRODUTO "
cQuery += "AND C2.C2_QUANT <> C2.C2_QUJE "
cQuery += "AND C2.C2_DESTINA <> 'E' "
cQuery += "AND A1.D_E_L_E_T_ <> '*' "
cQuery += "AND B5.D_E_L_E_T_ <> '*' "
cQuery += "AND C2.D_E_L_E_T_ <> '*' "
cQuery += "AND A7.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY 1"
//TCQuery Abre uma workarea com o resultado da query
//memowrit('c:\PCP006.sql',cQuery)
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")
                                                   
fCriaDBF()  // Cria arquivos temporarios para browse de OPS em aberto

TMP->(DBGotop())            
While !TMP->(EOF())
   RecLock("DBF",.T.)           
   DBF->NumOP     := TMP->C2_NUM
   DBF->Produto   := TMP->C2_PRODUTO
   DBF->Descricao := TMP->B1_DESC
   DBF->Qtde      := Transform(TMP->C2_QUANT,"@e 9999999")
   DBF->QtdeEmb   := Transform(TMP->B5_QE1,"@e 9999999")
   if (MOD(TMP->C2_QUANT,TMP->B5_QE1)) > 0
         DBF->SobraEtiq := Transform(MOD((TMP->C2_QUANT/TMP->B5_QE1),etiqpapel)+1,"@e 99999")      
   else                                                                  
        DBF->SobraEtiq := Transform(MOD((TMP->C2_QUANT/TMP->B5_QE1),etiqpapel),"@e 99999")         
   endif   
   DBF->FolhaEtiq := Transform(INT((TMP->C2_QUANT/TMP->B5_QE1)/etiqpapel),"@e 9999999")   
   MsUnlock("DBF")
   TMP->(DbSkip())
Enddo

aCampos := {}   

Aadd(aCampos,{"OK"            ,"OK"             , "@!"})
Aadd(aCampos,{"NumOP"         ,"NumOP"          , "@!"})
Aadd(aCampos,{"Produto"       ,"Produto"        , "@!"})
Aadd(aCampos,{"Descricao"     ,"Descrição"      , "@!"})
Aadd(aCampos,{"Qtde"          ,"Qtde"           , "@!"})
Aadd(aCampos,{"QtdeEmb"       ,"QtdeEmb"        , "@!"})
Aadd(aCampos,{"FolhaEtiq"     ,"FolhaEtiq"      , "@!"})
Aadd(aCampos,{"SobraEtiq"     ,"SobraEtiq"      , "@!"})


DBF->(DbGoTop())

@ 10,1 TO 600,845 DIALOG oDlg TITLE "Selecionar Ordens de Produção"
@ 5,5 TO 278,420 BROWSE "DBF"
@ 5,5 TO 278,420 BROWSE "DBF" FIELDS aCampos MARK "OK" 
@ 280,010 BUTTON "_Imprimir"  SIZE 40,15 ACTION fImpEtiq()
@ 280,050 BUTTON "Ca_lcular"  SIZE 40,15 ACTION fCalcula()
@ 280,090 BUTTON "_Cancelar"  SIZE 40,15 ACTION Close(oDlg)
fCalcula()             
ACTIVATE DIALOG oDlg CENTERED
              
Return(nil)

Static Function fImpEtiq()

Local nPagina := 1
 	nLin := 370
   nCol	  := 0
   nPag    := 0
   i       := 1                   
   j	     := 1
   _CodCli := space(50)
   oFonteG := TFont():New("Arial",,28,,.t.,,,,,.f.)
   oFonteM := TFont():New("Arial",,16,,.t.,,,,,.f.)
   oFonteP := TFont():New("Arial",,14,,.t.,,,,,.f.)
   oFontePP:= TFont():New("Arial",,12,,.t.,,,,,.f.)   
   oFonteSP:= TFont():New("Arial",,09,,.t.,,,,,.f.)      
   oPr := tAvPrinter():New("Protheus")
   oPr:StartPage()    
   oPr:SetLandscape()       
   aEtiq := {}
   
   close(oDlg)
   
   DBF->(DbGoTop())
   TMP->(DbGoTop())
   //ProcRegua(DBF->(RecCount()))
   While DBF->(!Eof())         
      if MARKED("OK")
			if (alltrim(DBF->FolhaEtiq) = "0")
				_fim := val(DBF->SobraEtiq)
			else
			   _fim := val(DBF->FolhaEtiq)*etiqpapel + val(DBF->SobraEtiq)
			endif   
			For i := 1 to _fim
	      	oPr:Say(nLin,nCol+180,TMP->C2_CODCLI,oFonteP) 	   
				oPr:Say(nLin,nCol+572,DBF->NumOp,oFonteP)	                     
	   		oPr:Say(nLin+80,nCol+30,substr(TMP->A1_NOME,1,20),oFonteM)
	   		oPr:Say(nLin+165,nCol+180,DBF->Produto,oFonteP)
	   		oPr:Say(nLin+235,nCol+30,substr(DBF->Descricao,1,27),oFonteP)
	   		oPr:Say(nLin+348,nCol+30,TMP->A7_CODCLI,oFonteG) 	   	   	                                        
	   		if (i <= _fim-1)          
 	   			oPr:Say(nLin+530,nCol+20,alltrim(DBF->QtdeEmb),oFonteG)	         	
 	   		else
 	   			oPr:Say(nLin+530,nCol+20,alltrim(str(mod(val(DBF->Qtde),val(DBF->QtdeEmb)))),oFonteG)	 
 	   		endif	 	   			
 	   		oPr:Say(nLin+685,nCol+143,DBF->NumOp,oFontePP)	         	
	   		if (i <= _fim-1)          
 	   			oPr:Say(nLin+685,nCol+420,alltrim(DBF->QtdeEmb),oFontePP)	         	
 	   		else
 	   			oPr:Say(nLin+685,nCol+420,alltrim(str(mod(val(DBF->Qtde),val(DBF->QtdeEmb)))),oFontePP)	 
 	   		endif	 	   			
 	   		
 	   		if val(DBF->FolhaEtiq) > 0
   	   		oPr:Say(nLin+685,nCol+655,strzero(i,2) + "/" + alltrim(strzero((val(DBF->FolhaEtiq)*etiqpapel + val(DBF->SobraEtiq)),2)),oFontePP)	         	 	   	
   	   	else
   	   		oPr:Say(nLin+685,nCol+655,strzero(i,2) + "/" + alltrim(DBF->SobraEtiq),oFontePP)	         	 	   	
   	   	endif	   	   	
 	   		oPr:Say(nLin+739,nCol+210,DBF->Produto,oFontePP)	         	 	   	 	   	
 	   		oPr:Say(nLin+739,nCol+588,TMP->A7_CODCLI,oFonteSP)	         	 	   	 	   	 	   	
 	   		if j=etiqpapel/2
 	   			nLin +=1190   
 	   			nCol :=0
 	   		else
 	   			nCol+=913
 	   		endif
 	   		j+=1		 	   		
 	   		if j >etiqpapel
 	   			j:=1
 	   			oPr:EndPage()
					nLin := 370
					nCol := 0 	   			
 	   		endif		
 		   Next         
			//grava flag de etiqueta impressa no SC2 C2_IMPRESS
			cQuery1 := "UPDATE " +  RetSqlName( 'SC2' ) 
			cQuery1 += " SET C2_IMPRESS = 'S' "
			cQuery1 += "WHERE C2_NUM = '" + alltrim(DBF->NumOp) + "' "
			cQuery1 += "AND C2_PRODUTO = '" + alltrim(DBF->Produto) + "' "
			//TCQuery Abre uma workarea com o resultado da query
			TCsqlExec(cQuery1) 		   
 		endif
      DBF->(Dbskip())
		TMP->(Dbskip())      
   Enddo
   oPr:EndPage()
   oPr:Preview()
   oPr:End()
   MS_FLUSH()      
   msgbox("Todas as OP´s selecionadas foram marcadas como impressas!","Impressao de Etiquetas","INFO")
	
Return(nil)


Static Function fCalcula()
//calcula a quantidade de etiquetas e folhas de etiqueta para imprimir 
//todas as OP selecionadas
local _SomaEtiq,_SomaFolha
_SomaEtiq :=0
_SomaFolha :=0
DBF->(DBGotop())            
While !DBF->(EOF())
   If MARKED("OK")
      _SomaEtiq +=val(DBF->SobraEtiq)   
      _SomaFolha +=val(DBF->FolhaEtiq)
   endif   
   DBF->(DbSkip())
Enddo                                                          
//recalcula todas etiquetas
_SomaFolha +=INT(_SomaEtiq/etiqpapel)
_SomaEtiq=MOD(_SomaEtiq,etiqpapel) 

DBF->(DbGoTop()) 


@ 280,230 say "Folhas de Etiquetas"
@ 280,280 get _SomaFolha picture "999,999,999" SIZE 40,15 when .f.
@ 280,350 say "Etiquetas" 
@ 280,380 get _SomaEtiq picture "999,999,999" SIZE 40,15 when .f.

Return

Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF  += ".DBF"
_aDBF := {}
                                                  
AADD(_aDBF,{"OK"        ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"NumOP"     ,"C", 06,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Produto"   ,"C", 15,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Descricao" ,"C", 50,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Qtde"      ,"C", 08,0})         // Codigo do produto
AADD(_aDBF,{"QtdeEmb"   ,"C", 08,0})         // Codigo do produto
AADD(_aDBF,{"FolhaEtiq" ,"C", 08,0})         // Codigo do produto
AADD(_aDBF,{"SobraEtiq" ,"C", 08,0})         // Codigo do produto

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.) 


Return


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "PCP006"
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
aadd(aRegs,{cPerg,"01","do Produto       ?","do Produto       ?","do Produto       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","até Produto      ?","até Produto      ?","até Produto      ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

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
                                     