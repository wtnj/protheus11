/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Customiza豫o                                            !
+------------------+---------------------------------------------------------+
!Modulo            ! Estoque                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! NHEST083                                                !
+------------------+---------------------------------------------------------+
!Tabelas Utilizadas! SB8, SBJ,SD4,SD5                                       !
+------------------+---------------------------------------------------------+
!Descricao         ! Atualizar a Data de Validade do Lote do Produto         !
+------------------+---------------------------------------------------------+
!Autor             ! Alexandre R. Bento                                      !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 08/01/07                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/

#include "rwmake.ch" 
#include "TOPCONN.CH"

User Function Nhest083()

SetPrvt("CSB8,CSD5,LCONTINUA,CLOTE,CQUERY,PNCONT")
SetPrvt("DDTVALID,DCORRETA,_CSQL,_NRET,dVIRADA")

SB8->( DBSETORDER( 6 ) )  // FILIAL, LOTE, PRODUTO, LOCAL
SD5->( DBSETORDER( 2 ) )  // FILIAL, PRODUTO, LOCAL

cSb8 := xFilial( "SB8" )
cSd5 := xFilial( "SD5" )

lContinua := .T.

WHILE lContinua

   cLote := SPACE( 10 )

   @ 00, 00 TO 200,400 DIALOG oDlg1 TITLE "Atualiza Data de Validade"

   @ 20, 10 SAY "Lote:"
   @ 20, 60 GET cLote      PICT "@!" size 40,8

   @ 80, 60 BMPBUTTON TYPE 01 ACTION CONFIRMA()// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==>    @ 80, 60 BMPBUTTON TYPE 01 ACTION EXECUTE(CONFIRMA)
   @ 80, 95 BMPBUTTON TYPE 02 ACTION SAIR()// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==>    @ 80, 95 BMPBUTTON TYPE 02 ACTION EXECUTE(SAIR)

   IF lContinua
      ACTIVATE DIALOG oDlg1 CENTERED
   ENDIF

END
//CLOSE( oDlg1 )



Return(nil)       


Static FUNCTION CONFIRMA()
*****************

   DbSelectArea("SA1")

   cQuery := "SELECT MIN(B8_DTVALID) B8_DTVALID FROM " + RetSqlName("SB8")
   cQuery += " WHERE B8_FILIAL = '" + xFilial("SB8") + "' AND D_E_L_E_T_ = ' ' AND B8_LOTECTL = '" + cLote + "'"
//   MemoWrit('C:\TEMP\EST083.SQL',cQuery)
   TCQuery cQuery new alias "TRB1"

   TcSetField("TRB1", "B8_DTVALID", "D", 8, 0)

   DBSelectArea( 'TRB1' )
   
   pnCont := 0
   
   DBEval( { || pnCont := pnCont + 1 }, { || .T. }, { || ! EoF() } )
   
   TRB1->( DbGotop() )

   dDtValid := TRB1->B8_DTVALID

   DbSelectArea("TRB1")
   TRB1->(DbCloseArea())
   DbSelectArea("SA1")


   IF pnCont > 0

      *컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
      *  Busca a menor data de validade do Lote
      *컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

      CLOSE( oDlg1 )

      @ 00, 00 TO 200,400 DIALOG oDlg2 TITLE "Atualiza Data de Validade"

      @ 20, 10 SAY "Lote:"
      @ 30, 10 SAY "Validade (Atual):"
      @ 40, 10 SAY "Validade (Nova):"

      @ 20, 60 SAY cLote
      @ 30, 60 SAY Dtoc(dDtValid)

      dCorreta := CTOD( "" )       
      @ 40, 60 GET dCorreta VALID dCorreta >= dDataBase

      @ 80, 60 BMPBUTTON TYPE 01 ACTION ATUALIZA()// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==>       @ 80, 60 BMPBUTTON TYPE 01 ACTION EXECUTE(ATUALIZA)
      @ 80, 95 BMPBUTTON TYPE 02 ACTION CLOSE( oDlg2 )

      ACTIVATE DIALOG oDlg2 CENTERED
   ELSE
      TONE( 1000, 1 )
      MSGBOX( "LOTE nao cadastrado", "Atualizacao", "ALERT" )
   ENDIF

RETURN( NIL )



// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==> FUNCTION SAIR
Static FUNCTION SAIR()
*************

   lContinua := .F.
   CLOSE( oDlg1 )

RETURN( NIL )



// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==> FUNCTION ATUALIZA
Static FUNCTION ATUALIZA()
*****************

   TONE( 500, 1 )

   IF MsgBox( "Altera Validade " + DTOC( dDtValid ) +;
              " para "           + DTOC( dCorreta ) + "?",;
               "Atualiza validade", "YESNO" )


      _cSQL := "UPDATE " + RetSqlName("SB8") + " SET B8_DTVALID = '" + Dtos(dCorreta) + "'"
      _cSQL := _cSQL + " FROM " + RetSqlName("SB8") + " SB8"
      _cSQL := _cSQL + " WHERE SB8.B8_FILIAL = '" + xFilial("SB8") + "' AND SB8.D_E_L_E_T_ =  ' ' AND SB8.B8_LOTECTL = '" + cLote + "'"

