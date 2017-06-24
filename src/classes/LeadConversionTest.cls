@isTest
private class LeadConversionTest {

	@isTest static void conversion_de_lead_sin_codeudor() {
		Lead lead = TestDataFactory.createLead();
		System.assert(lead.Id != null, 'El candidato no fué insertado.');
		Test.startTest();
		
		Database.LeadConvertResult lcr = TestDataFactory.leadConversion(lead.Id);
		
		if(lcr.getErrors().size() > 0){
			System.debug('Errores al convertir el candidato: ');
			for(Database.Error error : lcr.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		} else {
			System.debug('Registros creados en la conversión');
			System.debug('Account: ' + lcr.getAccountId());
			System.debug('Contact: ' + lcr.getContactId());
			System.debug('Opportunity: ' + lcr.getOpportunityId());
		}

		System.assert(lcr.isSuccess()); 
		
		//Se creó la cuenta?
		Account acc = [select Id from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c];

		System.assert(
			[select count() from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c] == 1, 
			'Debe existir una cuenta con el número de indentificación del lead'
		);

		//Verificar que exista la solicitud de crédito con su información respectiva
		System.assert(
			[select count() from Solicitud_de_credito__c where Cliente_deudor__c = :acc.Id] == 1, 
			'Debe existir una Solicitud de credito'
		);

		//Verificar que exista la radicación de crédito con su información respectiva
		System.assert(
			[select count() from Radicacion_de_credito__c where Cliente_deudor__c = :acc.Id] == 1, 
			'Debe existir una radicación de crédito'
		);
		Test.stopTest();
		 
	}
	
	@isTest static void conversion_de_lead_con_un_codeudor() {
		Lead lead = TestDataFactory.createLead();
		Id codeudorId = TestDataFactory.createCodeudor(lead.Id);
		Test.startTest();
			
			Database.LeadConvertResult lcr = TestDataFactory.leadConversion(lead.Id);
			
			if(lcr.getErrors().size() > 0){
				System.debug('Errores al convertir el candidato: ');
				for(Database.Error error : lcr.getErrors()){
	                System.debug(error.getStatusCode() + ': ' + error.getMessage());
	                System.debug('Verificar los siguientes campos: ' + error.getFields());
	            }
			} 
				
			//Existe un deudor principal?
			Account deudorPrincipal = [select Id, Canal_digital__c, Numero_de_documento__c from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c];
			System.debug('conversion_de_lead_con_un_codeudor -> deudorPrincipal: ' + deudorPrincipal.Id);
			System.assertEquals(deudorPrincipal.Canal_digital__c, 'Si', 'La cuenta no se está creando con el identificador de canal digital');

			System.assert(
				[select count() from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c] == 1, 
				'Debe existir una cuenta con el número de indentificación del lead'
			);

			//El codeudor está enlazado a la cuenta principal?
			Codeudor__c cod = [select Numero_de_documento__c from Codeudor__c where Id = :codeudorId];
			Account codeudor = [select Id, Cliente_deudor__c, Numero_de_documento__c from Account where Numero_de_documento__c = :String.valueOf(cod.Numero_de_documento__c)];
			System.assertEquals(
				 deudorPrincipal.Id, codeudor.Cliente_deudor__c,
				'El codeudor no está enlazado al cliente plrincipal'
			);

			//Se creo la oportunidad?
			 Opportunity op = [select Id, AccountId, Codeudor_1__c from Opportunity where AccountId = :lcr.getAccountId()];
			 System.debug('conversion_de_lead_con_un_codeudor -> oportunidad creada');
			 System.debug(op);
			 System.assertEquals(op.Id, lcr.getOpportunityId(), 'No se creó la oportunidad en la conversión del candidato.');
			 System.assertEquals(op.AccountId, lcr.getAccountId(), 'La oportunidad no está enlazada a la cuenta principal');

			// Se actualizo correctamente el codeudor en la oportunidad?
			Account cuentaTipoCodeudor = [select Id from Account where Numero_de_documento__c = :String.valueOf(codeudor.Numero_de_documento__c)];
			System.debug('conversion_de_lead_con_un_codeudor -> cuentaTipoCodeudor: ' + cuentaTipoCodeudor.Id);
			System.assertEquals(op.Codeudor_1__c, cuentaTipoCodeudor.Id, 'El codeudor 1 no fué actualizado correctamente en la oportunidad');

			//Se creo la radicación de crédito?
			Radicacion_de_credito__c rc = [select Id, Codeudor_1__c, Cliente_deudor__c from Radicacion_de_credito__c where Cliente_deudor__c = :lcr.getAccountId()];
			System.assertEquals(rc.Codeudor_1__c, codeudor.Id, 'La radicación no esta enlazada al codeudor');


		Test.stopTest();
	}

	@isTest static void conversion_de_lead_con_dos_codeudores() {
		Lead lead = TestDataFactory.createLead();
		Id codeudor1 = TestDataFactory.createCodeudor(lead.Id);
		Id codeudor2 = TestDataFactory.createCodeudor(lead.Id);

		Test.startTest();
		 
			Database.LeadConvertResult lcr = TestDataFactory.leadConversion(lead.Id);

			if(lcr.getErrors().size() > 0){
				System.debug('Errores al convertir el candidato: ');
				for(Database.Error error : lcr.getErrors()){
	                System.debug(error.getStatusCode() + ': ' + error.getMessage());
	                System.debug('Verificar los siguientes campos: ' + error.getFields());
	            }
			} 

			System.assert(lcr.isSuccess(), 'La conversión no fué exitosa.');

			//Existen 2 cuentas de tipo codeudor enlazadas a la cuenta principal?
			System.assert(
				[select count() from Account where Cliente_deudor__c = :lcr.getAccountId()] == 2,
				'Se esperaba encontrar 2 cuentas de tipo codeudor'
			);

			//Se creo la oportunidad?
			Opportunity op = [select Id, AccountId, Codeudor_1__c, Codeudor_2__c from Opportunity where AccountId = :lcr.getAccountId()];
			//System.debug('conversion_de_lead_con_dos_codeudores -> oportunidad creada');
			//System.debug(op);
			System.assertEquals(op.Id, lcr.getOpportunityId(), 'No se creó la oportunidad en la conversión del candidato.');
			System.assertEquals(op.AccountId, lcr.getAccountId(), 'La oportunidad no está enlazada a la cuenta principal');


			// Se actualizaron correctamente los codeudores en la oportunidad?
			List<Account> lstCodeudores = [select Id from Account where Cliente_deudor__c = :lcr.getAccountId()]; 
			Map<Id, Account> mapCodeudores = new Map<Id, Account>(lstCodeudores);
			System.assert(mapCodeudores.containsKey(op.Codeudor_1__c), 'El codeudor 1 no fué actualizado correctamente en la oportunidad');
			System.assert(mapCodeudores.containsKey(op.Codeudor_2__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');
		 
		Test.stopTest();
	}

	@isTest static void conversion_de_lead_con_tres_codeudores() {
		Lead lead = TestDataFactory.createLead();

		Id codeudor1 = TestDataFactory.createCodeudor(lead.Id);
		Id codeudor2 = TestDataFactory.createCodeudor(lead.Id);
		Id codeudor3 = TestDataFactory.createCodeudor(lead.Id);

		Test.startTest();
			Database.LeadConvertResult lcr = TestDataFactory.leadConversion(lead.Id);
			
			if(lcr.getErrors().size() > 0){
				System.debug('Errores al convertir el candidato: ');
				for(Database.Error error : lcr.getErrors()){
	                System.debug(error.getStatusCode() + ': ' + error.getMessage());
	                System.debug('Verificar los siguientes campos: ' + error.getFields());
	            }
			} 

			System.assert(lcr.isSuccess(), 'La conversión no fué exitosa.');

			//Existen 2 cuentas de tipo codeudor?
			System.assert(
				[select count() from Account where Cliente_deudor__c = :lcr.getAccountId()] == 3,
				'Se esperaba encontrar 3 cuentas de tipo codeudor'
			);

			//Se creo la oportunidad?
			Opportunity op = [select Id, AccountId, Codeudor_1__c, Codeudor_2__c, Codeudor_3__c from Opportunity where AccountId = :lcr.getAccountId()];
			//System.debug('conversion_de_lead_con_dos_codeudores -> oportunidad creada');
			//System.debug(op);
			System.assertEquals(op.Id, lcr.getOpportunityId(), 'No se creó la oportunidad en la conversión del candidato.');
			System.assertEquals(op.AccountId, lcr.getAccountId(), 'La oportunidad no está enlazada a la cuenta principal');


			// Se actualizaron correctamente los codeudores en la oportunidad?
			List<Account> lstCodeudores = [select Id from Account where Cliente_deudor__c = :lcr.getAccountId()]; 
			Map<Id, Account> mapCodeudores = new Map<Id, Account>(lstCodeudores);
			System.assert(mapCodeudores.containsKey(op.Codeudor_1__c), 'El codeudor 1 no fué actualizado correctamente en la oportunidad');
			System.assert(mapCodeudores.containsKey(op.Codeudor_2__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');
			System.assert(mapCodeudores.containsKey(op.Codeudor_3__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');
		
		Test.stopTest();
	}

	@isTest static void conversion_de_lead_con_cuatro_codeudores() {
		Lead lead = TestDataFactory.createLead();
		TestDataFactory.createCodeudor(lead.Id);
		TestDataFactory.createCodeudor(lead.Id);
		TestDataFactory.createCodeudor(lead.Id);
		Test.startTest();
			try {
				TestDataFactory.createCodeudor(lead.Id);
			} catch(Exception e){
				System.debug(e.getMessage());
			}

			System.assert(
				[select count() from Codeudor__c where Candidato__c = :lead.id] == 3,
				'Se esperaba encontrar 3 codeudores'
			);
		Test.stopTest();
		
	}
	
}