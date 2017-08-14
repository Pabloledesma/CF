public without sharing class AsignacionDeCandidatos {

    /**
    * Asigna el candidato solo si el número de candidatos asignados es menor que la meta asignada por el gerente
    **/
	public static void asignar(List<Lead> candidatosViables)
	{
		//Seleccionar usuarios activos 
        List<User> lstUsuariosActivos = [
            SELECT 
                Id,
                Name,
                Numero_de_candidatos_asignados__c,
                Meta_Canal_Digital__c
            FROM User
            WHERE Profile.Name = 'Asesor comercial canal digital'
            AND Habilitado_Canal_Digital__c = true
            AND isActive = true
            ORDER BY Numero_de_candidatos_asignados__c ASC, Name
        ];

		List<Lead> leadsPorAsignar = new List<Lead>();
		Integer i = 0;
		for(Lead lead : candidatosViables){
			User asesor = lstUsuariosActivos[ i ];
	        if(asesor.Numero_de_candidatos_asignados__c < asesor.Meta_Canal_Digital__c){
	        	System.debug('Candidatos asignados: ' + asesor.Numero_de_candidatos_asignados__c + ' Meta: ' + asesor.Meta_Canal_Digital__c);
	            System.debug('Asignando candidato a ' + asesor.Name);
	            lead.OwnerId = asesor.Id;
	            leadsPorAsignar.add(lead);
	        } else {
                // Aqui es buena idea enviar un correo al gerente y al asesor
                System.debug(asesor.Name + ' ya cumplió la meta!');

            }
            i++;
            if(i == lstUsuariosActivos.size()) i = 0;
		}

		if(!leadsPorAsignar.isEmpty()){
			Database.SaveResult[] lstResults = Database.update(leadsPorAsignar, false);
            
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

            /**
            * Actualización del número de candidatos asignados al asesor del canal digital
            **/
            Map<Id, Integer> mapActualizarCandidatosAsignados = new Map<Id, Integer>(); 
            for(Lead lead : candidatosViables){
                User user = new User();
                user = [select Id, ProfileId, Email, Numero_de_candidatos_asignados__c from User where Id = :lead.OwnerId];
                mapActualizarCandidatosAsignados.put(user.Id, [select count() from Lead where OwnerId = :user.Id and IsConverted = false]);
            }

           if(!mapActualizarCandidatosAsignados.isEmpty()){
                System.debug('LeadsTrigger->Actualizando candidatos');
                UserHandler.actualizarCandidatosAsignados(mapActualizarCandidatosAsignados);
           } 
		}//if(!leadsPorAsignar.isEmpty()){
	}
}