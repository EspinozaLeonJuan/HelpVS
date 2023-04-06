import { LightningElement, api,wire, track } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import clonarCotizacion from "@salesforce/apex/CloneQuoteComercial.clonarCotizacion";

export default class BotonComercialCloneQuote extends NavigationMixin(LightningElement) {
    @api objectId;
    @track consulta;
    @track showSpinner = false;


    Clonar() {
        this.showSpinner = true;
        clonarCotizacion({
            quoteId: this.objectId
        })
        .then(result => {
            this.consulta = result;            
            if(this.consulta){
                this.showSpinner = false;
                this.showToast('ÉXITO', 'Presupuesto generado correctamente', 'success');
                setTimeout(this.__reloadQuote, 250, this);
            } else {
                this.showSpinner = false;
                this.showToast('ERROR', 'Error generando presupuesto, favor volver a intentar', 'error');
            }
        })
        .catch(error => {
            let errorMessage = '';
            if ( error.body.message) {
                errorMessage =error.body.message;
            }
            this.showSpinner = false;
            this.showToast('Alerta', errorMessage, 'alert');
        });
    }

    showToast(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant
        });
        this.dispatchEvent(event);
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