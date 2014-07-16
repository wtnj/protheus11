/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP16          ³ M.GracaNCarvalho      ³ Data ³ 06.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Dependentes de Assistencia Medica            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp16()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_NDESTFX1,_NDESTFX2,_NDESTFX3")
SetPrvt("_NDESTFX4,_NDESTFX5,_NDESTFX6,_NDESTFX7,_NDEEXFX1,_NDEEXFX2")
SetPrvt("_NDEEXFX3,_NDEEXFX4,_NDEEXFX5,_NDEEXFX6,_NDEEXFX7,_NFUSTFX1")
SetPrvt("_NFUSTFX2,_NFUSTFX3,_NFUSTFX4,_NFUSTFX5,_NFUSTFX6,_NFUSTFX7")
SetPrvt("_NFUEXFX1,_NFUEXFX2,_NFUEXFX3,_NFUEXFX4,_NFUEXFX5,_NFUEXFX6")
SetPrvt("_NFUEXFX7,_NIDADE,")

SetPrvt("_nFsfFx1,_nFsmFx1,_nFefFx1,_nFemFx1")
SetPrvt("_nFsfFx2,_nFsmFx2,_nFefFx2,_nFemFx2")
SetPrvt("_nFsfFx3,_nFsmFx3,_nFefFx3,_nFemFx3")
SetPrvt("_nFsfFx4,_nFsmFx4,_nFefFx4,_nFemFx4")
SetPrvt("_nFsfFx5,_nFsmFx5,_nFefFx5,_nFemFx5")
SetPrvt("_nFsfFx6,_nFsmFx6,_nFefFx6,_nFemFx6")
SetPrvt("_nFsfFx7,_nFsmFx7,_nFefFx7,_nFemFx7")

SetPrvt("_nDsfFx1,_nDsmFx1,_nDefFx1,_nDemFx1")
SetPrvt("_nDsfFx2,_nDsmFx2,_nDefFx2,_nDemFx2")
SetPrvt("_nDsfFx3,_nDsmFx3,_nDefFx3,_nDemFx3")
SetPrvt("_nDsfFx4,_nDsmFx4,_nDefFx4,_nDemFx4")
SetPrvt("_nDsfFx5,_nDsmFx5,_nDefFx5,_nDemFx5")
SetPrvt("_nDsfFx6,_nDsmFx6,_nDefFx6,_nDemFx6")
SetPrvt("_nDsfFx7,_nDsmFx7,_nDefFx7,_nDemFx7")


cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1    := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Dependentes de Assistencia Medica"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
m_pag     := 1
nomeprog  := "RHGP16"
cPerg     := "RHGP16"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP16',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RHGP16"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| RHG016()})

Return Nil



Static Function RHG016()

DbSelectArea("SRB")
DbSetOrder(1)

DbSelectArea("SRA")
DbSetOrder(1)

_nDeStFx1:=_nDeStFx2:=_nDeStFx3:=_nDeStFx4:=_nDeStFx5:=_nDeStFx6:=_nDeStFx7:=0
_nDeExFx1:=_nDeExFx2:=_nDeExFx3:=_nDeExFx4:=_nDeExFx5:=_nDeExFx6:=_nDeExFx7:=0
_nFuStFx1:=_nFuStFx2:=_nFuStFx3:=_nFuStFx4:=_nFuStFx5:=_nFuStFx6:=_nFuStFx7:=0
_nFuExFx1:=_nFuExFx2:=_nFuExFx3:=_nFuExFx4:=_nFuExFx5:=_nFuExFx6:=_nFuExFx7:=0
_nIdade:=0

_nFsfFx1 :=  _nFsmFx1 := _nFefFx1 := _nFemFx1 := 0
_nFsfFx2 :=  _nFsmFx2 := _nFefFx2 := _nFemFx2 := 0
_nFsfFx3 :=  _nFsmFx3 := _nFefFx3 := _nFemFx3 := 0
_nFsfFx4 :=  _nFsmFx4 := _nFefFx4 := _nFemFx4 := 0
_nFsfFx5 :=  _nFsmFx5 := _nFefFx5 := _nFemFx5 := 0
_nFsfFx6 :=  _nFsmFx6 := _nFefFx6 := _nFemFx6 := 0
_nFsfFx7 :=  _nFsmFx7 := _nFefFx7 := _nFemFx7 := 0

