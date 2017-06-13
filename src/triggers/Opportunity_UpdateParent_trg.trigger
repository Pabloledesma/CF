trigger Opportunity_UpdateParent_trg on Opportunity (before insert, before update) 
{
    if(trigger.new.size()==1)
    {
        UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls(); 
        
        classUpdateRegistersLookUp.setRegister(trigger.new[0],'Opportunity');
        
    }
}