trigger PazYSalvos_tgr on Paz_y_salvo__c (before insert, before update,after insert,after update) 
{
	PazYSalvos_cls logicaPazySalvo = new PazYSalvos_cls();
	
	UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
	
	Sobject objTrigger=trigger.new[0];
	
	if(Trigger.isBefore)
	{
		if(!Banderas_cls.ValidarEjecucion('BeforePazYSalvo'))
		{	
			if(trigger.new.size()==1)
			{
				logicaPazySalvo.actualizarCodeudores(Trigger.new[0]);
								
                UpdateFromParent classUpdateFromParent= new UpdateFromParent();
            
                classUpdateFromParent.setRegister(objTrigger,'Paz_y_salvo__c');
                                
			}
		}
	}
	else if(Trigger.isAfter)
    {
    	classUpdateRegistersLookUp.setRegister(objTrigger,'Paz_y_salvo__c');  
    }
}