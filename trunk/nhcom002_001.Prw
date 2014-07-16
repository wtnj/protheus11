/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Nhcom002  º Autor ³ Sergio L Tambosi   º Data ³  17/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissao de Pedidos de Compras                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SC7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Alterado por Alexandre R.Bento p/ imprimir o Valor de Frete   04/08/04 ¼±±
±± Alterado por A.R.B. p/ imprimir o Valor de Desconto e campo OBS p/     ¼±±
±± imprimir as 200 posição do pedido de compras em 22/11/04               ¼±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Alterado:Fabio Nico  Data : 30/06/2005                                 ¼±±
±± Inclusao das observacoes no rodape                                     ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 

#INCLUDE "rwmake.ch"

User Function nhcom002()

SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,CPERG")
SetPrvt("ARETURN,NOMEPROG,NBEGIN")
SetPrvt("NTOTGER,NTOTNOTA,NTOTDESC,NTOTIPI,NDESCPROD")
SetPrvt("CSTRING,NUMPED,NREG")
SetPrvt("XTRANSP,NORDEM,COBS01,COBS02,COBS03")
SetPrvt("COBS04,LIMPRIME,NVALOR,_COBSGERAL,CRO,NK")
SetPrvt("NDESCNF,CFIL,NREGISTRO,_CNOMEUSER,COBS,NX")
SetPrvt("CVAR,NTOTGERAL,CLIBERADOR,CDESC,NLINREF,CDESCRI")
SetPrvt("CUNID,NQUANT,NPRECO,WNREL,uCodCli, uDtaRev,uRevDes")  
SetPrvt("nLargMax,nLin,nFrete,nDespesa")

wnrel      := "NHCOM002"
Titulo     := "Emissao de Pedidos de Compras"
cDesc1     := "Emissão de Pedidos de Compras Cadastrados"
cDesc2     := ""
cDesc3     := ""
aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
nomeprog   := "NHCOM002"
cPerg      := "COM002"
cString    := "SC7"
Tamanho    := "G"

nLin       := 01
limite     := 220
nLastKey   := 0
m_pag      := 01
nTotNota   := nTotGer:=nTotDesc:=nTotIpi:=nDescProd:=nTotal:=0
NumPed     := Space(6)
nLargMax   := 220
nLin       := 0
nReg       := 0
_cObsGeral := " "
nDespesa   := 0
cEndEntr   := ""
cCepEntr   := ""
/*
dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(cPerg))
While !Sx1->(Eof()) .and. SX1->X1_GRUPO = cPerg
	If SX1->X1_ORDEM == '13'
		RecLock('SX1')
			
			If SM0->M0_CODIGO=="NH"
				SX1->X1_CNT01 := "Rua Cyro Correia Pereira , 1780"
			ElseIf SM0->M0_CODIGO=="FN"
				SX1->X1_CNT01 := SM0->M0_ENDENT
			EndIf
			
		MsUnLock('SX1')
	Endif	
	SX1->(DbSkip())
Enddo
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto            ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Endereco de Entrega ?                 ³
//³ mv_par09               MPC ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                    

If !Pergunte(cPerg,.T.)
	Return(nil)
Endif	
           
If mv_par08==1 // fundicao servico
	cEndEntr := "Rua Cyro Correia Pereira, 1780"
	cCepEntr := "81460050"
ElseIf mv_par08==2 // fundicao
	cEndEntr := "Rua Wiegando Olsen, 1600"
	cCepEntr := "81460070"
ElseIf mv_par08==3 // pernambuco
	cEndEntr := "Senador Vigário Carvalho, 33"
	cCepEntr := "55JO620000"
ElseIf mv_par08==4 // ITESPAR
	cEndEntr := "Rua Padre Anchieta, 112"
	cCepEntr := "84130000"
Else
	cEndEntr := AllTrim(SM0->M0_ENDENT)
	cCepEntr := Alltrim(SM0->M0_CEPENT)
EndIf

If SM0->M0_CODIGO$'IT' // Fixo quando for para Itesa
	cEndEntr := "Rua Padre Anchieta, 112"
	cCepEntr := "84130000"
Endif


If Mv_par09 == 1
	Tamanho  := "G"
	nLargMax := 220
Else
	Tamanho  := "M"
	limite   := 120
	nLargMax := 120
Endif	


If Empty(mv_par02) .or. Empty(mv_par04)
   MsgBox("Campos Obrigatorios em Branco Verifique","Atencao","STOP")
   Return
Endif
            
wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,{},.F.,Tamanho,,.T.)

If nLastKey == 27
 	dbClearFilter() 	
	Return
Endif

SetDefault(aReturn,cString)

//-------------------------------------------------------------------
//-- verifica pendencia de aprovacao para impressao do pedido fechado
//-------------------------------------------------------------------

aCanc := {}
aPend := {}

SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL             
SZU->(DbSeek(xFilial("SZU")+Mv_par01))

While !SZU->(Eof()) .And. SZU->ZU_NUMPED == Mv_par01
	       
	If SZU->ZU_ORIGEM$"C77/C78" 
   		IF Empty(ALLTRIM(SZU->ZU_STATUS)) 
        	aAdd(aPend,{SZU->ZU_ITEMPED,SZU->ZU_LOGIN})
   		ELSEIF ALLTRIM(SZU->ZU_STATUS)$"C" 
        	aAdd(aCanc,{SZU->ZU_ITEMPED,SZU->ZU_LOGIN,SZU->ZU_DATAPR,SZU->ZU_HORAPR })
    	Endif
    Endif
    	
   	SZU->(Dbskip())
Enddo

if len(aCanc)>0 .or. len(aPend)>0
	
	cMsg := "Atenção Existem Itens Não Aprovados Deste Pedido!"+Chr(13)+chr(10)+Chr(13)+chr(10)

	For xI:=1 to len(aCanc)
		cMsg += "Pedido: "+aCanc[xI][1]+" Item: "+aCanc[xI][2]+" Cancelado por: "+ALLTRIM(aCanc[xI][3])+" ("+DTOC(aCanc[xI][4])+"-"+aCanc[xI][5]+")"+Chr(13)+chr(10)
	Next

	For xI:=1 to len(aPend)
		cMsg += "Pedido: "+aPend[xI][1]+" Item: "+aPend[xI][2]+" Falta aprovação de: "+aPend[xI][3]+Chr(13)+chr(10)
	Next
	
	//MsgBox(cMsg,"PC Nº: "+SZU->ZU_NUMPED+" - Depto de Compras","STOP")

  	MsgBox(cMsg,"PC Nº: "+Mv_par01+" - Depto de Compras","STOP")  	

    /*
   	If !Alltrim(upper(cUsername))$"MAURICIOFO/ALEXANDRERB/MARCOSR/DOUGLASSD/EDENILSONAS/GUILHERMEDC/ADMINISTRADOR"

	   	Return

    Endif
    */

Endif

//--------------------------- fim verifica aprovacao e rejeicao -------------------------

SC7->(DbSetOrder(1))
SC7->(DbGotop())
SC7->(DbSeek(xFilial("SC7")+mv_par01,.t.))

// Cadastro de Compradores, trazer nome comprador
SY1->(DbSetOrder(3)) // Filial + Cod. do Usuario

