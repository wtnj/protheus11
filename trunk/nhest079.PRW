/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST079  ºAutor  ³Alexandre R. Bento  º Data ³  05/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Explosao dos produtos montados no processo para inventario  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB Usinagem e Fundição                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhEst079()

AjustaSX1()
If !Pergunte('EST079',.T.)
   Return(nil)
Endif

If MsgYesNo("Confirma Explosao do Inventario","Inventario")
	Processa( {|| Gerando()   },"Gerando Dados para Explosao")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Inventario",.T.)
Endif

Return


Static Function fImporta()

DbSelectArea("TMP")
TMP->(DbgoTop())
While !TMP->(Eof())

	MsProcTxt("Produto : "+TMP->ZB_COD)

	RecLock("SZB",.T.)
		SZB->ZB_FILIAL  := xFilial("SZB")
		SZB->ZB_COD     := TMP->G1_COMP        
//		SZB->ZB_DESC    := TMP->B1_DESC        		
		SZB->ZB_CONT    := '3' //Contagem final
		SZB->ZB_ETIQ    := TMP->ZB_ETIQ
		SZB->ZB_LOCAL	:= TMP->ZB_LOCAL
		SZB->ZB_DOC     := "EXP0"+TMP->ZB_LOCAL
		SZB->ZB_QTDE1   := TMP->G1_QUANT
		SZB->ZB_QTDE3   := TMP->G1_QUANT
		SZB->ZB_DATA    := TMP->ZB_DATA
		SZB->ZB_LOCALIZ := '01'
		SZB->ZB_LOTE    := TMP->ZB_LOTE
	MsUnLock("SZB")				

	SZB->(Dbgoto(TMP->ZB_RECNO))
	If SZB->ZB_OPERACA <> ' '
		If !Deleted()
			RecLock("SZB")
			  SZB->(DbDelete())
  		    MsUnLock("SZB")
		Endif
	Endif	
	TMP->(Dbskip())
Enddo

TMP->(DbCloseArea())

Return


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST079"+Space(04)
aRegs   := {}

aadd(aRegs,{cPerg,"01","Do produto       ?","Do produto       ?","Do produto       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"02","Ate produto      ?","Ate produto      ?","Ate produto      ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"03","Do local         ?","Do local         ?","Do local         ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Ate local        ?","Ate local        ?","Ate local        ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Do Documento     ?","da Documento     ?","da Documento     ?","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Até Documento    ?","até Documento    ?","até Documento    ?","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Da Data          ?","da Data          ?","da Data          ?","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Até Data         ?","até Data         ?","até Data         ?","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"08","Até Data         ?","até Data         ?","até Data         ?","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
	     FieldPut(j, aRegs[i,j])
	 Next
     MsUnlock("SX1")
   Next
EndIf                   

dbSelectArea(_sAlias)

Return


Static Function Gerando()      

   cQuery := "SELECT SZB.R_E_C_N_O_ AS ZB_RECNO,SB1.B1_TIPO,SB1.B1_DESC,SZB.*,SG1.G1_COD,SG1.G1_COMP,SZB.ZB_QTDE3*SG1.G1_QUANT AS G1_QUANT"
   cQuery += " FROM " + RetSqlName( 'SZB' ) +" SZB,"+ RetSqlName( 'SG1' ) +" SG1,"+ RetSqlName( 'SB1' ) +" SB1"            
   cQuery += " WHERE ZB_FILIAL = '" + xFilial("SZB")+ "'"   
   cQuery += " AND G1_FILIAL = '" + xFilial("SG1")+ "'"      
   cQuery += " AND B1_FILIAL = '" + xFilial("SB1")+ "'"         
   cQuery += " AND SZB.ZB_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND SZB.ZB_LOCAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"   
   cQuery += " AND SZB.ZB_DOC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"   
   cQuery += " AND SZB.ZB_DATA BETWEEN '" + Dtos(mv_par07) + "' AND '" + Dtos(mv_par08) + "'"      
   cQuery += " AND SZB.ZB_LANC = ' '"      
   cQuery += " AND SZB.ZB_OPERACA <> ' '"  
   cQuery += " AND SG1.G1_OPERACA <= SZB.ZB_OPERACA"     
   cQuery += " AND SG1.G1_INI <='" + Dtos(Ddatabase) + "' AND SG1.G1_FIM > '"+Dtos(Ddatabase)+ "'"
   cQuery += " AND SG1.G1_COD = SZB.ZB_COD"  
   cQuery += " AND SG1.G1_COMP = SB1.B1_COD"     
   cQuery += " AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'"        
   cQuery += " AND SZB.D_E_L_E_T_ = ' ' "
   cQuery += " AND SG1.D_E_L_E_T_ = ' ' "   
   cQuery += " AND SB1.D_E_L_E_T_ = ' ' "      
   cQuery += " ORDER BY SZB.ZB_COD ASC" 
//   MemoWrit('C:\TEMP\NHEST079.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","ZB_DATA","D")  // Muda a data de digitaçao de string para date    

Return                                   
