public with sharing class AutorizacionDeDesembolsoCtrl {
    
    public String Banco {get; set;}
    public String Nit {get; set;}
    public String valorEnLetras {get; set;}
    public String valorEnNumeros {get; set;}
    public Id solicitudDeCredito {get; set;}
    public Date fechaDeAprobacion {get; set;}
    public String deudorPrincipal {get; set;}
    public String direccionDelInmueble {get; set;}
    public String proyecto {get; set;}
    public String matricula {get; set;}
    public String fechaDeCreacion { get; set; }
    
    public AutorizacionDeDesembolsoCtrl(){
        this.Banco = 'Caja Social'; //Lo digita la auxiliar
        this.Nit = '98754321-3'; // Lo digita la auxiliar
        this.fechaDeCreacion = Date.today().format();
        this.solicitudDeCredito = ApexPages.currentPage().getParameters().get('id');
        Solicitud_de_credito__c sc = [select 
            Id,
            Valor_del_credito__c, 
            Fecha_comite__c, 
            Cliente_deudor__c, 
            Proyecto__c 
            from Solicitud_de_credito__c where Id = :this.solicitudDeCredito];
            
        System.debug(sc);
        
    }
}