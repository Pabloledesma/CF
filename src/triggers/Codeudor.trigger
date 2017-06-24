trigger Codeudor on Codeudor__c (before insert) {
	/**
	* Verifica que la cédula del codeudor no exista en la cuenta.
	**/
	//List<Account> result = [
	//	select Numero_de_documento__c, RecordTypeId
	//	from Account 
	//	where Numero_de_documento__c = :String.valueOf(Trigger.new[0].Numero_de_documento__c)]; 
	
	//if(result.size() > 0){
	//	System.debug('Existe una Cuenta de tipo codeudor con el número de cédula: ' + Trigger.new[0].Numero_de_documento__c);
	//	// Que tipo de registro tiene?
	//	RecordType rt = [select Name from RecordType where Id = :result[0].RecordTypeId];
	//}

	//Un lead puede tener máximo 3 codeudores
	List<Codeudor__c> lstCodeudores = [select Id from Codeudor__c where Candidato__c = :Trigger.new[0].Candidato__c];
	if(lstCodeudores.size() == 3) Trigger.new[0].addError('El candidato ya tiene el número máximo de codeudores asociados.');
}