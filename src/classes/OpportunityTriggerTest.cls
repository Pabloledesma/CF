@isTest
private class OpportunityTriggerTest
{
	@isTest
	static void se_crea_una_oportunidad_con_un_codeudor_asociado()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudorId = TestDataFactory.createAccount('73194685');

		Test.startTest();
 		Id oppId = TestDataFactory.createOpportunity(deudorId, codeudorId);
 		Account codeudorAcc = [select Codeudor__c from Account where id = :codeudorId]; 
 		
 		System.assert(codeudorAcc.Codeudor__c, 'El campo codeudor no fué actualizado');
 		Test.stopTest();
	}

	@isTest
	static void se_crea_una_oportunidad_con_dos_codeudores_asociados()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudor1Id = TestDataFactory.createAccount('73194685');
		Id codeudor2Id = TestDataFactory.createAccount('73194684');

		Test.startTest();
 		Id oppId = TestDataFactory.createOpportunity(deudorId, codeudor1Id, codeudor2Id);
 		Account codeudor1Acc = [select Codeudor__c from Account where id = :codeudor1Id]; 
 		Account codeudor2Acc = [select Codeudor__c from Account where id = :codeudor2Id]; 
 		
 		System.assert(codeudor1Acc.Codeudor__c, 'El primer codeudor no fué marcadomarcado');
 		System.assert(codeudor2Acc.Codeudor__c, 'El segundo codeudor no fué marcadomarcado');
 		Test.stopTest();
	}

	@isTest
	static void se_crea_una_oportunidad_con_tres_codeudores_asociados()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudor1Id = TestDataFactory.createAccount('73194685');
		Id codeudor2Id = TestDataFactory.createAccount('73194684');
		Id codeudor3Id = TestDataFactory.createAccount('73194683');

		Test.startTest();
 		Id oppId = TestDataFactory.createOpportunity(deudorId, codeudor1Id, codeudor2Id, codeudor3Id);
 		Account codeudor1Acc = [select Codeudor__c from Account where id = :codeudor1Id]; 
 		Account codeudor2Acc = [select Codeudor__c from Account where id = :codeudor2Id]; 
 		Account codeudor3Acc = [select Codeudor__c from Account where id = :codeudor3Id]; 
 		
 		System.assert(codeudor1Acc.Codeudor__c, 'El primer codeudor no fué marcado');
 		System.assert(codeudor2Acc.Codeudor__c, 'El segundo codeudor no fué marcado');
 		System.assert(codeudor3Acc.Codeudor__c, 'El tercer codeudor no fué marcado');
 		Test.stopTest();
	}

	@isTest
	static void se_actualiza_una_oportunidad_con_un_codeudor_asociado()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudor1Id = TestDataFactory.createAccount('73194685');

		Id oppId = TestDataFactory.createOpportunity(deudorId);
		Opportunity opp = new Opportunity(Id = oppId, Codeudor_1__c = codeudor1Id);
		Test.startTest();
		update opp;

		Account codeudor1Acc = [select Codeudor__c from Account where Id = :codeudor1Id];
		System.assert(codeudor1Acc.Codeudor__c, 'El primer codeudor no fué marcado');
		Test.stopTest();
	}

	@isTest
	static void se_actualiza_el_codeudor_2_de_la_oportunidad()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudor2Id = TestDataFactory.createAccount('73194685');

		Id oppId = TestDataFactory.createOpportunity(deudorId);
		Opportunity opp = new Opportunity(Id = oppId, Codeudor_2__c = codeudor2Id);
		Test.startTest();
		update opp;

		Account codeudor2Acc = [select Codeudor__c from Account where Id = :codeudor2Id];
		System.assert(codeudor2Acc.Codeudor__c, 'El segundo codeudor no fué marcado');
		Test.stopTest();
	}

	@isTest
	static void se_actualiza_el_codeudor_3_de_la_oportunidad()
	{
		Id deudorId = TestDataFactory.createAccount('12345678');
		Id codeudor3Id = TestDataFactory.createAccount('73194685');

		Id oppId = TestDataFactory.createOpportunity(deudorId);
		Opportunity opp = new Opportunity(Id = oppId, Codeudor_3__c = codeudor3Id);
		Test.startTest();
		update opp;

		Account codeudor3Acc = [select Codeudor__c from Account where Id = :codeudor3Id];
		System.assert(codeudor3Acc.Codeudor__c, 'El tercer codeudor no fué marcado');
		Test.stopTest();
	}
}