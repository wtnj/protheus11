/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NFPECSER ³ Autor ³ Andr‚                 ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rdmake Emissao da Nota Fiscal de Pecas e Servicos - AUDI   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function NFPECSER()

SetPrvt("wnrel,cString,aRegistros,cDesc1,cDesc2,cDesc3,cAlias,aRegistros,cNomeImp")
SetPrvt("nLin,aPag,nIte,aReturn,cTamanho,Limite,lServer,cDrive")
SetPrvt("aOrdem,cTitulo,ctamanho,cNomProg,cNomRel,nLastKey,cSelect")

cSelect    := Alias()
cDesc1     := ""
cDesc2     := ""
cDesc3     := ""
cString    := "SD2"
cAlias     := "SD2"
aRegistros := {}
cTitulo    := OemToAnsi("Emissao da Nota Fiscal de Saida")
cTamanho   := "M"
aReturn    := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cNomProg   := "NFPECSER"
nLastKey   := 0
cNomRel    := "NFPECSER"
nLin       := 4
aPag       := 1
nIte       := 1
lServer    := .f.
cDrive     := GetMv("MV_DRVNFI")
cNomeImp   := GetMv("MV_PORNFI")

if ParamIXB == Nil
   PERGUNTE("OFR030")
Else
   mv_par01 := ParamIXB[1] //Nro da Nota
   mv_par02 := ParamIXB[2] //Serie
Endif

if valtype(mv_par01) # "C"  //fechamento de interna   s/ nro de nf
   Set Filter To     
   dbSelectArea(cSelect)
   Return
endif

cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)

If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| ImprimeNF(@lEnd,cNomRel,cAlias)},cTitulo)

Set Filter To

dbSelectArea(cSelect)

Return



Static Function ImprimeNF(lEnd,wNRel,cAlias)
************************************
Local nQtdIte := 0
Local nQtdSrv := 0
Private ntrans := 0, nQtdPag :=  0
lflagm := .t.
lflagT := .t.
SetPrvt("oPr,nX,aDriver,lVez,nValor1,aCab,nLin,aIte")
SetPrvt("cNomeEmp,cEndeEmp,cNomeCid,cEstaEmp,cCep_Emp,cFoneEmp,cCodMun")
SetPrvt("cFax_Emp,cCNPJEmp,cInscEmp,cCompac,cNormal")


aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Set Printer to &cNomRel
Set Printer On
Set Device  to Printer

DbSelectArea("SM0")
cNomeEmp := SM0->M0_NOMECOM
cEndeEmp := SM0->M0_ENDENT
cNomeCid := SM0->M0_CIDENT
cEstaEmp := "ESTADO: " + SM0->M0_ESTENT
cCep_Emp := SM0->M0_CEPENT
cFoneEmp := "FONE: " + SM0->M0_TEL
cFax_Emp := "FAX: " + SM0->M0_FAX
cCNPJEmp := SM0->M0_CGC
cInscEmp := SM0->M0_INSC
cCodMun  := SM0->M0_CODMUN 
DbSelectArea("SF2")
dbgotop()
DbSeek(xFilial("SF2")+mv_par01+mv_par02)

DbSelectArea("VOO")
dbsetorder(4)
dbgotop()          
DbSeek(xFilial("VOO")+mv_par01+mv_par02)

aOsv := {}

do while !eof() .and. (VOO->VOO_SERNFI + VOO->VOO_NUMNFI) = mv_par02+mv_par01

   aadd(aOsv,VOO->VOO_NUMOSV)

   DbSelectArea("VOO")
   dbskip()
   
enddo
   
aPla := {}

for i = 1 to len(aOsv)

   DbSelectArea("VO1")
   dbgotop()          
   DbSeek(xFilial("VO1")+aOsv[i])

   DbSelectArea("VV1")
   dbgotop()          
   DbSeek(xFilial("VV1")+VO1->VO1_CHAINT)
   if ascan(aPla,VV1->VV1_PLAVEI) = 0
      aadd(aPla,VV1->VV1_PLAVEI)
   endif
   
