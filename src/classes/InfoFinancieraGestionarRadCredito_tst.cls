/**
* Avanxo Colombia
* @author           Raul Mora
* Proyect:          Credifamilia.
* Description:      Test class for InfoFinancieraGestionarRadCredito_Ctrl.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version   1.0    2015-11-25      Raul Mora (RM)                  Create class.
*************************************************************************************************************/
@isTest
private class InfoFinancieraGestionarRadCredito_tst 
{
    
    public Informacion_financiera__c createData()
    {
        Actualizacionderegistros__c objConfPer = new Actualizacionderegistros__c();
        objConfPer.Objeto_origen__c = 'Informacion_financiera__c';
        objConfPer.Objeto_destino__c = 'Radicacion_de_credito__c';
        objConfPer.Campo_origen__c = 'Fecha_analisis__c';
        objConfPer.Campo_destino__c = 'Fecha_analisis__c';
        objConfPer.Campo_llave__c = 'Radicacion_de_credito__c';
        objConfPer.Name = 'Test';
        insert objConfPer;
        
        LogErrores__c objLgErr = new LogErrores__c();
        objLgErr.Name = 'MasterControl';
        objLgErr.parametro1__c = 'Test';
        insert objLgErr;
        
        Actualizacion_masiva_de_registros__c objActMasReg = new Actualizacion_masiva_de_registros__c();
        objActMasReg.Name = 'Test';
        objActMasReg.Campo_origen__c = 'Fecha_analisis__c';
        objActMasReg.Campo_Id__c = 'Radicacion_de_credito__c';
        objActMasReg.Objeto_origen__c = 'Radicacion_de_credito__c';
        objActMasReg.Objeto_destino__c = 'Informacion_financiera__c';
        objActMasReg.Campo_destino__c = 'Fecha_analisis__c';
        insert objActMasReg;
        
        Radicacion_de_credito__c objRadicacion_de_credito= new Radicacion_de_credito__c();
        objRadicacion_de_credito.Telefono_parentesco_familiar__c='46554';
        objRadicacion_de_credito.Telefono_oficina__c='46554';
        objRadicacion_de_credito.Telefono_parentesco_personal__c='46554';
        insert objRadicacion_de_credito;
        
        Informacion_financiera__c objInfoFin = new Informacion_financiera__c();
        objInfoFin.Radicacion_de_credito__c = objRadicacion_de_credito.Id;
        insert objInfoFin;
        
        return objInfoFin;
    }
    
    static testMethod void myUnitTest() 
    {
        InfoFinancieraGestionarRadCredito_tst tstClass = new InfoFinancieraGestionarRadCredito_tst();
        Test.startTest();
            InfoFinancieraGestionarRadCredito_Ctrl ctrClass = new InfoFinancieraGestionarRadCredito_Ctrl( new ApexPages.StandardController( tstClass.createData() ) );
            ctrClass.StartProcess();
        Test.stopTest();
    }
    
}