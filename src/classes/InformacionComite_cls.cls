public with sharing class InformacionComite_cls {
	public void actualizarCodeudores(Informacion_comite__c infoActual)
	{
		List<Radicacion_de_credito__c> lstInfoComite = [
			SELECT 
				Name, 
				Cargo_actual__c, 
				Solicitud_de_credito__r.Name, 
				Cliente_deudor__c,
				Codeudor_1__c,
				Codeudor_2__c,
				Codeudor_3__c,
				Solicitud_de_credito__c 
			FROM Radicacion_de_credito__c 
			WHERE Id =:infoActual.Radicacion__c
		];
		if( !lstInfoComite.isEmpty() )
		{
			infoActual.Cliente_deudor__c = lstInfoComite.get(0).Cliente_deudor__c;
			if(lstInfoComite.get(0).Codeudor_1__c != null)
			{
				infoActual.Codeudor_1__c = lstInfoComite.get(0).Codeudor_1__c;
			}
			if(lstInfoComite.get(0).Codeudor_2__c != null)
			{
				infoActual.Codeudor_2__c = lstInfoComite.get(0).Codeudor_2__c;
			}
			if(lstInfoComite.get(0).Codeudor_3__c != null)
			{
				infoActual.Codeudor_3__c = lstInfoComite.get(0).Codeudor_3__c;
			}
			infoActual.Solicitud_de_credito__c = lstInfoComite.get(0).Solicitud_de_credito__c;
			infoActual.Id_Credito__c = lstInfoComite.get(0).Solicitud_de_credito__r.Name;
			infoActual.Id_Radicacion__c = lstInfoComite.get(0).Name;
			//infoActual.Cargo_deudor__c = lstInfoComite.get(0).Cargo_actual__c;
		}
	}
}