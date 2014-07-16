/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST130  ºAutor  ³Alexandre R. Bento  º Data ³  31/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Controle de carga e descarga                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB usinagem / fundição                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteração ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest130()

SetPrvt("nEtq")

cString   := "SO5"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o  ")
cDesc2    := OemToAnsi("Controle de Carga e Descarga")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST130"
aLinha    := { }
nLastKey  := 0
titulo    := "CONTROLE DE CARGA E DESCARGA"
Cabec1    := "  Data          Nome                      Placa      Local entrega    Hora Chegada    Hora Entrada   Permanencia   Qtde Laudas"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST130"
_cPerg    := "EST130" 

//AjustaSx1()                                                               

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
//   Cabec1    := "COD PRODUTO    COD.CLIENTE   DESCRIÇÃO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
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
   cQuery += " FROM " + RetSqlName( 'SO5' ) 
   cQuery += " WHERE O5_FILIAL = '" + xFilial("SO5")+ "'"
   cQuery += " AND O5_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "'"      
   cQuery += " AND D_E_L_E_T_ = ' ' "  
   cQuery += " ORDER BY O5_EMISSAO, O5_HORACHE ASC" 
    
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","O5_EMISSAO","D")  // Muda a data de string para date      
Return                                   


Static Function RptDetail()    
Local nHrEnt := 0
Local nHrChe := 0
Local nHrPer := 0       
Local nResto := 0
Local _cTransp 

DBSELECTAREA("TMP")

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

//@ Prow() + 1, 000 Psay ' Transportadora: '+ TMP->A4_COD+" - "+ TMP->A4_NOME
While TMP->(!Eof())

  
   If Prow() > 60
      _nPag := _nPag + 1                 
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif      
   
   
   @ Prow() + 1, 001 Psay Dtoc(TMP->O5_EMISSAO)
   @ Prow()    , 010 Psay TMP->O5_DESCRI
   @ Prow()    , 042 Psay TMP->O5_PLACA
   @ Prow()    , 053 Psay TMP->O5_DESTINO
   @ ProW()    , 075 Psay Subs(TMP->O5_HORACHE,1,5)
   @ ProW()    , 090 Psay Subs(TMP->O5_HORAENT,1,5)   
   nHrChe := HoraToInt(Subs(TMP->O5_HORACHE,1,5))
   nHrEnt := HoraToInt(Subs(TMP->O5_HORAENT,1,5))   
   @ ProW()    , 105 Psay IntToHora(nHrEnt-nHrChe)  picture "99:99"

   @ ProW()    , 119 Psay TMP->O5_QTDENF Picture "999" //qtde de notas
	TMP->(DbSkip())  
 
Enddo

     
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST130"
aRegs   := {}

//aadd(aRegs,{cPerg,"01","Da Transportadora?","Da Transportadora?","Da Transportadora?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"02","Até Transportador?","Até Transportador?","Até Transportador?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"01","Da Data          ?","Da Data          ?","Da Data          ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"01","Até Data         ?","Até Data         ?","Até Data         ?","mv_ch1","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
                           

