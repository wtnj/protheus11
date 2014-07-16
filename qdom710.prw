/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QDOM710   ºAutor  ³Microsiga           º Data ³  24/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza documento do Word.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function qdom710()

SetPrvt("aRevisao,_nPosQDH,_nOrdQDH,_cFiltro,_cDocto,_aRev1,_aRev2,_aRev3,_cMemo1")
SetPrvt("_cDescArea,_cDescSpro,dRedeDoc,_aRev4,nPrgDisa")

//Variaveis do .DOT Padrao
OLE_SetDocumentVar( oWord, "Adv_NomeFilial"        , cNomFilial )                                            	        //01 - Filial do Sistema
OLE_SetDocumentVar( oWord, "Adv_CopiaControlada"   , cTpCopia )                                              	        //02 - Copia Controlada
OLE_SetDocumentVar( oWord, "Adv_Cancel"            , If( M->QDH_CANCEL == 'S','Situação: Documento Cancelado',' ' ) )   //03 - Cancelado
OLE_SetDocumentVar( oWord, "Adv_Obsoleto"          , If( M->QDH_OBSOL  == 'S','Situação: Documento Obsoleto' ,' ' ) )	//04 - Obsoleto
OLE_SetDocumentVar( oWord, "Adv_DTpDoc"            , QDXFNANTPD( M->QDH_CODTP, .t. ) )                     	            //05 - Tipo
OLE_SetDocumentVar( oWord, "Adv_DataVigencia"      , DtoC( M->QDH_DTVIG ) )                                          	//06 - Data de Vigencia
OLE_SetDocumentVar( oWord, "Adv_Titulo"            , M->QDH_TITULO )                                  	             	//07 - Titulo
OLE_SetDocumentVar( oWord, "Adv_Objetivo"          , cObjetivo )                        								//08 - Objetivo
OLE_SetDocumentVar( oWord, "Adv_NUsrR"             , cNomRece )                                                     	//09 - Destinatario
OLE_SetDocumentVar( oWord, "Adv_CodProd"           , M->QDH_PRODUT )                                  	            	//46 - Código do Produto
OLE_SetDocumentVar( oWord, "Adv_RevDes"            , M->QDH_REVDES )                                  	     	//50 - Revisão do Desenho
OLE_SetDocumentVar( oWord, "Adv_DescProd"          , M->QDH_DESCR )                                  	     	   //47 - Descrição do Produto
OLE_SetDocumentVar( oWord, "Adv_NomeClien"         , M->QDH_DCLIEN )                                  	     	//48 - Nome Cliente
OLE_SetDocumentVar( oWord, "Adv_Proces"            , M->QDH_PROCES )                                  	     	//49 - Processista
OLE_SetDocumentVar( oWord, "Adv_Desenh"            , IIF(ALLTRIM(M->QDH_DESENH)=="S","Sim","Nao"))                                  	     	

If Empty( cNomRece )
   OLE_SetDocumentVar( oWord, "Adv_NDeptoR"        , " " )
Else                                                                                                        	
   OLE_SetDocumentVar( oWord, "Adv_NDeptoR"        , QA_NDEPT( QDG->QDG_DEPTO,.T.,QDG->QDG_FILMAT) )     
