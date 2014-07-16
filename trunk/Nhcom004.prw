/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Nhcom004  ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 14.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±  
±±³Descricao ³Browse do cadastro de produtos, para anexar imagens.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico New Hubner.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
#include "rwmake.ch"  

User Function Nhcom004()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Desenhos do Produto'

aRotina := {{ "Pesquisar"    ,"AxPesqui",0,1},;
            { "Anexar"       ,'ExecBlock("NHCOM005",.F.,.F.,0)',0,2},;
            { "Mostra Anexo" ,'ExecBlock("NHCOM006",.F.,.F.,0)',0,2},;
            { "Altera" 		 ,"AxAltera",0,4},;
            { "Legenda"      ,"U_C002Legenda",0,2}}

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
DbGoTop()
            
mBrowse(,,,,"SB1",,"Alltrim(SB1->B1_ANEXO)==''")

Return(nil)    


User Function C002Legenda()

 BrwLegenda("Desenhos","Status",{{"ENABLE", "Com Anexo"},{"DISABLE","Sem Anexo "}})

Return
