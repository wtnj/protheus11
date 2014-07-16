/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM048  ºAutor  ³Marcos R Roquitski  º Data ³  20/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consultas pendencias por aprovadores.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLOR.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "DBTREE.CH"

User function Nhcom048()

SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("_dDatade,_dDatate,_cSitu,CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,_dUltApr")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Historico Aprovacao/Pendencias de Solicitacoes de Compras"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SZ4"
nTipo     := 0
nomeprog  := "NHCOM048"
cPerg     := "NHCO48"
nPag      := 1
m_pag     := 1
_dUltApr  := Ctod(Space(08))

_aGrupo := pswret()
_cLogin := _agrupo[1,2]
mStruct := {}
AADD(mStruct,{"DT_MARCA",    "C",10,0})
AADD(mStruct,{"DT_NUM",      "C",06,0})
AADD(mStruct,{"DT_ITEM",     "C",04,0}) 
AADD(mStruct,{"DT_NUMCT",    "C",06,0})
AADD(mStruct,{"DT_ITEMCT",   "C",04,0})
Aadd(mStruct,{"DT_NUMPED",   "C",06,0})    
Aadd(mStruct,{"DT_ITEMPED",  "C",04,0})
AADD(mStruct,{"DT_TIPO",     "C",03,0})
AADD(mStruct,{"DT_DESCRI",   "C",48,0})
AADD(mStruct,{"DT_PRODUTO",  "C",15,0})
AADD(mStruct,{"DT_LOGIN",    "C",15,0})
AADD(mStruct,{"DT_SOLICIT",  "C",15,0})
AADD(mStruct,{"DT_QUANT",    "N",14,4})
AADD(mStruct,{"DT_VUNIT",    "N",16,2})
AADD(mStruct,{"DT_VALOR",    "N",16,2})
AADD(mStruct,{"DT_VLRPC",    "N",16,2})
AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
AADD(mStruct,{"DT_ATENCAO",  "C",10,0})
AADD(mStruct,{"DT_ANEXO",    "C",03,0})
AADD(mStruct,{"DT_ANEXO1",  "C",100,0})
AADD(mStruct,{"DT_ANEXO2",  "C",100,0})
AADD(mStruct,{"DT_ANEXO3",  "C",100,0})
AADD(mStruct,{"DT_STATUS",   "C",01,0})
AADD(mStruct,{"DT_OBS",     "C",240,0})
AADD(mStruct,{"DT_ULTAPR",   "D",08,0})     
AADD(mStruct,{"DT_QUANTP",    "N",14,4})
AADD(mStruct,{"DT_VUNITP",    "N",16,2})
AADD(mStruct,{"DT_VALORP",    "N",16,2})


mArqTrab := CriaTrab(mStruct,.t.)
USE &mArqTrab Alias DET New Exclusive

MsAguarde( {|lEnd| fDetalhes()},"Aguarde","Filtrando dados....",.T.)

DbSelectArea("DET")
DET->(DbGotop())

If Reccount() <=0
	MsgBox("Nao ha registro Selecionados !","Atencao !","INFO")
	DbCloseArea("DET")
	Return
Endif

