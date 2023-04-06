import { LightningElement, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';

const iconWait = 'action:close';
const iconReady = 'action:approval';

export default class ComercialFileUpload extends NavigationMixin(LightningElement) {

    @api objectId;

    @api fieldId;
    @api fieldName;
    @api successMessage;

    @wire(
        getRecord, 
        {recordId: '$fieldId', fields: ['ContentDocument.Id']}
    )
    record({error, data}) {
        if (data) {
            this.fileLoaded = true;
        }
        if (error) {
            this.fileLoaded = false;
        }
    };

    componentTitle = 'Cargar Archivo';
    fileLoaded = false;
    
    @api get title () {return this.componentTitle;}
    /**
     * @param {string} value
     */
    set title(value) {this.componentTitle = value;}
    
    get iconStatus() {
        if (!this.fileLoaded) return iconWait;
        else return iconReady;
    }

    handleClick(event){
        const docPageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.fieldId,
                objectApiName: 'ContentDocument',
                actionName: 'view'
            }
        };

        this[NavigationMixin.Navigate](docPageRef);
    }

    handleUploadFinished(event) {
        const fields = {};
        fields['Id'] = this.objectId;
        fields[this.fieldName] = event.detail.files[0].documentId;

        updateRecord({fields} ).then(() =>{
            const toastEvt = new ShowToastEvent({
                title: "Carga de archivos",
                message: this.successMessage,
                variant: "success"
            });
            this.dispatchEvent(toastEvt);
    
            setTimeout(this.__reloadQuote, 250, this);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error subida de archivos',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    __reloadQuote(ctxt) {
        const quotePageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: ctxt.objectId,
                objectApiName: 'Quote',
                actionName: 'view'
            }
        };

        ctxt[NavigationMixin.Navigate](quotePageRef);
    }

}