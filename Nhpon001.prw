/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPON001  ºAutor  ³Marcos R. Roquitski º Data ³  07/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprovacao de horas extras.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhpon001()

SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd,_lSai,_cOrigem")

Pergunte("NHPON02",.T.)

If !CopiaArq()
	Return
Endif

_cArquivo := _cOrigem
lEnd      := .T.

DbSelectArea("SPC")
DbSetorder(1)


If File(_cArquivo)

	// Arquivo a ser trabalhado
	_aStruct:={{ "MATR","C",06,0} }

	_cTr1 := CriaTrab(_aStruct,.t.)
	USE &_cTr1 Alias TRB New Exclusive
	Append From (_cArquivo) SDF

	If MsgYesNo("Confirma Aprovacao Horas extras","Ferias")
	   MsAguarde ( {|lEnd| fAprova01() },"Aguarde","Aprovacao H.Extras",.T.)
	Endif
	DbSelectArea("TRB")
	DbCloseArea()

	Ferase(_cTr1)

Else

	Alert('** Arquivo de lote nao informado.')

Endif
             	
Return

//
Static Function fAprova01()
Local aUser, cUsrId

aUser := PswRet(1)
cUsrId := aUser[1][1]

SPC->(DbSetOrder(2))

DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())

	MsProcTxt('Matricula: '+TRB->MATR)


	SPC->(DbSeek(xFilial("SPC")+TRB->MATR))

	While !SPC->(Eof()) .and.  (SPC->PC_MAT == TRB->MATR)
	
	
	 If (SPC->PC_DATA >= MV_PAR01 .AND. SPC->PC_DATA <= MV_PAR02)
		
		_cPcPdi := Space(003)
		If SPC->PC_PD == '120' .and. MV_PAR03 == 'S' // 60% 
			_cPcPdi := '100' 

		Elseif SPC->PC_PD == '121' .and. MV_PAR03 == 'S' // 60% 
			_cPcPdi := '101' 

		Elseif SPC->PC_PD == '122' .and. MV_PAR03 == 'S' // 60%
			_cPcPdi := '101' 

		Elseif SPC->PC_PD == '133' .and. MV_PAR03 == 'S' // 60%
			_cPcPdi := '101' 

		Elseif SPC->PC_PD == '134' .and. MV_PAR03 == 'S' // 60%
			_cPcPdi := '101' 

		Elseif SPC->PC_PD == '135' .and. MV_PAR03 == 'S' // 60%
			_cPcPdi := '101' 
                                                                                                     
		Elseif SPC->PC_PD == '141' .and. MV_PAR03 == 'S' // 60%
			_cPcPdi := '101' 

		Elseif SPC->PC_PD == '139' .and. MV_PAR04 == 'S' // 100%
			_cPcPdi := '140' 

		Elseif SPC->PC_PD == '143' .and. MV_PAR04 == 'S' // 100%
			_cPcPdi := '140' 

		Elseif SPC->PC_PD == '148' .and. MV_PAR04 == 'S' // 100%
			_cPcPdi := '140' 

		Endif 
		
		If !Empty(_cPcPdi)
 			RecLock("SPC",.F.) 
			SPC->PC_PDI     :=  _cPcPdi 
			SPC->PC_QUANTI  :=  SPC->PC_QUANTC 
			SPC->PC_DATAALT :=  dDataBase 
			SPC->PC_HORAALT := 	Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS 
			SPC->PC_USUARIO :=  cUsrId 
			MsUnlock("SPC") 
		Endif	
			
		If SPC->PC_PD $ ('007/008/009/010/011/012/013/014/019/020/021/022/032/033/034/035') .AND. mv_par05 == 'S' 
 			RecLock("SPC",.F.) 
			SPC->PC_ABONO   :=  '001' 
			SPC->PC_QTABONO :=  SPC->PC_QUANTC 
			SPC->PC_DATAALT :=  dDataBase 
			SPC->PC_HORAALT := 	Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS 
			SPC->PC_USUARIO :=  cUsrId 
			MsUnlock("SPC") 
		Endif			

	 Endif		
     SPC->(DbSkip())
            
	Enddo
			
	/* 
	N.A   Autorizado 
	120 - 100 
	121 - 101 
	122 - 102 
	133 - 103 
	134 - 104 
	135 - 104 
	141 - 142 
	143 - 144 
	*/

	TRB->(Dbskip())

Enddo
Alert('Processo finalizado.......')
Return


Static Function CopiaArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Copia arquivo..."

@ 021,005 Say "Origem" Size  20,8
@ 021,030 Get _cOrigem Size 130,8 When .F. 

@ 021,180 Button    "_Localizar" Size 36,16 Action Origem()
@ 060,070 BmpButton Type 2 Action fFecha()
@ 060,120 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return(_lSai)


Static Function Origem()

	_cTipo :="Arquivo Tipo (*.TXT)       | *.TXT | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 

Return
              
Static Function fFecha()
	Close(oDialogos)
	_lSai := .F.
Return
      
Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
		_lSai := .T.
	Endif
Return
