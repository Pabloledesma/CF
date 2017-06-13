@RestResource(urlMapping='/Lead/*')
global with sharing class ConversionAutomatica {            

@HttpGet
global static String doGet() {
    String ret = 'fail';
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);              
    Database.LeadConvert lc = new Database.LeadConvert();
    lc.setLeadId(leadId);

    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);      
    lc.setOpportunityName('Credito hipotecario');
    Database.LeadConvertResult lcr ;
    try{
        lcr = Database.convertLead(lc);
        system.debug('*****lcr.isSuccess()'+lcr.isSuccess());            
        ret = 'ok';
    }
    catch(exception ex){
        system.debug('***NOT CONVERTED**');           
    }
    return ret;
}
}