_nDsfFx1 :=  _nDsmFx1 := _nDefFx1 := _nDemFx1 := 0
_nDsfFx2 :=  _nDsmFx2 := _nDefFx2 := _nDemFx2 := 0
_nDsfFx3 :=  _nDsmFx3 := _nDefFx3 := _nDemFx3 := 0
_nDsfFx4 :=  _nDsmFx4 := _nDefFx4 := _nDemFx4 := 0
_nDsfFx5 :=  _nDsmFx5 := _nDefFx5 := _nDemFx5 := 0
_nDsfFx6 :=  _nDsmFx6 := _nDefFx6 := _nDemFx6 := 0
_nDsfFx7 :=  _nDsmFx7 := _nDefFx7 := _nDemFx7 := 0



SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))
Do While SRA->(! Eof())
   IncRegua()
   If SRA->RA_SITFOLH$"DT"
      SRA->(DbSkip())
      Loop
   EndIf   
   If SRA->RA_ASMEDIC<>SPACE(02)
      _nIdade:=Int((dDataBase-SRA->RA_NASC)/365.25+0.002)
      If SubStr(SRA->RA_ASMEDIC,2,1)=="1"
         If _nIdade<=mv_par01
            _nFuExFx1:=_nFuExFx1+1
				If SRA->RA_SEXO == "M"
		            _nFemFx1++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx1++
				Endif		            
         ElseIf _nIdade<=mv_par02
            _nFuExFx2:=_nFuExFx2+1

				If SRA->RA_SEXO == "M"
		            _nFemFx2++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx2++
				Endif		            


         ElseIf _nIdade<=mv_par03
            _nFuExFx3:=_nFuExFx3+1

				If SRA->RA_SEXO == "M"
		            _nFemFx3++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx3++
				Endif		            


         ElseIf _nIdade<=mv_par04
            _nFuExFx4:=_nFuExFx4+1

				If SRA->RA_SEXO == "M"
		            _nFemFx4++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx4++
				Endif		            


         ElseIf _nIdade<=mv_par05
            _nFuExFx5:=_nFuExFx5+1

				If SRA->RA_SEXO == "M"
		            _nFemFx5++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx5++
				Endif		            


         ElseIf _nIdade<=mv_par06
            _nFuExFx6:=_nFuExFx6+1

				If SRA->RA_SEXO == "M"
		            _nFemFx6++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx6++
				Endif		            

         ElseIf _nIdade<=mv_par07
            _nFuExFx7:=_nFuExFx7+1

				If SRA->RA_SEXO == "M"
		            _nFemFx7++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFefFx7++
				Endif		            

         EndIf
      EndIf
      If SubStr(SRA->RA_ASMEDIC,2,1)=="2"
         If _nIdade<=mv_par01
            _nFuStFx1:=_nFuStFx1+1
				If SRA->RA_SEXO == "M"
		            _nFsmFx1++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx1++
				Endif		            

         ElseIf _nIdade<=mv_par02
            _nFuStFx2:=_nFuStFx2+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx2++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx2++
				Endif		            


         ElseIf _nIdade<=mv_par03
            _nFuStFx3:=_nFuStFx3+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx3++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx3++
				Endif		            

         ElseIf _nIdade<=mv_par04
            _nFuStFx4:=_nFuStFx4+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx4++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx4++
				Endif		            

         ElseIf _nIdade<=mv_par05
            _nFuStFx5:=_nFuStFx5+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx5++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx5++
				Endif		            

         ElseIf _nIdade<=mv_par06
            _nFuStFx6:=_nFuStFx6+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx6++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx6++
				Endif		            

         ElseIf _nIdade<=mv_par07
            _nFuStFx7:=_nFuStFx7+1

				If SRA->RA_SEXO == "M"
		            _nFsmFx7++
				Elseif SRA->RA_SEXO == "F"	            
		            _nFsfFx7++
				Endif		            

         EndIf
      EndIf
   EndIf
   SRB->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
   Do While SRB->(! Eof()) .and. SRA->RA_FILIAL==SRB->RB_FILIAL .and. SRA->RA_MAT==SRB->RB_MAT
      If SRB->RB_ASMEDIC<>SPACE(02)
         _nIdade:=Int((dDataBase-SRB->RB_DTNASC)/365.25+0.002)
         If SubStr(SRB->RB_ASMEDIC,2,1)=="1"
            If _nIdade<=mv_par01
               _nDeExFx1:=_nDeExFx1+1

					If SRB->RB_SEXO == "M"
			            _nDemFx1++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx1++
					Endif		            

            ElseIf _nIdade<=mv_par02
               _nDeExFx2:=_nDeExFx2+1
	
					If SRB->RB_SEXO == "M"
			            _nDemFx2++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx2++
					Endif		            

            ElseIf _nIdade<=mv_par03
               _nDeExFx3:=_nDeExFx3+1

					If SRB->RB_SEXO == "M"
			            _nDemFx3++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx3++
					Endif		            

            ElseIf _nIdade<=mv_par04
               _nDeExFx4:=_nDeExFx4+1

					If SRB->RB_SEXO == "M"
			            _nDemFx4++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx4++
					Endif		            

            ElseIf _nIdade<=mv_par05
               _nDeExFx5:=_nDeExFx5+1


					If SRB->RB_SEXO == "M"
			            _nDemFx5++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx5++
					Endif		            

            ElseIf _nIdade<=mv_par06
               _nDeExFx6:=_nDeExFx6+1

					If SRB->RB_SEXO == "M"
			            _nDemFx6++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx6++
					Endif		            


            ElseIf _nIdade<=mv_par07
               _nDeExFx7:=_nDeExFx7+1

					If SRB->RB_SEXO == "M"
			            _nDemFx7++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDefFx7++
					Endif		            

            EndIf
         EndIf
         If SubStr(SRB->RB_ASMEDIC,2,1)=="2"
            If _nIdade<=mv_par01
               _nDeStFx1:=_nDeStFx1+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx1++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx1++
					Endif		            

            ElseIf _nIdade<=mv_par02
               _nDeStFx2:=_nDeStFx2+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx2++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx2++
					Endif		            

            ElseIf _nIdade<=mv_par03
               _nDeStFx3:=_nDeStFx3+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx3++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx3++
					Endif		            

            ElseIf _nIdade<=mv_par04
               _nDeStFx4:=_nDeStFx4+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx4++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx4++
					Endif		            

            ElseIf _nIdade<=mv_par05
               _nDeStFx5:=_nDeStFx5+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx5++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx5++
					Endif		            


            ElseIf _nIdade<=mv_par06
               _nDeStFx6:=_nDeStFx6+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx6++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx6++
					Endif		            

            ElseIf _nIdade<=mv_par07
               _nDeStFx7:=_nDeStFx7+1

					If SRB->RB_SEXO == "M"
			            _nDsmFx7++
					Elseif SRB->RB_SEXO == "F"	            
			            _nDsfFx7++
					Endif		            

            EndIf
         EndIf
      EndIf
      SRB->(DbSkip())
   EndDo
   SRA->(DbSkip())
