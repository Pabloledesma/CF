trigger AsesorCanalDigitalTrigger on Asesor_Canal_Digital__c (before update) {
	List<User> toUpdate = new List<User>();
	for(Asesor_Canal_Digital__c asesor : Trigger.new){
		Asesor_Canal_Digital__c old = Trigger.oldMap.get(asesor.Id);

		if(old.Activo__c != asesor.Activo__c ){
			List<User> lstUser = [select Id, Habilitado_Canal_Digital__c, Email from User where Email = :old.Email__c];

			if(!lstUser.isEmpty()){
				if(old.Activo__c != asesor.Activo__c ){
					lstUser[0].Habilitado_Canal_Digital__c = asesor.Activo__c;
				}

				toUpdate.add(lstUser[0]);
			}
		}
	}

	if(!toUpdate.isEmpty()) update toUpdate;
}