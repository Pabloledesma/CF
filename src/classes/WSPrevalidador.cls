//Generated by wsdl2apex

public class WSPrevalidador {
    public class prevalidador_element {
        public String query;
        private String[] query_type_info = new String[]{'query','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'query'};
    }
    public class consultaCIFIN_element {
        public String numIdentificacion;
        public String tipoIdentificacion;
        private String[] numIdentificacion_type_info = new String[]{'numIdentificacion','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] tipoIdentificacion_type_info = new String[]{'tipoIdentificacion','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'numIdentificacion','tipoIdentificacion'};
    }
    public class datacredito_element {
        public String primerApellido;
        public String identificacion;
        private String[] primerApellido_type_info = new String[]{'primerApellido','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] identificacion_type_info = new String[]{'identificacion','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'primerApellido','identificacion'};
    }
    public class prevalidadorResponse_element {
        public String prevalidadorReturn;
        private String[] prevalidadorReturn_type_info = new String[]{'prevalidadorReturn','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'prevalidadorReturn'};
    }
    public class consultaCIFINResponse_element {
        public String consultaCIFINReturn;
        private String[] consultaCIFINReturn_type_info = new String[]{'consultaCIFINReturn','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'consultaCIFINReturn'};
    }
    public class datacreditoResponse_element {
        public String datacreditoReturn;
        private String[] datacreditoReturn_type_info = new String[]{'datacreditoReturn','http://server.tecnologia.credifamilia.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://server.tecnologia.credifamilia.com','true','false'};
        private String[] field_order_type_info = new String[]{'datacreditoReturn'};
    }
    public class Credifamilia {
        public String endpoint_x = 'http://wsprevalidador.credifamilia.com/CredifamiliaServer/services/Credifamilia';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://server.tecnologia.credifamilia.com', 'WSPrevalidador'};
        public String consultaCIFIN(String numIdentificacion,String tipoIdentificacion) {
            WSPrevalidador.consultaCIFIN_element request_x = new WSPrevalidador.consultaCIFIN_element();
            request_x.numIdentificacion = numIdentificacion;
            request_x.tipoIdentificacion = tipoIdentificacion;
            WSPrevalidador.consultaCIFINResponse_element response_x;
            Map<String, WSPrevalidador.consultaCIFINResponse_element> response_map_x = new Map<String, WSPrevalidador.consultaCIFINResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://server.tecnologia.credifamilia.com',
              'consultaCIFIN',
              'http://server.tecnologia.credifamilia.com',
              'consultaCIFINResponse',
              'WSPrevalidador.consultaCIFINResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.consultaCIFINReturn;
        }
        public String datacredito(String primerApellido,String identificacion) {
            WSPrevalidador.datacredito_element request_x = new WSPrevalidador.datacredito_element();
            request_x.primerApellido = primerApellido;
            request_x.identificacion = identificacion;
            WSPrevalidador.datacreditoResponse_element response_x;
            Map<String, WSPrevalidador.datacreditoResponse_element> response_map_x = new Map<String, WSPrevalidador.datacreditoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://server.tecnologia.credifamilia.com',
              'datacredito',
              'http://server.tecnologia.credifamilia.com',
              'datacreditoResponse',
              'WSPrevalidador.datacreditoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.datacreditoReturn;
        }
        public String prevalidador(String query) {
            WSPrevalidador.prevalidador_element request_x = new WSPrevalidador.prevalidador_element();
            request_x.query = query;
            WSPrevalidador.prevalidadorResponse_element response_x;
            Map<String, WSPrevalidador.prevalidadorResponse_element> response_map_x = new Map<String, WSPrevalidador.prevalidadorResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://server.tecnologia.credifamilia.com',
              'prevalidador',
              'http://server.tecnologia.credifamilia.com',
              'prevalidadorResponse',
              'WSPrevalidador.prevalidadorResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.prevalidadorReturn;
        }
    }
}