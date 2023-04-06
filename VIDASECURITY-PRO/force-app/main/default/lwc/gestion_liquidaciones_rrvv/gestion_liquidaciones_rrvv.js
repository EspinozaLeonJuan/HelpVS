import { LightningElement , api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import get_pickList_Months from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.get_pickList_Months';
import get_pickList_Years from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.get_pickList_Years';
import getLiquidaciones from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.getLiquidaciones';
import saveLiquidacion from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.saveLiquidacion';
import generateMail from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.generateMail';
import getEtapaLiquidacion from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.getEtapaLiquidacion';
import deleteLiquidacion from '@salesforce/apex/CLS_LWC_Gestion_Liquidaciones_RRVV.deleteLiquidacion';
import {refreshApex} from '@salesforce/apex';

const columns = [
    { label: 'Periodo', fieldName: 'Period', initialWidth: 100 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Mes', fieldName: 'Month', initialWidth: 110 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Año', fieldName: 'Year' , initialWidth: 70 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Estado', fieldName: 'Status' , initialWidth: 130 ,
    cellAttributes: { alignment: 'center' }},
    {
        type: "button",
        initialWidth: 130,
        initialHeigth: 22,

        typeAttributes: {
            label: 'Eliminar',
            name: 'View',
            title: 'Eliminar Periodo Liquidación',
            disabled: false,
            value: 'view',
            iconPosition: 'left'
        },
        cellAttributes: { alignment: 'center' }
    }
];

const columns_after = [
    { label: 'Periodo', fieldName: 'Period', initialWidth: 130 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Mes', fieldName: 'Month', initialWidth: 130 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Año', fieldName: 'Year' , initialWidth: 100 ,
    cellAttributes: { alignment: 'center' }},
    { label: 'Estado', fieldName: 'Status' , initialWidth: 200 ,
    cellAttributes: { alignment: 'center' }}
];


export default class Gestion_liquidaciones_rrvv extends LightningElement {

    @api recordId;
    // @api objectApiName;
    @track error;

    @track columns = columns;
    @track columns_after = columns_after;
    @track months;
    @track years;

    @track monthValue = '';
    @track yearValue = '';

    @track liquidaciones;

    @track showLoading = false;
    @track enviarCorreo = true;
    @track botonVisible = false;

    connectedCallback()
    {
        getEtapaLiquidacion({Id : this.recordId}).then(result => {
            this.enviarCorreo = result;

            if (this.enviarCorreo == false)
            {
                get_pickList_Months({}).then(r => {
                    let values = [];
                    r.forEach(rv => {
                        // from APEX
                        values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                        console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                    });
                    // LWC array tracking workaround
                    this.months = [...values];

                });

                get_pickList_Years({ }).then(r => {
                    let values = [];
                    r.forEach(rv => {
                        // from APEX
                        values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                        console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                    });
                    // LWC array tracking workaround
                    this.years = [...values];

                });
            }

            this.loadData();
        });
    }

    loadData()
    {
        console.log('@@@@  gestionLiquidaciones LD --> '+this.gestionLiquidaciones);
        getLiquidaciones( { Id : this.recordId } )
        .then(result => {
            let tempRecords = JSON.parse( JSON.stringify( result ) );
            tempRecords = tempRecords.map( row => {
                return { ...row
                };
            })
            console.log('@@@@ tempRecords.length '+ tempRecords.length);
            this.liquidaciones = tempRecords;
            console.log('@@@@ this.liquidaciones.length '+ this.liquidaciones.length);

            if (this.liquidaciones.length > 0)
            {
                this.botonVisible = true;
            }
            else
            {
                this.botonVisible = false;
            }

        })
        .catch(error => {
            this.liquidaciones = undefined;
            this.error = error;
            // setTimeout(function () {
            //     this.showLoading = false;
            //   }, 1500);  // After 1.5 secs

            this.showLoading = false;
        });
    }

    handlePicklist_Years_Change(e)
    {
        this.yearValue  = e.detail.value;
        console.log('@@@@ this.yearValue '+ this.yearValue);
       // this.loadData();
    }

    handlePicklist_Months_Change(e)
    {
        this.monthValue  = e.detail.value;
        console.log('@@@@ this.monthValue '+ this.monthValue);
        //this.loadData();
    }

    handleClick_add_Period()
    {
        console.log('@@@@ this.liquidaciones.length '+ this.liquidaciones.length);

        if (this.liquidaciones.length < 6)
        {
            this.showLoading = true;
            console.log('@@@@ this.monthValue '+ this.monthValue);
            console.log('@@@@ this.yearValue '+ this.yearValue);

            saveLiquidacion({Id : this.recordId, Year : this.yearValue, Month : this.monthValue }).then(result => {

                if(result == true){
                    this.loadData();
                    refreshApex(this.liquidaciones);
                    this.showLoading = false;
                    const evt = new ShowToastEvent({
                                    title: 'Gestión de Liquidaciones RRVV',
                                    message: 'El Periodo de Liquidación ingresado ha sido Agregado.',
                                    variant: 'success',
                                });

                                this.dispatchEvent(evt);

                }
                else{
                    this.showLoading = false;
                    const evt = new ShowToastEvent({
                        title: 'Gestión de Liquidaciones RRVV',
                        message: 'El Periodo de Liquidación ingresado NO ha sido Agregado.',
                    variant: 'error',
                });
                    this.dispatchEvent(evt);
                }

            })
            .catch((error) => {
                this.showLoading = false;
                this.dispatchEvent(evt);
            });
        }
        else
        {
            this.showLoading = false;
            const evt = new ShowToastEvent({
                title: 'Gestión de Liquidaciones RRVV',
                message: 'El Periodo de Liquidación ingresado NO ha sido Agregado, solo se pueden generar 6 liquidaciones como máximo por este medio.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }

    }

    callRowActionDeleteValue( event ) {
        const id =  event.detail.row.Id;
        console.log('@@@@ ID --> '+ id);

        deleteLiquidacion( { Id : id } )
        .then(result => {
            if(result == true){
                this.loadData();
                refreshApex(this.liquidaciones);
                this.showLoading = false;
                const evt = new ShowToastEvent({
                                title: 'Gestión de Liquidaciones RRVV',
                                message: 'El Periodo de Liquidación seleccionado ha sido Eliminado.',
                                variant: 'success',
                            });

                            this.dispatchEvent(evt);

            }
            else{
                this.showLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Gestión de Liquidaciones RRVV',
                    message: 'El Periodo de Liquidación seleccionado NO ha sido Eliminado.',
                variant: 'error',
            });
                this.dispatchEvent(evt);
            }
        }
        )
        .catch(error => {
            this.showLoading = false;
            this.error = error;
        });

   }


   callRowActionGetValue( event ) {


}

//BLloquear botones si caso esta cerrado
//permitir acceder a liq ? ¿

    sendEmailLiquidaciones()
    {
        this.showLoading = true;


      generateMail( { Id : this.recordId } )
        .then(result => {
            if(result == true) {
                this.showLoading = false;
                this.enviarCorreo = true;
                this.loadData();
                refreshApex(this.liquidaciones);
                const evt = new ShowToastEvent({
                                title: 'Gestión de Liquidaciones RRVV',
                                message: 'Se ha realizado el envio de las liquidaciones solicitadas al correo electrónico del Cliente.',
                                variant: 'success',
                            });

                            this.dispatchEvent(evt);

            }
            else{
                this.showLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Gestión de Liquidaciones RRVV',
                    message: 'No se ha realizado el envio de las liquidaciones solicitadas.',
                    variant: 'error',
            });
                this.dispatchEvent(evt);
            }

            }
        )
        .catch(error => {
            this.error = error;
        });
    }

}