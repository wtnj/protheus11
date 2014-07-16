/*---------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! SIGAPCP                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_PCPR005                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Relatório Inventário Diário                             !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 01/09/2010                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descrição detalhada da atualização      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+-------*/
#Include "Protheus.ch"
#Include "rwmake.ch"

user function pWhbr005()

Local cTit    := "Relatório Inventário Diário"
Local aSay    := {}
Local aBut    := {}
Local lOk     := .F.
Local lFim    := .F.

Private cPerg := padr("PWHBR005B",10)

CriaSx1(cPerg)
Pergunte(cPerg, .F.)

aAdd(aSay, "Este programa imprime o Relatório Inventário Diário.")
aAdd(aSay, "É necessario ter o MS Excel instalado no computador, pois o relatório é")
aAdd(aSay, "gerado diretamento em planilha.")

aAdd(aBut, {5, .T., {|| Pergunte(cPerg, .T.)}})
aAdd(aBut, {1, .T., {|o| o:oWnd:End(), lOk := .T.}})
aAdd(aBut, {2, .T., {|o| o:oWnd:End()}})

FormBatch(cTit, aSay, aBut)
	
If lOk

	//--Verifica se o Excel esta instalado
	If !ApOleClient('MsExcel') 
		Aviso("MsExcel","É necessario que o Ms Excel estejá instalado.",{"Ok"},1)
		Return
	EndIf

	//Processamento do relatório
	Processa({|lEnd|pWhb5Proc(@lEnd)},"Inventário Diário","Aguarde. Preparando dados para impressão...",.T.)

EndIf

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! pWhb5Proc                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Monta a estrutura do relatório                          !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function pWhb5Proc()

Local cAl    := getNextAlias()
Local cDirDocs := MsDocPath() 
Local aStru	   := {}
Local cArquivo := CriaTrab(,.F.)
Local cPath	   := AllTrim(GetTempPath())
Local nPos := 0
Local oExcelApp
Local nLin := 0
Local cCliente := ""
Local cNome := ""
Local aCliente := {}
/*
aCliente[1] := Cliente
aCliente[2] := aLinhas
*/
Local aLinhas := {}
/*
aLinhas[01] := Codigo WHB
aLinhas[02] := Codigo Cliente
aLinhas[03] := Descrição Cliente
aLinhas[04] := Peso
aLinhas[05] := Expedição
aLinhas[06] := Acabamento
aLinhas[07] := Retrabalho
aLinhas[08] := Inspecao
aLinhas[09] := Analise
*/
Local nRegs := 0

cExpedicao  := padr(superGetMv("WHB_ARMEXP",.f.,"27"),tamSx3("B1_LOCPAD")[1])
cAcabamento := padr(superGetMv("WHB_ARMACA",.f.,"23"),tamSx3("B1_LOCPAD")[1])
cRetrabalho := padr(superGetMv("WHB_ARMRET",.f.,"24"),tamSx3("B1_LOCPAD")[1])
cInspecao   := padr(superGetMv("WHB_ARMINS",.f.,"25"),tamSx3("B1_LOCPAD")[1])
cAnalise    := padr(superGetMv("WHB_ARMANA",.f.,"26"),tamSx3("B1_LOCPAD")[1])

Private nHandle

beginSql Alias cAl
	select
		B1_COD
	,   B1_DESC
	,	substring(B1.B1_COD,1,3)+substring(B1.B1_COD,9,4) as WHB_COD
	,   B1_PESO
	from
		%table:SB1% B1
	inner join (
			select
				distinct B2.B2_COD
			from
				%table:SB2% B2
			where
				B2.B2_FILIAL  = %xFilial:SB2%
			and B2.B2_COD    >= %Exp:mv_par06%
			and B2.B2_COD    <= %Exp:mv_par07%
			and B2.B2_LOCAL  in ( %Exp:cExpedicao%
			                     ,%Exp:cAcabamento%
			                     ,%Exp:cRetrabalho%
			                     ,%Exp:cInspecao%
			                     ,%Exp:cAnalise%)
			and B2.D_E_L_E_T_ = ' '
			group by
				B2.B2_COD
		) B2
		on B2.B2_COD = B1.B1_COD
	where
		B1.B1_FILIAL  = %xFilial:SB1%
	and B1.B1_COD    >= %Exp:mv_par06%
	and B1.B1_COD    <= %Exp:mv_par07%
	and B1.B1_GRUPO  >= %Exp:mv_par04%
	and B1.B1_GRUPO  <= %Exp:mv_par05%
	and B1.B1_MSBLQL <> '1'
	and B1.D_E_L_E_T_ = ' '
	order by
		B1.B1_COD
