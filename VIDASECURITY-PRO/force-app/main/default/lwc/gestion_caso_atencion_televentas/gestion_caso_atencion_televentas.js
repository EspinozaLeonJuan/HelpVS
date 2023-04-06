import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import saveRecord from '@salesforce/apex/CLS_CS_Gestion_CasoAtencion.SaveStatusCase';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';

import SUB_ESTADO_FIELD from '@salesforce/schema/Case.Sub_estado__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class Gestion_caso_atencion_televentas extends LightningElement {

    objectApiName = CASE_OBJECT;
    nameField = STATUS_FIELD;

    @api recordId;
    @api objectApiName; 

    

    /* Load Account.Owner.Email for custom rendering */
    @wire(getRecord, {
        recordId: "$recordId",
        fields: [STATUS_FIELD, SUB_ESTADO_FIELD]
      })
      record;

      /* Get the Account.Owner.Email value. */
      get showOption() 
      {
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


    @track options = [];
    @track picklistOptions = [];

  
    
    @track selectedValue;// = getFieldValue(this.record.data, SUB_ESTADO_FIELD);
   


    @wire( getObjectInfo, { objectApiName: CASE_OBJECT } )
    objectInfo;

    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: SUB_ESTADO_FIELD } )
    wiredData( { error, data } ) {

        console.log( 'Inside Get Picklist Values' );

        if ( data ) {
                            
            console.log( 'Data received from Picklist Field ' + JSON.stringify( data.values ) );
            
            this.options = data.values.map( objPL => {
                return {
                    label: `${objPL.label}`,
                    value: `${objPL.value}`
                };
            });

            console.log( 'Options are ' + JSON.stringify( this.options ) );

        } 
        else if ( error ) {

            console.error( JSON.stringify( error ) );
        }

        this.selectedValue =   getFieldValue(this.record.data, SUB_ESTADO_FIELD);
        console.log('@@@@ TEST '+ this.selectedValue );
    }

    handlePicklistChange( event ) {
        
        console.log( 'New Value selected is ' + JSON.stringify( event.detail.value ) );   
        this.selectedValue = event.detail.value ;
        console.log( 'selectedValue ' + this.selectedValue);
    }


    @track openmodel_close = false;
    @track openmodel_reopen = false;

    openmodal_close() {
        this.openmodel_close = true
    }
    closeModal_close() {
        this.openmodel_close = false
        this.selectedValue =   getFieldValue(this.record.data, SUB_ESTADO_FIELD);
        console.log('@@@@ TEST '+ this.selectedValue );
    } 

    openmodal_reopen() {
        this.openmodel_reopen = true
    }
    closeModal_reopen() {
        this.openmodel_reopen = false
        this.selectedValue =   getFieldValue(this.record.data, SUB_ESTADO_FIELD);
        console.log('@@@@ TEST '+ this.selectedValue );
    } 

    saveMethod_close() {
        saveRecord({Id : this.recordId, Status : 'Cerrado', SubEstado : this.selectedValue})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Atención',
                    message: 'El Caso de Atención ha sido exitosamente cerrado.',
                    variant: 'success',
                });
                this.openmodel_close = false
                this.dispatchEvent(evt);
             
                setTimeout(function () {
                    window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Atención',
                    message: 'El Caso de Atención no ha sido cerrado.',
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

    saveMethod_reopen() {

        saveRecord({Id : this.recordId, Status : 'En Proceso', SubEstado : '' })

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Atención',
                    message: 'El Caso de Atención ha sido exitosamente reabierto.',
                    variant: 'success',
                });
                this.openmodel_reopen = false
                this.dispatchEvent(evt);
               
                setTimeout(function () {
                    window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Atención',
                    message: 'El Caso de Atención no ha sido reabierto.',
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


}