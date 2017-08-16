public class UpdateFromParent 
 {
     public UpdateFromParent()
     {
       
     }
     
     public void setRegister(sObject sobjOrigen,String strNameOfTheObject) 
     {
       List<Actualizacion_masiva_de_registros__c> lstActualizacionmasivaderegistros=[SELECT Campo_destino__c,Campo_Id__c,Campo_origen__c,
                                          CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                          Name,Objeto_destino__c,Objeto_origen__c,SetupOwnerId 
                                          FROM Actualizacion_masiva_de_registros__c
                                          where Objeto_destino__c=:strNameOfTheObject];
          String strQuery='Select ',strId='';
          Boolean blnFirst=false;
          List<sObject> lstParent= new List<sObject>();
        if(!lstActualizacionmasivaderegistros.isEmpty()){
          
          for(Actualizacion_masiva_de_registros__c objActualizacion_masiva:lstActualizacionmasivaderegistros)
          {
             if(blnFirst)
             {
                 strQuery += ',';
             }
             else
             {
                 blnFirst=true;
             }
             strQuery += objActualizacion_masiva.Campo_origen__c;
          }
         
             //system.Debug('DebugLine31: 'strQuery':>>> : 'lstActualizacionmasivaderegistros[0].Campo_Id__c
             //               ': sobjOrigen:'sobjOrigen);
            strId=''+sobjOrigen.get(lstActualizacionmasivaderegistros[0].Campo_Id__c);
            strQuery+=' from '+lstActualizacionmasivaderegistros[0].Objeto_origen__c+
                 ' where Id=\''+strId+'\' limit 1';
             
         
         system.Debug('UpdateFromParent->strQuery: ' + strQuery);
         
         
         if(strId<>'null'&&strId<>null)
         {
            lstParent=Database.query(strQuery);
         }
        }
   
       if(lstParent.size()==1)
       {
            for(Actualizacion_masiva_de_registros__c objActualizacion_masiva:lstActualizacionmasivaderegistros)
            {
               sobjOrigen.put(objActualizacion_masiva.Campo_destino__c,lstParent[0].get(objActualizacion_masiva.Campo_origen__c));
            }
       }
     }
 }