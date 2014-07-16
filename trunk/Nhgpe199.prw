/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE199  ºAutor  ³Marcos R. Roquitski º Data ³  11/17/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa arquivo consignado Banco do Brasil.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhgpe199()

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


IF MsgBox( "Importa Arquivo ? ", "Consignado Banco do Brasil", "YESNO" )

	Processa( {|| Importa_Arq() } )

Endif

Return

/*
+--------------------------------------------------------------+
| Função Importa_Arq()                                         |
+--------------------------------------------------------------+
*/
     
Static Function Importa_Arq()
Local _aStruct

_cArquivo  := 'CEFN1124.REM'
_lRet      := .T.
_aStruct   := {{ "FILLER01","C",240,0}} 

_cArq := CriaTrab(_aStruct,.t.)
USE &_cArq Alias ZTRB New Exclusive

DbselectArea("ZTRB")
If !Empty(_cArquivo)
	Append From (_cArquivo) SDF
Endif	
ZTRB->(DbGotop())
SRA->(DbSetOrder(1))


/*
00100000         201261681000104                    0330650000000051896 WHB FUNDICAO S/A              BANCO DO BRASIL                         12011112411051200000008400000                                                                     
0010000100902011201100010000001201261681000104      000000000000002975200330650000000051896 WHB FUNDICAO S/A              01                                                                                                                    
0010001300001H0ALEXANDRE RODIZIO BENTO             83901132953000000002477111100020566700000000420511201112123011201130122012000617000000617000000051417000617000                    01000000000000000000A0351050000000112925                   
0010001300002H0MARCOS ROBERTO ROQUITSKI            68845200949000000002512111100017320000000000420511201112123011201130122012000519600000519600000043300000519600                    01000000000000000000A0351050000000138401                   
0010001300003H0SANDROVAL ITAMIR GONCALVES          81117574920000000002524111100012953300000000420511201112123011201130122012000388600000388600000032383000388600                    01000000000000000000A0351050000000142441                   
0010001300004H0JOAO FELIPE DA ROSA                 00993014909000000002767111100012953300000000420511201112123011201130122012000388600000388600000032383000388600                    01000000000000000000A0351050000000260975                   
0010001300005H0PHILIP DE OLIVEIRA RAMOS            31219011843000000003004111100012953300000000420511201112123011201130122012000388600000388600000032383000388600                    01000000000000000000A0351050000000519065                   
0010001300006H0AMIEL SERUR DOS S LOFFAGEM          03931750906000000003275111100008080000000000420511201112123011201130122012000242400000242400000020200000242400                    01000000000000000000A0351050000000266329                   
0010001300007H0BEATRIZ DE MEIRA SILVA              09139319938000000003455111100002453300000000420511201112123011201130122012000073600000073600000006133000073600                    01000000000000000000A0351050000000272213                   
0010001300008H0CAIO CESAR LISBOA                   23027674897000000003596111100007333300000000420511201112123011201130122012000220000000220000000018333000220000                    01000000000000000000A035105000000027495X                   
00100015       00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000                                                                                                                                  
00199999         000001000012000000                                                                                                                                                                                                             
*/


	While !ZTRB->(Eof())
    	
		If Substr(ZTRB->FILLER01,14,1) == "H"

			_cMat := StrZero(Val(SubStr(ZTRB->FILLER01,63,12)),6)

			If SRA->(DbSeek(xFilial('SRA') + _cMat))


				If !ZZ7->(DbSeek(xFilial('ZZ7') + _cMat))
					If RecLock("ZZ7",.T.)
						ZZ7->ZZ7_FILIAL := xFilial("ZZ7")
						ZZ7->ZZ7_MAT    := StrZero(Val(SubStr(ZTRB->FILLER01,63,12)),6)
						ZZ7->ZZ7_NOME   := SubStr(ZTRB->FILLER01,16,30)					
						ZZ7->ZZ7_DATA   := Ctod(SubStr(ZTRB->FILLER01,110,2) + '/' +SubStr(ZTRB->FILLER01,112,2) + '/' +SubStr(ZTRB->FILLER01,114,4))
						ZZ7->ZZ7_PARCEL := Val(SubStr(ZTRB->FILLER01,106,2))
						ZZ7->ZZ7_VALPAR := Val(SubStr(ZTRB->FILLER01,144,9))/100
						ZZ7->ZZ7_STATUS := 'A'
						ZZ7->ZZ7_CPF    := SubStr(ZTRB->FILLER01,52,11)
						MsUnLock("ZZ7")
					Endif	
				Endif	
			Endif	

       	Endif
		
		ZTRB->(DbSkip())		

	Enddo

   DbSelectArea("ZTRB")
   DbCloseArea()

Return
