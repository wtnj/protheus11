#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/04/00
#define DBS_NAME   1
#define DBS_TYPE   2
#define DBS_LEN	   3
#define DBS_DEC	   4

User Function Mudastru()        // incluido pelo assistente de conversao do AP5 IDE em 10/04/00

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("CARQSX2,CINDSX2,CALIAS,_ALIASOK,CARQINI,ANEWSTR")
SetPrvt("NCONTA,CARQTEMP,LOK1,LOK2,ASTRUC_OLD,NTOTREG")
SetPrvt("I,CCAMPO,NPOS,CTYPEOLD,XVALUE,NLEN")
SetPrvt("NDEC,CTYPENEW,")

SX3->(DBSETORDER(1))
cArqSx2 := "SX2"+SM0->M0_CODIGO+"0"
cIndSx2 := cArqSx2
IF !OpenSX2Excl(cArqSx2,cIndSx2) .OR. ! OpenSIXExcl()// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> IF !OpenSX2Excl(cArqSx2,cIndSx2) .OR. ! Execute(OpenSIXExcl)
Else
   Do While .T.
      cAlias:="   "
      @  0, 0 TO 250,400 DIALOG oDlg TITLE "Atualiza┤└o de Estruturas em SQL"
      @ 30,35 TO 80,130
      @ 50,40 SAY "Arquivo..:"
      @ 50,80 GET cAlias PICTURE "!!!" Valid AlValid()// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==>       @ 50,80 GET cAlias PICTURE "!!!" Valid Execute(AlValid)
      @ 35,150 BMPBUTTON TYPE 01 ACTION ATUALIZAR()// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==>       @ 35,150 BMPBUTTON TYPE 01 ACTION Execute(ATUALIZAR)
      @ 65,150 BMPBUTTON TYPE 02 ACTION Close(oDlg)
      ACTIVATE DIALOG oDlg  CENTERED
      Exit
   Enddo
ENDIF
// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 10/04/00



*---------------
// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Function AlValid
Static Function AlValid()
*---------------
_AliasOk:=.F.
SX2->(DBSETORDER(1))
SX3->(DBSETORDER(1))
SINDEX->(DBSETORDER(1))
If ! SX2->(DBSEEK(cAlias))
   _AliasOk:=.F.   
   MsgStop("Tabela nao encontrada no SX2.","Aviso de Erro")
ElseIf ! SX3->(DBSEEK(cAlias))
   _AliasOk:=.F.
   MsgStop("Tabela nao encontrada no SX3.","Aviso de Erro")
ElseIf ! TCCanOpen(ALLTRIM(SX2->X2_ARQUIVO))
   _AliasOk:=.F.
   MsgStop("Tabela nao encontrada no SQL.","Aviso de Erro")
Else
   _AliasOk:=.T.
Endif
Return _AliasOk



*-----------------
// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Function ATUALIZAR
Static Function ATUALIZAR()
*-----------------
Processa({||ATUALIZA()})// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Processa({||Execute(ATUALIZA)})
Return .T.



*----------------
// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Function ATUALIZA
Static Function ATUALIZA()
*----------------
cArqIni := ALLTRIM(SX2->X2_ARQUIVO)

ProcRegua(7)

IncProc("Apagando Arq. de Backup")
MSErase(RetArq( "TOPCONN",cArqIni+".#DB",.f.))

IncProc("Renomeando Arq. para Backup")
MSRename(cArqIni+GetDBExtension(),cArqIni+".#DB")

IncProc("Verificando Estrutura.")
aNewStr:={}

Do while ! SX3->(EOF()) .AND. SX3->X3_ARQUIVO == cAlias
   If SX3->X3_CONTEXT#"V"
      AADD(aNewStr,{SX3->X3_CAMPO ,SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL}) 
   EndIf
   SX3->(DBSKIP())
Enddo

IncProc("Apagando Indices.")
SIX->(DbSeek(cAlias))
While ( ! SIX->(Eof()) ) .And. ( cAlias == SIX->INDICE )
      Ferase(cArqIni+SIX->ORDEM+RetIndExt())
      SIX->(DbSkip())
End

IncProc("Criando Arq.")                    
MSCreate(cArqIni,aNewStr,"TOPCONN")

IncProc("Atualizando Arq.")                    
nConta:=0
cArqTemp := cArqIni+".#DB"

lOk1 := .F.
lOk2 := .F.
While !lOk1 .AND. !lOk2
   If !lOk1
      lOk1 :=MsOpenDbf(.T.,"TOPCONN",cArqIni+GetDBExtension(),"CurArqAtu",.F.,.F.,.T.)
   EndIf
   
   If !lOk2
      lOk2 :=MsOpenDbf(.T.,"TOPCONN",cArqIni+".#DB","CurArqOld",.F.,.F.,.T.)
   EndIf
End

aStruc_Old := CurArqOld->(DBStruct())

IncProc("Atualizando os Dados.")
DbSelectArea("CurArqAtu")

nTotReg:=CurArqOld->(RECCOUNT())

CurArqOld->(dbgotop())

CurArqOld->( DbEval( {|| Grava()},{|| SYSREFRESH() } ) )// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> CurArqOld->( DbEval( {|| Execute(Grava)},{|| SYSREFRESH() } ) )
//  MSAppend(cArqIni,cArqTemp)

CurArqAtu->(DBCLOSEAREA())
CurArqOld->(DBCLOSEAREA())

