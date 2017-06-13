trigger SolicitudCredito_tgr on Solicitud_de_credito__c (before insert, before update,after insert, after update) {
	
	SolicitudCredito_cls logicaSolicitud = new SolicitudCredito_cls();
	
    UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
	
	 Sobject objTrigger=trigger.new[0];
	 
	system.debug('\n\n----------Trigger Soliitud de credito----------\n\n'+objTrigger); 
	
	if(Trigger.isBefore)
	{
		system.debug('\n\n----------Trigger Soliitud de credito----------\n\n'+objTrigger);
		if(!Banderas_cls.ValidarEjecucion('BeforeSolicitudCredito'))
		{	
			if(trigger.new.size()==1)
			{	
				if(trigger.new[0].Migrado__c == False)
				{
					logicaSolicitud.actualizarCodeudores(Trigger.new[0]);
				}
				
				SolicitudCreditoVerifyProfile classSolicitudCreditoVerifyProfile= new SolicitudCreditoVerifyProfile();
                
                system.debug('\n\n----------Trigger Soliitud de credito----------\n\n'+objTrigger);
                
                if(trigger.isUpdate&&trigger.old[0].Estado_de_la_solicitud__c<>trigger.new[0].Estado_de_la_solicitud__c)
                {
                    classSolicitudCreditoVerifyProfile.verifyProfile(trigger.old[0],trigger.new[0]);
                }
                
                /*if(Trigger.new[0].Estado_de_la_solicitud__c=='Desembolsado')//JRMM por petición del cliente 14/01/2016.
                {
                	Account objAcc= new Account(Id=Trigger.new[0].Cliente_deudor__c, Estado_del_cliente__c='Cliente credifamilia');
                	update objAcc;
                }*/
			}
		}
	}
	else if(Trigger.isAfter && trigger.new.size()==1)
	{
		system.debug('\n\n----------Trigger Soliitud de credito isAfter----------\n\n'+objTrigger);
		classUpdateRegistersLookUp.setRegister(objTrigger,'Solicitud_de_credito__c');
	}
}