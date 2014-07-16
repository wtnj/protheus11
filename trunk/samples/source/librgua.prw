#INCLUDE "LibrGua.ch"
#include "PROTHEUS.CH"        

STATIC aMeses    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBRGUA   º Autor ³ Fernando Machima   ºFecha ³  03/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o Livro Fiscal de Vendas para o pais Guatemala     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIBRGUA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracion de Variables                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1   := STR0001 //"Este programa tiene como objetivo imprimir informe "
Local cDesc2   := STR0002 //"de acuerdo con los parámetros informados por el usuario."
Local cDesc3   := STR0042 //"Libro Fiscal"
Local cPict    := ""
Local titulo   := STR0042 //"Libro Fiscal"
Local imprime  := .T.
Local aOrd     := {}
Local cPerg    := "LIBGUA"
Local aAreaSF3 := {}
Local aAreaAtu := GetArea()

Private li          := 80
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "LIBRGUA" // Coloque aquí el nombre del programa para impresión en el encabezamiento
Private nTipo       := 15
Private aReturn     := {STR0045, 1, STR0046, 2, 1, nomeprog, "", 2}  //"Zebrado"###"Administracao"
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "LIBRGUA" // Coloque aquí el nombre del archivo usado para impresión en disco
Private cAliasSF3   := "SF3"
Private lQuery      := .F.

// Verifica se eh uma base TopConnect
#IFDEF TOP
	If TCSrvType() != "AS/400"
		lQuery := .T.
	EndIf
#ENDIF	

// Caso as perguntas nao existam as cria no arquivo SX1                 
AjustaSx1(cPerg)

// Determina qual livro sera impresso e o tamanho do relatorio                                     
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                         ³
//³mv_par01             // Mes                                  ³
//³mv_par02             // Ano                                  ³
//³mv_par03             // Filial de                            ³
//³mv_par04             // Filial ate                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF3")
aAreaSF3 := GetArea()
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta la interfase estandar con el usuario...                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cAliasSF3,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cAliasSF3)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procesamiento. RPTSTATUS monta ventana con la regla de procesamiento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport()},Titulo)

// Restaura a area do arquivo SF3
RestArea(aAreaSF3)

// Restaura a area original da entrada da rotina
RestArea(aAreaAtu)

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncion   ³RUNREPORT º Autor ³ Julio Cesar        ºFecha ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcion auxiliar llamada por la RPTSTATUS. La funcion      º±±
±±º          ³ RPTSTATUS monta la ventana con la regla de procesamiento.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport()

Local dDataIni   := Ctod("01/"+StrZero(Val(mv_par01),2)+"/"+mv_par02,"ddmmyyyy")
Local dDataFim   := LastDay(dDataIni)
Local cFiltro    := ""
Local cChave     := ""
Local cIndexSF3  := ""
Local cFilAtu    := ""
Local cCpoBAS    := ""
Local cCpoVAL    := ""
Local cNumeroUlt := Space(TamSX3("F3_NFISCAL")[1])
Local cSerieUlt  := Space(TamSX3("F3_SERIE")[1])
Local cTipoNFAtu := ""
Local cTipoNCCAtu:= ""
Local cPictVal   := "9,999,999,999.99"
Local cPictZero  := "9.99"
Local cCposSF3   := ""
Local cTipoNF    := ""
Local cTipoNCC   := ""
Local cFilialAtu := ""
Local dDataAtu   := ""
Local aTES       := {}
Local aInfTES    := {}
Local aStruSF3   := {}
Local aNFS       := {}
Local aNCC       := {}
Local nPosTES    := 0
Local nPosNF     := 0
Local nPosNCC    := 0
Local nI
Local nX         := 0
Local nQuantFilial:= 0
Local lNovaFilial := .F.

