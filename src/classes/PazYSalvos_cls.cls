public with sharing class PazYSalvos_cls {
	
	public void actualizarCodeudores(Paz_y_salvo__c objActual)
	{
		List<Solicitud_de_credito__c> lstSolicitud = [SELECT Name, Cliente_deudor__c,Codeudor_1__c,Codeudor_2__c,Codeudor_3__c FROM Solicitud_de_credito__c WHERE Id =: objActual.Solicitud_de_credito__c ];
		if( !lstSolicitud.isEmpty() )
		{
			objActual.Cliente_deudor__c = lstSolicitud.get(0).Cliente_deudor__c;
			if(lstSolicitud.get(0).Codeudor_1__c != null)
			{
				objActual.Codeudor_1__c = lstSolicitud.get(0).Codeudor_1__c;
			}
			if(lstSolicitud.get(0).Codeudor_2__c != null)
			{
				objActual.Codeudor_2__c = lstSolicitud.get(0).Codeudor_2__c;
			}
			if(lstSolicitud.get(0).Codeudor_3__c != null)
			{
				objActual.Codeudor_3__c = lstSolicitud.get(0).Codeudor_3__c;
			}
			objActual.Id_Credito__c = lstSolicitud.get(0).Name;
		}
	}
}