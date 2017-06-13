@isTest  (SeeAllData=true)
private class PazYSalvos_tst {

    static testMethod void myUnitTest() 
    {
        RecordType objRecordDeudor=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Cliente deudor' limit 1];
        Account objAccDedudor= new Account(RecordTypeId=objRecordDeudor.Id);
        objAccDedudor.Numero_de_telefono_celular__c='11111';
        objAccDedudor.Validar_numero_de_celular__c='11111';
        objAccDedudor.Numero_de_documento__c='11223344';
        objAccDedudor.Validar_numero_de_documento__c='11223344';
        objAccDedudor.LastName='Apellido';
        insert objAccDedudor;

        PazYSalvos_cls classPazYSalvos= new PazYSalvos_cls();
        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Paz_y_salvo__c objActual = new Paz_y_salvo__c();
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Opportunity opp = new Opportunity();
        opp.Resultado_del_Prevalidador__c = 'VIABLE';
        opp.Name = 'prueba';
        opp.StageName = 'Abierta';
        opp.CloseDate = Date.newInstance(2050,1,1);
        insert opp;
        
        Meta__c meta = new Meta__c();
        insert meta;
        
        Solicitud_de_credito__c objSolicitud_de_credito= new Solicitud_de_credito__c();
        objSolicitud_de_credito.Codeudor_1__c=objAcc.Id;
        objSolicitud_de_credito.Estado_de_la_solicitud__c = 'si';
        objSolicitud_de_credito.Oportunidad__c = opp.Id;
        objSolicitud_de_credito.Meta__c = meta.Id;
        insert objSolicitud_de_credito;
        objActual.Solicitud_de_credito__c=objSolicitud_de_credito.Id;

        insert objActual;
        classPazYSalvos.actualizarCodeudores(objActual);
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

        PazYSalvos_cls classPazYSalvos= new PazYSalvos_cls();
        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Paz_y_salvo__c objActual = new Paz_y_salvo__c();
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Opportunity opp = new Opportunity();
        opp.Resultado_del_Prevalidador__c = 'VIABLE';
        opp.Name = 'prueba';
        opp.StageName = 'Abierta';
        opp.CloseDate = Date.newInstance(2050,1,1);
        insert opp;
        
        Meta__c meta = new Meta__c();
        insert meta;
        
        Solicitud_de_credito__c objSolicitud_de_credito= new Solicitud_de_credito__c();
        objSolicitud_de_credito.Codeudor_2__c=objAcc.Id;
        objSolicitud_de_credito.Estado_de_la_solicitud__c = 'si';
        objSolicitud_de_credito.Oportunidad__c = opp.Id;
        objSolicitud_de_credito.Meta__c = meta.Id;
        insert objSolicitud_de_credito;
        objActual.Solicitud_de_credito__c=objSolicitud_de_credito.Id;
        insert objActual;
        classPazYSalvos.actualizarCodeudores(objActual);
    }

     static testMethod void myUnitTest2() 
    {
        RecordType objRecordDeudor=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Cliente deudor' limit 1];
        Account objAccDedudor= new Account(RecordTypeId=objRecordDeudor.Id);
        objAccDedudor.Numero_de_telefono_celular__c='11111';
        objAccDedudor.Validar_numero_de_celular__c='11111';
        objAccDedudor.Numero_de_documento__c='11223344';
        objAccDedudor.Validar_numero_de_documento__c='11223344';
        objAccDedudor.LastName='Apellido';
        insert objAccDedudor;

        PazYSalvos_cls classPazYSalvos= new PazYSalvos_cls();
        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Paz_y_salvo__c objActual = new Paz_y_salvo__c();
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;
        
        Opportunity opp = new Opportunity();
        opp.Resultado_del_Prevalidador__c = 'VIABLE';
        opp.Name = 'prueba';
        opp.StageName = 'Abierta';
        opp.CloseDate = Date.newInstance(2050,1,1);
        insert opp;
        
        Meta__c meta = new Meta__c();
        insert meta;
        
        Solicitud_de_credito__c objSolicitud_de_credito= new Solicitud_de_credito__c();
        objSolicitud_de_credito.Codeudor_3__c=objAcc.Id;
        objSolicitud_de_credito.Estado_de_la_solicitud__c = 'si';
        objSolicitud_de_credito.Oportunidad__c = opp.Id;
        objSolicitud_de_credito.Meta__c = meta.Id;
        insert objSolicitud_de_credito;
        
        objActual.Solicitud_de_credito__c=objSolicitud_de_credito.Id;
        insert objActual;
        classPazYSalvos.actualizarCodeudores(objActual);
    }
}