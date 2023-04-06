import { LightningElement, track, api, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeads_Filter_Owner from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter_Owner';

import get_pickList_SubEstado from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.get_pickList_SubEstado';
import changeOwnerLeads from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.changeOwnerLeads';

import getLeadForIds from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.getLeadForIds';

import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import TIPOLINK_FIELD from '@salesforce/schema/Lead.Tipo_Link__c';
import TIPOBASE_FIELD from '@salesforce/schema/Lead.Tipo_Base__c';

import getLeads_CallRemembers_Owner from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.getLeads_CallRemembers_Owner';
import getLeads_CallTask_Remembers_Owner from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.getLeads_CallTask_Remembers_Owner';




import get_pickList_CampagnasLinks from '@salesforce/apex/CLS_CM_Bandeja_Prospectos_Links.get_pickList_CampagnasLinks';
import userId from '@salesforce/user/Id';

const columns = [

    {label: 'Campaña', fieldName: 'CampaignURL', type: 'url',sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'CampaignName'
        }
    }},
    {label: 'Nombre Candidato', fieldName: 'LeadNameURL', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'LeadName'
        }
    }},
    {label: 'RUT Candidato', fieldName: 'LeadRUT_DV', type: 'text' ,sortable: "true" },
    // {label: 'Cuenta asociada', fieldName: 'AccountURL', type: 'url',
    // typeAttributes: {
    //     label: {
    //         fieldName: 'AccountName'
    //     }
    // }},
    { label: 'Nombre de Base', fieldName: 'NombreBase',sortable: "true" },
    { label: 'Tipo de Base', fieldName: 'TipoBase',sortable: "true" },
    { label: 'Tipo de Link', fieldName: 'TipoLink',sortable: "true" },

    { label: 'Estado', fieldName: 'Status',sortable: "true" },
    { label: 'Sub-Estado', fieldName: 'SubStatus',sortable: "true" },
    { label: 'Reprogramación', fieldName: 'Reprogramacion' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    { label: 'Fecha de Entrevista', fieldName: 'FechaEntrevista' , type: 'date',sortable: "true",
    typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour24: true
    }},
    {label: 'Propietario', fieldName: 'OwnerURL', type: 'url', sortable: "true",
    typeAttributes: {
        label: {
            fieldName: 'OwnerName'
        }
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

const columns_grid_popup_pl = [

    {label: 'Campaña', fieldName: 'CampaignName', type: 'text'},
    {label: 'Prospecto', fieldName: 'LeadName', type: 'text'},
    {label: 'RUT Prospecto', fieldName: 'LeadRUT_DV', type: 'text' ,sortable: "true" },
    { label: 'Nombre de Base', fieldName: 'NombreBase',sortable: "true" },
    { label: 'Tipo de Base', fieldName: 'TipoBase',sortable: "true" },
    { label: 'Tipo de Link', fieldName: 'TipoLink',sortable: "true" },
    { label: 'Estado', fieldName: 'Status',sortable: "true" },
    { label: 'Sub-Estado', fieldName: 'SubStatus',sortable: "true" }

];

const columns_grid_popup_call = [

    {label: 'Campaña', fieldName: 'CampaignName', type: 'text'},
    {label: 'Candidato', fieldName: 'LeadNameURL', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'LeadName'
        },
        target: '_blank'
    }},
    { label: 'Reprogramación', fieldName: 'Reprogramacion' , type: 'date',
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


const columns_grid_popup_calltask = [

    // {label: 'Campaña', fieldName: 'CampaignName', type: 'text'},
    {label: 'Asunto', fieldName: 'TaskURL', type: 'url',
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

export default class Bandeja_prospectos_links_view extends LightningElement {

    @track leads;
    @track error;
    @track columns = columns;
    @track columns_grid_popup_call = columns_grid_popup_call;
    @track columns_grid_popup_calltask = columns_grid_popup_calltask;
    @track columns_grid_popup_pl = columns_grid_popup_pl;
    @track sortBy;
    @track sortDirection;

    @track totalRegistros_Query = 0;

    @track showLoading = false;

    @track ownerId = userId;

    @track page = 1;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 40;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track data = [];

    @track campagnaValue;
    @track rutLeadValue;
    @track statusValue;
    @track subStatusValue;
    @track nameOwnerValue;
    @track nameLeadValue;
    @track createdDate;
    @track lastModifiedDate;
    @track reprogramacion;
    @track fechaEntrevista;
    @track nombreBase;
    @track tipoBaseValue;
    @track tipoLinkValue;

    @track lead_status;
    @track lead_tipoLink;
    @track lead_tipoBase;

    @wire(getPicklistValues, {
        recordTypeId: '0120H000000yVTiQAM', /*  RecordTypeId |--> Lead --> Prospecto Links */
        fieldApiName: STATUS_FIELD
      })
      lead_status;

      @wire(getPicklistValues, {
        recordTypeId: '0120H000000yVTiQAM', /*  RecordTypeId |--> Lead --> Prospecto Links */
        fieldApiName: TIPOLINK_FIELD
      })
      lead_tipoLink;

      @wire(getPicklistValues, {
        recordTypeId: '0120H000000yVTiQAM', /*  RecordTypeId |--> Lead --> Prospecto Links */
        fieldApiName: TIPOBASE_FIELD
      })
      lead_tipoBase;



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

        this.data = this.leads.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.leads));
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
        this.leads = parseData;
        this.data = this.leads.slice(0, this.pageSize);
        this.page = 1;
    }

    loadData()
    {
        this.showLoading = true;
        this.page = 1;
        this.startingRecord = 1;
        this.endingRecord = 0;
        //   getLeads_Filter( { } )

        var owner = '';
        if (this.typeSearch == 'Mis Prospectos')
        {
            owner = this.ownerId;
        }
        else  if (this.typeSearch == 'Pool Link')
        {
            owner = '00G0H0000070l14UAA';//Id de Pool Link
        }

        getLeads_Filter_Owner( { OwnerId : owner, CampaignId : this.campagnaValue, RutCliente : this.rutLeadValue, Estado : this.statusValue, SubEstado: this.subStatusValue, NombreCliente : this.nameLeadValue, CreatedDate : this.createdDate, LastModifiedDate : this.lastModifiedDate, FechaEntrevista: this.fechaEntrevista, Reprogramacion : this.reprogramacion, NombreBase : this.nombreBase, TipoBase : this.tipoBaseValue, TipoLink : this.tipoLinkValue } )
        .then(result => {
            let tempRecords = JSON.parse( JSON.stringify( result ) );
            tempRecords = tempRecords.map( row => {
                return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                    CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                };
            })

            if(tempRecords){
                tempRecords.forEach(item => item['CampaignURL'] = '/lightning/r/Campaign/' +item['CampaignId'] +'/view');
                tempRecords.forEach(item => item['LeadNameURL'] = '/' +item['LeadId']);
                // tempRecords.forEach(item => item['AccountURL'] = '/'+item['AccountId']);
                tempRecords.forEach(item => item['OwnerURL'] = '/' +item['OwnerId'] +'');
            }

            this.leads = tempRecords;

            this.totalRecountCount = this.leads.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.data = this.leads.slice(0, this.pageSize);

            this.totalRegistros_Query = this.leads.length;

            // setTimeout(function () {
            //     this.showLoading = false;
            //   }, 1500);  // After 1.5 secs

            this.showLoading = false;
        })
        .catch(error => {
            this.leads = [];
            this.error = error;
            // setTimeout(function () {
            //     this.showLoading = false;
            //   }, 1500);  // After 1.5 secs

            this.showLoading = false;
        });

    }

    connectedCallback()
    {
        get_pickList_CampagnasLinks({}).then(result => {
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
        this.statusValue = '';
        this.subStatusValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reprogramacion = null;
        this.fechaEntrevista = null;
        this.nombreBase = '';
        this.tipoBaseValue = '';
        this.tipoLinkValue = '';
        this.typeSearch = 'Mis Prospectos';
        this.loadData();
    }


    handlePicklist_Campaign_Change(e)
    {
        this.campagnaValue = e.detail.value;
        this.loadData();
    }


    @track leadFilter_subStatus = [];

    handlePicklist_status_Change(e)
    {
        this.statusValue = e.detail.value;

        console.log(' ST  '+this.statusValue);

        this.subStatusValue  = '';

        this.loadData();

        get_pickList_SubEstado({Estado : this.statusValue }).then(r => {
            let values = [];
            values.push({label: '', value: '' });

            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.leadFilter_subStatus = [...values];
        });
     }

    handlePicklist_subStatus_Change(e)
    {
        this.subStatusValue = e.detail.value;
        console.log(' SST  '+this.subStatusValue);
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

    handleInput_reprogramacion_Change(e)
    {
        this.reprogramacion = e.detail.value;
        console.log(' FR '+this.reprogramacion);
        this.loadData();
    }

    handleInput_fechaEntrevista_Change(e)
    {
        this.fechaEntrevista = e.detail.value;
        console.log(' FE '+this.fechaEntrevista);
        this.loadData();
    }

    handleInput_rutLead_Change(e)
    {
        this.rutLeadValue = e.detail.value;
        console.log(' RL  '+this.rutLeadValue);
        this.loadData();
    }

    handleInput_nombreBase_Change(e)
    {
        this.nombreBase = e.detail.value;
        console.log(' NB  '+this.nombreBase);
        this.loadData();
    }

    handlePicklist_tipoBase_Change(e)
    {
        this.tipoBaseValue = e.detail.value;
        this.loadData();
    }

    handlePicklist_tipoLink_Change(e)
    {
        this.tipoLinkValue = e.detail.value;
        this.loadData();
    }



    handleClick_RestartFilter()
    {
        this.campagnaValue = '';
        this.rutLeadValue = '';
        this.statusValue = '';
        this.subStatusValue = '';
        this.nameOwnerValue = '';
        this.nameLeadValue = '';
        this.createdDate = null;
        this.lastModifiedDate = null;
        this.reprogramacion = null;
        this.fechaEntrevista = null;
        this.nombreBase = '';
        this.tipoBaseValue = '';
        this.tipoLinkValue = '';
        //this.typeSearch = 'Mis Prospectos';
        this.loadData();
    }


    @track call_ListNotifications;
    @track callTask_ListNotifications;

    @track open_CallNotifications = false;
    @track open_CallTaskNotifications = false;

    @track showLoading_CallNotifications = false;
    @track showLoading_CallTaskNotifications = false;


    handleClick_close_CallNotifications()
    {
        this.open_CallNotifications = false;
    }

    handleClick_close_CallTaskNotifications()
    {
        this.open_CallTaskNotifications = false;
    }


    loadData_Call_Remembers()
    {
        this.call_ListNotifications = [];

        getLeads_CallRemembers_Owner( { OwnerId : this.ownerId } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row
                    };
                })

                if(tempRecords){
                    tempRecords.forEach(item => item['LeadNameURL'] = '/' +item['LeadId']);
                }

                this.call_ListNotifications = tempRecords;
            }
        )
        .catch(error => {
            this.call_ListNotifications = undefined;
            this.error = error;
        });
    }

    loadData_CallTask_Remembers()
    {
        this.callTask_ListNotifications = [];

        getLeads_CallTask_Remembers_Owner( { OwnerId : this.ownerId } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );
                tempRecords = tempRecords.map( row => {
                    return { ...row
                    };
                })

                if(tempRecords){
                    tempRecords.forEach(item => item['TaskURL'] = '/' +item['TaskId']);
                }

                this.callTask_ListNotifications = tempRecords;
            }
        )
        .catch(error => {
            this.callTask_ListNotifications = undefined;
            this.error = error;
        });
    }

    handleClick_Call_Notifications()
    {
        this.loadData_Call_Remembers();
        this.open_CallNotifications = true;
    }



    handleClick_CallTask_Notifications()
    {
        this.loadData_CallTask_Remembers();
        this.open_CallTaskNotifications = true;
    }

    @track typeSearch = '';

    get optionsTypeSearch() {
        return [
            { label: 'Mis Prospectos', value: 'Mis Prospectos' },
            { label: 'Pool Link', value: 'Pool Link'},
        ];
    }

    handle_SelectTypeSearch_OnChange(e) {
        this.typeSearch = e.detail.value;
        console.log('typeSearch '+this.typeSearch);
        if (this.typeSearch == 'Mis Prospectos')
        {
            this.isPoolLinkAction = false;
        }
        else if (this.typeSearch == 'Pool Link')
        {
            this.isPoolLinkAction = true;
        }
        this.loadData();
    }

    @track LeadSelected = [];
    @track leadsListChanged;

    @track showLoading_PoolLink = false;
    @track open_PoolLink = false;

    @track isPoolLinkAction = false;

    handleClick_start_change_PoolLink()
    {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();

        this.LeadSelected = [];
        this.leadsListChanged = [];

        for (var i = 0; i < selectedRecords.length; i++)
        {
            this.LeadSelected.push(selectedRecords[i].LeadId);
            console.log('@@@@ Id ' + selectedRecords[i].LeadId);
        }

        console.log('@@@@ this.LeadSelected.length ' + this.LeadSelected.length);

        getLeadForIds( { Ids : this.LeadSelected } )
            .then(result => {
                let tempRecords = JSON.parse( JSON.stringify( result ) );

                tempRecords = tempRecords.map( row => {
                    return { ...row, OwnerName : row.OwnerName, LeadName :row.LeadName,
                        CampaignName : row.CampaignName, LeadRUT : row.LeadRUT
                    };
                })

                this.leadsListChanged = tempRecords;

            })
            .catch(error => {
                this.leadsListChanged = undefined;
                this.error = error;
            });

        console.log('@@@@ this.leadsListChanged.length ' + this.leadsListChanged.length);

        if (this.LeadSelected.length > 0)
        {
            this.open_PoolLink = true;
        }
        else{
            const evt = new ShowToastEvent({
                title: 'Asignarse Prospecto(s) Pool Link',
                message: 'Debe seleccionar al menos un Prospecto para asignarse Prospectos Pool Link.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

    handleClick_closePoolLink()
    {
        this.open_PoolLink = false;
    }

    handleClick_savePoolLink()
    {
        this.showLoading_PoolLink = true;
        changeOwnerLeads({Ids : this.LeadSelected, newOwnerId : this.ownerId}).then(r => {

            if(r == true){

                const evt = new ShowToastEvent({
                    title: 'Asignarse Prospecto(s) Pool Link',
                    message: 'La asignación de Prospecto(s) ha sido exitosamente realizada.',
                    variant: 'success',
                });

                this.dispatchEvent(evt);
                setTimeout(function () {
                this.showLoading_PoolLink = false;
                this.open_PoolLink = false;
                window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Asignarse Prospecto(s) Pool Link',
                    message: 'La asignación de Prospecto(s) NO ha sido exitosamente realizada.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);

                setTimeout(function () {
                   this.showLoading_PoolLink = false;
                   this.open_PoolLink = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
            }
        })
        .catch((error) => {
                setTimeout(function () {
                   this.showLoading_PoolLink = false;
                   this.open_PoolLink = false;
                   window.location.reload();
                 }, 1500);  // After 1.5 secs
        });
    }

}