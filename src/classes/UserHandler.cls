public class UserHandler {

	@future
	public static void crearAsesoresCanalDigital(Map<String, String> mapAsesoresCD){
		List<Asesor_Canal_Digital__c> lstAsesores = new List<Asesor_Canal_Digital__c>();
		for(String name : mapAsesoresCD.keySet()){
			lstAsesores.add(new Asesor_Canal_Digital__c(Name = name, Email__c = mapAsesoresCD.get(name)));
		}
	
		System.debug('UserHandler: ' + lstAsesores);
		MixedDMLOps.ins(lstAsesores); 
	}

	@future
	public static void eliminarAsesoresCanalDigital(Set<String> asesores)
	{
		System.debug('Asesores para eliminar: ' + asesores);
		List<Asesor_Canal_Digital__c> lstAsesoresParaEliminar = [
			select
				Id
			from Asesor_Canal_Digital__c
			where Email__c IN :asesores
		];
		
		MixedDMLOps.del(lstAsesoresParaEliminar);
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

	@future
	public static void habilitarUsuario(Map<Id, Boolean> mapUsuarios)
	{
		List<User> toUpdate = new List<User>();
		Set<Id> idUsuarios = mapUsuarios.keySet();
		for(Id userId : idUsuarios){
			toUpdate.add( 
				new User(
					Id = userId,
					Habilitado_canal_digital__c = mapUsuarios.get(userId)
				)
			);
		}

		if(!toUpdate.isEmpty()){
			Database.SaveResult[] results = MixedDMLOps.up(toUpdate);
			for(Database.SaveResult res : results){
				if(res.isSuccess()){
					System.debug('UserHandler->habilitando: ' + res.getId());
				} else {
					for(Database.Error error : res.getErrors() ){
						System.debug(error.getMessage());
					}
				}
			}
		}
	}

	@future
	public static void nuevaMeta(Map<Id, Integer> mapUsuarios)
	{
		List<User> toUpdate = new List<User>();
		Set<Id> idUsuarios = mapUsuarios.keySet();
		for(Id userId : idUsuarios){
			toUpdate.add( 
				new User(
					Id = userId,
					Meta_canal_digital__c = mapUsuarios.get(userId)
				)
			);
		}

		if(!toUpdate.isEmpty()){
			Database.SaveResult[] results = MixedDMLOps.up(toUpdate);
			for(Database.SaveResult res : results){
				if(res.isSuccess()){
					System.debug('UserHandler->actualizando meta: ' + res.getId());
				} else {
					for(Database.Error error : res.getErrors() ){
						System.debug(error.getMessage());
					}
				}
			}
		}
	}
}