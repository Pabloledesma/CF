@isTest
private class RadicacionCredito_tst {

    static testMethod void myUnitTest() 
    {
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        insert objRadicacion_de_credito;
        ApexPages.Standardcontroller incontroller=new ApexPages.StandardController(objRadicacion_de_credito);
        RadicacionCredito_ctr classRadicacionCredito = new RadicacionCredito_ctr(incontroller);  
        classRadicacionCredito.guardar();
        classRadicacionCredito.cancelar();
    }

    static testMethod void myUnitTest1() 
    {
        RecordType objRecordDeudor=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Cliente deudor' limit 1];
        Account objAccDedudor= new Account(RecordTypeId=objRecordDeudor.Id);
        objAccDedudor.Numero_de_telefono_celular__c='11111';
        objAccDedudor.Validar_numero_de_celular__c='11111';
        objAccDedudor.Numero_de_documento__c='11223344';
        objAccDedudor.Validar_numero_de_documento__c='11223344';
        objAccDedudor.LastName='Apellido';
        insert objAccDedudor;

        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='1523577877';
        objAcc.Validar_numero_de_celular__c='1523577877';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Account objAccDedudor2= new Account(RecordTypeId=objRecordDeudor.Id);
        objAccDedudor2.Numero_de_telefono_celular__c='11111';
        objAccDedudor2.Validar_numero_de_celular__c='11111';
        objAccDedudor2.Numero_de_documento__c='11223355';
        objAccDedudor2.Validar_numero_de_documento__c='11223355';
        objAccDedudor2.LastName='Apellido';
        insert objAccDedudor2;

        Account objAcc2= new Account(RecordTypeId=objRecord.Id);
        objAcc2.Numero_de_telefono_celular__c='8768744455';
        objAcc2.Validar_numero_de_celular__c='8768744455';
        objAcc2.Numero_de_documento__c='124434';
        objAcc2.Validar_numero_de_documento__c='124434';
        objAcc2.LastName='pruebas';
        objAcc2.Cliente_deudor__c = objAccDedudor2.Id;
        insert objAcc2;

        Account objAccDedudor3= new Account(RecordTypeId=objRecordDeudor.Id);
        objAccDedudor3.Numero_de_telefono_celular__c='11111';
        objAccDedudor3.Validar_numero_de_celular__c='11111';
        objAccDedudor3.Numero_de_documento__c='11223366';
        objAccDedudor3.Validar_numero_de_documento__c='11223366';
        objAccDedudor3.LastName='Apellido';
        insert objAccDedudor3;

        Account objAcc3= new Account(RecordTypeId=objRecord.Id);
        objAcc3.Numero_de_telefono_celular__c='1266377885';
        objAcc3.Validar_numero_de_celular__c='1266377885';
        objAcc3.Numero_de_documento__c='127735';
        objAcc3.Validar_numero_de_documento__c='127735';
        objAcc3.LastName='pruebas3';
        objAcc3.Cliente_deudor__c = objAccDedudor3.Id;
        insert objAcc3;

        Opportunity objOpportunity= new Opportunity(Name='dgffg',StageName='ddd');
        objOpportunity.CloseDate=Date.today();
        objOpportunity.Codeudor_1__c=objAcc.Id;
        objOpportunity.Codeudor_2__c=objAcc2.Id;
        objOpportunity.Codeudor_3__c=objAcc3.Id;
        objOpportunity.Resultado_del_Prevalidador__c = 'VIABLE';
       
        insert objOpportunity;

        Meta__c meta = new Meta__c();
        insert meta;

        RadicacionCredito_ctr SolicitudCredito= new RadicacionCredito_ctr();
        Solicitud_de_credito__c solicitudActual= new Solicitud_de_credito__c();
        solicitudActual.Oportunidad__c=objOpportunity.Id;
        solicitudActual.Estado_de_la_solicitud__c = 'si';
        solicitudActual.Meta__c = meta.Id;
        insert solicitudActual;

        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        objRadicacion_de_credito.Solicitud_de_credito__c = solicitudActual.Id;
        insert objRadicacion_de_credito;
        
        ApexPages.Standardcontroller incontroller=new ApexPages.StandardController(objRadicacion_de_credito);
        RadicacionCredito_ctr classRadicacionCredito = new RadicacionCredito_ctr(incontroller);  
        classRadicacionCredito.guardar();
        classRadicacionCredito.cancelar();
    }
    
}