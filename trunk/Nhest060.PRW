/*                                                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                    
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST060  ³ Autor ³ Alexandre R. Bento     Data ³ 07/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Acompanhamento de Fusão                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fusão                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function nhest999()

//-------------------------------------------------------
//  CRIACAO DE VARIAVEIS
//-------------------------------------------------------
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cARQEXP ,cARQ,nPbruto,_auxdoc,_auxforno")   
SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,nI,_cForno,_cLiga,lMsErroAuto,_TOTLIN")
SetPrvt("_aGusa,_aAco,_aRetorno1,_aCavaco,_aGrafite_aCoq,_aFeSi,_aFeMn,_aCobre,_aLiga,_aPirita")
SetPrvt("_aFeCr,_aInoc,_aEstanho,_aTotlin,_aRetorno2")


lMsErroAuto := .f. 
_cForno  := Space(01)
_cLiga   := Space(04)
aHeader  := {}
aCols    := {}            
_TOTLIN := 0


//-------------------------------------------------------
//  VERIFICACAO DA EMPRESA
//-------------------------------------------------------
IF SM0->M0_CODIGO <> "FN" //empresa new hubner	
   Msgbox("Esta Rotina So Pode Ser Utilizada na Fundicao!!!" ,"Atencao","ALERT" )  
   Return
Endif

Processa( {|| gera_teste() } )
Processa( {|| gera_multi() } )

//-------------------------------------------------------------------
@ 1,1 TO 600,1000 DIALOG oDlg TITLE "Acompanhamento de Fusão"
@ 5,5 TO 180,500 BROWSE "FUS"
@ 5,5 TO 180,500 BROWSE "FUS" FIELDS aCampos Object oFusao// MARK "OK" 
  
@ 190,5 To 280,500 Title OemToAnsi("  Digite os Dados ") 
@ 195,10 TO 275,495 MULTILINE MODIFY OBJECT oMultiline 
@ 285,25 BUTTON "_Grava"  SIZE 40,15 ACTION fGrvOrd()
@ 285,80 BUTTON "_Saida"  SIZE 40,15 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED                                 
DbSelectArea("TMP")
DbcloseArea()      
Return

           
//--------------------
//  GRAVACAO 
//--------------------
Static Function fGrvOrd()                        
SetPrvt("_cCod,_x,_nLiga,_cDoc,aCab,lMsErroAuto,_n,_cc,_nForno,_nHi,_nHf,_nVi,_nVf,_cNumseq")
private lMsErroAuto:=.f.
Private _aItem :={}
Private _aCab  := {}

// posicao do campo no aHeader
_nLiga  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LIGA"})
_nForno := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_FORNO"})
_nHi    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_HORAINI"})
_nHf    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_HORAFIM"})
_nVi    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_VAZINI"})
_nVf    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_VAZFIM"})

_cDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc

// ALERT(" Numero de DOC "+ _cDoc)

_cCod  := Space(15)
_cc    := "201001"
_aCab   := {{"D3_TM"    	, "502" 	,NIL},;           
           {"D3_CC"    		, "201001"    	,NIL},;
           {"D3_EMISSAO"	,dDataBase  ,Nil}}

SB1->(DbsetOrder(1))                                 
SBM->(DbSetOrder(1))			// Filial + Grupo

For _n:=1 to Len(aCols) // Total de linhas
	For _x:=7 to Len(aHeader) // total de colunas

	   If _x == 7 //Gusa
	      _cCod := "MP01.000001"
	   Elseif _x == 8 //Aço
	      _cCod := "MP01.000002"
	   Elseif _x == 9 //Retorno Verifica se foi digitado o campo liga
	      if Acols[_n][_nLiga] == "4512"
             //Acols[_n][_x] := "MP01.000004"
	         _cCod := "MP01.000004"
	      Elseif Acols[_n][_nLiga] == "5506"
             //Acols[_n][_x] := "MP01.000013"	      
	         _cCod := "MP01.000013"
	      Elseif Empty(Acols[_n][_nLiga])
	         MsgBox("O campo LIGA não foi informado","Atencao","ALERT")
	      Endif 
	   Elseif _x == 10 //Cavaco
	      _cCod := "MP01.000003"
 	   Elseif _x == 11 //Grafite
	      _cCod := "MA01.000025"
	   Elseif _x == 12 //Coq
	      _cCod := "MP01.000005"
	   Elseif _x == 13 //Ferro Si
	      _cCod := "MP01.000007"
	   Elseif _x == 14 //Ferro manganes
	      _cCod := "MP01.000008"
	   Elseif _x == 15 //Cobre
	      _cCod := "MP01.000012"
	   Elseif _x == 16 //Liga
	      _cCod := "MP01.000010"
	   Elseif _x == 17 //Pirit
	      _cCod := "MP01.000017"
	   Elseif _x == 18 //Ferro Crono
	      _cCod := "MP01.000018"
	   Elseif _x == 19 //Inoc
	      _cCod := "MP01.000011"
	   Elseif _x == 20 //Estanho
	      _cCod := "MP01.000019"
	   Endif
   
	   If (!aCols[_n][Len(aHeader)+1] )//Verifica se a linha não foi excluida  

                    
           SB1->(DbSetOrder(1)) //filial+cod	       
       	   SB1->(DbGotop())           
    	   SB1->(Dbseek(xFilial("SB1")+_cCod))    
    	  
    	   //ALERT(" COD "+_cCod+"  Produto sb1 "+ SB1->B1_COD+"-"+SB1->B1_DESC+"-"+SB1->B1_GRUPO)
    	        
	       SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO),.T.)		// Procura no SBM o grupo digitado no SD3
  
		   Do Case
		      Case substr(_cc,1,1) $ "1/2"
			     IF SM0->M0_CODIGO == "NH"  //empresa new hubner	
			        _cConta := SBM->BM_CTAADM
			     Else // Empresa Fundição
                    _cConta := SBM->BM_CTADIR			     
			     Endif   
		   EndCase                         
		   _cNumseq := ProxNum()
           
           If Acols[_n][_x] > 0 //Somente adiciona na matriz se tiver qtde maior que zero		   	       
		      aadd(_aItem,{{"D3_COD"		, _cCod              ,NIL},; 
	                       {"D3_LOCAL"		, SB1->B1_LOCPAD	 ,NIL},;
	                       {"D3_UM"	    	, SB1->B1_UM 	     ,NIL},;
   	                       {"D3_GRUPO"	   	, SB1->B1_GRUPO	     ,NIL},;
   	                       {"D3_HORAINI"   	, Acols[_n][_nHi]    ,NIL},;   
                           {"D3_HORAFIM"   	, Acols[_n][_nHf]    ,NIL},;   	                   	                   	                   	                   	                   
                           {"D3_LIGA"  	   	, Acols[_n][_nLiga]   ,NIL},;	                   	                   	                   
                           {"D3_FORNO"	   	, Acols[_n][_nForno]  ,NIL},;	                   	                   	                   	                   
                           {"D3_VAZINI"   	, Acols[_n][_nVi]     ,NIL},;	                   	                   	                   	                   	                   	                   
                           {"D3_VAZFIM"   	, Acols[_n][_nVf]     ,NIL},; 	                   
	            	       {"D3_QUANT"		, Acols[_n][_x]      ,NIL}})  
	       Endif     	       
	   Endif
	Next _x
Next _n	

//MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_aItem,3)
Processa( {||MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_aItem,3)},"Aguarde Efetuando Baixa " )
If lMsErroAuto
	Mostraerro()
	DisarmTransaction()
	break
EndIf               


DbSelectArea("FUS")
FUS->(DBCLOSEAREA())
If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif   
DbSelectArea("TMP")
TMP->(DBCLOSEAREA())
Processa( {|| gera_teste() } )  
FUS->(DBGOTOP())
Acols:={}
Processa( {|| gera_multi() } )
AADD(Acols,{' ','    ','  :  ','  :  ','  :  ','  :  ',0,0,0,0,0,0,0,0,0,0,0,0,0,0})
ObjectMethod(oMultiline ,"Refresh()")
Return                  


//----------------------------------------------------------------------------------------------------------
//  MONTA O BROWSE DA PARTE SUPERIOR.
//----------------------------------------------------------------------------------------------------------
STATIC FUNCTION GERA_TESTE()

_cArqDBF:=SPACE(12)
 _cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}


_aGusa 		:= 0
_aAco  		:= 0
_aRetorno 	:= 0
_aCavaco 	:= 0
_aGrafite	:= 0
_aCoq 		:= 0
_aFeSi 		:= 0
_aFeMn 		:= 0
_aCobre 	:= 0
_aLiga 		:= 0
_aPirita 	:= 0
_aFeCr 		:= 0
_aInoc		:= 0
_aEstanho 	:= 0
_aTotlin	:= 0

//----------------------------------------------------------------------------------------------
//  GERACAO DO ARQUIVO TEMPORARIO PARA GERACAO DO BROWSE
//----------------------------------------------------------------------------------------------
cQuery := "SELECT D3.D3_DOC,D3.D3_LIGA,D3.D3_HORAINI,D3.D3_HORAFIM,D3.D3_VAZINI,D3.D3_VAZFIM,D3.D3_FORNO,"
cQuery += "D3.D3_QUANT,D3.D3_COD,D3.D3_EMISSAO "
cQuery += "FROM "+ RetSqlName( 'SD3' ) +" D3 "
cQuery += "WHERE D3.D3_EMISSAO = " + Dtos(dDataBase)
cQuery += " AND D3.D3_FORNO <> ' ' "
cQuery += "ORDER BY D3.D3_DOC,D3.D3_LIGA,D3.D3_HORAINI,D3.D3_HORAFIM,D3.D3_VAZINI,D3.D3_VAZFIM,D3.D3_FORNO,D3.D3_COD"
TCQUERY cQuery NEW ALIAS "TMP"

AADD(_aFields,{"FORNO"     	,"C", 01,0})
AADD(_aFields,{"LIGA"      	,"C", 04,0})
AADD(_aFields,{"DOCUMENTO" 	,"C", 06,0})
AADD(_aFields,{"HORAINI"   	,"C", 05,0})
AADD(_aFields,{"HORAFIM"   	,"C", 05,0})
AADD(_aFields,{"VAZINI"    	,"C", 05,0})
AADD(_aFields,{"VAZFIM"    	,"C", 05,0})
AADD(_aFields,{"EMISSAO"   	,"D", 08,0})
Aadd(_aFields,{"GUSA"      	, "N",11,2})
Aadd(_aFields,{"ACO"        , "N",11,2})
Aadd(_aFields,{"RETORNO"    , "N",11,2})
Aadd(_aFields,{"CAVACO"     , "N",11,2})
Aadd(_aFields,{"GRAFITE"    , "N",11,2})
Aadd(_aFields,{"COQ"        , "N",11,2})
Aadd(_aFields,{"FESI"       , "N",11,2})
Aadd(_aFields,{"FEMN"       , "N",11,2})
Aadd(_aFields,{"COBRE"      , "N",11,2})
Aadd(_aFields,{"QTDELIGA"   , "N",11,2})
Aadd(_aFields,{"PIRITA"     , "N",11,2})
Aadd(_aFields,{"FECR"       , "N",11,2})
Aadd(_aFields,{"INOC"       , "N",11,2})
Aadd(_aFields,{"ESTANHO"    , "N",11,2})
Aadd(_aFields,{"TOTLINHA"   , "N",11,2})


DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"FUS",.F.)

TMP->(DBGotop())            
_auxdoc	  := TMP->D3_DOC    
_auxforno := TMP->D3_FORNO  

While !TMP->(EOF())    
  RecLock("FUS",.T.)   
  while (_auxdoc == TMP->D3_DOC)  .AND. (_auxforno == TMP->D3_FORNO)
      FUS->LIGA 		:= TMP->D3_LIGA
	  FUS->DOCUMENTO	:= TMP->D3_DOC
	  FUS->HORAINI		:= TMP->D3_HORAINI
	  FUS->HORAFIM		:= TMP->D3_HORAFIM
	  FUS->VAZINI		:= TMP->D3_VAZINI
	  FUS->VAZFIM		:= TMP->D3_VAZFIM
	  FUS->FORNO		:= TMP->D3_FORNO  
	  FUS->EMISSAO      := STOD(TMP->D3_EMISSAO)
     
	   If TMP->D3_COD      = "MP01.000001" 
	      FUS->GUSA        := TMP->D3_QUANT
	      _aGusa := _aGusa + TMP->D3_QUANT
	   Elseif TMP->D3_COD  = "MP01.000002"
   	      FUS->ACO         := TMP->D3_QUANT
  	      _aAco := _aAco + TMP->D3_QUANT
	   Elseif TMP->D3_COD  = "MP01.000004"
   		  FUS->RETORNO     := TMP->D3_QUANT
	      _aRetorno := _aRetorno + TMP->D3_QUANT
	   Elseif TMP->D3_COD  = "MP01.000013"
		  FUS->RETORNO     := TMP->D3_QUANT
	      _aRetorno := _aRetorno + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000003"
	      FUS->CAVACO      := TMP->D3_QUANT               
		  _aCavaco := _aCavaco + TMP->D3_QUANT		  	      
 	   Elseif TMP->D3_COD  = "MA01.000025"                     
 	      FUS->GRAFITE     := TMP->D3_QUANT
 	      _aGrafite := _aGrafite + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000005"
	      FUS->COQ         := TMP->D3_QUANT
	      _aCoq := _aCoq + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000007"
   	      FUS->FESI        := TMP->D3_QUANT
   	      _aFesi := _aFesi + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000008"
	      FUS->FEMN        := TMP->D3_QUANT
	      _aFeMn := _aFemn + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000012"
   	      FUS->COBRE       := TMP->D3_QUANT
   	      _aCobre := _aCobre + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000010"
	      FUS->QTDELIGA    := TMP->D3_QUANT
	      _aLiga := _aLiga + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000017"
	      FUS->PIRITA      := TMP->D3_QUANT
	      _aPirita := _aPirita + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000018"
	      FUS->FECR        := TMP->D3_QUANT
	      _aFeCr := _aFecr + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000011"
	      FUS->INOC        := TMP->D3_QUANT
	      _aInoc := _aInoc + TMP->D3_QUANT		  
	   Elseif TMP->D3_COD  = "MP01.000019"
	      FUS->ESTANHO     := TMP->D3_QUANT
	      _aEstanho := _aEstanho + TMP->D3_QUANT		  
	   ENDIF        
       _TOTLIN := _TOTLIN + TMP->D3_QUANT
       _aTotlin := _aTotlin + TMP->D3_QUANT		  
  TMP->(DbSkip())
  ENDDO
  FUS->TOTLINHA := _TOTLIN
  MsUnLock("FUS",.T.)   
  _auxdoc	  := TMP->D3_DOC    
  _auxforno   := TMP->D3_FORNO
  _TOTLIN    := 0
enddo
                           
//-------------------------------------------------------------------
//  COLOCA O TOTAL POR COLUNA 
//-------------------------------------------------------------------
RecLock("FUS",.T.)
	  FUS->DOCUMENTO	:= "TOTAL"
      FUS->GUSA     := _aGusa
      FUS->ACO      := _aAco
	  FUS->RETORNO  := _aRetorno
      FUS->CAVACO   := _aCavaco 
      FUS->GRAFITE  := _aGrafite                                                          
      FUS->COQ      := _aCoq 
      FUS->FESI     := _aFesi
      FUS->FEMN     := _aFeMn 
      FUS->COBRE    := _aCobre 
      FUS->QTDELIGA := _aLiga 
	  FUS->PIRITA   := _aPirita 
	  FUS->FECR     := _aFeCr
	  FUS->INOC     := _aInoc
      FUS->ESTANHO  := _aEstanho
	  FUS->TOTLINHA := _aTotlin

MsUnLock("FUS",.T.)   

cMarca  := GetMark()
aCampos := {}   
Aadd(aCampos,{"EMISSAO"   ,"Emissao"     , "99/99/9999"})
Aadd(aCampos,{"LIGA"      ,"Liga"        , "@!"})
Aadd(aCampos,{"DOCUMENTO" ,"Documento"   , "@!"})
Aadd(aCampos,{"FORNO"     ,"FORNO"       , "@!"})
Aadd(aCampos,{"HORAINI"   ,"Hora Inicio" , "99:99"})
Aadd(aCampos,{"HORAFIM"   ,"Hora Fim"    , "99:99"})
Aadd(aCampos,{"VAZINI"    ,"Hora Inicio" , "99:99"})
Aadd(aCampos,{"VAZFIM"    ,"Hora Inicio" , "99:99"})
Aadd(aCampos,{"GUSA"      ,"Gusa"        , "@E 99999999.99"})
Aadd(aCampos,{"ACO"       ,"Aco"         , "@E 99999999.99"})
Aadd(aCampos,{"RETORNO"   ,"Retorno"     , "@E 99999999.99"})
Aadd(aCampos,{"CAVACO"     , "Cavaco" 	, "@E 99999999.99"})
Aadd(aCampos,{"GRAFITE"    , "Grafite"	, "@E 99999999.99"})
Aadd(aCampos,{"COQ"        , "COQ" 		, "@E 99999999.99"})
Aadd(aCampos,{"FESI"       , "FeSi"		, "@E 99999999.99"})
Aadd(aCampos,{"FEMN"       , "FeMn"		, "@E 99999999.99"})
Aadd(aCampos,{"COBRE"      , "Cobre"	, "@E 99999999.99"})
Aadd(aCampos,{"QTDELIGA"   , "LIga"		, "@E 99999999.99"})
Aadd(aCampos,{"PIRITA"     , "Pirita" 	, "@E 99999999.99"})
Aadd(aCampos,{"FECR"       , "Fecr"		, "@E 99999999.99"})
Aadd(aCampos,{"INOC"       , "Inoc"		, "@E 99999999.99"})
Aadd(aCampos,{"ESTANHO"    , "Estanho"	, "@E 99999999.99"})
Aadd(aCampos,{"TOTLINHA"   , "Total"	, "@E 99999999.99"})


FUS->(DbGoTop())
            
RETURN

Static Function gera_Multi()
//-------------------------------------------------------------------
Aadd(aHeader,{"Forno"      , "D3_FORNO", "@!"            , 1,0,".T.","","C","SD3"}) //03
Aadd(aHeader,{"Liga"       , "D3_LIGA" , "@!"            , 4,0,".T.","","C","SD3"}) // "ExecBlock('fLiga',.f.,.f.)","","C","SD3"}) //03
Aadd(aHeader,{"Hr Inicio"  , "D3_HORAINI" ,"99:99"       , 5,0,".T.","","C","SD3"}) //03
Aadd(aHeader,{"Hr Fim"     , "D3_HORAFIM" ,"99:99"       , 5,0,".T.","","C","SD3"}) //03
Aadd(aHeader,{"Vaz Inicio" , "D3_VAZINI"  ,"99:99"       , 5,0,".T.","","C","SD3"}) //03
Aadd(aHeader,{"Vaz Final"  , "D3_VAZFIM"  ,"99:99"       , 5,0,".T.","","C","SD3"}) //03
Aadd(aHeader,{"Gusa"       , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","00MP01.000001    ","N","SD3"})
Aadd(aHeader,{"Aço"        , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","01MP01.000002    ","N","SD3"})
Aadd(aHeader,{"Retorno"    , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","02RETORNO        ","N","SD3"})
Aadd(aHeader,{"Cavaco"     , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","03MP01.000003    ","N","SD3"})
Aadd(aHeader,{"Grafite"    , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","04MA01.000025    ","N","SD3"})
Aadd(aHeader,{"Coq"        , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","05MP01.000005    ","N","SD3"})
Aadd(aHeader,{"Fe.Si"      , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","06MP01.000007    ","N","SD3"})
Aadd(aHeader,{"FeMn"       , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","07MP01.000008    ","N","SD3"})
Aadd(aHeader,{"Cobre"      , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","08MP01.000012    ","N","SD3"})
Aadd(aHeader,{"Qtde Liga"  , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","09MP01.000010    ","N","SD3"})
Aadd(aHeader,{"Pirita"     , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","10MP01.000017    ","N","SD3"})
Aadd(aHeader,{"FeCr"       , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","11MP01.000018    ","N","SD3"})
Aadd(aHeader,{"Inoc"       , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","12MP01.000011    ","N","SD3"})
Aadd(aHeader,{"Estanho"    , "D3_QUANT","@E 99999999.99" ,11,2,"ExecBlock('Veqtde',.F.,.F.)","13MP01.000019    ","N","SD3"})
RETURN



User Function Veqtde()

_coluna = val(substr(aHeader[7][7],0,2))+7
_codigo = Substr(aHeader[_coluna][7],3,15)

if _codigo = "RETORNO"
  if aHeader[_coluna][7] = "4512"
	  _codigo = "MP01.000004    "
	 else
	  _codigo = "MP01.000013    "
  endif
endif

DbSelectArea("SB1")
SB1->(DbSetorder(1))
SB1->(DbSeek(xFilial("SB1")+_codigo))                    
_aLocPad := B1_LOCPAD       

DbSelectArea("SB2")
SB2->(DbSetorder(1)) 
DbGoTop()
DbSeek(xFilial("SB2")+_codigo+_aLocPad,.T.) 
 if B2_QATU < D3_QUANT
   ALERT("Qtde. Insuficiente em ESTOQUE !!") 
   Return(.F.)
endif
Return(.T.)