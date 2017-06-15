@isTest
public class TestDataFactory {
	
	public static Id createLead() {
		Lead lead = new Lead();
		insert lead;
		return lead.Id;
	}
	
	public static Id createCodeudor(Id leadId, Integer numeroDeDocumento) {
		Codeudor__c cod = new Codeudor__c(
			Name = 'CodeudorTest',
			Apellidos__c = 'Test',
			Candidato__c = leadId,
			Numero_de_documento__c = numeroDeDocumento
		); 
		insert cod;
		return cod.Id;
	}

	public static Id createAccount(Id recordTypeId){
		Account acc = new Account(
			RecordTypeId = recordTypeId,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Numero_de_documento__c = String.valueOf(Crypto.getRandomInteger()) 
		);
		return acc.Id;
	}

	public static Id createAccount(Id recordTypeId, Id clienteDeudorId){
		Account acc = new Account(
			RecordTypeId = recordTypeId,
			Cliente_deudor__c = clienteDeudorId,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Numero_de_documento__c = String.valueOf(randomWithLimit(1000000000))
		);
		return acc.Id;
	}

	public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
	
}