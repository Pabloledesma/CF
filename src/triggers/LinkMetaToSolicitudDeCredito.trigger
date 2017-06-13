trigger LinkMetaToSolicitudDeCredito on Solicitud_de_credito__c (before insert) {
    Meta__c meta = [SELECT Id FROM Meta__c LIMIT 1];
    
    if(meta != null){
        for(Solicitud_de_credito__c sc: Trigger.new){
            sc.Meta__c = meta.Id;
        }
    }
   
    
}