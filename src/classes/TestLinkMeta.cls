@isTest
private class TestLinkMeta {

    static Id createAccount(){

        RecordType rt = [
                SELECT
                        Id
                FROM
                        RecordType
                WHERE Name = 'Cliente deudor'
                AND sObjectType = 'Account'
        ];

        Id acctId = TestDataFactory.createAccount(rt.Id, '12345678');
        return acctId;
    }

    @isTest static void linkMetaToOneOpportunity(){
       Id metaId = TestDataFactory.createMeta();
       Id accountId = createAccount();
       
   		Opportunity objOpportunity= new Opportunity(
            Name='Test Opportunity',
            StageName='ddd',
            CloseDate=System.today().addMonths(1),
            AccountId=accountId,
            Resultado_del_Prevalidador__c = 'VIABLE',
            RecordTypeId='012o0000000Gl0LAAS'
        );
        
        Test.startTest();
        insert objOpportunity;
        
        //Verify
        Opportunity op = [SELECT Id, Name, Meta__c FROM Opportunity];
        System.debug(op);
        System.assert(op.Meta__c == metaId);
        Test.stopTest();
    }
    
    @isTest static void LinkMetaToManyOpportunities(){
        
       Id metaId = TestDataFactory.createMeta();
       Id accountId = createAccount();

        List<Opportunity> lstOpportunities = new List<Opportunity>();
        
        for(Integer i = 0; i<300; i++){
            lstOpportunities.add(
            	new Opportunity(
                    Name='Test Opportunity' + i,
                    StageName='ddd',
                    CloseDate=System.today().addMonths(1),
                    AccountId=accountId,
                    Resultado_del_Prevalidador__c = 'VIABLE',
                    RecordTypeId='012o0000000Gl0LAAS'
                )
            );
        }
        
        Test.startTest();
        	insert lstOpportunities;
        Test.stopTest();
        
        lstOpportunities = [SELECT Id, Meta__c FROM Opportunity WHERE Meta__c = :metaId];
        System.debug('Oportunidades de prueba: ' + lstOpportunities.size());
        System.assert(lstOpportunities.size() == 300);
    }
    
    @isTest static void LinkMetaToOneSolicitudDeCredito(){
		Id metaId = TestDataFactory.createMeta();
        Id accountId = createAccount();
        
   		Opportunity op = new Opportunity(
            Name='Test Opportunity',
            StageName='ddd',
            CloseDate=System.today().addMonths(1),
            AccountId=accountId,
            Resultado_del_Prevalidador__c = 'VIABLE',
            RecordTypeId='012o0000000Gl0LAAS'
        );

		insert op;
        
        Solicitud_de_credito__c sc = new Solicitud_de_credito__c(Oportunidad__c = op.Id);
        Test.startTest();
        insert sc;
        Test.stopTest();
        
        Solicitud_de_credito__c solCre = [select Id, Meta__c from Solicitud_de_credito__c];
		System.assert(solCre.Meta__c == metaId);        
    }
    
    @isTest static void LinkMetaToManySolicitudDeCredito(){
        Id metaId = TestDataFactory.createMeta();
        Id accountId = createAccount();
        
   		Opportunity op = new Opportunity(
            Name='Test Opportunity',
            StageName='ddd',
            CloseDate=System.today().addMonths(1),
            AccountId=accountId,
            Resultado_del_Prevalidador__c = 'VIABLE',
            RecordTypeId='012o0000000Gl0LAAS'
        );

		insert op;
        
        List<Solicitud_de_credito__c> lstSolicitudes = new List<Solicitud_de_credito__c>();
            
        for(Integer i = 0; i<300; i++){
            lstSolicitudes.add(new Solicitud_de_credito__c(Oportunidad__c = op.Id));
        }
        
        Test.startTest();
        insert lstSolicitudes;
        
        lstSolicitudes = [SELECT 
                              Id, 
                              Oportunidad__c 
                          FROM Solicitud_de_credito__c 
                          WHERE Oportunidad__c = :op.Id AND Meta__c = :metaId];
        System.assert(lstSolicitudes.size() == 300);
        Test.stopTest();
        
    }
}