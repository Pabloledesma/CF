@isTest (SeeAllData=true)
private class UpdateFromParent_tst 
{

    static testMethod void myUnitTest() 
    {
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        insert objRadicacion_de_credito;
         Referenciacion_y_verificacion__c objReferenciacion_y_verificacion= new Referenciacion_y_verificacion__c();
         objReferenciacion_y_verificacion.Radicacion_de_credito__c=objRadicacion_de_credito.Id;
        insert objReferenciacion_y_verificacion;
       // UpdateFromParent up = new UpdateFromParent();
       
       //up.setRegister(sobjOrigen,lstActualizacionmasivaderegistros[0].Objeto_destino__c);
    }
    
}