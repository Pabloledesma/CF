trigger AccountUpdateField on Account (before insert, before update, after insert)
{
    AccountUpdateField_cls.setAccountUpdate(trigger.new); 

    /**
    * Actualización de los codeudores en la Radicación de crédito
    **/
	if( Trigger.isAfter && Trigger.isInsert && Trigger.new.size() == 1){
    	RecordType rt = [select Id, Name from RecordType where Name = 'Codeudores' and SobjectType='Account'];

    	// Si es de tipo codeudor y tiene un cliente deudor asociado
    	if(Trigger.new[0].RecordTypeId == rt.id && Trigger.new[0].Cliente_deudor__c != null){

    		List<Radicacion_de_credito__c> listRc =
			[
				select
					Id,
					Codeudor_1__c,
					Codeudor_2__c,
					Codeudor_3__c,
					Cliente_deudor__c
				from Radicacion_de_credito__c
				where Cliente_deudor__c = :Trigger.new[0].Cliente_deudor__c limit 1
			];

    		// Es posible que un cliente tenga mas de una radicación de crédito?
    		if(listRc.size() > 0){
    			if(listRc[0].Codeudor_1__c == null && listRc[0].Codeudor_2__c == null && listRc[0].Codeudor_3__c == null)
    				listRc[0].Codeudor_1__c = Trigger.new[0].Id;
    			else if(listRc[0].Codeudor_2__c == null && listRc[0].Codeudor_3__c == null)
    				listRc[0].Codeudor_2__c = Trigger.new[0].Id;
    			else if(listRc[0].Codeudor_3__c == null)
    				listRc[0].Codeudor_3__c = Trigger.new[0].Id;
    		}
    	}
    }
}