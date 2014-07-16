/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST043 ³ Autor ³ Alexandre R. Bento     ³ Data ³ 10/02/03³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho no Z7_PRODUTO Preenche automaticamente o codigo    ³±±
±±³          ³ do produto quando digitado 3 caracteres ex.MS02.000 +Produto±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WHB                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SZ7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"        

User Function Nhest043()      

	SB1->(DbSetOrder(1)) 
   aCols[N][1] := StrZero(N,2) //Corrige item quando digitado errado
   aCols[N][4] := 1            //Coloca automaticamente a qtde sempre 1
	IF Len(Alltrim(M->Z7_PRODUTO)) == 3 // so entra qdo digitado 3 caracteres no codigo
	
		IF SB1->(Dbseek(xFilial("SB1")+IiF(SM0->M0_CODIGO == "NH","MS02.000","MS01.000")+M->Z7_PRODUTO ))
		   M->Z7_PRODUTO := SB1->B1_COD 
		   M->Z7_DESC    := SB1->B1_DESC
		   ACOLS[N][3]   := SB1->B1_DESC
		ElseIF SB1->(Dbseek(xFilial("SB1")+IiF(SM0->M0_CODIGO == "NH","MS01.000","MS02.000")+M->Z7_PRODUTO ))
		   M->Z7_PRODUTO := SB1->B1_COD 
		   M->Z7_DESC    := SB1->B1_DESC 
	  	   ACOLS[N][3]   := SB1->B1_DESC  
	   Else
	      M->Z7_PRODUTO := Space(15)
	      MsgBox("Produto Nao Encontrado, Redigite!!","Atencao","ALERT")
		Endif
	
	Else	//Entra aqui qdo o usuario digita o codigo inteiro do produto
		IF SB1->(Dbseek(xFilial("SB1")+M->Z7_PRODUTO ))                                                          
			M->Z7_DESC    := SB1->B1_DESC
		   ACOLS[N][3]   := SB1->B1_DESC
		Else
  	      M->Z7_PRODUTO := Space(15)
	      MsgBox("Produto Nao Encontrado, Redigite!!","Atencao","ALERT")
        Endif
		
	Endif
Return(M->Z7_PRODUTO)
