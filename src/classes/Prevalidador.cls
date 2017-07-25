global class Prevalidador {

    webservice static string GenerarPDFs(Id idRespuesta, Id idDatacredito, Id idCifin) {

            List<Resultado_Prevalidador__c> lstResultados = [
                SELECT PDFs_Generados__c FROM Resultado_Prevalidador__c WHERE Id = :idRespuesta
            ];
            if (lstResultados.size() == 0)
                return 'Error generando PDFs: No se encontró el Resultado del Prevalidador';
                
            Resultado_Prevalidador__c objResultado = lstResultados[0];
            if (objResultado.PDFs_Generados__c)
                return 'Los PDFs ya fueron generados';

            // Generar y guardar el PDF de Datacredito
            PageReference pagePdf;
            Blob pdfPageBlob;
            Attachment objAttachment;
            if (idDatacredito != null) {
                pagePdf = new PageReference('/apex/ResultadoConsultaDatacredito');
                pagePdf.getParameters().put('id', idDatacredito);
                pdfPageBlob = pagePdf.getContentAsPDF();
                objAttachment = new Attachment(Body = pdfPageBlob, ParentID = idRespuesta, Name = 'Datacredito.pdf');
                insert objAttachment;
            }

            // Generar y guardar el PDF de Cifin
            if (idCifin != null) {
                pagePdf = new PageReference('/apex/ResultadoConsultaCIFIN');
                pagePdf.getParameters().put('id', idCifin);
                pdfPageBlob = pagePdf.getContentAsPDF();
                objAttachment = new Attachment(Body = pdfPageBlob, ParentID = idRespuesta, Name = 'Cifin.pdf');
                insert objAttachment;
            }
            
            objResultado.PDFs_Generados__c = true;
            update objResultado;

            return 'ok';
    }

    webservice static string ValidarConsultaInterna(Id idOportunidad) {
        
        String respuesta = ValidarDatosObligatorios(idOportunidad);
        if (respuesta != 'ok')
            return respuesta;
            
        respuesta = ValidarCantidadConsultas(idOportunidad);
        return respuesta;

    }

    public static string ValidarDatosObligatorios(Id idOportunidad) {

        // Buscar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT Tipo_de_producto__c, Asignacion_de_cupo__c, Valor_del_inmueble__c, Amount, Numero_de_vivienda__c,
                   Tipo_de_vivienda__c, Ingresos_Familiares__c, Estado_Consulta__c, AccountId,
                   Codeudor_1__c, Codeudor_2__c, Codeudor_3__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];
        
        // Validar datos de la oportunidad
        if (String.isBlank(opp.Tipo_de_producto__c) ||
            String.isBlank(opp.Asignacion_de_cupo__c) ||
            (opp.Valor_del_inmueble__c == null) ||
            (opp.Amount == null) ||
            String.isBlank(opp.Numero_de_vivienda__c) ||
            String.isBlank(opp.Tipo_de_vivienda__c) ||
            (opp.Ingresos_Familiares__c == null) ||
            String.isBlank(opp.Estado_Consulta__c)
           )
            return 'Faltan datos de la oportunidad necesarios para realizar la consulta.';

        // Buscar datos del deudor (cuenta de la oportunidad)
        List<Account> lstCuentas = [
            SELECT FirstName, LastName, Sexo__c, Tipo_de_documento__c, Numero_de_documento__c, Edad__c, Estado_civil__c,
                   Ciudad_de_radicacion__c, Tipo_de_ocupacion__c, Actividad_economica__c, Fecha_de_ingreso_a_empleo_actual__c,
                   Tipo_de_contrato__c, Personas_a_cargo__c
            FROM Account
            WHERE id =: opp.AccountId
        ];
        Account cuenta = lstCuentas[0];

        // Validar datos del deudor
        if (String.isBlank(cuenta.FirstName) ||
            String.isBlank(cuenta.LastName) ||
            String.isBlank(cuenta.Sexo__c) ||
            String.isBlank(cuenta.Tipo_de_documento__c) ||
            String.isBlank(cuenta.Numero_de_documento__c) ||
            (cuenta.Edad__c == null) ||
            String.isBlank(cuenta.Estado_civil__c) ||
            String.isBlank(cuenta.Ciudad_de_radicacion__c) ||
            String.isBlank(cuenta.Tipo_de_ocupacion__c) ||
            String.isBlank(cuenta.Actividad_economica__c) ||
            (cuenta.Fecha_de_ingreso_a_empleo_actual__c == null) ||
            String.isBlank(cuenta.Tipo_de_contrato__c) ||
            String.isBlank(cuenta.Personas_a_cargo__c)
           )
            return 'Faltan datos del deudor necesarios para realizar la consulta.';

        // Validar datos de los codeudores
        String respuesta;
        if (opp.Codeudor_1__c != null) {
            respuesta = ValidarDatosCodeudor(opp.Codeudor_1__c);
            if (respuesta != 'ok')
                return respuesta;
        }
        if (opp.Codeudor_2__c != null) {
            respuesta = ValidarDatosCodeudor(opp.Codeudor_2__c);
            if (respuesta != 'ok')
                return respuesta;
        }
        if (opp.Codeudor_3__c != null) {
            respuesta = ValidarDatosCodeudor(opp.Codeudor_3__c);
            if (respuesta != 'ok')
                return respuesta;
        }

        return 'ok';
    }

    public static String ValidarDatosCodeudor(Id idCodeudor) {
        
        List<Account> lstCuentas = [
            SELECT FirstName, LastName, Sexo__c, Tipo_de_documento__c, Numero_de_documento__c, Edad__c, Estado_civil__c,
                   Ciudad_de_radicacion__c, Tipo_de_ocupacion__c, Lugar_de_nacimiento__c, Aporta_ingresos__c
            FROM Account
            WHERE id =: idCodeudor
        ];
        Account cuenta = lstCuentas[0];

        if (String.isBlank(cuenta.FirstName) ||
            String.isBlank(cuenta.LastName) ||
            String.isBlank(cuenta.Sexo__c) ||
            String.isBlank(cuenta.Tipo_de_documento__c) ||
            String.isBlank(cuenta.Numero_de_documento__c) ||
            (cuenta.Edad__c == null) ||
            String.isBlank(cuenta.Estado_civil__c) ||
            String.isBlank(cuenta.Ciudad_de_radicacion__c) ||
            String.isBlank(cuenta.Tipo_de_ocupacion__c) ||
            String.isBlank(cuenta.Lugar_de_nacimiento__c) ||
            String.isBlank(cuenta.Aporta_ingresos__c)
           )
            return 'Faltan datos del codeudor necesarios para realizar la consulta.';

        return 'ok';    
    }

    public static string ValidarCantidadConsultas(Id idOportunidad) {

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        Integer MaxConsultas = (Integer)conf.Cantidad_Consultas_Permitidas__c;

        // Consultar cantidad de consultas realizadas
        List<Opportunity> lstOportunidades = [
            SELECT Consultas_realizadas__c, Estado_Consulta__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];

        // Validar estado de la consulta y que haya consultas disponibles
        if ((MaxConsultas > 0) && (opp.Consultas_realizadas__c >= MaxConsultas)) {
            return 'Ya no se pueden realizar más consultas sobre esta oportunidad.';
        }
        else if (opp.Estado_Consulta__c != 'Disponible para consulta') {
            return 'Ya hay una consulta en proceso. Por favor espere la respuesta para realizar otra.';
        }
        else {
//          opp.Consultas_realizadas__c = opp.Consultas_realizadas__c + 1;
            opp.Estado_Consulta__c = 'Esperando respuesta Consulta Interna';
            update opp;
            return 'ok';
        }
    }

    webservice static string ValidarEstadoDatacredito(Id idOportunidad) {

        // Consultar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT Estado_Consulta__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];
        
        // Validar estado de la consulta
        if ((opp.Estado_Consulta__c != 'Disponible para consulta') && (opp.Estado_Consulta__c != 'Cantidad de consultas agotadas')) {
            return 'Ya hay una consulta en proceso. Por favor espere la respuesta para realizar otra.';
        }
        else {
            opp.Estado_Consulta__c = 'Esperando respuesta Datacrédito';
            update opp;
            return 'ok';
        }
    }

    webservice static string ValidarEstadoCIFIN(Id idOportunidad) {

        // Consultar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT Estado_Consulta__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];
        
        // Validar estado de la consulta
        if ((opp.Estado_Consulta__c != 'Disponible para consulta') && (opp.Estado_Consulta__c != 'Cantidad de consultas agotadas')) {
            return 'Ya hay una consulta en proceso. Por favor espere la respuesta para realizar otra.';
        }
        else {
            opp.Estado_Consulta__c = 'Esperando respuesta CIFIN';
            update opp;
            return 'ok';
        }
    }
    
    webservice static string ValidarConsultaInternaPasivos(Id idOportunidad) {

        // Buscar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT OwnerId, AccountId, Tipo_de_producto__c, Tipo_de_persona__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];

        // Si el tipo de producto es CDT y el cliente es una persona jurídica...
        if ((opp.Tipo_de_producto__c == 'CDT') && (opp.Tipo_de_persona__c == 'Jurídica')) {
            
            // Buscar representante legal de la oportunidad
            List<Persona__c> lstPersonas = [
                SELECT Nombre__c
                FROM Persona__c
                WHERE Tipo__c =: 'Representante Legal'
                  AND Oportunidad__c =: opp.Id
            ];
            if (lstPersonas.size() == 0) {
                return 'Para realizar una consulta de un CDT de persona jurídica, la oportunidad debe tener una persona de tipo Representante Legal';
            }
            
            // Buscar socios de la oportunidad
            lstPersonas = [
                SELECT Nombre__c
                FROM Persona__c
                WHERE Tipo__c =: 'Socio'
                  AND Oportunidad__c =: opp.Id
            ];
            if (lstPersonas.size() == 0) {
                return 'Para realizar una consulta de un CDT de persona jurídica, la oportunidad debe tener por lo menos una persona de tipo Socio';
            }
        }

        return 'ok';            
    }

    webservice static string RealizarConsultaInternaPasivos(Id idOportunidad) {

        HttpRequest req = ConstruirRequestConsultaInternaPasivos(idOportunidad);
        Http http = new Http();
        HttpResponse resp = http.send(req);

//      return resp.getBody();
//      return parametro;
        return req.getBody(); // SOAP;
    }

    public static HttpRequest ConstruirRequestConsultaInternaPasivos(Id idOportunidad) {

        // Buscar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT OwnerId, AccountId, Tipo_de_producto__c, Tipo_de_persona__c
            FROM Opportunity
            WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];
        
        // Buscar datos del propietario
        List<User> lstUsuarios = [
            SELECT User.Name, User.Email FROM User WHERE id =: opp.OwnerId
        ];
        User usuario = lstUsuarios[0];

        // Construir nodos principales
        DOM.Document doc = new DOM.Document();
        dom.XmlNode nodoInformes = doc.createRootElement('Informes', '', '');
        dom.Xmlnode nodoInforme = nodoInformes.addChildElement('Informe', '', '');
        nodoInforme.setAttribute('idOportunidad', opp.Id);
        if (opp.Tipo_de_producto__c == 'CDT') {
            nodoInforme.setAttribute('tipoProducto', opp.Tipo_de_producto__c + ' ' + opp.Tipo_de_persona__c);
        }
        else {
            nodoInforme.setAttribute('tipoProducto', opp.Tipo_de_producto__c);
        }       
        nodoInforme.setAttribute('correoTramitador', usuario.Email);
        nodoInforme.setAttribute('nombreTramitador', usuario.Name);
        nodoInforme.setAttribute('fechaValidacion', '');

        // Si el cliente es una persona natural...
