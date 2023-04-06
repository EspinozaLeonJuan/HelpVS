import { LightningElement , api,wire,track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import saveRecord from '@salesforce/apex/CLS_CS_Gestion_CasoAtencion.SaveStatusCase';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import RETORNO_LLAMADA_FIELD from '@salesforce/schema/Case.Retorno_Llamada__c';
import ID_FIELD from '@salesforce/schema/Case.Id';

export default class Gestion_caso_reclamo_vass extends LightningElement {
            //objectApiName = CASE_OBJECT;
    //nameField = STATUS_FIELD;

    @api recordId;
    //@api objectApiName; 

    /* Load Account.Owner.Email for custom rendering */
    @wire(getRecord, {
        recordId: "$recordId",
        fields: [STATUS_FIELD, RETORNO_LLAMADA_FIELD, ID_FIELD]
      })
      record;

      /* Para visualizacion de botones template base */
      get showOption() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        if (statusCase != 'Cerrado')
        {
         return true;
        }
        else
        {
            return false;
        }
      }


     //#region Cerrar Caso 
    @track openmodel_close = false;

    @track llamadaGrabada = true;

    openmodal_close() {
        this.openmodel_close = true
    }

    closeModal_close() {
        this.openmodel_close = false
    } 
    

    saveMethod_close() {
        saveRecord({Id : this.recordId, Status : 'Cerrado'})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Reclamo',
                    message: 'El Caso de Reclamo ha sido exitosamente cerrado.',
                    variant: 'success',
                });
                this.openmodel_close = false
                this.dispatchEvent(evt);
             
                setTimeout(function () {
                    window.location.reload();
                }, 1000);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Reclamo',
                    message: 'El Caso de Reclamo no ha sido cerrado.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
        .catch((error) => {
            this.message = 'ERROR RECIBIDO' + error.errorCode + ', ' +
                'MENSAJE ' + error.body.message;
                console.log(JSON.stringify(error));
                const evt = new ShowToastEvent({
                    title: 'ERROR',
                    message: 'ERROR'+ JSON.stringify(error),
                    variant: 'error',
                });
                this.dispatchEvent(evt);
        });
    }

    // #endregion

    //#region Reabrir Caso 
    @track openmodel_reopen = false;
  

    openmodal_reopen() {
        this.openmodel_reopen = true
    }
    closeModal_reopen() {
        this.openmodel_reopen = false
    } 

    saveMethod_reopen() {
        saveRecord({Id : this.recordId, Status : 'En Proceso'})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Reclamo',
                    message: 'El Caso de Reclamo ha sido exitosamente reabierto.',
                    variant: 'success',
                });
                this.openmodel_reopen = false
                this.dispatchEvent(evt);
               
                setTimeout(function () {
                    window.location.reload();
                }, 1000);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Reclamo',
                    message: 'El Caso de Reclamo no ha sido reabierto.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
        .catch((error) => {
            this.message = 'ERROR RECIBIDO' + error.errorCode + ', ' +
                'MENSAJE ' + error.body.message;
                console.log(JSON.stringify(error));
                const evt = new ShowToastEvent({
                    title: 'ERROR',
                    message: 'ERROR'+ JSON.stringify(error),
                    variant: 'error',
                });
                this.dispatchEvent(evt);
        });
    }

    // #endregion


    toLlamadaCliente()
    {
        var idCase = getFieldValue(this.record.data, ID_FIELD);
        var retornoLlamada  = getFieldValue(this.record.data, RETORNO_LLAMADA_FIELD);


        var url ="/apex/SEC_VF_CC_LlamadaAgente?Id="+idCase+"&Origin=Case&CallBack="+retornoLlamada;

        var popUp = window.open(url, "Llamada a Cliente", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=1150, height=700, top = 350, left = 500");

        if (popUp == null || typeof(popUp)=='undefined') {
            alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
        }
        else {
            popUp.focus();
        }
    }

    toGrabacionLlamada()
    {
        var idCase = getFieldValue(this.record.data, ID_FIELD);

        var url ="/apex/SEC_VF_CC_ArchivoLlamada?Id="+idCase;

        var popUp = window.open(url, "Grabación Llamada Cliente", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=1150, height=700, top = 350, left = 500");

        if (popUp == null || typeof(popUp)=='undefined') {
            alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
        }
        else {
            popUp.focus();
        }
    }
}