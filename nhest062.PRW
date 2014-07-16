/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEST062  บAutor  ณAlexandre R. Bento  บ Data ณ  21/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de horario de coletas das transportadoras        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB usinagem / fundi็ใo                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบAltera็ใo ณ                                                            บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 

ADICIONADO IMPRESSAO DE TOTAL DE HORAS:

Felipe Ciconini Valcanaia
<----28/09/2010---->
Linhas:
146~150
176~179
187~189

*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest062()

SetPrvt("nEtq")

cString   := "SZM"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
cDesc2    := OemToAnsi("Horarios de Coletas das Transportadoras")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST062"
aLinha    := { }
nLastKey  := 0
titulo    := "RELATำRIO DE COLETA"
Cabec1    := "TRANSPORTADORA: "
cabec2    := "DATA         Hr. CHEGADA     Hr. SAIDA   Hr. JANELA    PERMANENCIA  OBSERVACAO"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST062"
_cPerg    := "EST062" 

AjustaSx1()                                                               

Pergunte(_cPerg,.F.)
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

//if aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE   DESCRIวรO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()       
Local cQuery

   cQuery :="SELECT * "
   cQuery += " FROM " + RetSqlName( 'SZM' ) +" SZM, " + RetSqlName( 'SA4' ) +" SA4"        
   cQuery += " WHERE SZM.ZM_FILIAL = '" + xFilial("SZM")+ "'"
   cQuery += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"
   cQuery += " AND SZM.ZM_TRANSP BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND SZM.ZM_DATAENT BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"      
   cQuery += " AND SZM.ZM_TRANSP = SA4.A4_COD"  
   cQuery += " AND SZM.D_E_L_E_T_ = ' ' "  
   cQuery += " AND SA4.D_E_L_E_T_ = ' ' "  
   cQuery += " ORDER BY SZM.ZM_TRANSP,SZM.ZM_DATAENT,SZM.ZM_HORAENT ASC" 
    
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","ZM_DATAENT","D")  // Muda a data de string para date      
Return                                   


Static Function RptDetail()    
Local nHrEnt := 0
Local nHrSai := 0       
Local nResto := 0
Local _cTransp
Private nHrTot := 0
Private nHrTmp := 0
Private nHrPer := 0


DBSELECTAREA("TMP")

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec1 += TMP->A4_COD+" - "+ TMP->A4_NOME
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
_cTransp := TMP->A4_COD
//@ Prow() + 1, 000 Psay ' Transportadora: '+ TMP->A4_COD+" - "+ TMP->A4_NOME
While TMP->(!Eof())

  
   If Prow() > 59
      _nPag := _nPag + 1
      Cabec1 := "TRANSPORTADORA:"+ TMP->A4_COD+" - "+ TMP->A4_NOME
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif
   
   If _cTransp <> TMP->A4_COD
      _cTransp := TMP->A4_COD
      _nPag := _nPag + 1
      @Prow()+1,043 PSAY "Total:"
      nHrTmp += nHrTot
	  @Prow()  ,058 PSAY Stuff(StrZero(nHrTmp,5,2),AT(".",StrZero(nHrTmp,5,2)),1,":")
      nHrTot := 0
      nHrTmp := 0
      Cabec1 := "TRANSPORTADORA:"+ TMP->A4_COD+" - "+ TMP->A4_NOME
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif
   
   @ Prow() + 1, 000 Psay Dtoc(TMP->ZM_DATAENT)
   @ Prow()    , 015 Psay TMP->ZM_HORAENT
   @ ProW()    , 029 Psay Subs(TMP->ZM_HORAPOR,1,5)
   @ Prow()    , 043 Psay TMP->ZM_HRJANEL
   nHrEnt := Val (Stuff(TMP->ZM_HORAENT,AT(":",TMP->ZM_HORAENT),1,".") ) //Troca : por ,
   nHrSai := Val (Stuff(Subs(TMP->ZM_HORAPOR,1,5),AT(":",Subs(TMP->ZM_HORAPOR,1,5)),1,".")) //Troca : por ,
   If nHrEnt > nHrSai //verifica se o caminhao saiu no dia seguinte
      nHrPer := SubHoras(24,nHrEnt)
      nHrPer += nHrSai
      If (nHrPer - int(nHrPer)) > 0.59
         nResto := (nHrPer - int(nHrPer))
         nHrPer += 1.00 // Soma 1 hora
         nHrPer := int(nHrPer) + (nresto - 0.60)
         
      Endif
   Else
      
      nHrPer := SubHoras(nHrSai,nHrEnt)
   Endif
   fCalcHora(nHrPer)
   //nHrTot += nHrPer		//Acumula total por transportadora
   
   @ Prow()    , 058 Psay Stuff(StrZero(nHrPer,5,2),AT(".",StrZero(nHrPer,5,2)),1,":")
   @ Prow()    , 068 Psay Subs(TMP->ZM_OBSEXP,1,64)
	SubHoras(nHrEnt,nHrSai)
	TMP->(DbSkip())
 
Enddo

@Prow()+1,043 PSAY "Total:"
nHrTmp += nHrTot

If Val(Str(nHrTmp,6,2)) > 5
	@Prow()  ,057 PSAY Stuff(Str(nHrTmp,6,2),AT(".",Str(nHrTmp,6,2)),1,":")         //IMPRIME UMA COLUNA ANTES PARA FICAR ALINHADO
Else
	@Prow()  ,058 PSAY Stuff(Str(nHrTmp,6,2),AT(".",Str(nHrTmp,6,2)),1,":")			//IMPRIME UMA COLUNA DEPOIS PARA FICAR ALINHADO
EndIf


     
Return(nil)

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "EST062"+Space(04)
aRegs   := {}

aadd(aRegs,{cPerg,"01","Da Transportadora?","Da Transportadora?","Da Transportadora?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","At้ Transportador?","At้ Transportador?","At้ Transportador?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Da Data          ?","Da Data          ?","Da Data          ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","At้ Data         ?","At้ Data         ?","At้ Data         ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
      MsUnLock('SX1')
      SX1->(DbSkip())
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

//{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
//{{{{{{{|FUNCAO DE SOMAR AS HORAS|}}}}}}}
//}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


Static Function fCalcHora(nHrPerm)
Local _nC := 0
Local _nTmp
	
	_nC := 0
	_nTmp := nHrPerm
	While _nTmp >= 1.00
		nHrTmp += 1.00
		_nC += 1
		--_nTmp
	EndDo
	
	nHrTot += (nHrPerm - _nC)
	
	If nHrTot >= 0.6
		nHrTmp += 1.00
		nHrTot -= 0.6
	EndIf    

Return

