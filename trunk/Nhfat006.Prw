/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT006 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 30/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera arq. de faturament acumulado dia a dia por cliente/Mer³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

/*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT006()

SetPrvt("_cArqDbf, cQuery,_aFields,_nMes,i,_nCont,_cArqNtx,_cOrdem,_lAchou")   

_cArqDBF := Space(12)

If File("FAT006.DBF" )  
   fErase("FAT006.DBF")  // Deleta arquivo de dados temporario
Endif   

Processa({|| Gerando() }, "Acumulados do Faturamento")

If File(_cArqNtx+OrdBagExt())
   Ferase(_cArqNtx+OrdBagExt())
Endif   

DbSelectArea("TMP")
DbCloseArea()
DbSelectArea("FAT")
DbCloseArea()

//Close TMP
//Close FAT 
Return

Static Function Gerando()

   cQuery := "SELECT SD2.D2_EMISSAO AS 'ETL_DATA', "   
   cQuery += "SUM(SD2.D2_QUANT) AS 'ETL_QTDEFAT', "
   cQuery += "SUM(SD2.D2_TOTAL) AS 'ETL_VLRFAT', "
   cQuery += "0 AS 'ETL_QTDEREL', "
   cQuery += "0 AS 'ETL_VLRREL' "
//   cQuery += " ' ' AS 'ETL_OBS' "
   cQuery += "FROM " +  RetSqlName( 'SD2' ) +" SD2, " +  RetSqlName( 'SA1' ) +" SA1, "+ RetSqlName( 'SB1' ) +" SB1, "+ RetSqlName( 'SF4' ) +" SF4 "    
   cQuery += "WHERE SD2.D2_FILIAL = '" + xFilial("SD2")+ "' "
   cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "
   cQuery += "AND SA1.A1_FILIAL = '" + xFilial("SA1")+ "' "
   cQuery += "AND SF4.F4_FILIAL = '" + xFilial("SF4")+ "' "   
   cQuery += "AND SD2.D_E_L_E_T_ = ' '  "
   cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SF4.D_E_L_E_T_ = ' ' "
   cQuery += "AND SD2.D2_CLIENTE = SA1.A1_COD "
   cQuery += "AND SD2.D2_LOJA = SA1.A1_LOJA "
   cQuery += "AND SD2.D2_COD = SB1.B1_COD "
   cQuery += "AND SD2.D2_TES = SF4.F4_CODIGO "
   cQuery += "AND SF4.F4_DUPLIC = 'S' "
   cQuery += "AND SD2.D2_TIPO <> 'D' "
   cQuery += "AND SD2.D2_EMISSAO >= '20040901' "
   cQuery += "GROUP BY SD2.D2_EMISSAO "
   cQuery += "UNION "
   cQuery += "SELECT SZC.ZC_DATAFAT AS 'ETL_DATA', "
   cQuery += "0 AS 'ETL_QTDEFAT', "
   cQuery += "0 AS 'ETL_VLRFAT', "
   cQuery += "SUM(SZC.ZC_QTDEREL)  AS 'ETL_QTDEREL', "
   cQuery += "SUM(SZC.ZC_VALORRE) AS 'ETL_VLRREL' "
//   cQuery += " ' ' AS 'ETL_OBS'"
   cQuery += "FROM " +  RetSqlName( 'SZC' ) +" SZC, " +  RetSqlName( 'SA1' ) +" SA1, "+ RetSqlName( 'SB1' ) +" SB1 "
   cQuery += "WHERE SZC.ZC_FILIAL = '" + xFilial("SZC")+ "' "
   cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "
   cQuery += "AND SA1.A1_FILIAL = '" + xFilial("SA1")+ "' "
   cQuery += "AND SZC.D_E_L_E_T_ = ' ' "
   cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SZC.ZC_CLIENTE = SA1.A1_COD "
   cQuery += "AND SZC.ZC_LOJA = SA1.A1_LOJA "
   cQuery += "AND SZC.ZC_COD = SB1.B1_COD "
   cQuery += "AND SZC.ZC_DATA >= '20040901' "                          
   cQuery += "AND SZC.ZC_DATAFAT <> ' ' "      
   cQuery += "GROUP BY SZC.ZC_DATAFAT "
   cQuery += "UNION "
   cQuery += "SELECT SZD.ZD_DATA AS 'ETL_DATA', "
   cQuery += "SZD.ZD_QTDE AS 'ETL_QTDEFAT',"
   cQuery += "SZD.ZD_VALOR AS 'ETL_VLRFAT',"
   cQuery += "0  AS 'ETL_QTDEREL',"
   cQuery += "0  AS 'ETL_VLRREL' "
//   cQuery += "SZD.ZD_OBS AS 'ETL_OBS' "
   cQuery += "FROM " +  RetSqlName( 'SZD' ) +" SZD, " +  RetSqlName( 'SA1' ) +" SA1, "+ RetSqlName( 'SB1' ) +" SB1 "    
   cQuery += "WHERE SZD.ZD_FILIAL = '01'"  // + xFilial("SZD")+ "' "
   cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "
   cQuery += "AND SA1.A1_FILIAL = '" + xFilial("SA1")+ "' "
   cQuery += "AND SZD.D_E_L_E_T_ = ' ' "
   cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
   cQuery += "AND SZD.ZD_CLIENTE = SA1.A1_COD "
   cQuery += "AND SZD.ZD_LOJA = SA1.A1_LOJA "
   cQuery += "AND SZD.ZD_COD = SB1.B1_COD "
   
   MemoWrit('C:\TEMP\FAT006.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
  TCQUERY cQuery NEW ALIAS "TMP"

DbSelectArea("TMP")
Processa( {|| GeraArq() }, "Aguarde Gerando Arquivo de Acumulados..")

Return


Static Function GeraArq()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
//_cArqDBF += ".DBF"
_aFields := {}

AADD(_aFields,{"DTA"     ,"D", 08,0})         // Data                   
AADD(_aFields,{"DIAMES"  ,"C", 05,0})         // Dia/Mes
AADD(_aFields,{"QTDEFAT" ,"N", 14,2})         // qtde faturamento
AADD(_aFields,{"TOTALFAT","N", 14,2})         // total faturamento
AADD(_aFields,{"QTDEREL" ,"N", 14,2})         // qtde release
AADD(_aFields,{"VALORREL","N", 14,2})         // valor release

DbCreate("FAT006",_aFields)
DbUseArea(.T.,,"FAT006","FAT",.T.,.F.)

// Criacao de Indice Temporario
_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "DTOS(FAT->DTA)"
IndRegua("FAT",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TMP->(DBGotop())            
ProcRegua(TMP->(RecCount()))
_nMes := Month(STOD(TMP->ETL_DATA))
While !TMP->(EOF())
	

// If _nMes = Month(STOD(TMP->ETL_DATA))    
           
      _nCont:= 0  
      For i := Day(STOD(TMP->ETL_DATA)) to f_UltDia(STOD(TMP->ETL_DATA)) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico)          For 

	      If Day(STOD(TMP->ETL_DATA)) = f_UltDia(STOD(TMP->ETL_DATA)) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico) 
  	         If FAT->(Dbseek(TMP->ETL_DATA))              
	           _lAchou := .T. 
	         Else
   	           _lAchou := .F. 
   	         Endif
	      Else                 
   	         If FAT->(Dbseek(DTOS(STOD(TMP->ETL_DATA) +_nCont)))              
	           _lAchou := .T. 
	         Else
   	           _lAchou := .F. 
   	         Endif
  	      Endif   
          
          If _lAchou
          
 	         RecLock("FAT",.F.)                
   		        FAT->QTDEFAT  += TMP->ETL_QTDEFAT
     		    FAT->TOTALFAT += TMP->ETL_VLRFAT
	    	    FAT->QTDEREL  += TMP->ETL_QTDEREL
		        FAT->VALORREL += TMP->ETL_VLRREL
		  Else      		  		  		  
   	         RecLock("FAT",.T.)                
	            If Day(STOD(TMP->ETL_DATA)) = f_UltDia(STOD(TMP->ETL_DATA)) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico) 
	               FAT->DTA      := STOD(TMP->ETL_DATA)
 	            Else 
  	               FAT->DTA      := STOD(TMP->ETL_DATA) + _nCont
     	        Endif   
    		    FAT->QTDEFAT  := TMP->ETL_QTDEFAT
    		    FAT->TOTALFAT := TMP->ETL_VLRFAT
    		    FAT->QTDEREL  := TMP->ETL_QTDEREL
    		    FAT->VALORREL := TMP->ETL_VLRREL		  		  		  
//       		    FAT->OBS      := TMP->ETL_OBS	
       		    FAT->DIAMES   := Strzero(Day(FAT->DTA)+_nCont,2)+"/"+Strzero(Month(FAT->DTA),2)
	      Endif
          MsUnlock("FAT") 	     
	      _nCont++	     
         IncProc("Gerando Arquivo Acumulados")	      
	  Next    
//     Endif	  
   TMP->(DbSkip())
EndDo

FAT->(DBGotop())            
ProcRegua(FAT->(RecCount()))
_nQtdeFat := FAT->QTDEFAT
_nQtdeRel := FAT->QTDEREL
_nVlrFat  := FAT->TOTALFAT 
_nVlrRel  := FAT->VALORREL
_dData    := FAT->DTA
While !FAT->(EOF())
	
   IncProc("Finalizado....")
   
   RecLock("FAT",.F.)                
      FAT->DIAMES   := Strzero(Day(FAT->DTA),2)+"/"+Strzero(Month(FAT->DTA),2)
      FAT->TOTALFAT := FAT->TOTALFAT /1000000
      FAT->VALORREL := FAT->VALORREL/1000000
   MsUnlock("FAT") 	     

   FAT->(DbSkip())
   
   If _nQtdeFat = FAT->QTDEFAT .And. _nQtdeRel = FAT->QTDEREL .And.;
      _nVlrFat  = FAT->TOTALFAT  .And. _nVlrRel  = FAT->VALORREL

      RecLock("FAT",.F.)                
        FAT->(Dbdelete())
      MsUnlock("FAT") 	     
   Else
	  _nQtdeFat := FAT->QTDEFAT
	  _nQtdeRel := FAT->QTDEREL
	  _nVlrFat  := FAT->TOTALFAT 
	  _nVlrRel  := FAT->VALORREL
   Endif
EndDo

MS_FLUSH()
Return
