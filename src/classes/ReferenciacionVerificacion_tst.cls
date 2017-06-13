@isTest (SeeAllData=true)
private class ReferenciacionVerificacion_tst {

    
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
        objAcc.Numero_de_telefono_celular__c='8745454568';
        objAcc.Validar_numero_de_celular__c='8745454568';
        objAcc.Numero_de_documento__c='87687777';
        objAcc.Validar_numero_de_documento__c='87687777';
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
        objAcc2.Numero_de_telefono_celular__c='1454544234';
        objAcc2.Validar_numero_de_celular__c='1454544234';
        objAcc2.Numero_de_documento__c='145745';
        objAcc2.Validar_numero_de_documento__c='145745';
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
        objAcc3.Numero_de_telefono_celular__c='1296859835';
        objAcc3.Validar_numero_de_celular__c='1296859835';
        objAcc3.Numero_de_documento__c='12358998';
        objAcc3.Validar_numero_de_documento__c='12358998';
        objAcc3.LastName='pruebas3';
        objAcc3.Cliente_deudor__c = objAccDedudor3.Id;
        insert objAcc3;

         Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
       objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
       objRadicacion_de_credito.Telefono_oficina__c='46554';
       objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
       objRadicacion_de_credito.Codeudor_1__c = objAcc.Id;
       objRadicacion_de_credito.Codeudor_2__c=objAcc2.Id;
       objRadicacion_de_credito.Codeudor_3__c=objAcc3.Id;
       insert objRadicacion_de_credito;

       Referenciacion_y_verificacion__c referenciacionActual = new Referenciacion_y_verificacion__c();
       referenciacionActual.Radicacion_de_credito__c=objRadicacion_de_credito.Id;
     
       insert referenciacionActual;

        ReferenciacionVerificacion_cls classReferenciacionVerificacion= new ReferenciacionVerificacion_cls();
        classReferenciacionVerificacion.actualizarCodeudores(referenciacionActual);

       //ReferenciacionVerificacion_cls classReferenciacionVerificacion= new ReferenciacionVerificacion_cls();
       //classReferenciacionVerificacion.actualizarCodeudores(referenciacionActual);
    }
    


}