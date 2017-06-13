public with sharing class SolicitudCredito_cls {
	
	public void actualizarCodeudores(Solicitud_de_credito__c solicitudActual)
	{
		List<Opportunity> lstOpp = [SELECT Account.Name,Cliente_deudor__c,Codeudor_1__c,Codeudor_2__c,Codeudor_3__c FROM Opportunity WHERE Id =: solicitudActual.Oportunidad__c];
		if( !lstOpp.isEmpty() )
		{
			solicitudActual.Cliente_deudor__c = lstOpp.get(0).Account.Id;
			if(lstOpp.get(0).Codeudor_1__c != null)
			{
				solicitudActual.Codeudor_1__c = lstOpp.get(0).Codeudor_1__c;
			}
			if(lstOpp.get(0).Codeudor_2__c != null)
			{
				solicitudActual.Codeudor_2__c = lstOpp.get(0).Codeudor_2__c;
			}
			if(lstOpp.get(0).Codeudor_3__c != null)
			{
				solicitudActual.Codeudor_3__c = lstOpp.get(0).Codeudor_3__c;
			}
		}
	}
}