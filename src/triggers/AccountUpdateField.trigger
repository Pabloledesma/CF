trigger AccountUpdateField on Account (before insert, before update, after insert)
{
    AccountUpdateField_cls.setAccountUpdate(trigger.new); 

    /**
    * Actualización de los codeudores en la Radicación de crédito
    **/
	if( Trigger.isAfter && Trigger.isInsert ){
    	RecordType rt = [select Id, Name from RecordType where Name = 'Codeudores' and SobjectType='Account'];

		System.debug('AccountUpdateField: Es de tipo codeudor y tiene un cliente deudor asociado');

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
				System.debug('AccountUpdateField -> Radicación antes: ' + listRc);
				for(Account acc : Trigger.new){
					// Si es de tipo codeudor, tiene un cliente deudor asociado y existe una radicación de crédito asociada
					if(acc.RecordTypeId == rt.Id && acc.Cliente_deudor__c != null){
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
				System.debug('AccountUpdateField -> Radicación después: ' + listRc[0]);
				update sc;
				update listRc[0];
			}
		}



	} //Trigger.isAfter && Trigger.isInsert
}