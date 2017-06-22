trigger Codeudor on Codeudor__c (before insert) {
	/**
	* Verifica que la cédula del codeudor no exista en las cuentas de tipo codeudor antes de crear el codeudor
	**/
	RecordType rt = [select Id from RecordType where Name = 'Codeudores' and SobjectType='Account'];
	List<Account> result = [
		select 
			Numero_de_documento__c 
		from Account 
		where RecordTypeId = :rt.Id 
		and Numero_de_documento__c = :String.valueOf(Trigger.new[0].Numero_de_documento__c)]; 
	//System.debug(result);
	if(result.size() > 0){
		System.debug('Existe una Cuenta de tipo codeudor con el número de cédula: ' + Trigger.new[0].Numero_de_documento__c);
		Trigger.new[0].addError('Existe una Cuenta de tipo codeudor con el número de cédula: ' + Trigger.new[0].Numero_de_documento__c);
	}

	//Un lead puede tener máximo 3 codeudores
	List<Codeudor__c> lstCodeudores = [select Id from Codeudor__c where Candidato__c = :Trigger.new[0].Candidato__c];
	if(lstCodeudores.size() == 3) Trigger.new[0].addError('El candidato ya tiene el número máximo de codeudores asociados.');
}