trigger Calificacion on Calificacion__c (before insert) {
    
    //Verificar si este usuario ya fué calificado en los últimos 60 días
    List<Calificacion__c> lstCalificaciones = [
        select 
            c.Informacion_comite__c, 
            c.Id, 
            c.CreatedDate 
        from 
            Calificacion__c c 
        where 
            c.CreatedDate = LAST_N_DAYS:60
        and
            c.Informacion_comite__c = :Trigger.new[0].Informacion_comite__c 
    ];
    
    try {
        CalificationWarning cw = new CalificationWarning(lstCalificaciones); 
    } catch (CalificationWarning.NumberOfCalificationsException e) {
        System.debug('Error: ' + e);
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Excepción por exceder el número de calificaciones realizadas en 2 meses');
    }
    
    
    // Si el usuario está eximido de calificación se debe calificar al usuario por encima del umbral definido   
    //Obtener el Id de la información comité
    Id infoComiteId = Trigger.new[0].Informacion_comite__c;
    
    Informacion_comite__c ic = [
        select 
            Relacion_cuota_ingreso__c,
            Ind_relacion_cuota_ingeso_neto_dispon__c,
            Numero_de_consultas__c,
            Cliente_deudor__c
        from 
            Informacion_comite__c
        where Id = :infoComiteId
    ];
        
    //Aportes_de_recursos_propios__c
    //N_mero_de_cr_ditos_vigentes__c
    Trigger.new[0].Relacion_cuota_ingreso__c        = ic.Relacion_cuota_ingreso__c;
    Trigger.new[0].Indice_relacion_cuota_ingreso__c = ic.Ind_relacion_cuota_ingeso_neto_dispon__c;
    Trigger.new[0].Numero_de_Consultas__c           = ic.Numero_de_consultas__c;
    
    Informacion_financiera__c infoFinanciera = [
        Select 
            i.Valor_cupo__c, 
            i.Valor_cupo2__c, 
            i.Saldo__c, 
            i.Saldo2__c 
        From 
            Informacion_financiera__c i 
        where i.Cliente_deudor__c = :ic.Cliente_deudor__c
    ];
    
    Double cupo = infoFinanciera.Valor_cupo__c + infoFinanciera.Valor_cupo2__c;
    Double saldo = infoFinanciera.Saldo__c + infoFinanciera.Saldo2__c;
    
    if( cupo != 0 && saldo != 0 ){
        Trigger.new[0].Porcentaje_de_utilizacion_tc__c = saldo/cupo;
    }
    
    //Confirmar la ecuación con Juan Carlos  
    Trigger.new[0].Calificacion__c = ic.Relacion_cuota_ingreso__c + ic.Ind_relacion_cuota_ingeso_neto_dispon__c + ic.Numero_de_consultas__c + Trigger.new[0].Porcentaje_de_utilizacion_tc__c;
    
}