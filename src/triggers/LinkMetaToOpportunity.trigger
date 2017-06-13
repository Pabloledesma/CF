// When an Opportunity is created, it update the field Meta__c
trigger LinkMetaToOpportunity on Opportunity (before insert) {
    Meta__c meta = [SELECT Id FROM Meta__c LIMIT 1];
  
    if(meta != null){
        for(Opportunity op : Trigger.new){
            op.Meta__c = meta.Id;
           
        }    
    }    
    
}