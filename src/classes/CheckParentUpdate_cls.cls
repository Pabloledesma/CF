/**************************************************************************************************************
* Avanxo 
* @author           Luis Arismendy href = larismendy@avanxo.com
* Proyect:          Credifamilia
* Description:      Permite revisar si el objeto indicado sincronizo datos a su padre
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    23/11/2015      Luis Arismendy            Class created
/*************************************************************************************************************/

public class CheckParentUpdate_cls 
{
	public Boolean blnIsUpdated;
	public sObject sobjOrigen;
	public String strObjOrigen;
	public String strObjDestino;
//	List<LogDepuracion_cls.logWrap> listLog= new List<LogDepuracion_cls.logWrap>(); KYP01
	
	public CheckParentUpdate_cls(sObject sobjOrigenTmp,String strObjOrigenTmp, String strObjDestinoTmp)
    {
    	sobjOrigen = sobjOrigenTmp;
    	strObjOrigen = strObjOrigenTmp;
    	strObjDestino = strObjDestinoTmp;
    	
    	system.Debug('\n\nId Origen --> ' + sobjOrigen.get('id'));
    	system.Debug('\n\nObjeto Origen --> ' + strObjOrigen);
    	system.Debug('\n\nObjeto Destino --> ' + strObjDestino);

/* KYP01
        listLog.add( LogDepuracion_cls.setWrap(32,'CheckParentUpdate_cls', 'Id Origen --> ' + sobjOrigen.get('id'),'',true));
        listLog.add( LogDepuracion_cls.setWrap(33,'CheckParentUpdate_cls', 'Objeto Origen --> ' + strObjOrigen,'',true));
        listLog.add( LogDepuracion_cls.setWrap(34,'CheckParentUpdate_cls', 'Objeto Destino --> ' + strObjDestino,'',true));
*/        

    	blnIsUpdated = true;
        Map<String, sObject> mapList= new Map<String, sObject>();
        
		List<Actualizacionderegistros__c> lstActualizacionderegistros=[SELECT Campo_destino__c,Campo_llave__c,Campo_origen__c,Id,Id_externo__c,
                                                                              IsDeleted,Name,Objeto_destino__c,Objeto_origen__c,
                                                                              SetupOwnerId,SystemModstamp FROM Actualizacionderegistros__c 
                                                                              where  Objeto_origen__c=:strObjOrigen and Objeto_destino__c = :strObjDestino];
       
		system.debug('\n\n---------- Configuracion personalizada ----------\n\n'+lstActualizacionderegistros);                                                                      
//		LogDepuracion_cls.setLog(18,'UpdateRegistersLookUp_cls', '	 personalizada ----------\n\n'+lstActualizacionderegistros,'',true); KYP01
		String strQuery='SELECT Id ';
        
		sObject objDestinoTmp = Schema.getGlobalDescribe().get(strObjDestino).newSObject();
		for(Actualizacionderegistros__c objActualizacionderegistros : lstActualizacionderegistros)
		{
			try
			{
				// Permite revisar si los campos indicados existen en los objetos indicados
				sobjOrigen.get(lstActualizacionderegistros[0].Campo_origen__c);
				objDestinoTmp.get(lstActualizacionderegistros[0].Campo_destino__c);
				// FIN - Permite revisar si los campos indicados existen en los objetos indicados
				
				strQuery+=', ';
				strQuery+=objActualizacionderegistros.Campo_destino__c;
			}
			catch(exception e)
			{	
				// Se imprime error si alguno de los campos indicados no existe en los objetos indicados
				system.debug('\nError --> ' + e.getmessage());
//				LogDepuracion_cls.setLog(18,'CheckParentUpdate_cls', 'Error --> ' + e.getmessage(),'',true); KYP01
			}
		}
		
		strQuery+=' FROM '+ strObjDestino + ' WHERE Id=\''+ sobjOrigen.get(lstActualizacionderegistros[0].Campo_llave__c) +'\' LIMIT 1';
		
    	system.Debug('\n\nQuery Select Objeto Destino --> ' + strQuery);
//    	listLog.add( LogDepuracion_cls.setWrap(72,'CheckParentUpdate_cls', 'Query Select Objeto Destino --> ' + strQuery,'',true)); KYP01
    	List<sObject> lstObjetoDestino = Database.query(strQuery);
    	
    	if(!lstObjetoDestino.IsEmpty())
    	{
    		sObject sobjDestino = lstObjetoDestino[0];
     		system.Debug('\n\nlstObjetoDestino ENTRO --> ' + sobjDestino);
//     		listLog.add( LogDepuracion_cls.setWrap(79,'CheckParentUpdate_cls', 'lstObjetoDestino ENTRO --> ' + sobjDestino,'',true)); KYP01
    		for(Actualizacionderegistros__c objActualizacionderegistros : lstActualizacionderegistros)
            {
				system.Debug('\n\nCampo Origen --> ' + objActualizacionderegistros.Campo_origen__c);
				system.Debug('Campo Origen --> ' + sobjOrigen.get(objActualizacionderegistros.Campo_origen__c));
				system.Debug('\n\nCampo Destino --> ' + objActualizacionderegistros.Campo_destino__c);
				system.Debug('Campo Destino --> ' + sobjDestino.get(objActualizacionderegistros.Campo_destino__c));
				
/* KYP01
				listLog.add( LogDepuracion_cls.setWrap(87,'CheckParentUpdate_cls', 'Campo Origen --> ' + objActualizacionderegistros.Campo_origen__c,'',true));
				listLog.add( LogDepuracion_cls.setWrap(88,'CheckParentUpdate_cls', 'Campo Origen --> ' + sobjOrigen.get(objActualizacionderegistros.Campo_origen__c),'',true));
				listLog.add( LogDepuracion_cls.setWrap(89,'CheckParentUpdate_cls', 'Campo Destino --> ' + objActualizacionderegistros.Campo_destino__c,'',true));
				listLog.add( LogDepuracion_cls.setWrap(90,'CheckParentUpdate_cls', 'Campo Destino --> ' + sobjDestino.get(objActualizacionderegistros.Campo_destino__c),'',true));
*/				
               	if(sobjOrigen.get(objActualizacionderegistros.Campo_origen__c) != sobjDestino.get(objActualizacionderegistros.Campo_destino__c))
            	{
            		blnIsUpdated = false;
            		break;
            	}
            }
    	}
    	
    	system.Debug('\n\nEsta el objeto Actualizado --> ' + blnIsUpdated);
/* KYP01
    	listLog.add( LogDepuracion_cls.setWrap(90,'CheckParentUpdate_cls', 'Esta el objeto Actualizado --> ' + blnIsUpdated,'',true));
    	LogDepuracion_cls.setLogList(listLog);
*/    	
	}
	
	public Boolean CheckUpdate()
	{
		if(!blnIsUpdated)
		{
			UpdateRegistersLookUp_cls classUpdateRegistersLookUp= new UpdateRegistersLookUp_cls();
			classUpdateRegistersLookUp.setRegister(sobjOrigen, strObjOrigen);
		}
		return blnIsUpdated;
	}
}