EndDo   
@ pRow()   ,01 pSay "QUANTIDADE DE ASSOCIADOS ( FUNCIONARIOS E DEPENDENTES )"
@ pRow()+2 ,01 pSay "        POR FAIXA ETARIA  /  POR TIPO DE PLANO         "
@ pRow()+3 ,02 pSay "Funcionarios"
@ pRow()   ,32 pSay "Standard"
@ pRow()   ,52 pSay "Executivo"

@ pRow()   ,72 pSay "Stand./Masc"
@ pRow()   ,92 pSay "Stand./Fem" 

@ pRow()   ,112 pSay "Exec./Masc"
@ pRow()   ,132 pSay "Exec./Fem" 


@ pRow()+1 ,02 pSay "Faixa Etaria"
@ pRow()+1 ,02 pSay " 00"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par01 Picture "999"
@ pRow()   ,32 pSay _nFuStFx1 Picture "999"
@ pRow()   ,52 pSay _nFuExFx1 Picture "999"

@ pRow()   ,72  pSay _nFsmFx1   Picture "999"
@ pRow()   ,92  pSay _nFsfFx1   Picture "999"
@ pRow()   ,112 pSay _nFemFx1   Picture "999"
@ pRow()   ,132 pSay _nFefFx1   Picture "999"