endSql

//Verifica se há registros
If (cAl)->(Eof())
	Aviso("Fim","Não há registro para geração do relatório de inventário",{"Ok"},2)
	Return
Endif

//Controle de quebra
cCliente := substr((cAl)->B1_COD,1,3)

//Conta Quantidade de registros
(cAl)->(dbEval({||nRegs++}))
(cAl)->(dbGoTop())

dbSelectArea("SB2")
SB2->(dbSetOrder(1))

//Regua
procRegua(nRegs)

//Processa a consulta, tem que ser antes, pois preciso saber quantas linhas tem
While !(cAl)->(Eof())

	//Regua
	incProc("Processando: "+alltrim(str(nLin))+" de "+alltrim(str(nRegs))+" registros ...")

	//Cancelar?
	If lEnd; Return; Endif

	nLin++
	aAdd(aLinhas,{(cAl)->WHB_COD,(cAl)->B1_DESC,(cAl)->B1_PESO,0,0,0,0,0})

	//Posição da Ultima linha
	nPos := len(aLinhas)

	//calculo do estoque
	If ( mv_par01 != 1 )
		aLinhas[nPos,4] := calcEst((cAl)->B1_COD,cExpedicao ,mv_par02+iif(mv_par03==1,0,1))[1] //Armazem 27
        aLinhas[nPos,5] := calcEst((cAl)->B1_COD,cAcabamento,mv_par02+iif(mv_par03==1,0,1))[1] //Armazem 23
        aLinhas[nPos,6] := calcEst((cAl)->B1_COD,cRetrabalho,mv_par02+iif(mv_par03==1,0,1))[1] //Armazem 24
        aLinhas[nPos,7] := calcEst((cAl)->B1_COD,cInspecao  ,mv_par02+iif(mv_par03==1,0,1))[1] //Armazem 25
        aLinhas[nPos,8] := calcEst((cAl)->B1_COD,cAnalise   ,mv_par02+iif(mv_par03==1,0,1))[1] //Armazem 26

	//Saldo Sb2
	Else
	
		aLinhas[nPos,4] := Iif(SB2->(dbSeek(xFilial("SB2")+(cAl)->B1_COD+cExpedicao )),SB2->B2_QATU,0)
		aLinhas[nPos,5] := Iif(SB2->(dbSeek(xFilial("SB2")+(cAl)->B1_COD+cAcabamento)),SB2->B2_QATU,0)
		aLinhas[nPos,8] := Iif(SB2->(dbSeek(xFilial("SB2")+(cAl)->B1_COD+cRetrabalho)),SB2->B2_QATU,0)
		aLinhas[nPos,7] := Iif(SB2->(dbSeek(xFilial("SB2")+(cAl)->B1_COD+cInspecao  )),SB2->B2_QATU,0)
		aLinhas[nPos,8] := Iif(SB2->(dbSeek(xFilial("SB2")+(cAl)->B1_COD+cAnalise   )),SB2->B2_QATU,0)

	Endif

	//Nao considerera saldo Zero
	If ( mv_par08 != 1 )
		
		If Empty(aLinhas[nPos,4]).And.;
		   Empty(aLinhas[nPos,5]).And.;
		   Empty(aLinhas[nPos,6]).And.;
		   Empty(aLinhas[nPos,7]).And.;
		   Empty(aLinhas[nPos,8])
		
			aDel(aLinhas,len(aLinhas))
			aSize(aLinhas,len(aLinhas)-1)
		Endif

	Endif
	
	//Pula Linha
	(cAl)->(dbSkip())

	//Quebra
	If (len(aLinhas) != 0).And.(( cCliente != substr((cAl)->B1_COD,1,3) ).Or.(cAl)->(Eof()))
		aAdd(aCliente,{cCliente,AjustXml(aLinhas)})

		//Atualiza variais de controle
		aLinhas   := {}
		nLin++
	Endif

	cCliente := substr((cAl)->B1_COD,1,3)
	
Enddo

//Cria o arquivo
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".XML",0)

//Verifica se conseguiu criar o arquivo
If ( nHandle <= 0 )
	Aviso("Excel","Falha na geração do arquivo Excel.",{"Ok"},1)
	Return
Endif

