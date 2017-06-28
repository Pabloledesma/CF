public without sharing class LeadConversionHelper {
    
    public List<Lead> lstLead;
    public Account clienteDeudor;    //Trigger.new[0]
    public List<Codeudor__c> lstCodeudores;
    public RecordType rt;

    public LeadConversionHelper(Account newAccount) {
        this.clienteDeudor = newAccount;
        this.rt = [select Id, Name from RecordType where Name = 'Codeudores' and SobjectType='Account'];
        this.lstLead =
        [
                select
                    Id,
                    isConverted,
                    LastName,
                    FirstName,
                    Canal_digital__c,
                    Tipo_de_documento__c,
                    Numero_de_identificacion__c,
                    Ciudad_de_residencia__c,
                    Tipo_de_ocupacion__c,
                    Fecha_de_nacimiento__c,
                    Lugar_de_nacimiento__c,
                    Fecha_de_expedicion_cc__c,
                    Lugar_de_expedicion__c,
                    Estado_civil__c,
                    Numero_de_celular__c,
                    Tipo_de_producto_que_le_interesa__c,
                    //Informaciòn de residencia
                    Tipo_de_vivienda_residencia__c,
                    Antiguedad_en_la_vivienda_actual_en_a_o__c,
                    Direccion_residencia__c,
                    Phone,
                    Estrato__c,
                    // Informaciòn laboral
                    Tipo_de_contrato__c,
                    Fecha_de_ingreso_del_empleo_actual__c,
                    Nombre_entidad_empleadora_o_negocio__c,
                    Direccion_de_la_empresa__c,
                    Tiempo_de_experiencia_en_anos__c,
                    Ciudad_laboral_Actividad_Economica_c__c,
                    Cargo_actual__c,
                    Telefono_Actividad_Economica__c,
                    // Referencia familiar
                    Familiar_Nombre_y_Apellido__c,
                    Parentesco__c,
                    Direccion_Referencia_Familiar__c,
                    Telefono_referencia_familiar__c,
                    Ciudad_referencia_familiar__c,
                    // Referencia personal
                    Personal_Nombre_y_Apellido__c,
                    Relacion__c,
                    Direccion_referencia_personal__c,
                    Telefono_referencia_personal__c,
                    Ciudad_referencia_personal__c
            from Lead 
            where Numero_de_identificacion__c = :clienteDeudor.Numero_de_documento__c
        ];
        this.lstCodeudores =
        [
                select
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
                Ciudad_laboral__c,
                Ciudad_de_residencia__c,
                Direccion_de_la_empresa__c,
                Estado_civil__c,
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
                Ocupacion_u_oficio_principal__c,
                Relacion__c,
                Telefono_de_la_oficina__c,
                Telefono_fijo__c,
                Tipo_de_documento__c
            from Codeudor__c 
            where Candidato__c = :this.lstLead[0].Id];

        Id idSolicitud = this.createSolicitud();
        if(idSolicitud != null)
        this.createRadicacion(idSolicitud);

        if(this.lstCodeudores.size() > 0){
            this.createAccounts();
        }

    }

    public void createAccounts(){
        //System.debug('LeadConversionHelper.createAccounts -> Cliente deudor: ' + this.clienteDeudor.Id);
        List<Account> lstAccounts = new List<Account>();
        for(Codeudor__c c: this.lstCodeudores){
            lstAccounts.add(new Account(
                RecordTypeId                        = this.rt.Id,
                Cliente_deudor__c                   = this.clienteDeudor.Id,
                LastName                            = c.Apellidos__c,
                FirstName                           = c.Name,
                Numero_de_documento__c              = String.valueOf(c.Numero_de_documento__c),
                Tipo_de_documento__c                = c.Tipo_de_documento__c,
                Ciudad_de_residencia__c             = c.Ciudad_de_residencia__c,
                Tipo_de_ocupacion__c                = c.Ocupacion_u_oficio_principal__c,
                Fecha_de_nacimiento__c              = c.Fecha_de_nacimiento__c,
                Lugar_de_nacimiento__c              = c.Lugar_de_nacimiento__c,
                Fecha_de_expedicion_cc__c           = c.Fecha_de_expedicion__c,
                Lugar_de_expedicion__c              = c.Lugar_de_expedicion__c,
                Estado_civil__c                     = c.Estado_civil__c,
                Numero_de_telefono_celular__c       = c.Numero_de_celular__c,
                Telefono__c                         = c.Telefono_fijo__c,
                Fecha_de_ingreso_a_empleo_actual__c = c.Fecha_de_ingreso__c,
                Canal_digital__c                    = 'Si'
            ));
        }
        
        
        //List<Id> codeudoresCreados = new List<Id>();
        Database.SaveResult[] srList = Database.insert(lstAccounts, false);
        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                System.debug('Se creó el codeudor exitosamente: ' + sr.getId());
                //codeudoresCreados.add(sr.getId());
            } else {
                for(Database.Error error : sr.getErrors()){
                    System.debug('Errores al insertar cuentas de tipo codeudor: ');
                    System.debug(error.getStatusCode() + ': ' + error.getMessage());
                    System.debug('Verificar los siguientes campos: ' + error.getFields());
                }
            }
        }
        //System.debug('LeadConversionHelper.createAccounts -> codeudoresCreados: ');
        //System.debug(codeudoresCreados);
        //if(codeudoresCreados.size() > 0) updateOpportunity(codeudoresCreados);
        
        //System.debug('Codeudores creados: ');
        //System.debug(codeudoresCreados);
    }

    public Id createSolicitud(){

        List<RecordType> lstRt = [select id, name from RecordType where SobjectType = 'Solicitud_de_credito__c'];
        Map<String, Id> mapRt = new Map<String, Id>();
        for(RecordType rt : lstRt){
            mapRt.put(rt.Name, rt.Id);
        }

        Solicitud_de_credito__c sc = new Solicitud_de_credito__c();

        if( this.lstLead[0].Tipo_de_producto_que_le_interesa__c == 'Crédito de vivienda nueva' ||
            this.lstLead[0].Tipo_de_producto_que_le_interesa__c == 'Asignación de cupo')

            sc.RecordTypeId = mapRt.get('Vivienda Nueva');

        else if(this.lstLead[0].Tipo_de_producto_que_le_interesa__c == 'Crédito de vivienda usada' ||
        this.lstLead[0].Tipo_de_producto_que_le_interesa__c == 'Mejoramiento de vivienda')

            sc.RecordTypeId = mapRt.get('Vivienda Usada / Mejoramiento');

        else if(this.lstLead[0].Tipo_de_producto_que_le_interesa__c == 'Compra de cartera')

        sc.RecordTypeId = mapRt.get('Compra de cartera hipotecaria');
        sc.Cliente_deudor__c = this.clienteDeudor.Id;

        Database.SaveResult result = Database.insert(sc, false);
        
        if(result.isSuccess()){
            System.debug('createSolicitud -> Se creó la Solicitud de credito: ' + result.getId());
            return result.getId();
        } else {
            for(Database.Error error : result.getErrors()){
                System.debug('Errores al insertar la solicitud de crédito: ');
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
            return null;
        }
    }

    public void createRadicacion(Id solicitud_de_credito_id){

        Radicacion_de_credito__c rc = new Radicacion_de_credito__c(
                Solicitud_de_credito__c                     = solicitud_de_credito_id,
                Cliente_deudor__c                           = this.clienteDeudor.id,
                // Información de residencia
                Tipo_de_vivienda__c                         = this.lstLead[0].Tipo_de_vivienda_residencia__c,
                Antiguedad_en_la_vivienda_actual_en_ano__c  = this.lstLead[0].Antiguedad_en_la_vivienda_actual_en_a_o__c,
                Direccion_residencia__c                     = this.lstLead[0].Direccion_residencia__c,
                Telefono_residencia__c                      = this.lstLead[0].Phone,
                Estrato__c                                  = this.lstLead[0].Estrato__c,
                // Información laboral
                Tipo_de_contrato__c                         = this.lstLead[0].Tipo_de_contrato__c,
                Nombre_entidad_empleadora_o_negocio__c      = this.lstLead[0].Nombre_entidad_empleadora_o_negocio__c,
                Direccion_comercial__c                      = this.lstLead[0].Direccion_de_la_empresa__c,
                Tiempo_de_experiencia_en_anos__c            = this.lstLead[0].Tiempo_de_experiencia_en_anos__c,
                Profesion_u_oficio__c                       = this.lstLead[0].Tipo_de_contrato__c,
                Ciudad_Laboral__c                           = this.lstLead[0].Ciudad_laboral_Actividad_Economica_c__c,
                Cargo_actual__c                             = this.lstLead[0].Cargo_actual__c,
                Telefono_oficina__c                         = this.lstLead[0].Telefono_Actividad_Economica__c,
                Telefono_actividad_economica__c             = this.lstLead[0].Telefono_Actividad_Economica__c,
                // Referencia Familiar
                Familiar_Nombre_y_Apellido__c               = this.lstLead[0].Familiar_Nombre_y_Apellido__c,
                Parentesco_familiar__c                      = this.lstLead[0].Parentesco__c,
                Direccion_parentesco_familiar__c            = this.lstLead[0].Direccion_Referencia_Familiar__c,
                Telefono_parentesco_familiar__c             = this.lstLead[0].Telefono_referencia_familiar__c,
                Ciudad_parentesco_familiar__c               = this.lstLead[0].Ciudad_referencia_familiar__c,
                // Referencia personal
                Personal_Nombre_y_Apellido__c               = this.lstLead[0].Personal_Nombre_y_Apellido__c,
                Parentesco_personal__c                      = this.lstLead[0].Relacion__c,
                Direccion_parentesco_personal__c            = this.lstLead[0].Direccion_referencia_personal__c,
                Ciudad_parentesco_personal__c               = this.lstLead[0].Ciudad_referencia_personal__c,
                Telefono_parentesco_personal__c             = this.lstLead[0].Telefono_referencia_personal__c
        );

        Database.SaveResult result = Database.insert(rc, false);
        
        if(result.isSuccess()){
            System.debug('Se creó la radicación de credito: ' + result.getId());
        } else {
            for(Database.Error error : result.getErrors()){
                System.debug('Errores al insertar la radicación de crédito: ');
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
        }
        
    }
  
}