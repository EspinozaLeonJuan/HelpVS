import { LightningElement, api,wire,track } from 'lwc';
import getAllOpps from '@salesforce/apex/GetOpportunityBaseEspecialLinks.getAllOpps';
import getAgents from '@salesforce/apex/GetOpportunityBaseEspecialLinks.getAgents';
import asignacionEspecial from '@salesforce/apex/GetOpportunityBaseEspecialLinks.asignacionEspecial';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Carrusel extends LightningElement {

    value = ['option1'];

    @track openmodel = false;
    openmodal() {
        this.openmodel = true
    }
    closeModal() {
        this.openmodel = false
    } 

    saveMethod() {

        asignacionEspecial({valor : this.value})
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Asignación de Links Especiales',
                    message: 'SE HAN ASIGNADO EQUITATIVAMENTE LOS LINKS SELECCIONADOS BASE ESPECIAL',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.openmodel = false
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Asignación de Links Especiales',
                    message: 'NO SE HA SELECCIONADO NINGÚN SUPERVISOR, O NO HAY OPORTUNIDADES QUE ASIGNAR',
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

    @wire(getAllOpps) opps;
 
    connectedCallback() {
        getAgents({})
          .then(r => {
              let values = [];
              r.forEach(rv => {
                  // from APEX
                  values.push({label: rv.Name, value: rv.Id });
              });
              // LWC array tracking workaround
              this.options = [...values];
          });
    }   
    get selectedValues() {
        return this.value;
    }
    handleChange(e) {
            this.value  = e.detail.value;
    }
}