//Propriedades do arquivo
gXml('<?xml version="1.0" encoding="ISO-8859-1"?>')
gXml('<?mso-application progid="Excel.Sheet"?>')
gXml('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
gXml( 		 'xmlns:o="urn:schemas-microsoft-com:office:office"')
gXml( 		 'xmlns:x="urn:schemas-microsoft-com:office:excel"')
gXml( 		 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
gXml( 		 'xmlns:html="http://www.w3.org/TR/REC-html40">')
gXml( '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
gXml( 	'<Author>'+cUserName+'</Author>')
gXml( 	'<LastAuthor>'+cUserName+'</LastAuthor>')
gXml( 	'<LastPrinted>'+dtExcel(dDatabase)+'T'+Time()+'Z</LastPrinted>')
gXml( 	'<Created>'+dtExcel(dDatabase)+'T'+Time()+'Z</Created>')
gXml( 	'<Version>12.00</Version>')
gXml( '</DocumentProperties>')
gXml(	'<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">')
gXml(		'<WindowHeight>4170</WindowHeight>')
gXml(		'<WindowWidth>7635</WindowWidth>')
gXml( 	'<WindowTopX>360</WindowTopX>')
gXml( 	'<WindowTopY>30</WindowTopY>')
gXml( 	'<ProtectStructure>False</ProtectStructure>')
gXml( 	'<ProtectWindows>False</ProtectWindows>')
gXml( '</ExcelWorkbook>')
	
//--Estilos
gXml(' <Styles>')
gXml('  <Style ss:ID="Default" ss:Name="Normal">')
gXml('   <Alignment ss:Vertical="Bottom"/>')
gXml('   <Borders/>')
gXml('   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
gXml('   <Interior/>')
gXml('   <NumberFormat/>')
gXml('   <Protection/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s62" ss:Name="Normal 2">')
gXml('   <Alignment ss:Vertical="Bottom"/>')
gXml('   <Borders/>')
gXml('   <Font ss:FontName="Book Antiqua"/>')
gXml('   <Interior/>')
gXml('   <NumberFormat/>')
gXml('   <Protection/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s63" ss:Name="Normal_ACOMPANHAMENTO EXPEDIÇÃO">')
gXml('   <Alignment ss:Vertical="Bottom"/>')
gXml('   <Borders/>')
gXml('   <Font ss:FontName="Arial"/>')
gXml('   <Interior/>')
gXml('   <NumberFormat/>')
gXml('   <Protection/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s16" ss:Name="Separador de milhares">')
gXml('   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s65">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="36" ss:Color="#003366" ss:Bold="1"/>')
gXml('   <NumberFormat ss:Format="Short Date"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s68" ss:Parent="s63">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#000000"/>')
gXml('   <Interior ss:Color="#FAC090" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="Fixed"/>')
gXml('   <Protection/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s70" ss:Parent="s62">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#003366" ss:Bold="1" ss:Underline="Single"/>')
gXml('   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s71" ss:Parent="s62">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#003366" ss:Bold="1" ss:Underline="Single"/>')
gXml('   <Interior ss:Color="#E46D0A" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s72" ss:Parent="s62">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#003366" ss:Bold="1" ss:Underline="Single"/>')
gXml('   <Interior ss:Color="#93CDDD" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s73" ss:Parent="s62">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#003366" ss:Bold="1" ss:Underline="Single"/>')
gXml('   <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s74" ss:Parent="s62">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#003366" ss:Bold="1" ss:Underline="Single"/>')
gXml('   <Interior ss:Color="#FAC090" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s75">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="20" ss:Color="#000000"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s76">')
gXml('   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="20" ss:Color="#000000"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s77">')
gXml('   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#000000"/>')
//gXml('   <NumberFormat ss:Format="_ * #,##0.00_ ;\ * #,##0.00_ ;_ * &quot; &quot;??_ ;_ @_ "/>') 
gXml('   <NumberFormat ss:Format="_ * #,##0.00_ ;\ * #,##0.00_ ;_ * &quot; &quot;??_ ;_ @_ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s78">')
gXml('   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#000000"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s79">')
gXml('   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>')
gXml('   <Borders>')
gXml('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
gXml('   </Borders>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#000000"/>')
gXml('   <NumberFormat ss:Format="0_ ;[Red]\-0\ "/>')
gXml('   <Protection/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s80">')
gXml('   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#FAC090" ss:Pattern="Solid"/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s86" ss:Parent="s16">')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s87" ss:Parent="s16">')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#E46D0A" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s88" ss:Parent="s16">')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#93CDDD" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s89" ss:Parent="s16">')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml('  <Style ss:ID="s90" ss:Parent="s16">')
gXml('   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>')
gXml('   <Interior ss:Color="#FAC090" ss:Pattern="Solid"/>')
gXml('   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>')
gXml('  </Style>')
gXml(' </Styles>')
 

//Aba
gXml( '<Worksheet ss:Name="Inventário Diário">')
	
//--Montagem da Tabela e cabeaçalho
gXml(  '<Table ss:ExpandedColumnCount="15" ss:ExpandedRowCount="'+allTrim(str(nLin+2))+'" x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="187.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="266.25"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="135"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="135"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="135"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="135"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="135"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="108.75"/>')
gXml(   '<Column ss:AutoFitWidth="0" ss:Width="92.5"/>')
gXml(   '<Row ss:Height="45">')
gXml(    '<Cell ss:MergeAcross="11" ss:StyleID="s65"><Data ss:Type="String">INVENTÁRIO DIARIO</Data></Cell>')
gXml(    '<Cell ss:MergeAcross="2"  ss:StyleID="s65"><Data ss:Type="DateTime">'+dtExcel(mv_par02)+'T00:00:00.000</Data></Cell>')
gXml(   '</Row>')
gXml(   '<Row ss:AutoFitHeight="0" ss:Height="50.0625">')
gXml(    '<Cell ss:StyleID="s68"><Data ss:Type="String">CODIGO WHB</Data></Cell>')
gXml(    '<Cell ss:StyleID="s68"><Data ss:Type="String">DESCRIÇÃO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s68"><Data ss:Type="String">PESO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s70"><Data ss:Type="String">EXPEDIÇÃO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s70"><Data ss:Type="String">TON</Data></Cell>')
gXml(    '<Cell ss:StyleID="s71"><Data ss:Type="String">ACABAMENTO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s71"><Data ss:Type="String">TON</Data></Cell>')
gXml(    '<Cell ss:StyleID="s72"><Data ss:Type="String">RETRABALHO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s72"><Data ss:Type="String">TON</Data></Cell>')
gXml(    '<Cell ss:StyleID="s73"><Data ss:Type="String">QUALIDADE INSPEÇÃO</Data></Cell>')
gXml(    '<Cell ss:StyleID="s73"><Data ss:Type="String">TON</Data></Cell>')
gXml(    '<Cell ss:StyleID="s73"><Data ss:Type="String">QUALIDADE ANALISE</Data></Cell>')
gXml(    '<Cell ss:StyleID="s73"><Data ss:Type="String">TON</Data></Cell>')
gXml(    '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL</Data></Cell>')
gXml(    '<Cell ss:StyleID="s74"><Data ss:Type="String">TON</Data></Cell>')
gXml(   '</Row>')

//Nova regua
procRegua(len(aCliente))
    
aTotalGeral := {0,0,0,0,0,0}

For s := 1 to len(aCliente)

	//Itens do cliente
	aLinhas := aCliente[s,2]

	//Cancelar?
	If lEnd; Return; Endif

	//Regua
	incProc("Imprimindo cliente: "+aCliente[s,1])
	
	For r := 1 to len(aLinhas)
		gXml(   '<Row ss:AutoFitHeight="0" ss:Height="24.9375">')
		gXml(    '<Cell ss:StyleID="s75"><Data ss:Type="String">'+aLinhas[r,1]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s76"><Data ss:Type="String">'+aLinhas[r,2]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s77"><Data ss:Type="Number">'+aLinhas[r,3]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s78"><Data ss:Type="Number">'+aLinhas[r,4]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-2]/1000)"/>')
		gXml(    '<Cell ss:StyleID="s78"><Data ss:Type="Number">'+aLinhas[r,5]+'</Data></Cell>') 
		gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-4]/1000)"/>')
		gXml(    '<Cell ss:StyleID="s78"><Data ss:Type="Number">'+aLinhas[r,6]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-6]/1000)"/>')
		gXml(    '<Cell ss:StyleID="s78"><Data ss:Type="Number">'+aLinhas[r,7]+'</Data></Cell>')
		gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-8]/1000)"/>')
		gXml(    '<Cell ss:StyleID="s78"><Data ss:Type="Number">'+aLinhas[r,8]+'</Data></Cell>')
	   	gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-10]/1000)"/>')
		gXml(    '<Cell ss:StyleID="s78" ss:Formula="=SUM(RC[-10]+RC[-8]+RC[-6]+RC[-4]+RC[-2])"/>')
		gXml(    '<Cell ss:StyleID="s79" ss:Formula="=INT(RC[-1]*RC[-12]/1000)"/>')
		gXml(   '</Row>')

		aTotalGeral[1] += (Val(aLinhas[r,3]) * Val(aLinhas[r,4])) / 1000
		aTotalGeral[2] += (Val(aLinhas[r,3]) * Val(aLinhas[r,5])) / 1000
		aTotalGeral[3] += (Val(aLinhas[r,3]) * Val(aLinhas[r,6])) / 1000
		aTotalGeral[4] += (Val(aLinhas[r,3]) * Val(aLinhas[r,7])) / 1000
		aTotalGeral[5] += (Val(aLinhas[r,3]) * Val(aLinhas[r,8])) / 1000
		aTotalGeral[6] += (Val(aLinhas[r,3]) * (Val(aLinhas[r,4])+Val(aLinhas[r,5])+Val(aLinhas[r,6])+Val(aLinhas[r,7])+Val(aLinhas[r,8]))) / 1000		
		
		//Cancelar?
		If lEnd; Return; Endif
	
	Next

	//Verifica se existe proximo cliente
	gXml(   '<Row ss:AutoFitHeight="0" ss:Height="27.75">')
	gXml(    '<Cell ss:StyleID="s80"><Data ss:Type="String">'+"TOTAL "+aCliente[s,1]+'</Data></Cell>')
	gXml(    '<Cell ss:Index="5"  ss:StyleID="s86" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(    '<Cell ss:Index="7"  ss:StyleID="s87" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(    '<Cell ss:Index="9"  ss:StyleID="s88" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(    '<Cell ss:Index="11" ss:StyleID="s89" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(    '<Cell ss:Index="13" ss:StyleID="s90" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(    '<Cell ss:Index="15" ss:StyleID="s90" ss:Formula="=SUM(R[-'+allTrim(str(len(aLinhas)))+']C:R[-1]C)"/>')
	gXml(   '</Row>')

Next(s)

	gXml(   '<Row ss:AutoFitHeight="0" ss:Height="27.75">')
	gXml(    '<Cell ss:StyleID="s80"><Data ss:Type="String">TOTAL GERAL</Data></Cell>')
	gXml(    '<Cell ss:Index="5"  ss:StyleID="s86"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[1],"999999999.9999"))+'</Data></Cell>')
	gXml(    '<Cell ss:Index="7"  ss:StyleID="s87"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[2],"999999999.9999"))+'</Data></Cell>')
	gXml(    '<Cell ss:Index="9"  ss:StyleID="s88"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[3],"999999999.9999"))+'</Data></Cell>')
	gXml(    '<Cell ss:Index="11" ss:StyleID="s89"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[4],"999999999.9999"))+'</Data></Cell>') 
	gXml(    '<Cell ss:Index="13" ss:StyleID="s90"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[5],"999999999.9999"))+'</Data></Cell>') 
	gXml(    '<Cell ss:Index="15" ss:StyleID="s90"><Data ss:Type="Number">'+allTrim(transForm(aTotalGeral[6],"999999999.9999"))+'</Data></Cell>')
	gXml(   '</Row>')

gXml(  '</Table>')
gXml(  '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
gXml(   '<PageSetup>')
gXml(    '<Header x:Margin="0.31496062000000002"/>')
gXml(    '<Footer x:Margin="0.31496062000000002"/>')
gXml(    '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024" x:Right="0.511811024" x:Top="0.78740157499999996"/>')
gXml(   '</PageSetup>')
gXml(   '<Unsynced/>')
gXml(   '<Print>')
gXml(    '<ValidPrinterInfo/>')
gXml(    '<HorizontalResolution>600</HorizontalResolution>')
gXml(    '<VerticalResolution>600</VerticalResolution>')
gXml(   '</Print>')
gXml(   '<Zoom>55</Zoom>')
gXml(   '<Selected/>')
gXml(   '<Panes>')
gXml(    '<Pane>')
gXml(     '<Number>3</Number>')
gXml(     '<ActiveRow>3</ActiveRow>')
gXml(     '<ActiveCol>3</ActiveCol>')
gXml(    '</Pane>')
gXml(   '</Panes>')
gXml(   '<ProtectObjects>False</ProtectObjects>')
gXml(   '<ProtectScenarios>False</ProtectScenarios>')
gXml(  '</WorksheetOptions>')
gXml(  '<ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">')
gXml(   '<Range>R4C15:R10C15</Range>')
gXml(   '<Condition>')
gXml(    '<Qualifier>Equal</Qualifier>')
gXml(    '<Value1>0</Value1>')
gXml(    '<Format Style="color:white"/>')
gXml(   '</Condition>')
gXml(  '</ConditionalFormatting>')
gXml( '</Worksheet>')
gXml('</Workbook>')

//--Fecha o Arquivo
fClose(nHandle)

//--Copia para o temp
CpyS2T(cDirDocs+"\"+cArquivo+".XML",cPath,.T.)

//--Abre o XML no excel
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".xml" )
oExcelApp:SetVisible(.T.)
oExcelApp:Destroy()

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! dtExcel                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Formata data para XML do excel                          !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function dtExcel(dData)

Local cRet := ""

cRet := strZero(Year(dData),4)
cRet += "-"
cRet += strZero(Month(dData),2)
cRet += "-"
cRet += strZero(Day(dData),2)

Return(cRet)

/*-----------------+---------------------------------------------------------+
!Nome              ! gXml                                                    !
+------------------+---------------------------------------------------------+
!Descrição         ! Grava no arquivo XML                                    !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function gXml(cTexto)
fWrite(nHandle,cTexto+chr(13)+chr(10))
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! AjustXml                                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Ajusta os campos para concatenar no arquivo XML         !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function AjustXml(aLinhas)

Local aRet  := {}
Local aJust := {}

For s := 1 to len(aLinhas)
	For r := 1 to len(aLinhas[s])

		//Se for caractere
		If ( valType(aLinhas[s,r]) == 'C' )

			//tira os espaços
			aAdd(aJust,allTrim(aLinhas[s,r]))

		//Se for numerico, usa transform
		ElseIf ( valType(aLinhas[s,r]) == 'N' )

			//tira os espaços
			aAdd(aJust,allTrim(transForm(aLinhas[s,r],"999999999.9999")))

		//Se for outro tipo, manda nada
		Else
			aAdd(aJust,"")
		Endif
	Next
	aAdd(aRet,aClone(aJust))
	aJust := {}
Next(s)

Return(aClone(aRet))


/*-----------------+---------------------------------------------------------+
!Nome              ! CriaSx1                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Cria perguntas                                          !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function CriaSx1()
//Data de Referencia
PutSx1(cPerg,"01","Busca Saldo Atual(SB2)?","Busca Saldo Atual(SB2)?","Busca Saldo Atual(SB2)?","mv_ch1","N",1,0,0,"C","",""   ,"","","mv_par01","Sim","Sim","Sim","","Data Referencia","Data Referencia","Data Referencia","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Data de Referencia
PutSx1(cPerg,"02","Data de Referencia?","Data de Referencia?","Data de Referencia?","mv_ch1","D",8,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Origem do saldo
PutSx1(cPerg,"03","Saldo do Dia ?","Saldo do Dia ?","Saldo do Dia ?","mv_ch2","N",1,0,0,"C","",""   ,"","","mv_par03","Inicial","Inicial","","Inicial","Final","Final","Final","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Grupo de produto de até
PutSx1(cPerg,"04","Grupo Produto de?"  ,"Grupo Produto de?"  ,"Grupo Produto de?"  ,"mv_ch3","C",4,0,0,"G","","SBM","","","mv_par04","","","","","","","","","","","","","","","","",{"","","",""},{"","","","" },{"","",""},"")
PutSx1(cPerg,"05","Grupo Produto até?" ,"Grupo Produto até?" ,"Grupo Produto até?" ,"mv_ch4","C",4,0,0,"G","","SBM","","","mv_par05","","","","","","","","","","","","","","","","",{"","","",""},{"","","","" },{"","",""},"")
//Produto de até
putSx1(cPerg,"06","Produto de?" ,"Produto de?" ,"Produto de?" ,"mv_ch5","C",15,0,0,"G","","SB1","","","mv_par06","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"07","Produto ate?","Produto ate?","Produto ate?","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par07","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Mostra Saldo Zero
PutSx1(cPerg,"08","Mostra Saldo Zero?","Mostra Saldo Zero?","Mostra Saldo Zero?","mv_ch8","N",1,0,0,"C","","","","","mv_par08","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
Return