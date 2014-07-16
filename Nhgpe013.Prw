/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHGPE013        ³ Luciane P. Correia    ³ Data ³ 03.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Dependentes - Funcionarios Ativos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH"

User Function Nhgpe013()


SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("CTAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,CQUERY,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,NUMERO,CULTIMO,_CCC,NTOTFUN,NTOTDEP")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0                                    		
cTamanho  := "M"
limite    := 132
cString   := "SRA"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Relacao de Dependentes por Centro de Custo"
cDesc1    := "O objetivo deste relatorio eh listar os Funcionarios e"
cDesc2    := "seus dependentes."
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE013"
cPerg     := "RHGP27"
lEnd      := .F.
m_pag     := 1
nTotFun   := 0
nTotDep   := 0

If !Pergunte('RHGP27',.T.)
   Return(nil)
Endif   



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Da Filial                                       ³
//³ mv_par02     Ate a Filial                                    ³
//³ mv_par03     Da Matricula                                    ³
//³ mv_par04     Ate a Matricula                                 ³
//³ mv_par05     Do Centro de Custo                              ³
//³ mv_par06     Ate o Centro de Custo                           ³
//³ mv_par07     Plano Inicial                                   ³
//³ mv_par08     Plano Final                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Abertura dos Arquivos
SRA->(DbSetOrder(1)) // Filial + Matricula
SRB->(DbSetOrder(1)) // Filial + Matricula

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE013"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,cTamanho)
If LastKey() == 27 .or. nLastKey == 27
	Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

nPag := 1

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

cabec1 := "MATRICULA        NOME                                       DT NASC.  SEXO    CPF/GRAU         PLANO  C.CUSTO"
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                   1         2         3         4         5         6         7         8         9         0         1         2         3

rptStatus({||Imprime()},"Imprimindo...")

Return


Static Function Gerando()
	/*
	cQuery := "SELECT * "
	cQuery := cQuery + " FROM SRANH0"
	cQuery := cQuery + " WHERE (RA_SITFOLH = 'A' OR RA_SITFOLH = 'F' OR RA_SITFOLH = ' ') AND"
	cQuery := cQuery + " D_E_L_E_T_ <> '*' "
	cQuery := cQuery + " ORDER BY RA_CC,RA_MAT"
   */

	cQuery := "SELECT * "
	cQuery += "  FROM "+	RetSqlName("SE2")
	cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
	cQuery += "   AND D_E_L_E_T_ <> '*' "
	cQuery := "SELECT * "
	cQuery := cQuery + " FROM "+	RetSqlName("SRA") // SRANH0"
	cQuery := cQuery + " WHERE RA_MAT BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' AND"
	cQuery := cQuery + " RA_CC BETWEEN '" + Mv_par05 + "' AND '" + Mv_par06 + "' AND"
	cQuery := cQuery + " (RA_SITFOLH = 'A' OR RA_SITFOLH = 'F' OR RA_SITFOLH = ' ') AND"
	cQuery := cQuery + " RA_ASMEDIC BETWEEN '" + Mv_par07 + "' AND '" + Mv_par08 + "' AND"
	cQuery := cQuery + " D_E_L_E_T_ <> '*' "
	cQuery := cQuery + " ORDER BY RA_MAT"
   
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TEMPSRA"
	TcSetField("TEMPSRA","RA_NASC","D")

	DbSelectArea("TEMPSRA")

Return


Static Function IMPRIME()
Local _cDescc

SI3->(DbSetOrder(1))
DbSelectArea("TEMPSRA")
TEMPSRA->(DbgoTop())

SetRegua(TEMPSRA->(Reccount()))

Numero  := 1
Numero  := Numero+1
cULTIMO := "  "
_cCC    := TEMPSRA->RA_CC

Cabec(Titulo, Cabec1,Cabec2,NomeProg, cTamanho, nTipo)

While TEMPSRA->(!Eof())

   If pRow() > 66
      Cabec(Titulo, Cabec1,Cabec2,NomeProg, cTamanho, nTipo)
   Endif 
   _cDescc := Space(30)	
   SI3->(DbSeek(xFilial("SI3")+TEMPSRA->RA_CC))
   If SI3->(Found())
      _cDescc := SI3->I3_DESC	   
   Endif	   
   @ pRow()+1,4    pSay TEMPSRA->RA_MAT
   @ pRow()  ,17   pSay TEMPSRA->RA_NOME
   @ pRow()  ,60   pSay TEMPSRA->RA_NASC
   @ pRow()  ,71   pSay TEMPSRA->RA_SEXO
   @ pRow()  ,78   pSay TEMPSRA->RA_CIC Picture "@R 999.999.999-99"
   @ pRow()  ,95   pSay TEMPSRA->RA_ASMEDIC
   @ pRow()  ,102  pSay TEMPSRA->RA_CC + " " + _cDescc          
 	nTotFun++

   If SRB->(DbSeek(xFilial("SRB")+TEMPSRA->RA_MAT))
      While SRB->RB_MAT == TEMPSRA->RA_MAT
			If (SRB->RB_ASMEDIC >= mv_par07 .AND. SRB->RB_ASMEDIC <= mv_par08)
		      @ pRow()+1,4   pSay TEMPSRA->RA_MAT
	         @ pRow()  ,17  psay SRB->RB_NOME
	         @ pRow()  ,60  psay SRB->RB_DTNASC
	         @ pRow()  ,71  psay SRB->RB_SEXO

		If SRB->RB_GRAUPAR == "C"
		         @ pRow()  ,78 psay "Conjuge"
	    Elseif SRB->RB_GRAUPAR == "F"
	         	@ pRow()  ,78 psay "Filho"
	    Elseif SRB->RB_GRAUPAR == "E"
	         	@ pRow()  ,78 psay "Enteado"	    
	    Elseif SRB->RB_GRAUPAR == "P"
	         	@ pRow()  ,78 psay "Companheira(o)"	    
	    Elseif SRB->RB_GRAUPAR == "O"
	         	@ pRow()  ,78 psay "Outros"
				Endif
	        	@ pRow()  ,95 pSay SRB->RB_ASMEDIC
	        	nTotDep++
   		Endif
  	      SRB->(DbSkip())
      Enddo
      @ Prow() + 1, 000 Psay Repli("-",132)        
   Else
      @ Prow() + 1, 000 Psay Repli("-",132)        
   Endif      
   IncRegua()
   TEMPSRA->(DbSkip())

EndDo
@ Prow() + 1, 000 Psay "Total:  Funcionarios: "+Transform(nTotFun,"9999")+" Dependentes: "+Transform(nTotDep,"9999")
@ Prow() + 1, 000 Psay Repli("-",132)        
DbCloseArea("TEMPSRA")
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return


Static Function Cabecalho()
	@ prow()+1,00 Psay &cCompac+Repli("*",129)
	@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
	@ prow(),112 Psay "Folha : "
	@ prow(),124 Psay StrZero(nPag,5,0)+"  *"
	@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
	@ prow(),20 Psay PadC(titulo,82)
	@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
	@ prow()+1,00 Psay "*Hora...: "+Time()
	@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"  *"
	@ prow()+1,00 Psay Repli("*",132)
	@ prow()+1,00 Psay " "
	@ prow()+1,00 Psay cabec1 
	@ prow()+1,00 Psay cabec2 
	@ prow()+1,00 Psay "*** Centro de Custo: " + TEMPSRA->RA_CC + " ***"
Return

