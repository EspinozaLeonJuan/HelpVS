import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const namefieldTecnica = 'IdPropuestaTecnica__c';
const namefieldComercial = 'IdPropuestaComercial__c';

export default class ComercialQuoteFileUpload extends LightningElement {
    @api recordId;

    fieldTecnica = namefieldTecnica;
    fieldComercial = namefieldComercial;
    idTecnica;
    idComercial;

    @wire(
        getRecord, 
        {recordId: '$recordId', fields: ['Quote.' + namefieldTecnica, 'Quote.' + namefieldComercial]}
    )
    record({error, data}) {
        if (data) {
            this.idTecnica = data.fields.IdPropuestaTecnica__c.value;
            this.idComercial = data.fields.IdPropuestaComercial__c.value;
        }
        if (error) console.log(error);
    };
}