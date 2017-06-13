@isTest
private class InformacionComite_tst 
{

    
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
                
        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        objRadicacion_de_credito.Codeudor_1__c = objAcc.Id;
        insert objRadicacion_de_credito;
        Informacion_comite__c infoActual = new Informacion_comite__c();
        infoActual.Radicacion__c=objRadicacion_de_credito.Id;
        Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
        OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
        OBJActualizacion_masiva_de_registros.Name='fdgdf';
        OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
        OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
        OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
        
        insert OBJActualizacion_masiva_de_registros;
        insert infoActual;
        InformacionComite_cls  classInformacionComite= new InformacionComite_cls();
        classInformacionComite.actualizarCodeudores(infoActual);
        
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
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        objRadicacion_de_credito.Codeudor_2__c = objAcc.Id;
        insert objRadicacion_de_credito;
        Informacion_comite__c infoActual = new Informacion_comite__c();
        infoActual.Radicacion__c=objRadicacion_de_credito.Id;
        Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
        OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
        OBJActualizacion_masiva_de_registros.Name='fdgdf';
        OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
        OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
        OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
        
        insert OBJActualizacion_masiva_de_registros;
        insert infoActual;
        InformacionComite_cls  classInformacionComite= new InformacionComite_cls();
        classInformacionComite.actualizarCodeudores(infoActual);
        
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

        RecordType objRecord=[SELECT Id,Name,SobjectType FROM RecordType where Name ='Codeudores' limit 1];
        Account objAcc= new Account(RecordTypeId=objRecord.Id);
        objAcc.Numero_de_telefono_celular__c='8768';
        objAcc.Validar_numero_de_celular__c='8768';
        objAcc.Numero_de_documento__c='8768999';
        objAcc.Validar_numero_de_documento__c='8768999';
        objAcc.LastName='dgdfg';
        objAcc.Cliente_deudor__c = objAccDedudor.Id;
        insert objAcc;

        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        objRadicacion_de_credito.Codeudor_3__c = objAcc.Id;
        insert objRadicacion_de_credito;
        Informacion_comite__c infoActual = new Informacion_comite__c();
        infoActual.Radicacion__c=objRadicacion_de_credito.Id;
        Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
        OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
        OBJActualizacion_masiva_de_registros.Name='fdgdf';
        OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
        OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
        OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
        
        insert OBJActualizacion_masiva_de_registros;
        insert infoActual;
        InformacionComite_cls  classInformacionComite= new InformacionComite_cls();
        classInformacionComite.actualizarCodeudores(infoActual);
        
    }
    
}