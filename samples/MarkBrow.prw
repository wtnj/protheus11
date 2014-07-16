#INCLUDE "protheus.ch"

User Function MarkBrow()        
Local _astru:={}
Local _afields:={}     
Local _carq             
Local oMark
Private arotina := {}   
Private cCadastro 
Private cMark:=GetMark()

aRotina   := { { "Marcar Todos"    ,"U_MARCAR"  , 0, 4},;               
			   { "Desmarcar Todos" ,"U_DESMAR"  , 0, 4},;               
			   { "Inverter Todos"  ,"U_MARKALL" , 0, 4}}   

cCadastro := "Arquivo Temporario"//ª Estrutura da tabela temporaria
AADD(_astru,{"A1_OK","C",2,0})
AADD(_astru,{"A1_FILIAL","C",2,0})
AADD(_astru,{"A1_COD","C",6,0})
AADD(_astru,{"A1_LOJA","C",2,0})
AADD(_astru,{"A1_NOME","C",40,0})// cria a tabela temporária

_carq:="T_"+Criatrab(,.F.)

MsCreate(_carq,_astru,"DBFCDX")

Sleep(1000)// atribui a tabela temporária ao alias TRB

dbUseArea(.T.,"DBFCDX",_cARq,"TRB",.T.,.F.)

Dbselectarea("SA1")
DBGOTOP()
WHILE !EOF()        
	DBSELECTAREA("TRB")        
	RECLOCK("TRB",.T.)                 
		TRB->A1_FILIAL:=SA1->A1_FILIAL                
		TRB->A1_COD:=SA1->A1_COD                 
		TRB->A1_LOJA:=SA1->A1_LOJA                
		TRB->A1_NOME:=SA1->A1_NOME        
	MSUNLOCK()        
	DBSELECTAREA("SA1")        
	DBSKIP()
ENDDO

AADD(_afields,{"A1_OK","",""})
AADD(_afields,{"A1_FILIAL","","Filial"})
AADD(_afields,{"A1_COD","","Cliente"})
AADD(_afields,{"A1_LOJA","","Loja"})
AADD(_afields,{"A1_NOME","","Nome"})

DbSelectArea("TRB")
DbGotop()
MarkBrow( 'TRB', 'A1_OK',,_afields,, cMark,'u_MarkAll()',,,,'u_Mark()',{|| u_MarkAll()},,,,,,,.F.) 
DbCloseArea()      // apaga a tabela temporário 

MsErase(_carq+GetDBExtension(),,"DBFCDX") 
Return

User Function Marcar()                              
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()        
	IF RecLock( 'TRB', .F. )                
		TRB->A1_OK := cMark                
		MsUnLock()        
	EndIf        
	
	dbSkip()
Enddo

MarkBRefresh( )      // força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
return

User Function DesMar()
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()        
	IF RecLock( 'TRB', .F. )                
		TRB->A1_OK := SPACE(2)                
		MsUnLock()        
	EndIf       
	dbSkip()
Enddo
MarkBRefresh( )// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return// Grava marca no campo

User Function Mark()
	If IsMark( 'A1_OK', cMark )        
		RecLock( 'TRB', .F. )                
			Replace A1_OK With Space(2)        
		MsUnLock()
	Else        
		RecLock( 'TRB', .F. )               
		 Replace A1_OK With cMark        
		 MsUnLock()
	 EndIf
Return // Grava marca em todos os registros validos

User Function MarkAll()   
Local oMark := GetMarkBrow()

	dbSelectArea('TRB')
	dbGotop()
	While !Eof()
         u_Mark()
         dbSkip()
    End

    MarkBRefresh( )// força o posicionamento do browse no primeiro registro
    oMark:oBrowse:Gotop()
 Return