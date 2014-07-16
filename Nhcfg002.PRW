/*
+----------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! Configurador                                            !
+------------------+---------------------------------------------------------+
!Nome              ! Nhcfg002                                                !
+------------------+---------------------------------------------------------+
!Tabelas Utilizadas!                                                         !
+------------------+---------------------------------------------------------+
!Descrição         ! Relatório de Usuários/Permissões/Menus do Protheus      !
+------------------+---------------------------------------------------------+
!Autor             ! Rogerio Cassiano Lemos                                  !
+------------------+---------------------------------------------------------+
!Data de Criação   !                                                         !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descrição detalhada da atualização      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!Melhorias na impressão do relatório, inclu-!Rogerio de !Rogerio de !02/10/02!
!são de parâmetros.                         !Oliveira   !Oliveira   !        !
+-------------------------------------------+-----------+-----------+--------+
!Alterar a posicao do Eject logo abaixo do  ! J.Roberto !  Renato   !10/06/03!
!Set Device To Screen                       !           ! Ferreira  !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/   

#include "rwmake.ch"

User Function Nhcfg002()

/*
+---------------------------------------------------------------------+
| Declaracao de variaveis utilizadas no programa atraves da funcao    |
| SetPrvt, que criara somente as variaveis definidas pelo usuario,    |
| identificando as variaveis publicas do sistema utilizadas no codigo |
| Incluido pelo assistente de conversao do AP5 IDE                    |
+---------------------------------------------------------------------+
*/

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,CABEC3,WNREL")
SetPrvt("NORDEM,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,NPAG,CSTRING,ARETURN,NOMEPROG,MPAG")
SetPrvt("_CSINTE,ADRIVER,CDRIVER,CNORMAL,I,AEMP")
SetPrvt("ANOMMENU,AMENU,AAC,AACESSO,CID,AUM")
SetPrvt("_CID,_CNOME,_CNOMECOM,_DDTVAL,_LALTSEN,_LALTPRX")
SetPrvt("_CDEPART,_DDTULT,_CDIGANO,ADOIS,_CDIRREL,_CIMPPAD")
SetPrvt("_CACESSO,J,SS,ATRES,ZZ,CNIVEL")
SetPrvt("CARQTXT,ABRIUOK,NBYTES,TXT_EOF,CBUFFER,NHANDLE")
SetPrvt("_CORDEM,_CDESC,_CNOMEPRO,_CHABILI,_CARQABE,_COPCHAB")
SetPrvt("NCONTA,NLIST,_CDESACS,NREGISTRO,NLINHAS,_CTIPO")

/*
+--------------------------------------------------------------+
| Define Variaveis                                             |
+--------------------------------------------------------------+
*/

