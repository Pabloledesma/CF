@isTest
private class WSProcesadorPrevalidador_tst {

   static testMethod void myUnitTest() {

		Account cuenta = CrearCuentaDeudor();
		insert cuenta;
		String numDocumento = cuenta.Numero_de_documento__c;

		Opportunity opp = CrearOportunidad(cuenta.Id);
		insert opp;

// observaciones="Consulta exitosa"
String RespuestaCliente = '<Informes>' +
   '<Informe idOportunidad="' + opp.Id + '" montoSugerido="45690000" relacionCI="0.08" ltv="0.49088764" respuesta="Consulta exitosa" fechaConsulta="10/05/2016">' +
      '<InformeGeneral scoreIntenro="998.0" endeudamientoFinanciero="0.140818594" acierta="855.0" numDocumento="' + numDocumento + '" numConsultas="5" numTargetas="3" numCreditos="5" morasDataCredito="12" morasCifin="2" fechaListas="10/05/2016" horaListas="22:07:34" observaciones="Consulta exitosa">' +
         '<Vigia encontrado="N" error="N"/>' +
         '<DataCredito respuesta="13" encabezado="Historia de Credito+ |$Consultado por:|#Claudia Angel|#2012-09-09T21:16:17|$">' +
            '<InformacionBasica informacion="Tipo de documento |#C.C.|#Nemero |#00079792339|#Estado Del documento |#VIGENTE|#PUNTAJE|#855.0|$Nombre|#POLANIA TEATINO JORGE ORLANDO|#Rando de edad|#29 - 35|$">' +
               '<Articulo txt="Se presenta reporte negativo cuando las personas naturales efectivamente se encuetnran en mora en sus cuotas u obligaciones. Se presenta reporte positivo cuando las personas naturales estan al dia en sus obligaciones"/>' +
               '<Alertas alerta="Fuente |#Fecha|#Novedad|#Descripcien|$"/>' +
               '<Resumen perfil="Sectores |#Sector Financiero|#Sector Cooperativo|#Sector Real|#Sector Telcos|#Total Sectores|#Total como principal |#Total como codeudor y otros|$Creditos Vigentes |#4|#0|#0|#1|#5|#5|#0|$Creditos Cerrados |#11|#0|#4|#2|#17|#17|#0|$Creditos Reestructurados |#0|#0|#0|#0|#0|#0|#0|$Creditos Refinanciados |#0|#0|#0|#0|#0|#0|#0|$Consultas en los ult. 6 Meses |#3|#0|#4|#0|#7|#0|#0|$Descuentos Vigentes a la Fecha |#0|#0|#0|#0|#0|#0|#0|$Antiguedad desde |#1996-02-29|#-|#2005-09-30|#2003-02-28|#-|#-|#-|$" tendenciaEndeudamiento="Saldos y moras|#Saldos Deudas Totales en Mora (en miles)|#Saldos Deudas Totales (en miles)|#Moras mex sector Financiero |#Moras mex sector Real|#Moras mex sector Telcos|#Total Moras Meximas|#Nem credotos con mora = 30|#Nem credotos con mora = 60|$2012-06-30|#0.0|#1379.0|#N|#-|#N|#N|#0|#0|$2012-05-30|#0.0|#8038.0|#N|#-|#N|#N|#0|#0|$2012-04-30|#0.0|#8294.0|#N|#-|#N|#N|#0|#0|$2012-03-30|#0.0|#8153.0|#N|#-|#N|#N|#0|#0|$2012-02-29|#0.0|#7657.0|#N|#N|#N|#N|#0|#0|$2012-01-29|#0.0|#4478.0|#N|#N|#N|#N|#0|#0|$2011-12-29|#0.0|#4801.0|#N|#N|#N|#N|#0|#0|$2011-11-29|#0.0|#5121.0|#N|#N|#N|#N|#0|#0|$2011-10-29|#0.0|#5320.0|#N|#N|#N|#N|#0|#0|$2011-09-29|#0.0|#5745.0|#N|#N|#N|#N|#0|#0|$2011-08-29|#0.0|#5940.0|#N|#N|#N|#N|#0|#0|$2011-07-29|#0.0|#6234.0|#N|#N|#N|#N|#0|#0|$"/>' +
               '<EndeudamientoActual>' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="Cartera|#CAB|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#10000.0|#1379.0|#0.0|#153.0|#60.98|#13.79|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera=""/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="Cartera|#CTC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorTelcos>' +
               '</EndeudamientoActual>' +
               '<AbiertasVigentes encabezado="Entidad informante|#Tipo Cuenta|#Nem Cta 9 dijitos |#Calf|#Estado de la Obligacion |#Fecha Actualizacion|#47 meses|#Adjetivo-fecha|#Fecha Apertura |#Fecha Vencimiento |#Mora Maxima |#Desacuerdos con la inform.|#Estado del Titular |#Marca/Clase|#Tipo Garantia|#Vlr o Cupo inicial|#Saldo Actual (Miles $)|#Saldos en Mora |#Valor Cuota (Miles $)|#Fechas Limite Pago|#Fechas del Pago|#Perm.|#No. Cheq Devueltos|#Cuotas/M /Vigenccia|#% deuda|#Oficina / Deudor|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="CITIBANK       COLOMBIA|#TDC|#004014039|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CITIBANK       COLOMBIA|#TDC|#006261002|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CREDIFACIL     COLPATRIA|#TDC|#079792339|#A|#AL DIA|#2012-06-30|#NN--------------------------------------------- |#-|#2005-08-30|#2049-12-31|#0|#-|#Normal|#Privada/Otra|#SIN GAR|#2250000.0 |#0.0|#0.0|#0.0|#-|#-|#-|#-|#- de -/-/-|#0.0|#BOGOTA CARRERA/Deudor Principal|$BCO DE BOGOTA|#CAB|#A07510177|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN |#-|#2007-12-18|#2013-01-05|#0|#-|#Normal|#-/-|#SIN GAR|#-|#1379000.0|#0.0|#153000.0|#-|#2012-06-15|#0|#-|#29 de 37/M/-|#0.0|#ANTIGUO COUNTRY/Deudor Principal|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="BANCOOMEVA|#CBR|#279792339|#AA|#AL DIA|#2012-02-29|#NNNNNNNNNNNN----------------------------------- |#-|#2011-02-10|#2013-02-20|#0|#-|#Otra|#-/D|#OTR GAR|#-|#0.0|#0.0|#153000.0|#2012-03-20|#2012-01-17|#0|#-|#0 de 24/M/-|#0.0|#OFICINA ZONA INDUSTRIAL-BOGOTA/Deudor Principal|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#.01214449|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNN----------------------------------- |#-|#2011-06-20|#2011-08-06|#1|#-|#Normal|#-/D|#SIN GAR|#-|#-1|#0.0|#0.0|#-|#-|#0|#-|#0 de 0/M/-|#0.0|#-|$"/>' +
                  '</SectorTelcos>' +
               '</AbiertasVigentes>' +
               '<CerradasInactivas encabezado="Entidad Informante |#Tipo Cuenta |#Estado de la Obligacion|#Calf|#Adjetivo Fecha|#Num Cta 9 digitos |#47 meses|#Fecha Apertura|#Fecha Cierre|#Vrl o cupo inicial |#Ciudad Fecha|#oficina/Deudor |#Desacuerdo con la inform.|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="BANCO DE       OCCIDENTE S.A.|#TDC|#-|#A|#-|#965957391|#NN-NNNNN--------------------------------------- |#2009-07-31|#2010-04-30|#-1 |#2014-07-31|#-|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#001941768|#-NNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2004-10-31|#2006-11-30|#-|#2008-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#006033966|#-NNNNNNN--------------------------------------- |#2006-03-31|#2006-11-30|#-|#2010-05-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#097441004|#N---N-N-NNN-NNNNNNNNNNN------------------------ |#1996-02-29|#1999-10-31|#-|#1999-10-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#054060871|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN- |#1997-08-31|#2008-10-31|#-|#2008-09-30|#NO INFORMO/Deudor Principal|#-|$BCO DE BOGOTA|#TDC|#-|#A|#-|#002807607|#----------------------------------------------- |#2009-08-31|#2009-08-31|#-|#2014-11-30|#NO INFORMO/Deudor Principal|#-|$CREDENCIAL|#TDC|#-|#A|#-|#378148009|#NN-NNNNN--------------------------------------- |#2009-08-31|#2010-04-30|#-1 |#2013-08-31|#-|#-|$BANCO          PICHINCHA S.A.|#CAB|#-|#-|#-|#000158811|#NNNNNNNNNNNNNNNNNN----------------------------- |#2001-03-31|#2002-09-30|#-|#2002-09-30|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#410045036|#NN--------------------------------------------- |#2003-10-31|#2003-12-31|#-|#2006-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#756004611|#NNNNNNNNNNNNNNNNNNN--NNNN---------------------- |#2006-11-30|#2008-12-31|#-|#2008-11-30|#-|#-|$BCO DE BOGOTA|#CAB|#-|#A|#-|#A00709000|#----------------------------------------------- |#2007-12-18|#2009-12-31|#-|#2013-01-05|#ANTIGUO COUNTRY/Deudor Principal|#-|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="CODENSA HOGAR|#CON|#-|#A|#-|#758896880|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#758896890|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#785316840|#NNNNNNNNNNNN----------------------------------- |#2007-07-31|#2008-07-31|#-|#2008-07-31|#-|#-|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#CANCEL. MM|#A|#-|#.25463173|#NNNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2003-02-28|#2005-10-31|#-|#2003-04-30|#NO INFORMO/Deudor Principal|#-|$MOVISTAR|#CTC|#-|#A|#-|#005995800|#NN-N------------------------------------------- |#2008-04-30|#2008-08-31|#-|#2010-12-31|#-|#-|$"/>' +
                  '</SectorTelcos>' +
               '</CerradasInactivas>' +
               '<HistoriaConsultas historico="Fecha Ult. Consulta|#Consultante|#No. De Consultas mes|$2012-09-09|#CREDIFAMILIA|#03|$2012-07-06|#CREDIFAMILIA|#01|$2012-05-25|#BCO AVVILLAS   COMERCIAL|#01|$2012-05-14|#BC CAJA SOCIAL BCSC|#01|$2012-01-31|#CITIBANK       COLOMBIA|#01|$"/>' +
            '</InformacionBasica>' +
         '</DataCredito>' +
         '<Cifin respuesta="02" encabezado="INFORMACION COMERCIALCIFIN |$ Consultado por.|#COMF CREDIFAMILIA CF-COMPAÑIA DE FI|#Fecha|#31/03/2016|$Claudia Angel|#Hora|#12:06:59|$">' +
            '<InformacionBasica informacion="Tipo de documento|#C.C.|#Numero|#80725458|#Estado Del documento|#VIGENTE|#No. Informe|#02629239330260566617|$Nombre|#MENESES         BERMUDEZ      JULIAN|#Rando de edad|#31-35|#CIIU|#|$"/>' +
            '<Resumen cabecera="|#Tarjetas de Credito:|#Sector Financiero:|#Sector Real:|#SUBTOTAL PRINCIPAL|#Tarjetas de Credito:|#Sector Financiero:|#Sector Real:|#SUBTOTAL CODEUDOR|#Total|$" totales="Cant|#3|#4|#2|#9|#-|#-|#-|#-|#9|$Saldo Total|#13730|#4034|#3200|#20964|#-|#-|#-|#-|#20964|$Pade|#65|#19|#15|#100|#-|#-|#-|#-|#100|$" alDia="Cant|#3|#2|#2|#7|#-|#-|#-|#-|#7|$Saldo Total|#13730|#1852|#3200|#18782|#-|#-|#-|#-|#18782|$Cuota|#322|#52|#116|#490|#-|#-|#-|#-|#490|$" enMora="Cant|#0|#2|#0|#2|#-|#-|#-|#-|#2|$Saldo Total|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$Cuota|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$Valor en mora|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$"/>' +
            '<InformeDetallado cabezera="Fecha corte|#Tipo contrato|#No. Cuenta|#Estado|#Tipo ENT|#Entidad|#Ciudad|#Sucursal|#Fecha Apertura|$Cupo sobregiro|#Dias autor|#Fecha permanencia|#Che Devueltos Ultimo Mes|$">' +
               '<InformacionCuentas>' +
                  '<Vigentes cuenta="31/01/2016|#CTE-INDIVIDUAL|#021481|#NORMA|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#OFICINA TORRE RE|#10/08/2015|#500|#45|#|#0|$31/01/2016|#AHO-INDIVIDUAL|#548354|#NORMA|#BCO|#DAVIVIENDA S.A.|#BOGOTA|#OF.DORADO PLAZA|#23/07/2013|#|#|#|#|$29/02/2016|#AHO-INDIVIDUAL|#222957|#NORMA|#BCO|#BBVA  COLOMBIA|#BOGOTA|#EL  NOGAL|#09/11/2015|#|#|#|#|$29/02/2016|#AHO-INDIVIDUAL|#803922|#INACT|#BCO|#AV VILLAS|#BOGOTA|#SANTA BARBARA|#04/05/2010|#|#|#|#|$"/>' +
                  '<NoVigentes cuenta="31/12/2015|#AHO-INDIVIDUAL|#560038|#SVOL|#BCO|#BANCOLOMBIA|#BOGOTA|#WORLD TRADE CENT|#23/09/2015|#|#|#|#|$"/>' +
               '</InformacionCuentas>' +
            '</InformeDetallado>' +
            '<SectorFinanciero encabezado="FECHA CORTE|#MODA|#No. OBLIG|#TIPO-ENT|#NOMBRE ENTIDAD|#CIUDAD|#CAL|#MRC|#TIPO- GAR|#F INICIO|#PAC|# PAG|# MOR|#CUPO APROBVLR INIC|#PAGO MINIMVLR CUOTA|#SIT OBLIG|#NATU REES|#No. REE|#TIP PAG|#F PAGOF EXTIN|$TIPO CONT|#PADE|#LCRE|#EST. CONTR|#CLF|#ORIGEN CARTERA|#SUCURSAL|#EST TITU|#CLS|#COB GAR|$F TERM|#PER|#CUPO UTILISALDO CORT|#VALOR MORA|#REES|#MOR MAX|#MOD EXT|#F PERMAN|#Comportamientos |$">' +
               '<AlDia cuenta="31/01/2016|#CONS|#874810|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#-|#NOID|#10/08/2015|#84|#0|#0|#2000|#52|#VIGE|#|#|#|#|#CRE|#10|#ROTA|#VIGE|#A|#|#DEPTO  BANCA  PE|#NORM|#-|#0|#31/12/2030|#MEN|#1852|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$31/01/2016|#CONS|#021481|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#-|#NOID|#20/10/2015|#1|#0|#0|#500|#0|#VIGE|#|#|#|#|#CRE|#0|#SOBR|#VIGE|#A|#|#OFICINA TORRE RE|#NORM|#-|#|#04/12/2015|#VNC|#0|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N ||$29/02/2016|#CONS|#725458|#BCO|#CREDIFACIL COLPATRIA|#BOGOTA|#PRIN|#MAS|#-|#16/11/2006|#|#|#0|#5300|#161|#VIGE|#|#0|#|#|#CRE|#4|#TCR|#VIGE|#-|#-|#BOGOTA CARRERA D|#NORM|#CDS|#-|#-|#-|#754|#0|#NO|#|#|#|#N |N |N |N |X |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$31/01/2016|#CONS|#964168|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#CRE|#-|#18/08/2015|#|#|#0|#4000|#161|#VIGE|#|#0|#|#|#CRE|#21|#TCR|#VIGE|#-|#-|#OFICINA TORRE RE|#NORM|#COR|#-|#-|#-|#3719|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$31/01/2016|#CONS|#866425|#BCO|#BANCO CORPBANCA  - HELM|#BOGOTA|#PRIN|#MAS|#-|#18/08/2015|#|#|#0|#10000|#0|#VIGE|#|#0|#|#|#CRE|#52|#TCR|#VIGE|#-|#-|#OFICINA TORRE RE|#NORM|#NAI|#-|#-|#-|#9257|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$"/>' +
               '<Extinguidas cuenta="31/10/2007|#CONS|#017787|#COOP|#COOPCAFAM    LTDA|#BOGOTA|#PRIN|#-|#NOID|#23/06/2007|#|#3|#|#800|#73|#SALD|#|#|#|#|#CRE|#|#ROTA|#|#|#|#OFICINA  FLOREST|#|#-|#|#30/06/2008|#MEN|#0|#0|#|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |X |N ||$31/05/2014|#CONS|#1805KV|#BCO|#AV VILLAS|#BOGOTA|#PRIN|#-|#|#04/05/2010|#48|#48|#0|#10100|#0|#SALD|#|#|#VOL|#|#CRE|#|#ORDI|#NVIG|#|#|#EL CASTILLO|#OTRO|#-|#|#02/06/2014|#MEN|#0|#0|#NO|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$01/11/2011|#CONS|#817151|#BCO|#CITIBANK|#BOGOTA|#PRIN|#NOE|#-|#07/04/2009|#|#|#|#2800|#157|#CROB|#|#|#|#|#CRE|#|#TCR|#|#-|#-|#BOGOTA PRINCIPAL|#NORM|#NOE|#-|#-|#-|#|#0|#|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |R |R |R |R |R |R |R |R |R |R |R |R |N ||$07/10/2009|#CONS|#746868|#BCO|#DE BOGOTA|#BOGOTA|#PRIN|#CRE|#-|#19/01/2009|#|#|#|#0|#0|#CVOL|#|#|#|#|#CRE|#|#TCR|#|#-|#-|#ALIANZA PORVENIR|#|#CLA|#-|#-|#-|#0|#0|#|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Mora cuenta="28/11/2013|#CONS|#817021|#OACE|#REINTEGRA SAS|#BOGOTA|#PRIN|#-|#OTRA|#23/04/2010|#|#|#0|#2000|#878|#CAST|#|#|#|#|#CRE|#5|#OTRO|#VIGE|#K|#|#CENTRO FINANCIER|#NORM|#-|#0|#01/12/2014|#MEN|#878|#878|#NO|#|#|#|#N |N |N |N |X |X |X |N |N |N |N |N |2 |3 |3 |5 |6 |7 |7 |8 |10|11|12|12||$28/11/2013|#CONS|#596593|#OACE|#REINTEGRA SAS|#BOGOTA|#PRIN|#-|#OTRA|#23/04/2010|#|#|#0|#2000|#1304|#CAST|#|#|#|#|#CRE|#7|#OTRO|#VIGE|#K|#|#CENTRO FINANCIER|#NORM|#-|#0|#01/12/2014|#MEN|#1304|#1304|#NO|#|#|#|#N |N |N |N |N |N |N |N |N |N |1 |2 |4 |5 |5 |7 |8 |9 |7 |8 |9 |10|11|12||$"/>' +
            '</SectorFinanciero>' +
            '<SectorReal encabezado="FECHA CORTE|#TIPO CONT|#No. OBLIG|#NOMBRE ENTIDAD|#CIUDAD|#CALD|#VIG|#CLA PER|#F INICIO|#PAC|# PAG|# MOR|#CUPO APROBVLR INIC|#PAGO MINIMVLR  CUOTA|#SIT OBLIG|#TIPAG|#REF|#F PAGOF EXTIN|#CATELCRE|#EST. CONTR|#TIPO EMPR|#SUCURSAL|#EST TITU|#MES|#F TERM|#PER|#CUPO UTILISALDO CORT|#VALOR CARGO FIJO|#VALOR MORA|#MOD EXT|#MOR MAX|#F PERMAN|#Comportamientos |$">' +
               '<AlDia cuenta="29/02/2016|#CRE|#942800|#FINANZAUTO S.A.|#BOGOTA|#PRIN|#DEF|#0|#05/05/2014|#60|#22|#0|#22851|#116|#VIGE|#|#NO|#|#VEHI|#VIGE|#CPMM|#OF PRINCIPAL PTE|#|#-|#05/05/2019|#MEN|#-|#0|#0|#|#|#|#|  |N |N |N |N |N |N |N |N |N |R |N |N |N |N |N |N |N |N |N |N |N |N ||$29/02/2016|#SRV|#923271|#COLOMBIA MOVIL ESP|#BOGOTA|#PRIN|#IND|#|#05/10/2012|#0|#0|#0|#0|#0|#VIGE|#|#NO|#|#TELC|#VIGE|#COMU|#BOGOTA|#|#-|#-|#MEN|#-|#0|#0|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Extinguidas cuenta="31/03/2011|#SRV|#131350|#COMCEL - COMUNICACION CELULAR|#BOGOTA|#PRIN|#IND|#0|#11/10/2007|#0|#0|#0|#0|#0|#SALD|#|#NO|#|#TELC|#NVIG|#CCEL|#CREDITO Y ACTIVA|#|#-|#-|#MEN|#-|#0|#0|#|#|#|#|  |  |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Mora cuenta=""/>' +
            '</SectorReal>' +
            '<Huella huella="Entidad|#Fecha|#Sucursal|#Ciudad|$CREDIFAMILIA CF-COMPAÑIA DE FI|#30/03/2016|#DIRECCION GENERA|#BOGOTA|$CREDIFAMILIA CF-COMPAÑIA DE FI|#23/03/2016|#DIRECCION GENERA|#BOGOTA|$CREDIFAMILIA CF-COMPAÑIA DE FI|#22/01/2016|#DIRECCION GENERA|#BOGOTA|$"/>' +
         '</Cifin>' +
      '</InformeGeneral>' +
   '</Informe>' +
'</Informes>';
 
		WSProcesadorPrevalidador.ProcesarRespuestaCliente(RespuestaCliente);

// observaciones="EC-01: Espere un momento mientras se restablece la conexion de cliente DATACREDITO"
RespuestaCliente = '<Informes>' +
   '<Informe idOportunidad="' + opp.Id + '" montoSugerido="45690000" relacionCI="0.08" ltv="0.49088764" respuesta="Consulta exitosa" fechaConsulta="10/05/2016">' +
      '<InformeGeneral scoreIntenro="998.0" endeudamientoFinanciero="0.140818594" acierta="855.0" numDocumento="' + numDocumento + '" numConsultas="5" numTargetas="3" numCreditos="5" morasDataCredito="12" morasCifin="2" fechaListas="10/05/2016" horaListas="22:07:34" observaciones="EC-01: Espere un momento mientras se restablece la conexion de cliente DATACREDITO">' +
         '<Vigia encontrado="N" error="N"/>' +
         '<DataCredito respuesta="13" encabezado="Historia de Credito+ |$Consultado por:|#Claudia Angel|#2012-09-09T21:16:17|$">' +
            '<InformacionBasica informacion="Tipo de documento |#C.C.|#Nemero |#00079792339|#Estado Del documento |#VIGENTE|#PUNTAJE|#855.0|$Nombre|#POLANIA TEATINO JORGE ORLANDO|#Rando de edad|#29 - 35|$">' +
               '<Articulo txt="Se presenta reporte negativo cuando las personas naturales efectivamente se encuetnran en mora en sus cuotas u obligaciones. Se presenta reporte positivo cuando las personas naturales estan al dia en sus obligaciones"/>' +
               '<Alertas alerta="Fuente |#Fecha|#Novedad|#Descripcien|$"/>' +
               '<Resumen perfil="Sectores |#Sector Financiero|#Sector Cooperativo|#Sector Real|#Sector Telcos|#Total Sectores|#Total como principal |#Total como codeudor y otros|$Creditos Vigentes |#4|#0|#0|#1|#5|#5|#0|$Creditos Cerrados |#11|#0|#4|#2|#17|#17|#0|$Creditos Reestructurados |#0|#0|#0|#0|#0|#0|#0|$Creditos Refinanciados |#0|#0|#0|#0|#0|#0|#0|$Consultas en los ult. 6 Meses |#3|#0|#4|#0|#7|#0|#0|$Descuentos Vigentes a la Fecha |#0|#0|#0|#0|#0|#0|#0|$Antiguedad desde |#1996-02-29|#-|#2005-09-30|#2003-02-28|#-|#-|#-|$" tendenciaEndeudamiento="Saldos y moras|#Saldos Deudas Totales en Mora (en miles)|#Saldos Deudas Totales (en miles)|#Moras mex sector Financiero |#Moras mex sector Real|#Moras mex sector Telcos|#Total Moras Meximas|#Nem credotos con mora = 30|#Nem credotos con mora = 60|$2012-06-30|#0.0|#1379.0|#N|#-|#N|#N|#0|#0|$2012-05-30|#0.0|#8038.0|#N|#-|#N|#N|#0|#0|$2012-04-30|#0.0|#8294.0|#N|#-|#N|#N|#0|#0|$2012-03-30|#0.0|#8153.0|#N|#-|#N|#N|#0|#0|$2012-02-29|#0.0|#7657.0|#N|#N|#N|#N|#0|#0|$2012-01-29|#0.0|#4478.0|#N|#N|#N|#N|#0|#0|$2011-12-29|#0.0|#4801.0|#N|#N|#N|#N|#0|#0|$2011-11-29|#0.0|#5121.0|#N|#N|#N|#N|#0|#0|$2011-10-29|#0.0|#5320.0|#N|#N|#N|#N|#0|#0|$2011-09-29|#0.0|#5745.0|#N|#N|#N|#N|#0|#0|$2011-08-29|#0.0|#5940.0|#N|#N|#N|#N|#0|#0|$2011-07-29|#0.0|#6234.0|#N|#N|#N|#N|#0|#0|$"/>' +
               '<EndeudamientoActual>' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="Cartera|#CAB|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#10000.0|#1379.0|#0.0|#153.0|#60.98|#13.79|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera=""/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="Cartera|#CTC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorTelcos>' +
               '</EndeudamientoActual>' +
               '<AbiertasVigentes encabezado="Entidad informante|#Tipo Cuenta|#Nem Cta 9 dijitos |#Calf|#Estado de la Obligacion |#Fecha Actualizacion|#47 meses|#Adjetivo-fecha|#Fecha Apertura |#Fecha Vencimiento |#Mora Maxima |#Desacuerdos con la inform.|#Estado del Titular |#Marca/Clase|#Tipo Garantia|#Vlr o Cupo inicial|#Saldo Actual (Miles $)|#Saldos en Mora |#Valor Cuota (Miles $)|#Fechas Limite Pago|#Fechas del Pago|#Perm.|#No. Cheq Devueltos|#Cuotas/M /Vigenccia|#% deuda|#Oficina / Deudor|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="CITIBANK       COLOMBIA|#TDC|#004014039|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CITIBANK       COLOMBIA|#TDC|#006261002|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CREDIFACIL     COLPATRIA|#TDC|#079792339|#A|#AL DIA|#2012-06-30|#NN--------------------------------------------- |#-|#2005-08-30|#2049-12-31|#0|#-|#Normal|#Privada/Otra|#SIN GAR|#2250000.0 |#0.0|#0.0|#0.0|#-|#-|#-|#-|#- de -/-/-|#0.0|#BOGOTA CARRERA/Deudor Principal|$BCO DE BOGOTA|#CAB|#A07510177|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN |#-|#2007-12-18|#2013-01-05|#0|#-|#Normal|#-/-|#SIN GAR|#-|#1379000.0|#0.0|#153000.0|#-|#2012-06-15|#0|#-|#29 de 37/M/-|#0.0|#ANTIGUO COUNTRY/Deudor Principal|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="BANCOOMEVA|#CBR|#279792339|#AA|#AL DIA|#2012-02-29|#NNNNNNNNNNNN----------------------------------- |#-|#2011-02-10|#2013-02-20|#0|#-|#Otra|#-/D|#OTR GAR|#-|#0.0|#0.0|#153000.0|#2012-03-20|#2012-01-17|#0|#-|#0 de 24/M/-|#0.0|#OFICINA ZONA INDUSTRIAL-BOGOTA/Deudor Principal|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#.01214449|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNN----------------------------------- |#-|#2011-06-20|#2011-08-06|#1|#-|#Normal|#-/D|#SIN GAR|#-|#-1|#0.0|#0.0|#-|#-|#0|#-|#0 de 0/M/-|#0.0|#-|$"/>' +
                  '</SectorTelcos>' +
               '</AbiertasVigentes>' +
               '<CerradasInactivas encabezado="Entidad Informante |#Tipo Cuenta |#Estado de la Obligacion|#Calf|#Adjetivo Fecha|#Num Cta 9 digitos |#47 meses|#Fecha Apertura|#Fecha Cierre|#Vrl o cupo inicial |#Ciudad Fecha|#oficina/Deudor |#Desacuerdo con la inform.|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="BANCO DE       OCCIDENTE S.A.|#TDC|#-|#A|#-|#965957391|#NN-NNNNN--------------------------------------- |#2009-07-31|#2010-04-30|#-1 |#2014-07-31|#-|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#001941768|#-NNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2004-10-31|#2006-11-30|#-|#2008-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#006033966|#-NNNNNNN--------------------------------------- |#2006-03-31|#2006-11-30|#-|#2010-05-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#097441004|#N---N-N-NNN-NNNNNNNNNNN------------------------ |#1996-02-29|#1999-10-31|#-|#1999-10-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#054060871|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN- |#1997-08-31|#2008-10-31|#-|#2008-09-30|#NO INFORMO/Deudor Principal|#-|$BCO DE BOGOTA|#TDC|#-|#A|#-|#002807607|#----------------------------------------------- |#2009-08-31|#2009-08-31|#-|#2014-11-30|#NO INFORMO/Deudor Principal|#-|$CREDENCIAL|#TDC|#-|#A|#-|#378148009|#NN-NNNNN--------------------------------------- |#2009-08-31|#2010-04-30|#-1 |#2013-08-31|#-|#-|$BANCO          PICHINCHA S.A.|#CAB|#-|#-|#-|#000158811|#NNNNNNNNNNNNNNNNNN----------------------------- |#2001-03-31|#2002-09-30|#-|#2002-09-30|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#410045036|#NN--------------------------------------------- |#2003-10-31|#2003-12-31|#-|#2006-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#756004611|#NNNNNNNNNNNNNNNNNNN--NNNN---------------------- |#2006-11-30|#2008-12-31|#-|#2008-11-30|#-|#-|$BCO DE BOGOTA|#CAB|#-|#A|#-|#A00709000|#----------------------------------------------- |#2007-12-18|#2009-12-31|#-|#2013-01-05|#ANTIGUO COUNTRY/Deudor Principal|#-|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="CODENSA HOGAR|#CON|#-|#A|#-|#758896880|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#758896890|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#785316840|#NNNNNNNNNNNN----------------------------------- |#2007-07-31|#2008-07-31|#-|#2008-07-31|#-|#-|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#CANCEL. MM|#A|#-|#.25463173|#NNNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2003-02-28|#2005-10-31|#-|#2003-04-30|#NO INFORMO/Deudor Principal|#-|$MOVISTAR|#CTC|#-|#A|#-|#005995800|#NN-N------------------------------------------- |#2008-04-30|#2008-08-31|#-|#2010-12-31|#-|#-|$"/>' +
                  '</SectorTelcos>' +
               '</CerradasInactivas>' +
               '<HistoriaConsultas historico="Fecha Ult. Consulta|#Consultante|#No. De Consultas mes|$2012-09-09|#CREDIFAMILIA|#03|$2012-07-06|#CREDIFAMILIA|#01|$2012-05-25|#BCO AVVILLAS   COMERCIAL|#01|$2012-05-14|#BC CAJA SOCIAL BCSC|#01|$2012-01-31|#CITIBANK       COLOMBIA|#01|$"/>' +
            '</InformacionBasica>' +
         '</DataCredito>' +
         '<Cifin respuesta="02" encabezado="INFORMACION COMERCIALCIFIN |$ Consultado por.|#COMF CREDIFAMILIA CF-COMPAÑIA DE FI|#Fecha|#31/03/2016|$Claudia Angel|#Hora|#12:06:59|$">' +
            '<InformacionBasica informacion="Tipo de documento|#C.C.|#Numero|#80725458|#Estado Del documento|#VIGENTE|#No. Informe|#02629239330260566617|$Nombre|#MENESES         BERMUDEZ      JULIAN|#Rando de edad|#31-35|#CIIU|#|$"/>' +
            '<Resumen cabecera="|#Tarjetas de Credito:|#Sector Financiero:|#Sector Real:|#SUBTOTAL PRINCIPAL|#Tarjetas de Credito:|#Sector Financiero:|#Sector Real:|#SUBTOTAL CODEUDOR|#Total|$" totales="Cant|#3|#4|#2|#9|#-|#-|#-|#-|#9|$Saldo Total|#13730|#4034|#3200|#20964|#-|#-|#-|#-|#20964|$Pade|#65|#19|#15|#100|#-|#-|#-|#-|#100|$" alDia="Cant|#3|#2|#2|#7|#-|#-|#-|#-|#7|$Saldo Total|#13730|#1852|#3200|#18782|#-|#-|#-|#-|#18782|$Cuota|#322|#52|#116|#490|#-|#-|#-|#-|#490|$" enMora="Cant|#0|#2|#0|#2|#-|#-|#-|#-|#2|$Saldo Total|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$Cuota|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$Valor en mora|#0|#2182|#0|#2182|#-|#-|#-|#-|#2182|$"/>' +
            '<InformeDetallado cabezera="Fecha corte|#Tipo contrato|#No. Cuenta|#Estado|#Tipo ENT|#Entidad|#Ciudad|#Sucursal|#Fecha Apertura|$Cupo sobregiro|#Dias autor|#Fecha permanencia|#Che Devueltos Ultimo Mes|$">' +
               '<InformacionCuentas>' +
                  '<Vigentes cuenta="31/01/2016|#CTE-INDIVIDUAL|#021481|#NORMA|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#OFICINA TORRE RE|#10/08/2015|#500|#45|#|#0|$31/01/2016|#AHO-INDIVIDUAL|#548354|#NORMA|#BCO|#DAVIVIENDA S.A.|#BOGOTA|#OF.DORADO PLAZA|#23/07/2013|#|#|#|#|$29/02/2016|#AHO-INDIVIDUAL|#222957|#NORMA|#BCO|#BBVA  COLOMBIA|#BOGOTA|#EL  NOGAL|#09/11/2015|#|#|#|#|$29/02/2016|#AHO-INDIVIDUAL|#803922|#INACT|#BCO|#AV VILLAS|#BOGOTA|#SANTA BARBARA|#04/05/2010|#|#|#|#|$"/>' +
                  '<NoVigentes cuenta="31/12/2015|#AHO-INDIVIDUAL|#560038|#SVOL|#BCO|#BANCOLOMBIA|#BOGOTA|#WORLD TRADE CENT|#23/09/2015|#|#|#|#|$"/>' +
               '</InformacionCuentas>' +
            '</InformeDetallado>' +
            '<SectorFinanciero encabezado="FECHA CORTE|#MODA|#No. OBLIG|#TIPO-ENT|#NOMBRE ENTIDAD|#CIUDAD|#CAL|#MRC|#TIPO- GAR|#F INICIO|#PAC|# PAG|# MOR|#CUPO APROBVLR INIC|#PAGO MINIMVLR CUOTA|#SIT OBLIG|#NATU REES|#No. REE|#TIP PAG|#F PAGOF EXTIN|$TIPO CONT|#PADE|#LCRE|#EST. CONTR|#CLF|#ORIGEN CARTERA|#SUCURSAL|#EST TITU|#CLS|#COB GAR|$F TERM|#PER|#CUPO UTILISALDO CORT|#VALOR MORA|#REES|#MOR MAX|#MOD EXT|#F PERMAN|#Comportamientos |$">' +
               '<AlDia cuenta="31/01/2016|#CONS|#874810|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#-|#NOID|#10/08/2015|#84|#0|#0|#2000|#52|#VIGE|#|#|#|#|#CRE|#10|#ROTA|#VIGE|#A|#|#DEPTO  BANCA  PE|#NORM|#-|#0|#31/12/2030|#MEN|#1852|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$31/01/2016|#CONS|#021481|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#-|#NOID|#20/10/2015|#1|#0|#0|#500|#0|#VIGE|#|#|#|#|#CRE|#0|#SOBR|#VIGE|#A|#|#OFICINA TORRE RE|#NORM|#-|#|#04/12/2015|#VNC|#0|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N ||$29/02/2016|#CONS|#725458|#BCO|#CREDIFACIL COLPATRIA|#BOGOTA|#PRIN|#MAS|#-|#16/11/2006|#|#|#0|#5300|#161|#VIGE|#|#0|#|#|#CRE|#4|#TCR|#VIGE|#-|#-|#BOGOTA CARRERA D|#NORM|#CDS|#-|#-|#-|#754|#0|#NO|#|#|#|#N |N |N |N |X |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$31/01/2016|#CONS|#964168|#BCO|#BANCO CORPBANCA - HELM|#BOGOTA|#PRIN|#CRE|#-|#18/08/2015|#|#|#0|#4000|#161|#VIGE|#|#0|#|#|#CRE|#21|#TCR|#VIGE|#-|#-|#OFICINA TORRE RE|#NORM|#COR|#-|#-|#-|#3719|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$31/01/2016|#CONS|#866425|#BCO|#BANCO CORPBANCA  - HELM|#BOGOTA|#PRIN|#MAS|#-|#18/08/2015|#|#|#0|#10000|#0|#VIGE|#|#0|#|#|#CRE|#52|#TCR|#VIGE|#-|#-|#OFICINA TORRE RE|#NORM|#NAI|#-|#-|#-|#9257|#0|#NO|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N ||$"/>' +
               '<Extinguidas cuenta="31/10/2007|#CONS|#017787|#COOP|#COOPCAFAM    LTDA|#BOGOTA|#PRIN|#-|#NOID|#23/06/2007|#|#3|#|#800|#73|#SALD|#|#|#|#|#CRE|#|#ROTA|#|#|#|#OFICINA  FLOREST|#|#-|#|#30/06/2008|#MEN|#0|#0|#|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |X |N ||$31/05/2014|#CONS|#1805KV|#BCO|#AV VILLAS|#BOGOTA|#PRIN|#-|#|#04/05/2010|#48|#48|#0|#10100|#0|#SALD|#|#|#VOL|#|#CRE|#|#ORDI|#NVIG|#|#|#EL CASTILLO|#OTRO|#-|#|#02/06/2014|#MEN|#0|#0|#NO|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$01/11/2011|#CONS|#817151|#BCO|#CITIBANK|#BOGOTA|#PRIN|#NOE|#-|#07/04/2009|#|#|#|#2800|#157|#CROB|#|#|#|#|#CRE|#|#TCR|#|#-|#-|#BOGOTA PRINCIPAL|#NORM|#NOE|#-|#-|#-|#|#0|#|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |R |R |R |R |R |R |R |R |R |R |R |R |N ||$07/10/2009|#CONS|#746868|#BCO|#DE BOGOTA|#BOGOTA|#PRIN|#CRE|#-|#19/01/2009|#|#|#|#0|#0|#CVOL|#|#|#|#|#CRE|#|#TCR|#|#-|#-|#ALIANZA PORVENIR|#|#CLA|#-|#-|#-|#0|#0|#|#|#|#|#|  |  |  |  |  |  |  |  |  |  |  |  |  |  |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Mora cuenta="28/11/2013|#CONS|#817021|#OACE|#REINTEGRA SAS|#BOGOTA|#PRIN|#-|#OTRA|#23/04/2010|#|#|#0|#2000|#878|#CAST|#|#|#|#|#CRE|#5|#OTRO|#VIGE|#K|#|#CENTRO FINANCIER|#NORM|#-|#0|#01/12/2014|#MEN|#878|#878|#NO|#|#|#|#N |N |N |N |X |X |X |N |N |N |N |N |2 |3 |3 |5 |6 |7 |7 |8 |10|11|12|12||$28/11/2013|#CONS|#596593|#OACE|#REINTEGRA SAS|#BOGOTA|#PRIN|#-|#OTRA|#23/04/2010|#|#|#0|#2000|#1304|#CAST|#|#|#|#|#CRE|#7|#OTRO|#VIGE|#K|#|#CENTRO FINANCIER|#NORM|#-|#0|#01/12/2014|#MEN|#1304|#1304|#NO|#|#|#|#N |N |N |N |N |N |N |N |N |N |1 |2 |4 |5 |5 |7 |8 |9 |7 |8 |9 |10|11|12||$"/>' +
            '</SectorFinanciero>' +
            '<SectorReal encabezado="FECHA CORTE|#TIPO CONT|#No. OBLIG|#NOMBRE ENTIDAD|#CIUDAD|#CALD|#VIG|#CLA PER|#F INICIO|#PAC|# PAG|# MOR|#CUPO APROBVLR INIC|#PAGO MINIMVLR  CUOTA|#SIT OBLIG|#TIPAG|#REF|#F PAGOF EXTIN|#CATELCRE|#EST. CONTR|#TIPO EMPR|#SUCURSAL|#EST TITU|#MES|#F TERM|#PER|#CUPO UTILISALDO CORT|#VALOR CARGO FIJO|#VALOR MORA|#MOD EXT|#MOR MAX|#F PERMAN|#Comportamientos |$">' +
               '<AlDia cuenta="29/02/2016|#CRE|#942800|#FINANZAUTO S.A.|#BOGOTA|#PRIN|#DEF|#0|#05/05/2014|#60|#22|#0|#22851|#116|#VIGE|#|#NO|#|#VEHI|#VIGE|#CPMM|#OF PRINCIPAL PTE|#|#-|#05/05/2019|#MEN|#-|#0|#0|#|#|#|#|  |N |N |N |N |N |N |N |N |N |R |N |N |N |N |N |N |N |N |N |N |N |N ||$29/02/2016|#SRV|#923271|#COLOMBIA MOVIL ESP|#BOGOTA|#PRIN|#IND|#|#05/10/2012|#0|#0|#0|#0|#0|#VIGE|#|#NO|#|#TELC|#VIGE|#COMU|#BOGOTA|#|#-|#-|#MEN|#-|#0|#0|#|#|#|#N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Extinguidas cuenta="31/03/2011|#SRV|#131350|#COMCEL - COMUNICACION CELULAR|#BOGOTA|#PRIN|#IND|#0|#11/10/2007|#0|#0|#0|#0|#0|#SALD|#|#NO|#|#TELC|#NVIG|#CCEL|#CREDITO Y ACTIVA|#|#-|#-|#MEN|#-|#0|#0|#|#|#|#|  |  |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N |N ||$"/>' +
               '<Mora cuenta=""/>' +
            '</SectorReal>' +
            '<Huella huella="Entidad|#Fecha|#Sucursal|#Ciudad|$CREDIFAMILIA CF-COMPAÑIA DE FI|#30/03/2016|#DIRECCION GENERA|#BOGOTA|$CREDIFAMILIA CF-COMPAÑIA DE FI|#23/03/2016|#DIRECCION GENERA|#BOGOTA|$CREDIFAMILIA CF-COMPAÑIA DE FI|#22/01/2016|#DIRECCION GENERA|#BOGOTA|$"/>' +
         '</Cifin>' +
      '</InformeGeneral>' +
   '</Informe>' +
'</Informes>';

		WSProcesadorPrevalidador.ProcesarRespuestaCliente(RespuestaCliente);


// origen="datacredito"
RespuestaCliente = '<Informes>' +
   '<Informe idOportunidad="' + opp.Id + '" origen="datacredito" montoSugerido="45690000" relacionCI="0.08" ltv="0.49088764" respuesta="Consulta exitosa" fechaConsulta="10/05/2016">' +
      '<InformeGeneral scoreIntenro="998.0" endeudamientoFinanciero="0.140818594" acierta="855.0" numDocumento="' + numDocumento + '" numConsultas="5" numTargetas="3" numCreditos="5" morasDataCredito="12" morasCifin="2" fechaListas="10/05/2016" horaListas="22:07:34" observaciones="Consulta exitosa">' +
         '<Vigia encontrado="N" error="N"/>' +
         '<DataCredito respuesta="13" encabezado="Historia de Credito+ |$Consultado por:|#Claudia Angel|#2012-09-09T21:16:17|$">' +
            '<InformacionBasica informacion="Tipo de documento |#C.C.|#Nemero |#00079792339|#Estado Del documento |#VIGENTE|#PUNTAJE|#855.0|$Nombre|#POLANIA TEATINO JORGE ORLANDO|#Rando de edad|#29 - 35|$">' +
               '<Articulo txt="Se presenta reporte negativo cuando las personas naturales efectivamente se encuetnran en mora en sus cuotas u obligaciones. Se presenta reporte positivo cuando las personas naturales estan al dia en sus obligaciones"/>' +
               '<Alertas alerta="Fuente |#Fecha|#Novedad|#Descripcien|$"/>' +
               '<Resumen perfil="Sectores |#Sector Financiero|#Sector Cooperativo|#Sector Real|#Sector Telcos|#Total Sectores|#Total como principal |#Total como codeudor y otros|$Creditos Vigentes |#4|#0|#0|#1|#5|#5|#0|$Creditos Cerrados |#11|#0|#4|#2|#17|#17|#0|$Creditos Reestructurados |#0|#0|#0|#0|#0|#0|#0|$Creditos Refinanciados |#0|#0|#0|#0|#0|#0|#0|$Consultas en los ult. 6 Meses |#3|#0|#4|#0|#7|#0|#0|$Descuentos Vigentes a la Fecha |#0|#0|#0|#0|#0|#0|#0|$Antiguedad desde |#1996-02-29|#-|#2005-09-30|#2003-02-28|#-|#-|#-|$" tendenciaEndeudamiento="Saldos y moras|#Saldos Deudas Totales en Mora (en miles)|#Saldos Deudas Totales (en miles)|#Moras mex sector Financiero |#Moras mex sector Real|#Moras mex sector Telcos|#Total Moras Meximas|#Nem credotos con mora = 30|#Nem credotos con mora = 60|$2012-06-30|#0.0|#1379.0|#N|#-|#N|#N|#0|#0|$2012-05-30|#0.0|#8038.0|#N|#-|#N|#N|#0|#0|$2012-04-30|#0.0|#8294.0|#N|#-|#N|#N|#0|#0|$2012-03-30|#0.0|#8153.0|#N|#-|#N|#N|#0|#0|$2012-02-29|#0.0|#7657.0|#N|#N|#N|#N|#0|#0|$2012-01-29|#0.0|#4478.0|#N|#N|#N|#N|#0|#0|$2011-12-29|#0.0|#4801.0|#N|#N|#N|#N|#0|#0|$2011-11-29|#0.0|#5121.0|#N|#N|#N|#N|#0|#0|$2011-10-29|#0.0|#5320.0|#N|#N|#N|#N|#0|#0|$2011-09-29|#0.0|#5745.0|#N|#N|#N|#N|#0|#0|$2011-08-29|#0.0|#5940.0|#N|#N|#N|#N|#0|#0|$2011-07-29|#0.0|#6234.0|#N|#N|#N|#N|#0|#0|$"/>' +
               '<EndeudamientoActual>' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="Cartera|#CAB|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#10000.0|#1379.0|#0.0|#153.0|#60.98|#13.79|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#AA|#3200.0|#0.0|#0.0|#0.0|#19.51|#0.00|$Cartera|#TDC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera=""/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="Cartera|#CTC|$calidad |#Nem|#Estado actual |#Claf|#Vlr o cupo inicial |#Saldo actual|#Saldo en Mora|#Valor Cuota|#% Part|#% Deuda|$Principal|#1|#Al dÃÂ­a|#A|#0.0|#0.0|#0.0|#0.0|#0.00|#NaN|$"/>' +
                  '</SectorTelcos>' +
               '</EndeudamientoActual>' +
               '<AbiertasVigentes encabezado="Entidad informante|#Tipo Cuenta|#Nem Cta 9 dijitos |#Calf|#Estado de la Obligacion |#Fecha Actualizacion|#47 meses|#Adjetivo-fecha|#Fecha Apertura |#Fecha Vencimiento |#Mora Maxima |#Desacuerdos con la inform.|#Estado del Titular |#Marca/Clase|#Tipo Garantia|#Vlr o Cupo inicial|#Saldo Actual (Miles $)|#Saldos en Mora |#Valor Cuota (Miles $)|#Fechas Limite Pago|#Fechas del Pago|#Perm.|#No. Cheq Devueltos|#Cuotas/M /Vigenccia|#% deuda|#Oficina / Deudor|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="CITIBANK       COLOMBIA|#TDC|#004014039|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CITIBANK       COLOMBIA|#TDC|#006261002|#AA|#AL DIA|#2012-06-29|#NNNNN------------------------------------------ |#-|#2012-01-31|#2016-01-31|#0|#-|#Normal|#-/Clasica|#SIN GAR|#3200000.0 |#0.0|#0.0|#0.0|#2012-06-19|#2012-06-26|#-|#-|#- de -/-/-|#0.0|#PRQ. CENTRAL BAVARIA (PN)/Deudor Principal|$CREDIFACIL     COLPATRIA|#TDC|#079792339|#A|#AL DIA|#2012-06-30|#NN--------------------------------------------- |#-|#2005-08-30|#2049-12-31|#0|#-|#Normal|#Privada/Otra|#SIN GAR|#2250000.0 |#0.0|#0.0|#0.0|#-|#-|#-|#-|#- de -/-/-|#0.0|#BOGOTA CARRERA/Deudor Principal|$BCO DE BOGOTA|#CAB|#A07510177|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN |#-|#2007-12-18|#2013-01-05|#0|#-|#Normal|#-/-|#SIN GAR|#-|#1379000.0|#0.0|#153000.0|#-|#2012-06-15|#0|#-|#29 de 37/M/-|#0.0|#ANTIGUO COUNTRY/Deudor Principal|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="BANCOOMEVA|#CBR|#279792339|#AA|#AL DIA|#2012-02-29|#NNNNNNNNNNNN----------------------------------- |#-|#2011-02-10|#2013-02-20|#0|#-|#Otra|#-/D|#OTR GAR|#-|#0.0|#0.0|#153000.0|#2012-03-20|#2012-01-17|#0|#-|#0 de 24/M/-|#0.0|#OFICINA ZONA INDUSTRIAL-BOGOTA/Deudor Principal|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#.01214449|#A|#AL DIA|#2012-06-30|#NNNNNNNNNNNN----------------------------------- |#-|#2011-06-20|#2011-08-06|#1|#-|#Normal|#-/D|#SIN GAR|#-|#-1|#0.0|#0.0|#-|#-|#0|#-|#0 de 0/M/-|#0.0|#-|$"/>' +
                  '</SectorTelcos>' +
               '</AbiertasVigentes>' +
               '<CerradasInactivas encabezado="Entidad Informante |#Tipo Cuenta |#Estado de la Obligacion|#Calf|#Adjetivo Fecha|#Num Cta 9 digitos |#47 meses|#Fecha Apertura|#Fecha Cierre|#Vrl o cupo inicial |#Ciudad Fecha|#oficina/Deudor |#Desacuerdo con la inform.|$">' +
                  '<SectorFinanciero>' +
                     '<Cartera cartera="BANCO DE       OCCIDENTE S.A.|#TDC|#-|#A|#-|#965957391|#NN-NNNNN--------------------------------------- |#2009-07-31|#2010-04-30|#-1 |#2014-07-31|#-|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#001941768|#-NNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2004-10-31|#2006-11-30|#-|#2008-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#TDC|#-|#-|#-|#006033966|#-NNNNNNN--------------------------------------- |#2006-03-31|#2006-11-30|#-|#2010-05-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#097441004|#N---N-N-NNN-NNNNNNNNNNN------------------------ |#1996-02-29|#1999-10-31|#-|#1999-10-31|#NO INFORMO/Deudor Principal|#-|$BCO DAVIVIENDA F|#TDC|#-|#A|#-|#054060871|#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN- |#1997-08-31|#2008-10-31|#-|#2008-09-30|#NO INFORMO/Deudor Principal|#-|$BCO DE BOGOTA|#TDC|#-|#A|#-|#002807607|#----------------------------------------------- |#2009-08-31|#2009-08-31|#-|#2014-11-30|#NO INFORMO/Deudor Principal|#-|$CREDENCIAL|#TDC|#-|#A|#-|#378148009|#NN-NNNNN--------------------------------------- |#2009-08-31|#2010-04-30|#-1 |#2013-08-31|#-|#-|$BANCO          PICHINCHA S.A.|#CAB|#-|#-|#-|#000158811|#NNNNNNNNNNNNNNNNNN----------------------------- |#2001-03-31|#2002-09-30|#-|#2002-09-30|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#410045036|#NN--------------------------------------------- |#2003-10-31|#2003-12-31|#-|#2006-10-31|#NO INFORMO/Deudor Principal|#-|$BCO COLPATRIA|#CAB|#-|#-|#-|#756004611|#NNNNNNNNNNNNNNNNNNN--NNNN---------------------- |#2006-11-30|#2008-12-31|#-|#2008-11-30|#-|#-|$BCO DE BOGOTA|#CAB|#-|#A|#-|#A00709000|#----------------------------------------------- |#2007-12-18|#2009-12-31|#-|#2013-01-05|#ANTIGUO COUNTRY/Deudor Principal|#-|$"/>' +
                  '</SectorFinanciero>' +
                  '<SectorReal>' +
                     '<Cartera cartera="CODENSA HOGAR|#CON|#-|#A|#-|#758896880|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#758896890|#NNNNNNNNNNNN----------------------------------- |#2005-09-30|#2006-09-30|#-|#2006-09-30|#NO INFORMO/Deudor Principal|#-|$CODENSA HOGAR|#CON|#-|#A|#-|#785316840|#NNNNNNNNNNNN----------------------------------- |#2007-07-31|#2008-07-31|#-|#2008-07-31|#-|#-|$"/>' +
                  '</SectorReal>' +
                  '<SectorTelcos>' +
                     '<Cartera cartera="COMCEL S.A.|#CTC|#CANCEL. MM|#A|#-|#.25463173|#NNNNNNNNNNNNNNNNNNNNNNNN----------------------- |#2003-02-28|#2005-10-31|#-|#2003-04-30|#NO INFORMO/Deudor Principal|#-|$MOVISTAR|#CTC|#-|#A|#-|#005995800|#NN-N------------------------------------------- |#2008-04-30|#2008-08-31|#-|#2010-12-31|#-|#-|$"/>' +
                  '</SectorTelcos>' +
               '</CerradasInactivas>' +
               '<HistoriaConsultas historico="Fecha Ult. Consulta|#Consultante|#No. De Consultas mes|$2012-09-09|#CREDIFAMILIA|#03|$2012-07-06|#CREDIFAMILIA|#01|$2012-05-25|#BCO AVVILLAS   COMERCIAL|#01|$2012-05-14|#BC CAJA SOCIAL BCSC|#01|$2012-01-31|#CITIBANK       COLOMBIA|#01|$"/>' +
            '</InformacionBasica>' +
         '</DataCredito>' +
      '</InformeGeneral>' +
   '</Informe>' +
'</Informes>';

		WSProcesadorPrevalidador.ProcesarRespuestaCliente(RespuestaCliente);

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
		cuenta.Tipo_de_contrato__c = 'Término indefinido';
		cuenta.Ciudad_de_residencia__c = 'Bogotá';
		cuenta.Fecha_de_nacimiento__c = Date.newInstance(1970, 2, 2);
		cuenta.Fecha_de_ingreso_a_empleo_actual__c = Date.newInstance(2010, 3, 3);
		cuenta.Actividad_economica__c = 'Comercio';
		cuenta.Check_VIGIA__c = true;
        cuenta.Numero_de_telefono_celular__c='1111111111';
        cuenta.Validar_numero_de_celular__c='11111';
		
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
      opp.Cliente_deudor__c = idCuenta;
		
		return opp;
    }

}