DBSELECTAREA("SX3")

Return .T.

*-------------*   
// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Function Grava
Static Function Grava()
*-------------*
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/04/00 ==> #define DBS_NAME   1
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/04/00 ==> #define DBS_TYPE   2
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/04/00 ==> #define DBS_LEN	   3
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/04/00 ==> #define DBS_DEC	   4

I:=0
nConta:=nConta+1
IncProc("Atualizando Arq. Reg.: "+STRZERO(nConta,8,0)+"/"+STRZERO(nTotReg,8,0))

RECLOCK("CurArqAtu",.T.)
      
For I:=1 To Len( aNewStr )
    cCampo := ALLTRIM(aNewStr[I][DBS_NAME])

    nPos:=AScan(aStruc_Old,{|siga| ALLTRIM(siga[DBS_NAME]) == cCampo})  
    
    If nPos == 0
       Loop  // Campo novo ...
    Else
       cTypeOld := aStruc_Old[nPos][DBS_TYPE]
    Endif
      
    xValue := CurArqOld->( FieldGet(FieldPos(cCampo)) )                
      
    nLen     := aNewStr[I][DBS_LEN]
    nDec     := aNewStr[I][DBS_DEC]
    cTypeNew := aNewStr[I][DBS_TYPE]
    
    Do Case
         
       Case cTypeOld == "C"  // CARACTER ...
            
            Do Case
               Case cTypeNew == "C"   
                    xValue := Left(xValue,nLen)
               Case cTypeNew == "M"   
                    xValue := xValue
               Case cTypeNew == "N"   
                    xValue := Val(Transf(xValue,if(nDec>0,;
                                         Replic("9",nLen-nDec-1)+"."+Replic("9",nDec),;
                                         Replic("9",nLen) )))
               Case cTypeNew == "L"   
                    xValue := Empty(xValue)
               Case cTypeNew == "D"   
                    xValue := CToD(xValue)
            EndCase
 
                
       Case cTypeOld == "M"  // MEMO ...
            Do Case          
               Case cTypeNew == "C"   
                    xValue := MemoLine( xValue, nLen )
               Case cTypeNew == "N"   
                    xValue := Val(Transf(MemoLine(xValue),if(nDec>0,;
                                         Replic("9",nLen-nDec-1)+"."+Replic("9",nDec),;
                                         Replic("9",nLen))))
               Case cTypeNew == "L"   
                    xValue := Empty(xValue)
               Case cTypeNew == "D"   
                    xValue := CToD(MemoLine(xValue))
            EndCase
        
         
       Case cTypeOld == "N"  // NUMERICO ...
            Do Case
               Case cTypeNew == "C"   
                    xValue := If(len(Alltrim(Str(xValue,nLen,nDec)))>nLen,Replic("*",nLen),Left(Alltrim(Str(xValue,nLen,nDec)),nLen))
               Case cTypeNew == "M"   
                    xValue := Alltrim(Str(xValue,nLen,nDec))
               Case cTypeNew == "N"   
                    xValue := Val(Transf(xValue,if(nDec>0,;
                                         Replic("9",nLen-nDec-1)+"."+Replic("9",nDec),;
                                         Replic("9",nLen))))
               Case cTypeNew == "L"   
                    xValue := ( xValue >= 0 )
               Case cTypeNew == "D"   
                    xValue := Ctod("  /  /  ")
            EndCase
    
 
       Case cTypeOld == "D"  // DATA ...
            Do Case
               Case cTypeNew == "C"  
                    xValue := Left(DtoC(xValue),nLen)
               Case cTypeNew == "M"  
                    xValue := DtoC( xValue )
               Case cTypeNew == "N"  
                    xValue := 0
               Case cTypeNew == "L"  
                    xValue := Empty(xValue)
            EndCase
    
 
       Case cTypeOld == "L"  // LOGICO ...
            Do Case
               Case cTypeNew == "C"  
                    xValue := Space( nLen )
               Case cTypeNew == "M"  
                    xValue := " "
               Case cTypeNew == "N"  
                    xValue := 0
               Case cTypeNew == "D"
                    xValue := Ctod("  /  /  ")   
            EndCase
      
      EndCase
            
      CurArqAtu->( FieldPut(FieldPos(cCampo), xValue) )
Next I
CurArqAtu->(MSUNLOCK())
Return ( Nil )


// Substituido pelo assistente de conversao do AP5 IDE em 10/04/00 ==> Function OpenSIXExcl
Static Function OpenSIXExcl()

	*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	*Ё Aguarda Liberacao de Arquivos por outras estacoes para abrir Sindex Exclusivo  Ё
	*юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dBSelectArea("SIX")
	dBCloseArea()
	MsOpenDbf(.t. ,__LocalDriver,"SINDEX","SIX",.f.,.f.)
    MSGSTOP("1")
	While !Used()
			If !NaoExcl()
            MSGSTOP("2")
				 MsOpenDbf(.t. ,__LocalDriver,"SINDEX","SIX",.t.,.f.)
				 MsOpenIdx( "SINDEX1","INDICE+ORDEM",.f.,,,"SINDEX" )
				 Return .F.
			Endif
			MsOpenDbf(.t. ,__LocalDriver,"SINDEX","SIX",.f.,.f.)
	End
   MsOpenIdx( "SINDEX1","INDICE+ORDEM",.f.,,,"SINDEX" )
Return .T.