Private nTotBaseCon := 0   //Total por loja de base do imposto para NF ou NDC - Contado
Private nTotVlrCon  := 0   //Total por loja de valor do imposto para NF ou NDC - Contado
Private nTotBaseCre := 0   //Total por loja de base do imposto para NF ou NDC - Credito
Private nTotVlrCre  := 0   //Total por loja de valor do imposto para NF ou NDC - Credito
Private nTotIseCon  := 0   //Total por loja de isentos de imposto para NF ou NDC - Contado
Private nTotIseCre  := 0   //Total por loja de isentos de imposto para NF ou NDC - Credito
Private nTotNCBsCon := 0   //Total por loja de base do imposto para NCC - Contado
Private nTotNCVlCon := 0   //Total por loja de valor do imposto para NCC - Contado
Private nTotNCBsCre := 0   //Total por loja de base do imposto para NCC - Credito
Private nTotNCVlCre := 0   //Total por loja de valor do imposto para NCC - Credito  
Private nTotNCIsCon := 0   //Total por loja de isentos de imposto para NCC - Contado
Private nTotNCIsCre := 0   //Total por loja de isentos de imposto para NCC - Credito

Private nGerBaseCon := 0   //Total geral de base do imposto para NF ou NDC - Contado
Private nGerVlrCon  := 0   //Total geral de valor do imposto para NF ou NDC - Contado
Private nGerBaseCre := 0   //Total geral de base do imposto para NF ou NDC - Credito
Private nGerVlrCre  := 0   //Total geral de valor do imposto para NF ou NDC - Credito
Private nGerIseCon  := 0   //Total geral de isentos de imposto para NF ou NDC - Contado
Private nGerIseCre  := 0   //Total geral de isentos de imposto para NF ou NDC - Credito
Private nGerNCBsCon := 0   //Total geral de base do imposto para NCC - Contado
Private nGerNCVlCon := 0   //Total geral de valor do imposto para NCC - Contado
Private nGerNCBsCre := 0   //Total geral de base do imposto para NCC - Credito
Private nGerNCVlCre := 0   //Total geral de valor do imposto para NCC - Credito  
Private nGerNCIsCon := 0   //Total geral de isentos de imposto para NCC - Contado
Private nGerNCIsCre := 0   //Total geral de isentos de imposto para NCC - Credito

// Realiza o filtro dos dados, conforme os parametros informados
If !lQuery
	cFiltro := "(F3_FILIAL >= '"+mv_par03+"' .And. F3_FILIAL <= '"+mv_par04+"')"
   	cFiltro += " .And. (DTOS(F3_ENTRADA) >= '"+DTOS(dDataIni)+"' .And. DTOS(F3_ENTRADA) <= '"+DTOS(dDataFim)+"')"
   	cFiltro += " .And. Empty(F3_DTCANC)"      
    cFiltro += " .And. F3_TIPOMOV == 'V'"    
    cFiltro += " .And. F3_MANUAL <> 'S'"        

   	cChave    := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_CORRENT+F3_ESPECIE+F3_NFISCAL"
   	cIndexSF3 := CriaTrab(NIL,.F.)

   	IndRegua(cAliasSF3,cIndexSF3,cChave,,cFiltro,STR0003) //"Filtrando registros..."
	nIndex	:=	RetIndex()
   	dbSetIndex(cIndexSF3+OrdBagExt())	
	dbSetOrder(nIndex+1) 
Else
	cAliasSF3 := "SF3TMP"
    aStruSF3  := dbStruct()

	cCposSF3  := "F3_FILIAL,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,"
    cCposSF3  += "F3_VALCONT,F3_TIPOMOV,F3_DTCANC,F3_TES,F3_EXENTAS,F3_ESPECIE,"      
    cCposSF3  += "F3_CORRENT"    
    For nX := 1 To Len(aStruSF3)
    	If "F3_BASIMP"$AllTrim(aStruSF3[nX][1]) .Or. "F3_VALIMP"$AllTrim(aStruSF3[nX][1])
    		cCposSF3 += ","+AllTrim(aStruSF3[nX][1])
    	EndIf
    Next nX

    cQuery := "SELECT "+cCposSF3
    cQuery += "FROM "+RetSqlName("SF3")+" "					
    cQuery += "WHERE "
    cQuery += "F3_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
    cQuery += "F3_ENTRADA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
    cQuery += "F3_DTCANC = '' AND "
    cQuery += "F3_TIPOMOV = 'V' AND "    
    cQuery += "F3_MANUAL <> 'S' AND "        
      
    cQuery += "D_E_L_E_T_<>'*' "
    cQuery += "ORDER BY F3_FILIAL,F3_ENTRADA,F3_CORRENT,F3_ESPECIE,F3_NFISCAL"

	cQuery := ChangeQuery(cQuery)
 	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)
	For nX := 1 To Len(aStruSF3)
 		If AllTrim(aStruSF3[nX,1])$cCposSF3 .And. aStruSF3[nX,2] != "C" 
	 		TcSetField(cAliasSF3,aStruSF3[nX,1],aStruSF3[nX,2],aStruSF3[nX,3],aStruSF3[nX,4])
	   	EndIf
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica cuantos registros seran procesados para la regla ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

