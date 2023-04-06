import { LightningElement, track, api, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTasksForIds from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.getTasksForIds';
import changeOwnerTasks from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.changeOwnerTasks';
import changeStatusTasks from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.changeStatusTasks';
import getTasks_Filter from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.getTasks_Filter';

import get_pickList_SubEstado from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.get_pickList_SubEstado';

import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import STATUS_FIELD from '@salesforce/schema/Task.Status';

import get_pickList_CampagnasTeleventa from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.get_pickList_CampagnasTeleventa';

const columns = [

    {label: 'Campaña', fieldName: 'CampaignURL', type: 'url',sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'CampaignName'
        }
    }},
    {label: 'Asunto', fieldName: 'TaskURL', type: 'url',sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'Subject'
        }
    }},
    {label: 'Nombre Candidato', fieldName: 'LeadName', type: 'text',sortable: "true" },
    {label: 'RUT Candidato', fieldName: 'LeadRUT_DV', type: 'text' ,sortable: "true" },


    {label: 'Detalle Candidato', fieldName: 'RelationURL', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'LeadName'
        }
    }},
    { label: 'Fecha/hora Recordatorio', fieldName: 'ReminderDateTime', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Estado', fieldName: 'Status',sortable: "true" },
    { label: 'Sub-Estado', fieldName: 'SubStatus',sortable: "true" },
    { label: 'Prioridad', fieldName: 'Priority' },
   { label: 'RUT Ejecutivo Televenta', fieldName: 'RutEjecutivoTV' , type : 'text' ,sortable: "true"},
    {label: 'Asignado a', fieldName: 'OwnerURL', type: 'url', sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'OwnerName'
        },
        target: '_blank'
    }},
    { label: 'Fecha de Reprogramación/Original', fieldName: 'FechaReprogramacion' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Fecha de vencimiento', fieldName: 'ActivityDate' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Fecha/hora de creación', fieldName: 'CreatedDate', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Última fecha/hora de modificación', fieldName: 'LastModifiedDate', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
];

const columns_tlinks = [

    {label: 'Asunto', fieldName: 'TaskURL', type: 'url',sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'Subject'
        }
    }},
    {label: 'Nombre Candidato', fieldName: 'LeadName', type: 'text',sortable: "true" },
    {label: 'RUT Candidato', fieldName: 'LeadRUT_DV', type: 'text' ,sortable: "true" },


    {label: 'Detalle Candidato', fieldName: 'RelationURL', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'LeadName'
        }
    }},
    { label: 'Fecha/hora Recordatorio', fieldName: 'ReminderDateTime', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Estado', fieldName: 'Status',sortable: "true" },
    { label: 'Sub-Estado', fieldName: 'SubStatus',sortable: "true" },
    { label: 'Prioridad', fieldName: 'Priority' },
   { label: 'RUT Ejecutivo Televenta', fieldName: 'RutEjecutivoTV' , type : 'text' ,sortable: "true"},
    {label: 'Asignado a', fieldName: 'OwnerURL', type: 'url', sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'OwnerName'
        },
        target: '_blank'
    }},
    { label: 'Fecha de Reprogramación/Original', fieldName: 'FechaReprogramacion' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Fecha de vencimiento', fieldName: 'ActivityDate' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Fecha/hora de creación', fieldName: 'CreatedDate', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Última fecha/hora de modificación', fieldName: 'LastModifiedDate', type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
];

const columns_grid_popup = [

    {label: 'Campaña', fieldName: 'CampaignName', type: 'text'},
    {label: 'Asunto', fieldName: 'Subject', type: 'text'},
    {label: 'Nombre Candidato', fieldName: 'LeadName', type: 'text'},
    {label: 'RUT Candidato', fieldName: 'LeadRUT_DV', type: 'text'},
    { label: 'Estado', fieldName: 'Status' },
    { label: 'Sub-Estado', fieldName: 'SubStatus' },
    { label: 'Asignado a', fieldName: 'OwnerName' , type : 'text' },
];

export default class Bandeja_tareas_televenta extends LightningElement {

    @track tasks;
    @track error;
    @track columns = columns;
    @track columns_tlinks = columns_tlinks;
    @track columns_grid_popup = columns_grid_popup;
    @track sortBy;
    @track sortDirection;

