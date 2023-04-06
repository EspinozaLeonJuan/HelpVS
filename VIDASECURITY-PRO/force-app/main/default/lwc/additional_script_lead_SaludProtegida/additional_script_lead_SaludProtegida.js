import { LightningElement , api,wire,track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import NAME_FIELD from '@salesforce/schema/Lead.Name';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Lead.Cuenta__r.Name';
import CURRENTUSER_ID from '@salesforce/user/Id';
import ID_FIELD from '@salesforce/schema/Lead.Id';

const fields = [
    ID_FIELD,
    STATUS_FIELD,
    ACCOUNT_NAME_FIELD,
    NAME_FIELD
  ];


export default class Additional_script_lead_SaludProtegida extends LightningElement {

    @track nombreContratante = 'XXXXXX';
    @track nombreAsegurado  = 'XXXXXX';
    @track nombreEjecutiva  = 'XXXXXX';
    @track cobertura   = 'XXXXXX';
    @track nombreProducto  = 'XXXXXX';
    @track capitalHasta  = 'XXXXXX';
    @track capitalHasta76  = 'XXXXXX';
    @track precioMensualUF  = 'XXXXXX';
    @track precioMensualCLP  = 'XXXXXX';
    @track capitalPrimaAdic  = 'XXXXXX';
    @track fechaExluido  = 'XXXXXX';
    @track fechaRegir  = 'XXXXXX';
    @track nombreGrabacion  = 'XXXXXX';
    @track capitalEquivalente  = 'XXXXXX';
    @track fechaContratacion  = 'XXXXXX';
    @track fechaContratacion_sinAgno  = 'XXXXXX';
    @track fechaContratacion_Agno  = 'XXXXXX';
    @track capitalHasta_Cert = 'XXXXXX';
    @track deducible_Cert  = 'XXXXXX';
    @track fechaInicioVigencia  = 'XXXXXX';
    @track nombreCarga  = '"nombrecarga"';

    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId", fields
      })
      lead;

    @wire(getRecord, {
        recordId: CURRENTUSER_ID,
        fields: [
            USER_NAME_FIELD
                ]
    })
    userData;

    objectApiName = LEAD_OBJECT;

    get ES_ASEGURADO()
    {
        var status = getFieldValue(this.lead.data, STATUS_FIELD) ;
        console.log('@@@@ status lead (A) --> '+status);

//      this.nombreContratante = getFieldValue(this.lead.data, ACCOUNT_NAME_FIELD) ;
        this.nombreAsegurado = getFieldValue(this.lead.data, NAME_FIELD) ;
        this.nombreEjecutiva =  getFieldValue(this.userData.data, USER_NAME_FIELD) ;;

        if (status == 'Asegurado Contactado' || status == 'Asegurado No Contactado')
        {
            return true;
        }

        return false;
    }

    get ES_CONTRATANTE()
    {
        var status = getFieldValue(this.lead.data, STATUS_FIELD) ;
        console.log('@@@@ status lead (C)  --> '+status);

        this.nombreContratante = getFieldValue(this.lead.data, ACCOUNT_NAME_FIELD) ;
        this.nombreAsegurado = getFieldValue(this.lead.data, NAME_FIELD) ;
        this.nombreEjecutiva =  getFieldValue(this.userData.data, USER_NAME_FIELD) ;;


        if (status == 'Contratante Contactado' || status == 'Contratante No Contactado')
        {
            return true;
        }

        return false;
    }


}