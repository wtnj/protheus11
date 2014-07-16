/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NHCOM002 ³ Autor ³ Rosana Marques        ³ Data ³ 20/10/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Alterada por     ³ Marcelo J. Santos     ³ Data ³ 17/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SC7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"   

User Function nhcom222() 

SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,CPERG")
SetPrvt("ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA,LIMITE")
SetPrvt("LI,NTOTNOTA,NTOTGER,NTOTDESC,NTOTIPI,NDESCPROD")
SetPrvt("NTOTAL,CSTRING,NUMPED,NREG,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,XTRANSP,NORDEM,COBS01,COBS02,COBS03")
SetPrvt("COBS04,LIMPRIME,NVALOR,_COBSGERAL,CRO,NK")
SetPrvt("NDESCNF,CFIL,NREGISTRO,_CNOMEUSER,COBS,NX")
SetPrvt("CVAR,NTOTGERAL,CLIBERADOR,CDESC,NLINREF,CDESCRI")
SetPrvt("MV_PAR06,CUNID,NQUANT,NPRECO,WNREL,nTotFre")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho:="M"      
aOrd := { }
titulo:="EMISSAO DOS PEDIDOS DE COMPRAS"
cDesc1:="Emissao dos pedidos de compras cadastradados"
cDesc2:=" "
cDesc3:=" "
	       
cPerg  :="MTR110"
aReturn := { "Especial", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog:="NHCOM002"
nLastKey := 0
nBegin   :=0                                          
nTotFre  := 0
aLinha:={ }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel    := "NHCOM002"
limite   := 120
li       := 80
nTotNota := nTotGer  := nTotDesc := nTotIpi  := nDescProd:= nTotal   := 0
cString  := "SC7"
NumPed   := Space(6)
_COBSGERAL := "  "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("MTR110",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto            ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               N§ de Copias                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)
wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif        

SetDefault(aReturn,cString)
If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

nReg   := 0

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
Setprc(0,0)

SET DEVICE TO PRINT
SC7->(DbSetOrder(1))
SC7->(DbGotop())
SC7->(DbSeek(xFilial("SC7")+mv_par01,.t.))

// Cadastro de Compradores, trazer nome comprador
SY1->(DbSetOrder(3)) // Filial + Cod. do Usu rio

xTRANSP := Space(6)

RptStatus({|| Detalhe() })
Return

Static Function Detalhe()

SetRegua(150) 
While SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02 .And. !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nTotNota := nTotal := nTotGer := nTotDesc := nTotIpi  := nDescProd:= nTotFre := 0
	nOrdem   := 1
  cObs01   := cObs02 := cObs03  := cObs04   := " "
  lImprime := .f.
  If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
     SC7->(DbSkip())
     Loop
	Endif

  If SC7->C7_EMISSAO < mv_par03 .Or. SC7->C7_EMISSAO > mv_par04
     SC7->(DbSkip())
     Loop
	Endif

  ImpCabec()
  nReg := SC7->(Recno())

  nTotNota := nTotNota 
  While SC7->C7_FILIAL = xFilial() .And. SC7->C7_NUM == NumPed
    SC1->(DbSetOrder(1))
    SC1->(DbSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC))
    IncRegua() //Incrementa a posicao da regua de relatorios
	
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se havera salto de formulario                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If pRow() > 54 // 59 - 3 linhas do rodape
       nOrdem := nOrdem + 1
       ImpRodape()
       ImpCabec()
    Endif
    @ pRow()+1,001 pSay "|"
    @ pRow()  ,002 pSay SC7->C7_PRODUTO
    If !Empty(SC7->C7_TRANSP)
       xTRANSP := SC7->C7_TRANSP
    Endif
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

    if SB1->B1_TIPO== "02" .or. SB1->B1_TIPO=="05"
       lImprime := .t.
    endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa Descricao do Produto                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ImpProd()
    nValor := SC7->C7_TOTAL
    nTotal:=0
   
   // If !Empty(SC7->C7_DESC1)
//       nTotal:=nValor-(nValor*SC7->C7_DESC1/100)
//    Endif
//    If !Empty(SC7->C7_DESC2)
//       nTotal:=nTotal-(nTotal*SC7->C7_DESC2/100)
//    Endif
//    If !Empty(SC7->C7_DESC3)
//       nTotal:=nTotal-(nTotal*SC7->C7_DESC3/100)
//    Endif
//    If !Empty(nTotal)
//       nDescProd := nTotal
//    Else
//       nDescProd :=  nValor
//    EndIf
	
	 If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
       nDescProd:=nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	 Else
       nDescProd:=nDescProd+SC7->C7_VLDESC
	Endif
