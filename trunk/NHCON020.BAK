/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! ATI - Ativo Fixo                                              !
+------------------+---------------------------------------------------------------+
!Nome              ! NHCON020.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Exportação das Tabelas do ATIVO - Contrato de Financiamentos  +
+------------------+---------------------------------------------------------------+
!Autor             ! Edenilson Santos                                              !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 06/02/2014                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!Chamado No. 064723                         !Vivianesr      !Edenilson  !06/02/2014!
+-------------------------------------------+---------------+-----------+----------+
*/
#include "rwmake.ch"
#include "colors.ch"
#include "protheus.ch"
#include "prconst.ch"

User Function NHCON020(_aDbf)
Private _cTab := Space(3)
Private oCheck1 := .T.
Private oCheck2 := .F.
Private oCheck3 := .T.
Private oCheck4 := .F.
Private oCheck5 := .F.
Private oCheck6 := .F.
Private oFilial := "Sim"
Private oConsFil:= {"Sim","Nao"}

@ 180,180 To 400,404 Dialog oDlg Title "Exportar Tabelas"

TGroup():New(005,005,65,110,'Marque as tabelas que deseja exportar',oDlg,CLR_HBLUE,,.T.)

@ 015,010 CheckBox oChk1 Var oCheck1 PROMPT "SN1 - Ativo Imobilizado"          Size 100,008 Pixel Of oDlg
@ 025,010 CheckBox oChk2 Var oCheck2 PROMPT "SN2 - Descrição Estendida"        Size 100,008 Pixel Of oDlg
@ 035,010 CheckBox oChk3 Var oCheck3 PROMPT "SN3 - Saldos e Valores"           Size 100,008 Pixel Of oDlg
@ 045,010 CheckBox oChk4 Var oCheck4 PROMPT "SN4 - Movimentação do Ativo Fixo" Size 100,008 Pixel Of oDlg
@ 055,010 CheckBox oChk5 Var oCheck5 PROMPT "SN5 - Arquivos de Saldo"          Size 100,008 Pixel Of oDlg

TGroup():New(065,005,90,110,'Parâmetros',oDlg,CLR_HBLUE,,.T.)
@ 075,010 Say "Considerar Filiais:" Size 100,008 object oFil1
@ 073,055 ComboBox oFilial ITEMS oConsFil SIZE 025,010 object oFil2

@ 095,030 BmpButton Type 01 Action CON020EXP()
@ 095,060 BmpButton Type 02 Action Close(oDlg)

Activate Dialog oDlg Centered
Return

Static Function CON020EXP()
if oCheck1 == .T.
	Private cFile  := "SN1"+SM0->M0_CODIGO+"0.DBF"
	Private 	cNomDBF := __RelDir + cFile
	If File(cNomDBF)
		Delete File cNomDBF
	Endif
	if oFilial == 'Não'
		DbSelectAr("SN1")
		MsgRun("Aguarde, processando informações... {"+cFile+"-FILIAL:"+SM0->M0_CODFIL+"}","Filtro",{|| DbSetFilter( {|| N1_FILIAL = SM0->M0_CODFIL}, 'N1_FILIAL = "'+SM0->M0_CODFIL+'"')})
		SN1->(DbSetOrder(1))
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"}","Exportação de Tabelas",{|| ExportaDBF() })
		SN1->(DbClearFilter())
	Else
		DbSelectAr("SN1")
		SN1->(DbSetOrder(1))
		SN1->(DbClearFilter())
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"-FILIAL:TODAS}","Exportação de Tabelas",{|| ExportaDBF() })
	Endif
Endif

