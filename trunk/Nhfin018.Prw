/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFIN018 ³ Autor ³ Jose Roberto Gorski   ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao dos dados da Folha para os dados do Colaborador ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para New Hubner                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SZ5,SRA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"       

User Function Nhfin018()   

Processa( {|| Executa() } )

Return

//
Static Function Executa()

If !MsgBox ("Tem certeza que deseja importar os dados da folha","Escolha","YESNO")
   Return
Endif

SRA->(DbSetOrder(1)) // Filial + Matricula
SZ5->(DbSetOrder(1)) // Filial + Matricula

ProcRegua(SRA->(RecCount()))              
SRA->(DbGoTop())

While SRA->(!Eof())
      
      // Se nao encontar funcionario atualizar arquivo
      If !SZ5->(DbSeek(xFilial("SZ5")+SRA->RA_MAT))
         RecLock("SZ5",.t.)
           SZ5->Z5_FILIAL  := xFilial("SZ5")
           SZ5->Z5_MAT     := SRA->RA_MAT
           SZ5->Z5_CC      := SRA->RA_CC
           SZ5->Z5_NOME    := SRA->RA_NOME
           SZ5->Z5_BANCO   := SubStr(SRA->RA_BCDEPSA,1,3)
           SZ5->Z5_AGENCIA := SubStr(SRA->RA_BCDEPSA,4,5)
           SZ5->Z5_CONTA   := SRA->RA_CTDEPSA
	       SZ5->Z5_CPF     := SRA->RA_CIC
         MsUnLock("SZ5")
      Else
         RecLock("SZ5",.F.)
         SZ5->Z5_CPF  := SRA->RA_CIC
         SZ5->Z5_BANCO   := SubStr(SRA->RA_BCDEPSA,1,3)
         SZ5->Z5_AGENCIA := SubStr(SRA->RA_BCDEPSA,4,5)
         SZ5->Z5_CC      := SRA->RA_CC
         SZ5->Z5_NOME    := SRA->RA_NOME
         SZ5->Z5_CONTA   := SRA->RA_CTDEPSA
         MsUnLock("SZ5")
      Endif

      IncProc("Atualizando Colaborador: " + SRA->RA_NOME)
      SRA->(DbSkip())
EndDo
Return
