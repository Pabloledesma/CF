trigger OpportunityTrigger on Opportunity (before insert, before update, after insert) {

	/**
	* Opportunity_UpdateParent_trg
	**/
	if(Trigger.isBefore){
		if(trigger.new.size()==1)
	    {
	        UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
	        
	        classUpdateRegistersLookUp.setRegister(trigger.new[0],'Opportunity');
	        
	    }
	}

	if(Trigger.isBefore && Trigger.isInsert){

		/**
		* Enlaza la meta a la oportunidad
		**/
		List<Meta__c> meta = [SELECT Id FROM Meta__c LIMIT 1];
  
	    if(meta.size() > 0){
	        for(Opportunity op : Trigger.new){
	            op.Meta__c = meta[0].Id;
	           
	        }    
	    }    

		/**
		* Enlaza los codeudeudores a la oportunidad creada por la conversión del candidato y actualiza el campo codeudor en cada uno de ellos.
		* Apto para un solo registro
		**/
		if( Trigger.new.size() == 1 && Trigger.new[0].AccountId != null && Trigger.new[0].Origen__c != 'Canal tradicional' ){ 

			RecordType rt = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];

			//La cuenta tiene codeudores?
			List<Account> codeudores =
			[
					select
						Id,
						Codeudor__c
					from
						Account
					where Cliente_deudor__c = :Trigger.new[0].AccountId
					AND Canal_digital__c = 'Si'				
			];

			//System.debug('LinkCodeudorToOpportunity -> codeudores:');
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
	            }
	            update codeudores;
	        }
		} //if( Trigger.new.size() == 1 && Trigger.new[0].AccountId != null && Trigger.new[0].Origen__c != 'Canal tradicional' ){ 

		/**
		* Si la oportunidad es creada por el canal tradicional y tiene un codeudor asociado, actualiza el campo codeudor de la cuenta del codeudor asociado
		* Apto para inserciones masivas
		**/
		List<Account> lstCodeudoresCanalConstructor = new List<Account>();
		for(Opportunity op : Trigger.new){
			if(String.isBlank(op.Origen__c)){
				if(op.Codeudor_1__c != null){
					lstCodeudoresCanalConstructor.add(
						new Account(
							Id = (Id)op.Codeudor_1__c,
							Codeudor__c = true
						)
					);
				}

				if(op.Codeudor_2__c != null){
					lstCodeudoresCanalConstructor.add(
						new Account(
							Id = (Id)op.Codeudor_2__c,
							Codeudor__c = true
						)
					);
				} 

				if(op.Codeudor_3__c != null){
					lstCodeudoresCanalConstructor.add(
						new Account(
							Id = (Id)op.Codeudor_3__c,
							Codeudor__c = true
						)
					);
				} 
			}
		}

		if(lstCodeudoresCanalConstructor.size() > 0) update lstCodeudoresCanalConstructor; 
			
	} //if(Trigger.isBefore && Trigger.isInsert){

	/**
	* Si se modifica uno de los campos codeudor, se actualiza la cuenta del codeudor referenciado
	**/ 
	if(Trigger.isBefore && Trigger.isUpdate){
		List<Account> lstCodeudores = new List<Account>(); 
		for(Opportunity op : Trigger.new){
			Opportunity oldOpp = Trigger.oldMap.get(op.Id);

			/** Si fué enlazado un codeudor **/
			if((op.Codeudor_1__c != oldOpp.Codeudor_1__c) && op.Codeudor_1__c != null){
				lstCodeudores.add(
					new Account(
						Id = op.Codeudor_1__c,
						Codeudor__c = true
					)
				);
			}

			if((op.Codeudor_2__c != oldOpp.Codeudor_2__c) && op.Codeudor_2__c != null){ 
				lstCodeudores.add(
					new Account(
						Id = op.Codeudor_2__c,
						Codeudor__c = true
					)
				);
			}

			if((op.Codeudor_3__c != oldOpp.Codeudor_3__c) && op.Codeudor_3__c != null){
				lstCodeudores.add(
					new Account(
						Id = op.Codeudor_3__c,
						Codeudor__c = true
					)
				);
			}
		}

		update lstCodeudores;
	}

	/**
	* Enlaza la oportunidad a la solicitud de crédito
	**/
	if(Trigger.isAfter && Trigger.new.size() == 1 && Trigger.new[0].AccountId != null){
		//System.debug('LinkCodeudorToOpportunity -> Se creó la oportunidad ' + Trigger.new[0].Name);
		List<Solicitud_de_credito__c> sc = [select Id, Oportunidad__c from Solicitud_de_credito__c where Cliente_deudor__c = :Trigger.new[0].AccountId ];
		if(sc.size() > 0){
			sc[0].Oportunidad__c = Trigger.new[0].Id;
			//System.debug('Oportunidad enlazada: ' + sc);
			update sc[0];
		} else {
			//System.debug('LinkCodeudor to opportunity: No se ha creado la solicitud!');
		}
	}
}