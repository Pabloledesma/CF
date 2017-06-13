trigger ResultadoPrevalidador_tgr on Resultado_Prevalidador__c (after insert) {

	// Obtener oportunidad asociada al Resultado del Prevalidador
	Resultado_Prevalidador__c resultado = trigger.new[0];
	Id idOportunidad = resultado.Oportunidad__c;

	// Buscar última Solicitud de Crédito de la oportunidad
	List<Solicitud_de_credito__c> lstSolicitudes = [
		SELECT Id
		FROM Solicitud_de_credito__c
		WHERE Oportunidad__c = :idOportunidad
		ORDER BY CreatedDate DESC
	];
	if (lstSolicitudes.size() == 0)
		return;
	Solicitud_de_credito__c objSolicitud = lstSolicitudes[0];
	
	// Buscar última Radicación de Crédito de la Solicitud de Crédito
	List<Radicacion_de_credito__c> lstRadicaciones = [
		SELECT Id
		FROM Radicacion_de_credito__c
		WHERE Solicitud_de_credito__c = :objSolicitud.Id
		ORDER BY CreatedDate DESC
	];
	if (lstRadicaciones.size() == 0)
		return;
	Radicacion_de_credito__c objRadicacion = lstRadicaciones[0];

	// Buscar última Información Financiera de la Radicación de Crédito
	List<Informacion_financiera__c> lstInformaciones = [
		SELECT Id, Cliente_deudor__c, Codeudor_1__c, Codeudor_2__c, Codeudor_3__c,
			   Puntaje_score_central_de_riesgo__c, No_de_consultas_ultimos_seis_meses__c,
			   Puntaje_score_central_codeudor1__c, No_de_consultas_ultimos_seis_codeudor1__c,
			   Puntaje_score_central_codeudor2__c, No_de_consultas_ultimos_seis_codeudor2__c,
			   Puntaje_score_central_codeudor3__c, No_de_consultas_ultimos_seis_codeudor3__c
		FROM Informacion_financiera__c
		WHERE Radicacion_de_credito__c = :objRadicacion.Id
		ORDER BY CreatedDate DESC
	];
	if (lstInformaciones.size() == 0)
		return;
	Informacion_financiera__c objInformacion = lstInformaciones[0];

	if (resultado.Score_Data__c != null) {
		if (resultado.Cliente__c == objInformacion.Cliente_deudor__c) {
			objInformacion.Puntaje_score_central_de_riesgo__c = Decimal.valueOf(resultado.Score_Data__c);
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_1__c) {
			objInformacion.Puntaje_score_central_codeudor1__c = Decimal.valueOf(resultado.Score_Data__c);
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_2__c) {
			objInformacion.Puntaje_score_central_codeudor2__c = Decimal.valueOf(resultado.Score_Data__c);
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_3__c) {
			objInformacion.Puntaje_score_central_codeudor3__c = Decimal.valueOf(resultado.Score_Data__c);
		}
	}

	if (resultado.Numero_de_consultas__c != null) {
		if (resultado.Cliente__c == objInformacion.Cliente_deudor__c) {
			objInformacion.No_de_consultas_ultimos_seis_meses__c = resultado.Numero_de_consultas__c;
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_1__c) {
			objInformacion.No_de_consultas_ultimos_seis_codeudor1__c = resultado.Numero_de_consultas__c;
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_2__c) {
			objInformacion.No_de_consultas_ultimos_seis_codeudor2__c = resultado.Numero_de_consultas__c;
		}
		else if (resultado.Cliente__c == objInformacion.Codeudor_3__c) {
			objInformacion.No_de_consultas_ultimos_seis_codeudor3__c = resultado.Numero_de_consultas__c;
		}
	}
	
	update objInformacion;

}