aFields := {}
Aadd(aFields,{"DT_MARCA"     ,"C",OemToAnsi("Situacao")})
Aadd(aFields,{"DT_ANEXO"     ,"C",OemToAnsi("Anexo") })    
Aadd(aFields,{"DT_NUM"       ,"C",OemToAnsi("Numero") })    
Aadd(aFields,{"DT_ITEM"      ,"C",OemToAnsi("Item") })
Aadd(aFields,{"DT_NUMCT"     ,"C",OemToAnsi("Ped. Aberto") })    
Aadd(aFields,{"DT_ITEMCT"    ,"C",OemToAnsi("Item PA") })
Aadd(aFields,{"DT_NUMPED"    ,"C",OemToAnsi("Aut.Entrega") })    
Aadd(aFields,{"DT_ITEMPED"   ,"C",OemToAnsi("Item A.E.") })

Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") })
Aadd(aFields,{"DT_QUANT"     ,"N",OemToAnsi("Qtde"),"@E 999999999.9999"})
Aadd(aFields,{"DT_VUNIT"     ,"N",OemToAnsi("Vlr. Estimado"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VALOR"     ,"N",OemToAnsi("Total"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VLRPC"     ,"N",OemToAnsi("Vl.Ult.PC"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_SOLICIT"   ,"C",OemToAnsi("Solicitante")  })
Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })
Aadd(aFields,{"DT_ULTAPR"    ,"D",OemToAnsi("Ult.Aprov.") })
Aadd(aFields,{"DT_OBS"       ,"D",OemToAnsi("Observacao") })
Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
Aadd(aFields,{"DT_ATENCAO"   ,"C",OemToAnsi("Status") })
Aadd(aFields,{"DT_QUANTP"     ,"N",OemToAnsi("Qtde PA"),"@E 999999999.9999"})
Aadd(aFields,{"DT_VUNITP"     ,"N",OemToAnsi("Vlr. Ped. Aberto"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VALORP"     ,"N",OemToAnsi("Total PA"),"@E 999,999,999.99"})



aRotina   := {}
aRotina := { {"Anexo 1"      ,'U_fAnexodet(1)', 0 , 1 },;
             {"Anexo 2"      ,'U_fAnexodet(2)', 0 , 1 },;
             {"Anexo 3"      ,'U_fAnexodet(3)', 0 , 1 },;
             {"Filtrar"      ,'U_fFilPend()', 0 , 1 },;
             {"Imprime"      ,'U_fPenImp()', 0 , 1 }}
             
cDelFunc  := ".T."
cCadastro := OemToAnsi("Consulta status da Aprovacao")
cMarca    := getmark()
cCoord    := {50,50,600,600}
             
//MarkBrow("DET","DT_MARCA" ,"DET->DT_MARCA",afields,,)
MarkBrow("DET","","",afields,,)
DbCloseArea("DET")

Return


Static Function fDetalhes()
Local _aGrupo,_cLogin,nRecno,_cNumSc,_cNivel,_cOk,_nCont

DbSelectArea("SC1")
SET FILTER TO 
SC1->(DbGotop())

_aGrupo  := pswret()     // Retorna vetor com dados do usuario
_cLogin  := _agrupo[1,2] // Apelido

Pergunte("NHCO48",.T.) //ativa os parametros

_cLogin  := mv_par01
_cNivel  := Space(01)
_cOk     := 'S'
_cLogin2 := Space(15)
_dUltApr := Ctod(Space(08))
_nCont   := 0

DbSelectArea("DET")
Zap
// Processa Login Principal
SZU->(DbSetOrder(1))
SZU->( DbGotop())
SZU->(DbSeek(xFilial("SZU")+_cLogin))

While !SZU->(Eof()) .AND. Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin)

	_cOk    := 'S'
	_nRecno := SZU->(Recno())
	_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
	_cNivel := SZU->ZU_NIVEL
	_dUltApr := Ctod(Space(08))

	SZU->(DbSetOrder(2))
	SZU->(DbSeek(xFilial("SZU")+_cNumSc))
	While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
		If SZU->ZU_DATAPR <> Ctod(Space(08))
			_dUltApr := SZU->ZU_DATAPR
		Endif
			
		If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
			_cOk := "N"
			Exit
		Else
			If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)		
				_cOk := "N"	
				Exit
			Endif
		Endif
		SZU->(DbSkip())

		MsProcTxt("Processando.... " +StrZero(_nCont++,4))
	Enddo
	SZU->(DbSetOrder(1))
	SZU->(DbGoto(_nRecno))

	SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
	If SC1->(Found()) .AND. _cOk == 'S'
		ApTitulo1()
	Endif
	SZU->(DbSkip())
Enddo

  
// Processa responsavel nomeado
DbSelectarea("SZV")
SZV->(DbSetOrder(2))
SZV->(DbSeek(xFilial("SZV")+_cLogin))
While !SZV->(Eof())
	If (DATE() >= SZV->ZV_DATDE .AND. DATE() <= SZV->ZV_DATAT)
		If Alltrim(SZV->ZV_LOGDE) == Alltrim(_cLogin)
			_cLogin2 := SZV->ZV_LOGOR
			SZU->( DbGotop())
			SZU->(DbSeek(xFilial("SZU")+_cLogin2))

			While !SZU->(Eof()) .AND. Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin2)

				_cOk := 'S'
				_nRecno := SZU->(Recno())
				_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
				_cNivel := SZU->ZU_NIVEL

				SZU->(DbSetOrder(2))
				SZU->(DbSeek(xFilial("SZU")+_cNumSc))
				While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
		
					If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
						_cOk := "N"
						Exit
					Else
						If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)		
							_cOk := "N"	
							Exit
						Endif	
					Endif
					SZU->(DbSkip())
				Enddo
				SZU->(DbSetOrder(1))
				SZU->(DbGoto(_nRecno))

				SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
				If SC1->(Found()) .AND. _cOk == 'S'
					ApTitulo2()
				Endif
				SZU->(DbSkip())
			Enddo
        Endif
	Endif
	SZV->(DbSkip())
Enddo	        
Return(.T.)


Static Function ApTitulo1()
Local _nUltPrc := 0

	RecLock("DET",.T.)
	If SZU->ZU_STATUS=="A"
		DET->DT_MARCA := "Aprovado"
	Elseif SZU->ZU_STATUS=="B"
		DET->DT_MARCA := "Aguardar"
	Elseif SZU->ZU_STATUS=="C"
		DET->DT_MARCA := "Rejeitado"
	Elseif SZU->ZU_STATUS==" "
		DET->DT_MARCA := "Pendente"
	Endif	
	DET->DT_NUM       := SC1->C1_NUM
	DET->DT_ITEM      := SC1->C1_ITEM        
	DET->DT_NUMCT     := SZU->ZU_NUMCT //numero do contrato
	DET->DT_ITEMCT    := SZU->ZU_ITEMCT	 //item do contrato
	DET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	DET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga
	
	DET->DT_PRODUTO   := SC1->C1_PRODUTO
	DET->DT_DESCRI    := SC1->C1_DESCRI
	DET->DT_QUANT     := SC1->C1_QUANT
	DET->DT_VUNIT     := SC1->C1_VUNIT
	DET->DT_LOGIN     := SZU->ZU_LOGIN
	DET->DT_SOLICIT   := SC1->C1_SOLICIT
	DET->DT_VALOR     := (SC1->C1_VUNIT * SC1->C1_QUANT)
	DET->DT_EMISSAO   := SC1->C1_EMISSAO
	DET->DT_ATENCAO   := IIF(SZU->ZU_STATUS == 'B',"Aguardando",Space(10))
	DET->DT_ANEXO     := Iif(!EMPTY(SC1->C1_ANEXO1),"Sim","  ")
	DET->DT_ANEXO1    := SC1->C1_ANEXO1
	DET->DT_ANEXO2    := SC1->C1_ANEXO2
	DET->DT_ANEXO3    := SC1->C1_ANEXO3		
	DET->DT_STATUS    := SZU->ZU_STATUS			
	DET->DT_OBS       := SC1->C1_OBS     	
	DET->DT_ULTAPR    := _dUltApr
	
	  //Dados do pedido de compra em aberto para aprovacao         
    If !Empty(SZU->ZU_NUMCT)
       SC3->(DbSetOrder(1))
	   SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT + SZU->ZU_ITEMCT ))
	   If SC3->(Found())
	      DET->DT_QUANTP     := SC3->C3_QUANT
	      DET->DT_VUNITP     := SC3->C3_PRECO
	      DET->DT_VALORP     := (SC3->C3_PRECO * SC3->C3_QUANT)
       Endif
    Endif   
	
	SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	If SB1->(Found())
		If SB1->B1_GENERIC == '1'
			DET->DT_VLRPC := SB1->B1_UPRC
		Endif	
	Endif
	MsUnlock("DET")

