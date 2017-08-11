public class UserHandler {

	@future
	public static void crearAsesoresCanalDigital(List<String> lstEmails){
		if(! lstEmails.isEmpty()){
			List<Asesor_Canal_Digital__c> lstAsesores = new List<Asesor_Canal_Digital__c>();
			for(String email : lstEmails){
				lstAsesores.add(new Asesor_Canal_Digital__c(Email__c = email));
			}
			System.debug('UserHandler: ' + lstAsesores);
			MixedDMLOps.ins(lstAsesores); 
		}
	}

	@future
	public static void eliminarAsesoresCanalDigital(Set<Id> asesores)
	{
		System.debug('Asesores para eliminar: ' + asesores);
		List<Asesor_Canal_Digital__c> lstAsesores = new List<Asesor_Canal_Digital__c>();
		for(Id asesorId : asesores){
			lstAsesores.add(new Asesor_Canal_Digital__c(Id = asesorId));
		}
		MixedDMLOps.del(lstAsesores);
	}

	@future
	public static void actualizarCandidatosAsignados(Map<Id, Integer> usuarios)
	{
		List<User> toUpdate = new List<User>();
		Set<Id> idUsuarios = usuarios.keySet();
		for(Id userId : idUsuarios){
			toUpdate.add( 
				new User(
					Id = userId,
					Numero_de_candidatos_asignados__c = usuarios.get(userId)
				)
			);
		}

		if(!toUpdate.isEmpty()){
			Database.SaveResult[] results = MixedDMLOps.up(toUpdate);
			for(Database.SaveResult res : results){
				if(res.isSuccess()){
					System.debug('UserHandler->actualizando candidatos asignados: ' + res.getId());
				} else {
					for(Database.Error error : res.getErrors() ){
						System.debug(error.getMessage());
					}
				}
			}
		}
	}
}