next
aCab := {}
aAdd(aCab,SF2->F2_DOC  )                                   //1
aAdd(aCab,SF2->F2_SERIE)                                   //2
aAdd(aCab,SF2->F2_CLIENTE)                                 //3
aAdd(aCab,SF2->F2_LOJA)                                    //4
aAdd(aCab,SF2->F2_EMISSAO)                                 //5
aAdd(aCab,Transform(SF2->F2_BASEICM,"@E 999,999,999.99"))  //6
aAdd(aCab,Transform(SF2->F2_VALICM ,"@E 999,999,999.99"))  //7
aAdd(aCab,Transform(SF2->F2_FRETE  ,"@E 999,999,999.99"))  //8
aAdd(aCab,Transform(SF2->F2_SEGURO ,"@E 999,999,999.99"))  //9
aAdd(aCab,SF2->F2_VALBRUT)                                 //10
aAdd(aCab,SF2->F2_DESCONT)                                 //11

DbSelectArea("SE4")
Dbsetorder(1)
dbgotop()
DbSeek(xFilial("SE4")+SF2->F2_COND)

aTit  := {}
aTit1 := {}
dAnt := ctod("  /  /  ")
nRazao := 0

dbselectArea("SE1")
DbSetOrder(1)
dbgotop()
DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL)

nPar := 0 
nValor := 0

do while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM = SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL                        

*   if SE1->E1_BAIXA = ctod("  /  /  ")

      aAdd(aTit,{SE1->E1_PREFIXO+SE1->E1_NUM+"/"+SE1->E1_PARCELA,transform(SE1->E1_VALOR,"@e 999,999.99"),SE1->E1_VENCTO})

      if SE1->E1_PARCELA  >="1"
         nValor := nValor + SE1->E1_VALOR  
      endif

      if SE4->E4_TIPO = "A"
         if SE1->E1_PARCELA = "0"
            n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
            d_Ant := SE1->E1_VENCTO  
            aAdd(aTit1,strzero(n_Razao,3)) 
            npar++
         elseif SE1->E1_PARCELA = "1" .and. npar = 0
            n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
            d_Ant := SE1->E1_VENCTO  
            aAdd(aTit1,strzero(n_Razao,3))          
         else                                             
            n_Razao := SE1->E1_VENCTO - d_Ant 
            d_Ant := SE1->E1_VENCTO       
            aAdd(aTit1,strzero(n_Razao,3)) 
         endif
      endif


*   endif  

   dbselectArea("SE1")
   dbskip()

enddo  

DbSelectArea("SA3")
DbSetOrder(1)
dbgotop()
DbSeek(xFilial("SA3")+SF2->F2_VEND1)

aAdd(aCab,SF2->F2_VEND1+ " - "+SA3->A3_NOME)               //12

DbSelectArea("SE4")
Dbsetorder(1)
dbgotop()
DbSeek(xFilial("SE4")+SF2->F2_COND)

if SE4->E4_TIPO # "A"
   aAdd(aCab,SF2->F2_COND+" - "+SE4->E4_DESCRI)                //13
elseif SE4->E4_TIPO = "A" .AND. SF2->F2_COND = "028"          //CDCI    
   aAdd(aCab,SF2->F2_COND+" - "+SE4->E4_DESCRI)  
else
   cDescri := ""
   for xz = 1 to len(aTit1)
      cDescri := cDescri + atit1[xz] + ","          
   next         
   if len(aTit1) = 0
      cDescri := "A VISTA"                                    
      aAdd(aCab,SF2->F2_COND+" - "+cDESCRI)                //13      
   else                     
      cDescri := cDescri + " Dias"                           
      aAdd(aCab,SF2->F2_COND+" - "+cDESCRI)                //13
   endif 
endif

DbSelectArea("SA1")
dbgotop()
DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

aAdd(aCab,A1_NOME)                                         //14
aAdd(aCab,A1_END)                                          //15
aAdd(aCab,A1_BAIRRO)                                       //16
aAdd(aCab,A1_CEP)                                          //17
aAdd(aCab,A1_MUN)                                          //18
aAdd(aCab,A1_TEL)                                          //19
aAdd(aCab,A1_EST)                                          //20
cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
aAdd(aCab,cCGCPro)                                          //21
aAdd(aCab,A1_INSCR)                                        //22   21