Return


Static Function ApTitulo2()
Local _nUltPrc := 0
	RecLock("DET",.T.)
	If SZU->ZU_STATUS=="A"
		DET->DT_MARCA := "Aprovado"
	Elseif SZU->ZU_STATUS=="B"
		DET->DT_MARCA := "Aguardar"
	Elseif SZU->ZU_STATUS=="C"
		DET->DT_MARCA := "Rejeitado"
	Elseif SZU->ZU_STATUS==" "
		DET->DT_MARCA := "        "
	Endif	
	DET->DT_NUM       := SC1->C1_NUM
	DET->DT_ITEM      := SC1->C1_ITEM
	DET->DT_NUMCT     := SZU->ZU_NUMCT //numero do contrato
	DET->DT_ITEMCT    := SZU->ZU_ITEMCT	 //item do contrato
	DET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	DET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga
	
	DET->DT_PRODUTO   := SC1->C1_PRODUTO
	DET->DT_DESCRI    := SC1->C1_DESCRI
	DET->DT_QUANT     := SC1->C1_QUANT
	DET->DT_VUNIT     := SC1->C1_VUNIT
	DET->DT_LOGIN     := SZU->ZU_LOGIN
	DET->DT_SOLICIT   := SC1->C1_SOLICIT
	DET->DT_VALOR     := (SC1->C1_VUNIT * SC1->C1_QUANT)
	DET->DT_EMISSAO   := SC1->C1_EMISSAO
	DET->DT_ATENCAO   := IIF(SZU->ZU_STATUS == 'B',"Aguardando",Space(10))
	DET->DT_ANEXO     := Iif(!EMPTY(SC1->C1_ANEXO1),"Sim","  ")
	DET->DT_ANEXO1    := SC1->C1_ANEXO1
	DET->DT_ANEXO2    := SC1->C1_ANEXO2
	DET->DT_ANEXO3    := SC1->C1_ANEXO3
	DET->DT_STATUS    := SZU->ZU_STATUS
	DET->DT_OBS       := SC1->C1_OBS
	DET->DT_ULTAPR    := _dUltApr
	
	  //Dados do pedido de compra em aberto para aprovacao         
    If !Empty(SZU->ZU_NUMCT)
       SC3->(DbSetOrder(1))
	   SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT + SZU->ZU_ITEMCT ))
	   If SC3->(Found())
	      DET->DT_QUANTP     := SC3->C3_QUANT
	      DET->DT_VUNITP     := SC3->C3_PRECO
	      DET->DT_VALORP     := (SC3->C3_PRECO * SC3->C3_QUANT)
       Endif
    Endif   
	
	SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	If SB1->(Found())
		If SB1->B1_GENERIC == '1'
			DET->DT_VLRPC := SB1->B1_UPRC
		Endif
	Endif
	MsUnlock("DET")