CbTxt:="";CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem  := 0
tamanho := "P"   // Tamanho do Layout do Relatorio    "P/M/G"
limite  := 080   // Limites de Colunas do Relatorio
cbcont  := 0
titulo  := "Registro de Inventario de Usuarios"
cDesc1  := "Usuarios Cadastrados no Protheus"
cDesc2  := ""
cDesc3  := ""
Cabec1  := ""
nPag    := 01
cString := "SA1"    // Arquivo que ira fazer a filtragem
aReturn := { "PREENCHER", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:= "NHCFG002"  // Nome do programa
wnrel   := "NHCFG002"
mpag   := 1

/*
+--------------------------------------------------------------+
| Variaveis utilizadas para parametros                         |
| mv_par01             // Nr. Nao Conformidade                 |
+--------------------------------------------------------------+
*/

Processa( {|| PERGUNTAS()  } )

wnrel:=SetPrint(cString,wnrel,"CFG002",Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

IF nLastKey == 27
   Return
ENDIF

SetDefault(aReturn,cString)

_cSinte := .f.

IF MsgBox( "Imprime Sintetico ? ", "Forma de Impressao", "YESNO" )
   _cSinte := .t.
Endif

Processa( {|| VALIDA() } )

RETURN

/*
+--------------------------------------------------------------+
| Função VALIDA()                                              |
+--------------------------------------------------------------+
*/

Static FUNCTION VALIDA()

   aDriver   := ReadDriver()
   cDriver   := aDriver[3]
   cNormal   := aDriver[2]

   Verif_User()

   TONE( 900, 60 )
   TONE( 500, 20 )

   SET DEVICE TO SCREEN

  // EJECT
   
   IF aReturn[ 5 ] == 1
      SET PRINTER TO
      DBCOMMITALL()
      OURSPOOL(wnrel)
   ENDIF
   Eject
Return( NIL )

/*
+--------------------------------------------------------------+
| Função Verif_User()                                          |
+--------------------------------------------------------------+
*/
 
Static Function Verif_User()
     
  For i := 1 to 500

     PSWORDER(1)

     aEmp     := {}
     aNomMenu := {}
     aMenu    := {}
     aAc      := {}
     aAcesso  := {}

     cID := strzero(i,6)
     If PSWSEEK(cID,.T.)

        Aum:=PSWRET(1)

        _cID      := Aum[1][1]             // Id do Usuario
        _cNome    := Aum[1][2]             // Nome
        _cNomeCom := Aum[1][4]             // Nome Completo
        _dDtVal   := Aum[1][6]             // Data Validade da Senha
        _lAltSen  := Aum[1][8]             // Autorizado a Alterar sua Senha
        _lAltPrx  := Aum[1][9]             // Alterar Senha no proximo Logon
        _cDepart  := Aum[1][12]            // Departamento
        _dDtUlt   := Aum[1][16]            // Data Ultima Alteracao
        _cDigAno  := Aum[1][18]            // No. Digitos para o Ano

        Adois:=PSWRET(2)

        _cDirRel  := Adois[1][3]           // Diretorio para Relatorio
        _cImpPad  := Adois[1][4]           // Impressora Padrao
        _cAcesso  := Adois[1][5]           // Acessos SIGAMAT.ACS

        // Vetor com Empresas
                  
        For j := 1 to Len( aDois[1][6] )

           aadd( aEmp , Adois[1][6][j] )

           If "@" $ Adois[1][6][j]
              Exit
           EndIf
          
        Next

        // Vetor Acessos Sigamat.ACS

        For ss := 1 to Len(_cAcesso)
            If Subs(_cAcesso,ss,1) == "S"
               AAdd( aAc, ss )
            Endif
		Next

        Atres:=PSWRET(3)

        For zz := 1 to Len(Atres[1])

            If Subs( Atres[1][zz] , 3,1 ) <> 'X'

               Importa_MNU()
                          
            Endif

        Next

        Importa_ACS()

        Imp_user()
             
     EndIf   // Tinha else exit endif

  Next

Return

/*
+--------------------------------------------------------------+
| Função Importa_MNU()                                         |
+--------------------------------------------------------------+
*/

Static Function Importa_MNU()

  cNivel  := Subs(atres[1][zz] , 3 , 1 )
  cArqTXT := Subs(Atres[1][zz] , 4 , Len(Atres[1][zz]) - 3 )

  AAdd( aNomMenu , cArqTXT )

  AbriuOK  := .f.
  nBytes  := 131+2

  TXT_EOF := .f.

  cBuffer := Space(nBytes)
  nHandle := Fopen(cArqTXT)

  If Ferror()==0
     AbriuOK := .t.
  Endif

  If AbriuOK

     While !TXT_EOF

        If Fread(nHandle,@cbuffer,nBytes) <> nBytes
           TXT_EOF := .t.
           Fclose(nHandle)
           Return
        Endif
     
        _cOrdem       := SubStr(cBuffer,1,2)
        _cDesc        := SubStr(cBuffer,3,18)
        _cNomePro     := SubStr(cBuffer,21,7)
        _cHabili      := SubStr(cBuffer,31,1)
        _cArqAbe      := SubStr(cBuffer,32,90)
        _cOpcHab      := SubStr(cBuffer,122,10)

        If _cHabili == 'T'
           AAdd( aMenu, { cNivel, cArqTxt, _cOrdem, _cDesc, _cNomePro, _cHabili, _cArqAbe, _cOpcHab})
        Endif

     Enddo
  Else
     // tratar caso nao encontre o arquivo referente ao menu
     // MsgBox(" Nao consegui abrir o arquivo " + cArqTxt )
     // Return
  Endif


Return

/*
+--------------------------------------------------------------+
| Função Importa_ACS()                                         |
+--------------------------------------------------------------+
*/

Static Function Importa_ACS()

  cArqTXT := "\SIGAADV\SIGAMAT.ACS"

  AbriuOK  := .f.
  nBytes  := 27+2

  TXT_EOF := .f.

  cBuffer := Space(nBytes)
  nHandle := Fopen(cArqTXT)

  If Ferror()==0
     AbriuOK := .t.
  Endif

  If AbriuOK

     nConta  := 1
  
     While !TXT_EOF

        If Fread(nHandle,@cbuffer,nBytes) <> nBytes
           TXT_EOF := .t.
           Fclose(nHandle)
           Return
        Endif

        nList := ASCAN( aAc, nConta )

        If nList > 0
           _cDesACS  := SubStr(cBuffer,1,26)
           AAdd( aAcesso , _cDesACS )
        Endif

        nConta := nConta + 1

     Enddo

  Else

     // Tratar caso nao ache o arquivo
     // MsgBox(" Nao consegui abrir o arquivo " + cArqTxt )
     // Return

  Endif

Return

/*
+--------------------------------------------------------------+
| Função Imp_user()                                            |
+--------------------------------------------------------------+
*/

Static Function Imp_user()

    For nLinhas :=1 to Len( aNomMenu)        // Imprime os nomes dos menus habilitados

        If mv_par01$aNOMMENU[nLINHAS]           // Filtra o módulo informado no parâmetro

 		   @ 000      , 000 pSay "+-----------------------------------------------------------------------------+"
		   @ pRow()+1 , 000 pSay "|                                                                             |"
 		   @ pRow()+1 , 000 pSay "|                          REGISTRO DE USUARIOS PROTHEUS                      |"
 		   @ pRow()+1 , 000 pSay "|                                                                             |"
 		   @ pRow()+1 , 000 pSay "| Matricula.....: " + _cID + " Nome.: " + _cNome + "                  Pag: " + StrZero( nPag,3 ) + "     |"
		   @ pRow()+1 , 000 pSay "| Nome Completo.: " + _cNomeCom + " Data Val Senha: " + Dtoc( _dDtVal ) + "     |"
		   @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"
		   @ pRow()+1 , 000 pSay "| Altera Senha? " + IIF( _lAltSen == .t. , "SIM","NAO") + "  - Alterar Senha Prox. Logon? " + IIF( _lAltPrx == .t. , "SIM","NAO")  + "                         |"
		   @ pRow()+1 , 000 pSay "| Depto: " + Subs(_cDepart,1,20) + " Dt Ult Alterac: " + Dtoc( _dDtUlt )  + "   Digitos p/Ano: " + StrZero( _cDigAno,2) + "    |"
		   @ pRow()+1 , 000 pSay "| Dir. p/Relatorios: " + Subs(_cDirRel,1,50) + "       |"
		   @ pRow()+1 , 000 pSay "| Nome Impressora Padrao: " + _cImpPad   + "                                        |"
		   @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"
		   @ pRow()+1 , 000 pSay "|                               ACESSOS  AS  EMPRESAS                         |"
		   @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"

		   nRegistro := SM0->(Recno())
		   SM0->(DbSetOrder(1))

		   For nLinhas := 1 to Len(aEmp)
		       SM0->(DbSeek( aEmp[nLinhas] ))
		       @ pRow()+1 , 000 pSay "  -  Empresa: " + Subs( aEmp[nLinhas] ,1,2) + " " + SM0->m0_nome + "  Filial: " + Subs( aEmp[nLinhas] ,3,2) + ' ' + SM0->m0_Filial
		       Pula_pag()
		   Next

		   SM0->(DbGoto(nRegistro))

		   If !(_cSinte)     // Imprime se Analitico

   		      @ pRow()+1 , 000 pSay ""
		      @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"
		      @ pRow()+1 , 000 pSay "|                               ACESSOS DISPONIVEIS                           |"
		      @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"

		      @ pRow()+1 , 000 pSay "  Disponiveis: "  + AllTrim(SubStr( _cAcesso,001,060 ))
		      @ pRow()+1 , 000 pSay "               "  + Alltrim(Substr( _cAcesso,061,060 ))
		      
	          For nLinhas := 1 to Len(aAcesso)
		          @ pRow()+1 , 000 pSay "  Acesso Habilitado para: " + aAcesso[nlinhas]
		          Pula_pag()
		      Next

		   Endif

		   @ pRow()+1 , 000 pSay ""
		   @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"
		   @ pRow()+1 , 000 pSay "|                               MENUS HABILITADOS                             |"
		   @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"

		   For nLinhas :=1 to Len( aNomMenu)        // Imprime os nomes dos menus habilitados

		       If mv_par01$aNOMMENU[nLINHAS]
        
			      @ pRow()+1 , 001 pSay aNomMenu[nlinhas]
        
		       EndIf
        
		       Pula_pag()
		   Next

	   /*	   If !(_cSinte)                               // Imprime se Analitico
		      @ pRow()+1 , 000 pSay " "
		      For nLinhas := 1 to Len(aMenu)           // Imprime as opcoes disponiveis dos menus
		          If aMenu[nLinhas][3] == "10"
		             _cTipo := "10 Atualizacao"
		          ElseIf aMenu[nLinhas][3] == "20"
		             _cTipo := "20 Consultas  "
		          ElseIf aMenu[nLinhas][3] == "30"
		             _cTipo := "30 Relatorios "
		          Else
		             _cTipo := "40 Miscelanea "
		          Endif
		          //@ pRow()+1 , 000 pSay "  Nivel " + aMenu[nlinhas][1] + " " + aMenu[nlinhas][2] + " " + _cTipo + " " + aMenu[nLinhas][4] + " N.Prg: " + aMenu[nLinhas][5] + "  Opcoes Menu: " + aMenu[nLinhas][8]
		          @ pRow()+1 , 000 pSay Chr(15) + "  Nivel " + aMenu[nlinhas][1] + " " + aMenu[nlinhas][2] + " " + _cTipo + " " + aMenu[nLinhas][4] + " N.Prg: " + aMenu[nLinhas][5] + "  Opcoes Menu: " + aMenu[nLinhas][8] + chr(18)
		          Pula_pag()
			  Next
		   Endif
        */
        
		   @ pRow()+1 , 000 pSay ""
		   @ pRow()+1 , 000 pSay "       ------------------------------- // -------------------------------"

		   npag := npag + 1

		   If pRow()>60
		      @ 000, 000 pSay " *-* "
		   Endif   
    
        EndIf
    
    Next

Return

/*
+--------------------------------------------------------------+
| Função Pula_Pag()                                            |
+--------------------------------------------------------------+
*/

Static Function Pula_Pag()

   If pRow() > 60

      npag := npag + 1

      @ 000      , 000 pSay ''
      @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"
      @ pRow()+1 , 000 pSay "|                                                                             |"
      @ pRow()+1 , 000 pSay "|                          REGISTRO DE USUARIOS PROTHEUS                      |"
      @ pRow()+1 , 000 pSay "|                                                                             |"
      @ pRow()+1 , 000 pSay "| Matricula.....: " + _cID + " Nome.: " + _cNome + "          Pag: " + StrZero( nPag,3 ) + "           |"
      @ pRow()+1 , 000 pSay "| Nome Completo.: " + _cNomeCom + " Data Val Senha: " + Dtoc( _dDtVal ) + "      |"
      @ pRow()+1 , 000 pSay "+-----------------------------------------------------------------------------+"

   Endif

Return

/*
+--------------------------------------------------------------+
| Função Perguntas()                                           |
+--------------------------------------------------------------+
*/

Static FUNCTION PERGUNTAS()

   SX1->(DbSetOrder(1))
   If ! SX1->(DbSeek("CFG002",.F.))      
      RecLock("SX1",.T.)
      SX1->X1_GRUPO   := "CFG002"
      SX1->X1_ORDEM   := "01"
      SX1->X1_PERGUNT := "Modulo para filtro?     "
      SX1->X1_VARIAVL := "mv_ch1"
      SX1->X1_TIPO    := "C"
      SX1->X1_TAMANHO := 03
      SX1->X1_GSC     := "G"
      SX1->X1_VAR01   := "mv_par01"
      MsUnLock("SX1")
   EndIf

Return


