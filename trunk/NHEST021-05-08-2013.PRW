/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST021  ³ Autor ³ Alexandre R. Bento     Data ³ 28/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Ordem de Liberação                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expedição/ PCP / Controladoria / Portaria                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"                                                                                                
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

User Function nhest021()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Ordem de Liberação de Materiais")
aRotina := {{ "Pesquisa"      ,"AxPesqui"      , 0 , 1},;
            { "Visualizar"    ,'U_NHEST039(2)' , 0 , 2},;
            { "Incluir"       ,'U_fOrdem()'    , 0 , 3},;
            { "Excluir"       ,'U_NHEST039(5)' , 0 , 4},;       
            { "Imprimir"      ,'U_NHEST039(6)' , 0 , 5},;
            { "Frete/Entrega" ,'U_NHEST039(9)' , 0 , 5},;
            { "Rot. Entrega"  ,"U_EST021ROT()" , 0 , 5},;
            { "Emails"        ,"U_EST21MAIL()" , 0 , 5},;
            { "Legenda"       ,"U_FLegOrd1"    , 0 , 2}}     

mBrowse( 6, 1,22,75,"SZM",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fOrdem()

SetPrvt("_cDoc,_cCli,_dData,_cHora,_cTransp,_cMot,_cRG,_cPCam,_cPCar,_x,_cPed,oDialog,_cHoraen,_dDataen,_cObs")
SetPrvt("_cSerial,_cDesc,_cProd,_dData,_cHora,_cOper,_cNomeOp,_cHrJan,_cHrJanF")
SetPrvt("nMax,aHeader,aCols,oMultiline,cQuery,cQuery1,oDialog,nI,_cOrdCar")  
SetPrvt("_aPri,_cPri,_cArqDbf,_aFields,aCampos,cMarca,cARQ,i,nqtde,netiq,aNota,_cObsexp")
SetPrvt("_cTPCarg,_aTPCarg,_cFrete,_nValPed,_nValICM,_nValFre,_dDtEntr,_cHrEntr,_cLacre,cQuery2,_cArqNtx,_nOrder,_cTraTel")
SetPrvt("_lMail,_aMail,cAssunto,lMailFor")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  

lMailFor := .F.
_lMail   := .F.
_aMail   := {}
 nMax    := 1        
 _cDoc   := Space(06)
_cCli    := Space(37)
_dData   := date()
_cHora   := time()   
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)
_cHoraen := Space(05)
_dDataen := Space(08)
_cObs    := Space(100)                                               
_cObsexp := Space(100)                                               
_cLacre  := Space(50)                                               
_cHrJan  := Space(05)
_cHrJanF := Space(05)
_aPri    := {"1","2" ,"3","4","5","6","7","8","9","10","11","12"}
aNota    := {}
_cPri    := "1"
_aTPCarg := {"Total","Parcial","Especial",OemToAnsi("Baudiação")}
_cTPCarg := "1"
_cArqNtx := Space(08)
_cArqDBF := Space(12) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("EST021",.T.)
   Processa({|| Gerando() }, OemToAnsi("Ordem de Liberação"))
Else
   Return
EndIf

If File( _cArqDBF )   
  	fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif   

If File(_cArqNtx+OrdBagExt())
   Ferase(_cArqNtx+OrdBagExt())
Endif   

If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

If Select("XETQ") > 0
	XETQ->(dbCloseArea())
Endif

Return

Static Function Gerando()
Local cQuery

	cQuery := "SELECT SD2.D2_DOC,SD2.D2_COD,SD2.D2_EMISSAO,SD2.D2_SERIE,SD2.D2_QUANT,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.R_E_C_N_O_,SD2.D2_TOTAL,"
	cQuery += " SC5.C5_VOLUME1,SC5.C5_TRANSP, SC5.C5_PEDCOM,SC6.C6_DESCRI, SA4.A4_NOME, SA4.A4_TEL,SD2.D2_NFORI,SD2.D2_SERIORI,"
	cQuery += " 'CLIENTE' ="
	cQuery += " CASE"
	cQuery += "   WHEN SF2.F2_TIPO = 'B' THEN"
	cQuery += "        (SELECT SA2.A2_NOME FROM " +  RetSqlName( 'SA2' ) +" SA2 "
	cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE"
	cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "
	cQuery += "   ELSE"
	cQuery += "        (SELECT SA1.A1_NOME FROM " +  RetSqlName( 'SA1' ) +" SA1 "
	cQuery += "         WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE"
	cQuery += "         AND SA1.A1_LOJA = SF2.F2_LOJA)"
	cQuery += " END"
	cQuery += " FROM " +  RetSqlName( 'SD2' ) +" SD2, " +  RetSqlName( 'SC5' ) +" SC5, "+ RetSqlName( 'SC6' ) +" SC6, "+ RetSqlName( 'SB1' ) +" SB1, "
	cQuery += RetSqlName( 'SA4' ) +" SA4, "  + RetSqlName( 'SF2' ) +" SF2""
	cQuery += " WHERE SF2.F2_DOC =  SD2.D2_DOC "
	cQuery += " AND SF2.F2_SERIE =  SD2.D2_SERIE "
	cQuery += " AND SF2.F2_CLIENTE =  SD2.D2_CLIENTE "
	cQuery += " AND SF2.F2_LOJA =  SD2.D2_LOJA "
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2")+ "'"
	cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2")+ "'"
	cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5")+ "'"
	cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6")+ "'"
	cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
	cQuery += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"
	cQuery += " AND SD2.D2_DOC BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
	cQuery += " AND SC6.C6_NOTA = SD2.D2_DOC AND SC6.C6_SERIE = SD2.D2_SERIE"
	cQuery += " AND SC5.C5_CLIENTE = SC6.C6_CLI AND SC5.C5_LOJACLI = SC6.C6_LOJA"
	cQuery += " AND SD2.D2_CLIENTE = SC6.C6_CLI AND SD2.D2_LOJA = SC6.C6_LOJA"
	cQuery += " AND SD2.D2_ORDLIB = ' '" //traz somente notas que não foram geradas a ordem de liberação
	cQuery += " AND SD2.D2_ITEMPV = SC6.C6_ITEM"
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM"
	cQuery += " AND SB1.B1_COD = SD2.D2_COD"
	cQuery += " AND SB1.B1_COD = SC6.C6_PRODUTO"
	cQuery += " AND SA4.A4_COD = SC5.C5_TRANSP"
	cQuery += " AND SD2.D2_TES NOT IN ('694')"
	cQuery += " AND SF2. D_E_L_E_T_ = ' ' AND SA4. D_E_L_E_T_ = ' '"
	cQuery += " AND SD2. D_E_L_E_T_ = ' ' AND SC5. D_E_L_E_T_ = ' '"
	cQuery += " AND SC6. D_E_L_E_T_ = ' ' AND SB1. D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY SD2.D2_DOC,SD2.D2_CLIENTE,SD2.D2_LOJA ASC"
	   
	//MemoWrit('C:\TEMP\EST021.SQL',cQuery)
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"      
	TcSetField("TMP","D2_EMISSAO","D")  // Muda a data de string para date    
	DbSelectArea("TMP")

	Processa( {|| fRptDet() }, "Aguarde Pesquisando...")

Return

Static Function fRptDet()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF := "T_"+CriaTrab(NIL,.f.)
_aFields := {}
                                                   
AADD(_aFields,{"OK"       ,"C",02,0})        // Controle do browse
AADD(_aFields,{"NOTA"     ,"C",13,0})        // Numero da Nota + Serie
AADD(_aFields,{"NOMCLI"   ,"C",20,0})        // Cliente + Loja + Nome
AADD(_aFields,{"CLIENTE"  ,"C",40,0})        // Cliente + Loja + Nome
AADD(_aFields,{"NFDATA"   ,"C",10,0})        // Emissao
AADD(_aFields,{"EMISSAO"  ,"C",08,0})        // Emissao
AADD(_aFields,{"PRODUTO"  ,"C",45,0})        // Cod. + Nome do Produto
AADD(_aFields,{"TRANSP"   ,"C",36,0})        // Cod. + Nome da transportadora
AADD(_aFields,{"NFORI"    ,"C",10,0})        // Nota de retorno + serie de retorno
AADD(_aFields,{"PED"      ,"C",41,0})        // Pedido de retorno simples
AADD(_aFields,{"QUANT"    ,"C",12,0})        // Quantidade do Produto
AADD(_aFields,{"VOLUME"   ,"C",02,0})        // Volume das notas
AADD(_aFields,{"SD2RECNO" ,"C",10,0})        // Recno do registro SD2
AADD(_aFields,{"TOTAL"    ,"N",14,2})        // Total por Item da NF

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"XETQ",.F.)        

