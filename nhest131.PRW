/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST131  ºAutor  ³Alexandre R. Bento  º Data ³  31/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Controle de Visitantes                        º±±
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

User Function Nhest131()

SetPrvt("nEtq")

cString   := "SO5"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o  ")
cDesc2    := OemToAnsi("Controle de Visitantes      ")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST131"
aLinha    := { }
nLastKey  := 0
titulo    := "CONTROLE DE VISITANTES"
Cabec1    := " Nome                              Empresa                            Visitado               Setor            Chegada Entrada Permanen.  Obs."
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST131"
_cPerg    := "EST131" 

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
   cQuery += " AND O5_EMISSAO = '" + Dtos(mv_par01) + "'"      
   cQuery += " AND D_E_L_E_T_ = ' ' "  
   cQuery += " ORDER BY O5_HORACHE ASC" 
    
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","O5_EMISSAO","D")  // Muda a data de string para date      
Return                                   


Static Function RptDetail()    
Local nHrEnt := 0
Local nHrChe := 0
Local nHrPer := 0       


DBSELECTAREA("TMP")

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
Titulo += "    Da Data : "+Dtoc(mv_par01) 
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

//@ Prow() + 1, 000 Psay ' Transportadora: '+ TMP->A4_COD+" - "+ TMP->A4_NOME
While TMP->(!Eof())

  
   If Prow() > 60
      _nPag := _nPag + 1                 
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif      
   
   
//   @ Prow() + 1, 002 Psay Dtoc(TMP->O5_EMISSAO)
   @ Prow() + 1 ,001 Psay Subs(TMP->O5_DESCRI,1,20)  //Nome
   @ Prow()    , 035 Psay TMP->O5_EMPRESA //empresa
   @ Prow()    , 068 Psay TMP->O5_VISITAD //visitado
   @ Prow()    , 092 Psay TMP->O5_DESTINO  //destino  
   @ ProW()    , 112 Psay Subs(TMP->O5_HORACHE,1,5)
   @ ProW()    , 119 Psay Subs(TMP->O5_HORAENT,1,5)   
   nHrChe := HoraToInt(Subs(TMP->O5_HORACHE,1,5))
   nHrEnt := HoraToInt(Subs(TMP->O5_HORAENT,1,5))   
   @ ProW()    , 128 Psay IntToHora(nHrEnt-nHrChe)  picture "99:99"

   @ ProW()    , 138 Psay Alltrim(TMP->O5_OBS) //qtde de notas
	TMP->(DbSkip())  
 
Enddo

     
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST131"
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
                           

