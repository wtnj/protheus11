#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT052  ºAutor  ³Felipe Ciconini     º Data ³  06/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Insumos                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MANUTENÇÃO                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT052()

cString		:= "ZBU"
cDesc1      := "Este relatorio tem como objetivo imprimir"
cDesc2      := ""
cDesc3      := ""
tamanho     := "M"
limite      := 132
aReturn     := {"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog    := "NHMNT052"
nLastKey    := 0
titulo      := "INSUMOS DAS OS DE DISPOSITIVOS"
cabec1      := ""
cabec2      := ""
cCancel     := "****** CANCELADO PELO OPERADOR ******"
_nPag       := 1
M_PAG       := 1
wnrel       := "NHMNT052"
_cPerg      := "MNT052"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac := aDriver[1]

Processa(  {||Gerando()  },"Gerando Dados")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Gerando()

Local aMat     := {}
Local cDesc    := ""
Local nTotHora := 0
Local _nTam	   := 0
Local dDtaIni  
Local dDtaFim
Local nHraIni
Local nHraFim 

	QAA->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	ZBT->(dbSetOrder(1))//ZBT_FILIAL+ZBT_ORDEM
	ZBU->(dbSetORder(1))//ZBU_FILIAL+ZBU_ORDEM
	
	ZBT->(dbGoTop())
	ZBU->(DbGoTop())
	
	Titulo  := OemToAnsi("INSUMOS DAS OS'S DE DISPOSITIVOS DE "+DtoC(mv_par03)+" ATÉ "+DtoC(mv_par04))

	While ZBT->(!Eof())
	
		//Filtra por OS
		If ZBT->ZBT_ORDEM < mv_par01 .OR. ZBT->ZBT_ORDEM > mv_par02
			ZBT->(DbSkip())
			Loop
		EndIf

				
		//Percorrendo todos os insumos da Ordem
		While ZBU->(!EoF()) .OR. ZBU->ZBU_ORDEM==ZBT->ZBT_ORDEM
		    
			dDtaIni := ZBU->ZBU_DATINI
			dDtaFim := ZBU->ZBU_DATFIM
			nHraIni := HoraToInt(ZBU->ZBU_HORINI)
			nHraFim := HoraToInt(ZBU->ZBU_HORFIM)
		
		
			If dDtaIni >= mv_par03
				If dDtaIni < mv_par04
					If dDtaFim > mv_par04
						dDtaFim := mv_par04
						nHraFim := HoraToInt("23:59")
					EndIf
				Else
					ZBU->(DbSkip())
					Loop
				EndIf
			ElseIf dDtaFim > mv_par03
					If dDtaFim <= mv_par04
						dDtaIni := mv_par03
						nHraIni := HoraToInt("00:00")
					Else
						dDtaIni := mv_par03
						dDtaFim := mv_par04
						nHraFim := HoraToInt("23:59")
						nHraIni := HoraToInt("00:00")
					EndIf
				Else
					ZBU->(DbSkip())
					Loop
			EndIf

			cDesc := ""
			If(ZBU->ZBU_TIPO=="P")
				If SB1->(DbSeek(xFilial("SB1")+AllTrim(ZBU->ZBU_CODIGO)))
					cDesc := SB1->B1_DESC
				EndIf
			ElseIf ZBU->ZBU_TIPO=="M"

				If QAA->(DbSeek(xFilial("QAA")+AllTrim(ZBU->ZBU_CODIGO)))
					cDesc := QAA->QAA_NOME
				EndIf
			EndIf
			
			If ZBU->ZBU_CODIGO < mv_par05 .OR. ZBU->ZBU_CODIGO > mv_par06
				ZBU->(DbSkip())
				Loop
			EndIf
			
			aAdd(aMat,{	ZBU->ZBU_ORDEM,;
				       	ZBU->ZBU_CODIGO+" "+cDesc,;
				       	ZBU->ZBU_QUANT,;
				       	dDtaIni,;
				       	dDtaFim,;
				       	nHraIni,;
				       	nHraFim,;
				       	ZBU->ZBU_TIPO	})
				       
			ZBU->(DbSkip())
		EndDo
	ZBT->(DbSkip())
	EndDo
	
	Cabec1 := " Ordem    Codigo          Nome                                    Data Ini      Data Fim    Hora Ini   Hora Fim    Total"
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	
	For x:=1 to Len(aMat)
		If Prow() > 75
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		EndIf
		
		@Prow()+1,001 psay aMat[x][1]
		@Prow()  ,010 psay SubStr(aMat[x][2],1,50) //CODIGO + DESCRICAO
		If aMat[x][8]=="P"
			@Prow()  ,065 psay aMat[x][3] Picture PesqPict("ZBU","ZBU_QUANT")
		ElseIf aMat[x][8]=="M"
			@Prow()  ,065 psay aMat[x][4] //DATA INICIO
			@Prow()  ,079 psay aMat[x][5] //DATA FIM
			@Prow()  ,093 psay IntToHora(aMat[x][6]) //HORA INICIO
			@Prow()  ,104 psay IntToHora(aMat[x][7]) //HORA FIM
			
			nTDif    := 0
			nTDif    := fTDif(aMat[x][4],aMat[x][5],aMat[x][6],aMat[x][7])
			nTotHora += HoraToInt(fTDif(aMat[x][4],aMat[x][5],aMat[x][6],aMat[x][7]))
			@Prow()  ,115 psay nTDif //DIFERENCA DE TEMPO
			
		EndIf
		
	Next
	@Prow()+1,000 psay __PrtThinLine()
	@Prow()+1,001 psay "TOTAL"
	
	_nTam := Len(Alltrim(Str(Int(nTotHora))))
	@Prow()  ,115 psay IntToHora(nTotHora,_nTam)
Return
/*************************************************************
***CALCULANDO†A†DIFERENCA†DE†TEMPO†ENTRE†DUAS†DATAS†E†HORAS***
*************************************************************/

Static Function fTDif(dDtIni,dDtFim,cHrIni,cHrFim)

Local nDias  := dDtFim - dDtIni
Local nHoras := cHrFim - cHrIni + (nDias*24)

Return IntToHora(nHoras)