@ pRow()+1 ,02 pSay mv_par01+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par02 Picture "999"
@ pRow()   ,32 pSay _nFuStFx2 Picture "999"
@ pRow()   ,52 pSay _nFuExFx2 Picture "999"

@ pRow()   ,72  pSay _nFsmFx2   Picture "999"
@ pRow()   ,92  pSay _nFsfFx2   Picture "999"
@ pRow()   ,112 pSay _nFemFx2   Picture "999"
@ pRow()   ,132 pSay _nFefFx2   Picture "999"



@ pRow()+1 ,02 pSay mv_par02+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par03 Picture "999"
@ pRow()   ,32 pSay _nFuStFx3 Picture "999"
@ pRow()   ,52 pSay _nFuExFx3 Picture "999"

@ pRow()   ,72  pSay _nFsmFx3   Picture "999"
@ pRow()   ,92  pSay _nFsfFx3   Picture "999"
@ pRow()   ,112 pSay _nFemFx3   Picture "999"
@ pRow()   ,132 pSay _nFefFx3   Picture "999"


@ pRow()+1 ,02 pSay mv_par03+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par04 Picture "999"
@ pRow()   ,32 pSay _nFuStFx4 Picture "999"
@ pRow()   ,52 pSay _nFuExFx4 Picture "999"

@ pRow()   ,72  pSay _nFsmFx4   Picture "999"
@ pRow()   ,92  pSay _nFsfFx4   Picture "999"
@ pRow()   ,112 pSay _nFemFx4   Picture "999"
@ pRow()   ,132 pSay _nFefFx4   Picture "999"


@ pRow()+1 ,02 pSay mv_par04+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par05 Picture "999"
@ pRow()   ,32 pSay _nFuStFx5 Picture "999"
@ pRow()   ,52 pSay _nFuExFx5 Picture "999"

@ pRow()   ,72  pSay _nFsmFx5   Picture "999"
@ pRow()   ,92  pSay _nFsfFx5   Picture "999"
@ pRow()   ,112 pSay _nFemFx5   Picture "999"
@ pRow()   ,132 pSay _nFefFx5   Picture "999"

@ pRow()+1 ,02 pSay mv_par05+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par06 Picture "999"
@ pRow()   ,32 pSay _nFuStFx6 Picture "999"
@ pRow()   ,52 pSay _nFuExFx6 Picture "999"

@ pRow()   ,72  pSay _nFsmFx6   Picture "999"
@ pRow()   ,92  pSay _nFsfFx6   Picture "999"
@ pRow()   ,112 pSay _nFemFx6   Picture "999"
@ pRow()   ,132 pSay _nFefFx6   Picture "999"

@ pRow()+1 ,02 pSay mv_par06+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par07 Picture "999"
@ pRow()   ,32 pSay _nFuStFx7 Picture "999"
@ pRow()   ,52 pSay _nFuExFx7 Picture "999"

@ pRow()   ,72  pSay _nFsmFx7   Picture "999"
@ pRow()   ,92  pSay _nFsfFx7   Picture "999"
@ pRow()   ,112 pSay _nFemFx7   Picture "999"
@ pRow()   ,132 pSay _nFefFx7   Picture "999"

@ pRow()+2 ,31 pSay _nFuStFx1+_nFuStFx2+_nFuStFx3+_nFuStFx4+_nFuStFx5+_nFuStFx6+_nFuStFx7 Picture "9999"
@ pRow()   ,51 pSay _nFuExFx1+_nFuExFx2+_nFuExFx3+_nFuExFx4+_nFuExFx5+_nFuExFx6+_nFuExFx7 Picture "9999"
@ pRow()+4 ,02 pSay "Dependentes"
@ pRow()   ,32 pSay "Standard"
@ pRow()   ,52 pSay "Executivo"
@ pRow()   ,72 pSay "Stand./Masc"
@ pRow()   ,92 pSay "Stand./Fem" 
@ pRow()   ,112 pSay "Exec./Masc"
@ pRow()   ,132 pSay "Exec./Fem" 