xTRANSP := Space(6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// MPC
If Mv_par09 == 1  // SIM
	If SM0->M0_CODIGO$'FN/IT'
		RptStatus({|| Detalhe3() },Titulo)
	Else
		RptStatus({|| Detalhe1() },Titulo)	
	Endif
Else //MPC = NAO
	RptStatus({|| Detalhe2() })
Endif	

Return

                         
//***************************************************************************************************************//
Static Function Detalhe1()

While SC7->(!EOF()) .AND. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02

	If SC7->C7_TIPO==2 //-- não imprime autorizacao de entrega
     	SC7->(DbSkip())
     	Loop
  	Endif

  	If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
     	SC7->(DbSkip())
     	Loop
  	Endif

  	//-- filtra por data
  	If SC7->C7_EMISSAO < mv_par03 .Or. SC7->C7_EMISSAO > mv_par04
     	SC7->(DbSkip())
     	Loop
  	Endif

   	limite     := 220
   	NumPed     := Space(6)
   	nLargMax   := 220
   	nLin       := 0
   	nReg       := 0
   	_cObsGeral := " "

  	nTotNota := nTotal := nTotGer := nTotDesc := nTotIpi  := nDescProd:= nFrete := nDespesa := 0
  	nOrdem   := 1
  	cObs01   := cObs02 := cObs03  := cObs04   := " "
  	lImprime := .f.
  
  	DbSelectArea("SC7")

  	ImpCabec1()
  //nReg := SC7->(Recno())

//  nTotNota := nTotNota  //SC7->C7_FRETE
  While SC7->C7_FILIAL = xFilial() .And. SC7->C7_NUM == NumPed
    SC1->(DbSetOrder(1))
    SC1->(DbSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC))
    If pRow() > 49 // 59 - 3 linhas do rodape
       nOrdem := nOrdem + 1
       ImpRodape1()
       ImpCabec1()
    Endif

    uCodCli := Space(15)
    uDtaRev := Ctod(Space(08))
    uRevDes := Space(02)
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
	If SB1->(Found())

		// Controle de Documentos	
        QDH->(DbSetOrder(7))
	    QDH->(DbSeek(xFilial("QDH")+SC7->C7_PRODUTO))
		While !QDH->(Eof()) .and. QDH->QDH_PRODUT == SC7->C7_PRODUTO
			If Alltrim(QDH->QDH_CODTP) == "DC" .OR. Alltrim(QDH->QDH_CODTP) == "NT"
			    uCodCli := QDH->QDH_CLIDES 
			    uDtaRev := QDH->QDH_DTREDE
   				uRevDes := QDH->QDH_INRENO
   			Endif
			QDH->(DbSkip())
   		Enddo

	    If SB1->B1_TIPO== "02" .or. SB1->B1_TIPO=="05"
   	       lImprime := .t.
	    Endif
		 If !( Alltrim(SB1->B1_TIPO) $ "MP/CP/PA/FE")
     	    SC7->(DbSkip())
		    Loop
       Endif
	Endif

    @ pRow()+1,001 pSay "|"
    @ pRow()  ,002 pSay SUBSTR(SC7->C7_ITEM,3,2)+' '+ALLTRIM(SC7->C7_PRODUTO)
    If !Empty(SC7->C7_TRANSP)
       xTRANSP := SC7->C7_TRANSP
    Endif

    ImpProd1()

    nValor := SC7->C7_TOTAL
    nFrete += SC7->C7_VALFRE //Soma o valor de frete
    nDespesa += SC7->C7_DESPESA // Soma o valor de despesa
    nTotal:=0
	 If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
       nDescProd:=nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	 Else
       nDescProd:=nDescProd+SC7->C7_VLDESC
    Endif
    nTotIpi:=nTotIpi+Round(SC7->C7_TOTAL*SC7->C7_IPI/100,2)
    RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
      SC7->C7_EMITIDO := "S"
      SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
    MsUnLock("SC7")
    nReg := SC7->(Recno())
    _cObsGeral := SC7->C7_OBSGERA
    SC7->(DbSkip())
  End
  If nReg > 0
	  SC7->(DbGoto(nReg))
  Endif		  
  If pRow() > 49
     nOrdem := nOrdem + 1
     ImpRodape1()
     ImpCabec1()
  Endif
  FinalPed1()
  SC7->(DbSkip())
End
// Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

//****************************************************************************************************************//
Static Function FinalPed1()
nk := 1
@ pRow()+1,001 pSay "+-----------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
While pRow() < 28
   @ pRow()+1,000 pSay ""
   @ pRow()  ,001 pSay "|"
   @ pRow()  ,019 pSay "|"
   @ pRow()  ,019 + nk pSay "*"
   nk := IIf( nk == 30 , 1 , nk + 1 )
	@ pRow()  ,037 pSay "|"   
   @ pRow()  ,119 pSay "|"
   @ pRow()  ,124 pSay "|"
   @ pRow()  ,138 pSay "|"
   @ pRow()  ,155 pSay "|"
   @ pRow()  ,161 pSay "|"
   @ pRow()  ,178 pSay "|"
   @ pRow()  ,189 pSay "|"   
   @ pRow()  ,199 pSay "|"
   @ pRow()  ,210 pSay "|"
   @ pRow()  ,219 pSay "|"   
End
@ pRow()+1,001 pSay "+-----------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "D E S C O N T O S -->"
@ pRow()  ,040 pSay SC7->C7_DESC1 Picture "@E 999.99"
@ pRow()  ,060 pSay SC7->C7_DESC2 Picture "@E 999.99"
@ pRow()  ,080 pSay SC7->C7_DESC3 Picture "@E 999.99"
nTotal:=0
nValor := nTotNota
@ pRow(),098 pSay nDescProd Picture tm(nDescProd,14)
@ pRow(),219 pSay "|"
@ pRow()+1,001 pSay "+" + Replicate("-",217) + "+"
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
   @ pRow()  ,146 pSay "|"
   @ pRow()+1,001 pSay "+"
   @ pRow()  ,002 pSay Replicate("-",136)
   @ pRow()  ,146 pSay "+"
Endif

cFil := iif(empty(SC7->C7_FILENT),"01",SC7->C7_FILENT)
SM0->(DbSetOrder(1))
nRegistro := SM0->(Recno())
SM0->(DbSeek(SUBS(cNumEmp,1,2)+cFil))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Entrega  : " +Substr(cEndEntr,1,30) // + SM0->M0_ENDENT
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDENT
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTENT            
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay cCepEntr
@ pRow()  ,219 pSay "|"
SM0->(DbGoto(nRegistro))

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + ALLTRIM(SM0->M0_ENDCOB)
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDCOB
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTCOB
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPCOB)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"

SE4->(DbSeek(xFilial()+SC7->C7_COND))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CONDICAO DE PAGTO : "+SubStr(SE4->E4_COND,1,42)
@ pRow()  ,066 pSay "EMISSAO: " + DTOC(SC7->C7_EMISSAO) 
@ pRow()  ,090 pSay "TOTAL DAS MERCADORIAS: " + TRANSFORM(nTotNota,"@E 99,999,999.99")
//@ pRow()  ,108 pSay TRANSFORM(nTotNota,"@E 99,999,999.99")//nTotNota Picture "@E 99,999,999.99"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SE4->E4_DESCRI
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"


//Imprime nome do comprador
If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,25)
Else
   _cNomeUser := "Nome nao cadastrado"
Endif

@ pRow()+1,001 pSay "| COMPRADOR: " + Upper(_cNomeUser)
@ pRow()  ,094 pSay "| IPI   :"
@ pRow()  ,134 pSay nTotIpi         Picture tm(nTotIpi,14)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",92)
@ pRow()  ,094 pSay "+ FRETE :"
@ pRow()  ,134 pSay nFrete   Picture tm(nFrete,14)
@ pRow()  ,219 pSay "|"