DbSelectArea("SF2")
aAdd(aCab,SF2->F2_PLIQUI)                                  //23   22

DbSelectArea("SD2")
DbSetOrder(3)
dbgotop()
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

Private aIte := {}
Private aSrv := {}                   
Private aCfOp := {}           
Private aDesc := {}
Private nTotalSrv := 0
Private nTotalIss := 0
Private aliq := 0

While SF2->F2_DOC+SF2->F2_SERIE == D2_DOC+D2_SERIE .and. xFilial("SD2") == D2_FILIAL .and. !SD2->(EOF())

   DbSelectArea("SB1")
   dbSetOrder(1)
   dbgotop()
   DbSeek(xFilial("SB1")+SD2->D2_COD)

   DbSelectArea("SF4")
   dbgotop()
   DbSeek(xFilial("SF4")+SD2->D2_TES)

   If SF4->F4_ISS == "S"
      aAdd(aSrv,alltrim(SB1->B1_DESC))
      nTotalSrv := nTotalSrv+SD2->D2_TOTAL
      nTotalIss := nTotalIss + SD2->D2_VALISS
      if Aliq = 0
         Aliq := SD2->D2_ALIQISS
      endif
      if ascan(aCfOp,SD2->D2_CF,) = 0
         aAdd(aCfOp,SD2->D2_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif       
      nQtdSrv += 1
   Else
      aAdd(aIte,{SD2->D2_ITEM,SB1->B1_GRUPO+" "+SB1->B1_CODITE,SB1->B1_DESC,SD2->D2_UM,SD2->D2_QUANT,TRANSFORM(SD2->D2_PRUNIT,"@E 999,999,999.99"),SD2->D2_TOTAL,Transform(SD2->D2_PICM,"@E 999.99" ),SB1->B1_ORIGEM})
      if ascan(aCfOp,SD2->D2_CF,) = 0
         aAdd(aCfOp,SD2->D2_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif
      nQtdIte += 1
   Endif

   DbSelectArea("SD2")
   DbSkip()

Enddo

nQtdPag := nQtdIte / 16
nQtdPgs := nQtdSrv / 18

If nQtdPag > Int(nQtdPag)
   nQtdPag := Int(nQtdPag) + 1
Else
   nQtdpag := int(nqtdpag)
Endif

If nQtdIte == 16 
  nQtdPag := 1
Endif

If nQtdPgs > Int(nQtdPgs)
   nQtdPgs := Int(nQtdPgs) + 1
Else
   nQtdpgs := int(nqtdpgs)
Endif

If nQtdSrv == 18 
  nQtdPgs := 1
Endif

FS_CABEC()

nLin := 36 

lVez := .f.

nCol := 1

For i:=1 to Len(aSrv)

    if aPag > 1 .and. len(aSrv) > 18
       i:= 19
    endif  

    @ nLin, nCol pSay &cCompac+aSrv[i]+if(i=Len(aSrv),"",", ")

     nCol := nCol + Len(aSrv[i])+2
 
   if nCol >= 100
       nCol := 1
       nLin++
    Endif

    if nLin = 39  .and. nQtdPgs = 1 
       @ nLin, 00 pSay &cNormal+ " "
       @ nLIn, 65 pSay Transform(nTotalSrv,"@E 999,999,999.99") + &cCompac
    endif

    if nLin = 41 .and. nQtdPgs = 1 
       @ nLin, 00 pSay &cNormal + " "
       @ nLin, 60 pSay &cCompac + Transform(aliq,"@E 999,999,999.99") + &cNormal  
       @ nLin, 65 pSay Transform(nTotalIss,"@E 999,999,999.99")+&cCompac
       lVez := .t.
    endif
    
Next

If len(aSrv) # 0 

   if !lVez

      nLin := 39
      @ nLin, 00 pSay &cNormal  +" "
      @ nLin, 65 pSay Transform(nTotalSrv,"@E 999,999,999.99")

      nLin := 41
      @ nLin, 60 pSay &cCompac + Transform(aliq,"@E 999,999,999.99") + &cNormal
      @ nLin, 65 pSay  Transform(nTotalIss,"@E 999,999,999.99")

      lVez := .t.

   Endif

EndIf

@ 44, 000 pSay &cNormal + aCab[6]   //BASE DO ICMS - 42
@ 44, 014 pSay aCab[7]
//Cab[10]-aCab[11])
@ 44, 063 pSay Transform((aCab[10] - nTotalSrv),"@E 999,999,999.99")

@ 45, 063 pSay Transform((aCab[10]),"@E 999,999,999.99") //VL. TOTAL DA NF - 43

@ 47, 001 pSay &cCompac+" "
@ 47, 079 pSay "2" 

@ 50, 030 pSay &cNormal +"DIVERSAS"    
@ 50, 120 pSay transform(aCab[23],"@E 99.999")

@ 52, 001 pSay &cCompac + "Vendedor.......:"   
@ 52, 019 pSay aCab[12]  

@ 53, 002 pSay "Cond. Pagamento:"
@ 53, 019 pSay aCab[13]
@ 54,002  psay "Via Transporte.: Rodoviario" 
           
nLin := 55
nCol := 19  
if len(aOsv) >= 1                            
  @ nLin, 002 pSay "Ordem Servico..: "
  for i = 1 to len(aOsv)
     @ nLin, nCol pSay aOsv[i] + "/"              
     nCol := nCol + 9
     if nCol = 73 .or. nCol = 74
        nCol := 2
        nLin := nLin + 1
     endif      
  next 
endif

nLin := nLin + 1       

if len(aPla) = 1
   @ nLin, 002  pSay "Placa Veiculo..: "  + aPla[1]
endif

// IMPRIME NUMERO DA NOTA FISCAL NO RODAPE DO FORMULARIO

@ 61,00 psay &cNormal 
if nQtdPag > 0
   @ 62, 66 pSay aCab[1] + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPag,2)
else
   @ 62, 66 pSay aCab[1] + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPgs,2)
