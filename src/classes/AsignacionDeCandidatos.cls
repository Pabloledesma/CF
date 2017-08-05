global class AsignacionDeCandidatos implements Schedulable {
	global void execute(SchedulableContext sc) {
		//Seleccionar candidatos viables
		List<Lead> lstCandidatos = [
			SELECT 
				Id,
				Viable__c
			FROM Lead
			WHERE Canal_digital__c = 'Si'
			AND isConverted = false
			AND Viable__c = '1' 
		];

		//Seleccionar usuarios activos 
		List<User> lstUsuarios = [
			SELECT 
				Id
			FROM User
			WHERE Profile.Name = 'Asesor comercial canal digital'
			AND isActive = true
		];

		//Contar los candidatos asignados por usuario
		Map<Id, Integer> candidatosAsignadosPorUsuario = new Map<Id, Integer>();
		for(User u : lstUsuarios){
			Integer numCandidatos = [SELECT count() FROM Lead WHERE OwnerId = :u.Id];
			candidatosAsignadosPorUsuario.put(u.Id, numCandidatos);
		}

		//Organizar los usuarios por número de leads asignados en orden descendiente 

		//Cuantos candidatos le corresponden a cada uno?
		Decimal candidatosPorUsuario = 0;
		if(!lstCandidatos.isEmpty()){
			candidatosPorUsuario = lstCandidatos.size() / lstUsuarios.size();
			System.debug('Candidatos por usuario: ' + candidatosPorUsuario);
		}

		//Cual es el número máximo de candidatos a asignar?

		 

		// En caso de que el número de candidatos por usuario sea decimal, en la asignación
		// se redodeado al limite inferior y al último de los usuarios se le asignará un candidato adicional
		// Por el momento se asume que todos los usuarios tienen el mismo numero de candidatos asignados
		Integer i = Integer.valueOf(candidatosPorUsuario);
		List<Lead> lstCandidatosAsignados = new List<Lead>();	
		for(User u : lstUsuarios){

			for(Integer y = 0; y == i; y++){

				if( (lstCandidatos.size() - 1) >= 0 ){
					Lead lead = lstCandidatos.get( lstCandidatos.size() - 1 );
					lead.OwnerId = u.Id;
					lstCandidatosAsignados.add(lead);
					lstCandidatos.remove( lstCandidatos.size() - 1 );
				}
				
			}
		}

		System.debug('Candidatos asignados: ' + lstCandidatosAsignados.size());
		if(!lstCandidatosAsignados.isEmpty()){
			Database.SaveResult[] lstResults = Database.update(lstCandidatosAsignados, false);
			
			for(Database.SaveResult result : lstResults){
				if(!result.isSuccess()){
					for(Database.Error error : result.getErrors()){
						System.debug(
							'Errores al asignar el candidato: \n' +
							error.getMessage() + '\n' +
							error.getFields()
						);
					}
				}
			}
		}
	}
}