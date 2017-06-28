public class UpdateRegistersLookUp_cls 
{
//    List<LogDepuracion_cls.logWrap> listLog= new List<LogDepuracion_cls.logWrap>(); KYP01
    public UpdateRegistersLookUp_cls()
    {
      
    }
    
    public void setRegister(sObject sobjOrigen,String strNameOfTheObject) 
    {
        Map<String, sObject> mapList= new Map<String, sObject>();
        
        List<Actualizacionderegistros__c> lstActualizacionderegistros=[
          SELECT 
            Campo_destino__c,
            Campo_llave__c,
            Campo_origen__c,
            CreatedById,
            CreatedDate,
            Id,
            Id_externo__c,
            IsDeleted,
            LastModifiedById,
            LastModifiedDate,
            Name,
            Objeto_destino__c,
            Objeto_origen__c,
            SetupOwnerId,
            SystemModstamp 
          FROM Actualizacionderegistros__c 
          where Objeto_origen__c = :strNameOfTheObject and Id_externo_destino__c = null];
       
       //system.debug('\n\n----------Configuracion personalzizada----------\n\n'+lstActualizacionderegistros);                                                                      
//       LogDepuracion_cls.setLog(18,'UpdateRegistersLookUp_cls', 'Configuracion personalzizada----------\n\n'+lstActualizacionderegistros,'',true); KYP01
                                                                       
       for(Actualizacionderegistros__c objActualizacionderegistros:lstActualizacionderegistros)
       {
            if(mapList.containskey(objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c))
            {
                sObject objMap = mapList.get(
                  objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c
                );
                
                mapList.put(
                  objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c,
                  this.createObject(objMap,sobjOrigen,objActualizacionderegistros)
                );
                //system.debug('\n\n----------El map tiene mapList----------\n\n'+mapList);
//               listLog.add( LogDepuracion_cls.setWrap(28,'UpdateRegistersLookUp_cls', 'El map tiene mapList----------\n\n'+mapList,'',true)); KYP01
            }
            else
            {
                sObject objsObject=Schema.getGlobalDescribe().get(objActualizacionderegistros.Objeto_destino__c).newSObject();
                try
                {
                  if(objActualizacionderegistros.Campo_llave__c != null)
                  {
                    objsObject.put('Id',sobjOrigen.get(objActualizacionderegistros.Campo_llave__c));
                   // system.debug('\n\n----------El objeto tiene objsObject----------\n\n'+objsObject);
//                    listLog.add( LogDepuracion_cls.setWrap(39,'UpdateRegistersLookUp_cls', 'El objeto tiene objsObject----------\n\n'+objsObject,'',true)); KYP01
                  }
                  
                  
                  mapList.put(
                    objActualizacionderegistros.Objeto_origen__c+'-'+objActualizacionderegistros.Campo_llave__c,
                    this.createObject(objsObject,sobjOrigen,objActualizacionderegistros)
                  );
                  //system.debug('\n\n----------El mapList tiene mapList----------\n\n'+mapList);
//                  listLog.add( LogDepuracion_cls.setWrap(45,'UpdateRegistersLookUp_cls', 'El mapList tiene mapList----------\n\n'+mapList,'',true)); KYP01
                }
                catch(System.Exception e)
                {
                  System.debug('UpdateRegistersLookup_cls exception: '+e.GetMessage());
                }
            }
       }
        //System.debug('DebuLine34: '+mapList);
        //System.debug('mapList.Values()-->  '+mapList.Values());
      try
      {
       Database.SaveResult[] srList = Database.update(mapList.Values(),true);

        // Iterate through each returned result
         for (Database.SaveResult sr : srList) 
         {
            if (sr.isSuccess()) 
            {
              // Operation was successful, so get the ID of the record that was processed
              System.debug('Successfully inserted account. Account ID: ' + sr.getId());
//              listLog.add( LogDepuracion_cls.setWrap(66,'UpdateRegistersLookUp_cls', 'Successfully inserted account. Account ID: ' + sr.getId(),'',true)); KYP01
            }
            else 
            {
              // Operation failed, so get all errors               
              for(Database.Error err : sr.getErrors()) 
              {
                System.debug('The following error has occurred.');                   
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
/* KYP01                
                listLog.add( LogDepuracion_cls.setWrap(77,'UpdateRegistersLookUp_cls','The following error has occurred.'+ err.getStatusCode() + ': ' + err.getMessage(),'',true));
                listLog.add( LogDepuracion_cls.setWrap(78,'UpdateRegistersLookUp_cls','Account fields that affected this error: ' + err.getFields(),'',true));
*/                
                
              }
            }
         }
      }
     catch(exception e)
     {
      system.debug('getmessage-->' + e.getmessage());
     }
     
//     LogDepuracion_cls.setLogList(listLog); KYP01                                         
    }
    
    public sObject createObject(sObject objToSet,sObject objRadicaciondecredito,Actualizacionderegistros__c objActualizacionderegistros)
    {
        //system.debug('\n\n----------El createObject----------\n\n'+objToSet+'\n\n'+objRadicaciondecredito+'\n\n'+objActualizacionderegistros);
//        listLog.add( LogDepuracion_cls.setWrap(96,'UpdateRegistersLookUp_cls','El createObject----------\n\n'+objToSet+'\n\n'+objRadicaciondecredito+'\n\n'+objActualizacionderegistros,'',true)); KYP01
        
        sObject sobjOrigen=objRadicaciondecredito;
        objToSet.put(objActualizacionderegistros.Campo_destino__c,sobjOrigen.get(objActualizacionderegistros.Campo_origen__c));
        //system.debug('\n\n----------El objToSet devuelto es----------\n\n'+objToSet);
//        listLog.add( LogDepuracion_cls.setWrap(101,'UpdateRegistersLookUp_cls','El objToSet devuelto es----------\n\n'+objToSet,'',true)); KYP01
        
        return objToSet;
    } 
}