DbSelectArea(cAliasSF3)
dbGoTop()  	

If !Eof()
   cFilAtu  := F3_FILIAL
   dDataAtu := F3_ENTRADA
EndIf
   
While !Eof()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Comprobar la anulacion por el usuario...                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If lAbortPrint
    	@li,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
    	Exit
   	Endif
	
	While !Eof() .And. F3_FILIAL == cFilAtu

       While !Eof() .And. F3_ENTRADA == dDataAtu

          //Assumir como default conteudo "N"(Venda a Contado)
          cTipoNFAtu  := IIf(Empty(F3_CORRENT),"N",F3_CORRENT)
          
          // Verifica se os informacoes do TES ja foram pesquisadas
	      If (nPosTES := aScan(aTES,{|x| Trim(x[1])==Trim(F3_TES)})) > 0
		     cCpoBas := aTES[nPosTES][2]
		     cCpoVal := aTES[nPosTES][3]	
	      Else
		     aInfTES := TesImpInf(F3_TES)
		     If !Empty(aInfTES)		
			    AAdd(aTES,{F3_TES,"F3"+SubStr(aInfTES[1][8],3),"F3"+SubStr(aInfTES[1][6],3)})	
			    cCpoBas := "F3"+SubStr(aInfTES[1][8],3)
			    cCpoVal := "F3"+SubStr(aInfTES[1][6],3)
		     Else 
			    AAdd(aTES,{F3_TES,"F3_BASIMP1","F3_VALIMP1"})	
			    cCpoBas := "F3_BASIMP1"
			    cCpoVal := "F3_VALIMP1"
		     EndIf
		  EndIf   
		   
		  If AllTrim(F3_ESPECIE) $ "NF|NDC"
		     //NF ou NDC Contado
		     If cTipoNFAtu == "N"
		        nPosNF  := aScan(aNFS,{|x| x[01] == cFilAtu .And. x[02] == dDataAtu .And. x[3] == "1"})
		        If nPosNF == 0		        
	   		       AAdd(aNFS,{F3_FILIAL,F3_ENTRADA,"1",F3_NFISCAL,F3_SERIE,Space(TamSX3("F3_NFISCAL")[1]),;
	   		                   Space(TamSX3("F3_SERIE")[1]),F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),F3_EXENTAS})	   		   
                Else
                   aNFS[nPosNF][8] += F3_VALCONT
                   aNFS[nPosNF][9] += FieldGet(FieldPos(cCpoBAS))
                   aNFS[nPosNF][10] += FieldGet(FieldPos(cCpoVAL))                    
                   aNFS[nPosNF][11] += F3_EXENTAS                    
                EndIf		         
             //NF ou NDC Credito   
		     Else
		        nPosNF  := aScan(aNFS,{|x| x[01] == cFilAtu .And. x[02] == dDataAtu .And. x[3] == "2"})
		        If nPosNF == 0
	   		       AAdd(aNFS,{F3_FILIAL,F3_ENTRADA,"2",F3_NFISCAL,F3_SERIE,Space(TamSX3("F3_NFISCAL")[1]),;
	   		                  Space(TamSX3("F3_SERIE")[1]),F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),F3_EXENTAS})	   		   
                Else
                   aNFS[nPosNF][8]  += F3_VALCONT
                   aNFS[nPosNF][9]  += FieldGet(FieldPos(cCpoBAS))
                   aNFS[nPosNF][10] += FieldGet(FieldPos(cCpoVAL))                    
                   aNFS[nPosNF][11] += F3_EXENTAS                    
                EndIf		         		            
		     EndIf		      
		     cNumeroUlt  := F3_NFISCAL
		     cSerieUlt   := F3_SERIE
		     cTipoNF     := cTipoNFAtu
		     cFilAtu     := F3_FILIAL
		  
		     DbSkip()
		     //Verifica se eh o ultimo registro para gravar a numeracao final
		     cTipoNFAtu  := IIf(Empty(F3_CORRENT),"N",F3_CORRENT)
		     lNovaFilial := cFilAtu != F3_FILIAL
		     If Eof() .Or. F3_ENTRADA > dDataAtu .Or. cTipoNFAtu != cTipoNF .Or.;
		        lNovaFilial .Or. AllTrim(F3_ESPECIE) == "NCC"
		        aNFS[len(aNFS)][6]  := cNumeroUlt
		        aNFS[len(aNFS)][7]  := cSerieUlt    		     
		     EndIf
		  ElseIf AllTrim(F3_ESPECIE) == "NCC" 
		     //NCC contado
		     If cTipoNFAtu == "N"
		        nPosNCC  := aScan(aNCC,{|x| x[01] == cFilAtu .And. x[02] == dDataAtu .And. x[3] == "1"})
		        If nPosNCC == 0		        
	   		       AAdd(aNCC,{F3_FILIAL,F3_ENTRADA,"1",F3_NFISCAL,F3_SERIE,Space(TamSX3("F3_NFISCAL")[1]),;
	   		                   Space(TamSX3("F3_SERIE")[1]),F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),F3_EXENTAS})	   		   
                Else
                   aNCC[nPosNCC][08] += F3_VALCONT
                   aNCC[nPosNCC][09] += FieldGet(FieldPos(cCpoBAS))
                   aNCC[nPosNCC][10] += FieldGet(FieldPos(cCpoVAL))                    
                   aNCC[nPosNCC][11] += F3_EXENTAS                    
                EndIf		         
             //NCC Credito   
		     Else
		        nPosNCC  := aScan(aNCC,{|x| x[01] == cFilAtu .And. x[02] == dDataAtu .And. x[3] == "2"})
		        If nPosNCC == 0
	   		       AAdd(aNCC,{F3_FILIAL,F3_ENTRADA,"2",F3_NFISCAL,F3_SERIE,Space(TamSX3("F3_NFISCAL")[1]),;
	   		                  Space(TamSX3("F3_SERIE")[1]),F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),F3_EXENTAS})	   		   
                Else
                   aNCC[nPosNCC][08] += F3_VALCONT
                   aNCC[nPosNCC][09] += FieldGet(FieldPos(cCpoBAS))
                   aNCC[nPosNCC][10] += FieldGet(FieldPos(cCpoVAL))                    
                   aNCC[nPosNCC][11] += F3_EXENTAS                    
                EndIf		         		            
		     EndIf		      
		     cNumeroUlt  := F3_NFISCAL
		     cSerieUlt   := F3_SERIE
		     cTipoNCC    := cTipoNCCAtu
		     cFilAtu     := F3_FILIAL
		  
		     DbSkip()
		     //Verifica se eh o ultimo registro para gravar a numeracao final
		     cTipoNCCAtu  := IIf(Empty(F3_CORRENT),"N",F3_CORRENT)
		     lNovaFilial  := cFilAtu != F3_FILIAL
		     If Eof() .Or. F3_ENTRADA > dDataAtu .Or. cTipoNCCAtu != cTipoNCC .Or.;
		        lNovaFilial .Or. AllTrim(F3_ESPECIE) $ "NF|NDC"
		        aNCC[len(aNCC)][6]  := cNumeroUlt
		        aNCC[len(aNCC)][7]  := cSerieUlt    		     
		     EndIf		  
		  EndIf
	   EndDo                  	   
       dDataAtu  := F3_ENTRADA
	EndDo	   
    cFilAtu  := F3_FILIAL
