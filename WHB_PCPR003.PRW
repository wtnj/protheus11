/*---------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! SIGAPCP                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_PCPR003                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Relatório Moldagem Diária                               !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 27/08/2010                                              !
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

user Function pWhbr003()

Local oReport

Private cPerg := padr("PWHBR003",10)

//Cria as perguntas se não existirem
criaSx1()
Pergunte(cPerg, .F.)

//Monta Estrutura
oReport := ReportDef()
//Executa o relatório
oReport:PrintDialog() 

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! reportDef                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Funcao para montagem da estrutura do relatório          !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function reportDef()

Local cTitle    := OemToAnsi("Moldagem Diária.")
Local cHelp     := OemToAnsi("Relatório Moldagem Diária.")
Local oReport
Local oMoldagem
Local oQuebra
Local cAl     := getNextAlias()

//Criacao do componente de impressao
oReport := tReport():New("PWHBR003",cTitle,cPerg,{|oReport| ReportPrint(oReport,cAl)},cHelp)

oReport:SetLandScape()
//oReport:SetLandScape()

//Desabilita botão dos parametros
oReport:HideParamPage(.F.)

//Estrutura
oMoldagem := trSection():New(oReport,"Moldagem Diária.",{"SD3","SC2","SB1"},,,,,,.t.)
	trCell():New(oMoldagem,"D3_EMISSAO","SD3","Data"         ,pesqPict("SD3","D3_EMISSAO"),tamSx3("D3_EMISSAO")[1]+2)
	trCell():New(oMoldagem,"D3_DTFUNDI","SD3","Fundição"     ,pesqPict("SD3","D3_DTFUNDI"),tamSx3("D3_DTFUNDI")[1]+2)
	trCell():New(oMoldagem,"B1_COD"    ,"SB1","Código"       ,pesqPict("SB1","B1_COD")    ,10)
	trCell():New(oMoldagem,"B1_DESC"   ,"SB1","Descrição"    ,pesqPict("SB1","B1_DESC")   ,15)
	trCell():New(oMoldagem,"D3_PESO"   ,"SD3","Peso"         ,"@E 999,999.99"             ,tamSx3("D3_PESO")[1]+3     )
	trCell():New(oMoldagem,"D3_PPLACA" ,"SD3","PC Placa"     ,pesqPict("SD3","D3_PPLACA") ,tamSx3("D3_PPLACA")[1]+1  ,,,"CENTER",,"CENTER")
	trCell():New(oMoldagem,"B1_PECJTRO","SB1","Peso Conj."   ,"@E 99999.99"               ,tamSx3("B1_PECJTRO")[1]+1 ,,,"CENTER",,"CENTER")
	trCell():New(oMoldagem,"B1_LIGA"   ,"SB1","Liga"         ,pesqPict("SB1","B1_LIGA")   ,   8                      ,,,"CENTER",,"CENTER")
	trCell():New(oMoldagem,"QTDEMOLDES",""   ,"Qtde.Moldes"  ,"@E 99999999"               ,tamSx3("D3_QUANT")[1]+1  ,,{||(cAl)->D3_QUANT/(cAl)->D3_PPLACA},"RIGHT",,"RIGHT")
	trCell():New(oMoldagem,"TONPECAS"  ,""   ,"Peças(Ton)"   ,pesqPict("SD3","D3_QUANT")  ,tamSx3("D3_QUANT")[1]+1  ,,{||((cAl)->D3_QUANT*(cAl)->D3_PESO)/1000},"RIGHT",,"RIGHT")
	trCell():New(oMoldagem,"TONMETLIQ" ,""   ,"Met.Liq.(Ton)",pesqPict("SD3","D3_QUANT")  ,tamSx3("D3_QUANT")[1]+1  ,,{||(((cAl)->D3_QUANT/(cAl)->D3_PPLACA)*(cAl)->B1_PECJTRO)/1000},"RIGHT",,"RIGHT")
	trCell():New(oMoldagem,"RENDIMENTO",""   ,"Rend.(%)"     ,"@!"                        ,2                        ,,{|| Transform((((cAl)->D3_PESO*(cAl)->D3_PPLACA)/(cAl)->B1_PECJTRO)*100,"99.99%") }   ,"RIGHT",,"RIGHT")
	trCell():New(oMoldagem,"C2XDISA"   ,""   ,"Disa"         ,"@!"                        ,6                        ,,{|| Iif(  (cAl)->C2XDISA=='1' .OR. (cAl)->C2XDISA=='2', (cAl)->C2XDISA , 'KW' ) }    ,"CENTER",,"CENTER")
	trCell():New(oMoldagem,"TURNO"     ,""   ,"Turno"        ,"@!"                        ,6 ,,,"CENTER",,"CENTER")
	trCell():New(oMoldagem,"D3_QUANT"  ,"SD3","Qtde.Peças"   ,"@E 99999999"               ,tamSx3("D3_QUANT")[1]+1  ,,,"RIGHT",,"RIGHT")
	trCell():New(oMoldagem,"C2_PROVA"  ,"SC2","Prova Eng."   ,"@!"                        ,15                       ,,{|| Iif((cAl)->C2PROVA=='S','Sim','Não')},"CENTER",,"CENTER")

//Totalização
oQuebra := trBreak():New(oMoldagem,oMoldagem:Cell("D3_EMISSAO"),{||"Total do Dia "+cDia+":"},.f.,"QUEBRA")

	trFunction():New(oMoldagem:Cell("D3_QUANT"  ),,"SUM",oQuebra,,,,.f.,.t.)
	trFunction():New(oMoldagem:Cell("TONPECAS"  ),,"SUM",oQuebra,,,,.f.,.t.)
	trFunction():New(oMoldagem:Cell("TONMETLIQ" ),,"SUM",oQuebra,,,,.f.,.t.)


Return(oReport)


/*-----------------+---------------------------------------------------------+
!Nome              ! reportPrint                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Funcao para processamento do dados                      !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function reportPrint(oReport,cAl)

Local oMoldagem := oReport:Section(1)
Local oQuebra   := oReport:Section(1):GetBreak("QUEBRA")
Local cDia      := ""
Local cWhere    := "%%"

If mv_par09==1 // prova eng sim
	cWhere := "% AND C2.C2_PROVA = 'S' %"
ElseIf mv_par09==2 //prova eng nao
	cWhere := "% AND C2.C2_PROVA <> 'S' %"
EndIf

oMoldagem:BeginQuery()
beginSql Alias cAl
	select
		D3.D3_EMISSAO
	,   D3.D3_DTFUNDI 
	,   substring(B1.B1_COD,1,3)+substring(B1.B1_COD,9,4) as B1_COD
	,   substring(B1.B1_DESC,1,15) as B1_DESC
/*	,   B1.B1_PESO
	,   B1.B1_PPLACA
*/	,   D3.D3_PESO
	,	D3.D3_PPLACA
	,   B1.B1_PECJTRO
	,   B1.B1_LIGA
	,   D3.D3_QUANT
	,   C2_DISA as C2XDISA
	,   D3_TURNO as TURNO
	,   C2_PROVA as C2PROVA
	from (  select
				D3.D3_OP
			,   D3.D3_COD
			,   D3.D3_EMISSAO
			,   D3.D3_DTFUNDI
			,   SUM(D3.D3_QUANT) as D3_QUANT
			,   D3.D3_TURNO
			,   D3.D3_PESO
			,	D3.D3_PPLACA			
			from
				%table:SD3% D3
			where
				D3.D3_FILIAL   = %xFilial:SD3%
			and D3.D3_CF       = 'PR0'
			and D3.D3_EMISSAO >= %Exp:dtos(mv_par01)%
			and D3.D3_EMISSAO <= %Exp:dtos(mv_par02)%
			and D3.D3_COD     >= %Exp:mv_par05%
			and D3.D3_COD     <= %Exp:mv_par06%
			and D3.D3_DTFUNDI >= %Exp:mv_par07%
			and D3.D3_DTFUNDI <= %Exp:mv_par08%
			and D3.D_E_L_E_T_  = ' '
			group by
				D3.D3_OP
			,   D3.D3_COD
			,   D3.D3_EMISSAO
			,   D3_DTFUNDI
			,   D3_TURNO
			,   D3.D3_PESO
			,	D3.D3_PPLACA			
		) D3
	inner join %table:SC2% C2
		on  C2.C2_FILIAL  = %xFilial:SC2%
		and C2.C2_NUM     = substring(D3.D3_OP,1,6)
		and C2.C2_ITEM    = substring(D3.D3_OP,7,2)
		and C2.C2_SEQUEN  = substring(D3.D3_OP,9,3)
		and C2.C2_PRODUTO = D3.D3_COD
		%Exp:cWhere%
		and C2.D_E_L_E_T_ = ' '
	inner join %table:SB1% B1
		on  B1.B1_FILIAL  = %xFilial:SB1%
		and B1.B1_COD    >= %Exp:mv_par05%
		and B1.B1_COD    <= %Exp:mv_par06%
		and B1.B1_COD     = D3.D3_COD
		and B1.B1_GRUPO  >= %Exp:mv_par03%
		and B1.B1_GRUPO  <= %Exp:mv_par04%
		and B1.B1_MSBLQL <> '1'
		and B1.D_E_L_E_T_ = ' '
	order by
		D3.D3_EMISSAO,
		D3_TURNO
		
