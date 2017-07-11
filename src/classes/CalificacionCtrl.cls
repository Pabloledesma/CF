public with sharing class CalificacionCtrl {
    
    Transient public Id idInfoComite {get; set;}
    Transient public Informacion_comite__c infoComite {get; set;}
    Transient public Calificacion__c calificacion {get; set;}
    Transient public List<Calificacion__c> lstCalificaciones { get; set; } 
    Transient public Double porcentajeDeUsoTc { get; set; }
    
    public CalificacionCtrl(ApexPages.StandardController stdController){
        System.debug(stdController.getRecord());
        idInfoComite = ApexPages.currentPage().getParameters().get('id');
        if(idInfoComite != null){
            this.calificacion = new Calificacion__c(Informacion_comite__c = idInfoComite, Disponible__c = true);
            checkAvailability();
            this.infoComite = getInfoComite();
            setPorcentajeDeUsoTc();
        }   
    }
    
    /**
     * Obtiene la información comité
     **/
    public Informacion_comite__c getInfoComite(){
         Informacion_comite__c ic = [
                select 
                    Relacion_cuota_ingreso_propuesta__c,
                    Ind_relacion_cuota_ingeso_neto_propuesta__c,
                    Numero_de_consultas__c,
                    Cliente_deudor__c,
             		N_de_creditos_vigentes__c,
             		Credito_solicitado__c,
             		Subsidio__c,
             		Valor_total_del_Inmueble__c
             		
                from 
                    Informacion_comite__c
                where Id = :this.idInfoComite
            ];
            
            return ic;
    }
    
    /**
     * Verifica si este usuario ya fué calificado en los últimos 60 días
     * 
     * */
    private void checkAvailability(){
        
        this.lstCalificaciones = [
            select   
                c.Id,
                c.Name,
                c.Porcentaje_de_utilizacion_tc__c,
                c.Aportes_de_recursos_propios__c,
                c.Calificacion__c,
                c.Eximido_de_calificacion__c,
                c.CreatedDate,
                c.Informacion_comite__c,
                c.Numero_de_Consultas__c,
                c.N_mero_de_cr_ditos_vigentes__c,
                c.Relacion_cuota_ingreso__c
               
            from 
            	Calificacion__c c 
            where 
            	c.CreatedDate = LAST_N_DAYS:60
            and
            	c.Informacion_comite__c = :idInfoComite
        ];
        
        if(lstCalificaciones.size() > 2){
            this.calificacion.Disponible__c = false;
            ApexPages.addmessage(
                new ApexPages.message(
                        ApexPages.severity.ERROR,
                        'El usuario ya fué calificado dos veces en los últimos 60 días'
                )
            );
        }        
    }
    
    
    /**
     * Calcula el porcentaje de utilización de la tarjeta de crédito
     */
    public void setPorcentajeDeUsoTc(){
        
         
        Informacion_financiera__c infoFinanciera = [
            Select 
                Valor_cupo__c, 
                Valor_cupo2__c, 
                Saldo__c, 
                Saldo2__c
            From 
                Informacion_financiera__c  
            where Cliente_deudor__c = :this.infoComite.Cliente_deudor__c 
                order by CreatedDate desc limit 1
        ];
        
        Double valorCupo = (infoFinanciera.Valor_cupo__c != null) ? infoFinanciera.Valor_cupo__c : 0;
        Double valorCupo2 = (infoFinanciera.Valor_cupo2__c != null) ? infoFinanciera.Valor_cupo2__c : 0;
        Double saldo = (infoFinanciera.Saldo__c != null) ? infoFinanciera.Saldo__c : 0;
        Double saldo2 = (infoFinanciera.Saldo2__c != null) ? infoFinanciera.Saldo2__c : 0;
        Double cupo = valorCupo + valorCupo2;
        Double saldoTotal = saldo + saldo2;
        this.porcentajeDeUsoTc = ( cupo != 0 ) ? saldoTotal/cupo : -0.09434;
        System.debug('El porcentaje de uso TC es: ' + this.porcentajeDeUsoTc);
           
    }
    
    /**
     * Calcula los aportes propios
     * */
    public Decimal aportesPropios(){
        Informacion_comite__c ic = getInfoComite();
        Decimal recursosPropios = (Decimal)(ic.Valor_total_del_Inmueble__c - ic.Credito_solicitado__c - ic.Subsidio__c)/ic.Valor_total_del_Inmueble__c;
        return (recursosPropios > 0.5) ? 0.5 : recursosPropios;
    }
    
    /**
     * Crea una calificación
     */
   
    public void Calificar(){
        Calificacion__c calificacion = new Calificacion__c(
            Aportes_de_recursos_propios__c		= this.aportesPropios(),
            N_mero_de_cr_ditos_vigentes__c      = this.infoComite.N_de_creditos_vigentes__c,
            Relacion_cuota_ingreso__c           = this.infoComite.Relacion_cuota_ingreso__c,
            Numero_de_Consultas__c              = this.infoComite.Numero_de_consultas__c,
            Porcentaje_de_utilizacion_tc__c     = this.porcentajeDeUsoTc,
            Calificacion__c                     = (Double) (
                ((this.infoComite.N_de_creditos_vigentes__c != null) ? this.infoComite.N_de_creditos_vigentes__c : 0) +
                ((this.infoComite.Relacion_cuota_ingreso__c != null) ? this.infoComite.Relacion_cuota_ingreso__c : 0) +
                ((this.infoComite.Numero_de_consultas__c  != null) ? this.infoComite.Numero_de_consultas__c : 0)
            ) / 100
        );
    
        try {
            insert calificacion;
        } catch (Exception ex){
            ApexPages.addMessages(ex);
        }
        
        //this.calificacion = calificacion;
        //this.lstCalificaciones.add(calificacion);
    }
    
}