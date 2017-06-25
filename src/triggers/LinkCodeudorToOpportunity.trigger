trigger LinkCodeudorToOpportunity on Opportunity (before insert) {
	if(Trigger.new.size() == 1 && Trigger.new[0].AccountId != null){

		RecordType rt = [select Id, Name from RecordType where Name = 'Codeudores' and SobjectType='Account'];
		
		//La cuenta tiene codeudores?
		List<Account> codeudores = [select 
				Id 
			from 
				Account 
			where Cliente_deudor__c = :Trigger.new[0].AccountId 
			AND Canal_digital__c = 'Si'
			AND RecordTypeId = :rt.Id];

		System.debug('LinkCodeudorToOpportunity -> codeudores:');
		System.debug(codeudores);
		if(codeudores.size() > 0){
            for(Integer i = 0; i < codeudores.size(); i++)
            {
                if(i == 0){
                	Trigger.new[0].Codeudor_1__c = codeudores[i].Id;
                	System.debug('LinkCodeudorToOpportunity -> Actualizando codeudor 1: ' + codeudores[i].Id);
                } 
                if(i == 1) Trigger.new[0].Codeudor_2__c = codeudores[i].Id;
                if(i == 2) Trigger.new[0].Codeudor_3__c = codeudores[i].Id;
            }
        }
	}
}