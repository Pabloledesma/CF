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
}