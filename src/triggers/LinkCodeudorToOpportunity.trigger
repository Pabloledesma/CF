trigger LinkCodeudorToOpportunity on Opportunity (before insert, after insert) { 
	/**
	* Enlaza los codeudeudores a la oportunidad
	**/
	if(Trigger.new.size() == 1 && Trigger.new[0].AccountId != null && Trigger.isBefore){


		RecordType rt = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];

		//La cuenta tiene codeudores?
		List<Account> codeudores =
		[
				select
					Id
				from
					Account
				where Cliente_deudor__c = :Trigger.new[0].AccountId
				AND Canal_digital__c = 'Si'
				AND RecordTypeId = :rt.Id
		];

		System.debug('LinkCodeudorToOpportunity -> codeudores:');
		System.debug(codeudores);
		if(codeudores.size() > 0){
            for(Integer i = 0; i < codeudores.size(); i++)
            {
                if(i == 0){
                	Trigger.new[0].Codeudor_1__c = codeudores[i].Id;
					Trigger.new[0].Aporta_Ingresos_Codeudor_1__c = 'Si';
                	//System.debug('LinkCodeudorToOpportunity -> Actualizando codeudor 1: ' + codeudores[i].Id);
				}
				if(i == 1){
					Trigger.new[0].Codeudor_2__c = codeudores[i].Id;
					Trigger.new[0].Aporta_Ingresos_Codeudor_2__c = 'Si';
					//System.debug('LinkCodeudorToOpportunity -> Actualizando codeudor 2: ' + codeudores[i].Id);
				}

				if(i == 2){
					Trigger.new[0].Codeudor_3__c = codeudores[i].Id;
					Trigger.new[0].Aporta_Ingresos_Codeudor_3__c = 'Si';
					//System.debug('LinkCodeudorToOpportunity -> Actualizando codeudor 3: ' + codeudores[i].Id);
				}
            }
        }
	}

	/**
	* Enlaza la oportunidad a la solicitud de crédito
	**/
	if(Trigger.isAfter && Trigger.new.size() == 1 && Trigger.new[0].AccountId != null){
		System.debug('LinkCodeudorToOpportunity -> Se creó la oportunidad ' + Trigger.new[0].Name);
		List<Solicitud_de_credito__c> sc = [select Id, Oportunidad__c from Solicitud_de_credito__c where Cliente_deudor__c = :Trigger.new[0].AccountId ];
		if(sc.size() > 0){
			sc[0].Oportunidad__c = Trigger.new[0].Id;
			//System.debug('Oportunidad enlazada: ' + sc);
			update sc[0];
		} else {
			System.debug('LinkCodeudor to opportunity: No se ha creado la solicitud!');
		}
	}
}