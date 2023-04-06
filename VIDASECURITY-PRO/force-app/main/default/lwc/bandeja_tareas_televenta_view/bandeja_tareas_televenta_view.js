import { LightningElement, track, api, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTasks_Filter_Owner from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.getTasks_Filter_Owner';
import getTasks_Remembers_Owner from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.getTasks_Remembers_Owner';

import get_pickList_SubEstado from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.get_pickList_SubEstado';

import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import STATUS_FIELD from '@salesforce/schema/Task.Status';

import get_pickList_CampagnasTeleventa from '@salesforce/apex/CLS_CM_BandejaTareas_Televenta.get_pickList_CampagnasTeleventa';
import userId from '@salesforce/user/Id';
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
    // { label: 'Fecha de Reprogramación/Original', fieldName: 'FechaReprogramacion' , type: 'date',sortable: "true",
    // typeAttributes: {
    // day: 'numeric',
    // month: 'numeric',
    // year: 'numeric',
    // hour: '2-digit',
    // minute: '2-digit',
    // second: '2-digit',
    // hour24: true
    // }},
    // { label: 'Fecha de vencimiento', fieldName: 'ActivityDate' , type: 'date',sortable: "true",
    // typeAttributes: {
    // day: 'numeric',
    // month: 'numeric',
    // year: 'numeric',
    // hour: '2-digit',
    // minute: '2-digit',
    // second: '2-digit',
    // hour24: true
    // }},
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
    // { label: 'Fecha de Reprogramación/Original', fieldName: 'FechaReprogramacion' , type: 'date',sortable: "true",
    // typeAttributes: {
    // day: 'numeric',
    // month: 'numeric',
    // year: 'numeric',
    // hour: '2-digit',
    // minute: '2-digit',
    // second: '2-digit',
    // hour24: true
    // }},
    // { label: 'Fecha de vencimiento', fieldName: 'ActivityDate' , type: 'date',sortable: "true",
    // typeAttributes: {
    // day: 'numeric',
    // month: 'numeric',
    // year: 'numeric',
    // hour: '2-digit',
    // minute: '2-digit',
    // second: '2-digit',
    // hour24: true
    // }},
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

    // {label: 'Campaña', fieldName: 'CampaignName', type: 'text'},
    {label: 'Asunto', fieldName: 'TaskURL_Bl', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'Subject'
        },
        target: '_blank'
    }},
    {label: 'Nombre Candidato', fieldName: 'LeadName', type: 'text'},
    // {label: 'RUT Candidato', fieldName: 'LeadRUT_DV', type: 'text'},
    { label: 'Fecha/hora Recordatorio', fieldName: 'ReminderDateTime', type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    // { label: 'Estado', fieldName: 'Status' },
    // { label: 'Sub-Estado', fieldName: 'SubStatus' },
];


export default class Bandeja_tareas_televenta_view extends LightningElement {

    @track tasks;
    @track error;
    @track columns = columns;
    @track columns_tlinks = columns_tlinks;

    @track sortBy;
    @track sortDirection;

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

    @track ownerId = userId;


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

        getTasks_Filter_Owner( {RecordType : this.recordType, OwnerId : this.ownerId, CampaignId : this.campagnaValue, RutCliente : this.rutLeadValue, Estado : this.statusTaskValue, SubEstado: this.subStatusTaskValue, NombreCliente : this.nameLeadValue, CreatedDate : this.createdDate, LastModifiedDate : this.lastModifiedDate, ReminderDateTime : this.reminderDateTime } )
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
        console.log(' FRE  '+this.reminderDateTime);
        this.loadData();
    }

    handleClick_RestartFilter()
    {
        this.campagnaValue = '';
        this.rutLeadValue = '';
        this.statusTaskValue = '';
        this.subStatusTaskValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reminderDateTime = null;
        this.loadData();
    }

    @track openNotifications = false;

    @track columns_grid_popup = columns_grid_popup;
    @track taskListNotifications;

    handleClick_Notifications()
    {
        this.loadData_Remembers();
        this.openNotifications = true;
    }

    handleClick_closeNotifications()
    {
        this.openNotifications = false;
    }

    loadData_Remembers()
    {
        this.taskListNotifications = [];

        getTasks_Remembers_Owner( { RecordType : this.recordType, OwnerId : this.ownerId } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                        CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                    };
                })

                if(tempRecords){
                    tempRecords.forEach(item => item['TaskURL_Bl'] = '/' +item['TaskId']);
                }

                this.taskListNotifications = tempRecords;

            })
            .catch(error => {
                this.taskListNotifications = undefined;
                this.error = error;
            });

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
        this.loadData();
    }

}