//³ Inicializar campos de Observacoes.                           
@ pRow()+1,001 pSay "| OBSERVACOES "
@ pRow()  ,094 pSay "|"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,1,45) // Altera‡ao feita po Jose Roberto 31/08/2000
if lImprime == .t.
   @ pRow()  ,003 pSay "Nota Fiscal sujeita a confirmacao de quantidades."
Endif
@ pRow()  ,094 pSay "+" +Replicate("-",124)
@ pRow()  ,219 pSay "+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,46,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,094 pSay "| Total Geral : "
nTotGeral:=nTotNota+nTotIpi+nFrete+nDespesa-nDescProd
@ pRow()  ,135 pSay nTotGeral      Picture tm(nTotGeral,14)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,91,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,094 pSay "+-----------------------------------------------+----------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,094 pSay "|"
@ pRow()  ,102 pSay "         FORNECEDOR       "
@ pRow()  ,142 pSay "|Obs. do Frete:"+IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+------------------------------+------------------------------+------------------------------+"
@ pRow()  ,142 pSay "|"
@ pRow()  ,219 pSay "|"

cLiberador := ""
If SY1->(DbSeek(xFilial("SY1")+SC7->C7_USER))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,20)
Else
   _cNomeUser := "Depto. Compras      "
Endif
		
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Depto. Compras      "
@ pRow()  ,032 pSay "|"
@ pRow()  ,034 pSay "Gerencia"
@ pRow()  ,063 pSay "|"
@ pRow()  ,065 pSay "Diretoria"
@ pRow()  ,094 pSay "|     ----------------------------------"
@ pRow()  ,142 pSay "|"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,032 pSay "|"
@ pRow()  ,063 pSay "|"
@ pRow()  ,094 pSay "|"
@ pRow()  ,142 pSay "|"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+------------------------------+------------------------------+------------------------------+-----------------------------------------------+----------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|   NOTA: Somente aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",217)
@ pRow()  ,219 pSay "+"


@ pRow()+1,001 pSay "|   FORMA DE PAGAMENTO: Credito em Conta Corrente Exclusivamente do Fornecedor                                            | A T E N Ç Ã O:                                                                           "
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   OBS : 1 -> NAO EMITIR BOLETO BANCARIO                                                                                 | Nossa Empresa não pratica e tem como princípio não estabelecer  relações  comerciais  de "
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         2 -> TODOS OS PAGAMENTOS SÃO FEITOS SOMENTE NAS QUARTAS E SEXTAS-FEIRAS                                         | qualquer natureza com empresas que façam uso de trabalho escravo, exploração de trabalho "
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         3 -> A CONDICAO DE PAGAMENTO SERA INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB.                    | infantil, bem como aquisição de material extraído de forma ilegal. Assim, reserva-se  o  "
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         4 -> COM A IMPLANTAÇÃO DO SISTEMA DE GESTÃO AMBIENTAL DA WHB, O FORNECEDOR DEVE ATENDER OS REQUISITOS           | direito de descontinuar qualquer relação comercial diante da constatação dessas práticas,"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|              AMBIENTAIS AO DISPONIBILIZAR PRODUTOS E SERVIÇOS.                                                          | tanto nas atividades diretas, quanto na cadeia de suprimentos dos mesmos." 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         5 -> EM CASO DE NOTA FISCAL ELETRONICA ENCAMINHAR ARQUIVO XML P/: " +Iif(SM0->M0_CODIGO=="NH","nfe@whbusinagem.com.br",Iif(SM0->M0_CODIGO=="FN","nfe@whbfundicao.com.br","nfe@itesapar.com.br"))+"                        |" 
@ pRow()  ,219 pSay "|"

//oDanfe:Say(428,102,Iif(!Empty(aTransp[12]),aTransp[12],Iif(Len(aEspVol)>0,aEspVol[1][1],"")),oFont08:oFont)
//A CONDIÇÃO DE PAGAMENTO SERA  INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB COMPONENTES  AUTOMOTIVOS S/A"
 
@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",217)
@ pRow()  ,219 pSay "+"

If SC7->C7_NUM < mv_par02 // .And. SC7->C7_NUM <= mv_par02 
   Eject                    
Endif

Return .T.

//***************************************************************************************************************//
Static Function ImpRodape1()
Local lim := limite -3
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",lim)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,070 pSay "Continua ..."
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",lim)
@ pRow()  ,219 pSay "|"                                     
EJECT  
Return .T.


//************************************************************************************************************//
Static Function ImpCabec1()
FmtLin(,AvalImp(nLargMax),,,@nLin)
@ pRow()+1,001 pSay "+-------------------------------------------+----------------------------------+----------------------+-------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay "| P E D I D O  D E  C O M P R A S "
@ pRow()  ,080 pSay "|"
@ pRow()  ,082 pSay SC7->C7_NUM
@ pRow()  ,088 pSay "/"+Str(nOrdem,1)+ " - "+ IIf(SC7->C7_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,103 pSay "|"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay AllTrim(SM0->M0_NOMECOM)
@ pRow()  ,045 pSay "+----------------------------------+----------------------+-------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay ALLTRIM(SM0->M0_ENDCOB)

SA2->(DbSetOrder(1))
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Left(SA2->A2_NOME,40)+"  -  "+SA2->A2_COD+" I.E.: "+Alltrim(SA2->A2_INSCR)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SA2->A2_END Picture PesqPict("SA2","a2_end")
@ pRow()  ,089 pSay "-  "+Trim(SA2->A2_BAIRRO) Picture "@!"
@ pRow()  ,219 pSay "|"
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
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CGC: "+ transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
@ pRow()  ,028 pSay "IE:"+ SM0->M0_INSC
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SC7->C7_CONTATO
@ pRow()  ,069 pSay "FONE: "
@ pRow()  ,075 pSay Left(SA2->A2_TEL,17)
@ pRow()  ,093 pSay "FAX: "
@ pRow()  ,098 pSay Left(SA2->A2_FAX,24)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
@ pRow()+1,001 pSay "| Item/Codigo WHB |  Desenho/Norma  | Descricao do Material                                                           | UM |  Quantidade | Valor Unit.    | IPI |   Valor Total  | Entrega  | Num.Rev | Dat.Rev  |  S.C.  |"
@ pRow()+1,001 pSay "+-----------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
numPed:=SC7->C7_NUM

Return .T.

//***************************************************************************************************************//
Static Function ImpProd1()
cDesc := ""
nLinRef := 1
nBegin := 0
cDescri := ""          

//-- melhorado por joaofr 23/05/2012

If mv_par06==1 //AllTrim(mv_par06)=='B1_DESC' .OR. EMPTY(mv_par06)
	cDescri := Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,'B1_DESC')
Elseif mv_par06==2 ///AllTrim(mv_par06)=="B5_CEME"
	cDescri := Posicione('SB5',1,xFilial('SB5')+SC7->C7_PRODUTO,'B5_CEME')
Elseif mv_par06==3 //AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := SC7->C7_DESCRI
endif

cDescri := alltrim(cDescri) + Iif(!Empty(SC7->C7_OBS)," - "+Alltrim(SC7->C7_OBS),'')

@ pRow()  ,019 pSay "|" + AllTrim(uCodCli)
@ pRow()  ,037 pSay "|"+SubStr(cDescri,1,70)