endif

nlin := 66
@ nlin , 001 pSay " "
SETPRC(0,0)

Set Printer to
Set Device  to Screen

MS_Flush()

Return

// FUNCAO PARA IMPRIMIR O CABECALHO DA NOTA FISCAL
Static Function FS_CABEC(ntrans)
*********************

@ 01, 001 pSay &cNormal      
if nQtdPag > 0
   @ 03, 051 pSay "X"+ space(14) + aCab[1] + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPag,2)
else
   @ 03, 051 pSay "X"+ space(14) + aCab[1] + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPgs,2)
endif
          
@ 05, 002 pSay + &cCompac

if len(aCfOp) = 1
   @ 07, 002 pSay aDesc[1]
   @ 07, 049 pSay aCfOp[1]
elseif len(aCfOp) = 2
   nLin:= 6
   for xv = 1 to len(aCfOp)
      @ nLin, 002 pSay aDesc[xv]
      @ nLin, 049 pSay aCfOp[xv]        
      nlin++
   next
elseif len(aCfOp) = 3
   nLin:= 5
   for xv = 1 to len(aCfOp)
      @ nLin, 002 pSay aDesc[xv]
      @ nLin, 049 pSay aCfOp[xv]        
      nlin++
   next
endif

@ 09, 000 pSay &cNormal+" "+aCab[14]  //CLIENTE 
@ 09, 052 pSay aCab[21]
@ 09, 072 pSay aCab[5]

@ 10, 001 pSay aCab[15]      //ENDERECO
@ 10, 044 pSay SUBSTR(aCab[16],1,15)
@ 10, 060 pSay transform(aCab[17],"@R 99999-999")
@ 10, 072 pSay aCab[5] 

@ 12, 001 pSay aCab[18]   //MUNICIPIO
@ 12, 033 pSay aCab[19]
@ 12, 047 pSay aCab[20]
@ 12, 053 pSay aCab[22]+&cCompac

FS_FATUR()    

If aPag # 1 
   @ 19 ,005 pSay "De Transporte" 
   @ 19 ,113 pSay transform(nTrans,"@E 999,999,999.99") 
EndIf  
       
FS_DETALHE()  

Return .t.


// FUNCAO PARA IMPRIMIR OS TITULOS DA NOTA FISCAL
Static Function FS_FATUR()
***********************

