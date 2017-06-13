public class LogDepuracion_cls 
{
    public static void  setLog(Integer intLine,String strApp, String InputStream, String OutputStream, Boolean isOn)
    {
        LogDepuracion__c objLogDepuracion= new LogDepuracion__c();
        objLogDepuracion.InputStream__c=InputStream;
        objLogDepuracion.OutputStream__c=OutputStream;
        objLogDepuracion.Aplicacion__c=strApp;
        System.Debug('LogDepuracion_cls: DebugLine '+intLine+' : '+strApp+': \n\nInputStream: '+ InputStream+'\n\n OutputStream: '+OutputStream);
        if(isOn&&LogErrores__c.GetInstance('MasterControl')<>null&&LogErrores__c.GetInstance('MasterControl').parametro1__c=='true')
        {
            if(LogErrores__c.GetInstance(strApp)!=null&&LogErrores__c.GetInstance(strApp).parametro1__c=='true')
            {
              database.insert(objLogDepuracion,false);
            }
        }
    }
    public static void  setLogList(List<LogDepuracion_cls.logWrap> lstlogWrap)
    {
        List<LogDepuracion__c> lstLogDepuracion= new List<LogDepuracion__c>();
        
        for(LogDepuracion_cls.logWrap objLogDepuracion: lstlogWrap)
        {
            LogDepuracion__c objLogDepuracion1= new LogDepuracion__c();
	        objLogDepuracion1.InputStream__c=objLogDepuracion.InputStream;
	        objLogDepuracion1.OutputStream__c=objLogDepuracion.OutputStream;
	        objLogDepuracion1.Aplicacion__c=objLogDepuracion.strApp;
	        
	        System.Debug('LogDepuracion_cls: DebugLine '+objLogDepuracion.intLine+' : '+objLogDepuracion.strApp+': \n\nInputStream: '
	        + objLogDepuracion.InputStream+'\n\n OutputStream: '+objLogDepuracion.OutputStream);
	        if(objLogDepuracion.isOn&&LogErrores__c.GetInstance('MasterControl').parametro1__c=='true')
	        {
	            if(LogErrores__c.GetInstance(objLogDepuracion.strApp)!=null&&LogErrores__c.GetInstance(objLogDepuracion.strApp).parametro1__c=='true')
	            {
	               lstLogDepuracion.add(objLogDepuracion1);
	            }
	        }
        }
        
        database.insert(lstLogDepuracion,false);
        
    }
    public static logWrap  setWrap(Integer intLine,String strApp, String InputStream, String OutputStream, Boolean isOn)
    {
        LogDepuracion_cls.logWrap response= new LogDepuracion_cls.logWrap();
        response.intLine=intLine;
        response.strApp=strApp;
        response.InputStream=InputStream;
        response.OutputStream=OutputStream;
        response.isOn=isOn;
        return response;
    }
    public class logWrap
    {
        public Integer intLine{get;set;}
        public String strApp{get;set;}
        public String InputStream{get;set;}
        public String OutputStream{get;set;}
        public Boolean isOn{get;set;}
    }
}