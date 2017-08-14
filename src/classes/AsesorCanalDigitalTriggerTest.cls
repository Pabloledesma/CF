@isTest
private class AsesorCanalDigitalTriggerTest
{
	@isTest
	static void modificacion_del_campo_activo()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		User u = TestDataFactory.createUser(asesorCanalDigital.Id);
		insert u;
		List<Asesor_Canal_Digital__c> lstAsesor = [SELECT Id, Activo__c, Email__c FROM Asesor_Canal_Digital__c WHERE Activo__c = true];
		System.assertEquals(
			1, 
			lstAsesor.size(),
			'El asesor no fué creado'
		);

		lstAsesor[0].Activo__c = false;
		Test.startTest();
			update lstAsesor;
		Test.stopTest();
		System.assertEquals(
			1, 
			[SELECT count() FROM User WHERE Habilitado_Canal_Digital__c = false AND Email = :lstAsesor[0].Email__c],
			'El usuario no fué actualizado'
		);
	}

	@isTest
	static void modificacion_de_la_meta()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		User u = TestDataFactory.createUser(asesorCanalDigital.Id);
		insert u;
		List<Asesor_Canal_Digital__c> lstAsesor = [SELECT Id, Meta__c, Email__c FROM Asesor_Canal_Digital__c WHERE Activo__c = true];
		System.assertEquals(
			1, 
			lstAsesor.size(),
			'El asesor no fué creado'
		);

		lstAsesor[0].Meta__c = 20;
		Test.startTest();
			update lstAsesor;
		Test.stopTest();
		System.assertEquals(
			1, 
			[SELECT count() FROM User WHERE Meta_canal_digital__c = 20],
			'El usuario no fué actualizado'
		);
	}
}