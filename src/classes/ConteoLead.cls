@IsTest
public class ConteoLead{
    static testmethod void insertLead(){
        Lead l = new Lead();

        l.FirstName = 'usuario';
        l.LastName = 'prueba';
        l.Numero_de_celular__c = '3214567890';
        l.Email = 'correo@example.com';
        l.Numero_de_identificacion__c = '7896504';
        l.Canal_digital__c ='Si';
        l.Status = 'Nuevo';
        l.Puntaje_data_credito__c = 780;
        l.Concepto_del_candidato__c = 'Cumple score';
        
        insert l;
    }
}