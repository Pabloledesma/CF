@isTest
public class TestDataFactory {

	public static Lead createRawLead(){
		Lead lead = new Lead(
			FirstName = 'TestName',
			LastName = 'Test',
			Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
			Email = 'test@test.com',
            Phone = '1234567',
            Telefono_Actividad_Economica__c = '123456789',
            Telefono_referencia_familiar__c = '12345678',
            Telefono_referencia_personal__c = '12345678',
            Canal_digital__c = 'Si',
            Concepto_del_candidato__c = 'NO VIABLE'
		);

		return lead;
	}

	public static Id createLead() {
		Lead lead = new Lead(
			FirstName = 'TestName',
			LastName = 'Test',
			Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
			Email = 'test@test.com',
            Phone = '1234567',
            Telefono_Actividad_Economica__c = '123456789',
            Telefono_referencia_familiar__c = '12345678',
            Telefono_referencia_personal__c = '12345678',
            Canal_digital__c = 'Si'
		);
		
		Database.SaveResult result = Database.insert(lead);
		if(result.isSuccess()){
			return result.getId();
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
			return null;
		}
	}

	public static Lead createLead(Id ownerId) {
		Lead lead = new Lead(
				FirstName = 'TestName',
				LastName = 'Test',
				Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
				Email = 'test@test.com',
				Phone = '1234567',
				Telefono_Actividad_Economica__c = '123456789',
				Telefono_referencia_familiar__c = '12345678',
				Telefono_referencia_personal__c = '12345678',
				Canal_digital__c = 'Si',
				OwnerId = ownerId
		);

		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
			return lead;
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
			return null;
		}
	}

	public static Lead createLead(String tipoDeProducto) {
		Lead lead = new Lead(
			FirstName = 'TestName',
			LastName = 'Test',
			Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
			Email = 'test@test.com',
            Phone = '1234567',
            Telefono_Actividad_Economica__c = '123456789',
            Telefono_referencia_familiar__c = '12345678',
            Telefono_referencia_personal__c = '12345678',
            Canal_digital__c = 'Si',
            Tipo_de_producto_que_le_interesa__c = tipoDeProducto
		);
		
		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
			return lead;
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
			return null;
		}
	}

	public static Lead createLeadFullInfo(Id ownerId) {
		Lead lead = new Lead(
				FirstName = 'TestName',
				LastName = 'Test',
				Numero_de_identificacion__c = String.valueOf(Crypto.getRandomInteger()),
				Ciudad_de_residencia__c = 'Bogotá',
				Fecha_de_nacimiento__c = Date.newInstance(1983, 5, 24),
				Lugar_de_nacimiento__c = 'Leticia',
				Fecha_de_expedicion_cc__c = Date.newInstance(2001, 7, 26),
				Lugar_de_expedicion__c = 'Bogotá',
				Profesion_o_Actividad__c = 'Programador',
				Nivel_de_educacion__c = 'Universitario',
				N_mero_de_personas_a_cargo__c = '2',
				Tipo_de_vivienda_residencia__c = 'Hipotecada',
				Antiguedad_en_la_vivienda_actual_en_a_o__c = 2,
				Direccion_residencia__c = 'carrera 2 2 2',
				Estrato__c = '3',
				Email = 'test@test.com',
				Phone = '1234567',
				Telefono_Actividad_Economica__c = '123456789',
				Telefono_referencia_familiar__c = '12345678',
				Telefono_referencia_personal__c = '12345678',
				Canal_digital__c = 'Si',
				OwnerId = ownerId
				
		);

		Database.SaveResult result = Database.insert(lead, false);
		if(result.isSuccess()){
			lead.Id = result.getId();
			return lead;
		} else {
			System.debug('Errores al insertar el candidato: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
			return lead;
		}
	}

	public static User createUser(Id profileId){
		User u = new User(
			Alias = 'testUser', 
			Email='TESTuSERUNIQUE@testorg.com',
			EmailEncodingKey='ISO-8859-1', 
			LastName='Testing', 
			LanguageLocaleKey='es',
			LocaleSidKey='en_US', 
			ProfileId = profileId,
			TimeZoneSidKey='America/Bogota', 
			UserName='testUserUnique@testorg.com'
		);
		return u;
	}

	public static User createUser(Id profileId, Integer i){
		User u = new User(
			Alias = 'tUser' + i, 
			Email='TESTuSERUNIQUE'+i+'@testorg.com',
			EmailEncodingKey='ISO-8859-1', 
			LastName='Testing', 
			LanguageLocaleKey='es',
			LocaleSidKey='en_US', 
			ProfileId = profileId,
			TimeZoneSidKey='America/Bogota', 
			UserName='testUserUnique'+i+'@testorg.com',
			Habilitado_Canal_Digital__c = true,
			Meta_canal_digital__c = 40,
			Numero_de_candidatos_asignados__c = 0
		);
		return u;
	}

	/** 
	* Crea un registro de codeudor con todos los campos diligenciados 
	*
	* @param i: Identificador único para el codeudor
	* @param leadId: Id del candidato relacionado
	* @return Id
	**/
	public static Codeudor__c createCodeudorFullInfo(String i, Id leadId, String ocupacion)
	{
		Codeudor__c codeudor = new Codeudor__c(
				Name = 'CodeudorTest' + i,
				Apellidos__c = 'Test' + i,
				Candidato__c = leadId,
				Tipo_de_documento__c = 'Cédula ciudadanía',
				Numero_de_documento__c = String.valueOf(Crypto.getRandomInteger()).substring(0,8),
				Ciudad_de_residencia__c = 'Bogotá',
				Ocupacion__c = ocupacion,
				Fecha_de_nacimiento__c = Date.newInstance(1983, 05, 24),
				Lugar_de_nacimiento__c = 'Bogotá',
				Fecha_de_expedicion__c = Date.newInstance(2002,3,25),
				Lugar_de_expedicion__c = 'Bogotá',
				Estado_Civil__c = 'Casado',
				Nivel_de_educaci_n__c = 'Universitario',
				Parentesco_Ref_Familiar__c = 'Tio(a)',
				Telefono_fijo__c = '1234567',
				Numero_de_celular__c = '1234567890',
				Fecha_de_ingreso__c = Date.newInstance(2016,4,4),
				Nombre_entidad_empleadora__c = 'Acme',
				Direccion_de_la_empresa__c = 'Carrera 24 # 35 - 35',
				Experiencia__c = 2, 
				Ciudad_laboral__c = 'Bogotá',
				Cargo_actual__c = 'Analista',
				Telefono_de_la_oficina__c = '1234567',
				Profesion_o_Actividad__c = 'zapatero',
				Familiar_Nombre_y_Apellido__c = 'Nombre y Apellido ref fam' + i,
				Direccion_referencia_familiar_codeudor__c = 'calle 3 # 4 - 5',
				Celular_Ref_Familiar__c = 1234567890,
				Ciudad_Ref_Familiar__c = 'Cartago',
				Personal_Nombre_y_Apellido__c = 'Nombre ref personal' + i,				
				Direccion_referencia_personal_codeudor__c = 'carrera 89 # 56 - 29',
				Celular_Ref_Personal__c = 1234657890,
				Ciudad_Ref_Personal__c = 'Cali',
				Relacion__c = 'Amigo(a)'
		);

		Database.SaveResult result = Database.insert(codeudor, false);
		if(result.isSuccess()){
			codeudor.Id = result.getId();
			return codeudor;
		} else {
			System.debug('Errores al insertar el codeudor: ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
			return null;
		}
	}

	public static Id createCodeudor(Id leadId) {
 
		Codeudor__c cod = new Codeudor__c(
			Name = 'CodeudorTest',
			Apellidos__c = 'Test',
			Candidato__c = leadId,
			Numero_de_documento__c = String.valueOf(Crypto.getRandomInteger()).substring(0,7)
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

	public static Id createAccountForConstructorChanel(Id recordTypeId, String numeroDeDocumento){
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

	public static Database.SaveResult insertSOBject(sObject ob, String nameObject)
	{
		Database.SaveResult result = Database.insert(ob, false);
		if(!result.isSuccess()){
			System.debug('Errores al insertar '+ nameObject +': ');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getStatusCode() + ': ' + error.getMessage());
				System.debug('Verificar los siguientes campos: ' + error.getFields());
			}
		}
		return result;
	}

	public static Account createRawAccount(Id recordTypeId, String numeroDeDocumento)
	{
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
				Canal_digital__c = 'Si',
				Estado_del_cliente__c = 'Prospecto'
		);

		return acc;
	}

	public static Id createAccount(String numeroDeDocumento, Boolean canalDigital){

		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account']; 
		Account acc = new Account(
			RecordTypeId = rt.Id,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Tipo_de_documento__c = 'Cédula ciudadanía',
			Numero_de_documento__c = numeroDeDocumento,
			Sexo__c = 'Femenino',
			Estado_civil__c = 'Soltero',
			Fecha_de_expedicion_cc__c = Date.newInstance(2016, 2, 2),
			Fecha_de_nacimiento__c = Date.newInstance(1983, 5, 24),
			Fecha_de_ingreso_a_empleo_actual__c = Date.newInstance(2016, 2, 2),
			Lugar_de_expedicion__c = 'Bogotá',
			Lugar_de_nacimiento__c = 'Popayán',
			Ciudad_de_residencia__c = 'Bogotá',
			Ciudad_de_radicacion__c = 'Bogotá',
			Numero_de_telefono_celular__c = '3134665665',
			Correo_electronico_1__c = 'test@test.com',
			Tipo_de_ocupacion__c = 'Empleado',
			Tipo_de_contrato__c = 'Término indefinido',
			Personas_a_cargo__c = '1',
			Actividad_economica__c = 'Otra',
			Aporta_ingresos__c = 'No',
			Estado_del_cliente__c = 'Prospecto'
		);

		if(canalDigital){
			acc.Canal_digital__c = 'Si';
		} 

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

	public static Id createAccount(String numeroDeDocumento){

		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account']; 
		Account acc = new Account(
			RecordTypeId = rt.Id,
			LastName = 'TestLastname',
            FirstName = 'TestName',
			Tipo_de_documento__c = 'Cédula ciudadanía',
			Numero_de_documento__c = numeroDeDocumento,
			Sexo__c = 'Femenino',
			Estado_civil__c = 'Soltero',
			Fecha_de_expedicion_cc__c = Date.newInstance(2016, 2, 2),
			Fecha_de_nacimiento__c = Date.newInstance(1983, 5, 24),
			Fecha_de_ingreso_a_empleo_actual__c = Date.newInstance(2016, 2, 2),
			Lugar_de_expedicion__c = 'Bogotá',
			Lugar_de_nacimiento__c = 'Popayán',
			Ciudad_de_residencia__c = 'Bogotá',
			Ciudad_de_radicacion__c = 'Bogotá',
			Numero_de_telefono_celular__c = '3134665665',
			Correo_electronico_1__c = 'test@test.com',
			Tipo_de_ocupacion__c = 'Empleado',
			Tipo_de_contrato__c = 'Término indefinido',
			Personas_a_cargo__c = '1',
			Actividad_economica__c = 'Otra',
			Aporta_ingresos__c = 'No',
			Canal_digital__c = 'Si',
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
			Canal_digital__c = 'Si',
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
			Canal_digital__c = 'Si',
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

	public static Id createPerson(String numDocumento, Id oppId, String tipoDeProducto)
	{
		Persona__c persona = new Persona__c(
			Nombre__c = 'Nombre',
			Apellidos__c = 'Apellidos',
			Tipo_de_documento__c = 'Cédula ciudadanía',
			Numero_de_documento__c = numDocumento,
			Tipo__c = 'Representante Legal',
			Oportunidad__c = oppId,
			Tipo_de_producto_a_adquirir__c = 'CDT',
			Razon_social__c = 'Acme',
			Nit_de_la_entidad__c = '123456789'
		);

		Database.SaveResult result = Database.insert(persona, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la persona: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return persona.Id;
	}

	public static Id createOpportunity(Id deudorId){
		Opportunity op = new Opportunity(
			Name = 'Nombre',
			AccountId = deudorId,
			Tipo_de_producto__c = 'Crédito de vivienda usada',
			Asignacion_de_cupo__c = 'No',
			Tiene_convenio__c = 'No',
			Canal_de_atencion__c = 'Sala de ventas',
			Valor_del_inmueble__c = 200000,
			Amount = 100000000,
			Valor_del_credito__c = 100000000,
			Tipo_de_vivienda__c = 'Vip',
			Numero_de_vivienda__c = '1',
			Ingresos_Familiares__c = 500000,
			CloseDate = Date.newInstance(2200, 2, 2),
			StageName = 'Radicado',
			Excepcion__c = 'No',
	      	Cliente_deudor__c = deudorId
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		//Opportunity opp = [select Amount from Opportunity where Id = :op.Id];
		//System.assertEquals(
		//	100000000,
		//	opp.Amount, 
		//	'El monto de la oportunidad no se está actualizando correctamente'
		//);
		return op.Id;
	}

	public static Id createOpportunity(Id deudorId, String tipoDeProducto){
		Opportunity op = new Opportunity(
			Name = 'Nombre',
			AccountId = deudorId,
			Tipo_de_producto__c = tipoDeProducto,
			Asignacion_de_cupo__c = 'No',
			Tiene_convenio__c = 'No',
			Canal_de_atencion__c = 'Sala de ventas',
			Valor_del_inmueble__c = 200000,
			Amount = 100000,
			Tipo_de_vivienda__c = 'Vip',
			Numero_de_vivienda__c = '1',
			Ingresos_Familiares__c = 500000,
			CloseDate = Date.newInstance(2200, 2, 2),
			StageName = 'Radicado',
			Excepcion__c = 'No',
	      	Cliente_deudor__c = deudorId
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return op.Id;
	}

	public static Id createOpportunity(Id deudorId, Id codeudorId){
		Opportunity op = new Opportunity(
			AccountId = deudorId,
			Name = 'Opp Test',
			StageName = 'Abierta',
			CloseDate = Date.newInstance(2017, 12, 12),
			Codeudor_1__c = codeudorId
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return op.Id;
	}

	public static Id createOpportunity(Id tipoDeRegistro, Id deudorId, String tipoDePersona){
		Opportunity op = new Opportunity(
			RecordTypeId = tipoDeRegistro,
			Name = 'Nombre',
			AccountId = deudorId,
			Tipo_de_persona__c = tipoDePersona,
			Asignacion_de_cupo__c = 'No',
			Tiene_convenio__c = 'No',
			Canal_de_atencion__c = 'Sala de ventas',
			Valor_del_inmueble__c = 200000,
			Amount = 100000,
			Tipo_de_vivienda__c = 'Vip',
			Numero_de_vivienda__c = '1',
			Ingresos_Familiares__c = 500000,
			CloseDate = Date.newInstance(2200, 2, 2),
			StageName = 'Radicado',
			Excepcion__c = 'No',
	      	Cliente_deudor__c = deudorId
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return op.Id;
	}

	public static Id createOpportunity(Id deudorId, Id codeudor1Id, Id codeudor2Id){
		Opportunity op = new Opportunity(
			AccountId = deudorId,
			Name = 'Opp Test',
			StageName = 'Abierta',
			CloseDate = Date.newInstance(2017, 12, 12),
			Codeudor_1__c = codeudor1Id,
			Codeudor_2__c = codeudor2Id
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return op.Id;
	}

	public static Id createOpportunity(Id deudorId, Id codeudor1Id, Id codeudor2Id, Id codeudor3Id){
		Opportunity op = new Opportunity(
			AccountId = deudorId,
			Name = 'Opp Test',
			StageName = 'Abierta',
			CloseDate = Date.newInstance(2017, 12, 12),
			Codeudor_1__c = codeudor1Id,
			Codeudor_2__c = codeudor2Id,
			Codeudor_3__c = codeudor3Id
		);

		Database.SaveResult result = Database.insert(op, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la oportunidad: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return op.Id;
	}

	public static Opportunity createRawOpportunity(Id deudorId)
	{
		Opportunity op = new Opportunity(
			Name = 'Nombre',
			AccountId = deudorId,
			Tipo_de_producto__c = 'Crédito de vivienda usada',
			Asignacion_de_cupo__c = 'No',
			Tiene_convenio__c = 'No',
			Canal_de_atencion__c = 'Sala de ventas',
			Valor_del_inmueble__c = 200000,
			Amount = 100000000,
			Valor_del_credito__c = 100000000,
			Tipo_de_vivienda__c = 'Vip',
			Numero_de_vivienda__c = '1',
			Ingresos_Familiares__c = 500000,
			CloseDate = Date.newInstance(2200, 2, 2),
			StageName = 'Radicado',
			Excepcion__c = 'No',
	      	Cliente_deudor__c = deudorId

		);

		return op;
	}

	public static Id createMeta(){

		Meta__c meta = new Meta__c();
		Database.SaveResult results = Database.insert(meta);

		if(results.isSuccess()){
			//System.debug('Successfully insertion of Meta id: ' + results.getId());
			return results.getId();
		} else {
			for(Database.Error err : results.getErrors()) {
				System.debug('The following error has occurred.');
				System.debug(err.getStatusCode() + ': ' + err.getMessage());
				System.debug('Meta fields that affected this error: ' + err.getFields());
			}

			return null;

		}
	}

	public static Database.LeadConvertResult leadConversion(Id leadId){
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(leadId);

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);

		try {
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			if(lcr.isSuccess()){
				return lcr;
			} else {
				System.debug('Error al convertir el candidato:');
				for(Database.Error error : lcr.getErrors()){
					System.debug(error.getMessage());
				}
				return null;
			}
		} catch (Exception e) {
			System.debug(e.getMessage());
			return null;
		}
	}

	public static Id createReferenciacion(Id idClienteDeudor, List<Id> codeudores){
		Referenciacion_y_verificacion__c rv = new Referenciacion_y_verificacion__c();
		for(Integer i = 0; i<codeudores.size(); i++){
			if(i == 0)
				rv.Codeudor_1__c = codeudores[i];
			if(i == 1)
				rv.Codeudor_2__c = codeudores[i];
			if(i == 2)
				rv.Codeudor_3__c = codeudores[i];
		}

		rv.Cliente_deudor__c = idClienteDeudor;
		Database.SaveResult result = Database.insert(rv, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Radicación de crédito: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
            return null;
		}
		return rv.Id; 
	}

	public static Id createRadicacion(Id idSolicitud, List<Id> codeudores){
		Radicacion_de_credito__c rc = new Radicacion_de_credito__c();
		for(Integer i = 0; i<codeudores.size(); i++){
			if(i == 0)
				rc.Codeudor_1__c = codeudores[i];
			if(i == 1)
				rc.Codeudor_2__c = codeudores[i];
			if(i == 2)
				rc.Codeudor_3__c = codeudores[i];
		}

		rc.Solicitud_de_credito__c = idSolicitud;
		
		Database.SaveResult result = Database.insert(rc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Radicación de crédito: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
            return null;
		}
		return rc.Id; 
	}

	public static Id createRadicacion(Id codeudorId){
		Radicacion_de_credito__c rc = new Radicacion_de_credito__c(
			Codeudor_1__c = codeudorId
		);
		Database.SaveResult result = Database.insert(rc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Radicación de crédito: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return rc.Id; 
	}

	public static Id createRadicacion(Id codeudorId, Id codeudor2Id){
		Radicacion_de_credito__c rc = new Radicacion_de_credito__c(
			Codeudor_1__c = codeudorId,
			Codeudor_2__c = codeudor2Id
		);
		Database.SaveResult result = Database.insert(rc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Radicación de crédito: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return rc.Id; 
	}

	public static Id createRadicacion(Id codeudorId, Id codeudor2Id, Id codeudor3Id){
		Radicacion_de_credito__c rc = new Radicacion_de_credito__c(
			Codeudor_1__c = codeudorId,
			Codeudor_2__c = codeudor2Id,
			Codeudor_3__c = codeudor3Id
		);
		Database.SaveResult result = Database.insert(rc, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Radicación de crédito: ');
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
            }
		}
		return rc.Id; 
	}

	public static Id createSolicitudDeCredito(Id idOportunidad, String tipoDeRegistro){
		Solicitud_de_credito__c sc = new Solicitud_de_credito__c();
		List<RecordType> lstRt = [select id, name from RecordType where SobjectType = 'Solicitud_de_credito__c'];
        Map<String, Id> mapRt = new Map<String, Id>();
        for(RecordType rt : lstRt){
            mapRt.put(rt.Name, rt.Id);
        }

        if(mapRt.containsKey(tipoDeRegistro)){
        	sc.RecordTypeId = mapRt.get(tipoDeRegistro);
        }

        sc.Oportunidad__c = idOportunidad;
        sc.Migrado__c = true;
        Database.SaveResult result = Database.insert(sc, false);
        
        if(result.isSuccess()){
            //System.debug('createSolicitud -> Se creó la Solicitud de credito: ' + result.getId());
            return result.getId();
        } else {
        	System.debug('Errores al crear la solicitud de credito: ');
        	for(Database.Error error : result.getErrors()){
        		System.debug(error.getMessage());
        	}
        } 
        return null;
	}

	public static Id createInformacionComite(Id radicacionId){
		Informacion_comite__c infoComite = new Informacion_comite__c(
			Radicacion__c = radicacionId
		);

		Database.SaveResult result = Database.insert(infoComite, false);
		if(!result.isSuccess()){
            System.debug('Errores al insertar la Información comité: ');
            String errores = '';
			for(Database.Error error : result.getErrors()){
                System.debug(error.getStatusCode() + ': ' + error.getMessage());
                System.debug('Verificar los siguientes campos: ' + error.getFields());
                errores += error.getStatusCode() + ': ' + error.getMessage() + '\n' + 'Verificar los siguientes campos: ' + error.getFields();
            }
			System.assert(result.isSuccess(), errores);
		}
		return infoComite.Id;  
	}

	public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
	
}