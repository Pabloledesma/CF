@isTest
private class UserTriggerTest
{
	@isTest
	static void insertOneUser()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		User user = TestDataFactory.createUser(asesorCanalDigital.Id, 1);
		User admin = TestDataFactory.createUser(administrador.Id, 2);

		System.runAs(admin){
			Test.startTest();
				insert user;
			Test.stopTest();
		}

		System.assertEquals(
			1,
			[SELECT count() FROM Asesor_Canal_Digital__c],
			'El asesor no fué creado'
		);
	}

	@isTest
	static void insertMultipleUsers()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		User user = TestDataFactory.createUser(asesorCanalDigital.Id, 10);
		User admin = TestDataFactory.createUser(administrador.Id, 11);

		List<User> users = new List<User>();
		for(Integer i = 0; i < 5; i++){
			users.add(TestDataFactory.createUser(asesorCanalDigital.Id, i));

		}
		
		System.runAs(admin){
			Test.startTest();
				insert users;
			Test.stopTest();
		}
		
		System.assertEquals(
			5,
			[SELECT count() FROM Asesor_Canal_Digital__c],
			'El número de asesores no es el esperado'
		);
	}

	// mix dml exception!
	@isTest
	static void updateTheFieldIsActiveToFalse()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		User user = TestDataFactory.createUser(asesorCanalDigital.Id, 1);
		User admin = TestDataFactory.createUser(administrador.Id, 2);

		insert user;
		user.isActive = false;

		System.runAs(admin){
			Test.startTest();
				update user;
			Test.stopTest();
			System.assertEquals(
				0,
				[SELECT count() FROM Asesor_Canal_Digital__c],
				'El asesor no fué eliminado'
			);
		}
	}

	@isTest
	static void updateProfileForDelete()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		User user = TestDataFactory.createUser(asesorCanalDigital.Id, 1);
		User admin = TestDataFactory.createUser(administrador.Id, 2);
		insert user;

		System.runAs(admin){
			Test.startTest();
				user.ProfileId = administrador.Id;
				update user;
			Test.stopTest();
			System.assertEquals(
				0,
				[SELECT count() FROM Asesor_Canal_Digital__c],
				'El asesor no fué eliminado'
			);
		}
	}

	@isTest
	static void updateProfileForInsert()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		User user = TestDataFactory.createUser(administrador.Id, 1);
		User admin = TestDataFactory.createUser(administrador.Id, 2);

		insert user;
		user.ProfileId = asesorCanalDigital.Id;
		System.runAs(admin){
		Test.startTest();
			update user;
		Test.stopTest();
		}
		System.assertEquals(
			1,
			[SELECT count() FROM Asesor_Canal_Digital__c],
			'El asesor no fué insertado'
		);
	}

}