//			nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
//			nTotIpi:=nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2) 
	
    nTotIpi:=nTotIpi+Round(SC7->C7_TOTAL*SC7->C7_IPI/100,2)

    RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
      SC7->C7_EMITIDO := "S"
      SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
    MsUnLock("SC7")
    nReg := SC7->(Recno())
    
    If !Empty(SC7->C7_OBSGERA)
       _cObsGeral := SC7->C7_OBSGERA
    Endif   
    
    SC7->(DbSkip())
  End
  SC7->(DbGoto(nReg))
  If pRow() > 40
     nOrdem := nOrdem + 1
     ImpRodape()
     ImpCabec()
  Endif
  FinalPed()
  SC7->(DbSkip())
End

Set Device To Screen

cRo := SM0->M0_CODIGO

If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

return


Static Function FinalPed()
nk := 1
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay "---------------|----------------------------|--|-----------|--------------|---|------------|----------|---------|-------"
@ pRow()  ,122 pSay "|"
@ pRow()+1,000 pSay ""
While pRow() < 28
   @ pRow()  ,001 pSay "|"
   @ pRow()  ,017 pSay "|"
   @ pRow()  ,017 + nk pSay "*"
   nk := IIf( nk == 29 , 1 , nk + 1 )
   @ pRow()  ,046 pSay "|"
   @ pRow()  ,049 pSay "|"
   @ pRow()  ,061 pSay "|"
   @ pRow()  ,076 pSay "|"
   @ pRow()  ,080 pSay "|"
   @ pRow()  ,093 pSay "|"
   @ pRow()  ,104 pSay "|"
   @ pRow()  ,114 pSay "|"
   @ pRow()  ,122 pSay "|"
   @ pRow()+1,000 pSay ""
End
@ pRow()  ,001 pSay "|---------------|----------------------------|--|-----------|--------------|---|------------|----------|---------|-------|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,015 pSay "D E S C O N T O S -->"
@ pRow()  ,037 pSay SC7->C7_DESC1 Picture "@E 999.99"
@ pRow()  ,046 pSay SC7->C7_DESC2 Picture "@E 999.99"
@ pRow()  ,055 pSay SC7->C7_DESC3 Picture "@E 999.99"
nTotal:=0
nValor := nTotNota
//If !Empty(SC7->C7_DESC1)
//   nTotal:=nValor-(nValor*SC7->C7_DESC1/100)
//Endif
//If !Empty(SC7->C7_DESC2)
//   nTotal:=nTotal-(nTotal*SC7->C7_DESC2/100)
//Endif
//If !Empty(SC7->C7_DESC3)
//   nTotal:=nTotal-(nTotal*SC7->C7_DESC3/100)
//Endif
//If !Empty(nTotal)
//   nDescNF := nTotal
//Else
//   nDescNF :=  nValor/
//EndIf

//nTotDesc:=nTotNota-nDescNF
@ pRow()  ,068 pSay nDescProd Picture tm(nDescProd,14)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If !Empty(xTRANSP)
   SA4->(DbSetOrder(1))
   SA4->(DbSeek(xFilial("SA4")+xTRANSP))
   @ pRow()+1,001 pSay "|"
   @ pRow()  ,003 pSay "Transportadora    : " + SA4->A4_NREDUZ
   @ pRow()  ,057 pSay "-"
   @ pRow()  ,061 pSay SA4->A4_MUN
   @ pRow()  ,083 pSay "-"
   @ pRow()  ,085 pSay SA4->A4_EST
   @ pRow()  ,088 pSay "-"
   @ pRow()  ,090 pSay "CEP :"
   @ pRow()  ,096 pSay Alltrim(SA4->A4_CEP)
   @ pRow()  ,105 pSay "("
   @ pRow()  ,106 pSay Alltrim(SA4->A4_TEL)+")"
   @ pRow()  ,122 pSay "|"
   @ pRow()+1,001 pSay "|"
   @ pRow()  ,002 pSay Replicate("-",limite)
   @ pRow()  ,122 pSay "|"
Endif

cFil := iif(empty(SC7->C7_FILENT),"01",SC7->C7_FILENT)
SM0->(DbSetOrder(1))
nRegistro := SM0->(Recno())
SM0->(DbSeek(SUBS(cNumEmp,1,2)+cFil))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Entrega  : " + SM0->M0_ENDENT
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDENT
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTENT
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPENT)
@ pRow()  ,122 pSay "|"
SM0->(DbGoto(nRegistro))

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + SM0->M0_ENDCOB
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDCOB
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTCOB
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPCOB)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"


