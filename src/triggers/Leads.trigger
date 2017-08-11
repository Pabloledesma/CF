trigger Leads on Lead (after insert) {

    if(Trigger.isInsert){
        //Seleccionar candidatos viables
        List<Lead> lstCandidatosDisponibles = [
            SELECT 
                Id,
                OwnerId,
                Numero_del_Candidato__c
            FROM Lead
            WHERE Canal_digital__c = 'Si'
            AND isConverted = false
            AND Concepto_del_candidato__c = 'VIABLE' 
        ];

        System.debug('Candidatos viables: ' + lstCandidatosDisponibles.size());

        //Seleccionar usuarios activos 
        List<User> lstUsuarios = [
            SELECT 
                Id,
                Name,
                Numero_de_candidatos_asignados__c,
                Meta_Canal_Digital__c
            FROM User
            WHERE Profile.Name = 'Asesor comercial canal digital'
            AND Habilitado_Canal_Digital__c = true
            AND isActive = true
            ORDER BY Numero_de_candidatos_asignados__c ASC
        ];
        System.debug('LeadsTrigger->Usuarios activos: ' + lstCandidatosDisponibles.size());

        /**
        * Asigna el candidato solo si el número de candidatos asignados es menor que la meta asignada por el gerente
        **/
        List<Lead> leadsAsignados = new List<Lead>();
        for(Lead lead : lstCandidatosDisponibles){
            Integer numeroUsuario = Math.mod( Integer.valueOf(lead.Numero_del_Candidato__c), lstUsuarios.size() );
            System.debug('Candidatos asignados: ' + lstUsuarios[ numeroUsuario ].Numero_de_candidatos_asignados__c + ' Meeta: ' + lstUsuarios[ numeroUsuario ].Meta_Canal_Digital__c);
            if(lstUsuarios[ numeroUsuario ].Numero_de_candidatos_asignados__c < lstUsuarios[ numeroUsuario ].Meta_Canal_Digital__c){
                System.debug('Asignando candidato a ' + lstUsuarios[numeroUsuario].Name);
                lead.OwnerId = lstUsuarios[ numeroUsuario ].Id;
                leadsAsignados.add(lead);
            } else {
                System.debug(lstUsuarios[numeroUsuario].Name + ' ya cumplió la meta!');
            }
        }

        if(!leadsAsignados.isEmpty()){

            Database.SaveResult[] lstResults = Database.update(leadsAsignados, false);
            
            for(Database.SaveResult result : lstResults){
                if(!result.isSuccess()){
                    for(Database.Error error : result.getErrors()){
                        System.debug(
                            'Errores al asignar el candidato: \n' +
                            error.getMessage() + '\n' +
                            error.getFields()
                        );
                    } 
                }
            }

            /**
            * Actualización del número de candidatos asignados al asesor del canal digital
            **/
            Map<Id, Integer> mapActualizarCandidatosAsignados = new Map<Id, Integer>(); 
            for(Lead lead : leadsAsignados){
                User user = new User();
                user = [select Id, ProfileId, Email, Numero_de_candidatos_asignados__c from User where Id = :lead.OwnerId];
                mapActualizarCandidatosAsignados.put(user.Id, [select count() from Lead where OwnerId = :user.Id and IsConverted = false]);
            }

           if(!mapActualizarCandidatosAsignados.isEmpty()){
                System.debug('LeadsTrigger->Actualizando candidatos');
                UserHandler.actualizarCandidatosAsignados(mapActualizarCandidatosAsignados);
           } 
        } //if(!leadsAsignados.isEmpty()){
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