//-- MsCreate(_cArqDBF,_aFields,"DBFXETQ")
//-- Sleep(1000)
//-- dbUseArea(.T.,"DBFXETQ",_cArqDbf,"XETQ",.T.,.F.)

//INDEX ON XETQ->SD2RECNO TO (_cArqDBF)
//XETQ->(dbsetorder(1))

TMP->(DBGotop())            

ProcRegua(TMP->(RecCount()))

_cTraTel = Iif(Empty(TMP->A4_TEL),"s/n",TMP->A4_TEL) //telefone da transportadora

While !TMP->(EOF())
	_cPed := Space(41)	
	
	IncProc("Gerando Arquivo de Ordem de Liberação")
   
   	If !Empty(TMP->C5_PEDCOM) // Verifica se existe pedido de retorno
    	cQuery1 := "SELECT C6_NOTA"
        cQuery1 += " FROM " +  RetSqlName( 'SC6' ) 
        cQuery1 += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'" 
        cQuery1 += " AND C6_NUM = '" + TMP->C5_PEDCOM + "'" 
        cQuery1 += " AND D_E_L_E_T_ = ' '"
        cQuery1 += " GROUP BY C6_NOTA"  //  MemoWrit('C:\TEMP\ESTPED.SQL',cQuery1)
        
        //TCQuery Abre uma workarea com o resultado da query
        TCQUERY cQuery1 NEW ALIAS "TRB"      
        TRB->(DBGotop())            
        While !TRB->(EOF())
        	If !Empty(TRB->C6_NOTA)             
            	If Empty(_cPed)
                   _cPed := Alltrim(TRB->C6_NOTA)
                Else
                   _cPed := _cPed +"/"+Alltrim(TRB->C6_NOTA)             
                Endif 
            Endif   
            TRB->(Dbskip())
        Enddo
        
        TRB->(dbCloseArea())//fecha o arq. temporario TRB

	Endif   

	RecLock("XETQ",.T.)
		XETQ->OK       := Space(02)
		XETQ->NOTA     := TMP->D2_DOC+"-"+TMP->D2_SERIE
		XETQ->CLIENTE  := TMP->D2_CLIENTE+"-"+TMP->D2_LOJA+"-"+TMP->CLIENTE
		XETQ->NOMCLI   := Alltrim(TMP->CLIENTE)
		XETQ->NFDATA   := DTOC(TMP->D2_EMISSAO)
		XETQ->PRODUTO  := " "+Subs(TMP->D2_COD,1,15)+"-"+Subs(TMP->C6_DESCRI,1,28)
		XETQ->TRANSP   := TMP->C5_TRANSP+"-"+TMP->A4_NOME
		XETQ->PED      := Alltrim(_cPed)
		XETQ->VOLUME   := Alltrim(StrZero(TMP->C5_VOLUME1,2))
		XETQ->QUANT    := Transform(TMP->D2_QUANT,"@E 9999999.99")
		XETQ->SD2RECNO := STRZERO(TMP->R_E_C_N_O_,10)
		XETQ->TOTAL    := TMP->D2_TOTAL
	MsUnlock("XETQ")

	TMP->(DbSkip())
	
EndDo

TMP->(dbclosearea())

cMarca  := GetMark()
aCampos := {}   

Aadd(aCampos,{"OK"        ,"C", ""               				,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", Space(2)+"Nota"+Space(2) 		,"@!"})
Aadd(aCampos,{"NFDATA"    ,"C", Space(1)+"Data"+Space(1)		,"@!"})
Aadd(aCampos,{"NOMCLI"    ,"C", SPACE(11)+"Cliente"+Space(11)   ,"@!"})
Aadd(aCampos,{"PRODUTO"   ,"C", Space(11)+"Produto"+Space(11)	,"@!"})
Aadd(aCampos,{"QUANT"     ,"C", Space(1)+"Quant"+Space(1)       ,"@!"})
Aadd(aCampos,{"VOLUME"    ,"C", "Volume"         ,"@!"})
Aadd(aCampos,{"PED"       ,"C", "NF Simples"     ,"@!"})

XETQ->(DbGoTop())

aOldRot := aRotina //-- GUARDA O ARRAY
cOldCad := cCadastro //-- GUARDA A VARIAVEL

cCadastro := OemToAnsi("Selecione a Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Ordem Liberação" ,'U_fOrdLib()' , 0 , 3 },;
			 {"Marca Tudo"      ,'U_fMark()'   , 0 , 4 },;
             {"Desmarca Tudo"   ,'U_fDesmark()', 0 , 1 },;
             {"Legenda"         ,'U_fLeg()'    , 0 , 1 } }

MarkBrow("XETQ","OK" ,,aCampos,,cMarca) // Retirado 1 parametro, pois deu problema apos uma atualizacao
//MarkBrow( 'TRB', 'A1_OK',,_afields,, cMark,'u_MarkAll()',,,,'u_Mark()',{|| u_MarkAll()},,,,,,,.F.) 
aRotina := aOldRot //-- RECUPERA O ARRAY
cCadastro := cOldCad //-- RECUPERA A VARIAVEL

Return

/*******************************************************
* VERIFICA SE O NÚMERO DA ORDEM DE LIBERAÇÃO JÁ EXISTE *
*******************************************************/
Static Function fVerifSeq(_doc)
Local cQuery
	
	cQuery := "SELECT SZM.ZM_DOC FROM "+RetSqlName("SZM")+" SZM"
	cQuery += " WHERE SZM.ZM_DOC = '"+_doc+"'"
	cQuery += " AND SZM.D_E_L_E_T_ = ''"

	TCQUERY cQuery NEW ALIAS "TRA1"

	TRA1->(DbGoTop())

	If TRA1->(!EOF()) .AND. !EMPTY(TRA1->ZM_DOC)
		TRA1->(DbCloseArea())
		Return .F.
	EndIf
	
	TRA1->(DbCloseArea())
	
Return .T.

//*********************************************************** 
User Function fOrdLib()
Local lFlag := .F.
Local _cNF  := Space(06)
aHeader     := {}
aCols       := {}
_cCli       := Space(40)
 _cDoc   := Space(06)
_dData   := date()
_cHora   := time()   
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)
//_cTPCarg := Space(10)
_cFrete  := Space(06)
_nValFre := 0                      
_nValPed := 0
_nValICM := 0
_dDtEntr := Space(08)
_cHrEntr := Space(05)
_cLacre  := Space(50)
_cHrJan  := Space(05)                                                 
_cHrJanF := Space(05)                                                 
_cJanCli := Space(05)
_cModTrans := ""
_aModTrans := {"","1=Carreta","2=Truck","3=Bug","4=Outro"}
_cOrdCar   := Space(100)

DbSelectArea("SZM")
_cDoc       := GetSXENum("SZM","ZM_DOC")   // Variaveis do Cabecalho do Cadastro
DbCloseArea()

While !fVerifSeq(_cDoc)
	_cDoc := GetSXENum("SZM","ZM_DOC")
EndDo

Aadd(aHeader,{"Nota"       , "UM",  "@!"                ,13,0,".F.","","C","SZN"}) //1
Aadd(aHeader,{"Emissao"    , "ZN_EMISSAO" ,"99/99/9999" ,10,0,".F.","","C","SZN"}) //2
Aadd(aHeader,{"Produto"    , "UM"  ,Repli("!",40)       ,40,0,".F.","","C","SZN"}) //3
Aadd(aHeader,{"Quantidade" , "UM"  ,Repli("!",12)       ,12,0,".F.","","C","SZN"}) //4
Aadd(aHeader,{"Volume"     , "UM"  ,"!!"                ,02,0,".F.","","C","SZN"}) //5
Aadd(aHeader,{"NF Remessa" , "ZN_NFRET",  "@!"          ,41,0,".F.","","C","SZN"}) //6

