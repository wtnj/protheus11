#include "rwmake.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHECKTOP_AP5บAutor  ณMicrosiga           บ Data ณ  07/05/01 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem o objetivo de ajustar a TOP_FIELD se       บฑฑ
ฑฑบ          ณ baseando na tabela SX3.Esta rotina gera uma tabela de      บฑฑ
ฑฑบ          ณ resultado CHECKTOP no banco de dados para conferencia.     บฑฑ
ฑฑบ          ณ Esta rotina funciona somente para banco de dados.")        บฑฑ                                                    
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function checktop()
Processa({|lEnd| U_checkproc()})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHECKTOP_AP5บAutor  ณMicrosiga           บ Data ณ  07/05/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function checkproc()
Local cBanco, CQUERY
Local cServer := Space(30)
Local cDataBase := Space(30)
Local cEmpAnt,cArqSX2
local aCamposCHK := {}
Private aCamposSX3 := {},cUsertable:="" 
Private cmsgstopa := "N"

If MsgYesNo("Avisa sobre correcao S/N",OemToAnsi('ATENCAO'))
	cmsgstopa:="S"
Endif

If !MsgYesNo("Inicia a execu็ใo S/N ? ",OemToAnsi('ATENCAO'))
	Return
Endif

dbSelectArea("SM0")
ProcRegua(SM0->(LastRec()))
dbGotop()
cEmpAnt := "@@"
While !Eof()
	IncProc()
	IF M0_CODIGO == cEmpAnt
		dbSkip()
		LOOP
	Endif
	cEmpAnt := M0_CODIGO
    cQuery := " SELECT FIELD_TABLE "
    cQuery += " FROM TOP_FIELD "
    cQuery += " WHERE FIELD_TABLE LIKE '%CHECKTOP%'  "
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '__TOP', .F., .T.)
    cUserTable := substr(alltrim(FIELD_TABLE),1,AT(".",alltrim(FIELD_TABLE)))
    dbCloseArea("__TOP")
	if empty(cUserTable)
	   TCDelfile("CHECKTOP")
	Endif
    
	// Cria arquivo CHECKTOP DE LOG DE INFORMACOES ALTERADAS NA TABELA TOP_FIELD
	If TCCanOpen("CHECKTOP")  
   	   TCSQLEXEC("TRUNCATE TABLE CHECKTOP")
    else
       AADD(aCamposCHK,{'CHK_TABLE','C',64,0})
       AADD(aCamposCHK,{'CHK_NAME' ,'C',32,0})
       AADD(aCamposCHK,{'CHK_TYPE' ,'C',2 ,0})
       AADD(aCamposCHK,{'CHK_PREC' ,'C',4 ,0})
       AADD(aCamposCHK,{'CHK_DEC'  ,'C',4 ,0})
       AADD(aCamposCHK,{'CHK_NUM'  ,'N',2 ,0})
       AADD(aCamposCHK,{'CHK_DAT'  ,'D',8 ,0})
       AADD(aCamposCHK,{'CHK_LOG'  ,'L',1 ,0})
       dbCreate("CHECKTOP",aCamposCHK,"TOPCONN")
    Endif   

	// Obtem Usuario para criar as tabelas
	cQuery := " SELECT FIELD_TABLE "
	cQuery += " FROM TOP_FIELD "
	cQuery += " WHERE FIELD_TABLE LIKE '%CHECKTOP%'  "
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '__TOP', .F., .T.)
	cUserTable := substr(alltrim(FIELD_TABLE),1,AT(".",alltrim(FIELD_TABLE)))
    dbCloseArea("__TOP")
	if empty(cUserTable)
	   msgstop('Para dar continuidade neste processo; voce precisa reiniciar o servico do TOPCONNECT,; logo apos carregue este programa novamente.')
	   Return
	Endif

    Dbselectarea("SX3")
    dbSetOrder(1)
    
	dbSelectArea("Sx2")	
    dbSetOrder(1)
    set filter to
    
	dbGotop()
	While !Eof()
		cBanco := Alltrim(Upper(TCGetDb()))
		u_CheckTabela(SX2->X2_ARQUIVO,cBanco)
		dbSelectArea("SX2")
		dbSkip()
	End
	dbSelectArea("SM0")
	dbSkip()
End
msgstop("Processo concluido. ; Reinicialize o Servico do TopConnect; As modificacoes foram registradas na tabela CHECKTOP.")
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCheckTabelaบAutor  ณMicrosiga           บ Data ณ  07/05/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CheckTabela(cArquivo,cBanco)
Local aStru,ni,cQuery, cAlias, npos, npos1,npos2,npos3, lErro, lCria, ncount 

cArquivo := Upper(Alltrim(cArquivo))
IF "."$cArquivo
	cArquivo := Subs(cArquivo,1,AT(".",cArquivo)-1)
Endif
IF !TCCanOpen(cArquivo)
	Return Nil
Endif

// Carrega Estrutura do dicionario de dados da tabela corrente
cAlias := substr(cArquivo,1,3)
aCamposSX3 := {}
DbSelectArea("SX3")
DbSeek(cAlias)

While !Eof() .And. X3_ARQUIVO == cAlias
   If X3_CONTEXT != "V" .and. X3_TIPO$"N|D|L"
	  AADD(aCamposSX3,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
   EndIf
   DbSelectArea("SX3")
   DbSkip()
EndDo

// Carrega Estrutura do dicionario de dados da tabela corrente em fun็ao da TOP_FIELD
// Este array terแ somente os campos do Tipo Data, Numerico e Logico.
         
lErro := .F. // Determina se a Estrutura esta com problemas
lCria := .T. // Nใo existe nenhum registro da tabela corrente na top_field
nCount:= 0   // Contador para checar se a quantidade de registro esta diferente
cQuery := " SELECT FIELD_TABLE, FIELD_NAME, FIELD_TYPE, FIELD_PREC, FIELD_DEC "
cQuery += " FROM TOP_FIELD "
cQuery += " WHERE FIELD_TABLE LIKE '%"+cArquivo+"%' AND FIELD_TYPE <> 'X' "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '__TOP', .F., .T.)
dbSelectArea("__TOP")

