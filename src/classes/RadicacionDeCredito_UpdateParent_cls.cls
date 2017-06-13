public class RadicacionDeCredito_UpdateParent_cls 
{
//    List<LogDepuracion_cls.logWrap> listLog= new List<LogDepuracion_cls.logWrap>(); KYP01
    public RadicacionDeCredito_UpdateParent_cls()
    {
    	
    }
    
    public void setRegister(Radicacion_de_credito__c objRadicaciondecredito)
    {
    	system.debug('\n\n----------RadicacionDeCredito_UpdateParent_cls----------\n\n'+objRadicaciondecredito);
//    	listLog.add( LogDepuracion_cls.setWrap(11,'RadicacionDeCredito_UpdateParent_cls', 'RadicacionDeCredito_UpdateParent_cls----------\n\n'+objRadicaciondecredito,'',true)); KYP01
    	
    	Map<String, sObject> mapList= new Map<String, sObject>();
    	
    	List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,CreatedById,CreatedDate,Id,Id_externo__c,
									    	                                  IsDeleted,LastModifiedById,LastModifiedDate,Name,Objeto_destino__c,Objeto_origen__c,
									    	                                  SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
									    	                                  where  Objeto_origen__c='Radicacion_de_credito__c'];
        system.debug('\n\n----------Configuracion personalizada----------\n\n'+lstActualizacionderegistros);	
//        listLog.add( LogDepuracion_cls.setWrap(20,'RadicacionDeCredito_UpdateParent_cls', 'Configuracion personalizada----------\n\n'+lstActualizacionderegistros,'',true)); KYP01
        			    	                                       
       for(Actualizacionderegistros__c objActualizacionderegistros:lstActualizacionderegistros)
       {
       	    if(mapList.containskey(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c))
       	    {
       	    	sObject objMap=mapList.get(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c);
       	    	system.debug('\n\n----------sObject objMap----------\n\n'+objMap);
//       	    	listLog.add( LogDepuracion_cls.setWrap(24,'RadicacionDeCredito_UpdateParent_cls', 'sObject objMap----------\n\n'+objMap,'',true)); KYP01
       	    	
       	    	mapList.put(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c,this.createObject(objMap,objRadicaciondecredito,objActualizacionderegistros));
       	    	system.debug('\n\n----------El mapa tiene----------\n\n'+mapList);
       	    	
//       	    	listLog.add( LogDepuracion_cls.setWrap(29,'RadicacionDeCredito_UpdateParent_cls', '-El mapa tiene----------\n\n'+mapList,'',true)); KYP01
       	    }
       	    else
       	    {
       	    	sObject objsObject=Schema.getGlobalDescribe().get(objActualizacionderegistros.Objeto_destino__c).newSObject();
       	    	system.debug('\n\n----------El objsObject tiene----------\n\n'+objsObject);
//       	    	listLog.add( LogDepuracion_cls.setWrap(35,'RadicacionDeCredito_UpdateParent_cls', 'El objsObject tiene----------\n\n'+objsObject,'',true)); KYP01
       	    	
       	    	sObject sobjOrigen=objRadicaciondecredito;  
       	    	system.debug('\n\n----------El sobjOrigen tiene----------\n\n'+sobjOrigen);
//        	    	listLog.add( LogDepuracion_cls.setWrap(39,'RadicacionDeCredito_UpdateParent_cls', 'El sobjOrigen tiene----------\n\n'+sobjOrigen,'',true)); KYP01
       	    	system.debug('\n\n----------objActualizacionderegistros.Campo_llave__c----------\n\n'+sobjOrigen.get(objActualizacionderegistros.Campo_llave__c));
//       	    	listLog.add( LogDepuracion_cls.setWrap(39,'RadicacionDeCredito_UpdateParent_cls', 'EobjActualizacionderegistros.Campo_llave__c----------\n\n'+sobjOrigen.get(objActualizacionderegistros.Campo_llave__c),'',true)); KYP01
       	    	if(sobjOrigen.get(objActualizacionderegistros.Campo_llave__c)<>null)
       	    	{
           	    	objsObject.put('Id',sobjOrigen.get(objActualizacionderegistros.Campo_llave__c));
           	    	mapList.put(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c,this.createObject(objsObject,objRadicaciondecredito,objActualizacionderegistros));
       	    	}
       	    	system.debug('\n\n----------El mapList tiene----------\n\n'+mapList);
//       	    	listLog.add( LogDepuracion_cls.setWrap(44,'RadicacionDeCredito_UpdateParent_cls', 'El mapList tiene----------\n\n'+mapList,'',true)); KYP01
       	    	
       	    }
       }
       System.debug('DebuLine38: '+mapList);
       Database.update(mapList.Values(),true);
//       LogDepuracion_cls.setLogList(listLog); KYP01                                      
    }
    
    public sObject createObject(sObject objToSet,Radicacion_de_credito__c objRadicaciondecredito,Actualizacionderegistros__c objActualizacionderegistros)
    {
    	sObject sobjOrigen=objRadicaciondecredito;
    	system.debug('\n\n----------El sobjOrigen tiene----------\n\n'+sobjOrigen);
//    	listLog.add( LogDepuracion_cls.setWrap(56,'RadicacionDeCredito_UpdateParent_cls', 'El sobjOrigen tiene----------\n\n'+sobjOrigen,'',true)); KYP01
    	
    	objToSet.put(objActualizacionderegistros.Campo_destino__c,sobjOrigen.get(objActualizacionderegistros.Campo_origen__c));
    	system.debug('\n\n----------El objToSet tiene----------\n\n'+objToSet);
//    	listLog.add( LogDepuracion_cls.setWrap(60,'RadicacionDeCredito_UpdateParent_cls', 'El objToSet tiene----------\n\n'+objToSet,'',true)); KYP01
    	
    	return objToSet;
    } 
}