//      if (opp.Tipo_de_persona__c == 'Natural') {

            // Buscar datos del cliente (cuenta de la oportunidad)
            List<Account> lstCuentas = [
                SELECT FirstName, LastName, Numero_de_documento__c, Tipo_de_documento__c, Check_VIGIA__c
                FROM Account
                WHERE id =: opp.AccountId
            ];
            Account cuenta = lstCuentas[0];

            // Construir nodo con datos del cliente
            dom.Xmlnode nodoPrincipal = nodoInforme.addChildElement('Cliente', '', '');
            nodoPrincipal.setAttribute('nombre', EliminarCaracteresEspeciales(cuenta.FirstName));
            nodoPrincipal.setAttribute('apellidos', EliminarCaracteresEspeciales(cuenta.LastName));
            nodoPrincipal.setAttribute('tipoDocumento', EliminarCaracteresEspeciales(cuenta.Tipo_de_documento__c));
            nodoPrincipal.setAttribute('numDocumento', cuenta.Numero_de_documento__c);
            nodoPrincipal.setAttribute('consultaVigia', String.valueOf(cuenta.Check_VIGIA__c));
//      }

        // Si el cliente es una persona jurídica...
        if (opp.Tipo_de_persona__c == 'Jurídica') {
            
            // Buscar representante legal de la oportunidad
            List<Persona__c> lstPersonas = [
                SELECT Nombre__c, Apellidos__c, Tipo_de_Documento__c, Numero_de_documento__c, Check_VIGIA__c,
                       NIT_de_la_entidad__c, Razon_social__c
                FROM Persona__c
                WHERE Tipo__c =: 'Representante Legal'
                  AND Oportunidad__c =: opp.Id
            ];
            Persona__c representanteLegal = lstPersonas[0];
            
            // Construir nodo con datos del representante legal
            dom.Xmlnode nodoRepLegal = nodoInforme.addChildElement('RepresentanteLegal', '', '');
            nodoRepLegal.setAttribute('nombre', EliminarCaracteresEspeciales(representanteLegal.Nombre__c));
            nodoRepLegal.setAttribute('apellidos', EliminarCaracteresEspeciales(representanteLegal.Apellidos__c));
            nodoRepLegal.setAttribute('tipoDocumento', EliminarCaracteresEspeciales(representanteLegal.Tipo_de_Documento__c));
            nodoRepLegal.setAttribute('numDocumento', representanteLegal.Numero_de_documento__c);
            nodoRepLegal.setAttribute('consultaVigia', String.valueOf(representanteLegal.Check_VIGIA__c));
            nodoRepLegal.setAttribute('razonSocial', EliminarCaracteresEspeciales(representanteLegal.Razon_social__c));
            nodoRepLegal.setAttribute('nit', EliminarCaracteresEspeciales(representanteLegal.NIT_de_la_entidad__c));
            
            // Buscar socios de la oportunidad
            lstPersonas = [
                SELECT Nombre__c, Apellidos__c, Tipo_de_Documento__c, Numero_de_documento__c, Check_VIGIA__c
                FROM Persona__c
                WHERE Tipo__c =: 'Socio'
                  AND Oportunidad__c =: opp.Id
            ];
            
            // Construir nodos con datos de los socios
            dom.Xmlnode nodoSocio;
            for (Persona__c socio : lstPersonas) {
            nodoSocio = nodoInforme.addChildElement('Socio', '', '');
                nodoSocio.setAttribute('nombre', EliminarCaracteresEspeciales(socio.Nombre__c));
                nodoSocio.setAttribute('apellidos', EliminarCaracteresEspeciales(socio.Apellidos__c));
                nodoSocio.setAttribute('tipoDocumento', EliminarCaracteresEspeciales(socio.Tipo_de_Documento__c));
                nodoSocio.setAttribute('numDocumento', socio.Numero_de_documento__c);
                nodoSocio.setAttribute('consultaVigia', String.valueOf(socio.Check_VIGIA__c));
            }
        }

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        String URLWSPrevalidador = conf.URL_WS_Prevalidador__c;

        String parametroConsultaInterna = EliminarCaracteresEspeciales(doc.toXmlString().replace(' xmlns=""', ''));
        String SOAP = ConstruirSOAP(1, parametroConsultaInterna, null);
        HttpRequest req = new HttpRequest();
