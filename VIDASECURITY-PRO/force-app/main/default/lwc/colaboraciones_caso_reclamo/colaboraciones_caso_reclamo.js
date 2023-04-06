import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue, getRecordNotifyChange } from 'lightning/uiRecordApi';
import getColaboracionesCaso from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.getColaboracionesCaso';
import get_List_BandejasUR from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.get_List_BandejasUR';
import get_pickList_Priority from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.get_pickList_Priority';
import create_Colaboracion_Reclamo from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.create_Colaboracion_Reclamo';
import get_Colaboracion_Reclamo from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.get_Colaboracion_Reclamo';
import create_TaskComment from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.create_TaskComment';
import get_TaskComments from '@salesforce/apex/CLS_CS_Colaboraciones_Reclamo.get_TaskComments';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import CASE_OBJECT from '@salesforce/schema/Case';
// import ID_FIELD from '@salesforce/schema/Case.Id';
import {refreshApex} from '@salesforce/apex';

const columns = [
    {
        type: "button",
        initialWidth: 120,
        initialHeigth: 22,
        typeAttributes: {
            label: 'Detalle',
            name: 'View',
            title: 'Detalle de colaboración',
            disabled: false,
            value: 'view',
            iconPosition: 'left'
        }
    },
    { label: 'Asunto', fieldName: 'Subject'},
    { label: 'Descripción', fieldName: 'Description', initialHeigth: 50,initialWidth: 350 },
    { label: 'Estado', fieldName: 'Status' },
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
    { label: 'Fecha Vencimiento', fieldName: 'ActivityDate', type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric'
    }},
    {label: 'Unidad Resolutora', fieldName: 'OwnerName', type: 'text',
    typeAttributes: {
        label: {
            fieldName: 'OwnerName'
        }
    }},
    { label: 'Responsable UR', fieldName: 'ResponsableName', type : 'text' }
];


const columns_tc = [

    { label: 'Comentario', fieldName: 'Detail__c' , initialWidth: 350},
    { label: 'Responsable UR', fieldName: 'Responsable_UR__c' },
    { label: 'Ejecutiva', fieldName: 'Ejecutiva_Caso__c' },
    { label: 'Creado por', fieldName: 'CreatedName' },
    { label: 'Fecha Creación', fieldName: 'CreatedDate', type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }}
];


export default class Colaboraciones_caso_reclamo extends LightningElement {

    @api recordId;

    @wire( getColaboracionesCaso, { Id: '$recordId' } )
    wiredData( { error, data } ) {
        if ( data ) {
            let tempRecords = JSON.parse( JSON.stringify( data ) );

            tempRecords = tempRecords.map( row => {
                if (row.Responsable_Backup__r != null)
                {
                    return { ...row, OwnerName : row.Owner.Name, ResponsableName : row.Responsable_Backup__r.Name
                    };
                }
                else
                {
                    return { ...row, OwnerName : row.Owner.Name
                    };
                }

            })

            this.tasks = tempRecords;

        }
        else if ( error ) {

            console.error( JSON.stringify( error ) );
        }
    }

    @track showLoading = false;
    @track tasks;
    @track error;
    @track columns = columns;
    @track columns_tc = columns_tc;
    @track sortBy;
    @track sortDirection;
    @track URSelect = [];
    @track unidadesResolutoras = [];
    @track descripcionValue;
    @track fechaVencimientoValue;
    @track priorityValue;
    @track prioridadesTarea = [];
    @track open_modal_new = false;
    @track open_modal_det = false;

    @track Task_Status;
    @track Task_CaseNumber;
    @track Task_OwnerName;
    @track Task_Subject;
    @track Task_Cliente;
    @track Task_Poliza;
    @track Task_Priority;
    @track Task_ResponsableUR;
    @track Task_FechaVencimiento;
    @track Task_Description;

    @track comentarioValue;
    @track taskcomments = [];

    @track TaskSelectId;
    @track ResponsableOK = false;

    callRowAction( event ) {
        const id =  event.detail.row.Id;
        console.log('@@@@ ID --> '+ id);
        this.taskcomments = [];
        this.TaskSelectId = id;
        get_Colaboracion_Reclamo( { Id : id } )
        .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );

                console.log('@@@@ result --> '+ result);
                console.log('@@@@ tempRecords --> '+ tempRecords);

