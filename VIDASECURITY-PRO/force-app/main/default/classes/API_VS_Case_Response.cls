global with sharing class API_VS_Case_Response {
    public API_VS_Case_Response() {

    }

    public API_VS_Case_Response(String idAtencion, String caseNumber)
    {
        this.Id = idAtencion;
        this.CaseNumber = caseNumber;
    }

    public API_VS_Case_Response(String idAtencion, String caseNumberParent, String IdRequerimiento, String caseNumber) {
        this.Id = idAtencion;
        this.CaseNumber = caseNumberParent;
        if (String.isNotBlank(IdRequerimiento))
        {
            this.Requerimiento = new Requerimiento();
            this.Requerimiento.CaseNumber = caseNumber;
            this.Requerimiento.Id = IdRequerimiento;
        }

    }

    public String Id {get; set;}

    public String CaseNumber {get; set;}

    public Requerimiento Requerimiento {get; set;}

    public class Requerimiento {
        public String Id {get; set;}

        public String CaseNumber {get; set;}
    }
}