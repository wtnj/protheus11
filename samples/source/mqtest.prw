#include "mqseries.ch"
#include "rwmake.ch"

#define MsgSize 65536 // 64 Kb

//+----------------------------------------------------------------------+
//| Programa de teste de integracao com o IBM MQSeries, gerenciador de   |
//| mensagens.                                                           |
//| Atencao: Para a utilizacao desse programa, o client do MQSeries ver. |
//| 5.0 ou posteriores deve estar instalado no Servidor.                 |
//| Para conexao, o AP5 Server necessitara conectar-se a um servidor     |
//| dor MQSeries, informando o nome do Servidor, Canal de Conexao, Queue |
//| Manager e nome da Queue que serao utilizados.                        |
//+----------------------------------------------------------------------+

User Function MQTest()

Private hCon := hObj := nCompCode := nReason := nOptions := 0
Private cServer  := Space(25)
Private cChannel := Space(25)
Private cManager := Space(25)
Private cQueue   := Space(25)
Private cMsg     := ""
Private lConn   := lOpen := .F.

@ 177,144 To 450,511 Dialog oMQDlg Title "Teste de Integração com o IBM MQSeries"
@ 004,004 Say "Servidor:"          Size 025,008
@ 018,004 Say "Canal:"             Size 016,008
@ 031,004 Say "Queue Manager:"     Size 044,008
@ 045,004 Say "Queue"              Size 044,008
@ 004,051 Get cServer Picture "@!" Size 076,010
@ 017,051 Get cChannel             Size 076,010
@ 031,051 Get cManager             Size 076,010
@ 045,051 Get cQueue               Size 076,010
@ 077,004 Get cMsg                 Size 170,053 MEMO
@ 003,135 Button "_Fechar"         Size 036,016 Action EndMq()
@ 058,004 Button "_Conectar"       Size 036,016 Action ConMq()
@ 058,043 Button "_Desconectar"    Size 036,016 Action DisMq()
@ 057,093 Button "_Postar Msg"     Size 036,016 Action PosMq()
@ 057,131 Button "_Obter Msg"      Size 036,016 Action GetMq()
Activate Dialog oMQDlg
                                                        
Return

Static Function EndMq()
If lOpen .Or. lConn
	DisMQ()
Endif      
Close(oMQDlg)
Return

Static Function ConMq()
If !lConn
	lConn := MQConnect(cManager,cServer,cChannel,@hCon,@nCompCode,@nReason)
	If !lConn
		Alert("Erro na conexão ao servidor MQSeries. Código de razão número: " + AllTrim(Str(nReason,15)))	
	Endif
Else 
	Alert("O programa já se encontra conectado ao servidor MQSeries")
Endif
 
If !lOpen
	lOpen := MQOpen(@hCon, cQueue, @hObj, @nCompCode, @nReason, @nOptions)
	If !lOpen
		Alert("Erro na abertura da Queue. Código de razão número: " + AllTrim(Str(nReason,15)))
	Endif
Else
	Alert("A Queue já se encontra aberta")
Endif
Return

Static Function DisMq()
If lOpen
	lOpen := !MQClose(@hCon, @hObj, @nCompCode, @nReason, @nOptions)
	If lOpen
		Alert("Erro no fechamento da Queue. Código de razão número: " + AllTrim(Str(nReason,15)))
	Endif
Else 
	Alert("A Queue não se encontra aberta")
Endif

If lConn
	lConn := !MQDisconnect(@hCon,@nCompCode,@nReason)
	If lConn
		Alert("Erro na desconexão do servidor MQSeries. Código de razão número: " + AllTrim(Str(nReason,15)))
	Endif
Else 
	Alert("O programa não se encontra conectado ao servidor MQSeries")
Endif
Return

Static Function PosMq()
If MQPut(@hCon, @hObj, @nCompCode, @nReason, @nOptions , cMsg)			
	Alert("Mensagem postada com sucesso!")
Else
	Alert("Erro na postagem da mensagem. Código de razão número: " + AllTrim(Str(nReason,15)))
Endif
Return

Static Function GetMq()
cMSg := Space(MsgSize)
// A primeira chamada apenas lê a mensagem e posiciona o ponteiro. A segunda lê e remove da queue
If MQGet(@hCon, @hObj, @nCompCode, @nReason, MQ_NO_WAIT , @cMsg, MsgSize)
	MQGet(@hCon, @hObj, @nCompCode, @nReason, MQ_NO_WAIT + MQ_MSG_UNDER_CURSOR , @cMsg, MsgSize)
	Alert("Mensagem lida: " + cMsg)
Else
	If nReason == MQ_NO_MSG_AVAILABLE
		Alert("Não existem mais mensagens na fila")
	Else
		Alert("Erro na obtenção da mensagem. Código de razão número: " + AllTrim(Str(nReason,15)))
	Endif
Endif
Return