//      Memowrit("C:\TEMP\EST083B8.SQL",_cSql) 
      _nRet := TcSqlExec (_cSQL)

      If _nRet < 0
         Memowrit("C:\TEMP\NHEST083.SQL",_cSql) 
         MsgStop ("Erro: Ao atualizar SB8 !")
      EndIf
      
      _cSQL := " UPDATE " + RetSqlName("SD5") + " SET D5_DTVALID = '" + Dtos(dCorreta) + "'"
      _cSQL := _cSQL + " FROM " + RetSqlName("SB8") + " SB8," +  RetSqlName("SD5") + " SD5"
      _cSQL := _cSQL + " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "' AND SB8.D_E_L_E_T_ = ' ' AND SB8.B8_LOTECTL = '" + cLote + "' AND"
      _cSQL := _cSQL + "       SD5.D5_FILIAL  = '" + xFilial("SD5") + "' AND SD5.D_E_L_E_T_ = ' ' AND"
      _cSQL := _cSQL + "       SD5.D5_LOTECTL = SB8.B8_LOTECTL AND SD5.D5_PRODUTO = SB8.B8_PRODUTO"

///      Memowrit("C:\TEMP\EST083D5.SQL",_cSql)       
      _nRet := TcSqlExec (_cSQL)
      
      If _nRet < 0
         Memowrit("C:\TEMP\NHEST083.SQL",_cSql) 
         MsgStop ("Erro: Ao atualizar SD5 !")
      EndIf
      
      dVirada := GetMV('MV_ULMES')
      
      _cSQL := " UPDATE " + RetSqlName("SBJ") + " SET BJ_DTVALID = '" + Dtos(dCorreta) + "'"
      _cSQL := _cSQL + " WHERE BJ_FILIAL  = '" + xFilial("SBJ") + "' AND D_E_L_E_T_ = ' ' AND BJ_LOTECTL = '" + cLote + "' AND "
      _cSQL := _cSQL + " BJ_DATA = '" + Dtos(dVIRADA) + "'" 
//      Memowrit("C:\TEMP\EST083BJ.SQL",_cSql)             
      _nRet := TcSqlExec (_cSQL)

      If _nRet < 0
         Memowrit("D:\TEMP\NHEST083.SQL",_cSql) 
         MsgStop ("Erro: Ao atualizar SBJ !")
      Endif   
 //=================================================================================================================================
      _cSQL := " UPDATE " + RetSqlName("SD4") + " SET D4_DTVALID = '" + Dtos(dCorreta) + "'"
      _cSQL := _cSQL + " FROM " + RetSqlName("SB8") + " SB8," +  RetSqlName("SD4") + " SD4"
      _cSQL := _cSQL + " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "' AND SB8.D_E_L_E_T_ = ' ' AND SB8.B8_LOTECTL = '" + cLote + "' AND"
      _cSQL := _cSQL + "       SD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND SD4.D_E_L_E_T_ = ' ' AND"
      _cSQL := _cSQL + "       SD4.D4_LOTECTL = SB8.B8_LOTECTL AND SD4.D4_COD = SB8.B8_PRODUTO AND SD4.D4_QUANT > 0.00 "
//      Memowrit("C:\TEMP\EST083D4.SQL",_cSql)       
      _nRet := TcSqlExec (_cSQL)
      
      If _nRet < 0
         Memowrit("C:\TEMP\NHEST083.SQL",_cSql) 
         MsgStop ("Erro: Ao atualizar SD4 !")
      EndIf          
  //=================================================================================================================================    
   //   IF SM0->M0_CODIGO == "01" .AND. SM0->M0_CODFIL == "01"
     
   //      _cSQL := ' UPDATE ' + RetSqlName("SZL") + ' SET ZL_DTVALID = "' + Dtos(dCorreta) + '"'
    //     _cSQL := _cSQL + ' FROM ' + RetSqlName("SB8") + ' SB8,' +  RetSqlName("SZL") + ' SZL'
    //     _cSQL := _cSQL + ' WHERE SB8.B8_FILIAL  = "' + xFilial("SB8") + '" AND SB8.D_E_L_E_T_ <> "*" AND SB8.B8_LOTECTL = "' + cLote + '" AND'
    //     _cSQL := _cSQL + '       SZL.ZL_FILIAL  = "' + xFilial("SZL") + '" AND SZL.D_E_L_E_T_ <> "*" AND'
    //     _cSQL := _cSQL + '       SZL.ZL_LOTECTL = SB8.B8_LOTECTL AND SZL.ZL_COD = SB8.B8_PRODUTO'
      
    //     _nRet := TcSqlExec (_cSQL)
      
     //    If _nRet < 0
     //       Memowrit("C:\TEMP\HLB082.SQL",_cSql) 
      //      MsgStop ("Erro: Ao atualizar SZL !")
      //   EndIf
      
    //  EndIf
      
      CLOSE( oDlg2 )

   ENDIF

RETURN( NIL )