Endif
OLE_SetDocumentVar( oWord, "Adv_NDeptoD"           , QA_nDeptos( M->QDH_FILIAL, M->QDH_DOCTO, M->QDH_RV ) ) 	
OLE_SetDocumentVar( oWord, "Adv_Sumario"           , cSumario )                                            	   
OLE_SetDocumentVar( oWord, "Adv_MotivoRevisao"     , cMotRevi )                                             	
OLE_SetDocumentVar( oWord, "Adv_ApelidoElaborador" , cElabora )                                             	
OLE_SetDocumentVar( oWord, "Adv_ApelidoRevisor"    , cApRevis )                                             	
OLE_SetDocumentVar( oWord, "Adv_ApelidoAprovador"  , cAprovad )                                             	
OLE_SetDocumentVar( oWord, "Adv_ApelidoHomologador", cApHomol )                                             	
OLE_SetDocumentVar( oWord, "Adv_Docto"             , Alltrim( M->QDH_DOCTO ) )                              	
OLE_SetDocumentVar( oWord, "Adv_Rv"                , M->QDH_RV )                                            	
OLE_SetDocumentVar( oWord, "Adv_Rodape"            , cRodape )                                              	
OLE_SetDocumentVar( oWord, "Adv_MdpCodigo",             cCodAtu )                                             
OLE_SetDocumentVar( oWord, "Adv_MdpNovCod",             cCodNov )                                             
OLE_SetDocumentVar( oWord, "Adv_MdsDescr",              cDescr  )                                             
OLE_SetDocumentVar( oWord, "Adv_MdpDe",                 cDe )                                             
OLE_SetDocumentVar( oWord, "Adv_MdpPara",               cPara )                                           
OLE_SetDocumentVar( oWord, "Adv_MdpRaz",                cMdpRaz )                                         
OLE_SetDocumentVar( oWord, "Adv_MdpObs",                cMdpObs )                                         
OLE_SetDocumentVar( oWord, "Adv_MdsRaz",                cMdsRaz )                                         
OLE_SetDocumentVar( oWord, "Adv_DataEmissao",           DtoC( cDtEmiss ) )
OLE_SetDocumentVar( oWord, "Adv_MdsObs",                cMdsObs )                                         
OLE_SetDocumentVar( oWord, "Adv_Instr",                 M->QDH_INSTR)
OLE_SetDocumentVar( oWord, "Adv_Familia",               M->QDH_FAMILI)
OLE_SetDocumentVar( oWord, "Adv_Maquin",                M->QDH_MAQUIN)
OLE_SetDocumentVar( oWord, "Adv_Veicon",                M->QDH_VEICON)
OLE_SetDocumentVar( oWord, "Adv_DescOp",                M->QDH_DESCOP)

If     M->QDH_STPRO == "1"
   cStPro1 := "X"
   cStPro2 := Space(01)
   cStPro3 := Space(01)
   // Plano de Controle Fundicao
   cStDesc := "PROTOTIPO"
Elseif M->QDH_STPRO == "2"
   cStPro2 := "X"
   cStPro1 := Space(01)
   cStPro3 := Space(01)
   cStDesc := "PRE-LANCAMENTO"   
Elseif M->QDH_STPRO == "3"
   cStPro3 := "X"
   cStPro1 := Space(01)
   cStPro2 := Space(01)
   cStDesc := "PRODUCAO"   
Else
   cStPro3 := Space(01)
   cStPro1 := Space(01)
   cStPro2 := Space(01)
   cStDesc := Space(20)
Endif   

