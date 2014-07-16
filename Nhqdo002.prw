/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³NhQdo002  ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 14.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±  
±±³Descricao ³Cadastro do Anexo do Arquivo ao Documento.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Controle de Documento.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
#include "rwmake.ch"  

User Function NhQdo002()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Anexo do Documento'

aRotina := {{ "Pesquisar"    ,"AxPesqui",0,1},;
            { "Visualizar"   ,"AxVisual",0,2},;
            { "Mostra Anexo" ,'ExecBlock("NHQDO004",.F.,.F.,0)',0,2},;
            { "Anexar"       ,'ExecBlock("NHQDO003",.F.,.F.,0)',0,2},;
            { "Legenda"      ,"U_Q002Legenda",0,2}}

DbSelectArea("QDH")
QDH->(DbSetOrder(1))

If QDH->(FieldPos("QDH_FUTURA")) > 0
 	cFiltro := 'QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" .And. QDH_FUTURA <> "G") .or. (QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'
Else
 	cFiltro := 'QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'
Endif
Set Filter to &cFiltro

QDH->(DbGoTop())
            


mBrowse(,,,,"QDH",,"Alltrim(QDH->QDH_ANEXO)==''")

Set Filter to

Return(nil)    


User Function Q002Legenda()

 BrwLegenda("Documentos","Anexo",{{"ENABLE", "Com Anexo"},{"DISABLE","Sem Anexo "}})

Return


