@isTest
private class Prevalidador_tst {

	@testSetup static void setup()
	{
		ConfiguracionPrevalidador__c conf = new ConfiguracionPrevalidador__c();
		conf.Cantidad_Consultas_Permitidas__c = 1;
		conf.Usuario_WS_Prevalidador__c = 'user';
		conf.Clave_WS_Prevalidador__c = 'password';
		conf.URL_WS_Prevalidador__c = 'http://testwsprevalidador.credifamilia.com/CredifamiliaServer/services/Credifamilia';
		insert conf;
		TestDataFactory.createAccount('12345678', false);
	}

    @isTest
    static void oportunidad_disponible_para_consulta_con_tres_consultas() {
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		Id oppId = TestDataFactory.createOpportunity(cuenta.Id);

		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(oppId);
			Prevalidador.ValidarEstadoDatacredito(oppId);
			Prevalidador.ValidarEstadoCIFIN(oppId);
			Prevalidador.ValidarConsultaInterna(oppId);
			Prevalidador.ValidarDatosObligatorios(oppId);
		Test.stopTest();
	}

	@isTest
	static void validar_datos_obligatorios()
	{
		Account cuenta = [select Id, Numero_de_documento__c, Canal_digital__c from Account where Numero_de_documento__c = '12345678'];
		System.assert(cuenta.Canal_digital__c == 'No', 'La Cuenta debe ser del canal constructor.');
		Id oppId = TestDataFactory.createOpportunity(cuenta.Id);
		
		Test.startTest();
			String resultado = Prevalidador.ValidarDatosObligatorios(oppId);
			System.assertEquals(
					'ok',
					resultado,
					'Faltan datos obligatorios'
			); 
		Test.stopTest();
	}

