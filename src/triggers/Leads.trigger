trigger Leads on Lead (after update) {

    if(Trigger.isUpdate){
    /**
    * Actualización del número de candidatos asignados al asesor del canal digital
    **/
        List<User> lstUsuarios = new List<User>();
        for(Lead lead : Trigger.new){
            Lead oldLead = Trigger.oldMap.get(lead.Id);
            if(oldLead.OwnerId != lead.OwnerId){
                User user = new User();
                user = [select Id, ProfileId, Email from User where Id = :lead.OwnerId];
                Profile asesorCanalDigital = [SELECT Id FROM Profile WHERE Name = 'Asesor comercial canal digital'];
               
                if(user.ProfileId == asesorCanalDigital.Id){
                    System.debug('Leads Trigger->Candidato asignado');
                    lstUsuarios.add(user);
                } else {
                    System.debug('aún no se ha asignado el candidato.' + '\n' + 'OwnerId: ' + lead.OwnerId);   
                }
            }
        }

        if(!lstUsuarios.isEmpty()){
            List<Asesor_Canal_Digital__c> lstAsesores = new List<Asesor_Canal_Digital__c>();
            Map<String, Integer> candidatosAsignados = new Map<String, Integer>();
            for(User user : lstUsuarios){
                candidatosAsignados.put(user.Email, [select count() from Lead where OwnerId = :user.Id and IsConverted = false]);
            }

            lstAsesores = [
                SELECT
                    Id,
                    Email__c,
                    Candidatos_asignados__c
                FROM Asesor_Canal_Digital__c
                WHERE Email__c IN :candidatosAsignados.keySet()
            ];
            if(!lstAsesores.isEmpty()){
                for(Asesor_Canal_Digital__c asesor : lstAsesores){
                    asesor.Candidatos_asignados__c = candidatosAsignados.get(asesor.Email__c);
                }
                update lstAsesores;
            }
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