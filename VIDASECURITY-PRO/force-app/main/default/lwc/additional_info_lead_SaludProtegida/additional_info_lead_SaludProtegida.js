import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import {refreshApex} from '@salesforce/apex';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import COBERTURA_FIELD from '@salesforce/schema/Lead.Cobertura__c';
import CAPITAL_REMANENTE_FIELD from '@salesforce/schema/Lead.Capital_Remanente_Asegurado__c';
import PLAN_FIELD from '@salesforce/schema/Lead.Plan__c';
import FECHA_INICIO_VIGENCIA_FIELD from '@salesforce/schema/Lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c';
import PRIMA_FINAL_POLIZA_ORI_FIELD from '@salesforce/schema/Lead.Prima_Final_Poliza_Original__c';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import SUB_STATUS_FIELD from '@salesforce/schema/Lead.Sub_Estado__c';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import CIERRE_ADMINISTRATIVO_FIELD from '@salesforce/schema/Lead.Cierre_Administrativo__c';

import refreshLeadInfo from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoSaludPro.RefreshData_Lead';
// import SUB_ESTADO_FIELD from '@salesforce/schema/Lead.Sub_Estado__c';
const fields = [
    ID_FIELD,
    COBERTURA_FIELD,
    CAPITAL_REMANENTE_FIELD,
    PLAN_FIELD,
    FECHA_INICIO_VIGENCIA_FIELD,
    PRIMA_FINAL_POLIZA_ORI_FIELD,
    STATUS_FIELD,
    SUB_STATUS_FIELD,
    ID_FIELD,
    CIERRE_ADMINISTRATIVO_FIELD
  ];
export default class Additional_info_lead_SaludProtegida extends LightningElement {
    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId", fields
      })
      lead;

    objectApiName = LEAD_OBJECT;

    @track permisoActualizar = true;

    @track showLoading = false;

    connectedCallback() {
    }

    to_refresh_info()
    {
        this.showLoading = true;
        refreshLeadInfo({Id : this.recordId}).then(r => {
            if(r != false){

                const evt = new ShowToastEvent({
                    title: 'Actualizar Campos adicionales Prospecto',
                    message: 'Los campos adicionales del Prospecto han sido exitosamente actualizados.',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                refreshApex(this.lead);
                this.showLoading = false;
            }
            else{

                const evt = new ShowToastEvent({
                    title: 'Actualizar Campos adicionales Prospecto',
                    message: 'Los campos adicionales del Prospecto NO han sido exitosamente actualizados.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);

                setTimeout(function () {
                    // window.location = "/"+ ID;
                    this.showLoading = false;
                   // window.location.reload();
                  //this.modoEdicion = false;
                  }, 1500);
            }
        })
        .catch((error) => {

           // this.message = 'ERROR RECIBIDO' + error.errorCode + ', ' +
                'MENSAJE ' + error.body.message;
                console.log(JSON.stringify(error));
                const evt = new ShowToastEvent({
                    title: 'ERROR',
                    message: 'ERROR',//+ JSON.stringify(error),
                    variant: 'error',
                });
                this.dispatchEvent(evt);

                setTimeout(function () {
                    // window.location = "/"+ ID;
                    this.showLoading = false;
                    //window.location.reload();
                  //this.modoEdicion = false;
                  }, 1500);
        });

    }

    // get FECHA_INICIO_VIGENCIA(){
    //     var fecha = getFieldValue(this.lead.data, FECHA_INICIO_VIGENCIA_FIELD) ;
    //     console.log('@@@@ fecha '+fecha);
    //     return fecha;
    // }

    get CAPITAL_REMANENTE(){
        var capital = getFieldValue(this.lead.data, CAPITAL_REMANENTE_FIELD) ;
        console.log('@@@@ capital '+capital);
        return capital;
    }

    get REFRESH_OK()
    {
        var status = getFieldValue(this.lead.data, STATUS_FIELD);
        var substatus = getFieldValue(this.lead.data, SUB_STATUS_FIELD);
        var cierreAdministrativo = getFieldValue(this.lead.data, CIERRE_ADMINISTRATIVO_FIELD);

        console.log('@@@@ status '+status);
        console.log('@@@@ substatus '+substatus);
        console.log('@@@@ cierreAdministrativo '+cierreAdministrativo);

        if (status == 'Contratante No Contactado' && (substatus  == 'Teléfono Malo' || substatus  == 'No Contesta, inubicable' ||  substatus  == 'Persona falleció'))
        {
            return false;
        }
        else if (status == 'Asegurado No Contactado' && (substatus  == 'Teléfono Malo' || substatus  == 'No Contesta, inubicable'))
        {
            return false;
        }
        else if ((status == 'Contratante Contactado' || status == 'Asegurado Contactado') && (substatus  == 'No le interesa' ||  substatus  == 'Pide no volver a llamar' || substatus  == 'No reúne condiciones' || substatus  == 'Molesto con la compañía' || substatus == 'No tiene medio de pago'))
        {
            return false;
        }
        else if (status == 'Contrata' && (substatus == 'Contratante de póliza original' || substatus  == 'Asegurado'))
        {
            return false;
        }
        else if (cierreAdministrativo == true)//Aca agregar logica con los estado nuevos definidos
        {
            return false;
        }

        return true;
    }
}