trigger ConteoLeads on Lead (Before Update, Before Insert) {
 for(Lead l:Trigger.New){
  String Consulta = 'VIABLE';
  Integer asigna;
  Integer nleads = database.countQuery('SELECT COUNT() FROM Lead WHERE Concepto_del_candidato__c=: Consulta');

  
  if(Trigger.isUpdate && l.Concepto_del_candidato__c=='VIABLE'){
   l.Conteo__c = nleads;
   asigna = math.mod(nleads,11)+1;
   l.Numero_de_asignacion__c=asigna;
  }else if(Trigger.isInsert && l.Concepto_del_candidato__c=='VIABLE'){
   l.Conteo__c = nleads;
   asigna = math.mod(nleads,11)+1;
   l.Numero_de_asignacion__c=asigna;
  }
 }
} 