While !eof()
      lCria := .F.
      npos := AScan(acamposSX3,{|x| alltrim(x[1]) == alltrim(FIELD_NAME)} )
	  if npos = 0
	     lErro := .T.
	     exit
	  Endif
      cType := iif(alltrim(FIELD_TYPE)=='P','N',alltrim(FIELD_TYPE))
	  if !(aCamposSX3[npos][2] == cType .and. alltrim(str(aCamposSX3[npos][3])) == alltrim(FIELD_PREC) .and. ;
	       alltrim(str(aCamposSX3[npos][4])) == alltrim(FIELD_DEC) ) 
	      lErro := .T. 
      Endif   
      nCount++
      dbskip()
end
dbCloseArea("__TOP")              

if lCria   // Verifica se existe campos necessarios a serem criados na TOP_FIELD
   npos1 := AScan(acamposSX3,{|x| alltrim(x[2]) == 'N' })
   npos2 := AScan(acamposSX3,{|x| alltrim(x[2]) == 'D' })
   npos3 := AScan(acamposSX3,{|x| alltrim(x[2]) == 'L' })
   if !(npos1=0 .and. npos2=0 .and. npos3=0)
      lErro := .T.
   Endif
Endif		           
   
if lErro .or. (nCount <> len(aCamposSX3)) // Se Verdadeiro deve recriar sua estrutura na top_field
    if cmsgstopa == "S"
       msgstop("Tabela "+carquivo+" sera ajustada.Tecle enter para continuar")
    Endif

    // Elimina estrutura da tabela original 
    cQuery := " DELETE TOP_FIELD "
	cQuery += " WHERE FIELD_TABLE LIKE '%"+cArquivo+"%' "
    TCSQLEXEC(cQuery)
    IF substr(cBanco,1,6) == "ORACLE"
 	   TCSQLEXEC("COMMIT")
    Endif

    // Cria registro necessarios na TABELA TOP_FIELD
	For ni := 1 to len(aCamposSX3)
        cType := iif(aCamposSX3[ni][2]=='N','P',aCamposSX3[ni][2])

		// Atualiza TOP_FIELD
	    cQuery := " INSERT INTO TOP_FIELD (FIELD_TABLE, FIELD_NAME, FIELD_TYPE, FIELD_PREC, FIELD_DEC)  "
    	cQuery += " VALUES ('"+cUserTable+cArquivo+"','"+aCamposSX3[ni][1]+"','"+cType+"','"+alltrim(str(aCamposSX3[ni][3]))+"','"+alltrim(str(aCamposSX3[ni][4]))+"')"
    	TCSQLEXEC(cQuery)
	    IF substr(cBanco,1,6) == "ORACLE"
 		   TCSQLEXEC("COMMIT")
	    Endif

		// Atualiza tabela CHECKTOP 
		cQuery := " SELECT MAX(R_E_C_N_O_) RECNO "
  	 	cQuery += " FROM CHECKTOP "
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '__TOP', .F., .T.)
	    cQuery := " INSERT INTO CHECKTOP  (CHK_TABLE, CHK_NAME, CHK_TYPE, CHK_PREC, CHK_DEC, R_E_C_N_O_)  "
    	cQuery += " VALUES ('"+cUserTable+cArquivo+"','"+Alltrim(aCamposSX3[ni][1])+"','"+Alltrim(cType)+"','"+Alltrim(str(aCamposSX3[ni][3]))+"','"+Alltrim(str(aCamposSX3[ni][4], 0))+"',"+Alltrim(str(RECNO + 1, 0))+")"
    	dbCloseArea("__TOP")
    	TCSQLEXEC(cQuery)
	    IF substr(cBanco,1,6) == "ORACLE"
 		   TCSQLEXEC("COMMIT")
	    Endif
	next ni

	// Atualiza TOP_FIELD
    cQuery := " INSERT INTO TOP_FIELD (FIELD_TABLE, FIELD_NAME, FIELD_TYPE, FIELD_PREC, FIELD_DEC)  "
   	cQuery += " VALUES ('"+cUserTable+cArquivo+"','@@HAS_DFT_VAL@@','X','0','0') "
   	TCSQLEXEC(cQuery)
    IF substr(cBanco,1,6) == "ORACLE"
 	   TCSQLEXEC("COMMIT")
    Endif

	// Atualiza tabela CHECKTOP 
	cQuery := " SELECT MAX(R_E_C_N_O_) RECNO "
 	cQuery += " FROM CHECKTOP "
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '__TOP', .F., .T.)
   cQuery := " INSERT INTO CHECKTOP  (CHK_TABLE, CHK_NAME, CHK_TYPE, CHK_PREC, CHK_DEC, R_E_C_N_O_)  "
  	cQuery += " VALUES ('"+Alltrim(cUserTable+cArquivo)+"','@@HAS_DFT_VAL@@','X','0','0',"+str(RECNO + 1)+") "
  	dbCloseArea("__TOP")
  	TCSQLEXEC(cQuery)

    IF substr(cBanco,1,6) == "ORACLE"
 	   TCSQLEXEC("COMMIT")
    Endif
Endif

Return