OLE_SetDocumentVar( oWord, "Adv_StDesc"            , cStDesc) 
OLE_SetDocumentVar( oWord, "Adv_StPro1"            , cStPro1) 
OLE_SetDocumentVar( oWord, "Adv_StPro2"            , cStPro2) 
OLE_SetDocumentVar( oWord, "Adv_StPro3"            , cStPro3) 
OLE_SetDocumentVar( oWord, "Adv_ProRml"            , M->QDH_PRORML )                                        //   - Ramal Processista
OLE_SetDocumentVar( oWord, "Adv_AprMsa"            , M->QDH_APRMSA )                                        //   - Aprovacao MSA    
OLE_SetDocumentVar( oWord, "Adv_DtApMs"            , M->QDH_DTAPMS )                                        //   - Data de Aprovacao MSA 
OLE_SetDocumentVar( oWord, "Adv_AprEng"            , M->QDH_APRENG )                                        //   - Aprovacao Engenharia
OLE_SetDocumentVar( oWord, "Adv_DtApEn"            , M->QDH_DTAPEN )                                        //   - Data de Aprovacao Engenharia
OLE_SetDocumentVar( oWord, "Adv_DtApCl"            , M->QDH_DTAPCL )                                        //   - Data Aprovacao Cliente
OLE_SetDocumentVar( oWord, "Adv_EqApq"             , M->QDH_EQAPQ  )                                        //   - Equipe APQP              
OLE_SetDocumentVar( oWord, "Adv_AprCli"            , M->QDH_APRCLI )                                        //   - Aprovacao Cliente        
OLE_SetDocumentVar( oWord, "Adv_CodNor"            , M->QDH_CODNOR )                                        //   - Codigo da Norma
OLE_SetDocumentVar( oWord, "Adv_DtReno"            , M->QDH_DTRENO )                                        //   - Data de revisao      
OLE_SetDocumentVar( oWord, "Adv_Idioma"            , M->QDH_IDIOMA )                                        //   - Idioma
OLE_SetDocumentVar( oWord, "Adv_Folhas"            , M->QDH_FOLHAS )                                        //   - Folhas
OLE_SetDocumentVar( oWord, "Adv_Dtincn"            , M->QDH_DTINCN )                                        //   - Data de inclusao no sistema
OLE_SetDocumentVar( oWord, "Adv_Instit"            , M->QDH_INSTIT )                                        //   - Instituicao
OLE_SetDocumentVar( oWord, "Adv_InReNo"            , M->QDH_INRENO )                                        //   - Indice de Revisao
OLE_SetDocumentVar( oWord, "Adv_Niveln"            , M->QDH_NIVELN )                                        //   - Nivel da Norma   
OLE_SetDocumentVar( oWord, "Adv_Ncopia"            , M->QDH_NCOPIA )                                        //   - Numero de Copias
OLE_SetDocumentVar( oWord, "Adv_Profin"            , M->QDH_PROFIN )                                        //    
OLE_SetDocumentVar( oWord, "Adv_Protip"            , M->QDH_PROTIP )                                        // 
OLE_SetDocumentVar( oWord, "Adv_DtRede"            , M->QDH_DTREDE )                                        // 
OLE_SetDocumentVar( oWord, "Adv_Rev"               , M->QDH_REVDES )                                        // 
OLE_SetDocumentVar( oWord, "Adv_NorAss"            , M->QDH_NORASS )                                        // 
OLE_SetDocumentVar( oWord, "Adv_Locali"            , M->QDH_LOCALI )                                        //   
OLE_SetDocumentVar( oWord, "Adv_ItemNorma"         , M->QDH_ITNOR )                                         //   - Item da Norma 
OLE_SetDocumentVar( oWord, "Adv_DtRevDoc"          , M->QDH_DTRVD )                                         //   - Data de Revisao do Documento

OLE_SetDocumentVar( oWord, "Adv_Dtcad"             , M->QDH_DTCAD )                                         //   - Data de Inclusao do Documento.

nPrgDisa := 0
cCodAP5 := Space(15)
dRedeDoc := Ctod(Space(8))
If !Empty(M->QDH_PRODUT)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+M->QDH_PRODUT))
	If SB1->(Found())
		cCodAP5 := SB1->B1_CODAP5
		dRedeDoc := SB1->B1_REDEDOC
		If SM0->M0_CODIGO = 'FN'	
			nPrgDisa := SB1->B1_PRGDISA
		Endif	
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_CodAp5"            , cCodAp5)
OLE_SetDocumentVar( oWord, "Adv_RedeDoc"           , dRedeDoc)

