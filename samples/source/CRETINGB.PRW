#include "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcion   ¦ Retib    ¦ Autor ¦ Bruno Sobieski        ¦ Fecha 18.08.98  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descripcion Impresion del Certificados de Retencion de Ing. Brutos.    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User function CRETINGB()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cPerg:="RETENC"
Local tamanho:="P"

SetPrvt("CSTRING")
SetPrvt("LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CNATUREZA,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("LCONTINUA,NLIN,WNREL,NCNTITEM")
SetPrvt("CORDPAGO,NTOTALRET,NTOTBASE,NROCOPIA,PAGOTIPOANT")
SetPrvt("NOPC")
SetPrvt("I,J")



ValidPerg(cPerg)
//+-------------------------------------------------------------------------+
//¦ Verifica las preguntas seleccionadas, busca el padron de las Retenciones¦
//+-------------------------------------------------------------------------+


Pergunte(cPerg,.T.)               // Pregunta en SX1

cString:="SFE"
//+--------------------------------------------------------------+
//¦ Variables utilizadas para parametros                         ¦
//¦ mv_par01             // De la orden ?                        ¦
//¦ mv_par02             // Hasta la orden ?                     ¦ 
//+--------------------------------------------------------------+

limite :=220
titulo :=PADC("Emisión del Certificado de Retencion de Ing. Brutos." ,74)
cDesc1 :=PADC("Será solicitado el Intervalo de Ordenes de Pago para ",74)
cDesc2 :=PADC("la emisión de los Certificados de Retencion de Ing. Brutos.",74)
cDesc3 :=""
cNatureza:="" 
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administración"), 1, 2, 1,"",1 }
nomeprog:="CRETINGB" 
nLastKey:= 0 
lContinua := .T.
nLin:=31
wnrel    := "CRETINGB"


//+--------------------------------------------------------------+
//¦ Envia control a funcion SETPRINT                             ¦
//+--------------------------------------------------------------+
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicion del Formulario en la Impresora             ¦          
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif
VerImp()       

//+--------------------------------------------------------------+
//¦ Inicio de Procesamiento de la retencion                      ¦
//+--------------------------------------------------------------+
RptStatus({|| RptDetail()})
Return

Static Function RptDetail()


SetRegua(Val(mv_par02)-Val(mv_par01))
dbSelectArea("SFE")              
dbSetOrder(2)                  // Orden de pago + tipo de impuesto (I|B|G)
dbSeek(xFilial("SFE")+mv_par01+"B",.T.)

//+-----------------------------------------------------------+
//¦ Inicializa  Rutina de impresion                           ¦
//+-----------------------------------------------------------+
nCntItem := 1
While !Eof() .and. SFE->FE_FILIAL == xFilial("SFE");
   	.and. SFE->FE_ORDPAGO <= mv_par02 ;
	.and. lContinua
	If FE_TIPO#"B"
    	dbSkip()
        Loop
  	Endif
    cOrdPAGO := SFE->FE_ORDPAGO
    NTOTALret  :=0
    ntotbase :=0
       
    IF lAbortPrint
    	@ 00,01 PSAY "** CANCELADO POR EL OPERADOR **"
	    lContinua := .F.
        Exit
  	Endif

	NroCopIA:=1

    While NroCopia<=1
    	dbSelectArea("SFE")               
        dbSetOrder(2)    // Colocar en Orden de OP+tipo
		dbSeek(xFilial("SFE")+cOrdPAGO+"B",.T.)
		RemRCab()
		nCntItem:=1
       	pagotipoant:=cOrdPago+"B"
		While !Eof() .and. SFE->FE_FILIAL == xFilial("SFE");
                                         .and. SFE->FE_ordPAGO+FE_tipo == pAGOtipoant;
                                         .and. lContinua 
         
         	IF lAbortPrint
            	@ 00,01 PSAY "** CANCELADO POR EL OPERADOR **"
            	lContinua := .F.
    	       	Exit
        	 Endif
		//+-----------------------------------------------------------+
        //¦ Impresion de los Items de las Retenciones.                ¦
		//+-----------------------------------------------------------+
			If nCntItem > 21
				RemRRod()
				RemRCab()
			EndIf
	        
	        cOrdPago := SFE->FE_ORDPAGO

    //+--------------------------------------------------------------+
    //¦ Impresion de los Items del Certificado.                      ¦
   	//+--------------------------------------------------------------+
			IncRegua()
	        @ Nlin,000 PSAY "| " //+tipo de comprobante
	        @ Nlin,002 PSAY "OP" //+tipo de comprobante
	        @ nLin,008 PSAY "|"+Dtoc(SFE->FE_EMISSAO)
	        @ nLin,019 PSAY "|   00001 "
	        @ nLin,032 PSAY "|" + cOrdPago
	    	@ nLin,049 PSAY "|"
	        @ nLin,050 PSAY SFE->FE_VALBASE PICTURE "@E 999,999.99"
	        @ nLin,060 PSAY "| "
	        @ nLIN,062 PSAY SFE->FE_ALIQ PICTURE "@E 99.99"
	        @ nLin,067 PSAY "|"
	        @ NlIN,068 PSAY SFE->FE_RETENC PICTURE "@E 999,999.99"
	        @ nLin,077 PSAY "|"
	        nLin := nLin + 1
	        ntotalret:=nTotalret+SFE->FE_RETENC
	        ntotbase:=ntotbase+SFE->FE_VALBASE
			nCntItem := nCntItem + 1
		 	DbSelectArea("SFE")
			dbSkip()
		End
	
	//+-----------------------------------------------------------+
    //¦ Inicializa el pie.                                        ¦
	//+-----------------------------------------------------------+
		 RemRRod()
		NroCopia:= NroCopia + 1
	End 
	// DbSkip()
End

Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcion   ¦ RemRCab  ¦ Autor ¦ Bruno Sobieski        ¦ Fecha¦ 18.08.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descripcion Encabezado del Certificado de Retencion                    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Retib                                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function RemRCab
Static Function RemRCab()

Local CnROcERT:=SFE->FE_NROCERT     //Numero de certificado

cORDpago:= SFE->FE_ORDPAGO

dbSelectArea("SA2")
DbSetOrder(1)
dbSeek( xFilial("SA2") + SFE->FE_FORNECE + SFE->FE_LOJA) 
        
SetPrc(0,0)                                             // (Zera o Formulario)
@ 02,000 PSAY "-----------------------------------------------------------------"
@ 02,065 PSAY "-------------"
@ 03,000 PSAY "                         IMPUESTO SOBRE LOS INGRESOS BRUTOS"
@ 04,000 PSAY "                             Comprobante de Retencion"
@ 05,000 PSAY "-----------------------------------------------------------------"
@ 05,065 PSAY "-------------"
@ 06,000 PSAY "1|                            Nro. 0000 00"+Alltrim(cNroCert)
@ 07,000 PSAY "-----------------------------------------------------------------"
@ 07,065 PSAY "-------------"

@ 08,000 PSAY "2 | Agente de retencion"
@ 09,000 PSAY "-----------------------------------------------------------------"
@ 09,065 PSAY "-------------"
@ 10,003 PSAY "Numero de C.U.I.T.                            Nro de Agente de retencion"
@ 11,004 PSAY SM0->M0_CGC  PICTURE "999-999999-9" 
@ 11,050 PSAY SM0->M0_INSC
@ 12,003 PSAY "Razon Social"
@ 13,004 PSAY SM0->M0_NOMECOM
@ 14,000 PSAY "-----------------------------------------------------------------"
@ 14,065 PSAY "-------------"
@ 15,000 PSAY "3 | Datos del Contribuyente Sujeto a Retencion"
@ 16,000 PSAY "-----------------------------------------------------------------"
@ 16,065 PSAY "-------------"
@ 17,003 PSAY "Nro de C.U.I.T.: "
@ 18,014 PSAY SUBS(SA2->A2_CGC,1,2)+"-"+SUBS(SA2->A2_CGC,3,8)+"-"+SUBS(SA2->A2_CGC,11,1) 
@ 19,003 PSAY "Nro de Inscripcion a Ingresos Brutos : "
@ 20,014 PSAY SA2->A2_NROIB PICTURE "999-999999-9"
@ 21,003 PSAY "Razon Social : "
@ 22,014 PSAY SA2->A2_NOME 
@ 23,003 PSAY "Domicilio : "         
@ 24,014 PSAY ALLTRIM(SA2->A2_END) + "   ("+ alltrim(SA2->A2_CEP) + ")  - " +SA2->A2_MUN
@ 25,000 PSAY "-----------------------------------------------------------------"
@ 25,065 PSAY "-------------"                      
@ 26,000 PSAY "4 | Datos de la Operacion"
@ 27,000 PSAY "-----------------------------------------------------------------"
@ 27,065 PSAY "-------------"                      
@ 28,000 PSAY "| Tipo | Fecha de  | Codigo de  | N.Comprob.que  |  Base    | Alic.|Retencion|"
@ 29,000 PSAY "| Comp.| Operacion | Operacion  | Origino la Ret.| Imponible|      |         |"
@ 30,000 PSAY "_________________________________________________________________"
@ 30,065 PSAY "_____________"
nLin := 31
DbSelectArea("SFE")
Return

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcion   ¦ RemRRod  ¦ Autor ¦ Bruno Sobieski        ¦ Fecha¦ 18.08.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descripcion Pie del Certificado de Retencion                           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Retib                                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function RemRRod
Static Function RemRRod() 

nLin:=nLin+1
@ nLin-1,000 PSAY "|                                                                            |"
@ nlin,000 PSAY "|                                              Total "+str(nTotBase,18,2) 
@ nLin,068 PSAY ntotalret PICTURE "@E 999,999.99"
@ nlin,077 PSAY "|"
nLin:=nLin+1
@ nLin,000 PSAY "-----------------------------------------------------------------"
@ nLin,065 PSAY "-------------"
@ nLin+1,000 PSAY "5 | Observaciones"
@ nLin+2,000 PSAY "-----------------------------------------------------------------"
@ nLin+2,065 PSAY "-------------"
                
ImpObs(nLin+3)
@ nLin+1,000  PSAY "-----------------------------------------------------------------"
@ nLin+1,065  PSAY "-------------"
@ nLin+3,000  PSAY "6 |" 
@ nLin+4,000  PSAY "-----------------------------------------------------------------"
@ nLin+4,065  PSAY "-------------"
@ nlin+11,004 PSAY "----------------------                      ------------------------------"
@ nlin+12,007 PSAY "Lugar y Fecha                               Firma y Sello Aclaratorio "
@ nLin+14,000 PSAY "-----------------------------------------------------------------"
@ nLin+14,065 PSAY "-------------"
@ nLin+15,001 PSAY " "

if !(cOrdpago==mv_par02.and.nrocopia==1)
    EJECT
Endif

DbSElectArea("SFE")

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcion   ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descripcion¦ Verifica posicionamento de papel en la Impresora          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
//+---------------------+
//¦ Inicio de Funcion   ¦
//+---------------------+
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
If aReturn[5]==2

   nOpc       := 1
	
   While .T.
      SetPrc(0,0)
      dbCommitAll()

      @ nLin ,000 PSAY " "
      @ nLin ,004 PSAY "*"
      @ nLin ,022 PSAY "."
      Do Case
         Case nOpc==1
            lContinua:=.T.
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦VALIDPERG ¦ Autor ¦ Armando T. Buchina    ¦ Data ¦ 12/01/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica las preguntas incluyendolas en caso que no existan¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ aRemEmi .prx                                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function ValidPerg
Static Function ValidPerg(cPerg)
Local  j,i:=0                 
Local _sAlias := Alias()
Local aRegs:={}

dbSelectArea("SX1")
dbSetOrder(1)


aAdd(aRegs,{cPerg,"01","¿De la Orden de Pago?","mv_ch1","C",6,0,0,"G","","mv_par01",""     ,"000000","",""           ,"","",""         ,"","","","","","","",""})
aAdd(aRegs,{cPerg,"02","¿A la Orden de Pago ?","mv_ch2","C",6,0,0,"G","","mv_par02",""     ,"999999","",""           ,"","",""         ,"","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)
Return

Static Function ImpObs(nLinha)

Local aAreaSfe :=SFE->(Getarea())
dbSelectArea("SFE")              
dbSetOrder(2)                  // Orden de pago + tipo de impuesto (I|B|G)
dbSeek(xFilial("SFE")+cOrdPAGO+"B",.T.)
While xFilial("SFE")== SFE->FE_FILIAL .And. cOrdPAGO == SFE->FE_ORDPAGO   .And. SFE->FE_TIPO== "B"    
	If !(Alltrim(SFE->FE_NROCERT) $ "NORET")
		If nLinha > 60
			RemRCab()
		EndIf	
		@ nLinha,000 PSAY "|"		
		@ nLinha,003 PSAY SFE->FE_SERIE
	    @ nLinha,008 PSAY SFE->FE_NFISCAL
		@ nLinha,077 PSAY "|"         
	EndIf	
	SFE->(DbSkip())
EndDo       

SFE->(RestArea(aAreaSfe))
nLin := nLinha
If nLin > 48
	RemRCab()
EndIf	
Return()
   