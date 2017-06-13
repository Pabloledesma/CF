@isTest
private class Prevalidador_tst {

    static testMethod void myUnitTest() {

		ConfiguracionPrevalidador__c conf = new ConfiguracionPrevalidador__c();
		conf.Cantidad_Consultas_Permitidas__c = 1;
		conf.Usuario_WS_Prevalidador__c = 'user';
		conf.Clave_WS_Prevalidador__c = 'password';
		conf.URL_WS_Prevalidador__c = 'http://testwsprevalidador.credifamilia.com/CredifamiliaServer/services/Credifamilia';
		insert conf;
		
		Account cuenta = CrearCuentaDeudor();
		insert cuenta;

		Opportunity opp = CrearOportunidad(cuenta.Id);
		opp.Consultas_realizadas__c = 3;
		opp.Estado_Consulta__c = 'Disponible para consulta';
		insert opp;
		Prevalidador.ValidarCantidadConsultas(opp.Id);
		Prevalidador.ValidarEstadoDatacredito(opp.Id);
		Prevalidador.ValidarEstadoCIFIN(opp.Id);
		Prevalidador.ValidarConsultaInterna(opp.Id);
		Prevalidador.ValidarDatosObligatorios(opp.Id);

		Opportunity opp1 = CrearOportunidad(cuenta.Id);
		opp1.Consultas_realizadas__c = 0;
		opp1.Estado_Consulta__c = 'Disponible para consulta';
		insert opp1;
		Prevalidador.ValidarCantidadConsultas(opp1.Id);
		Prevalidador.ValidarEstadoDatacredito(opp1.Id);
		Prevalidador.ValidarEstadoCIFIN(opp1.Id);

		Opportunity opp2 = CrearOportunidad(cuenta.Id);
		opp2.Consultas_realizadas__c = 0;
		opp2.Estado_Consulta__c = 'Esperando respuesta Consulta Interna';
		insert opp2;
		Prevalidador.ValidarCantidadConsultas(opp2.Id);
		Prevalidador.ValidarEstadoDatacredito(opp2.Id);
		Prevalidador.ValidarEstadoCIFIN(opp2.Id);
				   		
		Account codeudor = CrearCuentaCodeudor(cuenta.Id, '111111');
		insert codeudor;
		Account codeudor2 = CrearCuentaCodeudor(cuenta.Id, '222222');
		insert codeudor2;
		Account codeudor3 = CrearCuentaCodeudor(cuenta.Id, '333333');
		insert codeudor3;

		Opportunity opp3 = CrearOportunidad(cuenta.Id);
		opp3.Amount = 100000;
//		opp3.OwnerId = usuario.Id;
		opp3.Codeudor_1__c = codeudor.Id;
		opp3.Codeudor_2__c = codeudor2.Id;
		opp3.Codeudor_3__c = codeudor3.Id;
		opp3.Numero_de_vivienda__c = '1';
		opp3.Ingresos_Familiares__c = 500000;
		opp3.Resultado_del_Prevalidador__c = 'VIABLE';
		opp3.Tipo_de_persona__c = 'Jurídica';
		opp3.Tipo_de_producto__c = 'CDT';
		insert opp3;
		
		Prevalidador.ConstruirRequestConsultaInterna(opp3.Id);
		Prevalidador.ConstruirRequestConsultaDatacredito(opp3.Id);
		Prevalidador.ConstruirRequestConsultaCIFIN(opp3.Id);
		
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
		Prevalidador.ValidarConsultaInternaPasivos(opp3.Id);
		Prevalidador.ConstruirRequestConsultaInternaPasivos(opp3.Id);		
		
		// Probar trigger after insert Resultado_Prevalidador__c
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
		info.Codeudor_1__c = codeudor.Id;
		info.Codeudor_2__c = codeudor2.Id;
		info.Codeudor_3__c = codeudor3.Id;
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
		resultado.Cliente__c = codeudor.Id;
		insert resultado;

		resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = codeudor2.Id;
		insert resultado;

		resultado = new Resultado_Prevalidador__c();
		resultado.Oportunidad__c = opp3.Id;
		resultado.Datacredito__c = datacredito.Id;
		resultado.Numero_de_consultas__c = 5;
		resultado.Cliente__c = codeudor3.Id;
		insert resultado;

		Informacion_financiera__c info2 = new Informacion_financiera__c();
		info2.Cliente_deudor__c = cuenta.Id;
		info2.Codeudor_1__c = codeudor.Id;
		info2.Codeudor_2__c = codeudor2.Id;
		info2.Codeudor_3__c = codeudor3.Id;
		info2.Radicacion_de_credito__c = radicacion.Id;
		insert info2;
		
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
        cuenta.Numero_de_telefono_celular__c='11111';
        cuenta.Validar_numero_de_celular__c='11111';
		
		return cuenta;

	}

	static Account CrearCuentaCodeudor(Id idCuentaDeudor, String numDocumento) {

		RecordType tipoRegistro = [SELECT Id FROM RecordType where Name ='Codeudores' limit 1];
		Account codeudor = new Account(RecordTypeId = tipoRegistro.Id);
		codeudor.Cliente_deudor__c = idCuentaDeudor;
		codeudor.FirstName = 'Nombre';
		codeudor.LastName = 'Apellidos';
		codeudor.Validar_nombre__c = 'Nombre';
		codeudor.Numero_de_documento__c = numDocumento;
		codeudor.Validar_numero_de_documento__c = numDocumento;
		codeudor.Tipo_de_documento__c = 'Cédula ciudadanía';
		codeudor.Aporta_ingresos__c = 'No';
		codeudor.Check_VIGIA__c = true;
		codeudor.Tipo_de_ocupacion__c = 'Empleado';
		codeudor.Ciudad_de_residencia__c = 'Bogotá';
		codeudor.Fecha_de_nacimiento__c = Date.newInstance(1970, 2, 2);
        codeudor.Numero_de_telefono_celular__c='11111';
        codeudor.Validar_numero_de_celular__c='11111';
		
		return codeudor;

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