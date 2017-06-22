@isTest
public class TestDataFactory {
	
	public static Lead createLead() {
		Lead lead = new Lead(
			FirstName = 'TestName',
			LastName = 'Test',
			Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
			Email = 'test@test.com',
            Tipo_de_documento__c = 'Cédula ciudadanía',
            Phone = '1234567',
            Telefono_Actividad_Economica__c = '123456789',
            Telefono_referencia_familiar__c = '12345678',
            Telefono_referencia_personal__c = '12345678'
		);
		
		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return lead;
	}

	public static Lead createLead(String tipoDeProducto) {
		Lead lead = new Lead(
			FirstName = 'TestName',
			LastName = 'Test',
			Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
			Email = 'test@test.com',
            Tipo_de_documento__c = 'Cédula ciudadanía',
            Phone = '1234567',
            Telefono_Actividad_Economica__c = '123456789',
            Telefono_referencia_familiar__c = '12345678',
            Telefono_referencia_personal__c = '12345678',
            Tipo_de_producto_que_le_interesa__c = tipoDeProducto
		);
		
		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return lead;
	}
	
	public static Id createCodeudor(Id leadId) {
 
		Codeudor__c cod = new Codeudor__c(
			Name = 'CodeudorTest',
			Apellidos__c = 'Test',
			Candidato__c = leadId,
			Numero_de_documento__c = String.valueOf(Crypto.getRandomInteger()).substring(0,8)
		); 

		Database.SaveResult result = Database.insert(cod, false);
		if(result.isSuccess()){
			return result.getId();
		} else {
			System.debug('Errores al insertar el codeudor: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
			return null;
		}
	}

	public static Id createCodeudor(Id leadId, String numeroDeDocumento) {
		Codeudor__c cod = new Codeudor__c(
			Name = 'CodeudorTest',
			Apellidos__c = 'Test',
			Candidato__c = leadId,
			Numero_de_documento__c = numeroDeDocumento
		);

		Database.SaveResult result = Database.insert(cod, false);
		
		if(result.isSuccess()){
           return result.getId();
		} else {
			 System.debug('Errores al insertar el codeudor: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
			return null;
		}
	}
	

	public static Id createAccount(Id recordTypeId, String numeroDeDocumento){
		Account acc = new Account(
			RecordTypeId = recordTypeId,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Tipo_de_documento__c = 'Cédula ciudadanía',
			Numero_de_documento__c = numeroDeDocumento,
			Sexo__c = 'Femenino',
			Estado_civil__c = 'Soltero',
			Fecha_de_expedicion_cc__c = Date.newInstance(2016, 2, 2),
			Fecha_de_nacimiento__c = Date.newInstance(1983, 5, 24),
			Lugar_de_expedicion__c = 'Bogotá',
			Lugar_de_nacimiento__c = 'Popayán',
			Ciudad_de_residencia__c = 'Bogotá',
			Ciudad_de_radicacion__c = 'Bogotá',
			Numero_de_telefono_celular__c = '3134665665',
			Correo_electronico_1__c = 'test@test.com',
			Tipo_de_ocupacion__c = 'Empleado',
			Aporta_ingresos__c = 'No',
			Estado_del_cliente__c = 'Prospecto'
		);
		Database.SaveResult result = Database.insert(acc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la cuenta: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return acc.Id;
	}

	public static Id createAccount(Id recordTypeId, Id clienteDeudorId, String numeroDeDocumento){
		Account acc = new Account(
			RecordTypeId = recordTypeId,
			Cliente_deudor__c = clienteDeudorId,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Tipo_de_documento__c = 'Cédula ciudadanía',
			Numero_de_documento__c = numeroDeDocumento,
			Sexo__c = 'Femenino',
			Estado_civil__c = 'Soltero',
			Fecha_de_expedicion_cc__c = Date.newInstance(2016, 2, 2),
			Fecha_de_nacimiento__c = Date.newInstance(1983, 5, 24),
			Lugar_de_expedicion__c = 'Bogotá',
			Lugar_de_nacimiento__c = 'Popayán',
			Ciudad_de_residencia__c = 'Bogotá',
			Ciudad_de_radicacion__c = 'Bogotá',
			Numero_de_telefono_celular__c = '3134665665',
			Correo_electronico_1__c = 'test@test.com',
			Tipo_de_ocupacion__c = 'Empleado',
			Aporta_ingresos__c = 'No',
			Estado_del_cliente__c = 'Prospecto'
		);

		Database.SaveResult result = Database.insert(acc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la cuenta: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return acc.Id;
	}

	public static Database.LeadConvertResult leadConversion(Id leadId){
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(leadId);

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);

		Database.LeadConvertResult lcr = Database.convertLead(lc);
		return lcr;
	}

	public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
	
}