public class SolicitudCreditoVerifyProfile
{
    public SolicitudCreditoVerifyProfile()
    {
    	
    }
    
    public void verifyProfile(Solicitud_de_credito__c objOldSolicitudcredito,Solicitud_de_credito__c objNewSolicitudcredito)
    {
    	String strUserProfile= UserInfo.getProfileId();
    	Boolean blnIsValid=false;
    	List<Controldeestados__c> lstControlDeEstados=[SELECT Estado_1__c,Estado_2__c,Perfil__c 
    	                                       FROM Controldeestados__c where Estado_1__c=:objOldSolicitudcredito.Estado_de_la_solicitud__c 
    	                                           and Estado_2__c=:objNewSolicitudcredito.Estado_de_la_solicitud__c limit 1];
    	                                           
    	Profile objProfile=[SELECT Id,Name FROM Profile where Id=:UserInfo.getProfileId()];
    	
    	if(lstControlDeEstados.size()==1)
    	{
    		List<String> lstConfProfiles=lstControlDeEstados[0].Perfil__c.split(',');
    		
    		for(String strProfiles:lstConfProfiles)
    		{
    			if(strProfiles==objProfile.Name)
    			{
    				blnIsValid=true;
    			}
    		}
    	}
    	
    	System.debug('DebugLine31: '+blnIsValid);
    	
    	//if(objNewSolicitudcredito.Estado_de_la_solicitud__c != null && objOldSolicitudcredito.Estado_de_la_solicitud__c != null || (objNewSolicitudcredito.Estado_de_la_solicitud__c != null && objOldSolicitudcredito.Estado_de_la_solicitud__c != null && objNewSolicitudcredito.Estado_de_la_solicitud__c.equals(objOldSolicitudcredito.Estado_de_la_solicitud__c)))
    	{
    		System.debug('DebugLine33: '+blnIsValid);
    		
    	//	blnIsValid=true;
    	}
    	
    	   	
    	if(!blnIsValid)
    	{
    		objNewSolicitudcredito.addError('Perfil no autorizado!');
    	}
    }
}