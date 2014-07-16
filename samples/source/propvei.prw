/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PROPVEI  ³ Autor ³  Manoel               ³ Data ³ 29/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Copia da Proposta de Venda de Veiculos                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico  - (Veiculos)                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
USER FUNCTION PROPVEI()

SetPrvt("aDriver,cTitulo,cNomProg,Limite,cCabec1,cCabec2,cNomeImp,lServer,cTamanho,m_Pag,nLin,cAlias,aReturn,cNumPed")
SetPrvt("aErrAva,cCodMap,bCampo,cCpoDiv,aStru")
                                             
aStru    := {}
cCpoDiv  := "    1"
bCampo   := { |nCPO| Field(nCPO) }
cCodMap  := "001"
aErrAva  := {}
cNumPed  := ParamIxb[1]
cTamanho := "M"           // P/M/G
nCaracter:= 15            // 20 - Normal     -   15 - Compactado
Limite   := 132            // 80/132/220
aOrdem   := {}           // Ordem do Relatorio
cTitulo  := "Proposta/Pedido de Venda de Veiculos"
nLastKey := 0
aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
cNomProg := "PROPVEI"
cNomeRel := "PROPVEI"
aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
cDrive   := "Epson.drv"
cNomeImp := "LPT1"
cAlias   := "VV1"
cCabec1  := ""
cCabec2  := "" 
lHabil   := .f.
Inclui   := .f.
m_Pag    := 1
cRodape  := GetMv("MV_MSGPROP")
cRodape1 := Alltrim(Subs(cRodape,001,070))
cRodape2 := Alltrim(Subs(cRodape,071,070))
cRodape3 := Alltrim(Subs(cRodape,141,070))
cRodape4 := Alltrim(Subs(cRodape,211,070))
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
If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cAlias)


Set Printer to &cNomeRel
Set Printer On
Set Device  to Printer

FG_SEEK("VVA","VV0->VV0_NUMTRA",1,.f.)
FG_SEEK("VV1","VVA->VVA_CHAINT",1,.f.)
FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
FG_SEEK("SA1","VV0->VV0_CODCLI+VV0->VV0_LOJA",1,.f.)
FG_SEEK("SA3","VV0->VV0_CODVEN",1,.f.)
FG_SEEK("VVT","VV0->VV0_NUMTRA",2,.f.)
FG_SEEK("VE1","VV1->VV1_CODMAR",1,.f.)

DbSelectArea("VV0")
For nCntFor := 1 TO FCount()
    M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

DbSelectArea("VVA")
DbSeek(xFilial("VVA")+M->VV0_NUMTRA)
For nCntFor := 1 TO FCount()
    M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

nLin      := cabec(ctitulo,cCabec1,cCabec2,cNomProg,cTamanho,nCaracter) + 1
cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
cCGCCPF   := cCGCCPF1 + space(18-len(cCGCCPF1))

nLin++
@ nLin,00 psay "P r o p o s t a   d e   V e n d a  /  P E D I D O"
if aReturn[5] = 3
   @ nLin,01 psay "P r o p o s t a   d e   V e n d a  /  P E D I D O"
Endif
nLin++
@ nLin,00 psay repl("-",79)
nLin := nLin + 2
@ nLin,00 psay "Data      " + dToc(VV0->VV0_DATMOV)   + Space(34) + "Pedido " + VV0->VV0_NUMPED
if aReturn[5] = 3
   @ nLin,01 psay "Data      " + dToc(VV0->VV0_DATMOV)   + Space(34) + "Pedido " + VV0->VV0_NUMPED
Endif   
nLin++
@ nLin,00 psay "Cliente   " + SA1->A1_NOME
nLin++
@ nLin,00 psay "CGC/CPF   " + cCGCCPF + Space(24) +"Cidade " + SA1->A1_MUN + " - " + SA1->A1_EST
nLin++
@ nLin,00 psay "Chassi    " + VVA->VVA_CHASSI          + Space(16) + " Marca  " + VE1->VE1_DESMAR
nLin++
@ nLin,00 psay "Modelo    " + VV2->VV2_DESMOD          + Space(11) + " Cor    " + Subs(VVC->VVC_DESCRI,1,14)
nLin++
@ nLin,00 psay "Ano/Mod   " + Subs(VV1->VV1_FABMOD,1,4) + "/" + Subs(VV1->VV1_FABMOD,5,4)
nLin++
@ nLin,00 psay "Vendedor  " + Subs(SA3->A3_NOME,1,24) + " - " + VV0->VV0_CODVEN + Space(09) + "Valor  " + transform(VV0->VV0_VALMOV,"@E 999,999,999.99")
nLin := nLin + 2
@ nLin,00 psay repl("-",79)
nLin := nLin + 2
@ nLin,00 psay "Acessorios"
if aReturn[5] = 3
   @ nLin,01 psay "Acessorios"