SE4->(DbSeek(xFilial()+SC7->C7_COND))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CONDICAO DE PAGTO : "+SubStr(SE4->E4_COND,1,42)
@ pRow()  ,066 pSay "|DATA DE EMISSAO|"
@ pRow()  ,084 pSay "TOTAL DAS MERCADORIAS : "
@ pRow()  ,108 pSay nTotNota Picture "@E 99,999,999.99"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(SE4->E4_DESCRI,1,34)
@ pRow()  ,066 pSay "|"
@ pRow()  ,071 pSay SC7->C7_EMISSAO
@ pRow()  ,082 pSay "|"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",52)
@ pRow()  ,054 pSay "|"
@ pRow()  ,055 pSay Replicate("-",67)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"

//Imprime nome do comprador
If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,25)
Else
   _cNomeUser := "Nome nao cadastrado"
Endif

@ pRow()  ,003 pSay "COMPRADOR: " + Upper(_cNomeUser)
@ pRow()  ,054 pSay "| IPI   :"
@ pRow()  ,094 pSay nTotIpi         Picture tm(nTotIpi,14)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",52)
@ pRow()  ,054 pSay "| FRETE :"
@ pRow()  ,094 pSay nTotFre   Picture tm(SC7->C7_VALFRE,14)
@ pRow()  ,122 pSay "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ pRow()+1,001 pSay "| OBSERVACOES "
@ pRow()  ,054 pSay "| GRUPO :"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,1,45) // Altera‡ao feita po Jose Roberto 31/08/2000
if lImprime == .t.
   @ pRow()  ,003 pSay "Nota Fiscal sujeita a confirmacao de quantidades."
Endif
@ pRow()  ,054 pSay "|"+Replicate("-",67)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,46,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,054 pSay " | Total Geral : "
//nTotGeral:=nTotNota+nTotIpi-  nTotDesc  nDescProd xxxxxx
nTotGeral:=nTotNota+nTotIpi-nDescProd +nTotFre
@ pRow()  ,095 pSay nTotGeral      Picture tm(nTotGeral,14)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,91,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,054 pSay "|"+Replicate("-",67)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,054 pSay "|"
@ pRow()  ,062 pSay "       FORNECEDOR         "
@ pRow()  ,102 pSay "|Obs. do Frete:"+IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"+Replicate("-",52)
@ pRow()  ,054 pSay "|"
@ pRow()  ,102 pSay "|"
@ pRow()  ,122 pSay "|"

cLiberador := ""
If SY1->(DbSeek(xFilial("SY1")+SC7->C7_USER))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,20)
Else
   _cNomeUser := "Depto. Compras      "
Endif
		
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay "Depto. Compras      "
@ pRow()  ,022 pSay "|"
@ pRow()  ,023 pSay "Gerencia"
@ pRow()  ,036 pSay "|"
@ pRow()  ,037 pSay "Diretoria"
@ pRow()  ,054 pSay "|     ----------------------------------"
@ pRow()  ,102 pSay "|"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,022 pSay "|"
@ pRow()  ,036 pSay "|"
@ pRow()  ,054 pSay "|"
@ pRow()  ,102 pSay "|"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"
Eject

Return .T.


Static Function ImpRodape()
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,070 pSay "Continua ..."
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"
Eject
Return .T.


Static Function ImpCabec()
Setprc(0,0)
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2] 
//@ pRow()-pRow(),000 pSay &cNormal

