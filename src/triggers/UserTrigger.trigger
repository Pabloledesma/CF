trigger UserTrigger on User (before insert, after update) {
	Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
	if(Trigger.isInsert){
		/**
		* @mapAsesoresCD Información básica para crear el Asesor comercial canal digital Map<Nombre, Correo>
		**/
		Map<String, String> mapAsesoresCD = new Map<String, String>();
		for(User u : Trigger.new){
			if(u.isActive && u.ProfileId == asesorCanalDigital.Id){
				mapAsesoresCD.put(u.FirstName + ' ' + u.LastName, u.Email);
			}
		}
		
		if(! mapAsesoresCD.isEmpty()) UserHandler.crearAsesoresCanalDigital( mapAsesoresCD );
	}

	if(Trigger.isUpdate){
		
		Map<String, String> mapAsesoresCD = new Map<String, String>();

		Map<Id, String> mapUdate = new Map<Id, String>();
		Set<String> setDelete = new Set<String>();	//Lista de asesores a eliminar
		for(User u : Trigger.new){
			User oldUser = Trigger.oldMap.get(u.Id);
			//System.debug(
			//	'u.isActive' + u.isActive + '\n' +
			//	'oldUser.isActive' + oldUser.isActive + '\n' +
			//	'u.ProfileId' + u.ProfileId + '\n' +
			//	'oldUser.ProfileId' + oldUser.ProfileId
			//);
			if(u.isActive != oldUser.isActive || u.ProfileId != oldUser.ProfileId){
				List<Asesor_Canal_Digital__c> lstAsesor = [
					SELECT
						Id,
						Email__c,
						Activo__c
					FROM 
						Asesor_Canal_Digital__c
					WHERE Email__c = :u.Email 	
				];
				System.debug(
						'u.isActive: ' + u.isActive + '\n' +
						'u.Email: ' + u.Email + '\n' +
						'lstAsesor.isEmpty(): ' + lstAsesor.isEmpty() + '\n' +
						'u.isActive != oldUser.isActive: ' + String.valueOf(u.isActive != oldUser.isActive) + '\n' +
						'u.ProfileId: ' + u.ProfileId + '\n' +
						'uoldUser.ProfileId: ' + oldUser.ProfileId
					);
				if( 
					u.isActive != oldUser.isActive && u.isActive == false ||
					u.ProfileId != oldUser.ProfileId && u.ProfileId != asesorCanalDigital.Id
					){
					System.debug('eliminando...');
					setDelete.add(u.Email);
				}

				//Agrerga un asesor
				if(u.ProfileId != oldUser.ProfileId && u.ProfileId == asesorCanalDigital.Id && lstAsesor.isEmpty()){
					System.debug('UserTrigger->Agregando el asesor: ' + u.Email);
					mapAsesoresCD.put( u.FirstName + ' ' + u.LastName, u.Email ); 
				}
			}
		}
		if( ! mapAsesoresCD.isEmpty() ) UserHandler.crearAsesoresCanalDigital( mapAsesoresCD );
		if( ! setDelete.isEmpty() ) {
			System.debug('agregando asesores para eliminar: ' + setDelete);			
			UserHandler.eliminarAsesoresCanalDigital(setDelete); 
		} 
	} // Trigger.isUpdate
}