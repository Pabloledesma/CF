@isTest
private class AsesorCanalDigitalTriggerTest
{
	@isTest
	static void modificacion_del_campo_activo()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		List<User> lstActivos = [
			SELECT 
				Email
			FROM User
			WHERE ProfileId = :asesorCanalDigital.Id
			AND isActive = true
			AND Habilitado_Canal_Digital__c = true
			LIMIT 1
		];

		System.assertEquals(1, lstActivos.size(), 'No se encontraron usuarios activos');

		Asesor_Canal_Digital__c asesor = new Asesor_Canal_Digital__c(Email__c = lstActivos[0].Email, Activo__c = true);

		Database.SaveResult result = Database.insert(asesor, false);
		if(!result.isSuccess()){
			System.debug('Errores al insertar el asesor: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}

		System.assert(result.isSuccess(), 'No fué posible crear el asesor.');
		
		Asesor_Canal_Digital__c asesorToUpdate = new Asesor_Canal_Digital__c(Id = result.getId(), Activo__c = false);
		
		Test.startTest();
			update asesorToUpdate;
		Test.stopTest();
	
		System.assertEquals(
			1, 
			[SELECT count() FROM User WHERE Habilitado_Canal_Digital__c = false AND Email = :lstActivos[0].Email],
			'El usuario no fué actualizado'
		);
	}

	@isTest
	static void modificacion_de_la_meta()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		List<User> lstActivos = [
			SELECT 
				Email
			FROM User
			WHERE ProfileId = :asesorCanalDigital.Id
			AND isActive = true
			AND Habilitado_Canal_Digital__c = true
			LIMIT 1
		];

		System.assertEquals(1, lstActivos.size(), 'No se encontraron usuarios activos');

		Asesor_Canal_Digital__c asesor = new Asesor_Canal_Digital__c(Email__c = lstActivos[0].Email, Activo__c = true);

		Database.SaveResult result = Database.insert(asesor, false);
		if(!result.isSuccess()){
			System.debug('Errores al insertar el asesor: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}

		System.assert(result.isSuccess(), 'No fué posible crear el asesor.');
		
		Asesor_Canal_Digital__c asesorToUpdate = new Asesor_Canal_Digital__c(Id = result.getId(), Meta__c = 2);
		
		Test.startTest();
			update asesorToUpdate;
		Test.stopTest();

		System.assertEquals(
			1, 
			[SELECT count() FROM User WHERE Meta_Canal_Digital__c = 2 AND Email = :lstActivos[0].Email],
			'El usuario no fué actualizado'
		);
	}
}