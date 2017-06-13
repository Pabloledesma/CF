trigger InformacionFinanciera_trg2 on Informacion_financiera__c (before insert) {

	Id idRadicacion = trigger.new[0].Radicacion_de_credito__c;
	Radicacion_de_credito__c objRadicacion = [
		SELECT Solicitud_de_credito__c
		FROM Radicacion_de_credito__c
		WHERE Id = :idRadicacion
		limit 1
	];
	if (objRadicacion == null)
		return;

	Id idSolicitud = objRadicacion.Solicitud_de_credito__c;
	List<Solicitud_de_credito__c> lstSolicitudes = [
		SELECT Oportunidad__c, Cliente_deudor__c, Codeudor_1__c, Codeudor_2__c, Codeudor_3__c
		FROM Solicitud_de_credito__c
		WHERE Id = :idSolicitud
	];
	if (lstSolicitudes.size() == 0)
		return;
	Solicitud_de_credito__c objSolicitud = lstSolicitudes[0];

	// Buscar datos del cliente deudor
	Id idOpp = objSolicitud.Oportunidad__c;
	Resultado_Prevalidador__c objResultado;
	List<Resultado_Prevalidador__c> lstResultados = [
		SELECT Id, Score_Data__c, Numero_de_consultas__c
		FROM Resultado_Prevalidador__c
		WHERE Oportunidad__c = :idOpp
		  AND Cliente__c = :objSolicitud.Cliente_deudor__c
		ORDER BY CreatedDate DESC
	];
	if (lstResultados.size() > 0) {
		objResultado = lstResultados[0];
		if (objResultado.Score_Data__c != null) {
			trigger.new[0].Puntaje_score_central_de_riesgo__c = Decimal.valueOf(objResultado.Score_Data__c);
		}
		trigger.new[0].No_de_consultas_ultimos_seis_meses__c = objResultado.Numero_de_consultas__c;
	}

	// Buscar datos del codeudor1
	lstResultados = [
		SELECT Id, Score_Data__c, Numero_de_consultas__c
		FROM Resultado_Prevalidador__c
		WHERE Oportunidad__c = :idOpp
		  AND Cliente__c = :objSolicitud.Codeudor_1__c
		ORDER BY CreatedDate DESC
	];
	if (lstResultados.size() > 0) {
		objResultado = lstResultados[0];
		if (objResultado.Score_Data__c != null) {
			trigger.new[0].Puntaje_score_central_codeudor1__c = Decimal.valueOf(objResultado.Score_Data__c);
		}
		trigger.new[0].No_de_consultas_ultimos_seis_codeudor1__c = objResultado.Numero_de_consultas__c;
	}

	// Buscar datos del codeudor2
	lstResultados = [
		SELECT Id, Score_Data__c, Numero_de_consultas__c
		FROM Resultado_Prevalidador__c
		WHERE Oportunidad__c = :idOpp
		  AND Cliente__c = :objSolicitud.Codeudor_2__c
		ORDER BY CreatedDate DESC
	];
	if (lstResultados.size() > 0) {
		objResultado = lstResultados[0];
		if (objResultado.Score_Data__c != null) {
			trigger.new[0].Puntaje_score_central_codeudor2__c = Decimal.valueOf(objResultado.Score_Data__c);
		}
		trigger.new[0].No_de_consultas_ultimos_seis_codeudor2__c = objResultado.Numero_de_consultas__c;
	}

	// Buscar datos del codeudor3
	lstResultados = [
		SELECT Id, Score_Data__c, Numero_de_consultas__c
		FROM Resultado_Prevalidador__c
		WHERE Oportunidad__c = :idOpp
		  AND Cliente__c = :objSolicitud.Codeudor_3__c
		ORDER BY CreatedDate DESC
	];
	if (lstResultados.size() > 0) {
		objResultado = lstResultados[0];
		if (objResultado.Score_Data__c != null) {
			trigger.new[0].Puntaje_score_central_codeudor3__c = Decimal.valueOf(objResultado.Score_Data__c);
		}
		trigger.new[0].No_de_consultas_ultimos_seis_codeudor3__c = objResultado.Numero_de_consultas__c;
	}

}