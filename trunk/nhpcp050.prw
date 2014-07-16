#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/**********************************************************************************************************************************/
/** user function NHPCP050                                                                                                       **/
/** monta o browser para tempo de clico					                                                                         **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
user function NHPCP050	

	// titulo
	private cCadastro := "Tempo de ciclo"
	// menus
	private aRotina   := { {"Pesquisar", "AxPesqui", 0, 1 } ,;
											 	 {"Visualizar", "AxVisual", 0, 2 } ,;
											 	 {"Incluir", "AxInclui", 0, 3 } ,;
											 	 {"Alterar", "AxAltera", 0, 4} ,;
											 	 {"Excluir", "AxDeleta", 0, 5}  ;
										 	 }
	
	
	// monta o browse
	MBrowse( Nil, Nil, Nil, Nil, "ZRZ" )
	
return