cProdG1  := IIF(!Empty(M->QDH_PRODUT),M->QDH_PRODUT  + "/" + M->QDH_REVDES  + "  "," ")
cProdG2  := IIF(!Empty(M->QDH_PRODU2),M->QDH_PRODU2  + "/" + M->QDH_REVDE2  + "  "," ")
cProdG3  := IIF(!Empty(M->QDH_PRODU3),M->QDH_PRODU3  + "/" + M->QDH_REVDE3  + "  "," ")
cProdG4  := IIF(!Empty(M->QDH_PRODU4),M->QDH_PRODU4  + "/" + M->QDH_REVDE4  + "  "," ")
cProdG5  := IIF(!Empty(M->QDH_PRODU5),M->QDH_PRODU5  + "/" + M->QDH_REVDE5  + "  "," ")
cProdG6  := IIF(!Empty(M->QDH_PRODU6),M->QDH_PRODU6  + "/" + M->QDH_REVDE6  + "  "," ")
cProdG7  := IIF(!Empty(M->QDH_PRODU7),M->QDH_PRODU7  + "/" + M->QDH_REVDE7  + "  "," ")
cProdG8  := IIF(!Empty(M->QDH_PRODU8),M->QDH_PRODU8  + "/" + M->QDH_REVDE8  + "  "," ")
cProdG9  := IIF(!Empty(M->QDH_PRODU9),M->QDH_PRODU9  + "/" + M->QDH_REVDE9  + "  "," ")
cProdGA  := IIF(!Empty(M->QDH_PRODUA),M->QDH_PRODUA  + "/" + M->QDH_REVDEA  + "  "," ")
cProdGB  := IIF(!Empty(M->QDH_PRODUB),M->QDH_PRODUB  + "/" + M->QDH_REVDEB  + "  "," ")
cProdGC  := IIF(!Empty(M->QDH_PRODUC),M->QDH_PRODUC  + "/" + M->QDH_REVDEC  + "  "," ")
cProdGD  := IIF(!Empty(M->QDH_PRODUD),M->QDH_PRODUD  + "/" + M->QDH_REVDED  + "  "," ")
cProdGE  := IIF(!Empty(M->QDH_PRODUE),M->QDH_PRODUE  + "/" + M->QDH_REVDEE  + "  "," ")
cProdGF  := IIF(!Empty(M->QDH_PRODUF),M->QDH_PRODUF  + "/" + M->QDH_REVDEF  + "  "," ")
cProdGG  := IIF(!Empty(M->QDH_PRODUG),M->QDH_PRODUG  + "/" + M->QDH_REVDEG  + "  "," ")
cProdGH  := IIF(!Empty(M->QDH_PRODUH),M->QDH_PRODUH  + "/" + M->QDH_REVDEH  + "  "," ")
cProdGI  := IIF(!Empty(M->QDH_PRODUI),M->QDH_PRODUI  + "/" + M->QDH_REVDEI  + "  "," ")
cProdGJ  := IIF(!Empty(M->QDH_PRODUJ),M->QDH_PRODUJ  + "/" + M->QDH_REVDEJ  + "  "," ")
cProdGL  := IIF(!Empty(M->QDH_PRODUL),M->QDH_PRODUL  + "/" + M->QDH_REVDEL  + "  "," ")

OLE_SetDocumentVar( oWord, "Adv_ProdG1"  , cProdG1)
OLE_SetDocumentVar( oWord, "Adv_ProdG2"  , cProdG2)
OLE_SetDocumentVar( oWord, "Adv_ProdG3"  , cProdG3)
OLE_SetDocumentVar( oWord, "Adv_ProdG4"  , cProdG4)
OLE_SetDocumentVar( oWord, "Adv_ProdG5"  , cProdG5)
OLE_SetDocumentVar( oWord, "Adv_ProdG6"  , cProdG6)
OLE_SetDocumentVar( oWord, "Adv_ProdG7"  , cProdG7)
OLE_SetDocumentVar( oWord, "Adv_ProdG8"  , cProdG8)
OLE_SetDocumentVar( oWord, "Adv_ProdG9"  , cProdG9)
OLE_SetDocumentVar( oWord, "Adv_ProdGA"  , cProdGA)
OLE_SetDocumentVar( oWord, "Adv_ProdGB"  , cProdGB)
OLE_SetDocumentVar( oWord, "Adv_ProdGC"  , cProdGC)
OLE_SetDocumentVar( oWord, "Adv_ProdGD"  , cProdGD)
OLE_SetDocumentVar( oWord, "Adv_ProdGE"  , cProdGE)
OLE_SetDocumentVar( oWord, "Adv_ProdGF"  , cProdGF)                          
OLE_SetDocumentVar( oWord, "Adv_ProdGG"  , cProdGG)
OLE_SetDocumentVar( oWord, "Adv_ProdGH"  , cProdGH)
OLE_SetDocumentVar( oWord, "Adv_ProdGI"  , cProdGI)
OLE_SetDocumentVar( oWord, "Adv_ProdGJ"  , cProdGJ)
OLE_SetDocumentVar( oWord, "Adv_ProdGL"  , cProdGL)

cAp5P1 := Space(15)
If !Empty(cProdG1)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG1))
	If SB1->(Found())
		cAp5P1 := SB1->B1_CODAP5
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P1" , cAp5P1)

cAp5P2 := Space(15)
cDesP2 := Space(30)
cDesP3 := Space(30)
cDesP4 := Space(30)
cDesP5 := Space(30)
cDesP6 := Space(30)
cDesP7 := Space(30)

If !Empty(cProdG2)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG2))
	If SB1->(Found())
		cAp5P2 := SB1->B1_CODAP5
		cDesP2 := SB1->B1_DESC
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P2" , cAp5P2)
OLE_SetDocumentVar( oWord, "Adv_DesP2" , cDesP2)

