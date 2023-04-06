import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class PanelBotonCloneQuote extends LightningElement {
    @api recordId;


    @wire(
        getRecord, 
        {recordId: '$recordId'}
    )
    record({error, data}) {
        if (data) {

        }
        if (error) console.log(error);
    };
}