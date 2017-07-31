@isTest
private class InformacionComite_tst 
{
    @testSetup static void setup()
    {
        RecordType rt          = [SELECT Id FROM RecordType where Name ='Cliente deudor' AND SobjectType = 'Account'];
        Id clienteDedudorId    = TestDataFactory.createAccount(rt.Id, '12345678');
        Id codeudorId          = TestDataFactory.createAccount(rt.Id, clienteDedudorId, '98745621');
    }

    @isTest
    static void cliente_deudor_con_un_codeudor() 
    {
        Account codeudor1   = [select Id from account where Numero_de_documento__c = '98745621'];
        Id radicacionId     = TestDatafactory.createRadicacion(codeudor1.Id);
        Test.startTest();
             Radicacion_de_credito__c rc = [
                SELECT 
                    Id,
                    Codeudor_1__c
                FROM 
                    Radicacion_de_credito__c
            ];
            Id infoComiteId     = TestDataFactory.createInformacionComite(rc.Id);
            Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
            OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
            OBJActualizacion_masiva_de_registros.Name='fdgdf';
            OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
            OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
            OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
            
            insert OBJActualizacion_masiva_de_registros;
            
            
           

            List<Informacion_comite__c> lstInfoC = [
                SELECT 
                    Id, 
                    Codeudor_1__c,
                    Radicacion__c,
                    Solicitud_de_credito__c,
                    Id_Credito__c,
                    Id_Radicacion__c,
                    Cargo_deudor__c
                FROM Informacion_comite__c
                WHERE Id = :infoComiteId
            ];

            System.assert(rc != null, 'Errores en la radicación');
            System.assert(lstInfoC.size() > 0, 'Errores en la información comité');
            System.assertEquals(
                rc.Codeudor_1__c, 
                lstInfoC[0].Codeudor_1__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

            // Actualización de la radicación
            // Este desarrollo está pendiente
            //rc.Codeudor_1__c = null;
            //update rc;

            //System.assertEquals(
            //    rc.Codeudor_1__c, 
            //    lstInfoC[0].Codeudor_1__c, 
            //    'El codeudor 1 no se actualizó correctamente en la información comité'
            //);
            
        Test.stopTest(); 
    }

   @isTest
   static void con_dos_codeudores()
   {
        RecordType rt          = [SELECT Id FROM RecordType where Name ='Cliente deudor' AND SobjectType = 'Account'];
        Account clienteDedudor = [Select Id from Account where Numero_de_documento__c = '12345678'];
        Account codeudor1      = [select Id from Account where Numero_de_documento__c = '98745621'];
        Id codeudor2Id         = TestDatafactory.createAccount(rt.Id, clienteDedudor.Id, '59146798');
        Id radicacionId        = TestDatafactory.createRadicacion(codeudor1.Id, codeudor2Id);
        Test.startTest();
             Radicacion_de_credito__c rc = [
                SELECT 
                    Id,
                    Codeudor_1__c,
                    Codeudor_2__c
                FROM 
                    Radicacion_de_credito__c
            ];
            Id infoComiteId     = TestDataFactory.createInformacionComite(rc.Id);
            Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
            OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
            OBJActualizacion_masiva_de_registros.Name='fdgdf';
            OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
            OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
            OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
            
            insert OBJActualizacion_masiva_de_registros;

            List<Informacion_comite__c> lstInfoC = [
                SELECT 
                    Id, 
                    Codeudor_1__c,
                    Codeudor_2__c,
                    Codeudor_3__c,
                    Radicacion__c,
                    Solicitud_de_credito__c,
                    Id_Credito__c,
                    Id_Radicacion__c,
                    Cargo_deudor__c
                FROM Informacion_comite__c
                WHERE Id = :infoComiteId
            ];

            System.assert(rc != null, 'Errores en la radicación');
            System.assert(lstInfoC.size() > 0, 'Errores en la información comité');
            System.assertEquals(
                rc.Codeudor_1__c, 
                lstInfoC[0].Codeudor_1__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

             System.assertEquals(
                rc.Codeudor_2__c, 
                lstInfoC[0].Codeudor_2__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

            // Actualización de la radicación
            // Este desarrollo está pendiente
            //rc.Codeudor_1__c = null;
            //update rc;

            //System.assertEquals(
            //    rc.Codeudor_1__c, 
            //    lstInfoC[0].Codeudor_1__c, 
            //    'El codeudor 1 no se actualizó correctamente en la información comité'
            //);
            
        Test.stopTest(); 
   }

    @isTest
   static void con_tres_codeudores()
   {
        RecordType rt          = [SELECT Id FROM RecordType where Name ='Cliente deudor' AND SobjectType = 'Account'];
        Account clienteDedudor = [Select Id from Account where Numero_de_documento__c = '12345678'];
        Account codeudor1      = [select Id from Account where Numero_de_documento__c = '98745621'];
        Id codeudor2Id         = TestDatafactory.createAccount(rt.Id, clienteDedudor.Id, '78936973');
        Id codeudor3Id         = TestDatafactory.createAccount(rt.Id, clienteDedudor.Id, '78936974');
        Id radicacionId        = TestDatafactory.createRadicacion(codeudor1.Id, codeudor2Id, codeudor3Id);
        Test.startTest();
             Radicacion_de_credito__c rc = [
                SELECT 
                    Id,
                    Codeudor_1__c,
                    Codeudor_2__c,
                    Codeudor_3__c
                FROM 
                    Radicacion_de_credito__c
            ];
            Id infoComiteId     = TestDataFactory.createInformacionComite(rc.Id);
            Actualizacion_masiva_de_registros__c OBJActualizacion_masiva_de_registros= new Actualizacion_masiva_de_registros__c();
            OBJActualizacion_masiva_de_registros.Objeto_destino__c='Informacion_comite__c';
            OBJActualizacion_masiva_de_registros.Name='fdgdf';
            OBJActualizacion_masiva_de_registros.Objeto_origen__c='Account';
            OBJActualizacion_masiva_de_registros.Campo_Id__c='Radicacion__c';
            OBJActualizacion_masiva_de_registros.Campo_origen__c='Id';
            
            insert OBJActualizacion_masiva_de_registros;

            List<Informacion_comite__c> lstInfoC = [
                SELECT 
                    Id, 
                    Codeudor_1__c,
                    Codeudor_2__c,
                    Codeudor_3__c,
                    Radicacion__c,
                    Solicitud_de_credito__c,
                    Id_Credito__c,
                    Id_Radicacion__c,
                    Cargo_deudor__c
                FROM Informacion_comite__c
                WHERE Id = :infoComiteId
            ];

            System.assert(rc != null, 'Errores en la radicación');
            System.assert(lstInfoC.size() > 0, 'Errores en la información comité');
            System.assertEquals(
                rc.Codeudor_1__c, 
                lstInfoC[0].Codeudor_1__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

            System.assertEquals(
                rc.Codeudor_2__c, 
                lstInfoC[0].Codeudor_2__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

             System.assertEquals(
                rc.Codeudor_3__c, 
                lstInfoC[0].Codeudor_3__c, 
                'El codeudor 1 no se actualizó correctamente en la información comité'
            );

            // Actualización de la radicación
            // Este desarrollo está pendiente
            //rc.Codeudor_1__c = null;
            //update rc;

            //System.assertEquals(
            //    rc.Codeudor_1__c, 
            //    lstInfoC[0].Codeudor_1__c, 
            //    'El codeudor 1 no se actualizó correctamente en la información comité'
            //);
            
        Test.stopTest(); 
   }

    
}