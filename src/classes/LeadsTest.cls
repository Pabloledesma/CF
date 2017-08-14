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
			AND Numero_de_Candidatos_asignados__c = 0
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

		System.assertEquals(
			0,
			candidatosAsignadosAntesDelCorte,
			'Existen candidatos'
		);

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
        	6,
        	candidatosAsignadosDespuesDelCorte,
        	'El número de candidatos asignados no corresponde a los candidatos creados'
        );

        /**
        * Segunda ronda de candidatos
        **/
  //      List<Lead> segundaRonda = new List<Lead>();
		//for(Integer i = 0; i < 8; i++){
		//	segundaRonda.add(TestDataFactory.createRawLead());
		//}
		//Database.SaveResult[] resSegundaRonda = Database.Insert(segundaRonda, false);
		//for(Database.SaveResult result : resSegundaRonda){
		//	if( !result.isSuccess() ){
		//		for(Database.Error error : result.getErrors()){
		//			System.debug(
		//				error.getMessage()
		//			);
		//		}
		//	}
		//}

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

		//System.assertEquals(
		//	2,
		//	lstUsuariosSegundaRonda[0].Numero_de_Candidatos_asignados__c,
		//	'El primer usuario debería tener 2 candidatos asignados'	
		//);

		//System.assertEquals(
		//	3,
		//	lstUsuariosSegundaRonda[4].Numero_de_Candidatos_asignados__c,
		//	'El penultimo usuario debería tener 3 candidatos asignados'	
		//);

		//System.assertEquals(
		//	3,
		//	lstUsuariosSegundaRonda[5].Numero_de_Candidatos_asignados__c,
		//	'El último usuario debería tener 3 candidatos asignados'	
		//);
	}

	//@isTest
	//static void un_usuario_inactivo()
	//{
	//	Test.startTest();
		
	//	User inactivo = new User();
	//	inactivo = [
	//		SELECT 
	//			Id,
	//			Habilitado_Canal_Digital__c
	//		FROM User
	//		WHERE Profile.Name = 'Asesor comercial canal digital'
	//		AND Habilitado_Canal_Digital__c = true
	//		AND isActive = true
	//		AND Numero_de_Candidatos_asignados__c = 0
	//		LIMIT 1
	//	];
	//	inactivo.Habilitado_Canal_Digital__c = false;
	//	update inactivo;

	//	List<User> lstUsuariosActivosBeforeTest = [
	//		SELECT 
	//			Id,
	//			Habilitado_Canal_Digital__c
	//		FROM User
	//		WHERE Profile.Name = 'Asesor comercial canal digital'
	//		AND Habilitado_Canal_Digital__c = true
	//		AND isActive = true
	//		AND Numero_de_Candidatos_asignados__c = 0
	//	];

	//	System.assertEquals(
	//		5,
	//		lstUsuariosActivosBeforeTest.size(),
	//		'Deben existir 5 usuarios activos'
	//	);

	//	Set<Id> idUsuarios = new Set<Id>();
	//	for(User u : lstUsuariosActivosBeforeTest){
	//		idUsuarios.add(u.Id);
	//	}

	//	Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
	//	Profile administrador = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];

	//	Integer candidatosAsignadosAntesDelCorte = [
	//		select 
 //       		count() 
 //       	from Lead 
 //       	where OwnerId IN :idUsuarios 
 //       	AND Canal_digital__c = 'Si'
	//		AND isConverted = false
	//		AND Concepto_del_candidato__c = 'VIABLE'
	//	];

	//	System.assertEquals(
	//		0,
	//		candidatosAsignadosAntesDelCorte,
	//		'Existen candidatos'
	//	);

	//	/**
	//	* Primera ronda de candidatos
	//	**/
	//	List<Lead> lstCandidatos = new List<Lead>();
	//	for(Integer i = 0; i < 6; i++){
	//		lstCandidatos.add(TestDataFactory.createRawLead());
	//	}
	//	Database.SaveResult[] resCandidatos = Database.Insert(lstCandidatos, false);
	//	List<Id> candidatosInsertados = new List<Id>();
	//	for(Database.SaveResult result : resCandidatos){
	//		if( result.isSuccess() ){
	//			candidatosInsertados.add(result.getId());
	//		} else {
	//			for(Database.Error error : result.getErrors()){
	//				System.debug(
	//					error.getMessage()
	//				);
	//			}
	//		}
	//	}

	//	System.assertEquals(
	//		false,
	//		candidatosInsertados.isEmpty(),
	//		'No se insertaron los candidatos'
	//	);

 //       // El número de candidatos asignados debe ser mayor a cero
 //       Integer candidatosAsignadosDespuesDelCorte = [
 //       	select 
 //       		count() 
 //       	from Lead 
 //       	where OwnerId IN :idUsuarios 
 //       	AND Canal_digital__c = 'Si'
	//		AND isConverted = false
	//		AND Concepto_del_candidato__c = 'VIABLE'
 //       ];

 //       List<Lead> pendientesPorAsignar = [
	//		select 
	//			id,
	//			OwnerId
	//		from Lead
	//		where OwnerId NOT IN :idUsuarios
	//		AND Canal_digital__c = 'Si'
	//		AND isConverted = false
	//		AND Concepto_del_candidato__c = 'VIABLE'
 //       ];
 //       if(!pendientesPorAsignar.isEmpty()){
 //       	System.debug('Pendientes por asignar: ');
	//        for(Lead lead : pendientesPorAsignar){
	//        	System.debug(lead);
	//        }
 //       }

 //       System.assertEquals(
 //       	true,
 //       	candidatosAsignadosDespuesDelCorte > candidatosAsignadosAntesDelCorte,
 //       	'No se asignaron candidatos'
 //       );

 //       //Verificar que no queden candidatos por asignar
 //       System.assertEquals(
 //       	0,
 //       	[select count() from Lead where Canal_digital__c = 'Si' AND Viable__c = '1' AND Owner.ProfileId = :administrador.Id AND isConverted = false],
 //       	'No se asignaron todos los candidatos'
 //       );

 //       System.assertEquals(
 //       	6,
 //       	candidatosAsignadosDespuesDelCorte,
 //       	'El número de candidatos asignados no corresponde a los candidatos creados'
 //       );

 //       /**
 //       * Segunda ronda de candidatos
 //       **/
 //       List<Lead> segundaRonda = new List<Lead>();
	//	for(Integer i = 0; i < 8; i++){
	//		segundaRonda.add(TestDataFactory.createRawLead());
	//	}
	//	Database.SaveResult[] resSegundaRonda = Database.Insert(segundaRonda, false);
	//	for(Database.SaveResult result : resSegundaRonda){
	//		if( !result.isSuccess() ){
	//			for(Database.Error error : result.getErrors()){
	//				System.debug(
	//					error.getMessage()
	//				);
	//			}
	//		}
	//	}

	//	Test.stopTest();

	//	List<User> lstUsuariosSegundaRonda = [
	//		SELECT 
	//			Id,
	//			Name,
	//			Numero_de_Candidatos_asignados__c
	//		FROM User
	//		WHERE Profile.Name = 'Asesor comercial canal digital'
	//		AND Habilitado_Canal_Digital__c = true
	//		AND isActive = true
	//		AND Numero_de_Candidatos_asignados__c > 0
	//		ORDER BY Numero_de_Candidatos_asignados__c ASC
	//	];

	//	System.assertEquals(
	//		false,
	//		lstUsuariosSegundaRonda.isEmpty(),
	//		'No se asignaron candidatos en la segunda ronda'
	//	);

	//	System.assertEquals(
	//		2,
	//		lstUsuariosSegundaRonda[0].Numero_de_Candidatos_asignados__c,
	//		'El primer usuario debería tener 2 candidatos asignados'	
	//	);

	//	System.assertEquals(
	//		3,
	//		lstUsuariosSegundaRonda[1].Numero_de_Candidatos_asignados__c,
	//		'El segundo usuario debería tener 3 candidatos asignados'	
	//	);

	//	System.assertEquals(
	//		3,
	//		lstUsuariosSegundaRonda[4].Numero_de_Candidatos_asignados__c,
	//		'El último usuario debería tener 3 candidatos asignados'	
	//	);
	//}
}