ImpCampos1()
If len(trim(cDescri))> 70
  For nBegin := 71 To Len(Trim(cDescri)) Step 70
      cDesc:=Substr(cDescri,nBegin,70)
      @ pRow()+1,001 pSay "|                 |"
      @ pRow()  ,037 pSay "|" + AllTrim(cDesc)
      @ pRow()  ,119 pSay "|"
      @ pRow()  ,124 pSay "|"
      @ pRow()  ,138 pSay "|"
      @ pRow()  ,155 pSay "|"
      @ pRow()  ,161 pSay "|"
      @ pRow()  ,178 pSay "|"
      @ pRow()  ,189 pSay "|"
      @ pRow()  ,199 pSay "|"
      @ pRow()  ,210 pSay "|"
      @ pRow()  ,219 pSay "|"
  Next nBegin
Endif
Return nil

//*************************************************************************************************************//
Static Function ImpCampos1()

if mv_par07 != 1 .AND. !Empty(SC7->C7_SEGUM)
   cUnid  := SC7->C7_SEGUM
   nQuant := SC7->C7_QTSEGUM
   nPreco := SC7->C7_TOTAL/SC7->C7_QTSEGUM
else
   cUnid  := SC7->C7_UM
   nQuant := SC7->C7_QUANT
   nPreco := SC7->C7_PRECO
endif

@ pRow()   ,119 pSay "|"
@ pRow()   ,120 pSay cUnid
@ pRow()   ,124 pSay "|"
@ pRow()   ,126 pSay nQuant          Picture "9999999.9999"
@ pRow()   ,138 pSay ""
@ pRow()   ,140 pSay nPreco          Picture "@E 9,999,999.9999"
@ pRow()   ,155 pSay "|"
@ pRow()   ,156 pSay SC7->C7_IPI     Picture "99"
@ pRow()   ,160 pSay "%"
@ pRow()   ,161 pSay "|"
@ pRow()   ,164 pSay SC7->C7_TOTAL   Picture "@E 99,999,999.99"
@ pRow()   ,178 pSay "|"          

if len(dtoc(SC7->C7_DATPRF)) == 10
	@ pRow()   ,180 pSay substr(dtoc(SC7->C7_DATPRF), 1,6)+substr(dtoc(SC7->C7_DATPRF), 9,2)
else	
	@ pRow()   ,180 pSay SC7->C7_DATPRF 
endif   

@ pRow()   ,189 pSay "|"
@ pRow()   ,190 pSay Substr(Alltrim(uRevDes),1,9)
@ pRow()   ,199 pSay "|"

if len(dtoc(uDtaRev)) = 10
	@ pRow()   ,200 pSay substr(dtoc(uDtaRev), 1,6)+substr(dtoc(uDtaRev), 9,2)
else	
   	@ pRow()   ,200 pSay uDtaRev 
endif         

@ pRow()   ,210 pSay "|"
@ pRow()   ,211 pSay SC7->C7_NUMSC
@ pRow()   ,219 pSay "|"

nTotNota += SC7->C7_TOTAL

Return


Static Function Detalhe2()

   NumPed     := Space(6)
   nLin       := 0
   nReg       := 0
   _cObsGeral := " "

SetRegua(150) 
While SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02 .And. !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nTotNota := nTotal := nTotGer := nTotDesc := nTotIpi  := nDescProd:= nFrete := 0
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

  ImpCabec2()
  nReg := SC7->(Recno())

//  nTotNota := nTotNota + SC7->C7_FRETE
  While SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == NumPed

	/*
	 O Código abaixo verifica se existe aprovação do item para impressão, caso contrário será impresso apenas os itens aprovados.
	*/
	/*
	SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
	SZU->(DbSeek(xFilial("SC7")+SC7->C7_NUM+SC7->C7_ITEM))
	IF Empty(ALLTRIM(SZU->ZU_STATUS))
		
		SC7->(DbSkip())
		Loop
			
	Endif
	*/
  
    SC1->(DbSetOrder(1))
    SC1->(DbSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC))
    IncRegua() //Incrementa a posicao da regua de relatorios
	
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se havera salto de formulario                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If pRow() > 40 // 59 - 3 linhas do rodape
       nOrdem := nOrdem + 1
       ImpRodape2()
       ImpCabec2()
    Endif
    

    SB1->(DbSetOrder(1))//FILIAL + COD
    SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
    If SB1->(Found())	
	    If SB1->B1_TIPO == "02" .or. SB1->B1_TIPO == "05"
   	    	lImprime := .t.
	    Endif

		 //If (Alltrim(SB1->B1_TIPO) $ "MP/CP/FE")
     	 //   SC7->(DbSkip())
		 //   Loop
         //Endif

    Endif
    
    @ pRow()+1,001 pSay "|"

    @ pRow()  ,002 pSay SUBSTR(SC7->C7_ITEM,3,2)+' '+ALLTRIM(SC7->C7_PRODUTO) //AQUIAQUI
    If !Empty(SC7->C7_TRANSP)
       xTRANSP := SC7->C7_TRANSP
    Endif

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³ Pesquisa Descricao do Produto                                ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ImpProd2()
    nValor := SC7->C7_TOTAL
    nTotal:=0
   

	 If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
       nDescProd:=nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	 Else
       nDescProd:=nDescProd+SC7->C7_VLDESC
	Endif
	
    nTotIpi:=nTotIpi+Round(SC7->C7_TOTAL*SC7->C7_IPI/100,2)
    nDespesa += SC7->C7_DESPESA // Soma o valor de despesa
    nFrete += SC7->C7_VALFRE // Soma valor do frete
    RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
      SC7->C7_EMITIDO := "S"
      SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
    MsUnLock("SC7")
    nReg := SC7->(Recno())
    _cObsGeral := SC7->C7_OBSGERA    
    SC7->(DbSkip())
  End
  SC7->(DbGoto(nReg))
  If pRow() > 49
     nOrdem := nOrdem + 1
     ImpRodape2()
     ImpCabec2()
  Endif
  FinalPed2()
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

Return




Static Function FinalPed2()
nk := 1
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay "------------------|-----------------------|--|-----------|---------------|---|-------------|------------|--------|------"
@ pRow()  ,122 pSay "|"
@ pRow()+1,000 pSay ""
While pRow() < 28
   @ pRow()  ,001 pSay "|"
   @ pRow()  ,020 pSay "|"
   @ pRow()  ,020 + nk pSay "*"
   nk := IIf( nk == 29 , 1 , nk + 1 )
   @ pRow()  ,044 pSay "|"
   @ pRow()  ,047 pSay "|"
   @ pRow()  ,059 pSay "|"
   @ pRow()  ,075 pSay "|"
   @ pRow()  ,079 pSay "|"
   @ pRow()  ,093 pSay "|"
   @ pRow()  ,106 pSay "|"
   @ pRow()  ,115 pSay "|"
   @ pRow()  ,122 pSay "|"
   @ pRow()+1,000 pSay ""
Enddo

