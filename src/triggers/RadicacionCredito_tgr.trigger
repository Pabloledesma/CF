trigger RadicacionCredito_tgr on Radicacion_de_credito__c (before insert, before update, after insert,after update) 
{
    RadicacionCredito_cls logica = new RadicacionCredito_cls();
    
     UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
    
     Sobject objTrigger=trigger.new[0];
    //system.debug('\n\n----------Trigger Radicacion de credito----------\n\n'+objTrigger); 
    if(Trigger.isAfter)
    {
        if(!Banderas_cls.ValidarEjecucion('AfterRadicacion'))
        {   
            if(trigger.new.size()==1 && !trigger.new[0].Migrado__c)
            {
                logica.actualizarCodeudores(Trigger.new[0]);
                //system.debug('\n\n----------Trigger Radicacion de credito----------\n\n'+objTrigger);
                classUpdateRegistersLookUp.setRegister(objTrigger,'Radicacion_de_credito__c');
            }
        }
        
        if(trigger.new.size()==1&& !trigger.new[0].Migrado__c)
        {            
            classUpdateRegistersLookUp.setRegister(objTrigger,'Radicacion_de_credito__c');
            //system.debug('\n\n----------Trigger Radicacion de credito----------\n\n'+objTrigger);
        }
//        UpdateRegistersExtId_cls objUpdate = new UpdateRegistersExtId_cls();
//        objUpdate.setRegister(objTrigger,'Radicacion_de_credito__c');
    }

    if(Trigger.isAfter)
        System.debug('RadicacionCredito_trg -> se creó la radicación de crédito ' + Trigger.new[0].Name);

}