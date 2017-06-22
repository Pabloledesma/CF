trigger LeadConversion on Account (after insert) {
    List<RecordType> rt = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];
    //System.debug('LeadConversion Trigger -> recordType List: ');
    //System.debug(rt);
    //Si tiene un lead asociado y el recordtype de la cuenta creada es Cliente deudor
    if(
    	[select count() from Lead where Numero_de_identificacion__c = :Trigger.new[0].Numero_de_documento__c] > 0 && 
    	Trigger.new[0].RecordTypeId == rt[0].Id
    ){
	    System.debug('LeadConversion Trigger -> Trigger.new: ');
	    System.debug(Trigger.new[0]);
        LeadConversionHelper leadConversionHelper = new LeadConversionHelper(Trigger.new[0]); 
    }
}