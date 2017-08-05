@isTest
private class AsignacionDeCandidatosTest
{
	public static String CRON_EXP = '0 30 9 3 8 2017';
	
	@isTest
	static void asignacion_par()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		Integer candidatosAsignadosAntesDelCorte = [
			SELECT 
				count() 
			FROM Lead 
			WHERE Canal_digital__c = 'Si' 
			AND Viable__c = '1' 
			AND Owner.ProfileId = :asesorCanalDigital.Id
		];

		//Crea los usuarios
		List<User> lstUsuarios = new List<User>();
		for(Integer i = 0; i == 3; i++){
			lstUsuarios.add(TestDataFactory.createUser(asesorCanalDigital.Id, i));
		}

		// Crea los candidatos
		List<Lead> lstCandidatos = new List<Lead>();
		for(Integer i = 0; i == 7; i++){
			lstCandidatos.add(TestDataFactory.createRawLead());
		}

		Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('primerCorte',
            CRON_EXP,
            new AsignacionDeCandidatos());         
        
        Test.stopTest();

        // El número de candidatos asignados debe ser mayor a cero
        Integer candidatosAsignadosDespuesDelCorte = [
        	SELECT 
        		count() 
        	FROM Lead 
        	WHERE Canal_digital__c = 'Si' 
        	AND Viable__c = '1' 
        	AND Owner.ProfileId = :asesorCanalDigital.Id
        ];
        System.assertEquals(
        	true,
        	(candidatosAsignadosDespuesDelCorte - candidatosAsignadosAntesDelCorte) > 0,
        	'No se asignaron candidatos'
        );

        //Verificar que no queden candidatos por asignar
        System.assertEquals(
        	0,
        	[select count() from Lead where Canal_digital__c = 'Si' AND Viable__c = '1' AND Owner.ProfileId = :administrador.Id],
        	'No se asignaron todos los candidatos'
        );
	}
}