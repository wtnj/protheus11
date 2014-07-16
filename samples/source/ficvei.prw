/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FICVEI   ³ Autor ³  Manoel               ³ Data ³ 19/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Ficha do Veiculo no modo Grafico                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico  - (Veiculos)                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
USER FUNCTION FICVEI()

SetPrvt("aDriver,cTitulo,cNomProg,Limite,cCabec1,cCabec2,cNomeImp,lServer,cTamanho,m_Pag,nLin,cAlias,aReturn,cNumPed")

//cNumPed := ParamIxb[1]
cTamanho := "M"           // P/M/G
nCaracter:= 15            // 20 - Normal     -   15 - Compactado
Limite   := 132            // 80/132/220
aOrdem   := {}           // Ordem do Relatorio
cTitulo  := "Ficha do Veiculo"
nLastKey := 0
aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
cNomProg := "FICVEI"
cNomeRel := "FICVEI"
aDriver  := LeDriver()
cCompac  := aDriver[1]
cNormal  := aDriver[2]
cDrive   := "Epson.drv"
cNomeImp := "LPT1"
cAlias   := "VV1"
cCabec1  := ""
cCabec2  := "" 
lHabil   := .f.
Inclui   := .f.
m_Pag    := 1

/*
[1] Reservado para Formulario
[2] Reservado para nro de Vias
[3] Destinatario
[4] Formato => 1-Comprimido 2-Normal
[5] Midia   => 1-Disco 2-Impressora
[6] Porta ou Arquivo 1-LPT1... 4-COM1...
[7] Expressao do Filtro
[8] Ordem a ser selecionada
[9]..[10]..[n] Campos a Processar (se houver)
*/

cNomeRel := SetPrint(cAlias,cNomeRel,nil ,@cTitulo,"","","",.F.,"",.F.,cTamanho,nil    ,nil    ,nil)
SetDefault(aReturn,cAlias)

If nLastKey == 27
	Set Filter To
	Return
Endif

Set Printer to &cNomeRel
Set Printer On
Set Device  to Printer

FG_SEEK("VVA","VV0->VV0_NUMTRA",1,.f.)
FG_SEEK("VV1","VVA->VVA_CHAINT",1,.f.)
FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
FG_SEEK("VVF","VV1->VV1_TRACPA",1,.f.)
FG_SEEK("VVG","VV1->VV1_TRACPA",1,.f.)
FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
FG_SEEK("SA1","VV0->VV0_CODCLI+VV0->VV0_LOJA",1,.f.)
FG_SEEK("SA2","VVF->VVF_CODFOR+VVF->VVF_LOJA",1,.f.)
FG_SEEK("SA3","VV0->VV0_CODVEN",1,.f.)
FG_SEEK("VE1","VV1->VV1_CODMAR",1,.f.)
FG_SEEK("VVH","VVG->VVG_CODIND",1,.f.)

nLin      := cabec(ctitulo,cCabec1,cCabec2,cNomProg,cTamanho,nCaracter) + 1
cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
cCGCCPFc  := cCGCCPF1 + space(18-len(cCGCCPF1))
cCGCCPF2  := subs(transform(SA2->A2_CGC,PicPes(SA2->A2_TIPO)),1,at("%",transform(SA2->A2_CGC,PicPes(SA2->A2_TIPO)))-1)
cCGCCPFf  := cCGCCPF2 + space(18-len(cCGCCPF2))

nLin := nLin + 2
@ nLin,00 psay repl("-",132)
nLin++
@ nLin,00 psay "Dados do Veiculo"
if aReturn[5] = 3
   @ nLin,01 psay "Dados do Veiculo"
Endif
nLin := nLin + 2
@ nLin,00 psay "Chassi     " + VVA->VVA_CHASSI             + Space(25) + "Marca    " + VE1->VE1_DESMAR + Space(2) + "Modelo     " + VV2->VV2_DESMOD
nLin++
@ nLin,00 psay "Cor        " + Subs(VVC->VVC_DESCRI,1,14) + Space(36) + "Ano/Mod  " + Subs(VV1->VV1_FABMOD,1,4) + "/" + Subs(VV1->VV1_FABMOD,5,4) + Space(23) + "Indexador  " + VVG->VVG_CODIND + " - " + VVH->VVH_DESCRI
nLin++
@ nLin,00 psay repl("-",132)
nLin++
@ nLin,00 psay "Dados da Entrada"
if aReturn[5] = 3
   @ nLin,01 psay "Dados da Entrada"
Endif
nLin := nLin + 2                   
@ nLin,00 psay "Data       " + dToc(VVF->VVF_DATMOV)      + Space(42) + "NF/Serie " + VVF->VVF_NUMNFI + "/" + VVF->VVF_SERNFI
nLin++
@ nLin,00 psay "Fornecedor " + SA2->A2_NOME                + Space(10) + "CGC/CPF  " + cCGCCPFf        + Space(14) + "Cidade  " + SA2->A2_MUN + " - " + SA2->A2_EST
nLin++
@ nLin,00 psay "Valor      " + transform(VVF->VVF_VALMOV,"@E 999,999,999.99")
nLin++
@ nLin,00 psay repl("-",132)
nLin++
@ nLin,00 psay "Dados da Saida"
if aReturn[5] = 3
   @ nLin,01 psay "Dados da Saida"
Endif
nLin := nLin + 2
@ nLin,00 psay "Data       " + dToc(VV0->VV0_DATMOV)      + Space(42) + "NF/Serie " + VV0->VV0_NUMNFI + "/" + VV0->VV0_SERNFI
nLin++
@ nLin,00 psay "Cliente    " + SA1->A1_NOME                + Space(10) + "CGC/CPF  " + cCGCCPFc        + Space(14) + "Cidade  " + SA1->A1_MUN + " - " + SA1->A1_EST
nLin++
@ nLin,00 psay "Valor      " + transform(VV0->VV0_VALMOV,"@E 999,999,999.99") + Space(36)  + "Vendedor " + VV0->VV0_CODVEN + " - " + Subs(SA3->A3_NOME,1,30) 
nLin := nLin + 3
@ nLin,00 psay repl("-",132)
nLin++
@nLin,00 psay "| Titulo da Conta                       Valores em R$        %           Valores em MF        %          Valor Presente       %    |"
nLin++
@ nLin,00 psay repl("-",132)
nLin := nLin + 1
@ nLin,00 psay "|"
nLin := nLin + 1
For vv = 1 to len(aStru)
    @ nLin++,00 psay "| " + If(Left(aStru[vv,05],7)==Space(7),Space(3)+Ltrim(aStru[vv,05]),aStru[vv,05]+Space(3)) + Space(6) + transform(aStru[vv,09],"@E 9,999,999.99")+Space(6)+transform(aStru[vv,10],"@E 999.99")+Space(9)+transform(aStru[vv,12],"@E 9,999,999.99")+;
               Space(6)+transform(aStru[vv,13],"@E 999.99")+Space(9)+transform(aStru[vv,20],"@E 9,999,999.99")+Space(5)+transform(aStru[vv,21],"@E 999.99") + " |"
Next

Ms_Flush()              
  
Set Printer to
Set Device  to Screen

if aReturn[5] == 1
   OurSpool(cNomeRel)
Endif  

Return
