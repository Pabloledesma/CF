trigger Leads on Lead (before insert) {
    /*
    * Si el candidato existe en la base de datos y aún no se ha convertido
    */
    if(Trigger.new.size() == 1 && [select count() from Lead where Numero_de_identificacion__c = :Trigger.new[0].Numero_de_identificacion__c and IsConverted = false] > 0){
        Lead oldLead = [
            SELECT
                Id,
                CreatedDate,
                LastModifiedDate,
                OwnerId,
                IsConverted
            FROM
                Lead
            WHERE Numero_de_identificacion__c = :Trigger.new[0].Numero_de_identificacion__c
            AND IsConverted = false
        ];
        
        Date createdDate = Date.newInstance(oldLead.CreatedDate.year(), oldLead.CreatedDate.month(), oldLead.CreatedDate.day());
        Date lastModifiedDate = Date.newInstance(oldLead.LastModifiedDate.year(), oldLead.LastModifiedDate.month(), oldLead.LastModifiedDate.day());
        
        if(createdDate.daysBetween( lastModifiedDate ) < 60){
         User propietario = [
            SELECT
                Name,
                Email
            FROM
                User
            WHERE Id = :oldLead.OwnerId
         ];
         
         Trigger.new[0].addError('El candidato ya existe en la base de datos. Por favor comuniquese al correo ' + propietario.Email + ' para actualizar la información.');
        } else {
            delete oldLead;
        } 
    }
   
}