cAp5P3 := Space(15)
If !Empty(cProdG3)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG3))
	If SB1->(Found())
		cAp5P3 := SB1->B1_CODAP5
		cDesP3 := SB1->B1_DESC
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P3" , cAp5P3)
OLE_SetDocumentVar( oWord, "Adv_DesP3" , cDesP3)

cAp5P4 := Space(15)
If !Empty(cProdG4)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG4))
	If SB1->(Found())
		cAp5P4 := SB1->B1_CODAP5
		cDesP4 := SB1->B1_DESC
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P4" , cAp5P4)
OLE_SetDocumentVar( oWord, "Adv_DesP4" , cDesP4)

cAp5P5 := Space(15)
If !Empty(cProdG5)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG5))
	If SB1->(Found())
		cAp5P5 := SB1->B1_CODAP5
		cDesP5 := SB1->B1_DESC		
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P5" , cAp5P5)
OLE_SetDocumentVar( oWord, "Adv_DesP5" , cDesP5)

cAp5P6 := Space(15)
If !Empty(cProdG6)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProdG6))
	If SB1->(Found())
		cAp5P6 := SB1->B1_CODAP5
		cDesP6 := SB1->B1_DESC		
	Endif
Endif	
OLE_SetDocumentVar( oWord, "Adv_Ap5P6" , cAp5P6)
OLE_SetDocumentVar( oWord, "Adv_DesP6" , cDesP6)


If SM0->M0_CODIGO = 'FN'	
	OLE_SetDocumentVar( oWord, "Adv_TitEng" , M->QDH_TITENG)
Endif
OLE_SetDocumentVar( oWord, "Adv_PrgDis" , nPrgDisa)
OLE_SetDocumentVar( oWord, "Adv_CPastaR", QDG->QDG_CODMAN )                                      //Pasta ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_NPastaR", QDXFNANMAN( QDG->QDG_CODMAN, .t., QDJ->QDJ_FILMAT ) )  //Pasta ( Nome )
OLE_SetDocumentVar( oWord, "Adv_DeptoD",  M->QDH_DEPTOD )                                        //Departamento Recebedores - Distribuicao ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_DeptoR",  QDG->QDG_DEPTO )                                       //Departamento do Destinatario ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_CDeptoUsr", cMatDep )                                            //Usuario do sistema ( Codigo - Depto )
OLE_SetDocumentVar( oWord, "Adv_NDeptoUsr",  QA_nDept( cMatDep, .t., cFilAnt ) )                 //Usuario do sistema ( Nome - Depto )

// QDH->QDH_DOCTO
// Outras variaveis ja definidas que podem ser utilizadas