    @track TaskSelected = [];
    @track tasksListChanged;

    @track openChangeOwner = false;
    @track newOwner;
    @track showLoading_changeOwner = false;

    @track openChangeStatus = false;
    @track showLoading_changeStatus = false;

    @track task_status;
    @track task_sub_status;

    @track estadoValue;
    @track subestadoValue;

    @track campaigns = [];
    @track campaignValue;

    @track showLoading = false;

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.tasks));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.tasks = parseData;
        this.data = this.tasks.slice(0, this.pageSize);
        this.page = 1;
    }

    connectedCallback()
    {
        get_pickList_CampagnasTeleventa({}).then(result => {
            let values = [];
            result.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.campaigns = values;
        });

        this.campagnaValue = '';
        this.rutLeadValue = '';
        this.statusTaskValue = '';
        this.subStatusTaskValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reminderDateTime = null;
        this.recordType = 'Ventas Oncológico';
        this.Option_VentaOncologico = true;
        this.loadData();
    }

    @track totalRegistros_Query = 0;

    loadData()
    {
        this.showLoading = true;
        this.page = 1;
        this.startingRecord = 1;
        this.endingRecord = 0;
       // getTasks( { } )

        getTasks_Filter( { RecordType : this.recordType, CampaignId : this.campagnaValue, RutCliente : this.rutLeadValue, Estado : this.statusTaskValue, SubEstado: this.subStatusTaskValue, AsignadoA : this.nameOwnerValue, NombreCliente : this.nameLeadValue, CreatedDate : this.createdDate, LastModifiedDate : this.lastModifiedDate, ReminderDateTime : this.reminderDateTime } )
        .then(result => {
            let tempRecords = JSON.parse( JSON.stringify( result ) );
            tempRecords = tempRecords.map( row => {
                return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                    CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                };
            })

            if(tempRecords){
                tempRecords.forEach(item => item['CampaignURL'] = '/lightning/r/Campaign/' +item['CampaignId'] +'/view');
                tempRecords.forEach(item => item['TaskURL'] = '/' +item['TaskId']);
                tempRecords.forEach(item => item['RelationURL'] = '/'+item['RelationId']);
                tempRecords.forEach(item => item['WhatURL'] = '/' +item['WhatId'] +'');
                tempRecords.forEach(item => item['OwnerURL'] = '/' +item['OwnerId'] +'');
            }

            this.tasks = tempRecords;

            this.totalRecountCount = this.tasks.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.data = this.tasks.slice(0, this.pageSize);

            this.totalRegistros_Query = this.tasks.length;

            // setTimeout(function () {
            //     this.showLoading = false;
            //   }, 1500);  // After 1.5 secs

            this.showLoading = false;
        })
        .catch(error => {
            this.tasks = undefined;
            this.error = error;
            // setTimeout(function () {
            //     this.showLoading = false;
            //   }, 1500);  // After 1.5 secs

            this.showLoading = false;
        });
        console.log('this.recordType  '+this.recordType);
    }

    handleClick_start_change_multiple_owner()
    {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();

        this.TaskSelected = [];
        this.tasksListChanged = [];

        for (var i = 0; i < selectedRecords.length; i++)
        {
            this.TaskSelected.push(selectedRecords[i].TaskId);
            console.log('@@@@ Id ' + selectedRecords[i].TaskId);
        }

        console.log('@@@@ this.TaskSelected.length ' + this.TaskSelected.length);

        getTasksForIds( { Ids : this.TaskSelected } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                        CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                    };
                })

                this.tasksListChanged = tempRecords;

            })
            .catch(error => {
                this.tasksListChanged = undefined;
                this.error = error;
            });

        console.log('@@@@ this.tasksListChanged.length ' + this.tasksListChanged.length);

        if (this.TaskSelected.length > 0)
        {
            this.openChangeOwner = true;
        }
        else{
            const evt = new ShowToastEvent({
                title: 'Cambiar Propietario (Asignado a) Tarea(s)',
                message: 'Debe seleccionar al menos una Tarea para realizar el cambio de Propietario.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }


    handleClick_saveChangeOwner(){

        this.showLoading_changeOwner = true;
        changeOwnerTasks({Ids : this.TaskSelected, newOwnerId : this.newOwner}).then(r => {

            if(r == true){

                const evt = new ShowToastEvent({
                    title: 'Actualizar Propietario Tarea(s)',
                    message: 'El Propietario de la(s) Tarea(s) ha sido exitosamente actualizado(s).',
                    variant: 'success',
                });

                this.dispatchEvent(evt);
                setTimeout(function () {
                this.showLoading_changeOwner = false;
                this.openChangeOwner = false;
                window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Actualizar Propietario Tarea(s)',
                    message: 'El Propietario de la(s) Tarea(s) NO ha sido exitosamente actualizado(s).',
                    variant: 'error',
                });
                this.dispatchEvent(evt);

                setTimeout(function () {
                   this.showLoading_changeOwner = false;
                   this.openChangeOwner = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
            }
        })
        .catch((error) => {
                setTimeout(function () {
                   this.showLoading_changeOwner = false;
                   this.openChangeOwner = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
        });
    }



    fieldsToCreate = ['Name','Username', 'Email']
    fields        = ['Name','Username'];

    handleLookup_User = (event) => {
        let data = event.detail.data;

        if(data && data.record){
            console.log('@@@@ data  ' +  data.record.Id);
            this.newOwner = data.record.Id;
            console.log('@@@@ this.newOwner  ' +  this.newOwner);
        }else{
        }
    }

    handleClick_closeChangeOwner()
    {
        this.openChangeOwner = false;
        this.newOwner = '';
    }


    handleClick_start_change_multiple_status()
    {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();

        this.TaskSelected = [];
        this.tasksListChanged = [];

        for (var i = 0; i < selectedRecords.length; i++)
        {
            this.TaskSelected.push(selectedRecords[i].TaskId);
            console.log('@@@@ Id ' + selectedRecords[i].TaskId);
        }

        console.log('@@@@ this.TaskSelected.length ' + this.TaskSelected.length);

        getTasksForIds( { Ids : this.TaskSelected } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                        CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                    };
                })

                this.tasksListChanged = tempRecords;

            })
            .catch(error => {
                this.tasksListChanged = undefined;
                this.error = error;
            });

        console.log('@@@@ this.tasksListChanged.length ' + this.tasksListChanged.length);

        if (this.TaskSelected.length > 0)
        {
            this.openChangeStatus = true;
        }
        else{
            const evt = new ShowToastEvent({
                title: 'Cambiar Estado Tarea(s)',
                message: 'Debe seleccionar al menos una Tarea para realizar el cambio de Estado.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

    @track task_subStatus;

    @track subStatusValue;

    @track statusValue;

    @wire(getPicklistValues, {
      recordTypeId: '0120H000001QUFUQA4', /*  RecordTypeId |--> Task --> Ventas Oncólogico */
      fieldApiName: STATUS_FIELD
    })
    task_status;

    handlePicklist_Status_Change(e){
        this.statusValue  = e.detail.value;
        this.subStatusValue  = '';
        console.log('@@@@ statusValue ' + this.statusValue );

        get_pickList_SubEstado({Estado : this.statusValue }).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.task_subStatus = [...values];
        });

    }

    handlePicklist_SubStatus_Change(e)
    {
        this.subStatusValue = e.detail.value;
    }

    handleClick_saveChangeStatus()
    {
        this.showLoading_changeStatus = true;
        changeStatusTasks({Ids : this.TaskSelected, Status : this.statusValue, SubStatus : this.subStatusValue}).then(r => {

            if(r == true){

                const evt = new ShowToastEvent({
                    title: 'Actualizar Estado Tarea(s)',
                    message: 'El Estado de la(s) Tarea(s) ha sido exitosamente actualizado(s).',
                    variant: 'success',
                });

                this.dispatchEvent(evt);
                setTimeout(function () {
                this.showLoading_changeStatus = false;
                this.openChangeStatus = false;
                window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Actualizar Estado Tarea(s)',
                    message: 'El Estado de la(s) Tarea(s) NO ha sido exitosamente actualizado(s).',
                    variant: 'error',
                });
                this.dispatchEvent(evt);

                setTimeout(function () {
                   this.showLoading_changeStatus = false;
                   this.openChangeStatus = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
            }
        })
        .catch((error) => {
                setTimeout(function () {
                   this.showLoading_changeStatus = false;
                   this.openChangeStatus = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
        });
    }

    handleClick_closeChangeStatus()
    {
        this.openChangeStatus = false;
    }

    @track page = 1;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 50;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track data = [];

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }
    }


    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount)
                            ? this.totalRecountCount : this.endingRecord;

        this.data = this.tasks.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }

    @track campagnaValue;
    @track rutLeadValue;
    @track statusTaskValue;
    @track subStatusTaskValue;
    @track nameOwnerValue;
    @track nameLeadValue;
    @track createdDate;
    @track lastModifiedDate;
    @track reminderDateTime;


    @track taskFilter_subStatus = [];

    handlePicklist_Campaign_Change(e)
    {
        this.campagnaValue = e.detail.value;
        this.loadData();
    }


    handleInput_rutLead_Change(e)
    {
        this.rutLeadValue = e.detail.value;
        console.log(' RL  '+this.rutLeadValue);
        this.loadData();
    }

    handlePicklist_statusTask_Change(e){
        this.statusTaskValue = e.detail.value;
        console.log(' ST  '+this.statusTaskValue);
        this.subStatusTaskValue  = '';
        this.loadData();
        get_pickList_SubEstado({Estado : this.statusTaskValue }).then(r => {
            let values = [];
            values.push({label: '', value: '' });

            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.taskFilter_subStatus = [...values];
        });
     }

    handlePicklist_subStatusTask_Change(e)
    {
        this.subStatusTaskValue = e.detail.value;
        console.log(' SST  '+this.subStatusTaskValue);
        this.loadData();
    }

    handleInput_nameOwner_Change(e)
    {
        this.nameOwnerValue = e.detail.value;
        console.log(' NO  '+this.nameOwnerValue);
        this.loadData();
    }

    handleInput_nameLead_Change(e)
    {
        this.nameLeadValue = e.detail.value;
        console.log(' NA  '+this.nameLeadValue);
        this.loadData();
    }

    handleInput_createdDate_Change(e)
    {
        this.createdDate = e.detail.value;
        console.log(' FC  '+this.createdDate);
        this.loadData();
    }


    handleInput_lastModifiedDate_Change(e)
    {
        this.lastModifiedDate = e.detail.value;
        console.log(' FUC  '+this.lastModifiedDate);
        this.loadData();
    }

    handleInput_reminderDateTime_Change(e)
    {
        this.reminderDateTime = e.detail.value;
        console.log(' FUC  '+this.lastreminderDateTimeModifiedDate);
        this.loadData();
    }

    handleClick_RestartFilter()
    {
        this.campagnaValue = '';
        this.rutLeadValue = '';
        this.statusTaskValue = '';
        this.subStatusTaskValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reminderDateTime = null;
        this.loadData();
    }

    @track recordType = '';
    @track Option_VentaOncologico = false;
    @track Option_TareaTeleventasLinks = false;

    get optionsTypeTask() {
        return [
            { label: 'Ventas Oncológico', value: 'Ventas Oncológico' },
            { label: 'Tarea Televentas Links', value: 'Tarea Televentas Links' },
        ];
    }

    handle_SelectTypeTask_OnChange(e) {
        this.recordType = e.detail.value;
        console.log('RecordType '+this.recordType);
        if (this.recordType == 'Ventas Oncológico')
        {
            this.Option_TareaTeleventasLinks = false;

            this.initial_VentaOncologico();

            this.Option_VentaOncologico = true;
        }
        else if (this.recordType == 'Tarea Televentas Links')
        {
            this.Option_VentaOncologico = false;
            this.initial_TareaTeleventaLinks();

            this.Option_TareaTeleventasLinks = true;
        }
    }

    initial_VentaOncologico()
    {
        get_pickList_CampagnasTeleventa({}).then(result => {
            let values = [];
            result.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.campaigns = values;
        });

        this.campagnaValue = '';
        this.rutLeadValue = '';
        this.statusTaskValue = '';
        this.subStatusTaskValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reminderDateTime = null;
     //   this.recordType = 'Ventas Oncológico';
        this.loadData();
    }

    initial_TareaTeleventaLinks()
    {
        this.rutLeadValue = '';
        this.statusTaskValue = '';
        this.subStatusTaskValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reminderDateTime = null;
       // this.recordType = 'Tarea Televentas Links';
        this.loadData();
    }

}