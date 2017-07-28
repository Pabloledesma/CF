global class WSProcesadorPrevalidador {
		
	webService static void ProcesarRespuestaCliente(String RespuestaCliente) {
				
		// Reemplazar todas las comas por puntos para el manejo de decimales
		RespuestaCliente = RespuestaCliente.replace(',', '.');

		// Obtener id de la oportunidad
		Dom.Document doc = new Dom.Document();
		Dom.Xmlnode informe;
		String idOportunidad;
 		Id idOpp;
		try {
	 		doc.load(RespuestaCliente);
	 		Dom.Xmlnode raiz = doc.getRootElement();
	 		informe = raiz.getChildElement('Informe', null); 		
	 		idOportunidad = informe.getAttributeValue('idOportunidad', '');
	 		idOpp = idOportunidad;
		}
		catch (Exception e) {
			System.debug('Error leyendo Id de la oportunidad: ' + e);
			return;
		}

		// Obtener datos que vienen en todos los tipos de consultas (Conulta Interna, Datacredito y Cifin)
		String origen, montoSugeridoPreaprobado, relacionCuotaIngreso, LTVPrevalidado, resultadoPrevalidador, fechaPrevalidacion;
		Boolean esConsultaInterna = false, esDatacredito = false, esCifin = false;
 		Dom.Xmlnode informeGeneral;
		String scoreInterno, endeudamientoFinanciero, acierta, numConsultas, numTarjetasVigentes, numCreditosVigentes,
			   numMorasDatacredito, numMorasCIFIN, fechaConsultaListas, horaConsultaListas, observaciones, numDocumento;
		try {

			// Obtener datos de nodo Informe
	 		origen = informe.getAttributeValue('origen', '');
	 		esConsultaInterna = ((origen == null) || (origen == ''));
	 		esDatacredito = (origen == 'datacredito');
	 		esCifin = (origen == 'cifin');
	 		montoSugeridoPreaprobado = informe.getAttributeValue('montoSugerido', null);
	 		relacionCuotaIngreso = informe.getAttributeValue('relacionCI', '');
	 		LTVPrevalidado = informe.getAttributeValue('ltv', '');
	 		fechaPrevalidacion = informe.getAttributeValue('fechaConsulta', '');

			// Obtener datos del nodo InformeGeneral
	 		informeGeneral = informe.getChildElement('InformeGeneral', null);
	 		scoreInterno = informeGeneral.getAttributeValue('scoreIntenro', '');
	 		endeudamientoFinanciero = informeGeneral.getAttributeValue('endeudamientoFinanciero', '');
	 		acierta = informeGeneral.getAttributeValue('acierta', '');
	 		numConsultas = informeGeneral.getAttributeValue('numConsultas', '');
	 		numTarjetasVigentes = informeGeneral.getAttributeValue('numTargetas', '');
	 		numCreditosVigentes = informeGeneral.getAttributeValue('numCreditos', '');
	 		numMorasDatacredito = informeGeneral.getAttributeValue('morasDataCredito', '');
	 		numMorasCIFIN = informeGeneral.getAttributeValue('morasCifin', '');
	 		fechaConsultaListas = informeGeneral.getAttributeValue('fechaListas', '');
	 		horaConsultaListas = informeGeneral.getAttributeValue('horaListas', '');
	 		observaciones = informeGeneral.getAttributeValue('observaciones', '');
	 		resultadoPrevalidador = (observaciones == 'Consulta Exitosa') ? 'VIABLE' : 'NO VIABLE';
	 		numDocumento = informeGeneral.getAttributeValue('numDocumento', '');

		}
		catch (Exception e) {
			ActualizarEstadoConsultaOpp(idOpp, 'Información incorrecta en Informe', true, e, RespuestaCliente,
										esConsultaInterna, false);
			system.debug(e);
			return;
		}

		// Si se presentó un error en la conexión con Datacredito ó CIFIN y
		// si las observaciones del último resultado indican que se presentó un error
		// en la conexión con Datacredito ó CIFIN, no seguir procesando la respuesta
		if (observaciones.startsWith('EC-01:')) {
			
			// Buscar las observaciones del último Resultado
			if (esConsultaInterna) {

				List<Resultado_Prevalidador__c> lstResultados = [
					SELECT Observaciones__c
					FROM Resultado_Prevalidador__c
					WHERE Oportunidad__c = :idOpp
					ORDER BY CreatedDate DESC
				];

				if (lstResultados.size() > 0) {
					if (lstResultados[0].Observaciones__c.startsWith('EC-01:'))
						return;
				}

			}
			else if (esDatacredito) {

				List<Resultado_Datacredito__c> lstResultados = [
					SELECT Observaciones__c
					FROM Resultado_Datacredito__c
					WHERE Oportunidad__c = :idOpp
					ORDER BY CreatedDate DESC
				];

				if (lstResultados.size() > 0) {
					if (lstResultados[0].Observaciones__c.startsWith('EC-01:'))
						return;
				}

			}
			else if (esCifin) {

				List<Resultado_CIFIN__c> lstResultados = [
					SELECT Observaciones__c
					FROM Resultado_CIFIN__c
					WHERE Oportunidad__c = :idOpp
					ORDER BY CreatedDate DESC
				];

				if (lstResultados.size() > 0) {
					if (lstResultados[0].Observaciones__c.startsWith('EC-01:'))
						return;
				}
			}
		}

		// Consultar datos de la oportunidad
		List<Opportunity> lstOportunidades = [
			SELECT 
				Tipo_de_Registro_de_Oportunidad__c, 
				Tipo_de_persona__c,
				AccountId
			FROM Opportunity
			WHERE id =: idOportunidad
		];

		Opportunity opp = lstOportunidades[0];
		System.debug('opp: ' + opp);
		// Consultar datos del cliente dependiendo del tipo de registro de la oportunidad y del tipo de persona
 		Account cuenta;
		String tipoCliente;
		Id idCuenta = null;
		if ((opp.Tipo_de_Registro_de_Oportunidad__c == 'Cuenta de ahorros - CDT') && (opp.Tipo_de_persona__c == 'Jurídica')) {

			List<Persona__c> lstPersonas = [
				SELECT Tipo__c
				FROM Persona__c
				WHERE Numero_de_documento__c =: numDocumento
				  AND Oportunidad__c =: opp.Id
			];
			if (lstPersonas.size() == 0) {
				ActualizarEstadoConsultaOpp(idOpp, 'No existe persona', true, null, '', esConsultaInterna, false);
				return;
			}
			Persona__c persona = lstPersonas[0];
			tipoCliente = persona.Tipo__c;

		} else {
	 		List<Account> lstCuentas = [
	 			SELECT Id, Tipo_de_registro_de_cuenta__c
	 			FROM Account
	 			WHERE Numero_de_documento__c = :numDocumento
	 		];

	 		if (lstCuentas.size() == 0) {
				ActualizarEstadoConsultaOpp(idOpp, 'No existe cliente', true, null, '', esConsultaInterna, false);
				return;
	 		}
	 		cuenta = lstCuentas[0];
	 		System.debug('cuenta: ' + cuenta);
	 		idCuenta = cuenta.Id;
	 		
	 		//Si la cuenta esta relacionada en el campo cliente deudor de la oportunidad entonces es deudor
	 		System.debug('Cliente:deudor: ' + opp.AccountId + ' idCuenta: ' + idCuenta);

	 		tipoCliente = (opp.AccountId == idCuenta) ? 'Deudor' : 'Codeudor';
		}

		

		// Procesar datos que solo vienen cuando es una consulta interna
		if (esConsultaInterna) {

			try {

				// Construir objeto con respuesta
				Resultado_Prevalidador__c objRespuesta;
				objRespuesta = new Resultado_Prevalidador__c();
		 		objRespuesta.Oportunidad__c = idOpp;
		 		objRespuesta.Tipo_Cliente__c = tipoCliente; // cuenta.Tipo_de_registro_de_cuenta__c == 'Cliente deudor' ? 'Deudor' : 'Codeudor';
		 		objRespuesta.Cliente__c = idCuenta; // cuenta.Id;
		 		objRespuesta.Resultado_del_Prevalidador__c = resultadoPrevalidador;
		 		objRespuesta.LTV_Prevalidado__c = LTVPrevalidado == '' ? null : (Decimal.valueOf(LTVPrevalidado) * 100);
		 		objRespuesta.Relacion_cuota_ingreso_prevalidado__c = relacionCuotaIngreso == '' ? null : (Decimal.valueOf(relacionCuotaIngreso) * 100);
		 		objRespuesta.Monto_sugerido_preaprobado__c = montoSugeridoPreaprobado == '' ? null : Decimal.valueOf(montoSugeridoPreaprobado);
		 		objRespuesta.Score_interno__c = scoreInterno == '' ? null : Double.valueOf(scoreInterno);
		 		objRespuesta.Endeudamiento_financiero_prevalidado__c = endeudamientoFinanciero == '' ? null : (Decimal.valueOf(endeudamientoFinanciero) * 100);
				objRespuesta.Numero_de_consultas__c = numConsultas == '' ? null : Double.valueOf(numConsultas);
				System.debug('Numero de consultas: ' + objRespuesta.Numero_de_consultas__c);
				objRespuesta.No_de_tarjetas_vigentes__c = numTarjetasVigentes == '' ? null : Double.valueOf(numTarjetasVigentes);
				objRespuesta.No_de_creditos_vigentes__c = numCreditosVigentes == '' ? null : Double.valueOf(numCreditosVigentes);
				objRespuesta.Moras_en_Datacredito__c = numMorasDatacredito == '' ? null : Double.valueOf(numMorasDatacredito);
				objRespuesta.Moras_en_CIFIN__c = numMorasCIFIN == '' ? null : Double.valueOf(numMorasCIFIN);
				objRespuesta.Observaciones__c = observaciones;
				objRespuesta.LogRespuesta__c = RespuestaCliente;
				
				Integer Anyo, Mes, Dia, Hora, Minutos, Segundos;
				if (fechaConsultaListas.length() > 0) {
					Anyo = Integer.valueOf(fechaConsultaListas.split('\\/')[2]);
					Mes = Integer.valueOf(fechaConsultaListas.split('\\/')[1]);
					Dia = Integer.valueOf(fechaConsultaListas.split('\\/')[0]);
					Hora = Integer.valueOf(horaConsultaListas.split('\\:')[0]);
					Minutos = Integer.valueOf(horaConsultaListas.split('\\:')[1]);
					Segundos = Integer.valueOf(horaConsultaListas.split('\\:')[2]);
					objRespuesta.Fecha_hora_consulta_en_listas__c = Datetime.newInstance(Anyo, Mes, Dia, Hora, Minutos, Segundos);
				}
				if (fechaPrevalidacion.length() > 0) {
					Anyo = Integer.valueOf(fechaPrevalidacion.split('\\/')[2]);
					Mes = Integer.valueOf(fechaPrevalidacion.split('\\/')[1]);
					Dia = Integer.valueOf(fechaPrevalidacion.split('\\/')[0]);
					objRespuesta.Fecha_de_prevalidacion__c = Date.newInstance(Anyo, Mes, Dia);
				}

				// Procesar respuesta de datacredito
		 		Dom.Xmlnode nodoDatacredito = informeGeneral.getChildElements()[1];
				Id idDatacredito = ProcesarDatacredito(nodoDatacredito, idOpp, RespuestaCliente, true);
				if (idDatacredito == null)
					return;
	
				// Procesar respuesta de Cifin
		 		Dom.Xmlnode nodoCifin = informeGeneral.getChildElements()[2];
				Id idCifin = ProcesarCifin(nodoCifin, idOpp, RespuestaCliente, true);
				if (idCifin == null)
					return;
				
				// Terminar exitosamente
				Boolean contarConsulta = (idCuenta != null) && (cuenta.Tipo_de_registro_de_cuenta__c == 'Cliente deudor');
				Double numConsulta = ActualizarEstadoConsultaOpp(idOpp, '', false, null, '', true, contarConsulta);
	
				// Crear objeto de respuesta
				objRespuesta.Datacredito__c = idDatacredito;
				objRespuesta.Cifin__c = idCifin;
				objRespuesta.No_Consulta__c = numConsulta;
				insert objRespuesta;

			}
			catch (Exception e) {
				ActualizarEstadoConsultaOpp(idOpp, 'Error procesando consulta interna', true, e, RespuestaCliente, true, false);
				System.debug(e);
				return;
			}

		}

		// Procesar respuesta de datacredito
		if (esDatacredito) {

			try {

		 		Dom.Xmlnode nodoDatacredito = informeGeneral.getChildElement('DataCredito', null);
				Id idDatacredito = ProcesarDatacredito(nodoDatacredito, idOpp, RespuestaCliente, false);
				if (idDatacredito == null)
					return;
					
				Resultado_Datacredito__c objResultado = new Resultado_Datacredito__c();
				objResultado.Datacredito__c = idDatacredito;
		 		objResultado.Oportunidad__c = idOpp;
		 		objResultado.Tipo_Cliente__c = cuenta.Tipo_de_registro_de_cuenta__c == 'Cliente deudor' ? 'Deudor' : 'Codeudor';
		 		objResultado.Cliente__c = cuenta.Id;
				objResultado.LogRespuesta__c = RespuestaCliente;
				insert objResultado;

				// Terminar exitosamente
				ActualizarEstadoConsultaOpp(idOpp, '', false, null, '', false, false);

			}
			catch (Exception e) {
				ActualizarEstadoConsultaOpp(idOpp, 'Error procesando respuesta datacredito', true, e, RespuestaCliente, false, false);
				system.debug(e);
				return;
			}

		}
		
		// Procesar respuesta de Cifin
		if (esCifin) {
			
			try {
		 		Dom.Xmlnode nodoCifin = informeGeneral.getChildElement('Cifin', null);
				Id idCifin = ProcesarCifin(nodoCifin, idOpp, RespuestaCliente, false);
				if (idCifin == null)
					return;

				Resultado_CIFIN__c objResultado = new Resultado_CIFIN__c();
				objResultado.Cifin__c = idCifin;
		 		objResultado.Oportunidad__c = idOpp;
		 		objResultado.Tipo_Cliente__c = cuenta.Tipo_de_registro_de_cuenta__c == 'Cliente deudor' ? 'Deudor' : 'Codeudor';
		 		objResultado.Cliente__c = cuenta.Id;
				objResultado.LogRespuesta__c = RespuestaCliente;
				insert objResultado;

				// Terminar exitosamente
				ActualizarEstadoConsultaOpp(idOpp, '', false, null, '', false, false);
			}
			catch (Exception e) {
				ActualizarEstadoConsultaOpp(idOpp, 'Error procesando respuesta cifin', true, e, RespuestaCliente, false, false);
				system.debug(e);
				return;
			}

		}

        return;
    }

	public static String EliminarSeparadores(String cadena) {
		return cadena.replace('#', '').replace('$', '').replace('|', '');
	}

	public static Id ProcesarCifin(Dom.Xmlnode nodoCifin, Id idOpp, String RespuestaCliente, Boolean esConsultaInterna) {

 		if ((nodoCifin.getAttributeCount() == 0) || (nodoCifin.getChildElements().size() == 0)) {
	 		Cifin__c objCifin = new Cifin__c();
	 		insert objCifin;
 			return objCifin.Id;
 		}

 		String dato1, dato2, dato3, dato4, dato5, dato6, dato7, dato8, dato9, dato10;
		String atributo;
 		List<String> datosAtributo, datosRegistro;
 		Integer numDato;
		String consultadoPor, fechaConsulta, nombreAsesor, horaConsulta;
 		Dom.Xmlnode nodoInfoBasica;
 		String tipoDocumento, numDocumento, estadoDocumento, numInforme, nombreCliente, rangoEdad, ciiu;
 		Cifin__c objCifin;
		try {
			// Procesar Encabezado
			atributo = nodoCifin.getAttributeValue('encabezado', '');
	 		datosAtributo = atributo.split('\\|');
	 		consultadoPor = EliminarSeparadores(datosAtributo[2]);
	 		fechaConsulta = EliminarSeparadores(datosAtributo[4]);
	 		nombreAsesor = EliminarSeparadores(datosAtributo[5]);
	 		horaConsulta = EliminarSeparadores(datosAtributo[7]);

			// Procesar Información Básica
	 		nodoInfoBasica = nodoCifin.getChildElement('InformacionBasica', null);
	 		atributo = nodoInfoBasica.getAttributeValue('informacion', '');
	 		datosAtributo = atributo.split('\\|');
	 		tipoDocumento = EliminarSeparadores(datosAtributo[1]);
	 		numDocumento = EliminarSeparadores(datosAtributo[3]);
	 		estadoDocumento = EliminarSeparadores(datosAtributo[5]);
	 		numInforme = EliminarSeparadores(datosAtributo[7]);
	 		nombreCliente = EliminarSeparadores(datosAtributo[9]);
	 		rangoEdad = EliminarSeparadores(datosAtributo[11]);
	 		ciiu = EliminarSeparadores(datosAtributo[13]); // Pendiente habilitar cuando lo envíe el prevalidador

			// Construir e insertar objeto con todos los datos de respuesta de Cifin
	 		objCifin = new Cifin__c();
	 		objCifin.Consultado_por__c = consultadoPor;
	 		objCifin.Nombre_Asesor__c = nombreAsesor;
	 		objCifin.Fecha_Consulta__c = fechaConsulta;
	 		objCifin.Hora_Consulta__c = horaConsulta;
	 		objCifin.Tipo_Documento__c = tipoDocumento;
	 		objCifin.Numero_Documento__c = numDocumento;
	 		objCifin.Estado_Documento__c = estadoDocumento;
	 		objCifin.Numero_Informe__c = numInforme;
	 		objCifin.Nombre_Cliente__c = nombreCliente;
	 		objCifin.Rango_Edad__c = rangoEdad;
	 		objCifin.Ciiu__c = ciiu;
	 		insert objCifin;

	 		// Procesar resumen endeudamiento
	 		Dom.Xmlnode nodoResumen = nodoCifin.getChildElement('Resumen', null);
	 		ProcesarEndeudamientoCifin(nodoResumen, 'totales', 'TOTALES', objCifin.Id);
	 		ProcesarEndeudamientoCifin(nodoResumen, 'alDia', 'OBLIGACIONES AL DIA', objCifin.Id);
	 		ProcesarEndeudamientoCifin(nodoResumen, 'enMora', 'OBLIGACIONES EN MORA', objCifin.Id);
	 		
	 		// Procesar cuentas
	 		Dom.Xmlnode nodoInformeDetallado = nodoCifin.getChildElement('InformeDetallado', null);
	 		Dom.Xmlnode nodoInfoCuentas = nodoInformeDetallado.getChildElement('InformacionCuentas', null);
	 		ProcesarCuentasCifin(nodoInfoCuentas, 'Vigentes', 'Estado: Vigentes', objCifin.Id);
	 		ProcesarCuentasCifin(nodoInfoCuentas, 'NoVigentes', 'Estado: No Vigentes', objCifin.Id);
	 		
			// Procesar endeudamiento x sectores
			ProcesarDetalleEndeudamientoCifin(nodoCifin, 'SectorFinanciero', objCifin.Id);
			ProcesarDetalleEndeudamientoCifin(nodoCifin, 'SectorReal', objCifin.Id);

			// Procesar histórico consultas
	 		Dom.Xmlnode nodoConsultas = nodoCifin.getChildElement('Huella', null);
	 		atributo = nodoConsultas.getAttributeValue('huella', '');
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		List<Consulta_Cifin__c> lstConsultas = new List<Consulta_Cifin__c>();
	 		Consulta_Cifin__c objConsulta;
	 		for (String datoConsulta : datosAtributo) {
	
	 			numDato++;
	 			
	 			// Ignorar encabezados
	 			if (numDato > 1) {
	 				datosRegistro = datoConsulta.split('\\|');
	 				dato1 = EliminarSeparadores(datosRegistro[0]);
	 				dato2 = EliminarSeparadores(datosRegistro[1]);
	 				dato3 = EliminarSeparadores(datosRegistro[2]);
	 				dato4 = EliminarSeparadores(datosRegistro[3]);
	 				objConsulta = new Consulta_Cifin__c(Cifin__c = objCifin.Id,
				 										  Entidad__c = dato1,
				 										  Fecha__c = dato2,
				 										  Sucursal__c = dato3,
				 										  Ciudad__c = dato4);
	 				lstConsultas.Add(objConsulta);
	 			}
	 		}
	 		insert lstConsultas;

		}
		catch (Exception e) {
			ActualizarEstadoConsultaOpp(idOpp, 'Error procesando Cifin', true, e, RespuestaCliente, esConsultaInterna, false);
			System.debug(e);
			return null;
		}

		return objCifin.Id;

	}
	
	public static void ProcesarDetalleEndeudamientoCifin(Dom.Xmlnode nodoCifin, String nombreNodo, Id idCifin) {

 		List<String> datosAtributo, datosRegistro;
 		Integer numDato, numValor;
 		String atributo, detalle, tagInicial, tagFinal, titulo, tituloAMostrar, sector;
		Detalle_Obligacion__c objObligacion;
 		List<Detalle_Obligacion__c> lstObligaciones = new List<Detalle_Obligacion__c>();

		Dom.Xmlnode nodoPrincipal = nodoCifin.getChildElement(nombreNodo, null);
		for (Dom.Xmlnode nodo : nodoPrincipal.getChildElements()) {
			
			titulo = '';
			if (nodo.getName() == 'AlDia') {
				titulo = 'OBLIGACIONES VIGENTES Y AL DÍA';
			}
			else if (nodo.getName() == 'Extinguidas') {
				titulo = 'OBLIGACIONES EXTINGUIDAS';
			}
			else if (nodo.getName() == 'Mora') {
				titulo = 'OBLIGACIONES EN MORA';
			}
			
			atributo = nodo.getAttributeValue('cuenta', '');
			if (atributo.length() > 0) {
		 		datosAtributo = atributo.split('\\$');
		 		numDato = 0;
		 		for (String dato : datosAtributo) {
		 			numDato++;
	 				tituloAMostrar = (numDato == 1) ? titulo : '';
	 				sector = (lstObligaciones.size() == 0) ? nombreNodo : ''; 
	 				datosRegistro = dato.split('\\|\\#');
	 				numValor = 0;
	 				detalle = '';
	 				for (String valor : datosRegistro) {
	 					numValor++;
	 					tagInicial = '[' + String.valueOf(numValor) + ']';
	 					tagFinal = '[/' + String.valueOf(numValor) + ']';
	 					detalle += tagInicial + EliminarSeparadores(valor) + tagFinal;
	 				}
					objObligacion = new Detalle_Obligacion__c(Cifin__c = idCifin,
															  Titulo__c = tituloAMostrar,
															  Detalle__c = detalle,
															  Sector__c = sector);
					lstObligaciones.Add(objObligacion);
		 		}
			}
		}
		insert lstObligaciones;

	}
	
	public static void ProcesarEndeudamientoCifin(Dom.Xmlnode nodoResumen, String nombreAtributo, String titulo, Id idCifin) {

 		List<String> datosAtributo, datosRegistro;
 		Integer numDato;
		String tituloAMostrar;
 		String dato1, dato2, dato3, dato4, dato5, dato6, dato7, dato8, dato9, dato10;
 		List<Obligacion__c> lstObligaciones = new List<Obligacion__c>();
 		Obligacion__c objObligacion;

		String atributo = nodoResumen.getAttributeValue(nombreAtributo, '');
		if (atributo.length() > 0) {
	 		
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		for (String dato : datosAtributo) {
	 			
	 			numDato++;
 				tituloAMostrar = (numDato == 1) ? titulo : '';
 				
 				datosRegistro = dato.split('\\|');
 				dato1 = EliminarSeparadores(datosRegistro[0]);
 				dato2 = EliminarSeparadores(datosRegistro[1]);
 				dato3 = EliminarSeparadores(datosRegistro[2]);
 				dato4 = EliminarSeparadores(datosRegistro[3]);
 				dato5 = EliminarSeparadores(datosRegistro[4]);
 				dato6 = EliminarSeparadores(datosRegistro[5]);
// Pendiente: habilitar cuando el prevalidor envíe los datos
 				dato7 = EliminarSeparadores(datosRegistro[6]);
 				dato8 = EliminarSeparadores(datosRegistro[7]);
 				dato9 = EliminarSeparadores(datosRegistro[8]);
 				dato10 = EliminarSeparadores(datosRegistro[9]);
//
				objObligacion = new Obligacion__c(Cifin__c = idCifin,
												  Titulo__c = tituloAMostrar,
												  Subtitulo__c = dato1,
												  Tarjeta_de_Credito__c = dato2,
												  Sector_Financiero__c = dato3,
												  Sector_Real__c = dato4,
												  Subtotal__c = dato5,
												  Tarjeta_de_Credito_2__c = dato6, // Pendiente: habilitar cuando el prevalidor envíe los datos
												  					//	(se cambió el orden, se pasó total al final)
												  Sector_Financiero_2__c = dato7,
												  Sector_Real_2__c = dato8,
												  Subtotal_2__c = dato9,
												  Total__c = dato10);
				lstObligaciones.Add(objObligacion);
	 		}
	 		insert lstObligaciones;
		}
	}

	public static void ProcesarCuentasCifin(Dom.Xmlnode nodoInfoCuentas, String nombreNodo, String titulo, Id idCifin) {

 		List<String> datosAtributo, datosRegistro;
 		Integer numDato;
		String tituloAMostrar;
 		String dato1, dato2, dato3, dato4, dato5, dato6, dato7, dato8, dato9, dato10, dato11, dato12, dato13;
 		List<Cuenta__c> lstCuentas = new List<Cuenta__c>();
 		Cuenta__c objCuenta;

		Dom.Xmlnode nodo = nodoInfoCuentas.getChildElement(nombreNodo, null);
		String atributo = nodo.getAttributeValue('cuenta', '');
		if (atributo.length() > 0) {
	 		
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		for (String dato : datosAtributo) {
	 			
	 			numDato++;
 				tituloAMostrar = (numDato == 1) ? titulo : '';
 				
 				datosRegistro = dato.split('\\|');
 				dato1 = EliminarSeparadores(datosRegistro[0]);
 				dato2 = EliminarSeparadores(datosRegistro[1]);
 				dato3 = EliminarSeparadores(datosRegistro[2]);
 				dato4 = EliminarSeparadores(datosRegistro[3]);
 				dato5 = EliminarSeparadores(datosRegistro[4]);
 				dato6 = EliminarSeparadores(datosRegistro[5]);
 				dato7 = EliminarSeparadores(datosRegistro[6]);
 				dato8 = EliminarSeparadores(datosRegistro[7]);
 				dato9 = EliminarSeparadores(datosRegistro[8]);
 				dato10 = EliminarSeparadores(datosRegistro[9]);
 				dato11 = EliminarSeparadores(datosRegistro[10]);
 				dato12 = EliminarSeparadores(datosRegistro[11]);
 				dato13 = EliminarSeparadores(datosRegistro[12]);

				objCuenta = new Cuenta__c(Cifin__c = idCifin,
										  Titulo__c = tituloAMostrar,
										  Fecha_Corte__c = dato1,
										  Tipo_Contrato__c = dato2,
										  Numero_Cuenta__c = dato3,
										  Estado__c = dato4,
										  Tipo_Entidad__c = dato5,
										  Entidad__c = dato6,
										  Ciudad__c = dato7,
										  Sucursal__c = dato8,
										  Fecha_Apertura__c = dato9,
										  Cupo_Sobregiro__c = dato10,
										  Dias__c = dato11,
										  Fecha_Permanencia__c = dato12,
										  Cheques_Devueltos__c = dato13);
				lstCuentas.Add(objCuenta);
	 		}
	 		insert lstCuentas;
		}
	}
	
	public static Id ProcesarDatacredito(Dom.Xmlnode nodoDatacredito, Id idOpp, String RespuestaCliente, Boolean esConsultaInterna) {
 		
 		if ((nodoDatacredito.getAttributeCount() == 0) || (nodoDatacredito.getChildElements().size() == 0)) {
	 		Datacredito__c objDatacredito = new Datacredito__c();
	 		insert objDatacredito;
 			return objDatacredito.Id;
 		}

 		String dato1, dato2, dato3, dato4, dato5, dato6, dato7, dato8, dato9, dato10;
 		String dato11, dato12, dato13, dato14, dato15, dato16, dato17, dato18, dato19, dato20;
 		String dato21, dato22, dato23, dato24, dato25, dato26;
		String atributo;
 		List<String> datosAtributo, datosRegistro;
 		String nombreAsesor, fechaConsulta, articulo;
 		Dom.Xmlnode nodoInfoBasica, nodoResumen;
 		String codigoRespuesta, tipoDocumento, numDocumento, estadoDocumento, puntaje, nombreCliente, rangoEdad;
 		Boolean tieneHistoriaCrediticia;
 		Integer numDato;
 		Datacredito__c objDatacredito;

		try {
			// Obtener código de respuesta
			codigoRespuesta = nodoDatacredito.getAttributeValue('respuesta', '');
			tieneHistoriaCrediticia = (codigoRespuesta != '14');

			// Procesar Encabezado
			atributo = nodoDatacredito.getAttributeValue('encabezado', '');
	 		datosAtributo = atributo.split('\\|');
	 		nombreAsesor = EliminarSeparadores(datosAtributo[2]);
	 		fechaConsulta = EliminarSeparadores(datosAtributo[3]);

			// Procesar Información Básica
	 		nodoInfoBasica = nodoDatacredito.getChildElement('InformacionBasica', null);
	 		atributo = nodoInfoBasica.getAttributeValue('informacion', '');
	 		datosAtributo = atributo.split('\\|');
	 		tipoDocumento = EliminarSeparadores(datosAtributo[1]);
	 		numDocumento = EliminarSeparadores(datosAtributo[3]);
	 		estadoDocumento = EliminarSeparadores(datosAtributo[5]);
	 		puntaje = EliminarSeparadores(datosAtributo[7]);
	 		nombreCliente = EliminarSeparadores(datosAtributo[9]);
	 		rangoEdad = EliminarSeparadores(datosAtributo[11]);

	 		// Procesar Artículo
	 		if (tieneHistoriaCrediticia) {
		 		Dom.Xmlnode nodoArticulo = nodoInfoBasica.getChildElement('Articulo', null);
		 		articulo = nodoArticulo.getAttributeValue('txt', '');
	 		}
	 		else {
	 			articulo = '';
	 		}
 		
			// Construir e insertar objeto con todos los datos de respuesta de datacredito
	 		objDatacredito = new Datacredito__c();
	 		objDatacredito.Nombre_Asesor__c = nombreAsesor;
	 		objDatacredito.Fecha_y_Hora_Consulta__c = fechaConsulta;
	 		objDatacredito.Tipo_Documento__c = tipoDocumento;
	 		objDatacredito.Numero_Documento__c = numDocumento;
	 		objDatacredito.Estado_Documento__c = estadoDocumento;
	 		objDatacredito.Puntaje__c = puntaje;
	 		objDatacredito.Nombre_Cliente__c = nombreCliente;
	 		objDatacredito.Rango_Edad__c = rangoEdad;
	 		objDatacredito.Articulo__c = articulo;
	 		insert objDatacredito;
 		
	 		// Si el cliente no tiene historia crediticia, terminar
	 		if (!tieneHistoriaCrediticia)
	 			return objDatacredito.Id;
 
			// Procesar Alertas
	 		Dom.Xmlnode nodoAlertas = nodoInfoBasica.getChildElement('Alertas', null);
	 		atributo = nodoAlertas.getAttributeValue('alerta', '');
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		List<Alerta__c> lstAlertas = new List<Alerta__c>();
	 		Alerta__c objAlerta;
	 		for (String dato : datosAtributo) {
	
	 			numDato++;
	 			
	 			// Ignorar encabezados
	 			if (numDato > 1) {
	 				datosRegistro = dato.split('\\|');
	 				dato1 = EliminarSeparadores(datosRegistro[0]);
	 				dato2 = EliminarSeparadores(datosRegistro[1]);
	 				dato3 = EliminarSeparadores(datosRegistro[2]);
	 				dato4 = EliminarSeparadores(datosRegistro[3]);
	 				objAlerta = new Alerta__c(Datacredito__c = objDatacredito.Id,
	 										  Fuente__c = dato1,
	 										  Fecha__c = dato2,
	 										  Novedad__c = dato3,
	 										  Descripcion__c = dato4);
	 				lstAlertas.Add(objAlerta);
	 			}
	 		}
	 		insert lstAlertas;
 		
	 		// Procesar datos x sector
	 		nodoResumen = nodoInfoBasica.getChildElement('Resumen', null);
	 		atributo = nodoResumen.getAttributeValue('perfil', '');
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		List<Datacredito_Sectores__c> lstDatosSectores = new List<Datacredito_Sectores__c>();
	 		Datacredito_Sectores__c objDatosSectores;
	  		for (String dato : datosAtributo) {
	
	 			numDato++;
	 			
	 			// Ignorar encabezados
	 			if (numDato > 1) {
	 				datosRegistro = dato.split('\\|');
	 				dato1 = EliminarSeparadores(datosRegistro[0]);
	 				dato2 = EliminarSeparadores(datosRegistro[1]);
	 				dato3 = EliminarSeparadores(datosRegistro[2]);
	 				dato4 = EliminarSeparadores(datosRegistro[3]);
	 				dato5 = EliminarSeparadores(datosRegistro[4]);
	 				dato6 = EliminarSeparadores(datosRegistro[5]);
	 				dato7 = EliminarSeparadores(datosRegistro[6]);
	 				dato8 = EliminarSeparadores(datosRegistro[7]);
	 				objDatosSectores = new Datacredito_Sectores__c(Datacredito__c = objDatacredito.Id,
						 										   Nombre__c = dato1,
						 										   Sector_Financiero__c = dato2,
						 										   Sector_Cooperativo__c = dato3,
						 										   Sector_Real__c = dato4,
						 										   Sector_Telcos__c = dato5,
						 										   Total_Sectores__c = dato6,
						 										   Total_como_principal__c = dato7,
						 										   Total_como_codeudor_y_otros__c = dato8);
	 				lstDatosSectores.Add(objDatosSectores);
	 			}
	 		}
	 		insert lstDatosSectores;
			
	 		// Procesar tendencia endeudamiento
	 		atributo = nodoResumen.getAttributeValue('tendenciaEndeudamiento', '');
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		List<Tendencia_Endeudamiento__c> lstTendenciaEndeudamiento = new List<Tendencia_Endeudamiento__c>();
	 		Tendencia_Endeudamiento__c objTendenciaEndeudamiento;
	  		for (String dato : datosAtributo) {
	
	 			numDato++;
	 			
	 			// Ignorar encabezados
	 			if (numDato > 1) {
	 				datosRegistro = dato.split('\\|');
	 				dato1 = EliminarSeparadores(datosRegistro[0]);
	 				dato2 = EliminarSeparadores(datosRegistro[1]);
	 				dato3 = EliminarSeparadores(datosRegistro[2]);
	 				dato4 = EliminarSeparadores(datosRegistro[3]);
	 				dato5 = EliminarSeparadores(datosRegistro[4]);
	 				dato6 = EliminarSeparadores(datosRegistro[5]);
	 				dato7 = EliminarSeparadores(datosRegistro[6]);
	 				dato8 = EliminarSeparadores(datosRegistro[7]);
	 				dato9 = EliminarSeparadores(datosRegistro[8]);
	 				objTendenciaEndeudamiento = new Tendencia_Endeudamiento__c(Datacredito__c = objDatacredito.Id,
						 										      Fecha__c = dato1,
						 										      Saldos_Totales_Mora__c = dato2,
						 										      Saldos_Totales_Miles__c = dato3,
						 										      Moras_Max_Financiero__c = dato4,
						 										      Moras_Max_Real__c = dato5,
						 										      Moras_Max_Telcos__c = dato6,
						 										      Total_Moras_Max__c = dato7,
						 										      Creditos_Mora_30__c = dato8,
						 										      Creditos_Mora_60__c = dato9);
	 				lstTendenciaEndeudamiento.Add(objTendenciaEndeudamiento);
	 			}
	 		}
	 		insert lstTendenciaEndeudamiento;

	 		// Procesar endeudamiento actual
	 		Dom.Xmlnode nodoEndeudamientoActual = nodoInfoBasica.getChildElement('EndeudamientoActual', null);
	 		String nombreCartera, dato;
	 		Decimal totalSaldoActual = 0;
	 		Decimal totalSaldoMora = 0;
	 		Decimal totalValorCuota = 0;
	 		Decimal totalValorInicial = 0;
	 		Decimal totalPorcentajePart = 0;
	 		Decimal totalPorcentajeDeuda = 0;
	 		List<Cartera_Actual_Financiera__c> lstCarteras = new List<Cartera_Actual_Financiera__c>();
	 		Cartera_Actual_Financiera__c objCartera, objTotal;
	 		String nombreSector, tipoCartera;
	 		Integer numCartera;
	 		Dom.Xmlnode nodoCartera;
	 		for (Dom.Xmlnode nodoSector : nodoEndeudamientoActual.getChildElements()) {

	 			// Obtener nombre del sector
	 			nombreSector = 'Sector ' + nodoSector.getName().replace('Sector', '');

				// Crear objeto con el total del sector
		 		objTotal = new Cartera_Actual_Financiera__c();
		 		objTotal.Datacredito__c = objDatacredito.Id;
		 		objTotal.Name = nombreSector;
		 		objTotal.Es_Total__c = true;
		 		objTotal.Total_Saldo_Actual__c = 0;
		 		objTotal.Total_Saldo_Mora__c = 0;
		 		objTotal.Total_Valor_Cuota__c = 0;
		 		objTotal.Total_Valor_Inicial__c = 0;
		 		objTotal.Total_Porcentaje_Part__c = 0;
		 		objTotal.Total_Porcentaje_Deuda__c = 0;
	 			
	 			// Si el nodo cartera del sector tiene datos...
	 			nodoCartera = nodoSector.getChildElements()[0];
				atributo = nodoCartera.getAttributeValue('cartera', '');
				if ((atributo != null) && (atributo.length() > 0)) {
					
					// Procesar carteras del sector
					datosAtributo = atributo.split('\\$');
					numDato = 0;
		 			numCartera = 0;
			 		for (String datosCartera : datosAtributo) {
		 				
		 				// Procesar los datos de cada cartera. Vienen en conjuntos de 3:
		 				// . Dato 1: Tipo de cartera
		 				// . Dato 2: Encabezados
		 				// . Dato 3: Datos de la cartera
			 			numDato++;
		 				datosRegistro = datosCartera.split('\\|');
						if (math.mod(numDato, 3) == 1) {
			 				tipoCartera = EliminarSeparadores(datosRegistro[1]);
						}
						else if (math.mod(numDato, 3) == 0) {
							
			 				// Asignar nombre del sector solamente a la primera cartera
							numCartera++;
				 			nombreSector = (numCartera == 1) ? nombreSector : '';
							
			 				dato1 = EliminarSeparadores(datosRegistro[0]);
			 				dato2 = EliminarSeparadores(datosRegistro[1]);
			 				dato4 = EliminarSeparadores(datosRegistro[3]);
			 				dato3 = EliminarSeparadores(datosRegistro[2]);
			 				dato5 = EliminarSeparadores(datosRegistro[4]);
			 				dato6 = EliminarSeparadores(datosRegistro[5]);
			 				dato7 = EliminarSeparadores(datosRegistro[6]);
			 				dato8 = EliminarSeparadores(datosRegistro[7]);
			 				dato9 = EliminarSeparadores(datosRegistro[8]);
			 				dato10 = EliminarSeparadores(datosRegistro[9]);
							
							// Crear objeto con la cartera y adicionarlo a la lista
							objCartera = new Cartera_Actual_Financiera__c(Datacredito__c = objDatacredito.Id,
																		  Es_Total__c = false,
																		  Name = tipoCartera,
																		  Sector__c = nombreSector,
																		  Tipo__c = tipoCartera,
																		  Calidad__c = dato1,
																		  Numero__c = dato2,
																		  Estado__c = dato3,
																		  Claf__c = dato4,
																		  Valor_Inicial__c = dato5,
																		  Saldo_Actual__c = dato6,
																		  Saldo_Mora__c = dato7,
																		  Valor_Cuota__c = dato8,
																		  Porcentaje_Part__c = dato9,
																		  Porcentaje_Deuda__c = dato10);
							lstCarteras.Add(objCartera);

							// Actualizar totales del sector con datos de la cartera	
					 		objTotal.Total_Saldo_Actual__c += (dato6.length() > 0) ? Decimal.valueOf(dato6) : 0;
					 		objTotal.Total_Saldo_Mora__c += (dato7.length() > 0) ? Decimal.valueOf(dato7) : 0;
					 		objTotal.Total_Valor_Cuota__c += (dato8.length() > 0) ? Decimal.valueOf(dato8) : 0;
					 		objTotal.Total_Valor_Inicial__c += (dato5.length() > 0) ? Decimal.valueOf(dato5) : 0;
					 		objTotal.Total_Porcentaje_Part__c += (dato9.length() > 0) ? Decimal.valueOf(dato9) : 0;
					 		objTotal.Total_Porcentaje_Deuda__c += (dato10.length() > 10) ? Decimal.valueOf(dato10) : 0;

						} // Procesar los datos de cada cartera
			 			
			 		} // Procesar carteras del sector
			 		
			 		// Actualizar totales de todos los sectore con los totales del sector
			 		totalSaldoActual += objTotal.Total_Saldo_Actual__c;
			 		totalSaldoMora += objTotal.Total_Saldo_Mora__c;
			 		totalValorCuota += objTotal.Total_Valor_Cuota__c;
			 		totalValorInicial += objTotal.Total_Valor_Inicial__c;
			 		totalPorcentajePart += objTotal.Total_Porcentaje_Part__c;
			 		totalPorcentajeDeuda += objTotal.Total_Porcentaje_Deuda__c;

					// Adicionar objeto con total a la lista de carteras
					lstCarteras.Add(objTotal);
				
				} // Si el nodo cartera del sector tiene datos...
	 			
	 		} // for nodoSector
	 		
	 		// Crear carteras
	 		insert lstCarteras;
	 		
	 		// Actualizar los totales de todos los sectores
	 		objDatacredito.Total_Saldo_Actual__c = totalSaldoActual;
	 		objDatacredito.Total_Saldo_Mora__c = totalSaldoMora;
	 		objDatacredito.Total_Valor_Cuota__c = totalValorCuota;
	 		objDatacredito.Total_Valor_Inicial__c = totalValorInicial;
	 		objDatacredito.Total_Porcentaje_Part__c = totalPorcentajePart;
	 		objDatacredito.Total_Porcentaje_Deuda__c = totalPorcentajeDeuda;
	 		update objDatacredito;

	 		// Procesar obligaciones vigentes
	 		Dom.Xmlnode nodoVigentes = nodoInfoBasica.getChildElement('AbiertasVigentes', null);
	 		String sectorCartera;
	 		List<Cartera_Vigente__c> lstCarteras4 = new List<Cartera_Vigente__c>();
	 		Cartera_Vigente__c objCartera4;
			
			// ... Procesar sectores
			Dom.Xmlnode nodoCartera2;
	 		for (Dom.Xmlnode nodoSector : nodoVigentes.getChildElements()) {
	 			
	 			nombreSector = nodoSector.getName();
	 			
	 			// ... Procesar carteras del sector
				nodoCartera2 = nodoSector.getChildElement('Cartera', null);
				atributo = nodoCartera2.getAttributeValue('cartera', '');
				if (atributo.length() > 0) {

					datosAtributo = atributo.split('\\$');
		 			numCartera = 0;
			 		for (String datosCartera : datosAtributo) {

						// Mostrar el nombre del sector solamente si es la primera cartera
						numCartera++;
						sectorCartera = (numCartera == 1) ? nombreSector : '';
						
		 				datosRegistro = datosCartera.split('\\|');
		 				dato1 = EliminarSeparadores(datosRegistro[0]);
		 				dato2 = EliminarSeparadores(datosRegistro[1]);
		 				dato3 = EliminarSeparadores(datosRegistro[2]);
		 				dato4 = EliminarSeparadores(datosRegistro[3]);
		 				dato5 = EliminarSeparadores(datosRegistro[4]);
		 				dato6 = EliminarSeparadores(datosRegistro[5]);
		 				dato7 = EliminarSeparadores(datosRegistro[6]);
		 				dato8 = EliminarSeparadores(datosRegistro[7]);
		 				dato9 = EliminarSeparadores(datosRegistro[8]);
		 				dato10 = EliminarSeparadores(datosRegistro[9]);
		 				dato11 = EliminarSeparadores(datosRegistro[10]);
		 				dato12 = EliminarSeparadores(datosRegistro[11]);
		 				dato13 = EliminarSeparadores(datosRegistro[12]);
		 				dato14 = EliminarSeparadores(datosRegistro[13]);
		 				dato15 = EliminarSeparadores(datosRegistro[14]);
		 				dato16 = EliminarSeparadores(datosRegistro[15]);
		 				dato17 = EliminarSeparadores(datosRegistro[16]);
		 				dato18 = EliminarSeparadores(datosRegistro[17]);
		 				dato19 = EliminarSeparadores(datosRegistro[18]);
		 				dato20 = EliminarSeparadores(datosRegistro[19]);
		 				dato21 = EliminarSeparadores(datosRegistro[20]);
		 				dato22 = EliminarSeparadores(datosRegistro[21]);
		 				dato23 = EliminarSeparadores(datosRegistro[22]);
		 				dato24 = EliminarSeparadores(datosRegistro[23]);
		 				dato25 = EliminarSeparadores(datosRegistro[24]);
		 				dato26 = EliminarSeparadores(datosRegistro[25]);

						objCartera4 = new Cartera_Vigente__c(Datacredito__c = objDatacredito.Id,
															  Sector__c = sectorCartera,
															  Entidad__c = dato1,
															  Tipo_Cuenta__c = dato2,
															  Numero_Cuenta__c = dato3,
															  Calf__c = dato4,
															  Estado_Obligacion__c = dato5,
															  Fecha_Actualizacion__c = dato6,
															  Tiempo__c = dato7,
															  Adjetivo_Fecha__c = dato8,
															  Fecha_Apertura__c = dato9,
															  Fecha_Vencimiento__c = dato10,
															  Mora_Maxima__c = dato11,
															  Desacuerdos__c = dato12,
															  Estado_Titular__c = dato13,
															  Marca_Clase__c = dato14,
															  Tipo_Garantia__c = dato15,
															  Valor_Cupo_Inicial__c = dato16,
															  Saldo_Actual__c = dato17,
															  Saldos_Mora__c = dato18,
															  Valor_Cuota__c = dato19,
															  Fechas_Limite_Pago__c = dato20,
															  Fechas_del_Pago__c = dato21,
															  Perm__c = dato22,
															  Cheques_Devueltos__c = dato23,
															  Cuotas__c = dato24,
															  Porcentaje_Deuda__c = dato25,
															  Oficina__c = dato26);
						lstCarteras4.Add(objCartera4);
					}
				}
	 		}
	 		insert lstCarteras4;

	 		// Procesar obligaciones cerradas
	 		Dom.Xmlnode nodoCerradas = nodoInfoBasica.getChildElement('CerradasInactivas', null);
	 		List<Cartera_Cerrada__c> lstCarteras5 = new List<Cartera_Cerrada__c>();
	 		Cartera_Cerrada__c objCartera5;
			
			// ... Procesar sectores
			Dom.Xmlnode nodoCartera3;
	 		for (Dom.Xmlnode nodoSector : nodoCerradas.getChildElements()) {
	 			
	 			nombreSector = nodoSector.getName();
	 			
	 			// ... Procesar carteras del sector
				nodoCartera3 = nodoSector.getChildElement('Cartera', null);
				atributo = nodoCartera3.getAttributeValue('cartera', '');
				if (atributo.length() > 0) {

					datosAtributo = atributo.split('\\$');
		 			numCartera = 0;
			 		for (String datosCartera : datosAtributo) {

						// Mostrar el nombre del sector solamente si es la primera cartera
						numCartera++;
						sectorCartera = (numCartera == 1) ? nombreSector : '';
			 			
		 				datosRegistro = datosCartera.split('\\|');
		 				dato1 = EliminarSeparadores(datosRegistro[0]);
		 				dato2 = EliminarSeparadores(datosRegistro[1]);
		 				dato3 = EliminarSeparadores(datosRegistro[2]);
		 				dato4 = EliminarSeparadores(datosRegistro[3]);
		 				dato5 = EliminarSeparadores(datosRegistro[4]);
		 				dato6 = EliminarSeparadores(datosRegistro[5]);
		 				dato7 = EliminarSeparadores(datosRegistro[6]);
		 				dato8 = EliminarSeparadores(datosRegistro[7]);
		 				dato9 = EliminarSeparadores(datosRegistro[8]);
		 				dato10 = EliminarSeparadores(datosRegistro[9]);
		 				dato11 = EliminarSeparadores(datosRegistro[10]);
		 				dato12 = EliminarSeparadores(datosRegistro[11]);
		 				dato13 = EliminarSeparadores(datosRegistro[12]);

						objCartera5 = new Cartera_Cerrada__c(Datacredito__c = objDatacredito.Id,
															  Sector__c = sectorCartera,
															  Entidad__c = dato1,
															  Tipo_Cuenta__c = dato2,
															  Estado_Obligacion__c = dato3,
															  Calf__c = dato4,
															  Adjetivo_Fecha__c = dato5,
															  Numero_Cuenta__c = dato6,
															  Tiempo__c = dato7,
															  Fecha_Apertura__c = dato8,
															  Fecha_Cierre__c = dato9,
															  Valor_Cupo_Inicial__c = dato10,
															  Ciudad_Fecha__c = dato11,
															  Oficina_Deudor__c = dato12,
															  Desacuerdo__c = dato13);
						lstCarteras5.Add(objCartera5);
			 		}
				}
	 		}
	 		insert lstCarteras5;

			// Procesar histórico consultas
	 		Dom.Xmlnode nodoConsultas = nodoInfoBasica.getChildElement('HistoriaConsultas', null);
	 		atributo = nodoConsultas.getAttributeValue('historico', '');
	 		datosAtributo = atributo.split('\\$');
	 		numDato = 0;
	 		List<Consulta_Datacredito__c> lstConsultas = new List<Consulta_Datacredito__c>();
	 		Consulta_Datacredito__c objConsulta;
	 		for (String datoConsulta : datosAtributo) {
	
	 			numDato++;
	 			
	 			// Ignorar encabezados
	 			if (numDato > 1) {
	 				datosRegistro = datoConsulta.split('\\|');
	 				dato1 = EliminarSeparadores(datosRegistro[0]);
	 				dato2 = EliminarSeparadores(datosRegistro[1]);
	 				dato3 = EliminarSeparadores(datosRegistro[2]);
	 				objConsulta = new Consulta_Datacredito__c(Datacredito__c = objDatacredito.Id,
					 										  Fecha__c = dato1,
					 										  Consultante__c = dato2,
					 										  Consultas_Mes__c = dato3);
	 				lstConsultas.Add(objConsulta);
	 			}
	 		}
	 		insert lstConsultas;


		}
		catch (Exception e) {
			ActualizarEstadoConsultaOpp(idOpp, 'Error procesando Datacredito', true, e, RespuestaCliente, esConsultaInterna, false);
			System.debug(e);
			return null;
		}
 				
		return objDatacredito.Id;
	}

	public static Double ActualizarEstadoConsultaOpp(Id idOportunidad, String mensajeError, Boolean crearRespuesta,
													 Exception ex, String textoRespuesta,
													 Boolean esConsultaInterna, Boolean contarConsulta) {

		ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
		Integer maxConsultas = (Integer)conf.Cantidad_Consultas_Permitidas__c;

		// Consultar datos de la oportunidad con respecto a las consultas
		List<Opportunity> lstOportunidades = [
			SELECT Consultas_realizadas__c, Estado_Consulta__c, Observaciones_estado_consulta__c
			FROM Opportunity
			WHERE id =: idOportunidad
		];
		Opportunity opp = lstOportunidades[0];
		
		// Actualizar datos de la oportunidad con respecto a las consultas
		Double cantidadConsultas = (opp.Consultas_realizadas__c == null) ? 0 : opp.Consultas_realizadas__c;
		Double nuevoNumeroConsulta = contarConsulta ? cantidadConsultas + 1 : cantidadConsultas;
		if (mensajeError.length() > 0) {
			opp.Observaciones_estado_consulta__c = 'Error en última consulta: ' + mensajeError;
		}
		else {
			opp.Observaciones_estado_consulta__c = '';
			if (esConsultaInterna && contarConsulta) {
				opp.Consultas_realizadas__c = nuevoNumeroConsulta;
			}
		}
		if ((maxConsultas > 0) && (nuevoNumeroConsulta >= maxConsultas)) {
			opp.Estado_Consulta__c = 'Cantidad de consultas agotadas';
		}
		else {
			opp.Estado_Consulta__c = 'Disponible para consulta';
		}
		update opp;
		
		if (crearRespuesta && esConsultaInterna) {
			Resultado_Prevalidador__c objRespuesta = new Resultado_Prevalidador__c();
	 		objRespuesta.Oportunidad__c = idOportunidad;
	 		if (ex != null) {
				objRespuesta.Log_Error__c = ex.getMessage() + ' [' + ex.getStackTraceString() + ']';
	 		}
	 		objRespuesta.LogRespuesta__c = textoRespuesta;
	 		insert objRespuesta;
		}
		
		return nuevoNumeroConsulta;
	}
	
}