OLE_SetDocumentVar( oWord, "Adv_ApelidoDestino",     QA_nUsr( cFilApDes, cCodApDes, .t., "A" ) )            //20 - Destinatario ( Apelido ) 
OLE_SetDocumentVar( oWord, "Adv_ApelidoSolicitante", QA_nUsr( cFilApSol, cCodApSol, .t., "A" ) )            //21 - Solicitante ( Apelido ) *** Quando de uma solicitacao de alteracao ***
OLE_SetDocumentVar( oWord, "Adv_Elaborador",         cElabora )                                             //22 - Elaborador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Revisor",            cRevisor )                                             //23 - Revisor ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Aprovador",          cAprovad )                                             //24 - Aprovador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Homologador",        cHomolog )                                             //25 - Homologador ( Nome ) 
OLE_SetDocumentVar( oWord, "Adv_Ass1",               QDXFNANASS( M->QDH_CODASS, .t. ) )                     //26 - Assunto ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass2",               QDXFNANASS( M->QDH_CODAS1, .t. ) )                     //27 - Assunto 1 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass3",               QDXFNANASS( M->QDH_CODAS2, .t. ) )                     //28 - Assunto 2 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass4",               QDXFNANASS( M->QDH_CODAS3, .t. ) )                     //29 - Assunto 3 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass5",               QDXFNANASS( M->QDH_CODAS4, .t. ) )                     //30 - Assunto 4 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_CodUsr",             cMatCod )                                              //31 - Usuario do sistema ( Matricula )
OLE_SetDocumentVar( oWord, "Adv_CDeptoUsr",          cMatDep )                                              //32 - Usuario do sistema ( Codigo - Depto )
OLE_SetDocumentVar( oWord, "Adv_NDeptoUsr",          QA_nDept( cMatDep, .t., cFilAnt ) )                    //33 - Usuario do sistema ( Nome - Depto )
OLE_SetDocumentVar( oWord, "Adv_CRespR",             SI3->I3_MAT )                                          //34 - Responsavel pelo Centro de Custo ( Matricula )
OLE_SetDocumentVar( oWord, "Adv_DeptoD",             M->QDH_DEPTOD )                                        //35 - Departamento Recebedores - Distribuicao ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_DeptoE",             M->QDH_DEPTOE )                                        //36 - Departamento Elaborador ( Codigo ) 
OLE_SetDocumentVar( oWord, "Adv_NDeptoE",            QA_nDept( M->QDH_DEPTOE, .t., M->QDH_FILMAT ) )        //37 - Departamento Elaborador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_CPastaR",            QDG->QDG_CODMAN )                                      //38 - Pasta ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_NPastaR",            QDXFNANMAN( QDG->QDG_CODMAN, .t., QDJ->QDJ_FILMAT ) )  //39 - Pasta ( Nome )
OLE_SetDocumentVar( oWord, "Adv_DeptoR",             QDG->QDG_DEPTO )                                       //40 - Departamento do Destinatario ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_NRespR",             QA_nUsr( SI3->I3_FILMAT, SI3->I3_MAT ) )               //41 - Responsavel pelo Departamento doDestinatario ( Nome )
OLE_SetDocumentVar( oWord, "Adv_DataEmissao",        DtoC( cDtEmiss ) )                                     //42 - Data de Emissao
OLE_SetDocumentVar( oWord, "Adv_DataValidade",       DtoC( M->QDH_DTLIM ) )                                 //43 - Data de Validade
OLE_SetDocumentVar( oWord, "Adv_DataImplantacao",    DtoC( M->QDH_DTIMPL ) )                                //44 - Data de Implantacao
OLE_SetDocumentVar( oWord, "Adv_DataDistribuicao",   DtoC( QD1->QD1_DTGERA ) )                              //45 - Data de Distribuicao


cNDepde :=  ""
QAD->(DbSetOrder(1))
QDJ->(DbSetOrder(1))
QDJ->(DbSeek(xFilial("QDJ")+M->QDH_DOCTO))
While QDJ->(!Eof()) .And. QDJ->QDJ_DOCTO == M->QDH_DOCTO
	QAD->(DbSeek(xFilial("QAD")+QDJ->QDJ_DEPTO))
	If QAD->(Found())              
		cNdepde += Alltrim(QAD->QAD_DESC) + ","  
	Endif	
	QDJ->(DbSkip())
Enddo

// 


aRevisao := {}
_nPosQDH := QDH->(Recno())
_nOrdQDH := QDH->(IndexOrd())
_cFiltro := QDH->(DbFilter())
_cDocto  := M->QDH_DOCTO

DbSelectArea("QDH")
QDH->(DbSetOrder(1))
Set Filter To
QDH->(DbSeek(xFilial("QDH")+_cDocto))
While QDH->(!Eof()) .And. QDH->QDH_FILIAL+QDH->QDH_DOCTO == xFilial("QDH")+_cDocto
	If QA2->(DbSeek(xFilial("QA2")+"REV     "+QDH->QDH_CHAVE))
		If Ascan(aRevisao, DTOS(QDH->QDH_DTRVD) + " " + QDH->QDH_RV + " " + QA2->QA2_TEXTO)==0
			AADD(aRevisao, DTOS(QDH->QDH_DTRVD) + " " + QDH->QDH_RV + " " + QA2->QA2_TEXTO)
		Endif
	Endif
	QDH->(DbSkip())
Enddo

DbSelectArea("QDH")
DbSetOrder(_nOrdQDH)
//Set Filter To &(_cFiltro)
DbGoto(_nPosQDH)

_aRev1 := Space(255)
_aRev2 := Space(255)
_aRev3 := Space(255)
_aRev4 := Space(10)
_aRev5 := Space(10)
_aRev6 := Space(10)

