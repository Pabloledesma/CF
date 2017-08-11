global class AsignacionDeCandidatos implements Schedulable {
	global void execute(SchedulableContext sc) {
		//Seleccionar candidatos viables
		List<Lead> lstCandidatos = [
			SELECT 
				Id,
				OwnerId,
				Numero_del_Candidato__c
			FROM Lead
			WHERE Canal_digital__c = 'Si'
			AND isConverted = false
			AND Concepto_del_candidato__c = 'VIABLE' 
		];

		System.debug('Candidatos viables: ' + lstCandidatos.size());

		//Seleccionar usuarios activos 
		List<User> lstUsuarios = [
			SELECT 
				Id
			FROM User
			WHERE Profile.Name = 'Asesor comercial canal digital'
			AND Habilitado_Canal_Digital__c = true
			AND isActive = true
		];

		System.debug('Usuarios activos: ' + lstUsuarios.size());

		//Cual es el número máximo de candidatos a asignar?

		// En caso de que el número de candidatos por usuario sea decimal, en la asignación
		// se redodeado al limite inferior y al último de los usuarios se le asignará un candidato adicional
		// Por el momento se asume que todos los usuarios tienen el mismo numero de candidatos asignados
		
		for(Lead lead : lstCandidatos){
			Integer numeroUsuario = Math.mod( Integer.valueOf(lead.Numero_del_Candidato__c), lstUsuarios.size() );
			lead.OwnerId = lstUsuarios[ numeroUsuario ].Id;
		}

		
		if(!lstCandidatos.isEmpty()){
			Database.SaveResult[] lstResults = Database.update(lstCandidatos, false);
			
			for(Database.SaveResult result : lstResults){
				if(result.isSuccess()){
					System.debug('Asignando candidatos: ' + result.getId());
				} else {
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