                this.Task_Status = tempRecords.Task_Status;
                this.Task_CaseNumber = tempRecords.Case_CaseNumber;
                this.Task_OwnerName = tempRecords.Task_OwnerName;
                this.Task_Subject = tempRecords.Task_Subject;
                this.Task_Cliente = tempRecords.Case_Nombre_Completo_Razon_Social;
                this.Task_Poliza = tempRecords.Case_CASO_N_Poliza;
                this.Task_Priority = tempRecords.Task_Priority;
                this.Task_ResponsableUR = tempRecords.Task_Responsable_Backup;
                this.Task_FechaVencimiento = tempRecords.Task_ActivityDate;
                this.Task_Description = tempRecords.Task_Description;

                console.log('@@@@ this.Task_Status --> '+ this.Task_Status);
                console.log('@@@@ this.Task_CaseNumber --> '+ this.Task_CaseNumber);
                console.log('@@@@ this.Task_OwnerName --> '+ this.Task_OwnerName);
                console.log('@@@@ this.Task_Subject --> '+ this.Task_Subject);
                console.log('@@@@ this.Task_Cliente --> '+ this.Task_Cliente);
                console.log('@@@@ this.Task_Poliza --> '+ this.Task_Poliza);
                console.log('@@@@ this.Task_Priority --> '+ this.Task_Priority);
                console.log('@@@@ this.Task_ResponsableUR --> '+ this.Task_ResponsableUR);
                console.log('@@@@ this.Task_FechaVencimiento --> '+ this.Task_FechaVencimiento);
                console.log('@@@@ this.Task_Description --> '+ this.Task_Description);

