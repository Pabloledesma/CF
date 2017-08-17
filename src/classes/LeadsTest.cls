@isTest
private class LeadsTest
{
	@isTest
	static void todos_los_usuarios_activos()
	{
		Test.startTest();
		
		List<User> lstUsuariosActivosBeforeTest = [
			SELECT 
				Id
			FROM User
			WHERE Profile.Name = 'Asesor comercial canal digital'
			AND Habilitado_Canal_Digital__c = true
			AND isActive = true
		];

		Set<Id> idUsuarios = new Set<Id>();
		for(User u : lstUsuariosActivosBeforeTest){
			idUsuarios.add(u.Id);
		}

		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];

		Integer candidatosAsignadosAntesDelCorte = [
			select 
        		count() 
        	from Lead 
        	where OwnerId IN :idUsuarios 
        	AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
		];

		/**
		* Primera ronda de candidatos
		**/
		List<Lead> lstCandidatos = new List<Lead>();
		for(Integer i = 0; i < 6; i++){
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
        	5,
        	candidatosAsignadosDespuesDelCorte,
        	'El número de candidatos asignados no corresponde a los candidatos creados'
        );

		Test.stopTest();

		List<User> lstUsuariosSegundaRonda = [
			SELECT 
				Id,
				Name,
				Numero_de_Candidatos_asignados__c
			FROM User
			WHERE Profile.Name = 'Asesor comercial canal digital'
			AND Habilitado_Canal_Digital__c = true
			AND isActive = true
			AND Numero_de_Candidatos_asignados__c > 0
			ORDER BY Numero_de_Candidatos_asignados__c ASC
		];

		System.assertEquals(
			false,
			lstUsuariosSegundaRonda.isEmpty(),
			'No se asignaron candidatos en la segunda ronda'
		);
	}
}