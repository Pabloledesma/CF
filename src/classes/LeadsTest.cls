@isTest
private class LeadsTest
{
	@isTest
	static void crear_candidato_con_regla_de_asignacion()
	{
		// crear usuario
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		User user = TestDataFactory.createUser(asesorCanalDigital.Id);
		insert user;

		// Crear candidato
		Test.startTest();
		TestDataFactory.createLead();
		Test.stopTest();
		// Then

	}
}