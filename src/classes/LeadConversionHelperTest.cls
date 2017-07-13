@isTest
private class LeadConversionHelperTest {
	
	@isTest public static void conversion_de_lead_codeudor_con_informacion_completa()
	{

		Test.startTest();
		Id asesorId = '005o0000002P5KY';
		Lead lead = TestDataFactory.createLead(asesorId);
		System.assertNotEquals(lead.Id, null, 'El candidato no se creó correctamente');
		User asesorComercial = [select Id from User where Id = '005o0000002P5KY'];
		Codeudor__c cod = TestDataFactory.createCodeudorFullInfo('Uno', lead.Id, 'Empleado');
		System.runAs(asesorComercial){

				Database.LeadConvertResult lcr = convertLead(lead.Id);

				verificarCuenta(lead);

				Opportunity op = verificarOportunidad(lcr);

				System.assert(
						op.Aporta_Ingresos_Codeudor_1__c,
						'El campo aporta ingresos del codeudor 1 no se está actualizando correctamente'
				);

				System.assert(
						! op.Aporta_Ingresos_Codeudor_2__c,
						'Solo se creó un codeudor para esta prueba'
				);

				System.assert(
						! op.Aporta_Ingresos_Codeudor_3__c,
						'Solo se creó un codeudor para esta prueba'
				);

				Solicitud_de_credito__c sc = verificarSolicitud(lcr);
				Radicacion_de_credito__c rc = verificarRadicacionDeCredito(sc);

				System.assertEquals(
						rc.Aporta_Ingresos_Codeudor_1__c,
						'Si',
						'El campo aporta ingresos del codeudor 1 no se está actualizando correctamente en la radicación de crédito'
				);

				System.assertEquals(
						rc.Aporta_ingresos_codeudor_2__c,
						null,
						'Solo se creó un codeudor para esta prueba'
				);

				System.assertEquals(
						rc.Aporta_Ingresos_Codeudor_3__c,
						null,
						'Solo se creó un codeudor para esta prueba'
				);

				System.assertEquals(
						rc.Familiar_Nombre_y_Apellido_codeudor1__c,
						cod.Nombres_Ref_Familiar__c + ' ' + cod.Apellidos_Ref_Familiar__c,
						'El nombre del codeudor no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Parentesco_familiar_codeduor1__c,
						cod.Parentesco_Ref_Familiar__c,
						'El Parentesco familiar del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Direccion_familiar_codeudor1__c,
						cod.Direccion_referencia_familiar_codeudor__c,
						'La dirección familiar del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Telefono_familiar_codeudor1__c,
						String.valueOf(cod.Celular_Ref_Familiar__c),
						'El teléfono de la referencia familiar del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Profesion_o_actividad_codeudor1__c,
						String.valueOf(cod.Profesion_o_Actividad__c),
						'La actividad del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Ciudad_familiar_codeudor1__c,
						cod.Ciudad_Ref_Familiar__c,
						'La ciudad de la referencia familiar del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Personal_Nombre_y_Apellido_codeudor1__c,
						cod.Nombres_Ref_Personal__c + ' ' + cod.Apellidos_Ref_Personal__c,
						'Los nombres y apellidos de la referencia personal del codeudor 1 no se actualizaron correctamente'
				);

				System.assertEquals(
						rc.Parentesco_personal_codeudor1__c,
						cod.Relacion__c,
						'El parentesco personal del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Direccion_personal_codeudor1__c,
						cod.Direccion_referencia_personal_codeudor__c,
						'La dirección de la referencia personal del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Telefono_personal_codeudor1__c,
						String.valueOf(cod.Celular_Ref_Personal__c),
						'El teléfono de la referencia personal del codeudor 1 no se actualizó correctamente'
				);

				System.assertEquals(
						rc.Ciudad_personal_codeudor1__c,
						cod.Ciudad_Ref_Personal__c,
						'La ciudad de la referencia personal del codeudor 1 no se actualizó correctamente'
				);
			}
		Test.stopTest();

	}

	@isTest static void conversion_de_lead_sin_codeudor_con_informacion_minima() {

		Lead lead = new Lead(
				FirstName = 'TestName',
				LastName = 'Test',
				Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
				Email = 'test@test.com',
				Tipo_de_documento__c = 'Cédula ciudadanía',
				Phone = '1234567',
				Telefono_Actividad_Economica__c = '123456789',
				Telefono_referencia_familiar__c = '12345678',
				Telefono_referencia_personal__c = '12345678',
				Canal_digital__c = 'Si'
		);

		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}


