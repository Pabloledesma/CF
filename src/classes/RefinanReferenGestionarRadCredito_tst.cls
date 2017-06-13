/**
* Avanxo Colombia
* @author           Raul Mora
* Proyect:          Credifamilia.
* Description:      Test class for RefinanReferenGestionarRadCredito_ctr.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version   1.0    2015-11-25      Raul Mora (RM)                  Create class.
*************************************************************************************************************/
@isTest
private class RefinanReferenGestionarRadCredito_tst 
{
    public Referenciacion_y_verificacion__c createData()
    {
        Actualizacionderegistros__c objConfPer = new Actualizacionderegistros__c();
        objConfPer.Objeto_origen__c = 'Referenciacion_y_verificacion__c';
        objConfPer.Objeto_destino__c = 'Radicacion_de_credito__c';
        objConfPer.Campo_origen__c = 'Cargo_deudor__c';
        objConfPer.Campo_destino__c = 'Cargo_deudor__c';
        objConfPer.Campo_llave__c = 'Radicacion_de_credito__c';
        objConfPer.Name = 'Test';
        insert objConfPer;
        
        LogErrores__c objLgErr = new LogErrores__c();
        objLgErr.Name = 'MasterControl';
        objLgErr.parametro1__c = 'Test';
        insert objLgErr;
        
        Actualizacion_masiva_de_registros__c objActMasReg = new Actualizacion_masiva_de_registros__c();
        objActMasReg.Name = 'Test';
        objActMasReg.Campo_origen__c = 'Cargo_deudor__c';
        objActMasReg.Campo_Id__c = 'Radicacion_de_credito__c';
        objActMasReg.Objeto_origen__c = 'Radicacion_de_credito__c';
        objActMasReg.Objeto_destino__c = 'Referenciacion_y_verificacion__c';
        objActMasReg.Campo_destino__c = 'Cargo_deudor__c';
        insert objActMasReg;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        insert objRadicacion_de_credito;
        
        Referenciacion_y_verificacion__c objRefVer = new Referenciacion_y_verificacion__c();
        objRefVer.Radicacion_de_credito__c = objRadicacion_de_credito.Id;
        insert objRefVer;
        
        return objRefVer;
    }

    static testMethod void myUnitTest() 
    {
        RefinanReferenGestionarRadCredito_tst tstClass = new RefinanReferenGestionarRadCredito_tst();
        Test.startTest();
            RefinanReferenGestionarRadCredito_ctr ctrClass = new RefinanReferenGestionarRadCredito_ctr( new ApexPages.StandardController( tstClass.createData() ) );
            ctrClass.StartProcess();
        Test.stopTest();
    }
    
}