                if (this.Task_ResponsableUR != 'Responsable no asignado')
                {
                    this.ResponsableOK = true;
                }

            }
        )
        .catch(error => {
            this.error = error;
        });

        console.log('@@@@ TaskSelectId --> '+   this.TaskSelectId);

        get_TaskComments( { Id :   this.TaskSelectId } )
        .then(result => {
            let tempRecords = JSON.parse( JSON.stringify( result ) );

            tempRecords = tempRecords.map( row => {
                return { ...row, CreatedName : row.CreatedBy.Name
                };
            })

            this.taskcomments = tempRecords;
            console.log('@@@@ taskcomments start --> '+   this.taskcomments.length);

            }
        )
        .catch(error => {
            this.error = error;
        });

        this.open_modal_det = true;
   }

   loadNewColaboracion()
   {
        get_List_BandejasUR({}).then(result => {
            let values = [];
            result.forEach(rv => {
                // from APEX
                values.push({label: rv.Name, value: rv.Id });
                console.log('@@@@  --> '+rv.Name + '  @@  '+ rv.Id );
            });
            // LWC array tracking workaround
                this.unidadesResolutoras = values;
            });

        get_pickList_Priority({}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.prioridadesTarea = [...values];

        });

        this.priorityValue = 'Normal';
        this.URSelect = [];
        this.descripcionValue = '';
        var today = new Date();
        var dd = today.getDate();

        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();
        if(dd<10)
        {
            dd='0'+dd;
        }

        if(mm<10)
        {
            mm='0'+mm;
        }

        today = yyyy+'-'+mm+'-'+dd;
        console.log(dd);
        console.log(mm);
        console.log(yyyy);
        console.log(today);

        this.fechaVencimientoValue = today;
   }

   handleClick_new_colaboracion_reclamo()
   {
       this.loadNewColaboracion();
       this.open_modal_new = true;
   }

   handleClick_close_NewColaboration()
   {
       this.open_modal_new = false;
   }

   handleClick_create_NewColaboration()
   {
       console.log('@@@@ this.URSelect.length --> ' +this.URSelect.length);

        this.showLoading = true;
        if (this.URSelect.length > 0)
        {
            this.open_modal_new = false;

            console.log('this.recordId  '+this.recordId);
            console.log('this.URSelect  '+this.URSelect);
            console.log('this.descripcionValue  '+this.descripcionValue);
            console.log('this.fechaVencimientoValue  '+this.fechaVencimientoValue);
            console.log('this.priorityValue  '+this.priorityValue);

            create_Colaboracion_Reclamo({Id : this.recordId, UR_Ids : this.URSelect, Descripcion : this.descripcionValue , FechaVencimiento : this.fechaVencimientoValue , Prioridad : this.priorityValue}).then(result => {
                if(result != null){

                    result.forEach((row) => {
                        window.console.log("res.Subject: " + row.Subject);
                        window.console.log("res.Description: " + row.Description);

                        window.console.log("res.CreatedDate: " + row.CreatedDate);
                        window.console.log("res.Owner.Name: " + row.Owner.Name);
                        window.console.log("res.Status: " + row.Status);
                        // this.tasks = [...this.tasks , { Subject :  row.Subject , Description : row.Description, Status : row.Status, CreatedDate : row.CreatedDate, ActivityDate :  row.ActivityDate, OwnerName : row.Owner.Name, Responsable_Backup__c : row.Responsable_Backup__c}];
                        let lineItem = {};
                        lineItem.Id = row.Id;
                        lineItem.Subject = row.Subject;
                        lineItem.Description = row.Description;
                        lineItem.Status = row.Status;
                        lineItem.CreatedDate = row.CreatedDate;
                        lineItem.ActivityDate = row.ActivityDate;
                        lineItem.OwnerName = row.Owner.Name;
                        lineItem.Responsable_Backup__c = row.Responsable_Backup__c;

                        this.tasks = [...this.tasks ,lineItem ];
                        this.taskcomments = [];
                    });

                    const evt = new ShowToastEvent({
                        title: 'Creación de Colaboración caso Reclamo',
                        message: 'La Colaboración caso Reclamo ha sido exitosamente creada.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    this.showLoading = false;

            }
                else{
                    this.showLoading = false;
                    const evt = new ShowToastEvent({
                        title: 'Creación de Colaboración caso Reclamo',
                        message: 'Colaboración caso Reclamo no ha sido creada.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            })
            .catch((error) => {
                this.showLoading = false;
                this.open_modal_new = false;
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
        else
        {
            this.showLoading = false;
            const evt = new ShowToastEvent({
                title: 'Creación de Colaboración caso Reclamo',
                message: 'Debe seleccionar ak menos una Bandeja UR para crear la colaboración.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
   }

   handle_unidades_resolutoras(e)
   {
       this.URSelect = e.detail.value;
       console.log('URSelect  --> '+this.URSelect);
   }

   handlePicklist_TaskPriority_Change(e)
   {
       this.priorityValue = e.detail.value;
       console.log('priorityValue  --> '+this.priorityValue);
   }

   handle_FechaVencimiento_Change(e)
   {
       this.fechaVencimientoValue = e.detail.value;
       console.log('fechaVencimientoValue  --> '+this.fechaVencimientoValue);
   }

   handle_Descripcion_Change(e)
   {
       this.descripcionValue = e.detail.value;
       console.log('descripcionValue  --> '+this.descripcionValue);
   }

   handle_Comentario_Change(e)
   {
       this.comentarioValue = e.detail.value;
       console.log('comentarioValue  --> '+this.comentarioValue);
   }

   handleClick_close_Colaboration()
   {
       this.open_modal_det = false;
   }

   handleClick_cancel_NewComment()
   {
       this.comentarioValue = '';
   }

   handleClick_create_NewComment()
   {
    create_TaskComment({Id :   this.TaskSelectId, Detalle : this.comentarioValue, Notificacion : 'CEJ_CM'}).then(result => {
            if(result != null){

                result.forEach((row) => {
                    window.console.log("res.Detail__c: " + row.Detail__c);
                    window.console.log("res.Ejecutiva_Caso__c: " + row.Ejecutiva_Caso__c);
                    window.console.log("res.CreatedDate: " + row.CreatedDate);
                    window.console.log("res.Responsable_Backup__c: " + row.Responsable_Backup__c);
                    // this.tasks = [...this.tasks , { Subject :  row.Subject , Description : row.Description, Status : row.Status, CreatedDate : row.CreatedDate, ActivityDate :  row.ActivityDate, OwnerName : row.Owner.Name, Responsable_Backup__c : row.Responsable_Backup__c}];
                    let lineItem = {};
                    lineItem.Detail__c = row.Detail__c;
                    lineItem.Ejecutiva_Caso__c = row.Ejecutiva_Caso__c;
                    lineItem.Responsable_Backup__c = row.Responsable_Backup__c;
                    lineItem.Ejecutiva_Caso__c = row.Ejecutiva_Caso__c;
                    lineItem.CreatedDate = row.CreatedDate;
                    lineItem.CreatedName = row.CreatedBy.Name;

                    this.taskcomments = [...this.taskcomments ,lineItem ];
                });
                this.comentarioValue = '';
                const evt = new ShowToastEvent({
                    title: 'Creación comentario Colaboración caso Reclamo',
                    message: 'El comentario ingresado ha sido exitosamente creado.',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.showLoading = false;

        }
            else{
                this.showLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Creación comentario Colaboración caso Reclamo',
                    message: 'El comentario ingresado no ha sido creado.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
        .catch((error) => {
            this.showLoading = false;
            this.open_modal_new = false;
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