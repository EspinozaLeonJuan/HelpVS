/*
  @description       :
  @author            : Juan Espinoza León
  @group             :
  @last modified on  : 06-06-2022
  @last modified by  : Juan Espinoza León
*/
import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import changeStatus from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import CONCEPTO_FIELD from '@salesforce/schema/Case.Concepto__c';
import POLIZA_FIELD from '@salesforce/schema/Case.CASO_N_Poliza__c';
import POLIZA_NAME_FIELD from '@salesforce/schema/Case.CASO_Poliza_Asoc__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import CANAL_FIELD from '@salesforce/schema/Case.Canal__c';

export default class Gestion_caso_consulta extends LightningElement {
    objectApiName = CASE_OBJECT;

    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: [
                 ID_FIELD,
                 STATUS_FIELD,
                 POLIZA_FIELD,
                 POLIZA_NAME_FIELD,
                 CONCEPTO_FIELD,
                 CANAL_FIELD
                ]
    })
    record;

    get showOption_Apertura() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        if (statusCase == 'Cerrado')
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    get showOption_Cierre() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        if (statusCase == 'Cerrado')
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    @track openmodel_close = false;

    openmodal_close() {
        this.openmodel_close = true
    }

    closeModal_close() {
        this.openmodel_close = false
    }

    saveMethod_close() {
        var updateParentStatus = false; // para cambiar estado del caso padre relacionado

        //canal seguro covid
        var canal  = getFieldValue(this.record.data, CANAL_FIELD);

       /* if (canal == 'SEGURO COVID')
        {
            updateParentStatus = true;
        }*/
        //canal seguro covid

       this.showLoading = true;
        changeStatus({Id : this.recordId, Status : 'Cerrado', UpdateParent : updateParentStatus })
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Consulta',
                    message: 'El Caso de Consulta ha sido exitosamente cerrado.',
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
                    title: 'Cierre de Caso Consulta',
                    message: 'El Caso Consulta no ha sido cerrado.',
                    variant: 'error',
                });
                //this.openmodel_close = false
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
             //   this.openmodel_close = false
                this.dispatchEvent(evt);
        });
        this.showLoading = false;

    }
    //##region cierre de caso


    //##region reabrir caso

    @track openmodel_reopen = false;

    openmodal_reopen() {
        this.openmodel_reopen = true
    }

    closeModal_reopen() {
        this.openmodel_reopen = false
    }

    saveMethod_reopen() {
        var updateParentStatus = false; // para cambiar estado del caso padre relacionado

        //canal seguro covid
        var canal  = getFieldValue(this.record.data, CANAL_FIELD);

        if (canal == 'SEGURO COVID')
        {
            updateParentStatus = true;
        }
        //canal seguro covid

        this.showLoading = true;
        changeStatus({Id : this.recordId, Status : 'En Proceso', UpdateParent : updateParentStatus })
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Consulta',
                    message: 'El Caso Consulta ha sido exitosamente reabierto.',
                    variant: 'success',
                });
                this.openmodel_reopen = false;
                this.dispatchEvent(evt);

                setTimeout(function () {
                    window.location.reload();
                }, 1000);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Consulta',
                    message: 'El Caso Consulta no ha sido reabierto.',
                    variant: 'error',
                });
                //this.openmodel_reopen = false;
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
                //this.openmodel_reopen = false;
                this.dispatchEvent(evt);
        });
        this.showLoading = false;
    }
    //##region reabrir caso

}