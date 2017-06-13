@isTest(SeeAllData=true)
private class LogDepuracion_test {

    static testMethod void myUnitTest() 
    {
        LogErrores__c objLogErrores= new LogErrores__c(Name='MasterControl1',parametro1__c='true');
        insert objLogErrores;
        objLogErrores= new LogErrores__c(Name='MasterControl2',parametro1__c='true');
        insert objLogErrores;
        LogDepuracion_cls.setLog(22, 'MasterControl', '', '',true);
        LogDepuracion_cls.logWrap objWrap= new LogDepuracion_cls.logWrap();
        objWrap.intLine=22;
        objWrap.strApp='hjgj';
        objWrap.InputStream='hjgj';
        objWrap.OutputStream='hjgj';
        objWrap.isOn=true;
        List<LogDepuracion_cls.logWrap> lstlogWrap = new List<LogDepuracion_cls.logWrap>();
        lstlogWrap.add(objWrap);
        LogDepuracion_cls.setWrap(22,'ddsdf','ddsdf','ddsdf',true);
        LogDepuracion_cls.setLogList(lstlogWrap); 
    }
}