@ pRow()+1 ,02 pSay "Faixa Etaria"
@ pRow()+1 ,02 pSay " 00"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par01 Picture "999"
@ pRow()   ,32 pSay _nDeStFx1 Picture "999"
@ pRow()   ,52 pSay _nDeExFx1 Picture "999"

@ pRow()   ,72  pSay _nDsmFx1   Picture "999"
@ pRow()   ,92  pSay _nDsfFx1   Picture "999"
@ pRow()   ,112 pSay _nDemFx1   Picture "999"
@ pRow()   ,132 pSay _nDefFx1   Picture "999"

@ pRow()+1 ,02 pSay mv_par01+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par02 Picture "999"
@ pRow()   ,32 pSay _nDeStFx2 Picture "999"
@ pRow()   ,52 pSay _nDeExFx2 Picture "999"

@ pRow()   ,72  pSay _nDsmFx2   Picture "999"
@ pRow()   ,92  pSay _nDsfFx2   Picture "999"
@ pRow()   ,112 pSay _nDemFx2   Picture "999"
@ pRow()   ,132 pSay _nDefFx2   Picture "999"

@ pRow()+1 ,02 pSay mv_par02+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par03 Picture "999"
@ pRow()   ,32 pSay _nDeStFx3 Picture "999"
@ pRow()   ,52 pSay _nDeExFx3 Picture "999"

@ pRow()   ,72  pSay _nDsmFx3   Picture "999"
@ pRow()   ,92  pSay _nDsfFx3   Picture "999"
@ pRow()   ,112 pSay _nDemFx3   Picture "999"
@ pRow()   ,132 pSay _nDefFx3   Picture "999"

@ pRow()+1 ,02 pSay mv_par03+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par04 Picture "999"
@ pRow()   ,32 pSay _nDeStFx4 Picture "999"
@ pRow()   ,52 pSay _nDeExFx4 Picture "999"

@ pRow()   ,72  pSay _nDsmFx4   Picture "999"
@ pRow()   ,92  pSay _nDsfFx4   Picture "999"
@ pRow()   ,112 pSay _nDemFx4   Picture "999"
@ pRow()   ,132 pSay _nDefFx4   Picture "999"

@ pRow()+1 ,02 pSay mv_par04+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par05 Picture "999"
@ pRow()   ,32 pSay _nDeStFx5 Picture "999"
@ pRow()   ,52 pSay _nDeExFx5 Picture "999"

@ pRow()   ,72  pSay _nDsmFx5   Picture "999"
@ pRow()   ,92  pSay _nDsfFx5   Picture "999"
@ pRow()   ,112 pSay _nDemFx5   Picture "999"
@ pRow()   ,132 pSay _nDefFx5   Picture "999"

@ pRow()+1 ,02 pSay mv_par05+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par06 Picture "999"
@ pRow()   ,32 pSay _nDeStFx6 Picture "999"
@ pRow()   ,52 pSay _nDeExFx6 Picture "999"

@ pRow()   ,72  pSay _nDsmFx6   Picture "999"
@ pRow()   ,92  pSay _nDsfFx6   Picture "999"
@ pRow()   ,112 pSay _nDemFx6   Picture "999"
@ pRow()   ,132 pSay _nDefFx6   Picture "999"

@ pRow()+1 ,02 pSay mv_par06+1 Picture "999"
@ pRow()   ,06 pSay "a"
@ pRow()   ,08 pSay mv_par07 Picture "999"
@ pRow()   ,32 pSay _nDeStFx7 Picture "999"
@ pRow()   ,52 pSay _nDeExFx7 Picture "999"

@ pRow()   ,72  pSay _nDsmFx7   Picture "999"
@ pRow()   ,92  pSay _nDsfFx7   Picture "999"
@ pRow()   ,112 pSay _nDemFx7   Picture "999"
@ pRow()   ,132 pSay _nDefFx7   Picture "999"


@ pRow()+2 ,31 pSay _nDeStFx1+_nDeStFx2+_nDeStFx3+_nDeStFx4+_nDeStFx5+_nDeStFx6+_nDeStFx7 Picture "9999"
@ pRow()   ,51 pSay _nDeExFx1+_nDeExFx2+_nDeExFx3+_nDeExFx4+_nDeExFx5+_nDeExFx6+_nDeExFx7 Picture "9999"

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
