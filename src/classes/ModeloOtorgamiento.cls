public with sharing class ModeloOtorgamiento {
	
	private final Calificacion__c calificacion;
	
	public ModeloOtorgamiento(ApexPages.StandardController stdController){
		this.calificacion = (Calificacion__c)stdController.getRecord();
	}
	
	
    
}