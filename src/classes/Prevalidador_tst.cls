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

		Account cuenta = CrearCuentaDeudor();
		insert cuenta;
	}

    @isTest
    static void oportunidad_disponible_para_consulta_con_tres_consultas() {
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		Opportunity opp = CrearOportunidad(cuenta.Id);
		opp.Consultas_realizadas__c = 3;
		opp.Estado_Consulta__c = 'Disponible para consulta';
		insert opp;

		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(opp.Id);
			Prevalidador.ValidarEstadoDatacredito(opp.Id);
			Prevalidador.ValidarEstadoCIFIN(opp.Id);
			Prevalidador.ValidarConsultaInterna(opp.Id);
			Prevalidador.ValidarDatosObligatorios(opp.Id);
		Test.stopTest();
	}

	@isTest
	static void oportunidad_sin_consultas()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		Opportunity opp1 = CrearOportunidad(cuenta.Id);
		opp1.Consultas_realizadas__c = 0;
		opp1.Estado_Consulta__c = 'Disponible para consulta';
		insert opp1;
		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(opp1.Id);
			Prevalidador.ValidarEstadoDatacredito(opp1.Id);
			Prevalidador.ValidarEstadoCIFIN(opp1.Id);
		Test.stopTest();
	}
		
	@isTest
	static void sin_consultas_y_esperando_respuesta()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		Opportunity opp2 = CrearOportunidad(cuenta.Id);
		opp2.Consultas_realizadas__c = 0;
		opp2.Estado_Consulta__c = 'Esperando respuesta Consulta Interna';
		insert opp2;
		Test.startTest();
			Prevalidador.ValidarCantidadConsultas(opp2.Id);
			Prevalidador.ValidarEstadoDatacredito(opp2.Id);
			Prevalidador.ValidarEstadoCIFIN(opp2.Id);
		Test.stopTest();
	}	

	@isTest
	static void oportunidad_con_tres_codeudores()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Opportunity opp3 = CrearOportunidad(cuenta.Id);
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		Database.SaveResult result = Database.insert(opp3, false);
		if(!result.isSuccess()){
			System.debug('Error al insertar la oportunidad');
			for(Database.Error error : result.getErrors()){
				System.debug(error.getMessage() + '\n' + error.getFields());
			}
		}
		Test.startTest();
			Prevalidador.ConstruirRequestConsultaInterna(opp3.Id);
			Prevalidador.ConstruirRequestConsultaDatacredito(opp3.Id);
			Prevalidador.ConstruirRequestConsultaCIFIN(opp3.Id);
		Test.stopTest();
	}

	@isTest
	static void validacion_exitosa_datos_codeudor()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Test.startTest();
			String resultado = Prevalidador.ValidarDatosCodeudor(codeudorId);
			System.debug(resultado);
		Test.stopTest();
	}	

	@isTest
	static void validacion_de_persona()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Opportunity opp3 = CrearOportunidad(cuenta.Id);
		opp3.Amount = 100000;
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		insert opp3;
		Persona__c persona = new Persona__c();
		persona.Oportunidad__c = opp3.Id;
		persona.Nombre__c = 'nombre';
		persona.Apellidos__c = 'apellido';
		persona.Tipo__c = 'Representante Legal';
		persona.Razon_social__c = 'empresa';
		persona.NIT_de_la_entidad__c = '12345';
		persona.Tipo_de_Documento__c = 'Cédula';
		persona.Numero_de_documento__c = '112233';
		insert persona;
		persona = new Persona__c();
		persona.Oportunidad__c = opp3.Id;
		persona.Nombre__c = 'nombre';
		persona.Apellidos__c = 'apellido';
		persona.Tipo__c = 'Socio';
		persona.Pais_de_nacimiento__c = 'Colombia';
		persona.Porcentaje_participacion__c = 10;
		persona.Tipo_de_Documento__c = 'Cédula';
		persona.Numero_de_documento__c = '112233';
		insert persona;
		Test.startTest();
			Prevalidador.ValidarConsultaInternaPasivos(opp3.Id);
			Prevalidador.ConstruirRequestConsultaInternaPasivos(opp3.Id);		
		Test.stopTest();
	}	
		
	@isTest
	static void generar_PDF()
	{
		Account cuenta = [select Id, Numero_de_documento__c from Account where Numero_de_documento__c = '112233'];
		RecordType rt = [select Id from RecordType where Name = 'Cliente deudor' and SobjectType = 'Account'];				   		
		Id codeudorId = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345678');
		Id codeudor2Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345677');
		Id codeudor3Id = TestDataFactory.createAccount(rt.id, cuenta.Id, '12345676');
		Opportunity opp3 = CrearOportunidad(cuenta.Id);
		opp3.Codeudor_1__c = codeudorId;
		opp3.Codeudor_2__c = codeudor2Id;
		opp3.Codeudor_3__c = codeudor3Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		insert opp3;
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

	static Account CrearCuentaDeudor() {

		RecordType tipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType where Name ='Cliente deudor' limit 1];
		Account cuenta = new Account(RecordTypeId = tipoRegistro.Id);
		cuenta.FirstName = 'Nombre';
		cuenta.LastName = 'Apellidos';
		cuenta.Validar_nombre__c = 'Nombre';
		cuenta.Numero_de_documento__c = '112233';
		cuenta.Validar_numero_de_documento__c = '112233';
		cuenta.Tipo_de_documento__c = 'Cédula ciudadanía';
		cuenta.Tipo_de_ocupacion__c = 'Empleado';
		cuenta.Sexo__c = 'Femenino';
		cuenta.Estado_civil__c = 'Soltero';
		cuenta.Personas_a_cargo__c = '2';
		cuenta.Tipo_de_contrato__c = 'Independiente';
		cuenta.Ciudad_de_residencia__c = 'Bogotá';
		cuenta.Fecha_de_nacimiento__c = Date.newInstance(1970, 2, 2);
		cuenta.Fecha_de_ingreso_a_empleo_actual__c = Date.newInstance(2010, 3, 3);
		cuenta.Actividad_economica__c = 'Comercio';
		cuenta.Check_VIGIA__c = true;
        cuenta.Numero_de_telefono_celular__c='1324567890';
        cuenta.Validar_numero_de_celular__c='1324567890';
		
		return cuenta;

	}
    
    static Opportunity CrearOportunidad(Id idCuenta) {

    	Opportunity opp = new Opportunity();
    	opp.Name = 'Nombre';
		opp.AccountId = idCuenta;
		opp.Tipo_de_producto__c = 'Crédito de vivienda usada';
		opp.Asignacion_de_cupo__c = 'No';
		opp.Tiene_convenio__c = 'No';
		opp.Canal_de_atencion__c = 'Sala de ventas';
		opp.Valor_del_inmueble__c = 200000;
		opp.Amount = 100000;
		opp.Tipo_de_vivienda__c = 'Vip';
		opp.Numero_de_vivienda__c = '1';
		opp.Ingresos_Familiares__c = 500000;
		opp.CloseDate = Date.newInstance(2200, 2, 2);
		opp.StageName = 'Radicado';
		opp.Excepcion__c = 'No';
		
		return opp;
    }
}