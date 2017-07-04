@isTest
private class AccountUpdateFieldTest {
	
	@isTest static void actualizacion_de_cuenta_codeudor_con_cliente_deudor() {
		RecordType rtDeudor = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];
		Id deudorId = TestDataFactory.createAccount(rtDeudor.Id, '12345678');
		Id codeudorId = TestDataFactory.createAccount(rtDeudor.Id, deudorId, '87654321');
		Account acc = new Account(Id = codeudorId, FirstName = 'Updated Account!');
		Test.startTest();
			update acc;
			System.assertEquals([select FirstName from Account where FirstName = 'Updated Account!'].FirstName, 'Updated Account!');
		Test.stopTest();
	}

	@isTest static void actualizacion_de_cuenta_codeudor_sin_cliente_deudor() {
		RecordType rtDeudor = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];
		Id codeudorId = TestDataFactory.createAccount(rtDeudor.Id, '87654321');
		Account acc = new Account(Id = codeudorId, FirstName = 'Updated Account!');
		Test.startTest();
			update acc;
			System.assertEquals([select FirstName from Account where FirstName = 'Updated Account!'].FirstName, 'Updated Account!');
		Test.stopTest();
	}
}