//      req.setEndpoint('http://wsprevalidador.credifamilia.com/CredifamiliaServer/services/Credifamilia');
        req.setEndpoint(URLWSPrevalidador);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '');
        req.setHeader('Host', 'wsprevalidador.credifamilia.com');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(SOAP);
        
        return req;

    }
    
    webservice static string RealizarConsultaInterna(Id idOportunidad) {

        HttpRequest req = ConstruirRequestConsultaInterna(idOportunidad);
        Http http = new Http();
        HttpResponse resp = http.send(req);

//      return resp.getBody();
//      return parametro;
        return req.getBody(); // SOAP;
    }
    
    public static HttpRequest ConstruirRequestConsultaInterna(Id idOportunidad) {

        // Buscar datos de la oportunidad
        List<Opportunity> lstOportunidades = [
            SELECT Amount, Tipo_de_producto__c, Valor_del_inmueble__c, AccountId, OwnerId, Tipo_de_vivienda__c,
            Codeudor_1__c, Codeudor_2__c, Codeudor_3__c, Numero_de_vivienda__c, Ingresos_Familiares__c, Canal_de_atencion__c
            FROM Opportunity
           c WHERE id =: idOportunidad
        ];
        Opportunity opp = lstOportunidades[0];
                
        // Buscar datos del propietario
        List<User> lstUsuarios = [
            SELECT User.Name, User.Email FROM User WHERE id =: opp.OwnerId
        ];
        User usuario = lstUsuarios[0];

        // Buscar datos del deudor (cuenta de la oportunidad)
        List<Account> lstCuentas = [
            SELECT FirstName, LastName, Numero_de_documento__c, Tipo_de_documento__c, Tipo_de_ocupacion__c,
                   Sexo__c, Estado_civil__c, Personas_a_cargo__c, Tipo_de_contrato__c, Ciudad_de_radicacion__c,
                   Edad__c, Fecha_de_nacimiento__c, Fecha_de_ingreso_a_empleo_actual__c,
                   Actividad_economica__c, Check_VIGIA__c
            FROM Account
            WHERE id =: opp.AccountId
        ];
        Account cuenta = lstCuentas[0];
        Datetime FechaNacimiento = cuenta.Fecha_de_nacimiento__c;
        Datetime FechaIngresoEmpleo = cuenta.Fecha_de_ingreso_a_empleo_actual__c;
        
        // Construir nodos principales
        DOM.Document doc = new DOM.Document();
        dom.XmlNode nodoInformes = doc.createRootElement('Informes', '', '');
        dom.Xmlnode nodoInforme = nodoInformes.addChildElement('Informe', '', '');
        nodoInforme.setAttribute('idOportunidad', opp.Id);
        nodoInforme.setAttribute('tipoVivienda', opp.Tipo_de_vivienda__c == null ? '' : opp.Tipo_de_vivienda__c);
        nodoInforme.setAttribute('valorCredito', String.valueOf(opp.Amount));
        nodoInforme.setAttribute('ingresosFamiliares', opp.Ingresos_Familiares__c == null ? '' : String.valueOf(opp.Ingresos_Familiares__c));
        nodoInforme.setAttribute('tipoProducto', EliminarCaracteresEspeciales(opp.Tipo_de_producto__c));
        nodoInforme.setAttribute('valorInmueble', String.valueOf(opp.Valor_del_inmueble__c));
        nodoInforme.setAttribute('numeroVivienda', String.valueOf(opp.Numero_de_vivienda__c));
        nodoInforme.setAttribute('correoTramitador', usuario.Email);
        nodoInforme.setAttribute('nombreTramitador', usuario.Name);
        nodoInforme.setAttribute('fechaValidacion', '');
        nodoInforme.setAttribute('canalAtencion',  opp.Canal_de_atencion__c == null ? '' : opp.Canal_de_atencion__c);
        // Construir nodo del deudor
        dom.Xmlnode nodoPrincipal = nodoInforme.addChildElement('Principal', '', '');
        nodoPrincipal.setAttribute('nombre', EliminarCaracteresEspeciales(cuenta.FirstName));
        nodoPrincipal.setAttribute('apellidos', EliminarCaracteresEspeciales(cuenta.LastName));
        nodoPrincipal.setAttribute('numDocumento', cuenta.Numero_de_documento__c);
        nodoPrincipal.setAttribute('tipoDocumento', EliminarCaracteresEspeciales(cuenta.Tipo_de_documento__c));
        nodoPrincipal.setAttribute('tipoOcupacion', EliminarCaracteresEspeciales(cuenta.Tipo_de_ocupacion__c));
        nodoPrincipal.setAttribute('sexo', cuenta.Sexo__c);
        nodoPrincipal.setAttribute('estadoCivil', EliminarCaracteresEspeciales(cuenta.Estado_civil__c));
        nodoPrincipal.setAttribute('personasAcargo', cuenta.Personas_a_cargo__c == null ? '': cuenta.Personas_a_cargo__c);
        nodoPrincipal.setAttribute('tipoContrato', cuenta.Tipo_de_contrato__c == null ? '': cuenta.Tipo_de_contrato__c);
        nodoPrincipal.setAttribute('fechaIngreso', FechaIngresoEmpleo == null ? '' : FechaIngresoEmpleo.format('yyyy/MM/dd'));
        nodoPrincipal.setAttribute('consultaVigia', String.valueOf(cuenta.Check_VIGIA__c));
        nodoPrincipal.setAttribute('ciudadResidencia', cuenta.Ciudad_de_radicacion__c == null ? '' : EliminarCaracteresEspeciales(cuenta.Ciudad_de_radicacion__c));
        nodoPrincipal.setAttribute('edad', String.valueOf(cuenta.Edad__c));
        nodoPrincipal.setAttribute('actividadEconomica', cuenta.Actividad_economica__c == null ? '': cuenta.Actividad_economica__c);
        nodoPrincipal.setAttribute('ingresosMensuales', opp.Ingresos_Familiares__c == null ? '' : String.valueOf(opp.Ingresos_Familiares__c));
        
        // Construir nodos de los codeudores
        if (opp.Codeudor_1__c != null) {
            ConstruirNodoCodeudor(opp.Codeudor_1__c, nodoInforme);
        }
        if (opp.Codeudor_2__c != null) {
            ConstruirNodoCodeudor(opp.Codeudor_2__c, nodoInforme);
        }
        if (opp.Codeudor_3__c != null) {
            ConstruirNodoCodeudor(opp.Codeudor_3__c, nodoInforme);
        }

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        String URLWSPrevalidador = conf.URL_WS_Prevalidador__c;

        String parametroConsultaInterna = EliminarCaracteresEspeciales(doc.toXmlString().replace(' xmlns=""', ''));
        String SOAP = ConstruirSOAP(1, parametroConsultaInterna, null);
        HttpRequest req = new HttpRequest();
//      req.setEndpoint('http://wsprevalidador.credifamilia.com/CredifamiliaServer/services/Credifamilia');
        req.setEndpoint(URLWSPrevalidador);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '');
        req.setHeader('Host', 'wsprevalidador.credifamilia.com');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(SOAP);
        
        return req;
    }
    
    public static void ConstruirNodoCodeudor(Id idCodeudor, dom.XmlNode nodoInformes) {
        
        // Buscar datos
        List<Account> lstCuentas = [
            SELECT FirstName, LastName, Numero_de_documento__c, Tipo_de_documento__c, Aporta_ingresos__c,
                   Check_VIGIA__c, Tipo_de_ocupacion__c, Edad__c, Ciudad_de_radicacion__c
            FROM Account
            WHERE id =: idCodeudor
        ];
        Account cuenta = lstCuentas[0];
    
        // Construir nodo
        dom.Xmlnode nodoCodeudor = nodoInformes.addChildElement('Codeudor', '', '');
        nodoCodeudor.setAttribute('nombre', EliminarCaracteresEspeciales(cuenta.FirstName));
        nodoCodeudor.setAttribute('apellidos', EliminarCaracteresEspeciales(cuenta.LastName));
        nodoCodeudor.setAttribute('numDocumento', cuenta.Numero_de_documento__c);
        nodoCodeudor.setAttribute('tipoOcupacion', EliminarCaracteresEspeciales(cuenta.Tipo_de_ocupacion__c));
        nodoCodeudor.setAttribute('tipoDocumento', EliminarCaracteresEspeciales(cuenta.Tipo_de_documento__c));
        nodoCodeudor.setAttribute('aportaIngresos', cuenta.Aporta_ingresos__c == 'Si' ? 'true' : 'false');
        nodoCodeudor.setAttribute('consultaVigia', String.valueOf(cuenta.Check_VIGIA__c));
        nodoCodeudor.setAttribute('ciudadResidencia', cuenta.Ciudad_de_radicacion__c ==  null ? '' : cuenta.Ciudad_de_radicacion__c);
        nodoCodeudor.setAttribute('edad', String.valueOf(cuenta.Edad__c));
    }

    webservice static string RealizarConsultaDatacredito(Id idOportunidad) {
        HttpRequest req = ConstruirRequestConsultaDatacredito(idOportunidad);
        Http http = new Http();
        HttpResponse resp = http.send(req);
        return ''; //SOAP;
    }

    public static HttpRequest ConstruirRequestConsultaDatacredito(Id idOportunidad) {

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        String URLWSPrevalidador = conf.URL_WS_Prevalidador__c;
        
        String SOAP = ConstruirSOAP(2, '', idOportunidad);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URLWSPrevalidador);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '');
        req.setHeader('Host', 'wsprevalidador.credifamilia.com');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(SOAP);
        
        return req;
    }
    
    webservice static string RealizarConsultaCIFIN(Id idOportunidad) {
        HttpRequest req = ConstruirRequestConsultaCIFIN(idOportunidad);
        Http http = new Http();
        HttpResponse resp = http.send(req);
        return ''; //SOAP;
    }

    public static HttpRequest ConstruirRequestConsultaCIFIN(Id idOportunidad) {

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        String URLWSPrevalidador = conf.URL_WS_Prevalidador__c;
        
        String SOAP = ConstruirSOAP(3, '', idOportunidad);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URLWSPrevalidador);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '');
        req.setHeader('Host', 'wsprevalidador.credifamilia.com');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(SOAP);
        
        return req;
    }

    // tipoConsulta: 1 - Consulta Interna, 2 - Datacredito, 3 - CIFIN
    public static string ConstruirSOAP(Integer tipoConsulta, String paramConsultaInterna, Id idOportunidad) {

        DOM.Document doc = new DOM.Document();      
        dom.XmlNode nodoEnvelope = doc.createRootElement('soapenv:Envelope', '', '');
        nodoEnvelope.setAttribute('xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
        nodoEnvelope.setAttribute('xmlns:ser', 'http://server.tecnologia.credifamilia.com');

        dom.Xmlnode nodoHeader = nodoEnvelope.addChildElement('soapenv:Header', '', '');

        dom.Xmlnode nodoSecurity = nodoHeader.addChildElement('wsse:Security', '', '');
        nodoSecurity.setAttribute('xmlns:wsse', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
        nodoSecurity.setAttribute('xmlns:wsu', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');

        dom.Xmlnode nodoToken = nodoSecurity.addChildElement('wsse:UsernameToken', '', '');
        nodoToken.setAttribute('wsu:Id', 'UsernameToken-03A6A3C3E1614506C714581367055044');

        ConfiguracionPrevalidador__c conf = ConfiguracionPrevalidador__c.getOrgDefaults();
        String usuario = conf.Usuario_WS_Prevalidador__c;
        String clave = conf.Clave_WS_Prevalidador__c;

        dom.Xmlnode nodoUsername = nodoToken.addChildElement('wsse:Username', '', '');
        nodoUsername.addTextNode(usuario);
        dom.Xmlnode nodoPassword = nodoToken.addChildElement('wsse:Password', '', '');
        nodoPassword.setAttribute('Type', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText');
        nodoPassword.addTextNode(clave);

        dom.Xmlnode nodoBody = nodoEnvelope.addChildElement('soapenv:Body', '', '');

        // Consulta interna
        if (tipoConsulta == 1) {
            dom.Xmlnode nodoMetodo = nodoBody.addChildElement('ser:prevalidador', '', '');
            dom.Xmlnode nodoParametro = nodoMetodo.addChildElement('ser:query', '', '');
            nodoParametro.addTextNode('<![CDATA[' + paramConsultaInterna + ']]>');
        }
        // Datacredito
        else if (tipoConsulta == 2) {
            dom.Xmlnode nodoMetodo = nodoBody.addChildElement('ser:datacredito', '', '');
            dom.Xmlnode nodoParametro = nodoMetodo.addChildElement('ser:primerApellido', '', '');
            nodoParametro.addTextNode(idOportunidad);
            dom.Xmlnode nodoParametro2 = nodoMetodo.addChildElement('ser:identificacion', '', '');
        }
        // CIFIN
        else if (tipoConsulta == 3) {
            dom.Xmlnode nodoMetodo = nodoBody.addChildElement('ser:consultaCIFIN', '', '');
            dom.Xmlnode nodoParametro = nodoMetodo.addChildElement('ser:numIdentificacion', '', '');
            nodoParametro.addTextNode(idOportunidad);
            dom.Xmlnode nodoParametro2 = nodoMetodo.addChildElement('ser:tipoIdentificacion', '', '');
        }
                
        return doc.toXmlString();

    }
    
    public static String EliminarCaracteresEspeciales(String cadena) {
        return cadena.replace('á', 'a').replace('é', 'e').replace('í', 'i').replace('ó', 'o').replace('ú', 'u'); 
    }

}