endSql
oMoldagem:EndQuery()

//Regua
oReport:SetMeter((cAl)->(Reccount()))

//Inicia impressao da sessao
oMoldagem:Init()

//laço Verificicando se é fim de arquivo
While !(cAl)->(Eof()) .And. !oReport:Cancel()

	If cDia != dtoc((cAl)->D3_EMISSAO)
		oQuebra:SetTitle("Total do Dia "+cDia+":")
	Endif

	//imprime linha
	oMoldagem:PrintLine()
			
	cDia := dtoc((cAl)->D3_EMISSAO)

	//Pula linha
	(cAl)->(dbSkip())

	//Regua
	oReport:IncMeter()

Enddo

//Finaliza impressao da sessao
oQuebra:SetTitle("Total do Dia "+cDia+":")
oMoldagem:Finish()

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! criaSx1                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Funcao para cricao dos parametros                       !
+------------------+---------------------------------------------------------+
!Autor             !                                                         !
+------------------+--------------------------------------------------------*/
static Function CriaSx1()

//Data de até
putSx1(cPerg,"01","Data de?"          ,"Data de?"    ,"Data de?"    ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"02","Data ate?"         ,"Data ate?"   ,"Data ate?"   ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Grupo de até
putSx1(cPerg,"03","Grupo de?"         ,"Grupo de?"   ,"Grupo de?"   ,"mv_ch3","C",04,0,0,"G","","SBM","","","mv_par03","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"04","Grupo ate?"        ,"Grupo ate?"  ,"Grupo ate?"  ,"mv_ch4","C",04,0,0,"G","","SBM","","","mv_par04","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Produto de até
putSx1(cPerg,"05","Produto de?"       ,"Produto de?" ,"Produto de?" ,"mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"06","Produto ate?"      ,"Produto ate?","Produto ate?","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
//Data Fundicao de até
putSx1(cPerg,"07","Data Fundicao de?" ,"Data Fundicao de?" ,"Data Fundicao de?" ,"mv_ch7","C",06,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"08","Data Fundicao ate?","Data Fundicao ate?","Data Fundicao ate?","mv_ch8","C",06,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",{"","","",""},{"","","",""},{"","",""},"")
putSx1(cPerg,"09","Prova Eng.?"       ,"Prova Eng.?"       ,"Prova Eng.?"       ,"mv_ch9","N", 1,0,2,"C","","","","","mv_par09","Sim"      ,"Si"       ,"Yes"    ,"","Não"      ,"No"       ,"No"       ,"Ambos","Ambos"  ,"Ambos" ,""          ,""          ,""          ,"","", "", {"Prova Eng","","",""},{"Prova Eng","","",""},{"Prova Eng","",""},"")

Return