trigger AsesorCanalDigitalTrigger on Asesor_Canal_Digital__c (before update) {
	List<User> toUpdate = new List<User>();
	Map<Id, Boolean> mapHabilitarUsuarios = new Map<Id, Boolean>();
	Map<Id, Integer> mapNuevaMeta = new Map<Id, Integer>();
	for(Asesor_Canal_Digital__c asesor : Trigger.new){
		Asesor_Canal_Digital__c old = Trigger.oldMap.get(asesor.Id);

		List<User> lstUser = [select Id, Habilitado_Canal_Digital__c, Email, Meta_Canal_Digital__c from User where Email = :old.Email__c];
		if(!lstUser.isEmpty()){
		
			if(old.Activo__c != asesor.Activo__c ){
				for(User u : lstUser){
					mapHabilitarUsuarios.put(u.Id, asesor.Activo__c);
				}
			}

			if(old.Meta__c != asesor.Meta__c){
				for(User u : lstUser){
					mapNuevaMeta.put(u.Id, Integer.valueOf(asesor.Meta__c));
				}
			}
		}
	}

	if(!mapHabilitarUsuarios.isEmpty()) 
		UserHandler.habilitarUsuario( mapHabilitarUsuarios );

	if(!mapNuevaMeta.isEmpty())
		UserHandler.nuevaMeta(mapNuevaMeta);
}