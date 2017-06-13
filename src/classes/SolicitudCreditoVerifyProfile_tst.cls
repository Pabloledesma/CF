@isTest
private class SolicitudCreditoVerifyProfile_tst {

    static testMethod void myUnitTest() 
    {
       SolicitudCreditoVerifyProfile classSolicitudCreditoVerifyProfile= new SolicitudCreditoVerifyProfile();

       Controldeestados__c controlador = new Controldeestados__c();
       controlador.Name ='nombre1';
       controlador.Estado_2__c ='Archivo riesgos';
       controlador.Estado_1__c ='Comité de crédito';
       controlador.Perfil__c ='Coordinadora de Riesgo y Crédito,Analista de Crédito,Administrador del sistema';
       insert controlador;

        Opportunity opp = new Opportunity();
        opp.Resultado_del_Prevalidador__c = 'VIABLE';
        opp.Name = 'prueba';
        opp.StageName = 'Abierta';
        opp.CloseDate = Date.newInstance(2050,1,1);
        insert opp;
        
        Meta__c meta = new Meta__c();
        insert meta;

       Solicitud_de_credito__c objOldSolicitudcredito = new Solicitud_de_credito__c();
       objOldSolicitudcredito.Estado_de_la_solicitud__c ='Comité de crédito';
        objOldSolicitudcredito.Oportunidad__c = opp.Id;
        objOldSolicitudcredito.Meta__c = meta.Id;
       insert objOldSolicitudcredito;

       Solicitud_de_credito__c objNewSolicitudcredito= new Solicitud_de_credito__c();
       objNewSolicitudcredito.Estado_de_la_solicitud__c='Archivo riesgos'; 
        objNewSolicitudcredito.Oportunidad__c = opp.Id;
        objNewSolicitudcredito.Meta__c = meta.Id;
       insert objNewSolicitudcredito;

       classSolicitudCreditoVerifyProfile.verifyProfile(objOldSolicitudcredito,objNewSolicitudcredito);
    }
}