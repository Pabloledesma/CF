public class RadicacionCredito_ctr {
	public ApexPages.Standardcontroller controller {get;set;}
    public Radicacion_de_credito__c recordRadicacion  {get;set;}
    public Solicitud_de_credito__c recordSolicitud {get;set;}
    
    public RadicacionCredito_ctr()
    {
    	
    }
    
    //Método constructor de la clase
    public RadicacionCredito_ctr(ApexPages.Standardcontroller incontroller)
    {
    	recordSolicitud = new Solicitud_de_credito__c();
        recordRadicacion = (Radicacion_de_credito__c)incontroller.getRecord();
        System.debug( 'Radicación en el constructor --> '+recordRadicacion );
        List<Solicitud_de_credito__c> lstSC = [SELECT Name, Cliente_deudor__c,Codeudor_1__c,Codeudor_2__c,Codeudor_3__c FROM Solicitud_de_credito__c WHERE Id =:recordRadicacion.Solicitud_de_credito__c];
        if(!lstSC.isEmpty())
        {
        	recordSolicitud = lstSC.get(0);
        	recordRadicacion.Cliente_deudor__c = lstSC.get(0).Cliente_deudor__c;
        	if(lstSC.get(0).Codeudor_1__c != null)
        	{
        		recordRadicacion.Codeudor_1__c = lstSC.get(0).Codeudor_1__c;
        	}
        	if(lstSC.get(0).Codeudor_2__c != null)
        	{
        		recordRadicacion.Codeudor_2__c = lstSC.get(0).Codeudor_2__c;
        	}
        	if(lstSC.get(0).Codeudor_3__c != null)
        	{
        		recordRadicacion.Codeudor_3__c = lstSC.get(0).Codeudor_3__c;
        	}
        	recordRadicacion.Id_Radicacion__c = recordRadicacion.Name;
        }
    }
    
    //Método que se encarga de actualizar el registro de cuenta y direccionar hacia la cuenta
    public PageReference guardar()
    {
    	System.debug( 'Radicación desde el boton guardar '+recordRadicacion );
    	insert recordRadicacion;
        PageReference pr;
        pr = new PageReference('/' + recordRadicacion.id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference cancelar()
    {	
        PageReference pr;
        pr = new PageReference('/' + recordRadicacion.Solicitud_de_credito__c);
        pr.setRedirect(true);
        return pr;
    }
}