EndDo

If Len(aNFS) > 0
   If li > 60
      LibrCab(dDataFim,aNFS[1][1],"V")
      cFilAtu  := aNFS[1][1]
   EndIf   
   nQuantFilial  := 1
   For nI := 1 To Len(aNFS)
      If lAbortPrint
         @li,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
         Exit
      EndIf
      //Se mudar de filial, imprimir os totais da loja e o cabecalho
      lNovaFilial  := cFilAtu != aNFS[nI][1]
      If li > 60 .Or. lNovaFilial
         If lNovaFilial
            nQuantFilial++
            ImprTotais() 
            //Imprimir as Notas de Credito da filial corrente       
            ImprNCC(aNCC,cFilAtu,dDataFim)
         EndIf   
         LibrCab(dDataFim,aNFS[nI][1],"V")      
      EndIf      
      @li,000 PSAY aNFS[nI][2]      //Data
      @li,011 PSAY aNFS[nI][3]      //Tipo NF - Contado/Credito
      @li,014 PSAY aNFS[nI][4]      //Numero inicial 
      @li,027 PSAY aNFS[nI][6]      //Numero final      
      @li,040 PSAY STR0063          //"MATERIAIS E IMPRESSOS"      
      @li,063 PSAY aNFS[nI][9]  Picture cPictVal      //Valor base do IVA
      @li,080 PSAY aNFS[nI][11] Picture cPictVal      //Valor isentas
      @li,099 PSAY aNFS[nI][9]  Picture cPictVal      //Total Vendas Diarias
      @li,122 PSAY 0            Picture cPictZero
      @li,134 PSAY 0            Picture cPictZero
      @li,152 PSAY 0            Picture cPictZero
      @li,160 PSAY aNFS[nI][9]  Picture cPictVal      //Valor base do IVA
      @li,177 PSAY aNFS[nI][10] Picture cPictVal      //Valor do IVA            
      //NF ou NDC Contado
      If aNFS[nI][3] == "1"
         nTotBaseCon   += aNFS[nI][9]
         nTotIseCon    += aNFS[nI][11]
         nTotVlrCon    += aNFS[nI][10]
         nGerBaseCon   += aNFS[nI][9]
         nGerIseCon    += aNFS[nI][11]
         nGerVlrCon    += aNFS[nI][10]         
      //NF ou NDC Credito         
      ElseIf aNFS[nI][3] == "2"
         nTotBaseCre   += aNFS[nI][9]
         nTotIseCre    += aNFS[nI][11]
         nTotVlrCre    += aNFS[nI][10]      
         nGerBaseCre   += aNFS[nI][9]
         nGerIseCre    += aNFS[nI][11]           
         nGerVlrCre    += aNFS[nI][10]      
      EndIf
      cFilAtu := aNFS[nI][1]
      li++
   Next nI
   //Verificar se imprime as NCCs quando retorna dados de apenas uma filial
   If nQuantFilial == 1
      ImprTotais() 
      //Imprimir as Notas de Credito da filial corrente       
      ImprNCC(aNCC,cFilAtu,dDataFim)   
   Else
      ImprTotais()
   EndIf   
