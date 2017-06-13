/**
* Avanxo Colombia
* @author 			Raul Mora
* Proyect:			Credifamilia.
* Description:		Class to verify if the parent object Radicación de crédito is up to date, if not it proceed to update it.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author							Description
*			-----	----------		--------------------			---------------
* @version	 1.0	2015-11-24		Raul Mora (RM)   				Create class.
*************************************************************************************************************/
public with sharing class RefinanReferenGestionarRadCredito_ctr 
{
	
	sObject sobjOrigenTmp;
    public RefinanReferenGestionarRadCredito_ctr(ApexPages.StandardController controller)
    {
    	List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,Id,Id_externo__c,
                                                                              IsDeleted,Name,Objeto_destino__c,Objeto_origen__c,
                                                                              SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
                                                                              where  Objeto_origen__c = 'Referenciacion_y_verificacion__c' and Objeto_destino__c = 'Radicacion_de_credito__c'];
        Referenciacion_y_verificacion__c objRefVer = (Referenciacion_y_verificacion__c)controller.getRecord();
        Referenciacion_y_verificacion__c objRefVer1;
        String strQuery='SELECT Id, Radicacion_de_credito__c ';
                                                                       
		for(Actualizacionderegistros__c objActualizacionderegistros : lstActualizacionderegistros)
		{
			try
			{
				strQuery+=', ';
				strQuery+=objActualizacionderegistros.Campo_origen__c;
			}
			catch(exception e)
			{
				system.debug('\nError --> ' + e.getmessage());
			}
		}
		
		strQuery+=' FROM Referenciacion_y_verificacion__c WHERE Id=\''+ objRefVer.Id +'\' LIMIT 1';
		
    	system.Debug('\n\n -->Query Select Objeto Origen --> ' + strQuery);
    	
    	List<sObject> lstObjetoOrigen = Database.query(strQuery);
    	
    	if( !lstObjetoOrigen.isEmpty() )
    	{
    		objRefVer1 = (Referenciacion_y_verificacion__c) lstObjetoOrigen.get(0);
    	}
       
        sobjOrigenTmp=objRefVer1;
    }
    public void StartProcess()
    {
        CheckParentUpdate_cls classCheckParentUpdate= new CheckParentUpdate_cls(sobjOrigenTmp,'Referenciacion_y_verificacion__c', 'Radicacion_de_credito__c');
        classCheckParentUpdate.CheckUpdate();
    }

}