@isTest
private class AsesorCanalDigitalTriggerTest
{
	@isTest
	static void modificacion_del_campo_activo()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		User u = TestDataFactory.createUser(asesorCanalDigital.Id);
		insert u;

		System.assertEquals(
			1, 
			[SELECT count() FROM Asesor_Canal_Digital__c WHERE Activo__c = true],
			'El asesor no fué creado'
		);

		Test.startTest();
			Asesor_Canal_Digital__c asesor = [
				SELECT 
					Id, 
					Activo__c
				FROM Asesor_Canal_Digital__c
				WHERE Email__c = :u.Email 
			];

			asesor.Activo__c = false;

			update asesor;

			System.assertEquals(
				1, 
				[SELECT count() FROM User WHERE Habilitado_Canal_Digital__c = false],
				'El usuario no fué actualizado'
			);
		Test.stopTest();
	}
}