/**
* Verifica que la cédula del codeudor no exista en las cuentas de tipo codeudor antes de crear el codeudor
**/
trigger CodeudorDuplicado on Codeudor__c (before insert) {
	RecordType rt = [select Id from RecordType where Name = 'Codeudores' and SobjectType='Account'];
	List<Account> result = [
		select 
			Numero_de_documento__c 
		from Account 
		where RecordTypeId = :rt.Id 
		and Numero_de_documento__c = :String.valueOf(Trigger.new[0].Numero_de_documento__c)]; 
	System.debug(result);
	if(result.size() > 0){
		System.debug('Existe una Cuenta de tipo codeudor con el número de cédula: ' + Trigger.new[0].Numero_de_documento__c);
		Trigger.new[0].addError('Existe una Cuenta de tipo codeudor con el número de cédula: ' + Trigger.new[0].Numero_de_documento__c);
	}
}