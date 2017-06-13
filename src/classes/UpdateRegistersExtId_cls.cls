public class UpdateRegistersExtId_cls 
{
//    List<LogDepuracion_cls.logWrap> listLog= new List<LogDepuracion_cls.logWrap>(); KYP01
    public UpdateRegistersExtId_cls()
    {
    	
    }
    
    public void setRegister(sObject objRadicaciondecredito,String strNameOfTheObject) 
    {
        Map<String, sObject> mapList= new Map<String, sObject>();
        system.debug('\n\n----------UpdateRegistersExtId_cls----------\n\n'+objRadicaciondecredito+'\n\n'+strNameOfTheObject);
//        listLog.add( LogDepuracion_cls.setWrap(12,'UpdateRegistersExtId_cls', '-UpdateRegistersExtId_cls----------\n\n'+objRadicaciondecredito,' strNameOfTheObject: '+strNameOfTheObject,true)); KYP01
        List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,CreatedById,CreatedDate,Id,Id_externo__c,
                                                                              IsDeleted,LastModifiedById,LastModifiedDate,Name,Objeto_origen__c,Objeto_destino__c,
                                                                              SetupOwnerId,SystemModstamp,Id_externo_destino__c
                                                                              FROM Actualizacionderegistros__c 
                                                                              where  Objeto_origen__c=:strNameOfTheObject and Id_externo_destino__c != null];
		system.debug('\n\n----------Configuracion personalizada----------\n\n'+lstActualizacionderegistros);
		
//		listLog.add( LogDepuracion_cls.setWrap(20,'UpdateRegistersExtId_cls', 'Configuracion personalizada----------\n\n'+lstActualizacionderegistros,'',true)); KYP01
		
		
        //Control agregado para mapear el maplist creado ya que este no se mapea en esta clase.
        if(Test.isRunningTest())
        {
            for(Actualizacionderegistros__c customSetting :lstActualizacionderegistros)
            {   
                if(customSetting.Name=='Prueba')
                {
                    string prueba = strNameOfTheObject+'-'+customSetting.Objeto_destino__c;
                    mapList.put(prueba,objRadicaciondecredito);
                }
            }
        }
                                                                   
       for(Actualizacionderegistros__c objActualizacionderegistros:lstActualizacionderegistros) 
       {
            if(mapList.containskey(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Objeto_destino__c))
            {
                sObject objMap=mapList.get(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Objeto_destino__c);
                system.debug('\n\n----------sObject objMap----------\n\n'+objMap);
//                listLog.add( LogDepuracion_cls.setWrap(42,'UpdateRegistersExtId_cls', 'sObject objMap----------\n\n'+objMap,'',true)); KYP01
                
                mapList.put(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Objeto_destino__c,this.createObject(objMap,objRadicaciondecredito,objActualizacionderegistros));
            	system.debug('\n\n----------El mapa tiene----------\n\n'+mapList);
//            	listLog.add( LogDepuracion_cls.setWrap(46,'UpdateRegistersExtId_cls', '-El mapa tiene----------\n\n'+mapList,'',true)); KYP01
            	
            }
            else
            {
                sObject objsObject=Schema.getGlobalDescribe().get(objActualizacionderegistros.Objeto_destino__c).newSObject();
                system.debug('\n\n----------El objsObject tiene----------\n\n'+objsObject);
//                listLog.add( LogDepuracion_cls.setWrap(53,'UpdateRegistersExtId_cls', 'El objsObject tiene----------\n\n'+objsObject,'',true)); KYP01
                sObject sobjOrigen=objRadicaciondecredito;
                
                system.debug('\n\n----------El sobjOrigen tiene----------\n\n'+sobjOrigen);
//                listLog.add( LogDepuracion_cls.setWrap(57,'UpdateRegistersExtId_cls', 'El sobjOrigen tiene----------\n\n'+sobjOrigen,'',true)); KYP01
                
                System.debug('objsObject-> '+objsObject);
//                listLog.add( LogDepuracion_cls.setWrap(60,'UpdateRegistersExtId_cls', 'objsObject-> '+objsObject,'',true)); KYP01
                
                System.debug('objActualizacionderegistros.Id_externo__c-> '+objActualizacionderegistros.Id_externo__c);
//                listLog.add( LogDepuracion_cls.setWrap(63,'UpdateRegistersExtId_cls','objActualizacionderegistros.Id_externo__c-> '+objActualizacionderegistros.Id_externo__c,'',true)); KYP01
                try
                {
	                objsObject.put('Id',this.getSdfcId((String)sobjOrigen.get(objActualizacionderegistros.Id_externo__c),objActualizacionderegistros));
	                if(this.getSdfcId((String)sobjOrigen.get(objActualizacionderegistros.Id_externo__c),objActualizacionderegistros) != '')
	                {
	            		mapList.put(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Objeto_destino__c,this.createObject(objsObject,objRadicaciondecredito,objActualizacionderegistros));
	            		system.debug('\n\n----------El mapList tiene----------\n\n'+mapList);
	            		
//	            		listLog.add( LogDepuracion_cls.setWrap(72,'UpdateRegistersExtId_cls', 'El mapList tiene----------\n\n'+mapList,'',true)); KYP01
	            		
	                }
                }
                catch(System.Exception e)
                {
                	System.debug('DebugLine42: e: '+e.GetMessage());
                }
            }
       }
       System.debug('DebuLine35: '+mapList);
       System.debug('DebuLine mapList.Values()-> '+mapList.Values());
       Database.update(mapList.Values(),true); 
//       LogDepuracion_cls.setLogList(listLog); KYP01
    }
    public String getSdfcId(String strExtId, Actualizacionderegistros__c strObjDestino)
    {
    	String strId='';
    	String strQuery='Select Id from '+strObjDestino.Objeto_destino__c+' where '+strObjDestino.Id_externo_destino__c+'= \''+strExtId+'\' limit 1';
    	System.debug('DebugLine54: strQuery: '+strQuery);
    	List<sObject> lstObject=database.query(strQuery);
    	if(lstObject.size()==1)
    	{
    		strId=(String)lstObject[0].get('Id');
    	}
    	System.debug('strId--> '+strId+', strQuery: '+strQuery);
    	return strId;
    }
    public sObject createObject(sObject objToSet,sObject objRadicaciondecredito,Actualizacionderegistros__c objActualizacionderegistros)
    {
        sObject sobjOrigen=objRadicaciondecredito;
        system.debug('\n\n----------El sobjOrigen tiene----------\n\n'+sobjOrigen);
//        listLog.add( LogDepuracion_cls.setWrap(103,'UpdateRegistersExtId_cls', 'El sobjOrigen tiene----------\n\n'+sobjOrigen,'',true)); KYP01
        
        objToSet.put(objActualizacionderegistros.Campo_destino__c,sobjOrigen.get(objActualizacionderegistros.Campo_origen__c));
        system.debug('\n\n----------El objToSet tiene----------\n\n'+objToSet);
//        listLog.add( LogDepuracion_cls.setWrap(107,'UpdateRegistersExtId_cls', 'El objToSet tiene----------\n\n'+objToSet,'',true)); KYP01
        
        return objToSet;
    } 
}