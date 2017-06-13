public with sharing class InformacionFinanciera_cls {
	
	public void actualizarCodeudores(Informacion_financiera__c infoActual)
	{
		List<Radicacion_de_credito__c> lstInfoFinanciera = [SELECT Name, Cliente_deudor__c,Codeudor_1__c,Codeudor_2__c,Codeudor_3__c FROM Radicacion_de_credito__c WHERE Id =:infoActual.Radicacion_de_credito__c];
		if( !lstInfoFinanciera.isEmpty() )
		{
			infoActual.Cliente_deudor__c = lstInfoFinanciera.get(0).Cliente_deudor__c;
			if(lstInfoFinanciera.get(0).Codeudor_1__c != null)
			{
				infoActual.Codeudor_1__c = lstInfoFinanciera.get(0).Codeudor_1__c;
			}
			if(lstInfoFinanciera.get(0).Codeudor_2__c != null)
			{
				infoActual.Codeudor_2__c = lstInfoFinanciera.get(0).Codeudor_2__c;
			}
			if(lstInfoFinanciera.get(0).Codeudor_3__c != null)
			{
				infoActual.Codeudor_3__c = lstInfoFinanciera.get(0).Codeudor_3__c;
			}
			infoActual.Id_Radicacion__c = lstInfoFinanciera.get(0).Name;
		}
	}
}