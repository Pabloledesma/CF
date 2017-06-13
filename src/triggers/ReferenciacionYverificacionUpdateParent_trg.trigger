trigger ReferenciacionYverificacionUpdateParent_trg on Referenciacion_y_verificacion__c (before insert, before update,after insert,after update) 
{
	ReferenciacionVerificacion_cls logicaReferenciacion = new ReferenciacionVerificacion_cls();
	
	 UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
	 
	 Sobject objTrigger=trigger.new[0];
	 
	if(!Banderas_cls.ValidarEjecucion('BeforeReferenciacion')&&trigger.isBefore)
	{
	    if(trigger.new.size()==1)
	    {
	    	logicaReferenciacion.actualizarCodeudores(trigger.new[0]);
	       	        
	        UpdateFromParent classUpdateFromParent= new UpdateFromParent();
	        
	        	        
	        classUpdateFromParent.setRegister(objTrigger,'Referenciacion_y_verificacion__c');
	       
	        
	    }
	}
	else if(trigger.isAfter)
	{
            classUpdateRegistersLookUp.setRegister(objTrigger,'Referenciacion_y_verificacion__c');
	
	}
}