aNota    := {}
// Carrega os campos da ordem de liberação selecionada
XETQ->(DbGoTop())   
DbSelectArea("XETQ")
While !XETQ->(eof())    

   If MARKED("OK") //Pega as notas selecionadas
      If _cCli <> XETQ->CLIENTE
         If lFlag
            MsgBox("Favor Selecionar Somente Clientes Iguais ","Atencao","STOP")    
            XETQ->(DbGoTop())
            MarkBRefresh()
            Return(.F.)     
         Endif
         lFlag    := .T.
         _cCli    := XETQ->CLIENTE
         _cTransp := XETQ->TRANSP
         
      Endif            
      
      If _cNF <> XETQ->NOTA
         _cNF := XETQ->NOTA
         Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,XETQ->VOLUME,XETQ->PED,XETQ->SD2RECNO,XETQ->TOTAL}) //Carrega o Acols               
      Else
         Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,"0",XETQ->PED,XETQ->SD2RECNO,XETQ->TOTAL}) //Carrega o Acols               
      Endif
      Aadd(aNota,{XETQ->NOTA,XETQ->SD2RECNO}) //Carrega a nota p/ verificação das mesmmas marcadas                     

   Endif
   XETQ->(DbSkip())
Enddo

// Para verificar se o usuario marcou todos os produtos da mesma nota na ordem de liberação
XETQ->(DbGoTop())   
While !XETQ->(eof())    

   If Ascan(aNota,{|X|X[1] == XETQ->NOTA}) <> 0    
      If Ascan(aNota,{|X|X[2] == XETQ->SD2RECNO}) == 0 
          Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,"0",XETQ->PED,XETQ->SD2RECNO,XETQ->TOTAL}) //Carrega o Acols               
      Endif    
   Endif                                          
   XETQ->(DbSkip())
Enddo
              
aCols := Asort(aCols,,, { |x,y| x[1] < y[1] }) // Orderna as notas no acols p/mostrar p/ usuario
nMax := Len(aCols)

If nMax == 0 //verifica se o usuario selecionou alguma nota fiscal
   MsgBox("Nao foi Selecionada Nenhuma Nota Fiscal","Atencao","STOP")    
   XETQ->(DbGoTop())
   MarkBRefresh()
   RollBackSx8() //Volta a numeração da Ordem de Liberação Qdo nenhuma NF foi marcada.
   Return(.F.)     
Endif
 
Define MsDialog oDialog Title OemToAnsi("Ordem de Liberação de Materiais") From 020,030 To 490,790 Pixel 
@ 013,007 To 115,372 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8            
@ 027,032 Say _cDoc Size 035,8 Object oDoc            
 oDoc:Setfont(oFont)
 
@ 027,070 Say "Cliente:" Size 30,8            
@ 025,090 Get _cCli  Picture "@!" When .F.  Size 170,8 Object oCli

@ 027,270 Say "Data:" Size 30,8            
@ 025,285 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 025,335 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora            

@ 040,010 Say "Transportadora:" Size 045,8
@ 038,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp             

@ 040,175 Say "Dt Entrada:" Size 030,8 object oDtEntrada  
@ 038,205 Get _dDataEn Picture "@!" When .F. Size 25,8 Object oDataEn
@ 040,240 Say "Hr Entrada:" Size 030,8 object oHrEntrada            
@ 038,270 Get _cHoraEn Picture "@!" When .F. Size 25,8 Object oHoraEn

@ 040,315 Say "Jan. Cli:" Size 030,8 object olJanCli
@ 038,340 Get _cJanCli Picture "99:99" Size 25,8 Object oJanCli

@ 053,010 Say OemToAnsi("Placa Caminhão:") Color CLR_HBLUE  Size 050,8                    
@ 051,050 Get _cPCam Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCam) Object oPCam             
oPCam:SetFocus(oPCam)
@ 053,095 Say OemToAnsi("Placa Carreta :") Size 050,8
@ 051,135 Get _cPCar Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCar) Object oPCar                                 

@ 053,175 Say "Hr.Jan. Ini:" Color CLR_HBLUE Size 025,8  object oHrja             
@ 051,205 Get _cHrJan Picture "!!:!!" Size 10,8 Valid .T. Object oHrJan             

@ 053,240 Say "Hr.Jan.Fim:" Color CLR_HBLUE Size 030,8  object oHrjafim             
@ 051,270 Get _cHrJanF Picture "!!:!!" Size 10,8 Valid fHrJan() Object oHrJanfim             

@ 053,310 Say "Prioridade:" Size 040,8 object oTPri  
  oTPri:Setfont(oFont10)                      

@ 051,355 Get _cPri Picture "@!" Size 7,8 Object oPri             

@ 065,010 Say "Motorista :" Color CLR_HBLUE  Size 050,8            
@ 063,050 Get _cMot Picture "@!" Size 100,8 Object oMot             
@ 065,153 Say "RG :" Color CLR_HBLUE  Size 010,8                    
@ 063,163 Get _cRG Picture "@!" Size 050,8 Object oRG          

@ 065,218 Say "Tipo Carga:" Size 050,8                     
@ 063,248 COMBOBOX _cTPCarg ITEMS _aTPCarg SIZE 40,10 object oTPCarg

@ 065,293 Say "Mod. Transp.:" Color CLR_HBLUE Size 050,8
@ 063,330 COMBOBOX _cModTrans ITEMS _aModTrans SIZE 40,10 object oModTrans

@ 077,010 Say OemToAnsi("Num Frete :")  Size 050,8
@ 075,050 Get _cFrete Picture "@!" Size 035,8 Object oFrete
             
@ 077,95 Say OemToAnsi("Valor Frete :") Size 050,8
@ 075,125 Get _nValFre Picture "999,999.99" Size 050,8 Object oValFre

@ 077,185 Say OemToAnsi("Valor Pedagio :") Size 050,8
@ 075,220 Get _nValPed Picture "999,999.99" Size 050,8 Object oValPed

@ 077,280 Say OemToAnsi("Valor ICMS :") Size 050,8
@ 075,320 Get _nValICM Picture "999,999.99" Size 050,8 Object oValICM

@ 089,010 Say OemToAnsi("Num Lacre :") Size 050,8
@ 087,050 Get _cLacre Picture "@!" Size 125,8 Object oLacre

@ 089,190 Say OemToAnsi("Obs Exp:") Size 050,8
@ 087,220 Get _cObsexp Picture "@!" Size 150,8 Object oObsexp

@ 101,010 Say OemToAnsi("Ordem Entrega:") Color CLR_HBLUE Size 050,8
@ 099,050 Get _cOrdCar Picture "@!" Size 320,8 Object oOrdCar

//******************************************************************************   
@ 117,006 To 212,372 Title OemToAnsi(" Informações ")  

@ 127,008 TO 210,370 MULTILINE MODIFY OBJECT oMultiline

@ 217,305 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 217,345 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center 

XETQ->(DbGoTop())
MarkBRefresh()

Return           

