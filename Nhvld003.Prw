/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHVLD003 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 23/04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Traz a Descricao do Centro de Custo no Cad. EPI            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Execblock usado do programa NHEST023                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SZ7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"  

User Function Nhvld003()

SetPrvt("_LRET,_CDESCRCC,")

_lRet := .f.
ZRG->(DbSetOrder(1))
CTT->(DbSetOrder(1))
CTT->(DbSeek(xFilial("CTT")+_CCC))

If CTT->(Found())

   _lRet := .t.    	
	If Empty(_CCC) .Or. Len(Alltrim(_CCC)) < Iif(SM0->M0_CODIGO=="FN",8,6)
	   MSGBOX("O CENTRO DE CUSTO é Obrigatorio e Com "+STRZERO(Iif(SM0->M0_CODIGO=="FN",8,6),1)+" Digitos, REDIGITE Novamente para Contabilizar Corretamente!!!!!!!!","Atencao Centro de Custo","STOP")
	   _CCC := Space(09) //limpa campo de centro de custo     
	   _lRet := .f.
	Endif

	If Alltrim(CTT->CTT_BLOQ) == "1" // Inativo
	   MsgBox("ATENCAO: CENTRO DE CUSTO BLOQUEADO, USAR  CENTRO DE CUSTO VALIDO !!!!!!!!")
	   _CCC := Space(09) //limpa campo de centro de custo     
	   _lRet := .f.
	Endif

   _cDescrCC := CTT->CTT_DESC01

	ZRG->(DbSeek(xFilial("ZRG")+_cMatr))
	If ZRG->(Found())
	   If Alltrim(_CCC) <> Alltrim(ZRG->ZRG_CC)
	      MsgBox("ATENCAO: Centro de Custo "+ Alltrim(_CCC) +" é Diferente do Centro de Custo " +Alltrim(ZRG->ZRG_CC)+" Do Cadastro do funcionario !!!!!!!!")
		  _CCC := Space(09) //limpa campo de centro de custo     
		  _lRet := .f.
	   Endif   
	Else
	    QAA->(DbSeek(xFilial("QAA")+ _cMatr))
		If QAA->(Found())
		    If Alltrim(_CCC) <> Alltrim(QAA->QAA_CC)
		       MsgBox("ATENCAO: Centro de Custo "+ Alltrim(_CCC) +" é Diferente do Centro de Custo " +Alltrim(QAA->QAA_CC)+" Do Cadastro do funcionario !!!!!!!!")
			   _CCC := Space(09) //limpa campo de centro de custo     
			   _lRet := .f.
		    Endif   
		Endif             
    Endif		

ElseIF !EMPTY(_CCC)
   MSGBOX("O CENTRO DE CUSTO Nao Cadastrado Verifique !","Atencao Centro de Custo","STOP")
   _CCC := Space(09) //limpa campo de centro de custo     
   _lRet := .f.
Endif

Return(_lRet)  
