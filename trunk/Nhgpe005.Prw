/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE005  ºAutor  ³Microsiga           º Data ³  03/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de Entregas de Documentos                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe005()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,")


cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Controle de Requerimento de Documento para Arquivo"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP18"
cPerg    := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGP05"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| RHG018()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG018)})  //-- Chamada do Relatorio.

Return Nil

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG018
Static Function RHG018()

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   IncRegua()
   @ 1, 22 pSay "* * "+ Alltrim(SM0->M0_NOMECOM) + " * *"
   @ pRow()+2, 18 pSay "CONTROLE DE REQUERIMENTO DE DOCUMENTOS PARA ARQUIVO"
   @ pRow()+3, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "NOME : "+SRA->RA_NOME + " REGISTRO : "+SRA->RA_MAT
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+2, 01 pSay "DOCUMENTOS NECESSARIOS P/ ADMISSAO : " 
   @ pRow()+2, 01 pSay "CURRICULUM / SOLICITACAO DE EMPREGO          (           )"
   @ pRow()+1, 01 pSay "CARTEIRA DE TRABALHO                         (           )"
   @ pRow()+1, 01 pSay "EXAME MEDICO OCUPACIONAL                     (           )"
   @ pRow()+1, 01 pSay "CEDULA DE IDENTIDADE                         (           )"
   @ pRow()+1, 01 pSay "DOCUMENTO MILITAR                            (           )"
   @ pRow()+1, 01 pSay "TITULO DE ELEITOR                            (           )"
   @ pRow()+1, 01 pSay "CARTEIRA DE HABILITACAO                      (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE PIS / PASEP                      (           )"
   @ pRow()+1, 01 pSay "C.P.F.                                       (           )"
   @ pRow()+1, 01 pSay "DOC. DE INSCRICAO ORGAO E CLASSE             (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE NASCIMENTO                       (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE CASAMENTO                        (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE NASCIMENTO FILHOS MENORES 7 ANOS (           )"
   @ pRow()+1, 01 pSay "FOTOGRAFIA 3 X 4                             (           )"
   @ pRow()+1, 01 pSay "RECOLHIMENTO SINDICAL                        (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE DE RESIDENCIA                    (           )"
   @ pRow()+1, 01 pSay "ANTECEDENTES CRIMINAIS                       (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE DE ESCOLARIDADE 2o,3o GRAU       (           )"
   @ pRow()+1, 01 pSay "CURSOS COMPLEMENTARES                        (           )"
   @ pRow()+3, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "COMPROVANTE ENTREGA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL PARA ANOTACOES"
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "NOME : "+SRA->RA_NOME + " REGISTRO : "+SRA->RA_MAT
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "CTPS / SERIE : "+SRA->RA_NUMCP + " / " + SRA->RA_SERCP
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+2, 01 pSay "Recebemos a CTPS acima, para anotacoes necessarias que sera devolvida dentro"
   @ pRow()+1, 01 pSay "de 48 hs. de acordo com a Lei em vigor :" 
   @ pRow()+3, 01 pSay "Data : " + dtoc(SRA->RA_ADMISSA)
   @ pRow()+3, 01 pSay "__________________________________           __________________________________"
   
   SRA->(DbSkip())
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()
Return