@ pRow()  ,001 pSay "|------------------|-----------------------|--|-----------|---------------|---|-------------|------------|--------|------|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,015 pSay "D E S C O N T O S -->"
@ pRow()  ,037 pSay SC7->C7_DESC1 Picture "@E 999.99"
@ pRow()  ,046 pSay SC7->C7_DESC2 Picture "@E 999.99"
@ pRow()  ,055 pSay SC7->C7_DESC3 Picture "@E 999.99"
nTotal:=0
nValor := nTotNota
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
@ pRow()  ,003 pSay "Local de Entrega  : " + Substr(cEndEntr,1,30) // + SM0->M0_ENDENT
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDENT
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTENT
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay cCepEntr
@ pRow()  ,122 pSay "|"
SM0->(DbGoto(nRegistro))

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + ALLTRIM(SM0->M0_ENDCOB)
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
@ pRow()  ,003 pSay "CONDICAO DE PAGTO : "+SubStr(SE4->E4_COND,1,35)
@ pRow()  ,057 pSay "EMISSAO: "+ DTOC(SC7->C7_EMISSAO)
@ pRow()  ,078 pSay "TOTAL DAS MERCADORIAS : "
@ pRow()  ,103 pSay nTotNota Picture "@E 999,999,999.99"
@ pRow()  ,121 pSay "|"

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SE4->E4_DESCRI
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
//@ pRow()  ,094 pSay SC7->C7_FRETE   Picture tm(SC7->C7_FRETE,14)
@ pRow()  ,094 pSay nFrete  Picture tm(nFrete,14)
@ pRow()  ,122 pSay "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ pRow()+1,001 pSay "| OBSERVACOES "
@ pRow()  ,054 pSay "| DESCONTO: "                  
@ pRow()  ,094 pSay nDescProd Picture tm(nDescProd,14)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,1,50) // Altera‡ao feita po Jose Roberto 31/08/2000
if lImprime == .t.
   @ pRow()  ,003 pSay "Nota Fiscal sujeita a confirmacao de quantidades."
Endif
@ pRow()  ,054 pSay "| DESPESAS: "
@ pRow()  ,094 pSay nDespesa Picture tm(nDespesa,14)
@ pRow()  ,122 pSay "|"

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,51,50) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,054 pSay "|"+Replicate("-",67)
@ pRow()  ,122 pSay "|"

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,101,50) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,054 pSay "| Total Geral :"
nTotGeral:=nTotNota+nTotIpi+nFrete+nDespesa-nDescProd 
@ pRow()  ,094 pSay nTotGeral      Picture tm(nTotGeral,14)
@ pRow()  ,122 pSay "|"

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,151,50) // Altera‡ao feita po Jose Roberto 31/08/2000
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
@ pRow()+1,001 pSay "|   NOTA: Somente aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "|"


@ pRow()+1,001 pSay "|   FORMA DE PAGAMENTO: Credito em Conta Corrente Exclusivamente do Fornecedor"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   OBS : 1 -> NAO EMITIR BOLETO BANCARIO"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|         2 -> TODOS OS PAGAMENTOS SÃO FEITOS SOMENTE NAS QUARTAS E SEXTAS-FEIRAS"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|         3 -> A CONDICAO DE PAGAMENTO SERA INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA EMPRESA."
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|         4 -> COM A IMPLANTAÇÃO DO SISTEMA DE GESTÃO AMBIENTAL, O FORNECEDOR DEVE ATENDER OS REQUISITOS"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|              AMBIENTAIS AO DISPONIBILIZAR PRODUTOS E SERVIÇOS."
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|         5 -> EM CASO DE NOTA FISCAL ELETRONICA ENCAMINHAR ARQUIVO XML P/: " +Iif(SM0->M0_CODIGO=="NH","nfe@whbusinagem.com.br",Iif(SM0->M0_CODIGO=="FN","nfe@whbfundicao.com.br","nfe@itesapar.com.br")) 
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   A T E N Ç Ã O:"              
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   A empresa não pratica e tem como princípio não estabelecer relações comerciais  de  qualquer  natureza com  empresas"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   que façam uso de trabalho escravo, exploração de trabalho infantil, bem como aquisição de material extraído de forma"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   ilegal. Assim, reserva-se o direito de descontinuar qualquer relação comercial diante da constatação dessas praticas,"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|   tanto nas atividades diretas, quanto na cadeia de suprimentos dos mesmos."
@ pRow()  ,122 pSay "|"


@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",limite)
@ pRow()  ,122 pSay "+"

//Eject tirado por alexandre R. Bento em 22/11/04 estava pulando uma folha no final no final da impressao do pedido
If SC7->C7_NUM < mv_par02 
   Eject                    
Endif

Return .T.




Static Function ImpRodape2()
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


Static Function ImpCabec2()

Setprc(0,0)

@ pRow()+1,001 pSay "+-------------------------------------------+--------------------------------------------------+-------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay "| P E D I D O  D E  C O M P R A S"
@ pRow()  ,079 pSay IIf(nOrdem>1," - continuacao"," ")
@ pRow()  ,096 pSay "|"
@ pRow()  ,101 pSay SC7->C7_NUM
@ pRow()  ,107 pSay "/"+Str(nOrdem,1)
@ pRow()  ,112 pSay IIf(SC7->C7_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay AllTrim(SM0->M0_NOMECOM)
@ pRow()  ,045 pSay "|--------------------------------------------------|-------------------------|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay ALLTRIM(SM0->M0_ENDCOB)

SA2->(DbsetOrder(1))
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Left(SA2->A2_NOME,40)+"  -  "+SA2->A2_COD+" I.E.: "+Alltrim(SA2->A2_INSCR)
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SA2->A2_END            Picture PesqPict("SA2","A2_END")
@ pRow()  ,089 pSay "-  "+Trim(SA2->A2_BAIRRO) Picture "@!"
@ pRow()  ,122 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "TEL: "+SM0->M0_TEL
@ pRow()  ,022 pSay "FAX: "+SM0->M0_FAX
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Trim(SA2->A2_MUN)   Picture "@!"
@ pRow()  ,069 pSay SA2->A2_EST            Picture PesqPict("SA2","A2_EST")
@ pRow()  ,074 pSay "CEP: "
@ pRow()  ,081 pSay SA2->A2_CEP            Picture PesqPict("SA2","A2_CEP")
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
@ pRow()+1,001 pSay "|      Codigo      | Descricao do Material |UM|  Quant.   |   Valor Unit. |IPI|Valor Total  |Entrega     |Revisao |S.C   |"
@ pRow()+1,001 pSay "|------------------------------------------------------------------------------------------------------------------------|"
numPed:=SC7->C7_NUM
Return .T.


Static Function ImpProd2()
cDesc := ""
nLinRef := 1
nBegin := 0
cDescri := ""

//-- melhorado por joaofr 23/05/2012

If mv_par06==1 //AllTrim(mv_par06)=='B1_DESC' .OR. EMPTY(mv_par06)
	cDescri := Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,'B1_DESC')
Elseif mv_par06==2 ///AllTrim(mv_par06)=="B5_CEME"
	cDescri := Posicione('SB5',1,xFilial('SB5')+SC7->C7_PRODUTO,'B5_CEME')
Elseif mv_par06==3 //AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := SC7->C7_DESCRI
endif

cDescri := alltrim(cDescri) + Iif(!Empty(SC7->C7_OBS)," - "+Alltrim(SC7->C7_OBS),'')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime da descricao selecionada                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ pRow()  ,020 pSay "|"+SubStr(cDescri,1,23) // 27
ImpCampos2()
If len(trim(cDescri))> 23
  For nBegin := 24 To Len(Trim(cDescri)) Step 23
      cDesc:=Substr(cDescri,nBegin,23)
      @ pRow()+1,001 pSay "|                  |"
      @ pRow()  ,021 pSay cDesc
      @ pRow()  ,044 pSay "|"
      @ pRow()  ,047 pSay "|"
      @ pRow()  ,059 pSay "|"
      @ pRow()  ,075 pSay "|"
      @ pRow()  ,079 pSay "|"  
      @ pRow()  ,093 pSay "|"
      @ pRow()  ,106 pSay "|"        
      @ pRow()  ,115 pSay "|"
      @ pRow()  ,122 pSay "|"
  Next nBegin
