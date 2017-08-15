public class AccountUpdateField_cls 
 {
     public AccountUpdateField_cls()
     {
         
     }
     
     public static void setAccountUpdate(List<Account> lstAcc)
     {
         
         //System.debug('Debuline 11: lstAccsize: 'lstAcc.size()', lstAcc: 'lstAcc);
         List<Account> lstcodeudores= new List<Account>();
         Set<String> stIds= new Set<String>();
         Map<String,Account> mpAcc= new Map<String,Account>();
         for(Account objAccount:lstAcc)
         {
             mpAcc.put(objAccount.Id,objAccount);
         }
         for(Account objAccount:lstAcc)
         {
           //System.debug('1');
             
             if(objAccount.RecordTypeId==Label.AccountRecordTypeId && !stIds.contains(objAccount.Cliente_deudor__c))
             {
               //System.debug('3');
                 stIds.add(objAccount.Cliente_deudor__c);
                 if(!mpAcc.containsKey(objAccount.Cliente_deudor__c))
                 {
                   //System.debug('4');
                     Account objAcc= new Account(Id=objAccount.Cliente_deudor__c,Valida_aporta_ingresos__c=objAccount.Aporta_ingresos__c);
                     lstcodeudores.add(objAcc);
                 }
                 else
                 {
                   //System.debug('5');
                     mpAcc.get(objAccount.Cliente_deudor__c).Valida_aporta_ingresos__c=objAccount.Aporta_ingresos__c;
                 }
                 
             }
         }
         //System.debug('Debuline 24: lstcodeudores: 'lstcodeudores);
         update lstcodeudores;
     }
     
 }