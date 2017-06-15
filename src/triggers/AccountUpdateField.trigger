trigger AccountUpdateField on Account (after insert, before update)
{

    if(Trigger.isUpdate){
	    AccountUpdateField_cls.setAccountUpdate(trigger.new); 
    }
 
    List<Lead> lead = [select
    			Id, 
    			isConverted, 
    			Numero_de_identificacion__c,
    			Canal_digital__c,
                Tipo_de_vivienda_residencia__c
    		from Lead 
    		where Numero_de_identificacion__c = :Trigger.new[0].Numero_de_documento__c];
    List<RecordType> rt = [select Id, Name from RecordType where Name = 'Cliente deudor' and SobjectType='Account'];

    if(Trigger.isInsert && lead.size() > 0 && Trigger.new[0].RecordTypeId == rt[0].Id){
    	Account clienteDeudor = [select Id from Account where Numero_de_documento__c = :Trigger.new[0].Numero_de_documento__c];
        System.debug('El id del cliente deudor es: ' + clienteDeudor.Id);
    	System.debug('El id del cliente deudor es: ' + Trigger.new[0].Id);
    	RecordType rt = [select Id, Name from RecordType where Name = 'Codeudores' and SobjectType='Account'];
    	
        // Si tiene lead asociado
    	if(lead.size() > 0){
    		// Hay codeudores asociados? 
    		List<Codeudor__c> lstCodeudores = [select 
                                RecordTypeId,
                                Name,
                                Apellidos__c,
                                Apellidos_Ref_Familiar__c,
                                Apellidos_Ref_Personal__c,
                                Barrio_de_residencia_Ref_Familiar__c,
                                Barrio_de_residencia_Ref_Personal__c,
                                Candidato__c,
                                Cargo_actual__c,
                                Celular_Ref_Familiar__c,
                                Celular_Ref_Personal__c,
                                Ciudad_de_residencia__c,
                                Ciudad_en_la_que_labora__c,
                                Direccion_de_la_empresa__c,
                                Direccion_de_residencia__c,
                                Estado_civil__c,
                                Estrato__c,
                                Experiencia__c,
                                Fecha_de_expedicion__c,
                                Fecha_de_ingreso__c,
                                Fecha_de_nacimiento__c,
                                Lugar_de_expedicion__c,
                                Lugar_de_nacimiento__c,
                                Nivel_de_educaci_n__c,
                                Nombre_entidad_empleadora__c,
                                Nombres_Ref_Familiar__c,
                                Nombres_Ref_Personal__c,
                                Numero_de_celular__c,
                                Numero_de_documento__c,
                                Ocupacion__c, 
                                Parentesco_Ref_Familiar__c,
                                Profesion_u_oficio__c,
                                Telefono_de_la_oficina__c,
                                Telefono_fijo__c,
                                Tipo_de_contrato__c,
                                Tipo_de_documento__c,
                                Tipo_de_vivienda__c
                            from Codeudor__c where Candidato__c = :lead[0].Id];

            System.debug('Codeudores: ' + lstCodeudores.size());
    		//Crear una cuenta de tipo codeudor
    		if(lstCodeudores.size() > 0){
    			List<Account> lstAccounts = new List<Account>();
    			for(Codeudor__c c: lstCodeudores){
    				lstAccounts.add(new Account(
    					RecordTypeId = rt.Id,
    					Cliente_deudor__c = clienteDeudor.Id,
    					LastName = c.Apellidos__c,
                        FirstName = c.Name,
    					Numero_de_documento__c = String.valueOf(c.Numero_de_documento__c),
    					Tipo_de_documento__c = c.Tipo_de_documento__c,
    					Ciudad_de_residencia__c = c.Ciudad_de_residencia__c,
    					Tipo_de_ocupacion__c = c.Ocupacion__c,
    					Fecha_de_nacimiento__c = c.Fecha_de_nacimiento__c,
    					Lugar_de_nacimiento__c = c.Lugar_de_nacimiento__c,
    					Fecha_de_expedicion_cc__c = c.Fecha_de_expedicion__c,
    					Lugar_de_expedicion__c = c.Lugar_de_expedicion__c,
    					Estado_civil__c = c.Estado_civil__c,
    					Numero_de_telefono_celular__c = String.valueOf(c.Numero_de_celular__c),
    					Tipo_de_contrato__c = c.Tipo_de_contrato__c,
    					Telefono__c = String.valueOf(c.Telefono_fijo__c),
    					Fecha_de_ingreso_a_empleo_actual__c = c.Fecha_de_ingreso__c
    				));
    			}

    			insert lstAccounts;
    		}
    		
            // Crea la solicitud de crédito
            Solicitud_de_credito__c sc = new Solicitud_de_credito__c();
            Radicacion_de_credito__c rc = new Radicacion_de_credito__c();
            if(lstCodeudores.size() > 0){
                Integer i = 0;
                for(Codeudor__c cod: lstCodeudores){
                    if(i == 0){
                        sc.Codeudor_1__c = cod.Id;
                        rc.Codeudor_1__c = cod.Id;
                    } 
                    if(i == 1){
                        sc.Codeudor_2__c = cod.Id;
                        rc.Codeudor_2__c = cod.Id;
                    }
                    if(i == 2){
                        sc.Codeudor_3__c = cod.Id;
                        rc.Codeudor_3__c = cod.Id;
                    }
                    i++;
                }    
            } 
            
            insert sc;

            
            

        } // lead.size() > 0

       
    }
}