		Test.startTest();
			Database.LeadConvertResult lcr = convertLead(lead.Id);
		Test.stopTest();
		verificarCuenta(lead);
		Solicitud_de_credito__c sc = verificarSolicitud(lcr);
		verificarRadicacionDeCredito(sc);
	}
	
	@isTest static void conversion_de_lead_con_un_codeudor() {

		Id asesorId = '005o0000002P5KY';
		Lead lead = TestDataFactory.createLead(asesorId);
		System.assert(lead != null, 'El candidato no fué insertado.');

		Id codeudorId = TestDataFactory.createCodeudor(lead.Id);
		User asesorComercial = [select Id from User where Id = :asesorId];
		//El codeudor está enlazado a la cuenta principal?
		Codeudor__c cod = [select Numero_de_documento__c from Codeudor__c where Id = :codeudorId];
		Test.startTest();
			System.runAs(asesorComercial){
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

				Account codeudor = [
						SELECT
								Id,
								Cliente_deudor__c,
								Numero_de_documento__c
						FROM Account
						WHERE Numero_de_documento__c = :String.valueOf(cod.Numero_de_documento__c)
				];
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
			}
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
		System.assert(lead != null, 'El candidato no fué insertado.');
		User asesorComercial = [select Id from User where Id = '005o0000002P5KY'];
		System.runAs(asesorComercial){

			Database.LeadConvertResult lcr = convertLead(lead.id);
			verificarCuenta(lead);
			verificarOportunidad(lcr);
			Solicitud_de_credito__c sc = verificarSolicitud(lcr);
			verificarRadicacionDeCredito(sc);
		}

		//System.debug('conversion_de_lead_asignado_a_un_asesor -> lead: ' + lead);


		Test.stopTest();
	}

	@isTest
	public static void solicitud_de_vivienda_nueva()
	{
		Lead viviendaNueva = TestDataFactory.createLead('Crédito de vivienda nueva');
		System.assert(viviendaNueva != null, 'El candidato no fué insertado.');
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
		System.assert(asignacionDeCupo != null, 'El candidato no fué insertado.');
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
		System.assert(lead != null, 'El candidato no fué insertado.');
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
		System.assert(lead != null, 'El candidato no fué insertado.');
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

		Test.startTest();

		User user = getComercialUser();
		System.runAs(user)
		{
			Lead lead = TestDataFactory.createLead();
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

	@isTest public static void los_codeudores_se_eliminan_despues_de_la_conversion()
	{
		Id asesorId = '005o0000002P5KY';
		Lead lead = TestDataFactory.createLead(asesorId);

		User asesorComercial = [select Id from User where Id = '005o0000002P5KY'];
		Set<Id> setCodeudores = new Set<Id>();
		setCodeudores.add(TestDataFactory.createCodeudor(lead.Id));
		setCodeudores.add(TestDataFactory.createCodeudor(lead.Id));

		Test.startTest();
	       System.runAs(asesorComercial){

			   Database.LeadConvertResult lcr = convertLead(lead.id);
			   //Existen 2 cuentas de tipo codeudor enlazadas a la cuenta principal?
			   System.assert(
					   [select count() from Account where Cliente_deudor__c = :lcr.getAccountId()] == 2,
					   'Se esperaba encontrar 2 cuentas de tipo codeudor'
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

			   //Los codeudores se eliminaron?
			   List<Codeudor__c> codeudores = new List<Codeudor__c>();
			   codeudores = [SELECT Id FROM Codeudor__c WHERE Candidato__c = :lead.Id];
			   System.assertEquals(codeudores.size(), 0, 'Los codeudores se deben eliminar despues de la conversión');
		   }


	    Test.stopTest();
	}

	public static User getComercialUser()
	{
		Profile asesorComercial = [SELECT Id, Name FROM Profile WHERE Name = 'Asesor comercial canal digital'];
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
		if(leadId != null){

			Database.LeadConvertResult lcr = TestDataFactory.leadConversion(leadId);
			if( ! lcr.isSuccess() ){
				if(lcr.getErrors().size() > 0){
					System.debug('Errores al convertir el candidato: ');
					for(Database.Error error : lcr.getErrors()){
						System.debug(error.getStatusCode() + ': ' + error.getMessage());
						System.debug('Verificar los siguientes campos: ' + error.getFields());
					}
				}
			}
			System.assert(lcr.isSuccess(), 'La conversión no fué exitosa.');
			return lcr;
		}
		System.debug('Es necesario el id del candidato para ejecutar esta función');
		return null;

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
						Solicitud_de_credito__c,
						Aporta_ingresos_codeudor_1__c,
						Aporta_ingresos_codeudor_2__c,
						Aporta_ingresos_codeudor_3__c,

						Familiar_Nombre_y_Apellido_codeudor1__c,
						Parentesco_familiar_codeduor1__c,
						Direccion_familiar_codeudor1__c,
						Telefono_familiar_codeudor1__c,
						Ciudad_familiar_codeudor1__c,

						Personal_Nombre_y_Apellido_codeudor1__c,
						Parentesco_personal_codeudor1__c,
						Direccion_personal_codeudor1__c,
						Telefono_personal_codeudor1__c,
						Ciudad_personal_codeudor1__c,
						Profesion_o_actividad_codeudor1__c,
								
						Familiar_Nombre_y_Apellido_codeudor2__c,
						Profesion_o_actividad_codeudor2__c,
						Parentesco_familiar_codeudor2__c,
						Direccion_familiar_codeudor2__c,
						Telefono_familiar_codeudor2__c,
						Ciudad_familiar_codeudor2__c,

						Personal_Nombre_y_Apellido_codeudor2__c,
						Parentesco_personal_codeudor2__c,
						Direccion_personal_codeudor2__c,
						Telefono_personal_codeudor2__c,
						Ciudad_personal_codeudor2__c,

						Familiar_Nombre_y_Apellido_codeudor3__c,
						Parentesco_falimiar_codeudor3__c,
						Profesion_o_actividad_codeudor3__c,
						Direccion__c,
						Telefono_familiar_codeudor3__c,
						Ciudad_familiar_codeudor3__c,

						Personal_Nombre_y_Apellido_codeudor3__c,
						Parentesco_personal_codeudor3__c,
						Direccion_personal_codeudor3__c,
						Telefono_personal_codeudor3__c,
						Ciudad_personal_codeudor3__c
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
						Codeudor_3__c,
						Aporta_Ingresos_Codeudor_1__c,
						Aporta_Ingresos_Codeudor_2__c,
						Aporta_Ingresos_Codeudor_3__c
				FROM Opportunity
				WHERE AccountId = :lcr.getAccountId()
		];
		System.assertEquals(op.Id, lcr.getOpportunityId(), 'No se creó la oportunidad en la conversión del candidato.');
		System.assertEquals(op.AccountId, lcr.getAccountId(), 'La oportunidad no está enlazada a la cuenta principal');

		return op;
	}
}