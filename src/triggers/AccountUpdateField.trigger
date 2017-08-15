}trigger AccountUpdateField on Account (before insert, before update, after insert)
{
    /**
    * Ya se está actualizando el campo aporta ingresos en la cuenta 
    **/
    AccountUpdateField_cls.setAccountUpdate(trigger.new); 

    /**
    * Actualización de los codeudores en la Radicación de crédito
    **/
    if( Trigger.isAfter && Trigger.isInsert ){
        RecordType rt = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];

        //System.debug('AccountUpdateField: Es de tipo codeudor y tiene un cliente deudor asociado');

        List<Solicitud_de_credito__c> sc =
        [
                SELECT
                        Id,
                        Codeudor_1__c,
                        Codeudor_2__c,
                        Codeudor_3__c,
                        Cliente_deudor__c
                FROM Solicitud_de_credito__c
                WHERE Cliente_deudor__c = :Trigger.new[0].Cliente_deudor__c
        ];

        if(sc.size() > 0){
            List<Radicacion_de_credito__c> listRc =
            [
                    select
                            Id,
                            Codeudor_1__c,
                            Codeudor_2__c,
                            Codeudor_3__c,
                            Solicitud_de_credito__c
                    from Radicacion_de_credito__c
                    where Solicitud_de_credito__c = :sc[0].Id
            ];
            if(listRc.size() > 0){
                //System.debug('AccountUpdateField -> Solicitud antes: ' + sc[0]);
                Set<String> cedulasCodeudores = new Set<String>();
                for(Account acc : Trigger.new){
                    if(acc.RecordTypeId == rt.Id && acc.Cliente_deudor__c != null){
                        cedulasCodeudores.add(acc.Numero_de_documento__c);
                        List<String> lstCampos = new List<String>{'Codeudor_1__c', 'Codeudor_2__c', 'Codeudor_3__c'};

                        for(String campo : lstCampos){
                            if(campo == 'Codeudor_1__c' && listRc[0].Codeudor_1__c == null){
                                listRc[0].Codeudor_1__c = acc.Id;
                                sc[0].Codeudor_1__c = acc.Id;
                                break;
                            } else if (campo == 'Codeudor_2__c' && listRc[0].Codeudor_2__c == null) {
                                listRc[0].Codeudor_2__c = acc.Id;
                                sc[0].Codeudor_2__c = acc.Id;
                                break;
                            } else if (campo == 'Codeudor_3__c' && listRc[0].Codeudor_3__c == null) {
                                listRc[0].Codeudor_3__c = acc.Id;
                                sc[0].Codeudor_3__c = acc.Id;
                                break;
                            }
                        }
                    }
                }
                //System.debug('AccountUpdateField -> Solicitud después: ' + sc[0]);
                Database.SaveResult resSolicitud = Database.update(sc[0]);
                Database.SaveResult resRadicacion = Database.update(listRc[0]);

                /**
                * Eliminación de codeudores después del evento de conversión
                 **/
                if(resSolicitud.isSuccess() && resRadicacion.isSuccess()){
                    //System.debug('Se eliminan los codeudores!');

                    List<Codeudor__c> codeudores = new List<Codeudor__c>();
                    codeudores = [SELECT Id FROM Codeudor__c WHERE Numero_de_documento__c IN :cedulasCodeudores];
                    System.debug(codeudores);

                    Database.DeleteResult[] deleteResults = Database.delete(codeudores);
                    for(Database.DeleteResult res : deleteResults){
                        if(!res.isSuccess()){
                            for(Database.Error er : res.getErrors()){
                                System.debug('Errores en la eliminación de los codeudores.');
                                System.debug(er.getStatusCode() + ': ' + er.getMessage());
                                System.debug('Campos afectados: ' + er.getFields());
                            }
                        }
                    }
                }
            }
        }
    } //Trigger.isAfter && Trigger.isInsert
}