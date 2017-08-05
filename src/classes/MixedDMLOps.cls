/**
* Handles mixed dml situations in code. It runs the DML operation in different context for Test code only, so that conflict between DML on setup and non-setup object is gone.
*
* PLEASE NOTE:
* ============
* methods are not named as delete, insert because they are reserved words by Apex
*/
public without sharing class MixedDMLOps {
  // DML UPDATE operation 
  public static Database.SaveResult[] up (Sobject[] objs) {
    Database.Saveresult[] updateRes;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          updateRes = database.update(objs);
          }
        } else {
        updateRes = database.update(objs);
        }  
    return updateRes;
  }
  
  // DML DELETE
  public static Database.DeleteResult[] del (Sobject[] objs) {
    Database.DeleteResult[] delRes;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          delRes = database.delete(objs);
          }
        } else {
        delRes = database.delete(objs);
        }
        System.debug('deleteResults: ' + delRes);  
    return delRes;
  }
  
  
  // DML INSERT
  public static Database.Saveresult[] ins (Sobject[] objs) {
    Database.Saveresult[] res;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          		res = database.insert(objs);
	          for(Database.SaveResult r : res){
		          if(r.isSuccess()){
		          	System.debug('inserted: ' + r.getId());
		          } else {
		          	for(Database.Error error : r.getErrors()){
		          		System.debug(error.getMessage());
		          	}
		          }
	          }
          }
        } else {
        res = database.insert(objs);
        }  
    return res;
  }
  
  
}