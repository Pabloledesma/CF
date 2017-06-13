@isTest (SeeAllData=true)
private class RadicacionDeCredito_UpdateParent_tst {

    static testMethod void myUnitTest() 
    {
    	List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,CreatedById,CreatedDate,Id,Id_externo__c,
                                                                              IsDeleted,LastModifiedById,LastModifiedDate,Name,Objeto_destino__c,Objeto_origen__c,
                                                                              SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
                                                                              where  Objeto_origen__c='Radicacion_de_credito__c'];
        RadicacionDeCredito_UpdateParent_cls classRadicacionDeCredito_UpdateParent= new RadicacionDeCredito_UpdateParent_cls();
        Radicacion_de_credito__c objRadicaciondecredito= new Radicacion_de_credito__c();
        classRadicacionDeCredito_UpdateParent.setRegister(objRadicaciondecredito);
        sObject objsObject=Schema.getGlobalDescribe().get(lstActualizacionderegistros[0].Objeto_destino__c).newSObject();
        classRadicacionDeCredito_UpdateParent.createObject(objsObject,objRadicaciondecredito,lstActualizacionderegistros[0]);
        
    }
}