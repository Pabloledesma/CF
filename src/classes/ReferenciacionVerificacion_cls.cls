public with sharing class ReferenciacionVerificacion_cls 
{
	public ReferenciacionVerificacion_cls()
	{
		
	}
	public void actualizarCodeudores(Referenciacion_y_verificacion__c referenciacionActual)
	{
		List<Radicacion_de_credito__c> lstRadicacion = [SELECT Name, Cargo_actual__c, Cliente_deudor__c,Codeudor_1__c,Codeudor_2__c,Codeudor_3__c FROM Radicacion_de_credito__c WHERE Id =:referenciacionActual.Radicacion_de_credito__c];
		if( !lstRadicacion.isEmpty() )
		{
			referenciacionActual.Cliente_deudor__c = lstRadicacion.get(0).Cliente_deudor__c;
			if(lstRadicacion.get(0).Codeudor_1__c != null)
			{
				referenciacionActual.Codeudor_1__c = lstRadicacion.get(0).Codeudor_1__c;
			}
			if(lstRadicacion.get(0).Codeudor_2__c != null)
			{
				referenciacionActual.Codeudor_2__c = lstRadicacion.get(0).Codeudor_2__c;
			}
			if(lstRadicacion.get(0).Codeudor_3__c != null)
			{
				referenciacionActual.Codeudor_3__c = lstRadicacion.get(0).Codeudor_3__c;
			}
			referenciacionActual.Id_Radicacion__c = lstRadicacion.get(0).Name;
			//referenciacionActual.Cargo_deudor__c = lstRadicacion.get(0).Cargo_actual__c;
		}
	}
}