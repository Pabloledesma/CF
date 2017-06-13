@isTest (SeeAllData=true)
private class UpdateRegistersLookUp_tst 
{

    static testMethod void myUnitTest() 
    {
        UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls();
         List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,CreatedById,CreatedDate,Id,Id_externo__c,
                                                                              IsDeleted,LastModifiedById,LastModifiedDate,Name,Objeto_destino__c,Objeto_origen__c,
                                                                              SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
                                                                              where Id_externo_destino__c = null];
        Case objCase= new Case();
        sObject sobjOrigen=objCase;
        classUpdateRegistersLookUp.setRegister(sobjOrigen,lstActualizacionderegistros[0].Objeto_origen__c);
    }
}