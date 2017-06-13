public with sharing class CalificationWarning {
    
    /*
    * Excepción por exceder el número de calificaciones realizadas en 2 meses
    **/
    public class NumberOfCalificationsException extends Exception {}
    
 	public CalificationWarning(List<Calificacion__c> lstCalificaciones){
 		if(lstCalificaciones.size() > 5){
 			throw new NumberOfCalificationsException();
 		}
 	}
    
    
}