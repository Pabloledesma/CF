public class InfoFinancieraGestionarRadCredito_Ctrl 
{
    sObject sobjOrigenTmp;
    public InfoFinancieraGestionarRadCredito_Ctrl(ApexPages.StandardController controller)
    {
    	List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,Id,Id_externo__c,
                                                                              IsDeleted,Name,Objeto_destino__c,Objeto_origen__c,
                                                                              SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
                                                                              where  Objeto_origen__c = 'Informacion_financiera__c' and Objeto_destino__c = 'Radicacion_de_credito__c'];
        Informacion_financiera__c objInformacion_financiera= (Informacion_financiera__c)controller.getRecord();
        Informacion_financiera__c objInformacion_financiera1;
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
		
		strQuery+=' FROM Informacion_financiera__c WHERE Id=\''+ objInformacion_financiera.Id +'\' LIMIT 1';
		
    	system.Debug('\n\n -->Query Select Objeto Origen --> ' + strQuery);
    	
    	List<sObject> lstObjetoOrigen = Database.query(strQuery);
    	
    	if( !lstObjetoOrigen.isEmpty() )
    	{
    		objInformacion_financiera1 = (Informacion_financiera__c) lstObjetoOrigen.get(0);
    	}
       
        sobjOrigenTmp=objInformacion_financiera1;
    }
    public void StartProcess()
    {
        CheckParentUpdate_cls classCheckParentUpdate= new CheckParentUpdate_cls(sobjOrigenTmp,'Informacion_financiera__c', 'Radicacion_de_credito__c');
        classCheckParentUpdate.CheckUpdate();
    }    
        
       
}