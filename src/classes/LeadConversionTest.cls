@isTest
private class LeadConversionTest {

	@isTest static void conversion_de_lead_sin_codeudor() {
		Lead lead = TestDataFactory.createLead();
		System.assert(lead.Id != null, 'El candidato no fué insertado.');
		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(lead.Id);
			verificarCuenta(lead);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);
			verificarRadicacionDeCredito(sc);
		Test.stopTest();
	}
	
	@isTest static void conversion_de_lead_con_un_codeudor() {
		Lead lead = TestDataFactory.createLead();
		Id codeudorId = TestDataFactory.createCodeudor(lead.Id);
		Test.startTest();
			
			Database.LeadConvertResult lcr = convertLead(lead.Id);
				
			verificarCuenta(Lead);

			Account deudorPrincipal =
			[
					SELECT
							Id,
							Canal_digital__c,
							Numero_de_documento__c
					FROM Account
					WHERE Numero_de_documento__c = :lead.Numero_de_identificacion__c
			];
			//System.debug('conversion_de_lead_con_un_codeudor -> deudorPrincipal: ' + deudorPrincipal.Id);
			System.assertEquals(
					deudorPrincipal.Canal_digital__c,
					'Si',
					'La cuenta no se está creando con el identificador de canal digital'
			);

			//El codeudor está enlazado a la cuenta principal?
			Codeudor__c cod = [select Numero_de_documento__c from Codeudor__c where Id = :codeudorId];
			Account codeudor = [select Id, Cliente_deudor__c, Numero_de_documento__c from Account where Numero_de_documento__c = :String.valueOf(cod.Numero_de_documento__c)];
			System.assertEquals(
				 deudorPrincipal.Id, codeudor.Cliente_deudor__c,
				'El codeudor no está enlazado al cliente plrincipal'
			);

			Opportunity op = verificarOportunidad(lcr);

			// Se actualizo correctamente el codeudor en la oportunidad?
			Account cuentaTipoCodeudor = [select Id from Account where Numero_de_documento__c = :String.valueOf(codeudor.Numero_de_documento__c)];
			//System.debug('conversion_de_lead_con_un_codeudor -> cuentaTipoCodeudor: ' + cuentaTipoCodeudor.Id);
			System.assertEquals(
					op.Codeudor_1__c,
					cuentaTipoCodeudor.Id,
					'El codeudor 1 no fué actualizado correctamente en la oportunidad'
			);

			Solicitud_de_credito__c sc = verificarSolicitud(lcr);

			Radicacion_de_credito__c rc = verificarRadicacionDeCredito(sc);

			System.assertEquals(rc.Codeudor_1__c, codeudor.Id, 'La radicación no esta enlazada al codeudor');

		Test.stopTest();
	}

	@isTest static void conversion_de_lead_con_dos_codeudores() {
		Lead lead = TestDataFactory.createLead();
		Set<Id> setCodeudores = new Set<Id>();
		setCodeudores.add(TestDataFactory.createCodeudor(lead.Id));
		setCodeudores.add(TestDataFactory.createCodeudor(lead.Id));

		Test.startTest();
		 
			Database.LeadConvertResult lcr = convertLead(lead.Id);

			//Existen 2 cuentas de tipo codeudor enlazadas a la cuenta principal?
			System.assert(
				[select count() from Account where Cliente_deudor__c = :lcr.getAccountId()] == 2,
				'Se esperaba encontrar 2 cuentas de tipo codeudor'
			);

			//El codeudor está enlazado a la cuenta principal?
			List<Codeudor__c> lstCodeudors = new List<Codeudor__c>();
			lstCodeudors = [select Numero_de_documento__c from Codeudor__c where Id IN :setCodeudores];
			Set<String> cedulasCodeudores = new Set<String>();
			for(Codeudor__c cod: lstCodeudors){
				cedulasCodeudores.add(cod.Numero_de_documento__c);
			}
			List<Account> accounts = new List<Account>();
			accounts = [select Id, Cliente_deudor__c, Numero_de_documento__c from Account where Numero_de_documento__c IN :cedulasCodeudores];
			System.assertEquals(
					accounts.size(), 2,
					'Los codeudores no están enlazados a la cuenta del cliente plrincipal'
			);

			Opportunity op = verificarOportunidad(lcr);

			// Se actualizaron correctamente los codeudores en la oportunidad?
			List<Account> lstCodeudores = [select Id from Account where Cliente_deudor__c = :lcr.getAccountId()]; 
			Map<Id, Account> mapCodeudores = new Map<Id, Account>(lstCodeudores);
		System.assert(mapCodeudores.containsKey(op.Codeudor_1__c), 'El codeudor 1 no fué actualizado correctamente en la oportunidad');
		System.assert(mapCodeudores.containsKey(op.Codeudor_2__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');

		Solicitud_de_credito__c sc = verificarSolicitud(lcr);
		System.assert(mapCodeudores.containsKey(sc.Codeudor_1__c), 'El codeudor 1 no fué actualizado correctamente en la Solicitud');
		System.assert(mapCodeudores.containsKey(sc.Codeudor_2__c), 'El codeudor 2 no fué actualizado correctamente en la Solicitud');


			Radicacion_de_credito__c rc = verificarRadicacionDeCredito(sc);

			System.assert(mapCodeudores.containsKey(rc.Codeudor_1__c), 'La radicación no esta enlazada al codeudor 1');
			System.assert(mapCodeudores.containsKey(rc.Codeudor_2__c), 'La radicación no esta enlazada al codeudor 2');

		Test.stopTest();
	}

	@isTest static void conversion_de_lead_con_tres_codeudores() {

		Lead lead = TestDataFactory.createLead();

		Set<Id> idCodeudores = new Set<Id>();
		idCodeudores.add(TestDataFactory.createCodeudor(lead.Id));
		idCodeudores.add(TestDataFactory.createCodeudor(lead.Id));
		idCodeudores.add(TestDataFactory.createCodeudor(lead.Id));

		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(lead.Id);

			//Existen 3 cuentas de tipo codeudor?
			System.assert(
				[select count() from Account where Cliente_deudor__c = :lcr.getAccountId()] == 3,
				'Se esperaba encontrar 3 cuentas de tipo codeudor'
			);

			Opportunity op = verificarOportunidad(lcr);

			// Se actualizaron correctamente los codeudores en la oportunidad?
			List<Account> lstCodeudores = [select Id from Account where Cliente_deudor__c = :lcr.getAccountId()]; 
			Map<Id, Account> mapCodeudores = new Map<Id, Account>(lstCodeudores);
			System.assert(mapCodeudores.containsKey(op.Codeudor_1__c), 'El codeudor 1 no fué actualizado correctamente en la oportunidad');
			System.assert(mapCodeudores.containsKey(op.Codeudor_2__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');
			System.assert(mapCodeudores.containsKey(op.Codeudor_3__c), 'El codeudor 2 no fué actualizado correctamente en la oportunidad');

			Solicitud_de_credito__c sc = verificarSolicitud(lcr);

			//se actualizaron los codeudores en la radicación?
			Radicacion_de_credito__c rc = verificarRadicacionDeCredito(sc);

			System.assert(mapCodeudores.containsKey(rc.Codeudor_1__c), 'La radicación no esta enlazada al codeudor 1');
			System.assert(mapCodeudores.containsKey(rc.Codeudor_2__c), 'La radicación no esta enlazada al codeudor 2');
			System.assert(mapCodeudores.containsKey(rc.Codeudor_3__c), 'La radicación no esta enlazada al codeudor 3');

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

	@isTest
	static void conversion_de_lead_asignado_a_un_asesor(){
		//User asesorComercialCD = TestDataFactory.createUser('00eo0000000TUb1');
		//System.debug('conversion_de_lead_asignado_a_un_asesor -> usuario: ' + asesorComercialCD);
		//TestDataFactory.createMeta();
		Test.startTest();
		Id asesorId = '005o0000002P5KY';
		Lead lead = TestDataFactory.createLead(asesorId);

		User asesorComercial = [select Id from User where Id = '005o0000002P5KY'];
		System.runAs(asesorComercial){

			Database.LeadConvertResult lcr = convertLead(lead.id);
			verificarCuenta(lead);
			verificarOportunidad(lcr);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);
			verificarRadicacionDeCredito(sc);
		}

		System.debug('conversion_de_lead_asignado_a_un_asesor -> lead: ' + lead);


		Test.stopTest();
	}

	@isTest
	public static void solicitud_de_vivienda_nueva()
	{
		Lead viviendaNueva = TestDataFactory.createLead('Crédito de vivienda nueva');
		Map<String, Id> mapRt = new Map<String, Id>();
		mapRt = getRecordTypeFromSolicitud();
		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(viviendaNueva.id);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);

			System.assertEquals(
					sc.RecordTypeId,
					mapRt.get('Vivienda Nueva'),
					'El tipo de registro de la Solicitud no es correcto.'
			);
		Test.stopTest();
	}

	@isTest public static void solicitud_de_asignacion_de_cupo()
	{
		Lead asignacionDeCupo = TestDataFactory.createLead('Asignación de cupo');
		Map<String, Id> mapRt = new Map<String, Id>();
		mapRt = getRecordTypeFromSolicitud();
		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(asignacionDeCupo.id);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);

			System.assertEquals(
					sc.RecordTypeId,
					mapRt.get('Vivienda Nueva'),
					'El tipo de registro de la Solicitud no es correcto.'
			);
	    Test.stopTest();
	}

	@isTest public static void solicitud_credito_de_vivienda_usada()
	{
		Lead lead = TestDataFactory.createLead('Crédito de vivienda usada');
		Map<String, Id> mapRt = new Map<String, Id>();
		mapRt = getRecordTypeFromSolicitud();
		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(lead.id);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);

			System.assertEquals(
					sc.RecordTypeId,
					mapRt.get('Vivienda Usada / Mejoramiento'),
					'El tipo de registro de la Solicitud no es correcto.'
			);
	    Test.stopTest();
	}

	@isTest public static void solicitud_mejoramiento_de_vivienda()
	{
		Lead lead = TestDataFactory.createLead('Mejoramiento de vivienda');
		Map<String, Id> mapRt = new Map<String, Id>();
		mapRt = getRecordTypeFromSolicitud();
		Test.startTest();
		Database.LeadConvertResult lcr = convertLead(lead.id);
		Solicitud_de_credito__c sc = verificarSolicitud(lcr);

		System.assertEquals(
				sc.RecordTypeId,
				mapRt.get('Vivienda Usada / Mejoramiento'),
				'El tipo de registro de la Solicitud no es correcto.'
		);
		Test.stopTest();
	}

	@isTest public static void solicitud_compra_de_cartera_hipotecaria()
	{
		Lead lead = TestDataFactory.createLead('Compra de cartera');
		Map<String, Id> mapRt = new Map<String, Id>();
		mapRt = getRecordTypeFromSolicitud();
		Test.startTest();
		Database.LeadConvertResult lcr = convertLead(lead.id);
		Solicitud_de_credito__c sc = verificarSolicitud(lcr);

		System.assertEquals(
				sc.RecordTypeId,
				mapRt.get('Compra de cartera hipotecaria'),
				'El tipo de registro de la Solicitud no es correcto.'
		);
		Test.stopTest();
	}

	@isTest public static void conversion_de_lead_con_perfil_comercial()
	{
		Lead lead = TestDataFactory.createLead();

		User user = getComercialUser();

		Test.startTest();
			System.runAs(user)
			{
				try {
					Database.LeadConvertResult lcr = convertLead(lead.id);
				} catch (DmlException e){
					System.debug('Error en la conversión del cantidato: ' + e.getMessage());
					System.assert(
							e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'),
							'Un asesor comercial no puede convertir candidatos'
					);
				}
			}
	    Test.stopTest();
	}

	@isTest public static void crear_cuenta_para_canal_constructor_con_perfil_comercial()
	{
		User user = getComercialUser();
		Test.startTest();
			System.runAs(user)
			{
				RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Cliente deudor' AND sObjectType = 'Account'];
				Id accId = TestDataFactory.createAccountForConstructorChanel(rt.Id, '12345678');

				// Existe oportunidad?
				System.assertEquals(
					[select count() from Opportunity where AccountId = :accId],
					0,
					'La oportunidad se debe crear manualmente en el canal constructor'
				);

				// Existe Solicitud?
				System.assertEquals(
					[select count() from Solicitud_de_credito__c where Cliente_deudor__c = :accId],
					0,
					'La Solicitud de crédito se debe crear manualmente en el canal constructor'
				);
			}
	    Test.stopTest();
	}

	public static User getComercialUser()
	{
		Profile asesorComercial = [SELECT Id, Name FROM Profile WHERE Name = 'Comercial'];
		return TestDataFactory.createUser(asesorComercial.Id);
	}

	public static Map<String, Id> getRecordTypeFromSolicitud()
	{
		List<RecordType> lstRt = [select id, name from RecordType where SobjectType = 'Solicitud_de_credito__c'];
		Map<String, Id> mapRt = new Map<String, Id>();
		for(RecordType rt : lstRt){
			mapRt.put(rt.Name, rt.Id);
		}

		return mapRt;
	}

	public static Database.LeadConvertResult convertLead(Id leadId)
	{
		Database.LeadConvertResult lcr = TestDataFactory.leadConversion(leadId);

		if(lcr.getErrors().size() > 0){
			System.debug('Errores al convertir el candidato: ');
			for(Database.Error error : lcr.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}

		System.assert(lcr.isSuccess(), 'La conversión no fué exitosa.');
		return lcr;
	}

	/**
	* Verificar que exista la solicitud de crédito y esté enlazada a la oportunidad
	**/
	public static Solicitud_de_credito__c verificarSolicitud(Database.LeadConvertResult lcr)
	{

		Solicitud_de_credito__c sc =
		[
				SELECT
						Id,
						RecordTypeId,
						Oportunidad__c,
						Codeudor_1__c,
						Codeudor_2__c,
						Codeudor_3__c
				FROM Solicitud_de_credito__c
				WHERE Oportunidad__c = :lcr.getOpportunityId()
				LIMIT 1
		];

		System.assert(sc != null, 'Debe existir una Solicitud de credito');

		System.assertEquals(
				sc.Oportunidad__c,
				lcr.getOpportunityId(),
				'La solicitud de crédito no está enlazada a la oportunidad'
		);

		return sc;
	}

	public static Radicacion_de_credito__c verificarRadicacionDeCredito(Solicitud_de_credito__c sc)
	{
		//Verificar que exista la radicación de crédito y esté enlazada a la solicitud de crédito
		System.assert(
				[select count() from Radicacion_de_credito__c where Solicitud_de_credito__c = :sc.Id] == 1,
				'Debe existir una radicación de crédito'
		);

		Radicacion_de_credito__c rc =
		[
				SELECT
						Id,
						Codeudor_1__c,
						Codeudor_2__c,
						Codeudor_3__c,
						Solicitud_de_credito__c
				FROM Radicacion_de_credito__c
				WHERE Solicitud_de_credito__c = :sc.Id
				LIMIT 1
		];

		return rc;
	}

	public static void verificarCuenta(Lead lead)
	{
		Account acc = [select Id from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c];

		System.assert(
				[select count() from Account where Numero_de_documento__c = :lead.Numero_de_identificacion__c] == 1,
				'Debe existir una cuenta con el número de indentificación del lead'
		);

	}

	public static Opportunity verificarOportunidad(Database.LeadConvertResult lcr)
	{

		Opportunity op =
		[
				SELECT
						Id,
						AccountId,
						Codeudor_1__c,
						Codeudor_2__c,
						Codeudor_3__c
				FROM Opportunity
				WHERE AccountId = :lcr.getAccountId()
		];
		System.assertEquals(op.Id, lcr.getOpportunityId(), 'No se creó la oportunidad en la conversión del candidato.');
		System.assertEquals(op.AccountId, lcr.getAccountId(), 'La oportunidad no está enlazada a la cuenta principal');

		return op;
	}
}