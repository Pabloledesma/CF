trigger ConteoLeads on Lead (Before Update, Before Insert) {
 for(Lead l:Trigger.New){
     Integer numAccounts = [select count() from Account where Numero_de_documento__c = :l.Numero_de_identificacion__c];
     if(numAccounts > 0){
         Account acc = [
                 SELECT
                         FirstName,
                         LastName,
                         Ciudad_de_residencia__c,
                         Tipo_de_ocupacion__c,
                         Estado_civil__c,
                         Numero_de_celular_1__c,
                         Phone
                 FROM
                         Account
                 WHERE Numero_de_documento__c = :l.Numero_de_identificacion__c
         ];
     }

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