EndIf

If Len(aNFS) > 0 .Or. Len(aNCC) > 0
   ImprGeral()
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza la ejecucion del informe...                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si imprime en disco, llama al gerente de impresion...               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea(cAliasSF3)
If !lQuery 
	dbClearFilter()
	RetIndex("SF3")
	Ferase(cIndexSF3+OrdBagExt())
Else
	dbCloseArea()
	dbSelectArea("SF3")
EndIf

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria as perguntas caso nao existam                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o mes para a impressao" )
Aadd( aHelpPor, "dos dados                     " )
Aadd( aHelpEng, "Informe o mes para a impressao" )
Aadd( aHelpEng, "dos dados                     " )
Aadd( aHelpSpa, "Indique el mes para la impresion" ) 
Aadd( aHelpSpa, "de los datos                  " )

PutSx1(cPerg,"01","Mes                ?","Mes                ?","Month              ?","mv_ch1","C",2,0,0,"G","NaoVazio() .And. LibGVldMes(MV_PAR01)","","","","mv_par01","","","","01","","","","","","","","","","","","")


aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o ano para a impressao" )
Aadd( aHelpPor, "dos dados                     " )
Aadd( aHelpEng, "Informe o ano para a impressao" )
Aadd( aHelpEng, "dos dados                     " )
Aadd( aHelpSpa, "Indique el ano para la impresion" ) 
Aadd( aHelpSpa, "de los datos                  " )

