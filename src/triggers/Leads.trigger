trigger Leads on Lead (after update) {
   
    Set<Id> idCandidatosViables = new Set<Id>();
    for(Lead lead : Trigger.new){
        Lead oldLead = Trigger.oldMap.get(lead.Id);
        System.debug(
            'oldLead.Concepto_del_candidato__c: ' + oldLead.Concepto_del_candidato__c + '\n' +
            'lead.Concepto_del_candidato__c: ' + lead.Concepto_del_candidato__c 
        );
        if( oldLead.Concepto_del_candidato__c != lead.Concepto_del_candidato__c && lead.Concepto_del_candidato__c == 'VIABLE'){
            idCandidatosViables.add(lead.Id);
        }
    }

    System.debug('LeadsTrigger->idCandidatosViables.size(): ' +idCandidatosViables.size());
    if(!idCandidatosViables.isEmpty()){
        List<Lead> candidatosViables = new List<Lead>();
        candidatosViables = [
            SELECT
                Id,
                OwnerId,
                Numero_del_candidato__c,
                Concepto_del_candidato__c
            FROM Lead
            WHERE Id IN :idCandidatosViables 
        ];
        System.debug('LeadsTrigger->candidatosViables.size(): ' +candidatosViables.size());

        if(!candidatosViables.isEmpty()){
            AsignacionDeCandidatos.asignar(candidatosViables);
        } 
    }


    /*
    * Esta funcionalidad es parte del sprint 2 y esta pendiente por probar (09/08/2017)
    * Si el candidato existe en la base de datos y aún no se ha convertido
    */
    //if(Trigger.new.size() == 1 && [select count() from Lead where Numero_de_identificacion__c = :Trigger.new[0].Numero_de_identificacion__c and IsConverted = false] > 0){
    //    Lead oldLead = [
    //        SELECT
    //            Id,
    //            CreatedDate,
    //            LastModifiedDate,
    //            OwnerId,
    //            IsConverted
    //        FROM
    //            Lead
    //        WHERE Numero_de_identificacion__c = :Trigger.new[0].Numero_de_identificacion__c
    //        AND IsConverted = false
    //    ];
        
    //    Date createdDate = Date.newInstance(oldLead.CreatedDate.year(), oldLead.CreatedDate.month(), oldLead.CreatedDate.day());
    //    Date lastModifiedDate = Date.newInstance(oldLead.LastModifiedDate.year(), oldLead.LastModifiedDate.month(), oldLead.LastModifiedDate.day());
        
    //    if(createdDate.daysBetween( lastModifiedDate ) < 60){
    //     User propietario = [
    //        SELECT
    //            Name,
    //            Email
    //        FROM
    //            User
    //        WHERE Id = :oldLead.OwnerId
    //     ];
         
    //     Trigger.new[0].addError('El candidato ya existe en la base de datos. Por favor comuniquese al correo ' + propietario.Email + ' para actualizar la información.');
    //    } else {
    //        delete oldLead;
    //    } 
    //}
   
}