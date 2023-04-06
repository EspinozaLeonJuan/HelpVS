import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import getAdjuntosCaso from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.getAdjuntosCaso';
//import { NavigationMixin } from 'lightning/navigation';
import ID_FIELD from '@salesforce/schema/Case.Id';
const columns = [
    {
        type: "button",
        initialWidth: 120,
        initialHeigth: 22,
        typeAttributes: {
            label: 'Acceder',
            name: 'View',
            title: 'Visualizar',
            disabled: false,
            value: 'view',
            iconPosition: 'left'
        }
    },
    { label: 'Nombre Documento', fieldName: 'Nombre_Documento__c' },
    { label: 'Código Adjunto', fieldName: 'Codigo_Adjunto__c' },
    { label: 'Id Retorno', fieldName: 'Id_Retorno__c' },
    { label: 'Fecha Creación', fieldName: 'CreatedDate', type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Creado por', fieldName: 'OwnerName', type : 'text' }
];

export default class Listado_documentos_repositorio extends LightningElement {

    @track documents;
    @track error;
    @track columns = columns;

    @api recordId;
    @api objectApiName = CASE_OBJECT;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: [
                 ID_FIELD
                ]
    })
    record;

    connectedCallback()
    {
        console.log('@@@@ ID CASE --> '+this.recordId);
        getAdjuntosCaso( { Id : this.recordId} )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row, OwnerName: row.CreatedBy.Name};
                })

                this.documents = tempRecords;
            })
            .catch(error => {
                this.documents = undefined;
                this.error = error;
            });
    }

    callRowAction( event ) {
        const url =  event.detail.row.UrlDoc__c;
        console.log('@@@@ ID --> '+ url);

        var height = 588;
        var width =1000;
        var y=parseInt((window.screen.height/2) - height/2);
        var x=parseInt((window.screen.width/2) - width/2);

        var performance   = 'height='+height+'px,width='+width+'px, top='+y+',left='+x+',toolbar=no,location=no,status=no,menubar=no,scrollbars=no,directories=no,resizable=no';

            var popUp = window.open(url, "_blank", performance);

            if (popUp == null || typeof(popUp)=='undefined') {
                    alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle Tarea UR".');
            }
            else {
                    popUp.focus();
            }

   }

}