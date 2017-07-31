trigger InformacionComite_tgr on Informacion_comite__c (before insert, before update,after insert,after update) 
{
	InformacionComite_cls logica = new InformacionComite_cls();
	
	UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
	 
	Sobject objTrigger=trigger.new[0];
	
	if(Trigger.isBefore)
	{
		if(!Banderas_cls.ValidarEjecucion('BeforeInformacionComite'))
		{	
			if(trigger.new.size()==1 && !trigger.new[0].Migrado__c)
			{
				logica.actualizarCodeudores(Trigger.new[0]);               
                                
                UpdateFromParent classUpdateFromParent= new UpdateFromParent();
            	            
	            classUpdateFromParent.setRegister(objTrigger,'Informacion_comite__c');
	            
                System.debug('DebugLine 16: '+trigger.new[0]);
               
			}
		}
	}
	else if(Trigger.isAfter&&trigger.new.size()==1 && !trigger.new[0].Migrado__c)
    {
    	classUpdateRegistersLookUp.setRegister(objTrigger,'Informacion_comite__c'); 
    }
}