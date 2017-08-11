@isTest
private class AsignacionDeCandidatosTest
{
	public static string cron_exp = '0 56 11 * * ?';
	
	@isTest
	static void todos_los_usuarios_activos()
	{
		List<User> lstUsuariosActivosBeforeTest = [
			SELECT 
				Id
			FROM User
			WHERE Profile.Name = 'Asesor comercial canal digital'
			AND Habilitado_Canal_Digital__c = true
			AND isActive = true
		];

		System.debug('Usuarios activos antes de iniciar la prueba: ' + lstUsuariosActivosBeforeTest.size());

		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];

		Test.startTest();

		//Crea los usuarios
		List<User> lstUsuarios = new List<User>();
		for(Integer i = 0; i < 7; i++){
			lstUsuarios.add(TestDataFactory.createUser(asesorCanalDigital.Id, i));
		}

		Set<Id> idUsuarios = new Set<Id>();
		Database.SaveResult[] resUsuarios = Database.Insert(lstUsuarios, false);
		for(Database.SaveResult result : resUsuarios){
			if( result.isSuccess() ){
				idUsuarios.add(result.getId());
			} else {
				for(Database.Error error : result.getErrors()){
					System.debug(
						error.getMessage()
					);
				}
			}
		}

		// Crea los candidatos
		List<Lead> lstCandidatos = new List<Lead>();
		for(Integer i = 0; i < 7; i++){
			lstCandidatos.add(TestDataFactory.createRawLead());
		}


		Database.SaveResult[] resCandidatos = Database.Insert(lstCandidatos, false);
		List<Id> candidatosInsertados = new List<Id>();
		for(Database.SaveResult result : resCandidatos){
			if( result.isSuccess() ){
				candidatosInsertados.add(result.getId());
			} else {
				for(Database.Error error : result.getErrors()){
					System.debug(
						error.getMessage()
					);
				}
			}
		}

		System.assertEquals(
			false,
			candidatosInsertados.isEmpty(),
			'No se insertaron los candidatos'
		);

		Integer candidatosAsignadosAntesDelCorte = [
			select 
        		count() 
        	from Lead 
        	where OwnerId IN :idUsuarios 
        	AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
		];

		System.assertEquals(
			0,
			candidatosAsignadosAntesDelCorte
		);

		
        // Schedule the test job
        String jobId = System.schedule('primerCorte',
            CRON_EXP,
            new AsignacionDeCandidatos());         
        
        Test.stopTest();

        // El número de candidatos asignados debe ser mayor a cero
        Integer candidatosAsignadosDespuesDelCorte = [
        	select 
        		count() 
        	from Lead 
        	where OwnerId IN :idUsuarios 
        	AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
        ];

        List<Lead> pendientesPorAsignar = [
			select 
				id,
				OwnerId
			from Lead
			where OwnerId NOT IN :idUsuarios
			AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
        ];
        if(!pendientesPorAsignar.isEmpty()){
        	System.debug('Pendientes por asignar: ');
	        for(Lead lead : pendientesPorAsignar){
	        	System.debug(lead);
	        }
        }

        System.assertEquals(
        	true,
        	candidatosAsignadosDespuesDelCorte > candidatosAsignadosAntesDelCorte,
        	'No se asignaron candidatos'
        );

        //Verificar que no queden candidatos por asignar
        System.assertEquals(
        	0,
        	[select count() from Lead where Canal_digital__c = 'Si' AND Viable__c = '1' AND Owner.ProfileId = :administrador.Id AND isConverted = false],
        	'No se asignaron todos los candidatos'
        );

        System.assertEquals(
        	7,
        	candidatosAsignadosDespuesDelCorte,
        	'El número de candidatos asignados no corresponde a los candidatos creados'
        );
	}
}