nLin++ //12
nLin := 14

if len(aTit) <= 12 
   
   for xa = 1 to len(aTit)

      if strzero(xa,2) $ "01/04/07/10"
         @ nLin, 000 pSay aTit[xa,1] //DUPLICATA
         @ nLin, 017 pSay aTit[xa,2] //VALOR
         @ nLin, 032 pSay aTit[xa,3] //VENCTO 
      elseif strzero(xa,2) $ "02/05/08/11"
         @ nLin, 047 pSay aTit[xa,1] 
         @ nLin, 063 pSay aTit[xa,2]
         @ nLin, 078 pSay aTit[xa,3]  
      elseif strzero(xa,2) $ "03/06/09/12"   
         @ nLin, 093 pSay aTit[xa,1] 
         @ nLin, 110 pSay aTit[xa,2]
         @ nLin, 126 pSay aTit[xa,3]  
         nLin++
      endif
  
   next

else

   if subs(aTit[1,1],11,1) = "0"    //tem entrada
   
      @ nLin, 000 pSay aTit[xa,1] //DUPLICATA
      @ nLin, 017 pSay aTit[xa,2] //VALOR
      @ nLin, 032 pSay aTit[xa,3] //VENCTO 

      @ nLin, 047 pSay "A Prazo"   // total a prazo
      @ nLin, 063 pSay nValor
       
   endif
   
endif

return

// FUNCAO PARA IMPRIMIR OS ITEMS DA NOTA FISCAL
Static Function FS_DETALHE()
***********************
           
If aPag == 1
   nLin:=19
else
   nLin:=20   
Endif

For i:=nIte to Len(aIte)   

    @ nLin, 001 pSay aIte[i,2] //14
    @ nLin, 025 pSay aIte[i,3]
    @ nLin, 075 pSay aIte[i,9]
    @ nLin, 080 pSay aIte[i,4]
    @ nLin, 089 pSay aIte[i,5]
    @ nLin, 092 pSay aIte[i,6]
    @ nLin, 114 pSay TRANSFORM(aIte[i,7],"@E 999,999,999.99")
    @ nLin, 132 pSay aIte[i,8]
    nTrans+= aIte[i,7]
    nLin++

    //TESTE PARA SABER SE O FORMULARIO CONTEM MAIS DE 1 VIA OU SEJA OS ITEMS NAO CABEM EM UM SO FORMULARIO
    If nLin > 33 //32

       @ nLin ,005 pSay "A Transportar"
       @ nLin ,113 pSay transform(nTrans,"@E 999,999,999.99")

       // IMPRIME NUMERO DA NOTA FISCAL NO RODAPE DO FORMULARIO
       @ 61, 01 psay &cNormal
       @ 62, 66 pSay  aCab[1]  +" / "+ StrZero(aPag,2)+"/"+ Strzero(nQtdPag,2)

       nlin := 66
       @ nlin , 001 pSay " "
       SETPRC(0,0)
       nIte := i + 1
       nLin := 1
       aPag++
       FS_CABEC(ntrans)

    EndIf
Next

Return

Static Function FS_VALNF1()
**********************

DbSelectArea("SF2")
DbSetOrder(1)
dbgotop()
If DbSeek(xFilial("SF2")+mv_par01)
   Return .f.
EndIf

Return .t.


Static Function FS_VALNF2()
**********************

DbSelectArea("SF2")
DbSetOrder(1)
dbgotop()
If DbSeek(xFilial("SF2")+mv_par01+mv_par02)
   Return .t.
Else              
   DbSelectArea("SA1")
   dbgotop()
   DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
   mv_par03 := sa1->a1_nome
   mv_par04 := sf2->f2_emissao
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LeDriver ³ Autor ³ Tecnologia            ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Emissao da Nota Fiscal de Balcao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeDriver()

Local aSettings := {}
Local cStr, cLine, i

If !File(__DRIVER)
   aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
   cStr := MemoRead(__DRIVER)
   For i:= 2 to 7
      cLine := AllTrim(MemoLine(cStr,254,i))
      aAdd(aSettings,SubStr(cLine,7))
   Next
EndIf

Return aSettings
