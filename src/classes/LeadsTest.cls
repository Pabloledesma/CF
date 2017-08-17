@isTest
private class LeadsTest
{
	@isTest
	static void todos_los_usuarios_activos()
	{
		Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
		Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];
		
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

		List<Lead> lstActualizarCandidatos = new List<Lead>();
		for(Id idLead : candidatosInsertados){
			lstActualizarCandidatos.add(
				new Lead(
					Id = idLead,
					Concepto_del_candidato__c = 'VIABLE'
				)
			);
		}

		Database.SaveResult[] results = Database.update(lstActualizarCandidatos, false);
		for(Database.SaveResult result : results){
			if( ! result.isSuccess() ){
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

	@isTest
	static void asignacion_en_la_actualizacion_de_candidato_no_viable_a_viable()
		{
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
		
		Integer candidatosAsignadosAntes = [
			select 
        		count() 
        	from Lead 
        	where OwnerId IN :idUsuarios 
        	AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
		];

		Lead leadNoViable = TestDataFactory.createRawLead();
		leadNoViable.Concepto_del_candidato__c = 'NO VIABLE';

		Test.startTest();
		Database.SaveResult result = Database.insert(leadNoViable, false);
		if(!result.isSuccess()){
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}

		System.assert(result.isSuccess(), 'No se pudo insertar el candidato');

		Lead toUpdate = new Lead(Id = result.getId(), Concepto_del_candidato__c = 'VIABLE');
		update toUpdate;
		Test.stopTest();

		Integer candidatosAsignadosDespues = [
			select 
        		count() 
        	from Lead 
        	where OwnerId IN :idUsuarios 
        	AND Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE'
		];

		System.assertEquals(
			true, 
			candidatosAsignadosDespues > candidatosAsignadosAntes,
			'El candidato no fué asignado tras la actualización.'
		);
		
	}
}