/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST049  ºAutor  ³Microsiga           º Data ³  23/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importacao do arquivo SZB para o SB7 (Inventario)           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB Usinagem                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhEst049()

SetPrvt("_cTipo")

AjustaSX1()
If !Pergunte('EST049',.T.)
   Return(nil)
Endif

If MsgYesNo("Confirma Importacao do Inventario","Inventario")
	Processa( {|| Gerando()   },"Gerando Dados para a Importacao")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Inventario",.T.)
Endif

Return


Static Function fImporta()

DbSelectArea("TMP")
TMP->(DbgoTop())
While !TMP->(Eof())

	MsProcTxt("Produto : "+TMP->ZB_COD)

	_cTipo := Space(02)
   If SB1->(DbSeek(xFilial("SB1")+TMP->ZB_COD),Found())	
		_cTipo := SB1->B1_TIPO
	Endif		

	If _cTipo >= mv_par05 .And. _cTipo <= mv_par06

		_nQuant := 0

		If TMP->ZB_QTDE1 == 0 .And. TMP->ZB_QTDE2 == 0 .And. TMP->ZB_QTDE3 == 0
			_nQuant := 0
		Endif

		If TMP->ZB_QTDE1 == TMP->ZB_QTDE2
			_nQuant := TMP->ZB_QTDE3
		Endif

		If TMP->ZB_QTDE1 <> TMP->ZB_QTDE2 
			_nQuant := TMP->ZB_QTDE3
		Endif
		
		If TMP->ZB_QTDE1 > 0 .And. TMP->ZB_QTDE2 == 0 .And. TMP->ZB_QTDE3 == 0
			_nQuant := TMP->ZB_QTDE1
		Endif
		

		// Grava SB7
		RecLock("SB7",.T.)
		SB7->B7_FILIAL  := xFilial("SB7")
		SB7->B7_COD     := TMP->ZB_COD
		SB7->B7_LOCAL	 := TMP->ZB_LOCAL
		SB7->B7_TIPO    := _cTipo
		SB7->B7_DOC     := TMP->ZB_DOC
		SB7->B7_QUANT   := _nQuant
		SB7->B7_DATA    := TMP->ZB_DATA
		SB7->B7_LOCALIZ := Iif(SB1->B1_LOCALIZ$"S",TMP->ZB_LOCALIZ,"")
		SB7->B7_LOTECTL := Iif(SB1->B1_RASTRO$"L",TMP->ZB_LOTE,"")      
   	    SB7->B7_DTVALID := TMP->ZB_DATA + 365
		MsUnLock("SB7")				

		SZB->(DbGoto(TMP->ZB_RECNO)) //If SZB->(DbSeek(xFilial("SZB")+TMP->ZB_ETIQ),Found())
		RecLock("SZB")
			SZB->ZB_LANC := "S"
		MsUnLock("SZB")
	//	Endif
						
	Endif		
	TMP->(Dbskip())
Enddo
DbSelectArea("TMP")
DbCloseArea()

Return


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST049"+Space(04)
aRegs   := {}

aadd(aRegs,{cPerg,"01","Do produto       ?","Do produto       ?","Do produto       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"02","Ate produto      ?","Ate produto      ?","Ate produto      ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"03","Do local         ?","Do local         ?","Do local         ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Ate local        ?","Ate local        ?","Ate local        ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Do Documento     ?","da Documento     ?","da Documento     ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Até Documento    ?","até Documento    ?","até Documento    ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
   cQuery := "SELECT R_E_C_N_O_ AS ZB_RECNO,* "
   cQuery += " FROM " + RetSqlName( 'SZB' )
   cQuery += " WHERE ZB_FILIAL = '" + xFilial("SZB")+ "'"
   cQuery += " AND ZB_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND ZB_LOCAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"   
   cQuery += " AND ZB_DOC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"   
   cQuery += " AND ZB_DATA BETWEEN '" + Dtos(mv_par07) + "' AND '" + Dtos(mv_par08) + "'"      
   cQuery += " AND ZB_LANC = ' '"      
   cQuery += " AND D_E_L_E_T_ = ' ' "
   cQuery += " ORDER BY ZB_COD ASC" 

	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","ZB_DATA","D")  // Muda a data de digitaçao de string para date    

Return                                   
