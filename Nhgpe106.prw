/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE106  ºAutor  ³Marcos R. Roquitski º Data ³  27/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Evolucao Salarial                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"
User Function NHGPE106()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,_NVLRANT,_NVLRATU,_LFUNCAO,_NSALATU")
SetPrvt("_LSALARIO,_CTIPOALT,_PRIVEZ,_npercent")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "M"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Funcionarios com Evolucao Salarial"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SR7"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE020"
wnrel    := "NHGPE020"   
cPerg    := "NHGP20"
wnRel    := SetPrint("SR7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

Pergunte('NHGP20',.F.)


If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

cabec1 := "CCUSTO  MATR   NOME                          ADMISSAO ALTERACAO MOTIVO                   VALOR       %   FUNCAO"
cabec2 := ""
cabec3 := "" 

RptStatus({|| Process()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG005)})  //-- Chamada do Relatorio.

Return


Static Function Process()
Local _cMatr := Space(06), lRet := .T., _nLin := 0

DbSelectArea("SRA")
DbSetOrder(01)

DbSelectArea("SR3")
DbSetOrder(01)

DbSelectArea("SR7")
DbSetOrder(01)

m_pag    := 1
_nVlrAnt := _nVlrAtu := 0.00

DbSelectArea("SRA")
SRA->(DbGotop())
SRA->(SetRegua(RecCount()))
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
While SRA->(!Eof())
   
   IncRegua()   
   
   If SRA->RA_SITFOLH=="D" .or. SRA->RA_SITFOLH=="T"
      SRA->(Dbskip ())
      Loop
   Endif
   If SRA->RA_CC < MV_PAR05 .or. SRA->RA_CC > MV_PAR06
      SRA->(Dbskip ())
      Loop
   Endif
   If SRA->RA_MAT < MV_PAR03 .or. SRA->RA_MAT > MV_PAR04
      SRA->(Dbskip ())
      Loop
   Endif                            
   _PRIVEZ := 0                            
   _nvlrant := 0.00
   SR7->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))

   While SR7->(!Eof()) .AND. SR7->R7_FILIAL==SRA->RA_FILIAL .AND. SR7->R7_MAT==SRA->RA_MAT 

      If SR7->R7_FILIAL==SRA->RA_FILIAL .AND. SR7->R7_MAT==SRA->RA_MAT 
           _lFuncao:=.T.
      Endif

      SR3->(DbSeek(SR7->R7_FILIAL+SR7->R7_MAT+dTos(SR7->R7_DATA),.T.))
      If SR3->R3_FILIAL==SR7->R7_FILIAL .AND. SR3->R3_MAT==SR7->R7_MAT .AND. dTos(SR3->R3_DATA)==dTos(SR7->R7_DATA)
         If SR3->R3_FILIAL==SR7->R7_FILIAL .AND. SR3->R3_MAT==SR7->R7_MAT .AND. dTos(SR3->R3_DATA)<>dTos(SR7->R7_DATA)
               _lSalario:=.T.
         Endif
      Endif

      If _lSalario==.T. .OR. _lFuncao==.T.

	     If SR7->R7_TIPO $ "004/005"

	         If pRow() > 60
	            Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
    	     Endif
         
	         If lRet
	            _PRIVEZ := 0
	            @ pRow()+1,01  pSay Substr(SRA->RA_CC,1,6)
	            @ pRow()  ,08  pSay SRA->RA_MAT
	            @ pRow()  ,15  pSay Substr(SRA->RA_NOME,1,28)
	            @ pRow()  ,45  pSay SubStr(DTOS(SRA->RA_ADMISSA),5,2) + "/" + SubStr(DTOS(SRA->RA_ADMISSA),1,4)
	            If _privez ==0
	               _nvlrant := SR3->R3_VALOR
	            Endif
			    lRet := .F.
			    _nLin := 0
	         Endif

			 /*
	         SR7->(DbSkip())
	         If SR7->(Eof())
         
	         	SR7->(DbSkip(-1))
         	
	         Else
	            Loop
         
	         Endif          	
             */
             
	         _PRIVEZ := 1
	         @ pRow()+_nLin,54  pSay SubStr(DTOS(SR7->R7_DATA),5,2) + "/" + SubStr(DTOS(SR7->R7_DATA),1,4)
	         _cTipoAlt:=SubStr(Tabela("41",SR7->R7_TIPO),1,20)
	         @ pRow()  ,64  pSay _cTipoAlt
	         @ pRow()  ,85  pSay SR3->R3_VALOR Picture "99,999.99"

	         If _privez <> 0
	            _NPERCENT := (SR3->R3_VALOR / _NVLRANT * 100) - 100
	            @ pRow()  ,95  pSay _NPERCENT Picture "999.99" + "%"
	            _nvlrant := SR3->R3_VALOR
	         Endif
	         @ pRow()  ,105 pSay SR7->R7_DESCFUN
	 	     _nLin := 1
	         _cMatr := SR7->R7_MAT


  	   	     If SR7->R7_MAT <> _cMatr
	            @ pRow()+1,01  pSay ""
	            lRet := .T.
             Endif
          
         Endif
         SR7->(DbSkip())

   	     If SR7->R7_MAT <> _cMatr
            //@ pRow()+1,01  pSay ""
            lRet := .T.
         Endif




      Else
         SR7->(DbSkip())
      Endif   

   Enddo
   SRA->(DbSkip())

Enddo
@ Prow()+02,001 Psay __PrtThinLine() 
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
/*
Static procedure pGera()

SELECT RA.RA_MAT,R3.R3_VALOR,R7.R7_DATA,R7.R7_TIPO FROM SRANH0 RA, SR7NH0 R7, SR3NH0 R3
WHERE RA.RA_SITFOLH <> 'D' 
AND RA.RA_MAT = R7.R7_MAT 
AND R7.R7_MAT = R3.R3_MAT 
AND R7.R7_DATA = R3.R3_DATA
AND R7.D_E_L_E_T_ = ''
AND R3.D_E_L_E_T_ = ''
AND R7.R7_TIPO IN('004','005')
ORDER BY 1

Return
  */

Static Function Gerando()
Local cQuery

cQuery := "SELECT * " 
cQuery += "FROM " + RetSqlName( 'ZRC' ) + " ZRC " 
cQuery += "WHERE ZRC.D_E_L_E_T_ <> '*' " 
cQuery += "AND ZRC.ZRC_MAT BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "ORDER BY 2,4"

TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRC_DATA","D") // Muda a data de string para date.

DbSelectArea("TMP")
Return