Endif   
nLin := nLin + 2
@ nLin,00 psay "Grupo Codigo do Acessorio         Descricao do Acessorio                  Valor"
nLin++
nTotAce := 0          
DbSelectArea("VVT")
while VVT->VVT_FILIAL == xFilial("VVT") .and. VVT->VVT_NUMTRA == VV0->VV0_NUMTRA .and. !eof()
       if nLin > 53
		    nLin     := cabec(ctitulo,cCabec1,cCabec2,cnomprog,ctamanho,nCaracter) + 1
			 nLin := nLin + 2
			 @ nLin,00 psay "Acessorios"
			 if aReturn[5] = 3
			    @ nLin,01 psay "Acessorios"
			 Endif   
			 nLin := nLin + 2
			 @ nLin,00 psay "Grupo Codigo do Acessorio         Descricao do Acessorio                  Valor"
			 nLin++
		 Endif
		 FG_SEEK("SB1","VVT->VVT_GRUITE+VVT->VVT_CODITE",7,.f.)
		 @ nLin++,00 psay VVT->VVT_GRUITE + "  " +  VVT->VVT_CODITE + " " + SB1->B1_DESC + "  " +  transform(VVT->VVT_VALEQP,"@E 99,999,999.99")
		 nTotAce := nTotAce + VVT->VVT_VALEQP
		 DbSelectArea("VVT")
		 dbSkip()
Enddo

nLin++
@ nLin,42 psay "Total de Acessorios     " + transform(nTotAce,"@E 99,999,999.99")
if aReturn[5] = 3
   @ nLin,43 psay "Total de Acessorios     " + transform(nTotAce,"@E 99,999,999.99")
Endif   
nLin := nLin + 2
@ nLin,00 psay repl("-",79)
nLin := nLin + 2
@ nLin,00 psay "Forma de Pagamento"
if aReturn[5] = 3
	@ nLin,01 psay "Forma de Pagamento"
Endif
nLin := nLin + 2
@ nLin,00 psay "Tipo de Pagamento    Nro Documento      Data           Valor"
nLin := nLin + 2
DbSelectArea("VS9")
FG_SEEK("VS9","VV0->VV0_NUMTRA+'V'",1,.f.)
while !eof() .and. VS9->VS9_NUMIDE+VS9->VS9_TIPOPE == VV0->VV0_NUMTRA+"V"
	FG_SEEK("SX5","'05'+VS9->VS9_TIPPAG",1,.f.)
   if nLin > 53
      nLin := cabec(ctitulo,cCabec1,cCabec2,cnomprog,ctamanho,nCaracter) + 1
		nLin := nLin + 2
      @ nLin,00 psay "Forma de Pagamento"
	   if aReturn[5] = 3
	      @ nLin,01 psay "Forma de Pagamento"
      Endif   
	   nLin := nLin + 2
	   @ nLin,00 psay "Tipo de Pagamento    Nro Documento      Data           Valor"
	   nLin := nLin + 2
	Endif                                             
	if VS9->VS9_TIPPAG == Space(2)
	   @ nLin,00 psay "Pagamento a vista" + Space(21) + dToc(VS9->VS9_DATPAG) + " " + transform(VV0->VV0_VALMOV,"@E 999,999,999.99")
   Else   
      @ nLin,00 psay VS9->VS9_TIPPAG + "-" + subs(SX5->X5_DESCRI,1,13) + Space(5) + VS9->VS9_REFPAG + Space(2) + dToc(VS9->VS9_DATPAG) + " " + transform(VS9->VS9_VALPAG,"@E 99,999,999.99")
   Endif   
   nLin++
   @ nLin,00 psay E_MSMM(VS9->VS9_OBSMEM,80)
		DbSelectArea("VS9")
		dbSkip()
		nLin++
Enddo         
						
@ 53,15 psay "-------------------               --------------------"
@ 54,19 psay "COMPRADOR                        DEPTO DE VENDAS"
@ 56,00 psay padc(cRodape1,80)
@ 57,00 psay padc(cRodape2,80)
@ 58,00 psay padc(cRodape3,80)
@ 59,00 psay padc(cRodape4,80)

//Avaliacao da Venda
FG_CalcVlrs(FS_VDRVM050(VV0->VV0_TIPFAT,cCodMap))

nLin := 1
@nLin,00 psay "| Titulo da Conta                       Valores em R$        %           Valores em MF        %          Valor Presente       %    |"
nLin++
@ nLin,00 psay repl("-",132)
nLin := nLin + 1
@ nLin,00 psay "|"
nLin := nLin + 1
For vv = 1 to len(aStru)
    @ nLin,00 psay "| " + If(Left(aStru[vv,05],7)==Space(7),Space(3)+Ltrim(aStru[vv,05]),aStru[vv,05]+Space(3)) + Space(6) + transform(aStru[vv,09],"@E 9,999,999.99")+Space(6)+transform(aStru[vv,10],"@E 999.99")+Space(9)+transform(aStru[vv,12],"@E 9,999,999.99")+;
               Space(6)+transform(aStru[vv,13],"@E 999.99")+Space(9)+transform(aStru[vv,20],"@E 9,999,999.99")+Space(5)+transform(aStru[vv,21],"@E 999.99") + " |"
Next

Ms_Flush()              
  
Set Printer to
Set Device  to Screen

if aReturn[5] == 1
   OurSpool(cNomeRel)
Endif  

Return