Endif

Return nil

Static Function ImpCampos2()

if mv_par07 != 1 .AND. !Empty(SC7->C7_SEGUM)
   cUnid  := SC7->C7_SEGUM
   nQuant := SC7->C7_QTSEGUM
   nPreco := SC7->C7_TOTAL/SC7->C7_QTSEGUM
else
   cUnid  := SC7->C7_UM
   nQuant := SC7->C7_QUANT
   nPreco := SC7->C7_PRECO
endif

@ pRow()   ,044 pSay "|"
@ pRow()   ,045 pSay cUnid
@ pRow()   ,047 pSay "|"
@ pRow()   ,048 pSay nQuant          Picture "9999999.9999"
@ pRow()   ,059 pSay ""
@ pRow()   ,060 pSay nPreco          Picture "@E 99,999,999.9999"
@ pRow()   ,075 pSay "|"
@ pRow()   ,076 pSay SC7->C7_IPI     Picture "99"
@ pRow()   ,078 pSay "%"
@ pRow()   ,079 pSay "|"
@ pRow()   ,080 pSay SC7->C7_TOTAL   Picture "@E 99,999,999.99"
@ pRow()   ,093 pSay "|"
@ pRow()   ,094 pSay SC7->C7_DATPRF
@ pRow()   ,106 pSay "|"
@ pRow()   ,107 pSay SB1->B1_REVDES  //Colocar a data do desenho, revisao e codigo desenho. ARQ. QE6 E SB5.
@ pRow()   ,115 pSay "|"
@ pRow()   ,116 pSay SC7->C7_NUMSC
@ pRow()   ,122 pSay "|"
nTotNota:=nTotNota+SC7->C7_TOTAL

Return

                         
// Especifico ETM - Fundicao e DC
Static Function Detalhe3()
Local _cDocto := Space(16)

While SC7->(!Eof()) .AND. SC7->C7_FILIAL == xFilial('SC7') .AND. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02

   	limite     := 220
   	NumPed     := Space(6)
   	nLargMax   := 220
   	nLin       := 0
   	nReg       := 0
   	_cObsGeral := " "

  	nTotNota := nTotal := nTotGer := nTotDesc := nTotIpi  := nDescProd:= nFrete := nDespesa := 0
  	nOrdem   := 1
  	cObs01   := cObs02 := cObs03  := cObs04   := " "
  	lImprime := .f.
  	DbSelectArea("SC7")
  	If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
     	SC7->(DbSkip())
     	Loop
  	Endif

  	If SC7->C7_EMISSAO < mv_par03 .Or. SC7->C7_EMISSAO > mv_par04
     	SC7->(DbSkip())
     	Loop
  	Endif

  	ImpCabec3()

	numPed:=SC7->C7_NUM
	
  	While SC7->(!EOF()) .AND. SC7->C7_FILIAL == xFilial('SC7') .And. SC7->C7_NUM == NumPed
    	
    	SC1->(DbSetOrder(1))
	    SC1->(DbSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC))
	    
	    If pRow() > 40 // 59 - 3 linhas do rodape
	       	nOrdem++
	       	ImpRodape3()
	       	ImpCabec3()
	    	numPed:=SC7->C7_NUM
	    Endif
	
	    uCodCli := Space(15)
    	uDtaRev := Ctod(Space(08))
	    uRevDes := Space(03)
    	
    	SB1->(DbSetOrder(1))
	    If SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

			If Alltrim(SB1->B1_TIPO) $ "MP/MA/CP/FE/PA"

				// Assume no cadastro do produto para atender DC
				uCodCli := SB1->B1_CODAP5
				uDtaRev := SB1->B1_REDEDOC
				uRevDes := SB1->B1_CODDES			
	
		        QDH->(DbSetOrder(7))
			    QDH->(DbSeek(xFilial("QDH")+SC7->C7_PRODUTO))
				If QDH->(Found())
					_cDocto := QDH->QDH_DOCTO
			        QDH->(DbSetOrder(1)) // Ultima revisao
				    QDH->(DbSeek(xFilial("QDH")+_cDocto))
					While !QDH->(Eof()) .and. QDH->QDH_FILIAL==xFilial('QDH') .AND. QDH->QDH_DOCTO == _cDocto
						If Alltrim(QDH->QDH_CODTP) == 'ETM'
						    uCodCli := QDH->QDH_DOCTO
						    uDtaRev := QDH->QDH_DTRVD
			    			uRevDes := QDH->QDH_RV
			    		Elseif Alltrim(QDH->QDH_CODTP) == 'DC'
						    uCodCli := QDH->QDH_CLIDES
						    uDtaRev := QDH->QDH_DTREDE
			    			uRevDes := QDH->QDH_INRENO
			    		Endif
						QDH->(DbSkip())
		    		Enddo
				Endif
			Endif

	    	/*
	    	If SB1->B1_TIPO== "02" .or. SB1->B1_TIPO=="05"
   	       		lImprime := .t.
	    	Endif
            */
            
		Endif

    	@ pRow()+1,001 pSay "|" + SUBSTR(SC7->C7_ITEM,3,2)+' '+Substr(ALLTRIM(SC7->C7_PRODUTO),1,15)

	    If !Empty(SC7->C7_TRANSP)
	       	xTRANSP := SC7->C7_TRANSP
	    Endif
	
    	ImpProd3()

    nValor := SC7->C7_TOTAL
    nFrete += SC7->C7_VALFRE //Soma o valor de frete
    nDespesa += SC7->C7_DESPESA // Soma o valor de despesa
    nTotal:=0
	 If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
       nDescProd:=nDescProd+CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	 Else
       nDescProd:=nDescProd+SC7->C7_VLDESC
    Endif
    nTotIpi:=nTotIpi+Round(SC7->C7_TOTAL*SC7->C7_IPI/100,2)
    RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
      SC7->C7_EMITIDO := "S"
      SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
    MsUnLock("SC7")
    nReg := SC7->(Recno())
    _cObsGeral := SC7->C7_OBSGERA
    SC7->(DbSkip())
  End
  If nReg > 0
	  SC7->(DbGoto(nReg))
  Endif		  
  If pRow() > 50
     nOrdem := nOrdem + 1
     ImpRodape3()
     ImpCabec3()
  Endif
  FinalPed3()
  SC7->(DbSkip())
End
// Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


//
Static Function ImpCabec3()

Setprc(0,0)

FmtLin(,AvalImp(nLargMax),,,@nLin)
@ pRow()+1,001 pSay "+-------------------------------------------+----------------------------------+----------------------+--------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay "| P E D I D O  D E  C O M P R A S "
@ pRow()  ,080 pSay "|"
@ pRow()  ,082 pSay SC7->C7_NUM
@ pRow()  ,088 pSay "/"+Str(nOrdem,1)+ " - "+ IIf(SC7->C7_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,103 pSay "|"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay AllTrim(SM0->M0_NOMECOM)
@ pRow()  ,045 pSay "+----------------------------------+----------------------+--------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay ALLTRIM(SM0->M0_ENDCOB)

SA2->(DbSetOrder(1))
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))


