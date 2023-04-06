/**
 * @File Name          : CTR_CS_LightningEvents.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 4/22/2020, 11:39:55 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/22/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class CTR_CS_LightningEvents {
    
    
    public String Id { get; set; }

    public String URL { get; set; }

    public String Mensaje { get; set; }

    public Pagereference LoadEvent()
    {
        this.Id = apexpages.currentpage().getparameters().get('Id'); 
        String Option = apexpages.currentpage().getparameters().get('Option'); 

        if (Option == 'ADJUNTO_VALUETECH')
        {
            this.URL = 'apex/SEC_VF_CS_UploadValuetech?Id='+this.Id+'&From=caso_nativo_lig';
        }
        else if (Option == 'ESCRITORIO_DIGITAL_RPA'){
            String IdRequerimiento = apexpages.currentpage().getparameters().get('IdRequerimiento');//3

            if (String.IsBlank(IdRequerimiento) || IdRequerimiento == 'null')
            {
                this.Mensaje = 'No existe creado en Escritorio Digital un Requerimiento vinculado al Caso actual';    
            }
            else {

                CLS_EscritorioDigital_Consume.Respuesta_Persistencia respuesta = CLS_EscritorioDigital_Consume.obtenerPersistencia('77777777-7', 'Salesforce', 'SF');                     
                String Persistencia = String.valueOf(respuesta.IdPersistencia); 
                this.URL = 'http://kta.vidasecurity.cl/TotalAgility/forms/vs-ed-dev/VS-ED-FormularioFirma.form?IDRequerimiento='+IdRequerimiento+'&Rut=77777777-7&Persistencia='+Persistencia;
//              this.URL = 'http://kta.vidasecurity.cl/TotalAgility/forms/vs-ed-dev/VS-ED-FormularioFirma.form?IDRequerimiento='+IdRequerimiento+'&Rut=77777777-7&Persistencia='+Persistencia;
            }
        }
        else if (Option == 'ESCRITORIO_DIGITAL')
        {
        /*    String IdReq = '', Status = '', Responsabe = '';
            
            try {
                IdReq = apexpages.currentpage().getparameters().get('IdReq'); 
            } catch (Exception ex) {
                
            }

            try {
                Status = apexpages.currentpage().getparameters().get('Status'); 
            } catch (Exception ex) {
                
            }

            try {
                Responsable = apexpages.currentpage().getparameters().get('Responsable'); 
            } catch (Exception ex) {
                
            }

            if (String.IsNotBlank(IdReq) || IdReq != 'null')
            {
                if (Status == 'Cerrado')
                {}
                else if (Status == 'Rechazado')
                {}
                else if (Status == 'Back Office')
                {}
                else if (Status == 'En Proceso')
                {
                    if (String.isNotBlank(Responsable) != null && Responsable != 'null')
                    {}
                }
            }
            else
            {
                //a creacion de nuevo requerimiento
            }*/
        }
        
        return null;
    }
 
    public CTR_CS_LightningEvents() {

    }
}


/*
            if ('{!Case.Id_Requerimiento_EscritorioDigital__c}' != null&& '{!Case.Id_Requerimiento_EscritorioDigital__c}' != '')
{
document.location = "/apex/SEC_VF_ED_VerRequerimiento?id={!Case.Id}";
}
else
{

if ('{!Case.Status}' == 'Cerrado' )
{
alert("No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en Estado Cerrado.");
}
else if ('{!Case.Status}' == 'Rechazado' )
{
alert("No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en Estado Rechazado.");
}
else if ('{!Case.Status}' == 'Back Office' )
{
alert("No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en proceso de Derivación (Back Office).");
}
else if ('{!Case.Status}' == 'En Proceso')
{
if ('{!Case.CASO_Responsable_UR__c}' != null && '{!Case.CASO_Responsable_UR__c}' != '')
{
alert("No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en proceso de Derivación (En Proceso).");
}
else
{
document.location = "/apex/SEC_VF_ED_Requerimiento?id={!Case.Id}";
}
}
else
{
document.location = "/apex/SEC_VF_ED_Requerimiento?id={!Case.Id}";
}

}

            
            */