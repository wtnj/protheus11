/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE105  ºAutor  ³Marcos R Roquitski  º Data ³  14/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcionarios X Vale meracado.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe105()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Funcionarios X Vale mercado"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE105"
cPerg     := "GPE105"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 
aOrdem    := { 'Matricula','Cetrio de Custo','Nome' }


If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE105"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrdem,,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->RA_MAT)
   MsgBox("Nenhum Ocorrencia ","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()
Local nOrdem		:= aReturn[8]
Local _cZemp 

	cQuery  := " SELECT * FROM " + RetSqlName( 'SRA' ) + " RA "
    cQuery  += " WHERE RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
    cQuery  += " AND RA.RA_CC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    cQuery  += " AND RA.RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
    cQuery  += " AND RA.RA_SITFOLH <> 'D' "
    cQuery  += " AND RA.RA_CATFUNC IN ('H','M') "
    cQuery  += " AND RA.RA_CODFUNC <> '0193' "
    cQuery  += " AND RA.D_E_L_E_T_ = ' ' "

	/*
	_cZemp := StrZero(mv_par05,1)
	If Mv_par05 == 1 // Usinagem
	    cQuery  += "AND RA.RA_ZEMP = '" + _cZemp + "' "
	Endif
	If Mv_par05 == 2 // Fundicao 
	    cQuery  += "AND RA.RA_ZEMP = '" + _cZemp + "' "
	Endif
    */
    
	_cZemp := mv_par05

	If Mv_par05 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

		If Mv_par05 == '3'
			cQuery  += " AND RA.RA_CODFUNC <> '1193' "
		Endif
 
		If Mv_par05 == '2'
			cQuery  += " AND RA.RA_CODFUNC <> '0321' "
		Endif

	Elseif Mv_par05 == '7'
	    cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "
		cQuery  += " AND RA.RA_CODFUNC <> '0321' "
	Endif

	If nOrdem == 1 // Codigo
	    cQuery  += "ORDER BY RA.RA_MAT "
			
	Elseif nOrdem == 2 // Centro de Custo
	    cQuery  += "ORDER BY RA.RA_CC "

	Elseif nOrdem == 3 // Nome              
	    cQuery  += "ORDER BY RA.RA_NOME "

	Endif

	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.
	DbSelectArea("TMP")

Return

Static Function Imprime()
Local lRet := .t.
Local _nSalario := _nAfas := _nAdmi := _nRece := _nAbes := _nFaltas := _nRecno := _nExperi := 0
Local _dDtExp, _cMat
Local _lAfas := .F.

If SM0->M0_CODIGO = 'NH' // Usinagem
	_cMat := '004157'
Elseif SM0->M0_CODIGO = 'FN' // Fundicao
	_cMat := '001725'
Endif
TMP->(Dbgotop())
Cabec1 := "Mat.      Nome                            CPF            C.Custo                                   Funcao                     Admissao       Salario    Restricao"
SRB->(DbSetOrder(1))                        
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While !TMP->(eof())

	If TMP->RA_CATFUNC = 'H'
		_nSalario := (TMP->RA_SALARIO * TMP->RA_HRSMES)	   
	Else
		_nSalario := TMP->RA_SALARIO
	Endif
   
	If _nSalario <= 4000.00

		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		@ Prow() + 1, 000 Psay TMP->RA_MAT 
		@ Prow()    , 010 Psay TMP->RA_NOME

		@ Prow()    , 042 Psay TMP->RA_CIC Picture "@R XXX.XXX.XXX-XX"


		@ Prow()    , 057 Psay TMP->RA_CC  

		CTT->(Dbseek(xFilial("CTT")+TMP->RA_CC))
		If CTT->(Found())
			@ Prow(), 067 Psay Substr(CTT->CTT_DESC01,1,30)
		Endif

		@ Prow()    , 100 Psay TMP->RA_CODFUNC
		SRJ->(Dbseek(xFilial("SRJ")+TMP->RA_CODFUNC))
		If SRJ->(Found())
			@ Prow(), 105 Psay SRJ->RJ_DESC	
		Endif
		@ Prow()    , 127 Psay TMP->RA_ADMISSA
	
		If TMP->RA_CATFUNC = 'H'
			_nSalario := (TMP->RA_SALARIO * TMP->RA_HRSMES)
		Else
			_nSalario := TMP->RA_SALARIO	  
		Endif
		@ Prow()    , 140 Psay _nSalario Picture "@E 999,999.99"



		If Alltrim(TMP->RA_SITFOLH) == 'A'

			If SR8->(DbSeek(xFilial("SR8")+SRA->RA_MAT))
				While !SR8->(Eof()) .and. SR8->R8_MAT == SRA->RA_MAT .and. SR8->R8_FILIAL == SRA->RA_FILIAL
							
					If SR8->R8_TIPO == 'Q' // Maternidade 
						@ Prow()    , 155 Psay 'Maternidade'
						_lAfas := .T.
						Exit
					Endif						

					If SR8->R8_TIPO $ 'O/P' 
						// Saida de Afastamento 
															
						If (SR8->R8_DATAINI + 365) >= dDataBase
							If SR8->R8_DATAFIM == Ctod(Space(08)) 
								@ Prow()    , 155 Psay 'Doenca Rel. Trab.'							
								_lAfas := .T.
								Exit 
							Endif 
						Endif 
					Endif 
					SR8->(DbSkip()) 

				Enddo
    		
    		Endif

			If !(_lAfas)
				@ Prow()    , 155 Psay 'Afastado'
				_nAfas++				
				_lAfas := .F.
			Endif	


		Else


	  		If Val(Dtos(TMP->RA_ADMISSA + 90)) > Val(Substr(Dtos(dDataBase),1,6)+"15")

				//_dDtExp := DATE() - 90
				//If TMP->RA_ADMISSA > _dDtExp  .AND. TMP->RA_MAT > _cMat
			
				@ Prow()    , 155 Psay 'Experiencia'
				_nExperi++

			Else			


				If Val(Dtos(TMP->RA_ADMISSA)) >= Val(Substr(Dtos(dDataBase),1,6)+"15") //.AND. TMP->RA_MAT > _cMat
					@ Prow()    , 155 Psay 'Admissao maior que 15o. Dia'
					_nAdmi++
				Else			

					_nFaltas := 0
					_nRecno  := SRC->(Recno())
					SRC->(DbSeek(xFilial("SRC")+TMP->RA_MAT))
					While !SRC->(Eof()) .and. SRC->RC_MAT == TMP->RA_MAT
						If SRC->RC_PD == "425" .or. SRC->RC_PD == "427" .or. SRC->RC_PD == "428"
							_nFaltas+=SRC->RC_HORAS
						Endif	
						SRC->(DbSkip())			
					Enddo
					SRC->(Dbgoto(_nRecno))
			
					If _nFaltas <= 0.15
						@ Prow()    , 155 Psay ''
						_nRece++
					Else
						@ Prow()    , 155 Psay 'Faltas no mes'
						_nAbes++
					Endif

				Endif	

			Endif

		Endif

	Endif			
	TMP->(Dbskip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,001 Psay 'Recebe vale mercado........:'+Transform(_nRece,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,001 Psay 'Nao recebe (afastado)......:'+Transform(_nAfas,"99999")
@ Prow() + 1,001 Psay 'Nao recebe (Maior 15o. Dia):'+Transform(_nAdmi,"99999")
@ Prow() + 1,001 Psay 'Nao recebe (Faltas no Mes).:'+Transform(_nAbes,"99999")
@ Prow() + 1,001 Psay 'Em experiencia.............:'+Transform(_nExperi,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()

Return
			