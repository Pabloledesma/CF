public with sharing class CartaController {
    
    public String Banco {get; set;}
    public String Nit {get; set;}
    public String valor {get; set;}
    public Id solicitudDeCredito {get; set;}
    public Date fechaDeAprobacion {get; set;}
	public String deudorPrincipal {get; set;}
	public String direccionDelInmueble {get; set;}
	public String proyecto {get; set;}
	public String matricula {get; set;}
	
	public CartaController(){
		this.Banco = 'Caja Social';
		this.Nit = '98754321-3';
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