if oCheck2 == .T.
	Private cFile  := "SN2"+SM0->M0_CODIGO+"0.DBF"
	Private 	cNomDBF := __RelDir + cFile
	If File(cNomDBF)
		Delete File cNomDBF
	Endif
	if oFilial == 'Nao'
		DbSelectAr("SN2")
		MsgRun("Aguarde, processando informações... {"+cFile+"-FILIAL:"+SM0->M0_CODFIL+"}","Filtro",{|| DbSetFilter( {|| N2_FILIAL = SM0->M0_CODFIL}, 'N2_FILIAL = "'+SM0->M0_CODFIL+'"')})
		SN2->(DbSetOrder(1))
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"}","Exportação de Tabelas",{|| ExportaDBF() })
		SN2->(DbClearFilter())
	Else
		DbSelectAr("SN2")
		SN2->(DbSetOrder(2))
		SN2->(DbClearFilter())
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"-FILIAL:TODAS}","Exportação de Tabelas",{|| ExportaDBF() })
	Endif
Endif

if oCheck3 == .T.
	Private cFile  := "SN3"+SM0->M0_CODIGO+"0.DBF"
	Private 	cNomDBF := __RelDir + cFile
	If File(cNomDBF)
		Delete File cNomDBF
	Endif
	if oFilial == 'Nao'
		DbSelectAr("SN3")
		MsgRun("Aguarde, processando informações... {"+cFile+"-FILIAL:"+SM0->M0_CODFIL+"}","Filtro",{|| DbSetFilter( {|| N3_FILIAL = SM0->M0_CODFIL}, 'N3_FILIAL = "'+SM0->M0_CODFIL+'"')})
		SN3->(DbSetOrder(1))
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"}","Exportação de Tabelas",{|| ExportaDBF() })
		SN3->(DbClearFilter())
	Else
		DbSelectAr("SN3")
		SN3->(DbSetOrder(2))
		SN3->(DbClearFilter())
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"-FILIAL:TODAS}","Exportação de Tabelas",{|| ExportaDBF() })
	Endif
Endif

if oCheck4 == .T.
	Private cFile  := "SN4"+SM0->M0_CODIGO+"0.DBF"
	Private 	cNomDBF := __RelDir + cFile
	If File(cNomDBF)
		Delete File cNomDBF
	Endif
	if oFilial == 'Nao'
		DbSelectAr("SN4")
		MsgRun("Aguarde, processando informações... {"+cFile+"-FILIAL:"+SM0->M0_CODFIL+"}","Filtro",{|| DbSetFilter( {|| N4_FILIAL = SM0->M0_CODFIL}, 'N4_FILIAL = "'+SM0->M0_CODFIL+'"')})
		SN4->(DbSetOrder(1))
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"}","Exportação de Tabelas",{|| ExportaDBF() })
		SN4->(DbClearFilter())
	Else
		DbSelectAr("SN4")
		SN4->(DbSetOrder(2))
		SN4->(DbClearFilter())
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"-FILIAL:TODAS}","Exportação de Tabelas",{|| ExportaDBF() })
	Endif
Endif

if oCheck5 == .T.
	Private cFile  := "SN5"+SM0->M0_CODIGO+"0.DBF"
	Private 	cNomDBF := __RelDir + cFile
	If File(cNomDBF)
		Delete File cNomDBF
	Endif
	if oFilial == 'Nao'
		DbSelectAr("SN5")
		MsgRun("Aguarde, processando informações... {"+cFile+"-FILIAL:"+SM0->M0_CODFIL+"}","Filtro",{|| DbSetFilter( {|| N5_FILIAL = SM0->M0_CODFIL}, 'N5_FILIAL = "'+SM0->M0_CODFIL+'"')})
		SN5->(DbSetOrder(1))
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"}","Exportação de Tabelas",{|| ExportaDBF() })
		SN5->(DbClearFilter())
	Else
		DbSelectAr("SN5")
		SN5->(DbSetOrder(2))
		SN5->(DbClearFilter())
		MsgRun("Aguarde, gerando arquivo... {"+cFile+"-FILIAL:TODAS}","Exportação de Tabelas",{|| ExportaDBF() })
	Endif
Endif

Return

Static Function ExportaDBF()

Local cPath    := AllTrim(GetTempPath())
Local oExcelApp
Local cArquivo := cNomDBF

Copy To &cNomDBF VIA "DBFCDXADS"
__COPYFILE(cNomDBF,cPath+'\'+cFile)

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return Nil
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cFile ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return
