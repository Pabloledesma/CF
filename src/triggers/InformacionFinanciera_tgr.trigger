trigger InformacionFinanciera_tgr on Informacion_financiera__c (before insert, before update,after insert, after update) 
{
	
	InformacionFinanciera_cls logicaFinanciera = new InformacionFinanciera_cls();
	
	
        
    UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
    
    Sobject objTrigger=trigger.new[0];                
    
	if(Trigger.isBefore)
	{
		if(!Banderas_cls.ValidarEjecucion('BeforeInformacionFinanciera'))
		{	
			if(trigger.new.size()==1)
			{
				logicaFinanciera.actualizarCodeudores(Trigger.new[0]);				
		        
		        UpdateFromParent classUpdateFromParent= new UpdateFromParent();            
                
                classUpdateFromParent.setRegister(objTrigger,'Informacion_financiera__c');	        
		       
				
			}
		}
	}
	else if(Trigger.isAfter)
	{
		classUpdateRegistersLookUp.setRegister(objTrigger,'Informacion_financiera__c');
	}
}