@ pRow()+1,001 pSay "|-------------------------------------------|--------------------------------------------------|-------------------------|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay "| P E D I D O  D E  C O M P R A S"
@ pRow()  ,079 pSay IIf(nOrdem>1," - continuacao"," ")
@ pRow()  ,096 pSay "|"
@ pRow()  ,101 pSay SC7->C7_NUM
@ pRow()  ,107 pSay "/"+Str(nOrdem,1)
@ pRow()  ,112 pSay IIf(SC7->C7_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SM0->M0_NOMECOM
@ pRow()  ,045 pSay "|--------------------------------------------------|-------------------------|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SM0->M0_ENDENT
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Left(SA2->A2_NOME,40)+"  -  "+SA2->A2_COD+" I.E.: "+Alltrim(SA2->A2_INSCR)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SA2->A2_END            Picture PesqPict("SA2","a2_end")
@ pRow()  ,089 pSay "-  "+Trim(SA2->A2_BAIRRO) Picture "@!"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "TEL: "+SM0->M0_TEL
@ pRow()  ,022 pSay "FAX: "+SM0->M0_FAX
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Trim(SA2->A2_MUN)   Picture "@!"
@ pRow()  ,069 pSay SA2->A2_EST            Picture PesqPict("SA2","a2_est")
@ pRow()  ,074 pSay "CEP: "
@ pRow()  ,081 pSay SA2->A2_CEP            Picture PesqPict("SA2","a2_cep")
@ pRow()  ,093 pSay "CGC: "
@ pRow()  ,098 pSay SA2->A2_CGC            Picture PesqPict("SA2","A2_CGC")
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CGC: "+ transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
@ pRow()  ,028 pSay "IE:"+ SM0->M0_INSC
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SC7->C7_CONTATO
@ pRow()  ,069 pSay "FONE: "
@ pRow()  ,075 pSay Left(SA2->A2_TEL,17)
@ pRow()  ,093 pSay "FAX: "
@ pRow()  ,098 pSay Left(SA2->A2_FAX,24)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|------------------------------------------------------------------------------------------------------------------------|"
@ pRow()+1,001 pSay "|   Codigo      |Descricao do Material       |UM|  Quant.   |Valor Unitario|IPI³Valor Total | Entrega  | Revisao | S.C.  |"
@ pRow()+1,001 pSay "|------------------------------------------------------------------------------------------------------------------------|"
numPed:=SC7->C7_NUM
Return .T.

Static Function ImpProd()
cDesc := ""
nLinRef := 1
nBegin := 0
cDescri := ""

If Empty(mv_par06) 
   mv_par06 := "B1_DESC"
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
    dbSeek( xFilial()+SC7->C7_PRODUTO )
        If !Empty(SC7->C7_OBS)
           cDescri := Alltrim(SB1->B1_DESC)+" - "+Alltrim(SC7->C7_OBS)
        Else
           cDescri := Alltrim(SB1->B1_DESC)
        Endif
    dbSelectArea("SC7")
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
    dbSeek( xFilial()+SC7->C7_PRODUTO )
	If Found()
           If !Empty(SC7->C7_OBS)
              cDescri := Alltrim(B5_CEME)+" - "+Alltrim(SC7->C7_OBS)
           Else
              cDescri := Alltrim(B5_CEME)
           Endif
        EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
    If !Empty(SC7->C7_OBS)
       cDescri := Alltrim(SC7->C7_DESCRI)+" - "+Alltrim(SC7->C7_OBS)
    Else
       cDescri := Alltrim(SC7->C7_DESCRI)
    Endif
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime da descricao selecionada                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ pRow()  ,017 pSay "|"+SubStr(cDescri,1,27)
ImpCampos()
If len(trim(cDescri))> 27
  For nBegin := 28 To Len(Trim(cDescri)) Step 27
      cDesc:=Substr(cDescri,nBegin,27)
      @ pRow()+1,001 pSay "|               |"
      @ pRow()  ,018 pSay cDesc
      @ pRow()  ,046 pSay "|"
      @ pRow()  ,049 pSay "|"
      @ pRow()  ,061 pSay "|"
      @ pRow()  ,076 pSay "|"
      @ pRow()  ,080 pSay "|"
      @ pRow()  ,093 pSay "|"
      @ pRow()  ,104 pSay "|"
      @ pRow()  ,114 pSay "|"
      @ pRow()  ,122 pSay "|"
  Next nBegin
Endif
Return nil

Static Function ImpCampos()
if mv_par07 == 1
   cUnid := SC7->C7_UM
elseif !Empty(SC7->C7_SEGUM)
   cUnid := SC7->C7_SEGUM
else
   cUnid := SC7->C7_UM
endif

if mv_par07 == 1
   nQuant := SC7->C7_QUANT
elseif !Empty(SC7->C7_SEGUM)
   nQuant := SC7->C7_QTSEGUM
else
   nQuant := SC7->C7_QUANT
endif

if mv_par07 == 1
   nPreco := SC7->C7_PRECO
elseif !Empty(SC7->C7_SEGUM)
   nPreco := SC7->C7_TOTAL/SC7->C7_QTSEGUM
else
   nPreco := SC7->C7_PRECO
endif

@ pRow()   ,046 pSay "|"
@ pRow()   ,047 pSay cUnid
@ pRow()   ,049 pSay "|"
@ pRow()   ,050 pSay nQuant          Picture "999999.9999"
@ pRow()   ,061 pSay "|"
@ pRow()   ,062 pSay nPreco          Picture "@E 9,999,999.9999"
@ pRow()   ,076 pSay "|"
@ pRow()   ,077 pSay SC7->C7_IPI     Picture "99"
@ pRow()   ,079 pSay "%"
@ pRow()   ,080 pSay "|"
@ pRow()   ,081 pSay SC7->C7_TOTAL   Picture "@E 9,999,999.99"
@ pRow()   ,093 pSay "|"
@ pRow()   ,094 pSay SC7->C7_DATPRF
@ pRow()   ,104 pSay "|"
@ pRow()   ,105 pSay SB1->B1_REVDES  //Colocar a data do desenho, revisao e codigo desenho. ARQ. QE6 E SB5.
@ pRow()   ,114 pSay "|"
@ pRow()   ,115 pSay SC7->C7_NUMSC
@ pRow()   ,122 pSay "|"
nTotNota:=nTotNota+SC7->C7_TOTAL
nTotFre := nTotFre + SC7->C7_VALFRE
Return