@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Left(SA2->A2_NOME,40)+"  -  "+SA2->A2_COD+" I.E.: "+Alltrim(SA2->A2_INSCR)
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SA2->A2_END Picture PesqPict("SA2","A2_END")
@ pRow()  ,089 pSay "-  "+Trim(SA2->A2_BAIRRO) Picture "@!"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "TEL: "+SM0->M0_TEL
@ pRow()  ,022 pSay "FAX: "+SM0->M0_FAX
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Trim(SA2->A2_MUN)   Picture "@!"
@ pRow()  ,069 pSay SA2->A2_EST            Picture PesqPict("SA2","A2_EST")
@ pRow()  ,074 pSay "CEP: "
@ pRow()  ,081 pSay SA2->A2_CEP            Picture PesqPict("SA2","A2_CEP")
@ pRow()  ,093 pSay "CGC: "
@ pRow()  ,098 pSay SA2->A2_CGC            Picture PesqPict("SA2","A2_CGC")
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CGC: "+ transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
@ pRow()  ,028 pSay "IE:"+ SM0->M0_INSC
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SC7->C7_CONTATO
@ pRow()  ,069 pSay "FONE: "
@ pRow()  ,075 pSay Left(SA2->A2_TEL,17)
@ pRow()  ,093 pSay "FAX: "
@ pRow()  ,098 pSay Left(SA2->A2_FAX,24)
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+------------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
@ pRow()+1,001 pSay "|   Codigo WHB     |Cod.Cli/Esp.Tec. | Descricao do Material                                                           | UM |  Quantidade |   Valor Unit.  | IPI |   Valor Total  | Entrega  | Num.Rev |Dt.Rev.Doc|  S.C.  |"
@ pRow()+1,001 pSay "+------------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"

Return .T.

//***************************************************************************************************************//
Static Function ImpRodape3()

	@ pRow()+1,001 pSay "|" + Replicate("-",218) + "|"
	@ pRow()+1,001 pSay "|"
	@ pRow()  ,100 pSay "Continua ..."
	@ pRow()  ,220 pSay "|"
	@ pRow()+1,001 pSay "+" + Replicate("-",218) + "+"                                     
	EJECT

Return .T.

//****************************************************************************************************************//
Static Function FinalPed3()
nk := 1
@ pRow()+1,001 pSay "+------------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
While pRow() < 28
   @ pRow()+1,000 pSay ""
   @ pRow()  ,001 pSay "|"
   @ pRow()  ,020 pSay "|"
   @ pRow()  ,020 + nk pSay "*"
   nk := IIf( nk == 30 , 1 , nk + 1 )
   @ pRow()  ,038 pSay "|"   
   @ pRow()  ,120 pSay "|"
   @ pRow()  ,125 pSay "|"
   @ pRow()  ,139 pSay "|"
   @ pRow()  ,156 pSay "|"
   @ pRow()  ,162 pSay "|"
   @ pRow()  ,179 pSay "|"
   @ pRow()  ,190 pSay "|"   
   @ pRow()  ,200 pSay "|"
   @ pRow()  ,211 pSay "|"
   @ pRow()  ,220 pSay "|"   
End
@ pRow()+1,001 pSay "+------------------+-----------------+---------------------------------------------------------------------------------+----+-------------+----------------+-----+----------------+----------+---------+----------+--------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "D E S C O N T O S -->"
@ pRow()  ,040 pSay SC7->C7_DESC1 Picture "@E 999.99"
@ pRow()  ,060 pSay SC7->C7_DESC2 Picture "@E 999.99"
@ pRow()  ,080 pSay SC7->C7_DESC3 Picture "@E 999.99"
nTotal:=0
nValor := nTotNota
@ pRow(),098 pSay nDescProd Picture tm(nDescProd,14)
@ pRow(),220 pSay "|"
@ pRow()+1,001 pSay "+" + Replicate("-",218) + "+"
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
   @ pRow()  ,146 pSay "|"
   @ pRow()+1,001 pSay "+"
   @ pRow()  ,002 pSay Replicate("-",136)
   @ pRow()  ,146 pSay "+"
Endif

cFil := iif(empty(SC7->C7_FILENT),"01",SC7->C7_FILENT)
SM0->(DbSetOrder(1))
nRegistro := SM0->(Recno())
SM0->(DbSeek(SUBS(cNumEmp,1,2)+cFil))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Entrega  : " +OEMTOANSI(Substr(cEndEntr,1,30)) // + SM0->M0_ENDENT
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay OEMTOANSI(ALLTRIM(SM0->M0_CIDENT))
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay OEMTOANSI(ALLTRIM(SM0->M0_ESTENT))
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay OEMTOANSI(ALLTRIM(cCepEntr))
@ pRow()  ,220 pSay "|"
SM0->(DbGoto(nRegistro))

@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + OEMTOANSI(ALLTRIM(SM0->M0_ENDCOB))
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay OEMTOANSI(ALLTRIM(SM0->M0_CIDCOB))
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay OEMTOANSI(ALLTRIM(SM0->M0_ESTCOB))
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay OEMTOANSI(Alltrim(SM0->M0_CEPCOB))
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"

SE4->(DbSeek(xFilial()+SC7->C7_COND))
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CONDICAO DE PAGTO : "+SubStr(SE4->E4_COND,1,42)
@ pRow()  ,066 pSay "EMISSAO: " + DTOC(SC7->C7_EMISSAO) 
@ pRow()  ,090 pSay "TOTAL DAS MERCADORIAS: " + TRANSFORM(nTotNota,"@E 99,999,999.99")
//@ pRow()  ,108 pSay TRANSFORM(nTotNota,"@E 99,999,999.99")//nTotNota Picture "@E 99,999,999.99"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SE4->E4_DESCRI
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"


//Imprime nome do comprador
If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,25)
Else
   _cNomeUser := "Nome nao cadastrado"
Endif

@ pRow()+1,001 pSay "| COMPRADOR: " + Upper(_cNomeUser)
@ pRow()  ,094 pSay "| IPI   :"
@ pRow()  ,134 pSay nTotIpi         Picture tm(nTotIpi,14)
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",92)
@ pRow()  ,094 pSay "+ FRETE :"
@ pRow()  ,134 pSay nFrete   Picture tm(nFrete,14)
@ pRow()  ,220 pSay "|"

//³ Inicializar campos de Observacoes.                           
@ pRow()+1,001 pSay "| OBSERVACOES "
@ pRow()  ,094 pSay "|"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,1,45) // Altera‡ao feita po Jose Roberto 31/08/2000
if lImprime == .t.
   @ pRow()  ,003 pSay "Nota Fiscal sujeita a confirmacao de quantidades."
Endif
@ pRow()  ,094 pSay "+" +Replicate("-",124)
@ pRow()  ,220 pSay "+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,46,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,094 pSay "| Total Geral : "
nTotGeral:=nTotNota+nTotIpi+nFrete+nDespesa-nDescProd
@ pRow()  ,135 pSay nTotGeral      Picture tm(nTotGeral,14)
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SubStr(_cObsGeral,91,45) // Altera‡ao feita po Jose Roberto 31/08/2000
@ pRow()  ,094 pSay "+-----------------------------------------------+-----------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,094 pSay "|"
@ pRow()  ,102 pSay "         FORNECEDOR       "
@ pRow()  ,142 pSay "|Obs. do Frete:"+IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+------------------------------+------------------------------+------------------------------+"
@ pRow()  ,142 pSay "|"
@ pRow()  ,220 pSay "|"

cLiberador := ""
If SY1->(DbSeek(xFilial("SY1")+SC7->C7_USER))
   _cNomeUser := SubStr(SY1->Y1_NOME,1,20)
Else
   _cNomeUser := "Depto. Compras      "
