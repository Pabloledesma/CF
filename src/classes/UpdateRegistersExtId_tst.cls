@isTest(SeeAllData=true)
private class UpdateRegistersExtId_tst 
{
    
    static testMethod void myUnitTest() 
    {
        UpdateRegistersExtId_cls classUpdateRegistersExtId= new UpdateRegistersExtId_cls();

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
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Actualizacionderegistros__c objObjeto_origen= new Actualizacionderegistros__c();
        objObjeto_origen.Name ='Prueba';
        objObjeto_origen.Id_externo_destino__c='Id';
        objObjeto_origen.Campo_destino__c = 'Direccion_oficina_deudor__c    ';
        objObjeto_origen.Campo_llave__c = 'Cliente_deudor__c';
        objObjeto_origen.Campo_origen__c = 'Direccion_oficina_deudor__c';
        objObjeto_origen.Id_externo__c = objAcc.Id;
        objObjeto_origen.Objeto_origen__c = 'Radicacion_de_credito__c';
        objObjeto_origen.Objeto_destino__c='Account';
        upsert objObjeto_origen;
        
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
        objSolicitud_de_credito.Estado_de_la_solicitud__c = 'Radicado';
        objSolicitud_de_credito.Oportunidad__c = opp.Id;
        objSolicitud_de_credito.Meta__c = meta.Id;
        insert objSolicitud_de_credito;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Direccion_oficina_deudor__c ='Prueba';
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
         objRadicacion_de_credito.Solicitud_de_credito__c=objSolicitud_de_credito.Id;
        insert objRadicacion_de_credito;
        
        sObject objRadicaciondecredito=objRadicacion_de_credito;
        classUpdateRegistersExtId.setRegister(objRadicaciondecredito,objObjeto_origen.Objeto_origen__c);
        classUpdateRegistersExtId.getSdfcId(objAcc.Id,objObjeto_origen);                                                                
    }

    static testMethod void myUnitTesttwo() 
    {
        UpdateRegistersExtId_cls classUpdateRegistersExtId= new UpdateRegistersExtId_cls();

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
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Actualizacionderegistros__c objObjeto_origen= new Actualizacionderegistros__c();
        objObjeto_origen.Name ='test';
        objObjeto_origen.Id_externo_destino__c='Id';
        objObjeto_origen.Campo_destino__c = 'Direccion_oficina__c';
        objObjeto_origen.Campo_llave__c = 'Cliente_deudor__c';
        objObjeto_origen.Campo_origen__c = 'Direccion_oficina_deudor__c';
        objObjeto_origen.Id_externo__c = objAcc.Id;
        objObjeto_origen.Objeto_origen__c = 'Radicacion_de_credito__c';
        objObjeto_origen.Objeto_destino__c='Account';
        upsert objObjeto_origen;
        
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
        objSolicitud_de_credito.Estado_de_la_solicitud__c = 'Radicado';
        objSolicitud_de_credito.Oportunidad__c = opp.Id;
        objSolicitud_de_credito.Meta__c = meta.Id;
        insert objSolicitud_de_credito;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Direccion_oficina_deudor__c ='Prueba';
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        objRadicacion_de_credito.Solicitud_de_credito__c=objSolicitud_de_credito.Id;
        
        insert objRadicacion_de_credito;
        
        sObject objRadicaciondecredito=objRadicacion_de_credito;
        classUpdateRegistersExtId.setRegister(objRadicaciondecredito,objObjeto_origen.Objeto_origen__c);                                                              
    }
    
}