If Len(aRevisao) >= 3
 	_aRev1 := aRevisao[Len(aRevisao)]
	_aRev2 := aRevisao[Len(aRevisao)-1]	
	_aRev3 := aRevisao[Len(aRevisao)-2]	
	_aRev4 := QDH->QDH_PROCES
	_aRev5 := QDH->QDH_PROCES	
	_aRev6 := QDH->QDH_PROCES	
Elseif Len(aRevisao) == 2
	_aRev1 := aRevisao[Len(aRevisao)]
	_aRev2 := aRevisao[Len(aRevisao)-1]	
	_aRev4 := QDH->QDH_PROCES	
	_aRev5 := QDH->QDH_PROCES	
Elseif Len(aRevisao) == 1
	_aRev1 := aRevisao[Len(aRevisao)]
	_aRev4 := QDH->QDH_PROCES	
Endif

OLE_SetDocumentVar( oWord, "Adv_Drev1"  ,Substr(_aRev1,7,2) + '/' + Substr(_aRev1,5,2) + '/' + Substr(_aRev1,1,4))
OLE_SetDocumentVar( oWord, "Adv_Drev2"  ,Substr(_aRev2,7,2) + '/' + Substr(_aRev2,5,2) + '/' + Substr(_aRev2,1,4))
OLE_SetDocumentVar( oWord, "Adv_Drev3"  ,Substr(_aRev3,7,2) + '/' + Substr(_aRev3,5,2) + '/' + Substr(_aRev3,1,4))
OLE_SetDocumentVar( oWord, "Adv_Nrev1"  ,Substr(_aRev1,10,3))
OLE_SetDocumentVar( oWord, "Adv_Nrev2"  ,Substr(_aRev2,10,3))
OLE_SetDocumentVar( oWord, "Adv_Nrev3"  ,Substr(_aRev3,10,3))
OLE_SetDocumentVar( oWord, "Adv_Hrev1"  ,Substr(_aRev1,14,230))
OLE_SetDocumentVar( oWord, "Adv_Hrev2"  ,Substr(_aRev2,14,230))
OLE_SetDocumentVar( oWord, "Adv_Hrev3"  ,Substr(_aRev3,14,230))
OLE_SetDocumentVar( oWord, "Adv_Ndepde" , cNdepde)
_cMemo1 := MSMM(QD2->QD2_PROTOC)
OLE_SetDocumentVar( oWord, "Adv_Memo1" ,_cMemo1)
OLE_SetDocumentVar( oWord, "Adv_Mrev1" ,_aRev4)
OLE_SetDocumentVar( oWord, "Adv_Mrev2" ,_aRev5)
OLE_SetDocumentVar( oWord, "Adv_Mrev3" ,_aRev6)

_cDescArea := Space(30)
SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"ZC")) // Tabela de Area
While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZC"
   If Alltrim(SX5->X5_CHAVE) == Alltrim(M->QDH_AREA)
      _cDescArea := SX5->X5_DESCRI
      Exit
   Endif
   SX5->(DbSkip())
Enddo
OLE_SetDocumentVar( oWord, "Adv_DescArea" , _cDescArea)
OLE_SetDocumentVar( oWord, "Adv_Area" , M->QDH_AREA)

_cDescSpro := Space(30)
SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"ZI")) // Tabela de Sub-Processo
While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZI"
   If Alltrim(SX5->X5_CHAVE) == Alltrim(M->QDH_SUBPRO)
      _cDescSpro := SX5->X5_DESCRI
      Exit
   Endif
   SX5->(DbSkip())
Enddo
OLE_SetDocumentVar( oWord, "Adv_DescSpro" , _cDescSpro) 
OLE_SetDocumentVar( oWord, "Adv_SubPro" , M->QDH_SUBPRO)


_cCodFor := Space(15)
// Pesquisa Cliente
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+M->QDH_CLIENT + M->QDH_LOJA))
If SA1->(Found())
	_cCodFor := SA1->A1_CODFOR
Endif
OLE_SetDocumentVar( oWord, "Adv_CodFor" , _cCodFor)
OLE_SetDocumentVar( oWord, "Adv_CodEng" , Substr(M->QDH_PRODUT,1,3)+"."+Substr(M->QDH_PRODUT,9,4))

OLE_SetDocumentVar( oWord, "Adv_NomAnalis" , M->QDH_NOMAQ)
OLE_SetDocumentVar( oWord, "Adv_CodAnalis" , M->QDH_CODAQ)

Return