Endif
		
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Depto. Compras      "
@ pRow()  ,032 pSay "|"
@ pRow()  ,034 pSay "Gerencia"
@ pRow()  ,063 pSay "|"
@ pRow()  ,065 pSay "Diretoria"
@ pRow()  ,094 pSay "|     ----------------------------------"
@ pRow()  ,142 pSay "|"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,032 pSay "|"
@ pRow()  ,063 pSay "|"
@ pRow()  ,094 pSay "|"
@ pRow()  ,142 pSay "|"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+------------------------------+------------------------------+------------------------------+-----------------------------------------------+-----------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|   NOTA: Somente aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "+" + Replicate("-",218) + "+"

/*
@ pRow()+1,001 pSay "|   FORMA DE PAGAMENTO: Credito em Conta Corrente Exclusivamente do Fornecedor"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|   OBS : 1 -> NAO EMITIR BOLETO BANCARIO"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         2 -> TODOS OS PAGAMENTOS SÃO FEITOS SOMENTE NAS QUARTAS E SEXTAS-FEIRAS"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         3 -> A CONDICAO DE PAGAMENTO SERA INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB."
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         4 -> COM A IMPLANTAÇÃO DO SISTEMA DE GESTÃO AMBIENTAL DA WHB, O FORNECEDOR DEVE ATENDER OS REQUISITOS"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|              AMBIENTAIS AO DISPONIBILIZAR PRODUTOS E SERVIÇOS."
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         5 -> EM CASO DE NOTA FISCAL ELETRONICA ENCAMINHAR ARQUIVO XML P/: " +Iif(SM0->M0_CODIGO=="NH","nfe@whbusinagem.com.br","nfe@whbfundicao.com.br")
@ pRow()  ,220 pSay "|"
*/

@ pRow()+1,001 pSay "|   FORMA DE PAGAMENTO: Credito em Conta Corrente Exclusivamente do Fornecedor                                            | A T E N Ç Ã O:                                                                           "
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|   OBS : 1 -> NAO EMITIR BOLETO BANCARIO                                                                                 | A WHB não pratica e tem como  princípio não  estabelecer  relações comerciais de qualquer"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         2 -> TODOS OS PAGAMENTOS SÃO FEITOS SOMENTE NAS QUARTAS E SEXTAS-FEIRAS                                         | natureza com empresas que façam uso de trabalho escravo, exploração de trabalho infantil,"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         3 -> A CONDICAO DE PAGAMENTO SERA INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB.                    | bem como aquisição de material extraído de forma ilegal. A WHB  reserva-se  o  direito de"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         4 -> COM A IMPLANTAÇÃO DO SISTEMA DE GESTÃO AMBIENTAL DA WHB, O FORNECEDOR DEVE ATENDER OS REQUISITOS           | descontinuar qualquer relação comercial diante da constatação dessas práticas, tanto  nas"
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|              AMBIENTAIS AO DISPONIBILIZAR PRODUTOS E SERVIÇOS.                                                          | atividades diretas, quanto na cadeia de suprimentos dos mesmos." 
@ pRow()  ,220 pSay "|"
@ pRow()+1,001 pSay "|         5 -> EM CASO DE NOTA FISCAL ELETRONICA ENCAMINHAR ARQUIVO XML P/: " +Iif(SM0->M0_CODIGO=="NH","nfe@whbusinagem.com.br",Iif(SM0->M0_CODIGO=="FN","nfe@whbfundicao.com.br","nfe@itesa.com.br"))+"                        |" 
@ pRow()  ,220 pSay "|"

//A CONDIÇÃO DE PAGAMENTO SERA  INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB COMPONENTES  AUTOMOTIVOS S/A"
 
@ pRow()+1,001 pSay "+" + Replicate("-",218) + "+"

If SC7->C7_NUM < mv_par02 // .And. SC7->C7_NUM <= mv_par02 
   Eject                    
Endif

Return .T.


//***************************************************************************************************************//
Static Function ImpProd3()
cDesc   := ""
nBegin  := 0
cDescri := ""          

//-- melhorado por joaofr 23/05/2012

If mv_par06==1 //AllTrim(mv_par06)=='B1_DESC' .OR. EMPTY(mv_par06)
	cDescri := Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,'B1_DESC')
Elseif mv_par06==2 ///AllTrim(mv_par06)=="B5_CEME"
	cDescri := Posicione('SB5',1,xFilial('SB5')+SC7->C7_PRODUTO,'B5_CEME')
Elseif mv_par06==3 //AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := SC7->C7_DESCRI
endif

cDescri := alltrim(cDescri) + Iif(!Empty(SC7->C7_OBS)," - "+Alltrim(SC7->C7_OBS),'')

@ pRow()  ,020 pSay "|" + AllTrim(uCodCli)
@ pRow()  ,038 pSay "|" + SubStr(cDescri,1,70)

ImpCampos3()

If len(trim(cDescri))> 70
  For nBegin := 71 To Len(Trim(cDescri)) Step 70
      cDesc:=Substr(cDescri,nBegin,70)
      @ pRow()+1,001 pSay "|                  |"
      @ pRow()  ,038 pSay "|" + Alltrim(cDesc)
      @ pRow()  ,120 pSay "|"
      @ pRow()  ,125 pSay "|"
      @ pRow()  ,139 pSay "|"
      @ pRow()  ,156 pSay "|"
      @ pRow()  ,162 pSay "|"
      @ pRow()  ,179 pSay "|"
      @ pRow()  ,190 pSay "|"
      @ pRow()  ,200 pSay "|"
      @ pRow()  ,211 pSay "|"
      @ pRow()  ,220 pSay "|"
  Next nBegin
Endif
Return nil
//*************************************************************************************************************//
Static Function ImpCampos3()

if mv_par07 != 1 .AND. !Empty(SC7->C7_SEGUM)
   cUnid  := SC7->C7_SEGUM
   nQuant := SC7->C7_QTSEGUM
   nPreco := SC7->C7_TOTAL/SC7->C7_QTSEGUM
else
   cUnid  := SC7->C7_UM
   nQuant := SC7->C7_QUANT
   nPreco := SC7->C7_PRECO
endif

@ pRow()   ,120 pSay "| " + cUnid
@ pRow()   ,125 pSay "|"
@ pRow()   ,127 pSay nQuant          Picture "9999999.9999"
@ pRow()   ,139 pSay ""
@ pRow()   ,141 pSay nPreco          Picture "@E 9,999,999.9999"
@ pRow()   ,156 pSay "|"
@ pRow()   ,157 pSay SC7->C7_IPI     Picture "99"
@ pRow()   ,160 pSay "%"
@ pRow()   ,162 pSay "|"
@ pRow()   ,165 pSay SC7->C7_TOTAL   Picture "@E 99,999,999.99"
@ pRow()   ,179 pSay "|"          

if len(dtoc(SC7->C7_DATPRF)) == 10
	@ pRow()   ,181 pSay substr(dtoc(SC7->C7_DATPRF), 1,6)+substr(dtoc(SC7->C7_DATPRF), 9,2)
else	
   	@ pRow()   ,181 pSay SC7->C7_DATPRF 
endif   

@ pRow()   ,190 pSay "|" + Substr(Alltrim(uRevDes),1,9)
@ pRow()   ,200 pSay "|"

if len(dtoc(uDtaRev)) == 10
	@ pRow()  ,202 pSay substr(dtoc(uDtaRev), 1,6)+substr(dtoc(uDtaRev), 9,2)
else	
   	@ pRow()  ,202 pSay uDtaRev 
endif         

@ pRow()   ,211 pSay "| "+SC7->C7_NUMSC
@ pRow()   ,220 pSay "|"
nTotNota:=nTotNota+SC7->C7_TOTAL

Return