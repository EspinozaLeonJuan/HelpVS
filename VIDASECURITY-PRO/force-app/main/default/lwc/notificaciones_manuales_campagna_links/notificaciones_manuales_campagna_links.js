import { LightningElement , api,wire,track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import sendEmail from '@salesforce/apex/CLS_OPP_NotificacionManualLink.SendEmail';
import sendEmail_Cliente from '@salesforce/apex/CLS_OPP_NotificacionManualLink.SendEmail_Cliente';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Notificaciones_manuales_campagna_links extends LightningElement {
    objectApiName = OPPORTUNITY_OBJECT;

    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: [ID_FIELD]
    })
    record;

    @track showLoading = false;

    send_notification_agente()
    {
        this.showLoading = true;
        sendEmail({Id : this.recordId})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Envío de Notificación a Agente',
                    message: 'La notificación ha sido exitosamente enviada.',
                    variant: 'success',
                });

                this.dispatchEvent(evt);
                this.showLoading = false;
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Envío de Notificación a Agente',
                    message: 'No se puede enviar notificación a Agente en la Etapa actual.',
                    variant: 'error',
                });

                this.dispatchEvent(evt);
                this.showLoading = false;
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
                this.showLoading = false;
        });
    }

    send_notification_cliente()
    {
        this.showLoading = true;
        sendEmail_Cliente({Id : this.recordId})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Envío de Notificación a Cliente',
                    message: 'La notificación ha sido exitosamente enviada.',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.showLoading = false;
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Envío de Notificación a Cliente',
                    message: 'No se puede enviar notificación a Cliente en la Etapa actual.',
                    variant: 'error',
                });

                this.dispatchEvent(evt);
                this.showLoading = false;
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
                this.showLoading = false;
        });
    }

}