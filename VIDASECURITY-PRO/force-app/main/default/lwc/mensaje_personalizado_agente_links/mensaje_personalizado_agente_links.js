import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import saveMessage from '@salesforce/apex/CLS_OPP_GestionLinks.SaveMessageToAgente';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import TITULO_NOTA_AGENTE_FIELD from '@salesforce/schema/Opportunity.Titulo_Nota_a_Agente__c';
import NOTA_AGENTE_FIELD from '@salesforce/schema/Opportunity.Nota_a_Agente__c';
import {refreshApex} from '@salesforce/apex';

const fields = [
    ID_FIELD,
    TITULO_NOTA_AGENTE_FIELD,
    NOTA_AGENTE_FIELD,
    STAGE_FIELD
];

export default class Mensaje_personalizado_agente_links extends LightningElement {

    objectApiName = OPPORTUNITY_OBJECT;

    @api recordId;
    @api objectApiName;

    @track parameters = [];

    @wire(getRecord, {
        recordId: "$recordId", fields
    })
    opportunity;

    @track modo_edit = false;
    @track showLoading = false;

    @track titulo_nota_agente = '';
    @track nota_agente = '';

    event_change_nota(event){
        this.nota_agente = event.target.value;
        console.log('@@@@  this.nota_agente  -->  '+ this.nota_agente);
    }

    event_change_titulo_nota(event){
        this.titulo_nota_agente = event.target.value;
        console.log('@@@@  this.titulo_nota_agente  -->  '+ this.titulo_nota_agente);
    }

    to_modo_edit()
    {
        this.modo_edit = true;
        this.titulo_nota_agente = getFieldValue(this.opportunity.data, TITULO_NOTA_AGENTE_FIELD);
        this.nota_agente = getFieldValue(this.opportunity.data, NOTA_AGENTE_FIELD);
    }

    to_modo_view()
    {
        this.modo_edit = false;
    }

    save_changes()
    {
        this.showLoading = true;
        saveMessage({Id : this.recordId, Titulo : this.titulo_nota_agente, Mensaje : this.nota_agente})

        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Mensaje a Agente',
                    message: 'El mensaje a agente ha sido exitosamente modificado.',
                    variant: 'success',
                });

                this.dispatchEvent(evt);
                this.showLoading = false;
                refreshApex(this.opportunity);
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Mensaje a Agente',
                    message: 'No se puede modificar el mensaje a agente.',
                    variant: 'error',
                });
                this.showLoading = false;
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
                this.showLoading = false;
                this.dispatchEvent(evt);
        });

        this.modo_edit = false;
    }
}