PutSx1(cPerg,"02","Ano                ?","Ano                ?","Year               ?","mv_ch2","C",4,0,0,"G","NaoVazio() .And. LibGVldAno(MV_PAR02)","","","","mv_par02","","","","2004","","","","","","","","","","","","")


aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a filial inicial   " )
Aadd( aHelpEng, "Enter the initial branch   " )
Aadd( aHelpSpa, "Indique la sucursal inicial" )

PutSx1(cPerg,"03","Filial de          ?","Sucursal De        ?","From Branch        ?","mv_ch3","C",2,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")


aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a filial final    " )
Aadd( aHelpEng, "Enter the final branch    " )
Aadd( aHelpSpa, "Indique la sucursal final " )

PutSx1(cPerg,"04","Filial Ate         ?","Sucursal Hasta     ?","To Branch          ?","mv_ch4","C",2,0,0,"G","","","","","mv_par04","","","","ZZ","","","","","","","","","","","","")

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibGVldMesºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o mes informado como parametro eh valido.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LibGVldMes(cMes)

Local lRet := .T.

lRet := Val(cMes) > 0 .And. Val(cMes) < 13

Return( lRet )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibGVldAnoºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o ano informado como parametro eh valido.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LibGVldAno(cAno)

Local lRet := .T.

lRet := Val(cAno) > 1900 .And. Val(cAno) <= Year(dDataBase)

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibrCab   ºAutor  ³Fernando Machima    º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Livro de Vendas - Loc. Guatemala              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibrCab(dDataFim,cFilialAtu,cTipoOper)

Local cTitulo   := ""
Local Cabec1    := ""
Local Cabec2    := ""
Local Titulo    := ""
Local nMes
Local nRecnoSM0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas no cabecalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aMeses == NIL
    aMeses  := {}
	AADD(aMeses,OemToAnsi(STR0048)) //"JANEIRO "
	AADD(aMeses,OemToAnsi(STR0049)) //"FEVEREIRO "
	AADD(aMeses,OemToAnsi(STR0050)) //"MARCO "
	AADD(aMeses,OemToAnsi(STR0051)) //"ABRIL "
	AADD(aMeses,OemToAnsi(STR0052)) //"MAIO "
	AADD(aMeses,OemToAnsi(STR0053)) //"JUNHO "
	AADD(aMeses,OemToAnsi(STR0054)) //"JULHO "
	AADD(aMeses,OemToAnsi(STR0055)) //"AGOSTO "
	AADD(aMeses,OemToAnsi(STR0056)) //"SETEMBRO "
	AADD(aMeses,OemToAnsi(STR0057)) //"OUTUBRO "
	AADD(aMeses,OemToAnsi(STR0058)) //"NOVEMBRO "
	AADD(aMeses,OemToAnsi(STR0059)) //"DEZEMBRO "                            
EndIf

cTitulo     := STR0064    //"L I V R O   D E   V E N D A S   E   S E R V I C O S   P R E S T A D O S   D O   M E S   D E "                             

nMes := Month(dDataFim)

Titulo   := cTitulo+aMeses[nMes]+STR0065+StrZero(Year(dDataFim),4)  //"DE "
Cabec1   := STR0005    //"                    DOCUMENTO                                      VDA. LOCAL       VDA. LOCAL       TOTAL VENDAS    VENDAS     DESCONTOS        VDAS. LIQS.       VDAS. LIQS.       S/VENDAS "
Cabec2   := STR0006    //" DATA    COND    DO No.      AO No.     DESC. DE MERCADORIAS        GRAVADAS          ISENTAS            DIARIAS   EXPORTACAO    S/VENDAS           ISENTAS          GRAVADAS        GRAVADAS "

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho para o Relatorio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                       1         2         3         4         5         6         7         8         9        100       110       120       130       140       150       160       170       180       190
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ li,000 PSAY STR0066  //"1 = VENDAS A VISTA"
li++
@ li,000 PSAY STR0067  //"2 = VENDAS A CREDITO"
li++
@ li,000 PSAY Replicate("-",220)
li++

SM0->(dbSetOrder(1))
nRecnoSM0 := SM0->(Recno())
If SM0->(DbSeek(Substr(cNumEmp,1,2)+cFilialAtu))
   @ li,000 PSAY STR0069+AllTrim(SM0->M0_NOMECOM) + STR0070+TRANSFORM(SM0->M0_CGC,PesqPict("SA1","A1_CGC"))  //"LOJA: "###"     NIT: "            
   li  := li + 2
EndIf   

SM0->(DbGoto(nRecnoSM0))

If cTipoOper == "D"
   @ li,000 PSAY STR0071  //"***NOTAS DE CREDITO***"
   li  := li + 2
EndIf   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprTotaisºAutor  ³Fernando Machima    º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos totais para NF ou NDC                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprTotais()

Local cPictTot   := "99,999,999,999.99"
Local cPictZero  := "9.99"

li++
@li,007 PSAY STR0072  //"TOTAL LOJA........                              A VISTA"                  
@li,062 PSAY nTotBaseCon Picture cPictTot                  
@li,079 PSAY nTotIseCon  Picture cPictTot                              
@li,098 PSAY nTotBaseCon Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nTotBaseCon Picture cPictTot                  
@li,175 PSAY nTotVlrCon  Picture cPictTot                              
li++
@li,007 PSAY STR0073  //"TOTAL LOJA........                              CREDITO"                  
@li,062 PSAY nTotBaseCre Picture cPictTot               
@li,079 PSAY nTotIseCre  Picture cPictTot                                          
@li,098 PSAY nTotBaseCre Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nTotBaseCre Picture cPictTot                  
@li,175 PSAY nTotVlrCre  Picture cPictTot                                             

nTotBaseCon   := 0
nTotIseCon    := 0
nTotVlrCon    := 0
nTotBaseCre   := 0
nTotIseCre    := 0
nTotVlrCre    := 0            

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprNCCTotºAutor  ³Fernando Machima    º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos totais para NCC                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprNCCTotais()

Local cPictTot   := "99,999,999,999.99"
Local cPictZero  := "9.99"

li++
@li,007 PSAY STR0077  //"TOTAL LOJA........                              A VISTA"                  
@li,062 PSAY nTotNCBsCon Picture cPictTot                  
@li,079 PSAY nTotNCIsCon Picture cPictTot                              
@li,098 PSAY nTotNCBsCon Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nTotNCBsCon Picture cPictTot                  
@li,175 PSAY nTotNCVlCon Picture cPictTot                              
li++
@li,007 PSAY STR0078  //"TOTAL LOJA........                              CREDITO"                  
@li,062 PSAY nTotNCBsCre Picture cPictTot               
@li,079 PSAY nTotNCIsCre Picture cPictTot                                          
@li,098 PSAY nTotNCBsCre Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nTotNCBsCre Picture cPictTot                  
@li,175 PSAY nTotNCVlCre Picture cPictTot                                             

nTotNCBsCon    := 0
nTotNCIsCon    := 0
nTotNCVlCon    := 0
nTotNCBsCre    := 0
nTotNCIsCre    := 0
nTotNCVlCre    := 0            

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprGeral ºAutor  ³Fernando Machima    º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos totais gerais de todas as lojas              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprGeral()

Local cPictTot   := "99,999,999,999.99"
Local cPictZero  := "9.99"
Local nGerBase   := nGerBaseCon + nGerBaseCre 
Local nGerIse    := nGerIseCon  + nGerIseCre  
Local nGerVlr    := nGerVlrCon  + nGerVlrCre  

li := li + 3
@li,007 PSAY STR0074   //"TOTAL COMPANHIA....                             A VISTA"                  
@li,062 PSAY nGerBaseCon Picture cPictTot                  
@li,079 PSAY nGerIseCon  Picture cPictTot                              
@li,098 PSAY nGerBaseCon Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nGerBaseCon Picture cPictTot                  
@li,175 PSAY nGerVlrCon  Picture cPictTot                              
li++
@li,007 PSAY STR0075   //"TOTAL COMPANHIA....                             CREDITO"                  
@li,062 PSAY nGerBaseCre Picture cPictTot               
@li,079 PSAY nGerIseCre  Picture cPictTot                                          
@li,098 PSAY nGerBaseCre Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nGerBaseCre Picture cPictTot                  
@li,175 PSAY nGerVlrCre  Picture cPictTot                                             
li := li + 2
@li,000 PSAY STR0076   //"TOTAL COMPANHIA...."                  
@li,062 PSAY nGerBase Picture cPictTot                  
@li,079 PSAY nGerIse  Picture cPictTot                              
@li,098 PSAY nGerBase Picture cPictTot                  
@li,122 PSAY 0 Picture cPictZero                  
@li,134 PSAY 0 Picture cPictZero                  
@li,152 PSAY 0 Picture cPictZero                  
@li,159 PSAY nGerBase Picture cPictTot                  
@li,175 PSAY nGerVlr  Picture cPictTot                              

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprNCC   ºAutor  ³Fernando Machima    º Data ³  07/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao das NCC da loja corrente                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGUA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprNCC(aNCC,cFilialAtu,dDataFim)

Local nPosFilial  := 0     
Local nI
Local lNovaFilial := .F.
Local cPictVal    := "9,999,999,999.99"
Local cPictZero   := "9.99"

If Len(aNCC) > 0
   nPosFilial  := aScan(aNCC,{|x| x[01] == cFilialAtu})
   //Verifica se tem registros de NCC para a filial corrente
   If nPosFilial > 0
      If li < 60                                          
         li  := li + 3
         @ li,000 PSAY STR0071  //"***NOTAS DE CREDITO***"
         li  := li + 2
      EndIf
      
      For nI := nPosFilial To Len(aNCC)
         If lAbortPrint
            @li,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
            Exit
         EndIf
         //Se mudar de filial, imprimir o cabecalho
         lNovaFilial  := cFilialAtu != aNCC[nI][1]
         If li > 60 .Or. lNovaFilial
            If lNovaFilial
               Exit
            EndIf
            LibrCab(dDataFim,aNCC[nI][1],"D")      
         EndIf      
         @li,000 PSAY aNCC[nI][2]      //Data
         @li,011 PSAY aNCC[nI][3]      //Tipo NCC - Contado/Credito
         @li,014 PSAY aNCC[nI][4]      //Numero inicial 
         @li,027 PSAY aNCC[nI][6]      //Numero final      
         @li,040 PSAY STR0063          //"MATERIAIS E IMPRESSOS"      
         @li,063 PSAY aNCC[nI][9]  Picture cPictVal      //Valor base do IVA
         @li,080 PSAY aNCC[nI][11] Picture cPictVal      //Valor isentas
         @li,099 PSAY aNCC[nI][9]  Picture cPictVal      //Total Vendas Diarias
         @li,122 PSAY 0            Picture cPictZero
         @li,134 PSAY 0            Picture cPictZero
         @li,152 PSAY 0            Picture cPictZero
         @li,160 PSAY aNCC[nI][9]  Picture cPictVal      //Valor base do IVA
         @li,177 PSAY aNCC[nI][10] Picture cPictVal      //Valor do IVA            
         //NCC Contado
         If aNCC[nI][3] == "1"
            nTotNCBsCon   += aNCC[nI][9]
            nTotNCIsCon   += aNCC[nI][11]
            nTotNCVlCon   += aNCC[nI][10]
            nGerNCBsCon   += aNCC[nI][9]
            nGerNCIsCon   += aNCC[nI][11]
            nGerNCVlCon   += aNCC[nI][10]         
            nGerBaseCon   -= aNCC[nI][9]
            nGerVlrCon    -= aNCC[nI][10]                  
            nGerIseCon    -= aNCC[nI][11]         
         //NCC Credito         
         ElseIf aNCC[nI][3] == "2"
            nTotNCBsCre    += aNCC[nI][9]
            nTotNCIsCre    += aNCC[nI][11]
            nTotNCVlCre    += aNCC[nI][10]      
            nGerNCBsCre    += aNCC[nI][9]
            nGerNCIsCre    += aNCC[nI][11]
            nGerNCVlCre    += aNCC[nI][10]               
            nGerBaseCre    -= aNCC[nI][9]         
            nGerVlrCre     -= aNCC[nI][10]               
            nGerIseCre     -= aNCC[nI][11]                    
         EndIf      
         li++
      Next nI
      ImprNCCTotais()
   EndIf   
EndIf
