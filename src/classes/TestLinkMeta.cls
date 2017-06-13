@isTest
private class TestLinkMeta {
    
    static Id createMeta(){
        
        Meta__c meta = new Meta__c();
        Database.SaveResult results = Database.insert(meta);
        
        if(results.isSuccess()){
            //System.debug('Successfully insertion of Meta id: ' + results.getId());
            return results.getId();
        } else {
            for(Database.Error err : results.getErrors()) {
                System.debug('The following error has occurred.');                   
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Meta fields that affected this error: ' + err.getFields());
        	}
            
            return '012o0000000Gl0LAAS';

        }
    }
    
    static Id createAccount(){
        Account acct = new Account(Name='Test Account', RecordTypeId='012o0000000Gl0KAAS');
        Database.SaveResult rs = Database.insert(acct);
        
        if(rs.isSuccess()){
            //System.debug('Successfully insertion of Account id: ' + rs.getId());
            return rs.getId();
        } else {
            for(Database.Error err : rs.getErrors()) {
                System.debug('The following error has occurred.');                   
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
        	}

            return '012o0000000Gl0LAAS';
        }
    }

    @isTest static void linkMetaToOneOpportunity(){
      	
       Id metaId = createMeta();
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
        
       Id metaId = createMeta();
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
		Id metaId = createMeta();
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
        Id metaId = createMeta();
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