Return


User Function fPenImp()

U_fFilPen()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHCOM048"

SetPrint("SZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")


If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Imprime()
Local _nZxVlpago := 0, _cNumero, _cNmbanco := Space(40)
Local _nVlrTot   := 0

DET->(Dbgotop())
                        
Cabec1    := "Situacao   Nr.Sc     Item  Produto        Descricao do produto                                Quantidade V.Unit.Estimado         Total Solicit.   Emissao    Ult.Aprov.   Anexo Observacao\Aprovador"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !DET->(eof())
	
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif


	If mv_par01 == 2 .AND. DET->DT_STATUS <>  " "  // Pendente
		DET->(DbSkip())	
		Loop
	Endif		

	If mv_par01 == 3 .AND. DET->DT_STATUS <> "A" // Aprovada
		DET->(DbSkip())	
		Loop
	Endif		

	If mv_par01 == 4 .AND. DET->DT_STATUS <> "B" // Aguardando
		DET->(DbSkip())	
		Loop
	Endif		

	If mv_par01 == 5 .AND. DET->DT_STATUS <> "C" // Rejeitada
		DET->(DbSkip())	
		Loop
	Endif		
    _nVlrTot += DET->DT_VALOR // Soma o total das pendencias
	@ Prow() + 1, 000 Psay 	DET->DT_MARCA
	@ Prow()    , 011 Psay 	DET->DT_NUM
	@ Prow()    , 021 Psay 	DET->DT_ITEM
	@ Prow()    , 027 Psay 	Substr(DET->DT_PRODUTO,1,13)
	@ Prow()    , 042 Psay 	DET->DT_DESCRI
	@ Prow()    , 090 Psay 	DET->DT_QUANT Picture "@E 9,999,999.9999"
	@ Prow()    , 106 Psay 	DET->DT_VUNIT Picture "@E 999,999,999.99"
	@ Prow()    , 120 Psay 	DET->DT_VALOR Picture "@E 999,999,999.99"
	@ Prow()    , 135 Psay 	Substr(DET->DT_SOLICIT,1,10)
	@ Prow()    , 146 Psay 	DET->DT_EMISSAO
	@ Prow()    , 157 Psay 	DET->DT_ULTAPR 
	@ Prow()    , 170 Psay 	DET->DT_ANEXO
	@ Prow()    , 176 Psay 	Substr(DET->DT_OBS,1,30)+ " " + DET->DT_LOGIN
	DET->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()  
@ Prow() + 1,001 Psay "Total Geral :"
@ Prow()    ,120 Psay _nVlrTot Picture "@E 999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()  
Return


User Function fFilPen()
	If Pergunte("NHCO44",.T.) //ativa os parametros

		If mv_par01 == 1
			SET FILTER TO 
		Endif		

		If mv_par01 == 2 
			SET FILTER TO DET->DT_STATUS =  " "  // Pendentes
		Endif		

		If mv_par01 == 3 
			SET FILTER TO DET->DT_STATUS = "A"  // Aprovada
		Endif		

		If mv_par01 == 4 
			SET FILTER TO DET->DT_STATUS = "B"  // Aguardando
		Endif		

		If mv_par01 == 5 
			SET FILTER TO DET->DT_STATUS = "C"  // Rejeitada 
		Endif		
	Else
		SET FILTER TO 	
	Endif		
	DET->(Dbgotop())
	
Return
