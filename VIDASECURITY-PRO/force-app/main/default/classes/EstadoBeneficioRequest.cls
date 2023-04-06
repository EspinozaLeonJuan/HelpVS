public with sharing class EstadoBeneficioRequest {
    
    public static final Integer CANAL_PREDETERMINADO = null;
    
    public String poliza {get; set;}
    public Integer rutFilial {get; set;}
    public Integer canal {get; set;}
    public String usuario {get; set;} //Usuario que ingresa el Estado
    public Integer grupoCobranza {get; set;} 
   
    public EstadoBeneficioRequest(String poliza, Integer rutFilial, Integer canal, String usuario, Integer grupoCobranza) {
        this.poliza = poliza;
        this.rutFilial = rutFilial;
        this.canal = canal;
        this.usuario = usuario;
        this.grupoCobranza = grupoCobranza;
            }
            
    public EstadoBeneficioRequest(String poliza, Integer rutFilial, Integer canal, Integer grupoCobranza) {
        this(poliza, rutFilial, canal, UserInfo.getName(), grupoCobranza);
    }
    
    public EstadoBeneficioRequest(String poliza, Integer rutFilial, Integer grupoCobranza) {
        this(poliza,  rutFilial, CANAL_PREDETERMINADO, grupoCobranza);
            }
            
    public EstadoBeneficioRequest(Filial__c filial) {
        this(
            filial == null ? null : String.valueOf(filial.Numero_Poliza__c),
            filial == null ? null : Integer.valueOf(filial.Rut_Empresa__c),
            filial == null ? null : Integer.valueOf(filial.Grupo_Cobranza__c)
        );
    }

    public EstadoBeneficioRequest() {
        this(null);
            }
}