Static Function fHrJan()
Local lRet := .T.
   If Empty(_cHrJan) .OR. Empty(_cHrJanF)
      Msgbox("Horario de Janela  nao Foi Digitado, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )  
      lRet := .F.       
   Endif
Return(lRet)

Static Function fEnd() 

   RollBackSx8() //Volta a numeração da Ordem de Liberação
   Close(oDialog) 

Return

Static Function fMotori()
Local lRet := .T.
   If Empty(cMot)
      Msgbox("Fornecedor nao Foi Digitado, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )  
      lRet := .F.       
   Endif
Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A ORDEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvOrd()
_aMail   := {} //LIMPA O ARRAY DOS ITENS QUE VAO SER ENVIADOS POR EMAIL
cCodProd := ""

	If !Empty(_cMot) .And. !Empty(_cRG) .And. !Empty(_cHrJan) .And. !Empty(_cModTrans) .And. !Empty(_cOrdCar)

		Reclock("SZM",.T.)
	    	SZM->ZM_FILIAL  := xFilial("SZM")
		    SZM->ZM_DOC     := _cDoc
		    SZM->ZM_CLIENTE := Substr(_cCli,1,6)
		    SZM->ZM_LOJA    := Substr(_cCli,8,2)
		    SZM->ZM_TRANSP  := Substr(_cTransp,1,6)
		    SZM->ZM_PLACACM := _cPCam
	   	    SZM->ZM_PLACACR := _cPCar
		    SZM->ZM_MOTORIS := _cMot
		    SZM->ZM_RGMOTOR := _cRG
		    SZM->ZM_EXPEDI  := __cUserID 
		    SZM->ZM_HORAEXP := Time()
		    SZM->ZM_DATAEXP := Date()       
		    SZM->ZM_PRIORI  := _cPri
	        SZM->ZM_HORAENT := _cHoraen
	        SZM->ZM_DATAENT := Iif(Empty(_dDataen),Ctod("//"),_dDataen)
	        SZM->ZM_OBS     := _cObs
	        SZM->ZM_TPCARGA := _cTPCarg 
	        SZM->ZM_FRETE   := _cFrete 
	        SZM->ZM_VALFRET := _nValFre
            SZM->ZM_VALPED  := _nValPed
	        SZM->ZM_VALICM  := _nValICM   	         
	        SZM->ZM_DTENTRE := Iif(Empty(_dDtEntr ),Ctod("//"),_dDtEntr )
	        SZM->ZM_HRENTRE := _cHrEntr 
  	        SZM->ZM_LACRE   := _cLacre 	         
	        SZM->ZM_OBSEXP  := _cObsexp  	         
	        SZM->ZM_HRJANEL := _cHrJan 
	        SZM->ZM_HRJAFIM := _cHrJanF
	        SZM->ZM_MODTRAN := SUBSTR(_cModTrans,1,1)
	        SZM->ZM_ORDCARR := _cOrdCar 	         
	        SZM->ZM_JANCLI  := _cJanCli
		MsUnlock("SZM")     
		
		For _x:=1 to Len(aCols)
	  		If !Empty(Acols[_x][1])
		        Reclock("SZN",.T.)   
		        	SZN->ZN_FILIAL  := xFilial("SZN")
		            SZN->ZN_DOC     := _cDoc
		            SZN->ZN_NFISCAL := Substr(Acols[_x][1],1,9) //nota fiscal
		            SZN->ZN_SERIE   := Substr(Acols[_x][1],11,3) //serie da nota fiscal
		            SZN->ZN_COD     := Substr(Acols[_x][3],2,15) //codigo do produto
		            SZN->ZN_QUANT   := Val(Acols[_x][4])  //quantidade
		            SZN->ZN_VOLUME  := Val(Acols[_x][5])  //volume	            
		            SZN->ZN_NFRET   := Alltrim(Acols[_x][6]) //notas fiscais de retorno
		            SZN->ZN_VALFRET := Acols[_x][8] //Valor por item da NF
	          	MsUnlock("SZN")                                       

	            SD2->(DbGoto(VAL(Acols[_x][7])))//posiciona o registro SD2 para gravar o numero da ordem de liberação ref. a nota de saida
	               
				lMailFor := Iif(SD2->D2_TIPO=="B",.T.,.F.) //variavel usada para saber se a liberação é para fornecedor ou cliente

		        Reclock("SD2",.F.)
		        	SD2->D2_ORDLIB  := _cDoc //numero da ord. de liberação
	            MsUnlock("SD2")

	            XETQ->(dbgotop())
	            
	            While XETQ->(!EOF())
	            	If XETQ->SD2RECNO==Acols[_x][7]
	    			    Reclock("XETQ",.F.)   
		               		XETQ->(DbDelete())
        	        	MsUnlock("XETQ") 
        	        	
        	        	Exit
        	   		Endif
        	   		
        	   		XETQ->(dbskip())
        	    Enddo
            	    
				If SB1->(Dbseek(xFilial("SB1")+Substr(Acols[_x][3],2,15))) //B1_FILIAL+B1_COD
		   			If SB1->B1_TIPO$"PA" .Or. ; //Produto acabado, Embalagem
			   		   (SM0->M0_CODIGO=="NH" .AND. ALLTRIM(SB1->B1_COD)$"GM01.3.258.00/VW01.3.183.00/VW01.3.216.01/VW01.3.216.05") .or. ;//Produtos que também fazem parte do processo.
			   		   (SM0->M0_CODIGO=="FN" .AND. ALLTRIM(SB1->B1_COD)$"GMO24.5.0007.01") .OR. ; //pedido do heloir hitner do pcp
			   		   (SM0->M0_CODIGO=="FN" .AND. ALLTRIM(SB1->B1_COD)$"EC01.000118/EC01.000123" .AND. Substr(_cCli,1,6)$"900025" .and. Substr(_cCli,8,2)=="03") .or. ; // CHAMADO 040607 - Lupercio
			   		   (SB1->B1_TIPO$"EB/EC" .AND. lMailFor)
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ ZDF - Cadastro de e-mails do aviso de embarque                 ³
						//³ Se posicionar nesta tabela é porque existem e-mails cadastrados³
						//³ para envio de aviso de embarque para cliente ou fornecedor     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ZDF->(dbSetOrder(1)) //FILIAL + CLI + LOJA + TIPO
						If ZDF->(dbSeek(xFilial("ZDF")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
	
							cCodProd := " - "
	
							If lMailFor
								cCodProd := Substr(Acols[_x][3],2,15)
							Else
								SA7->(dbSetOrder(1)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
								If SA7->(Dbseek(xFilial("SA7")+ Substr(_cCli,1,6) + Substr(_cCli,8,2) +Substr(Acols[_x][3],2,15)))
									cCodProd := SA7->A7_CODCLI
								EndIf
							EndIf
						
				   			Aadd(_aMail,{Substr(Acols[_x][3],18,28),; // Descricao do produto
				   						 Substr(Acols[_x][1],1,9),;   // nota fiscal
				   			             Substr(Acols[_x][1],11,3),;  // serie
				   			             Acols[_x][4],;               // quantidade
				   			             Substr(Acols[_x][3],2,15),;  // código do produto whb
				   			             cCodProd})                   // código do produto cliente/fornecedor
				   			             
				        		_lMail := .T. //Verifica se gera email
						EndIf
					Endif
				Endif		
	    	Endif   
		Next _x
	 	
	 	If _lMail
	  		If Msgbox("Enviar aviso de embarque?" ,"Enviar ", "YESNO")
		    	fEMail()
			Endif
		EndIf
	   	
	   	ConfirmSX8()  
	   	Close(oDialog)
   	Else
       	Msgbox("Campos Obrigatorios Nao Foram Digitados, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )      
   	Endif

   	MarkBRefresh()   
   	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL DE AVISO DE EMBARQUE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEmail()
Local CRLF      := chr(13)+chr(10)   // PULA LINHA  
Local cMSG      := ""
Local cCliNome  := "Aviso de embarque p/ "
Local _cResp    := ""
Local _cResp1   := ""
Local lAdd      := .F.
Local cGrupo    := ""
Local cAssunto  := '***** AVISO DE EMBARQUE - '
Local aResp     := {}
Local aCli      := {}
Local cObs      := ""

	If Msgbox("Deseja digitar uma Observação para a mensagem?" ,"Enviar ", "YESNO")
		//abre uma janela para digitacao da observacao
		oDlgObs := MsDialog():New(0,0,210,400,"Observação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		
		oSay1 := TSay():New(10,10,{||"Observação"},oDlgObs,,,,,,.T.,,)
				
		oMemo1 := tMultiget():New(22,10,{|u|if(Pcount()>0,cObs:=u,cObs)},;
			oDlgObs,183,60,,,,,,.T.,,,{||.T.})
			
		oBtn1 := tButton():New(88,153,"Ok" ,oDlgObs,{||oDlgObs:End()},40,10,,,,.T.)
		
		oDlgObs:Activate(,,,.T.,{||.T.},,{||})
	EndIf
		
	aAdd(aResp,"João Gruczkowski - joaog@whbusinagem.com.br - 55 41 3341-1327") //1
	aAdd(aResp,"Lupercio de Carvalho - lupercioc@whbusinagem.com.br - 55 41 3341-1325") //2
	aAdd(aResp,"Mario Carvalho Pietrzak - mariocp@whbusinagem.com.br - 55 41 3341-1838") //4
	aAdd(aResp,"Lilian Esther Martinez Gimenez - lilianeg@whbfundicao.com.br - 55 41 3341-1838") //5
	aAdd(aResp,"Erica de Lima Pires - ericalp@whbusinagem.com.br - 55 41 3341-1323") //6
	aAdd(aResp,"Elenita de Oliveira Urbano - elenitaou@whbusinagem.com.br - 55 41 3341-1330") //7
	aAdd(aResp,"Anderson dos Santos Counto - andersonsc@whbbrasil.com.br - 55 41 3341-1215") //8

	If lMailFor
		SA2->(dbSetOrder(1))//FILIAL + COD + LOJA
		If SA2->(dbSeek(xFilial("SA2")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
			cCliNome := AllTrim(SA2->A2_NOME)
			cAssunto += AllTrim(SA2->A2_NREDUZ)
		EndIf
	Else
		SA1->(dbSetOrder(1))//FILIAL + COD + LOJA
		If SA1->(dbSeek(xFilial("SA1")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
			cCliNome := AllTrim(SA1->A1_NOME)
			cAssunto += AllTrim(SA1->A1_NREDUZ)
		EndIf

	EndIf

IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
	
	If lMailFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NH - FORNECEDORES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cResp  := aResp[6]
		_cResp1 := aResp[7]
		
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NH - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Substr(_cCli,1,6) == '900182' .And. Substr(_cCli,8,2) == '01'//Wabco 900182 e loja 01
	        _cResp   := aResp[3]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900183' .And. Substr(_cCli,8,2) == '01'//Iveco 900183 e loja 01
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900004' .And. Substr(_cCli,8,2) == '02'//GM 900004 e LOJA 02
	        _cResp   := aResp[1]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900193'.And. Substr(_cCli,8,2) == '01'//TEDRIVE 900193 e LOJA 01
	        _cResp   := aResp[1]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900141' .And. Substr(_cCli,8,2) == '03'//PSA 900141 e loja 03
	        _cResp   := aResp[2]
	        _cResp1  := aResp[1]
		ElseIf Substr(_cCli,1,6) == '900186' .AND. (Substr(_cCli,8,2) == '01' .OR. Substr(_cCli,8,2) == '02')//FIAT 900186
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900171' .AND. Substr(_cCli,8,2) == '01' //CNH 900171 
	        _cResp   := aResp[1]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900009' .AND. Substr(_cCli,8,2) == '01'//SM 900009
	        _cResp   := aResp[1]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900001' .AND. Substr(_cCli,8,2) == '03'//VW 900001
	        _cResp   := aResp[3]
	        _cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900164' .AND. (Substr(_cCli,8,2) == '01' .OR. Substr(_cCli,8,2) == '02')//JTEKT 900164
	        _cResp   := aResp[3]
	        _cResp1  := ''
		EndIf
	EndIf
	
Elseif SM0->M0_CODIGO == "FN" //empresa FUNDICAO

	If lMailFor //Liberacao de nota para fornecedor

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FN - FORNECEDORES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	
    	If Substr(_cCli,1,6) == '000284' .AND. Substr(_cCli,8,2) == '01' //ELETROLAK
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
    	ElseIf Substr(_cCli,1,6) == '000956' .AND. Substr(_cCli,8,2) == '01'//TECNOPO
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
	    ElseIf Substr(_cCli,1,6) == '003817' .AND. Substr(_cCli,8,2) == '01' //FF PINTURAS
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
		Else
			_cResp  := aResp[6]
			_cResp1 := aResp[7]
	    EndIf
		
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FN - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Substr(_cCli,1,6) == '000005'// SCANIA
	        _cResp   := aResp[3]
	        _cResp1  := ''
	    elseIf Substr(_cCli,1,6) == '000001' .And. Substr(_cCli,8,2) == '01' //WHB USINAGEM
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '900040' .And. Substr(_cCli,8,2) == '02' //BREMBO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '000065' .And. Substr(_cCli,8,2) == '01' //MBB
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '900015' .And. Substr(_cCli,8,2) == '01' //WABCO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '000007' .And. Substr(_cCli,8,2) == '01' //DAIMLERCHRYLSER 000007 e loja 01
	        _cResp   := aResp[1]
	        _cResp1  := ''
		elseIf Substr(_cCli,1,6) == '900024' // GM
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900022' // IVECO
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900003' //PSA
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900025'// FIAT
	        _cResp   := aResp[2]
	        _cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '000002' .AND. Substr(_cCli,8,2) == '01' //ROBERT BOSCH
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000003' .AND. Substr(_cCli,8,2) == '01' //MASTER
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '900014' .AND. Substr(_cCli,8,2) == '01' //BASSO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000008' .AND. Substr(_cCli,8,2) == '01' //DORMA
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000012' .AND. Substr(_cCli,8,2) == '02' //VOLKSWAGEN DO BRASIL LTDA 000012 LOJA 02
			
	        SB1->(Dbseek(xFilial("SB1")+ _aMail[1][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
		    If SB1->B1_GRUPO$"PA01" //envia email para fundicao
				_cResp   := aResp[4]
				_cResp1  := aResp[5]
			Else //envia email para usinagem
	            _cResp   := aResp[3]
	            _cResp1  := ''
			Endif
	
		ElseIf Substr(_cCli,1,6) == '900109' .AND. Substr(_cCli,8,2) == '02' //WHB PERNAMBUCO

	        SB1->(Dbseek(xFilial("SB1")+ _aMail[1][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
		    If SB1->B1_GRUPO$"PA01" //envia email para fundicao
				_cResp   := aResp[4]
				_cResp1  := aResp[5]
			ElseIF SB1->B1_GRUPO$"PA03" //envia email para forjaria
	            _cResp   := aResp[8]
	            _cResp1  := ''
			Else //envia email para usinagem
	            _cResp   := aResp[3]
	            _cResp1  := ''
			Endif
			
		ElseIf Substr(_cCli,1,6) == '000012' .AND. Substr(_cCli,8,2) == '03' //VOLKSWAGEN DO BRASIL LTDA 000012 LOJA 03
	        _cResp   := aResp[3]
	        _cResp1  := ''
	  	ElseIf Substr(_cCli,1,6) == '900048' .AND. Substr(_cCli,8,2) == '02'//SM SISTEMAS MODULARES LTDA 900048 LOJA 02
	        _cResp    := aResp[3]
	        _cResp1   := ''
	  	ElseIf Substr(_cCli,1,6) == '900048' .AND. Substr(_cCli,8,2) == '01'//SM SISTEMAS MODULARES LTDA 900048 LOJA 01
	        _cResp    := aResp[3]
	        _cResp1   := ''
		ElseIf Substr(_cCli,1,6) == '900063' .AND. Substr(_cCli,8,2) == '01'//TEDRIVE 
	        _cResp    := aResp[1]
	        _cResp1   := ''
		EndIf
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA QUAIS OS ENDERECOS DE EMAIL IRAO RECEBER O AVISO DE EMBARQUE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    cTo := ""

	For x:=1 to Len(_aMail)
		SB1->(Dbseek(xFilial("SB1")+ _aMail[x][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
		If AllTrim(SB1->B1_GRUPO)$"PA01/PA02/PA03"
			cGrupo := Alltrim(SB1->B1_GRUPO)
			exit
		EndIf
	Next
		
	cGrupo := Iif(cGrupo$"PA02/PA03","PA02","PA01")
	 
	//encontra os e-mails para enviar
	ZDF->(dbSetOrder(1)) //FILIAL + CLI + LOJA + TIPO
	ZDF->(dbSeek(xFilial("ZDF")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
	While ZDF->ZDF_CLI==Substr(_cCli,1,6) .AND. ZDF->ZDF_LOJA==Substr(_cCli,8,2)
		lAdd := .F.
		If SM0->M0_CODIGO=="FN"
			If ZDF->ZDF_TIPO=='1' .AND. ;
			 	(ZDF->ZDF_WHB=="1" .Or. ; //ambos
				 ZDF->ZDF_WHB=="2" .and. cGrupo=="PA01" .Or. ; //whb 2
				 ZDF->ZDF_WHB=="3" .and. cGrupo=="PA02") .Or. ; //whb 3
   			     ZDF->ZDF_TIPO=="2" .AND. lMailFor
					lAdd := .T.
			EndIf
		Else
			lAdd := .T.
		EndIf
		
		If lAdd
			cTo += AllTrim(ZDF->ZDF_EMAIL) + ";"
		EndIf
		
		ZDF->(dbSkip())
	EndDo

	cAssunto += ' - *****'
	
	cMsg := '<html><head><title>Aviso de Embarque</title></head><body>'
	cMsg += '<TABLE WIDTH="100%" style="font-family:arial" border="1">'
	cMsg += '<TR style="background:#666666;color:#eeeeee">'
	cMsg += '<TD colspan="5" align="center">'+cCliNome+'</TD>'
	cMsg += '</TR>'
	
	cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
	cMsg += '<TD width="20%" align="center">Nº. Controle</TD>'
	cMsg += '<TD width="20%" align="center">Placa do Caminhão</TD>'
	cMsg += '<TD width="20%" align="center">Data da Saída</TD>'
	cMsg += '<TD width="20%" align="center">Hora de Saída</TD>'
	cMsg += '<TD width="20%" align="center">Janela Entrega</TD>'
	cMsg += '</TR>'
	
	cMsg += '<TR style="background:#cccccc;font-size:12px">'
	cMsg += '<TD width="20%" align="center">'+_cDoc+'</TD>'
	cMsg += '<TD width="20%" align="center">'+_cPCam+'</TD>'
	cMsg += '<TD width="20%" align="center">'+DtoC(Date())+'</TD>'
	cMsg += '<TD width="20%" align="center">'+time()+'</TD>'
	cMsg += '<TD width="20%" align="center">'+_cJanCli+'</TD>'
	cMsg += '</TR>'
	
	cMsg += '<TR style="background:#cccccc;font-size:12px">'
	cMsg += '<TD width="40%" align="left" colspan="2" style="background:#aabbcc;font-weight:bold">Motorista</TD>'
	cMsg += '<TD width="60%" align="left" colspan="3">'+_cMot+'</TD>'
	cMsg += '</TR>'
	
	cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
	cMsg += '<TD width="20%" align="center">Código da Peça</TD>'
	cMsg += '<TD width="40%" align="center" colspan="2">Descrição da Peça</TD>'
	cMsg += '<TD width="20%" align="center">Quantidade Embarcada</TD>'
	cMsg += '<TD width="20%" align="center">Nota Fiscal</TD>'
	cMsg += '</TR>'
	
	For _x:=1 to Len(_aMail)
	
		cMsg += '<TR style="background:'+Iif(x%2==0,'#eeeeee','#ffffff')+';font-size:12">'
		cMsg += '<TD align="center">'+_aMail[_x][6]+'</TD>'
		
/*
		If SA7->(Dbseek(xFilial("SA7")+ Substr(_cCli,1,6) + Substr(_cCli,8,2) +_aMail[_x][5])) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
			cMsg += '<TD align="center">' + SA7->A7_CODCLI + '</TD>' //codigo do produto para o cliente
		Else
			cMsg += '<TD align="center"> - </TD>' //Nao encontrou o codigo do produto do cliente 
		EndIf	
*/	
		cMsg += '<TD align="center" colspan="2">'+ _aMail[_x][1] + '</TD>' //nome do produto
			
		cMsg += '<TD align="center">'+ _aMail[_x][4] + '</TD>'  //quantidade
		cMsg += '<TD align="center">'+ _aMail[_x][2] + '-' + _aMail[_x][3] + '</TD></TR>' //nota fiscal + serie
	
	Next
	
	cMsg += '</TABLE>'
	cMsg += CRLF	 
	
	If(!Empty(cObs))
		cMsg += '<table width="100%" style="font-family:arial" border="1">'
		cMsg += '<tr><td style="background:#aabbcc;">Obs.:</td>'
		cMsg += '<td>' + cObs + '</td></tr>'
		cMsg += '</table>'
	EndIf
	
	cMsg += CRLF	 
	cMsg += '<font size="2"> Para informações adicionais entrar em contato com:</font>' + CRLF	 
	cMsg += '<font size="2">'+ _cResp + '</font>' + CRLF	 
	cMsg += '<font size="2">'+ _cResp1 + '</font>' + CRLF	 
	
	cMsg += '</body></html>'

	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := cAssunto
	oMail:cTo      := cTo
	
	oMail:Envia()

Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function fLeg()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

               
//marca todas as notas
User Function fMark()

   XETQ->(DbGoTop())
   While !XETQ->(eof())     
      
      RecLock("XETQ")
         XETQ->OK := cMarca
      MsUnlock("XETQ")
      XETQ->(Dbskip())
   Enddo   

   MarkBRefresh()
Return

//desmarca todas as notas
User Function fDesMark()
   XETQ->(DbGoTop())
   While !XETQ->(eof())     
      
      RecLock("XETQ")
         XETQ->OK := " "
      MsUnlock("XETQ")
      XETQ->(Dbskip())
   Enddo   
   
   MarkBRefresh()
Return 

Static Function fPlaca(_cPl)

Local _nNum  := 1
Local _lFlag := .T. 
Local _cPlaca:= _cPl
_cPri        := "1"

If !Empty(_cPCam) .And. Empty(_cPCar) 
//   _cHoraen := Space(05)
//   _dDataen := Space(08)
   SO5->(DbSetOrder(4))
   SO5->(Dbseek(xFilial("SO5")+_cPlaca))
      While !SO5->(EOF()) .And. _cPlaca == SO5->O5_PLACA
          //ARRUMAR HORA CHEGADA
         If Empty(SO5->O5_HORASAI)
            _cMot      := SO5->O5_DESCRI
            _cRG       := SO5->O5_CHASSI
            _cPCam     := SO5->O5_PLACA
            _cPCar     := SO5->O5_PLACACA  
            _cHoraen   := SO5->O5_HORAENT // Hora de Entrada do veiculo na empresa
            _dDataen   := SO5->O5_EMISSAO // Data de Entrada do veiculo na empresa
            _cModTrans := SO5->O5_MODTRAN // modalidade de transporte
            
            oHoraEn:Refresh()
            oDataen:Refresh()
            oMot:Refresh()
            oRG:Refresh()         
            oPCam:Refresh()         
            oPCar:Refresh()               
            oModTrans:Refresh()
            
            oHrJan:SetFocus(oHrJan)  
            fPriori() //verifica a prioridade se já existe acrescenta um
            exit //se achou força a saida do loop
         Endif   
         SO5->(Dbskip())
      Enddo   
Endif

If !Empty(_cPCar)
   If Len(Alltrim(_cPlaca)) <> 8
      Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao","ALERT" )  
      Return(.F.)       
      
   Endif

   For _nNum:= 1 to 3
      
      _lFlag := Entre("A","Z",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Letras","ALERT" )  
         Return(.F.)       
      Endif      
   Next

   For _nNum:=5 to 8
      
      _lFlag := Entre("0","9",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Numeros","ALERT" )  
         Return(.F.)       
      Endif      
   Next 
Endif

If Empty(_cPCam) 
   Msgbox("A Placa do Caminhao Nao Foi Digitada , Verifique !!!" ,"Atencao Placa","ALERT" )  
   Return(.F.)       
Endif      

Return

User Function FLegOrd1()       

Local aLegenda :=	{ {"BR_VERDE"    , "Conferente"  },;
                      {"BR_AMARELO"  , "Portaria"    },;                      
  					  {"BR_VERMELHO" , "Fechada"     }}

BrwLegenda(OemToAnsi("Ordem de Liberação de Materiais"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"     , "Conferente"  },;
                      {"BR_AMARELO"   , "Portaria"    },;                      
  					  {"BR_VERMELHO"  , "Fechada"     }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE <> " " .And. ZM_PORTARI = " "' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE <> " " .And. ZM_PORTARI <> " "' , aLegenda[3][1] } )
Return(uRetorno)

Static Function fPriori()

   	cQuery2 := "SELECT MAX(ZM_PRIORI) AS PRIORI"
   	cQuery2 += " FROM " +  RetSqlName( 'SZM' ) 
   	cQuery2 += " WHERE ZM_FILIAL = '" + xFilial("SZM")+ "'" 
   	cQuery2 += " AND ZM_PLACACM = '" + _cPCam + "'" 
   	cQuery2 += " AND ZM_PORTARI = ' '"    
   	cQuery2 += " AND D_E_L_E_T_ = ' '"
   	//MemoWrit('C:\TEMP\ESTPED.SQL',cQuery1)
   	//TCQuery Abre uma workarea com o resultado da query
   	TCQUERY cQuery2 NEW ALIAS "PRI"  
  // DbSelectArea("PRI")    
   	PRI->(DBGotop())            
   	If !Empty(PRI->PRIORI) // Verifica se existe alguma ordem de liberação de materiais
      	_cPri := StrZero(Val(PRI->PRIORI)+1,1)         
   	Else
      	_cPri := "1"
   	Endif   
   	ObjectMethod(oPri, "Refresh()")
   	DbSelectArea("PRI")
   	DbCloseArea()//fecha o arq. temporario PRI

Return                                     
                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME O ROTEIRO DE ENTREGA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST021ROT()
Local   lSai    := .F.
Private cPlaca
Private cData   := Space(10)
Private aPlacas := {}
Private aRecSZM := {}
Private nRecSZM := ""
Private cObs    := Space(100)

    oDlg  := MsDialog():New(0,0,122,370,"Parâmetros",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    oSay1 := tSay():New(10,10,{||"Data"},oDlg,,,,,,.T.,,)
   	oGet1 := tGet():New(08,30,{|u| if(Pcount()>0,cData := u, cData)},oDlg,;
   		 35,8,"99/99/9999",{||fTrazPlc(cData)},,,,,,.T.,,,{||.T.},,,,,,,"cData")

    oSay2 := tSay():New(22,10,{||"Placa"},oDlg,,,,,,.T.,,)
	//combobox

	oCombo := TComboBox():New(20,30,{|u| if(Pcount() > 0,cPlaca := u,cPlaca)},;
		aPlacas,90,20,oDlg,,{||},,,,.T.,,,,{||.T.},,,,,"cPlaca")

    oSay2 := tSay():New(34,10,{||"Obs."},oDlg,,,,,,.T.,,)
   	oGet2 := tGet():New(32,30,{|u| if(Pcount()>0,cObs := u, cObs)},oDlg,;
   		 150,8,"@!",{||.T.},,,,,,.T.,,,{||.T.},,,,,,,"cObs")

	oBtn3 := tButton():New(46,95,"Ok",oDlg,{||nRecSZM := aRecSZM[oCombo:nAt],oDlg:End()},40,10,,,,.T.)
	oBtn4 := tButton():New(46,140,"Cancelar",oDlg,{||lSai := .T., oDlg:End()},40,10,,,,.T.)

	oDlg:Activate(,,,.T.,{||.T.},,{||})

	If lSai
		Return
	EndIf
	
	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SO5"
    oRelato:cPerg    := "ROT021"
	oRelato:cNomePrg := "NHEST021"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este   relatório   apresenta  o  roteiro"
	oRelato:cDesc2   := "de entrega."

	//titulo
	oRelato:cTitulo  := "ROTEIRO DE ENTREGA"

	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
aModTrans := {"Carreta","Truck","Bug","Outro"}
	
	SZM->(DbGoTo(nRecSZM))
	
	oRelato:Cabec()
	
	@Prow()+1 , 001 psay "Ord. Liberação: "+SZM->ZM_DOC
	@Prow()+1 , 001 psay "Placa: "+SZM->ZM_PLACACM
	@Prow()   , 050 psay "Motorista: "+ALLTRIM(SZM->ZM_MOTORIS)
	@Prow()   , 100 psay "RG: "+SZM->ZM_RGMOTOR
	@Prow()+1 , 001 psay "Modalidade: "+aModTrans[Val(SZM->ZM_MODTRAN)]
	@Prow()   , 050 psay "Hora Exped.: "+ALLTRIM(SZM->ZM_HORAEXP)
	@Prow()   , 100 psay "Jan. Entrega: "+SZM->ZM_JANCLI
	@Prow()+1 , 000 psay __PrtThinLine()

    cQuery := " SELECT ZM.ZM_CLIENTE, ZM.ZM_LOJA, ZN.ZN_COD, B1.B1_DESC, F2.F2_TIPO,"
    cQuery += " ZN.ZN_VOLUME, ZN.ZN_QUANT, ZN.ZN_NFISCAL, ZN.ZN_SERIE, ZM.ZM_PRIORI"
	cQuery += " FROM "+RetSqlName("SZN")+" ZN, "+RetSqlName("SZM")+" ZM, "
	cQuery += RetSqlName("SB1")+" B1, "+RetSqlName("SF2")+" F2"
    cQuery += " WHERE ZM.ZM_DOC = ZN.ZN_DOC"
    cQuery += " AND F2.F2_DOC = ZN.ZN_NFISCAL"
    cQuery += " AND F2.F2_SERIE = ZN.ZN_SERIE"

    If mv_par01==1 //Abertas
    	cQuery += " AND ZM.ZM_PORTARI = ''"
    ElseIf mv_par01==2 //Fechadas
    	cQuery += " AND ZM.ZM_PORTARI != ''"
    EndIf
    
    cQuery += " AND B1.B1_COD = ZN.ZN_COD"
    cQuery += " AND ZM.ZM_PLACACM = '"+SZM->ZM_PLACACM+"'"
    cQuery += " AND ZM.ZM_DATAEXP = '"+DtoS(SZM->ZM_DATAEXP)+"'"
    cQuery += " AND ZN.ZN_FILIAL = '"+xFilial("SZN")+"' AND ZN.D_E_L_E_T_ = ''"
    cQuery += " AND ZM.ZM_FILIAL = '"+xFilial("SZM")+"' AND ZM.D_E_L_E_T_ = ''"
    cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''"
    cQuery += " ORDER BY ZM.ZM_PRIORI "

	TCQUERY cQuery NEW ALIAS "TRC"
	
	TRC->(DbGoTop())  

	While TRC->(!EOF())
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		@Prow()+1, 001 psay TRC->ZM_PRIORI+" ª ENTREGA"
		@Prow()+1, 001 psay "CLIENTE/LOJA      DESCRIÇÃO"
	
    	If TRC->F2_TIPO=="B"
    		SA2->(DbSetOrder(1)) // FILIAL + COD + LOJA
    		SA2->(DbSeek(xFilial("SA2")+TRC->ZM_CLIENTE+TRC->ZM_LOJA))

			@Prow()+1, 001 psay TRC->ZM_CLIENTE+" - "+TRC->ZM_LOJA+"     "+SA2->A2_NOME
			@Prow()+1, 001 psay "Endereço: "+Alltrim(SA2->A2_END)+Space(5)+"Bairro: "+Alltrim(SA2->A2_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA2->A2_MUN)+Space(5)+"Estado: "+Alltrim(SA2->A2_EST)
			@Prow()+1, 001 psay "Telefone: "+SA2->A2_TEL
		Else
			SA1->(DbSetOrder(1)) //FILIAL + COD + LOJA
			SA1->(DbSeek(xFilial("SA1")+TRC->ZM_CLIENTE+TRC->ZM_LOJA))
	
			@Prow()+1, 001 psay TRC->ZM_CLIENTE+" - "+TRC->ZM_LOJA+"     "+SA1->A1_NOME
			@Prow()+1, 001 psay "Endereço: "+Alltrim(SA1->A1_END)+Space(5)+"Bairro: "+Alltrim(SA1->A1_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA1->A1_MUN)+Space(5)+"Estado: "+Alltrim(SA1->A1_EST)
			@Prow()+1, 001 psay "Telefone: "+SA1->A1_TEL
		EndIf	
		
		@Prow()+2, 001 psay "CÓDIGO          DESCRIÇÃO                                               VOLUME           QUANT          NF"

		@Prow()+1, 001 psay ""
		
		cCli  := TRC->ZM_CLIENTE
		cLoja := TRC->ZM_LOJA
		
		nTotVol := 0
		
		While TRC->ZM_CLIENTE==cCli .AND. TRC->ZM_LOJA==cLoja
						
			@Prow()+1, 001 psay TRC->ZN_COD
			@Prow()  , 017 psay SUBSTR(TRC->B1_DESC,1,50)
			@Prow()  , 070 psay TRC->ZN_VOLUME Picture "@e 9,999.99"
			@Prow()  , 085 psay TRC->ZN_QUANT  Picture "@e 999,999.99"
			@Prow()  , 100 psay TRC->ZN_NFISCAL+" - "+TRC->ZN_SERIE
			
			SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			SD2->(DbSeek(xFilial("SD2")+TRC->ZN_NFISCAL+TRC->ZN_SERIE+cCli+cLoja+TRC->ZN_COD))
			
			If SD2->(Found()) .AND. SD2->D2_TES$"503/542" //se for sacaria ou embalagem
				nTotVol += TRC->ZN_VOLUME
			EndIf
			
			TRC->(DbSkip())
		EndDo
		@Prow()+1, 001 psay "Total: "
		@Prow()  , 068 psay nTotVol Picture "@e 999,999.99"
	     
		@Prow() +1,000 psay __PrtThinLine()
	
	ENDDO

	@Prow()+1, 001 psay "Obs.: "+cObs	    
	
	@Prow()+3, 010 psay "__________________________________"
	@Prow()  , 080 psay "__________________________________"
	@Prow()+1, 020 psay UPPER(cUserName)
	@Prow()  , 090 psay "RESP. TRANSPORTE"
	
	@Prow()+3, 000 psay "OBS.: OBRIGATÓRIO QUE SEJA PREENCHIDO NO CONHECIMENTO DE FRETE RG, NOME LEGÍVEL E/OU CARIMBO COM NOME DO RESPONSÁVEL"
	@Prow()+1, 000 psay "      PELO RECEBIMENTO DA MERCADORIA."

	TRC->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ AS PLACAS DO DIA PASSADO COMO PARAMETRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTrazPlc(cData)
Local cQuery  := ""

	If Empty(cData)
		Return .T.
	EndIf
	
	cQuery := " SELECT ZM_PLACACM, R_E_C_N_O_ AS ZM_RECNO "
	cQuery += " FROM "+RetSqlName("SZM")+" ZM"
	cQuery += " WHERE ZM_DATAEXP = '"+DtoS(CtoD(cData))+"'"
	cQuery += " AND D_E_L_E_T_ = ''"
	cQuery += " AND ZM_FILIAL = '"+xFilial("SZM")+"'"
		
	TCQUERY cQuery NEW ALIAS "TRB"
	      
	TRB->(DbGoTop())
	
	aPlacas := {}
	
	While TRB->(!EOF())
	    aAdd(aPlacas,TRB->ZM_PLACACM+" - "+ALLTRIM(Str(TRB->ZM_RECNO)))
	    aAdd(aRecSZM,TRB->ZM_RECNO)
		TRB->(Dbskip())
	ENDDO              
	
	oCombo:Refresh()        
	oCombo:aItems := {}
	oCombo:aItems := aPlacas
	
	TRB->(DbCloseArea())

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST21MAIL ºAutor  ³João Felipe da Rosa º Data ³  16/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de e-mails do aviso de embarque                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS - PCP                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EST21MAIL()

aRotOld := aClone(aRotina)

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Email da Ordem de Liberação")
aRotina := {{ "Pesquisa"      ,"AxPesqui"      , 0 , 1},;
            { "Visualizar"    ,'U_E21M(2)'     , 0 , 2},;
            { "Incluir"       ,'U_E21M(3)'     , 0 , 3},;
            { "Alterar"       ,'U_E21M(4)'     , 0 , 4},;
            { "Excluir"       ,'U_E21M(5)'     , 0 , 5}}

mBrowse( 6, 1,22,75,"ZDF",,,,,,)

aRotina := aClone(aRotOld)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function E21M(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  
Private aSize     := MsAdvSize()

Private cCliFor   := Space(6)
Private cLoja     := Space(2)
Private cDesc     := ""
Private cEmail    := Space(40)
Private cTipo     := ""
Private aTipo     := {"1=Cliente","2=Fornecedor"}
Private cWHB      := ""
Private aWHB      := {"1=Ambos","2=WHBII","3=WHBIII"}
 
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk := {|| fInclui()}
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	EndIf

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Email Ordem de Liberação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Cli. / Fornec."},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cCliFor := u,cCliFor)},oDlg,40,8,"@!",{||fVCliFor(.T.)},;
		,,,,,.T.,,,{||nPar==3},,,,,,"SA1","cCliFor")

	oSay2 := TSay():New(20,160,{||"Loja"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(18,200,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,20,8,"@!",{||fVCliFor(.F.)},;
		,,,,,.T.,,,{||nPar==3},,,,,,,"cLoja")
		
	oSay3 := TSay():New(31,10,{||"Nome"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(29,50,{|u| if(Pcount() > 0, cDesc := u,cDesc)},oDlg,180,8,"@!",,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesc")

	oSay4 := TSay():New(42,10,{||"Email"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(40,50,{|u| if(Pcount() > 0, cEmail := u,cEmail)},oDlg,180,8,"@!",{||fValEmail()},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cEmail")

	oSay5 := TSay():New(53,10,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(51,50,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
		aTipo,40,10,oDlg,,{||fAltF3()},,,,.T.,,,,{||nPar==3},,,,,"cTipo")

	If SM0->M0_CODIGO=="FN"
		oSay6 := TSay():New(64,10,{||"WHB"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oCombo2 := TComboBox():New(62,50,{|u| if(Pcount() > 0,cWHB := u,cWHB)},;
		aWHB,40,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cWHB")
	EndIf
	
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fValEmail()
	
	if !isEmail(ALLTRIM(cEmail))
		Alert('Informe o e-mail corretamente!')
		return .f.
	Endif

Return .t.

static function fAltF3()
	oGet1:cF3 := Iif(Substr(cTipo,1,1)=="1","SA1","SA2")
	cCliFor   := Space(6)
	cLoja     := Space(2)
	cDesc     := ""
	oGet1:Refresh()
	oGet2:Refresh()
	oGet3:Refresh()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CLIENTE OU O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fVCliFor(lCli)
	
	If lCli
		cLoja := Space(2)
		oGet2:Refresh()
	EndIf
		
	If oGet1:cF3=="SA1"
		SA1->(dbSetOrder(1)) //FILIAL + COD + LOJA
		If !SA1->(dbSeek(xFilial("SA1")+AllTrim(cCliFor)+AllTrim(cLoja)))
			Alert("Cliente/Fornecedor não encontrado!")
			Return .F.
		Else
			If !lCli
				cDesc := SA1->A1_NOME
			EndIf
		EndIf
	Else
		SA2->(dbSetOrder(1)) //FILIAL + COD + LOJA
		If !SA2->(dbSeek(xFilial("SA2")+AllTrim(cCliFor)+AllTrim(cLoja)))
			Alert("Cliente/Fornecedor não encontrado!")
			Return .F.
		Else
			If !lCli
				cDesc := SA2->A2_NOME
			EndIf
		EndIf
	EndIf

	oGet3:Refresh()
	
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()

	If Empty(cCliFor) .or. Empty(cLoja)
		Alert("Cliente / Fornecedor ou Loja não informados!")
		Return .F.
	EndIf
	
	If Empty(cEmail)
		Alert("Informe o e-mail!")
		Return .F.
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()
	
	If !fValida()
		Return
	EndIf     
	
	RecLock("ZDF",.T.)
		ZDF->ZDF_FILIAL := xFilial("ZDF")
		ZDF->ZDF_CLI    := cCliFor
		ZDF->ZDF_LOJA   := cLoja
		ZDF->ZDF_EMAIL  := cEmail
		ZDF->ZDF_TIPO   := Substr(cTipo,1,1)
		If SM0->M0_CODIGO=="FN"
			ZDF->ZDF_WHB := substr(cWHB,1,1)
		EndIf
	MsUnLock("ZDF")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	RecLock("ZDF",.F.)
		ZDF->ZDF_EMAIL  := cEmail
		If SM0->M0_CODIGO=="FN"
			ZDF->ZDF_WHB := substr(cWHB,1,1)
		EndIf
	MsUnLock("ZDF")

	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
		RecLock("ZDF",.F.)
			ZDF->(dbDelete())
		MsUnlock("ZDF")
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
	
	cCliFor := ZDF->ZDF_CLI
	cLoja   := ZDF->ZDF_LOJA
	cEmail  := ZDF->ZDF_EMAIL
	cTipo   := ZDF->ZDF_TIPO
	
	If ZDF->ZDF_TIPO=="1"
		cDesc := Posicione("SA1",1,xFilial("SA1")+cCliFor+cLoja,"A1_NOME")
	Else
		cDesc := Posicione("SA2",1,xFilial("SA2")+cCliFor+cLoja,"A2_NOME")
	EndIf
	
Return