	@isTest
	static void oportunidad_sin_consultas()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		Id opp1Id = TestDataFactory.createOpportunity(cuenta.Id);
		Opportunity opp1 = new Opportunity(
			Id = opp1Id,
			Consultas_realizadas__c = 0,
			Estado_Consulta__c = 'Disponible para consulta'
		);
		update opp1;
		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(opp1Id);
			Prevalidador.ValidarEstadoDatacredito(opp1Id);
			Prevalidador.ValidarEstadoCIFIN(opp1Id);
		Test.stopTest();
	}
		
	@isTest
	static void sin_consultas_y_esperando_respuesta()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		Id opp2Id = TestDataFactory.createOpportunity(cuenta.Id);
		Opportunity opp2 = new Opportunity(
			Id = opp2Id,
			Consultas_realizadas__c = 0,
			Estado_Consulta__c = 'Esperando respuesta Consulta Interna'
		);
		update opp2;
		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(opp2.Id);
			Prevalidador.ValidarEstadoDatacredito(opp2.Id);
			Prevalidador.ValidarEstadoCIFIN(opp2.Id);
		Test.stopTest();
	}	

	@isTest
	static void oportunidad_con_tres_codeudores()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Id opp3Id = TestDataFactory.createOpportunity(cuenta.Id);
		Opportunity opp3 = new Opportunity();
		opp3.Id = opp3Id; 
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		Database.SaveResult result = Database.update(opp3, false);
		if(!result.isSuccess()){
			System.debug('Error al insertar la oportunidad');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getMessage() + '\n' + error.getFields());
			}
		}
		Test.startTest();
			//Prevalidador.ConstruirRequestConsultaInterna(opp3.Id);
			Prevalidador.ConstruirRequestConsultaDatacredito(opp3.Id);
			Prevalidador.ConstruirRequestConsultaCIFIN(opp3.Id);
		Test.stopTest();
	}

	@isTest
	static void validacion_exitosa_datos_codeudor()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '85749612');
		Test.startTest();
			String resultado = Prevalidador.ValidarDatosCodeudor(codeudorId);
			System.debug(resultado);
		Test.stopTest();
	}	

	@isTest
	static void validacion_de_persona()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Id opp3Id = TestDataFactory.createOpportunity(cuenta.Id);
		Opportunity opp3 = new Opportunity();
		opp3.Id = opp3Id; 
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		Database.SaveResult result = Database.update(opp3, false);
		if(!result.isSuccess()){
			System.debug('Error al insertar la oportunidad');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getMessage() + '\n' + error.getFields());
			}
		}

		Persona__c persona = new Persona__c();
		persona.Oportunidad__c = opp3.Id;
		persona.Nombre__c = 'nombre';
		persona.Apellidos__c = 'apellido';
		persona.Tipo__c = 'Representante Legal';
		persona.Razon_social__c = 'empresa';
		persona.NIT_de_la_entidad__c = '12345';
		persona.Tipo_de_Documento__c = 'Cédula';
		persona.Numero_de_documento__c = '12345678';
		insert persona;
		persona = new Persona__c();
		persona.Oportunidad__c = opp3.Id;
		persona.Nombre__c = 'nombre';
		persona.Apellidos__c = 'apellido';
		persona.Tipo__c = 'Socio';
		persona.Pais_de_nacimiento__c = 'Colombia';
		persona.Porcentaje_participacion__c = 10;
		persona.Tipo_de_Documento__c = 'Cédula';
		persona.Numero_de_documento__c = '12345678';
		insert persona;
		Test.startTest();
			Prevalidador.ValidarConsultaInternaPasivos(opp3.Id);
			Prevalidador.ConstruirRequestConsultaInternaPasivos(opp3.Id);		
		Test.stopTest();
	}	
		
	@isTest
	static void generar_PDF()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '12345678'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Id opp3Id = TestDataFactory.createOpportunity(cuenta.Id);
		Opportunity opp3 = new Opportunity();
		opp3.Id = opp3Id; 
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		Database.SaveResult result = Database.update(opp3, false);
		if(!result.isSuccess()){
			System.debug('Error al insertar la oportunidad');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getMessage() + '\n' + error.getFields());
			}
		}
		Meta__c meta = new Meta__c();
		insert meta;
		Solicitud_de_credito__c solicitud = new Solicitud_de_credito__c();
		solicitud.Oportunidad__c = opp3.Id;
		solicitud.Meta__c = meta.Id;
		insert solicitud;
		
		Radicacion_de_credito__c radicacion = new Radicacion_de_credito__c();
		radicacion.Solicitud_de_credito__c = solicitud.Id;
		insert radicacion;

		Banderas_cls.setEjecucion('BeforeInformacionFinanciera');
		Informacion_financiera__c info = new Informacion_financiera__c();
		info.Cliente_deudor__c = cuenta.Id;
		info.Codeudor_1__c = codeudorId;
		info.Codeudor_2__c = codeudor2Id;
		info.Codeudor_3__c = codeudor3Id;
		info.Radicacion_de_credito__c = radicacion.Id;
		insert info;
				
		Datacredito__c datacredito = new Datacredito__c();
		datacredito.Puntaje__c = '1000';
		insert datacredito;
		
		Resultado_Prevalidador__c resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = cuenta.Id;
		insert resultado;

		resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = codeudorId;
		insert resultado;

		resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = codeudor2Id;
		insert resultado;

		resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = codeudor3Id;
		insert resultado;

		Informacion_financiera__c info2 = new Informacion_financiera__c();
		info2.Cliente_deudor__c = cuenta.Id;
		info2.Codeudor_1__c = codeudorId;
		info2.Codeudor_2__c = codeudor2Id;
		info2.Codeudor_3__c = codeudor3Id;
		info2.Radicacion_de_credito__c = radicacion.Id;
		insert info2;

		Cifin__c cifin = new Cifin__c();
		insert cifin;

		Test.startTest();
			try {
				String res = Prevalidador.GenerarPDFs(resultado.Id, datacredito.Id, cifin.Id);
				System.debug('Prevalidador.GenerarPDFs: ' + res);
			} catch (Exception e){
				System.debug(e.getMessage());				
			}
		Test.stopTest();
	}
}