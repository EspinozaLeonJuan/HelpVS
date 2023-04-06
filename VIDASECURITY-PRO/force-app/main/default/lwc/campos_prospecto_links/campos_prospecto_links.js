import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
// import {refreshApex} from '@salesforce/apex';

import update_fields from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.update_fields';
import create_task_call from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.create_task_call';
import update_owner from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.update_owner';
import create_task_Reprogramacion from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.create_task_Reprogramacion';
import permission_specialfields from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.permission_specialfields';
//import getLead from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.getLead';


import LEAD_OBJECT from '@salesforce/schema/Lead';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import RUT_FIELD from '@salesforce/schema/Lead.PROSP_Carga_RUT__c';
import DV_FIELD from '@salesforce/schema/Lead.DV__c';
import NAME_FIELD from '@salesforce/schema/Lead.Name';
import FIRSTNAME_FIELD from '@salesforce/schema/Lead.FirstName';
import MIDDLENAME_FIELD from '@salesforce/schema/Lead.MiddleName';
import LASTNAME_FIELD from '@salesforce/schema/Lead.LastName';
import SALUDATION_FIELD from '@salesforce/schema/Lead.Salutation';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import EMAIL_FIELD from '@salesforce/schema/Lead.Email';
import SUB_ESTADO_FIELD from '@salesforce/schema/Lead.Sub_Estado__c';
import CARGO_FIELD from '@salesforce/schema/Lead.Title';
import RENTA_FIELD from '@salesforce/schema/Lead.Renta__c';
import TELEFONO_1_FIELD from '@salesforce/schema/Lead.Phone';
import TELEFONO_2_FIELD from '@salesforce/schema/Lead.PROSP_Carga_Tel_fono_2__c';
import TELEFONO_3_FIELD from '@salesforce/schema/Lead.Telefono_3__c';
import TELEFONO_4_FIELD from '@salesforce/schema/Lead.Telefono_4__c';
import TELEFONO_5_FIELD from '@salesforce/schema/Lead.Telefono_5__c';
import TELEFONO_6_FIELD from '@salesforce/schema/Lead.Telefono_6__c';
import TELEFONO_7_FIELD from '@salesforce/schema/Lead.Telefono_7__c';
import TELEFONO_8_FIELD from '@salesforce/schema/Lead.Telefono_8__c';
import DIRECCION_FIELD from '@salesforce/schema/Lead.Direccion__c';
import TELEFONO_ACTIVO_FIELD from '@salesforce/schema/Lead.Telefono_activo__c';
import COMUNA_FIELD from '@salesforce/schema/Lead.Comuna__c';
import CIUDAD_FIELD from '@salesforce/schema/Lead.Ciudad__c';
import REGION_FIELD from '@salesforce/schema/Lead.Region__c';
import FECHA_NACIMIENTO_FIELD from '@salesforce/schema/Lead.PROSPE_Carga_Fecha_Nacimiento__c';
import AGENTE_VENTA_FIELD from '@salesforce/schema/Lead.Agente_Venta__c';
import EJECUTIVO_POSTVENTA_FIELD from '@salesforce/schema/Lead.Ejecutivo_PostVenta__c';
import PERFIL_ASIGNACION_FIELD from '@salesforce/schema/Lead.Perfil_asignacion__c';
import FECHA_ENTREVISTA_FIELD from '@salesforce/schema/Lead.Fecha_Entrevista__c';
import HORA_ENTREVISTA_FIELD from '@salesforce/schema/Lead.Hora_Entrevista__c';
import FECHA_CONCERTACION_FIELD from '@salesforce/schema/Lead.Fecha_Concertacion__c';
import REPROGRAMACION_FIELD from '@salesforce/schema/Lead.Reprogramacion__c';
import SUBJECT_LINK_FIELD from '@salesforce/schema/Lead.Subject_Link__c';
import TIPO_LINK_FIELD from '@salesforce/schema/Lead.Tipo_Link__c';
import TIPO_BASE_FIELD from '@salesforce/schema/Lead.Tipo_Base__c';
import NOMBRE_BASE_FIELD from '@salesforce/schema/Lead.Nombre_Base__c';
import ORIGEN_FIELD from '@salesforce/schema/Lead.LeadSource';
import ACEPTA_CONTACTO_FUTURO_FIELD from '@salesforce/schema/Lead.Acepta_Contacto_Futuro__c';
import OBSERVACION_FIELD from '@salesforce/schema/Lead.Observacion__c';
import RUT_DV_FIELD from '@salesforce/schema/Lead.RUT_DV__c';
import TIPO_CLIENTE_FIELD from '@salesforce/schema/Lead.Tipo_Cliente__c';
import NOMBRE_INTERMEDIARIO_FINAL_FIELD from '@salesforce/schema/Lead.Nombre_intermediario_Final__c';
import TIPO_INTERMEDIARIO_FINAL_FIELD from '@salesforce/schema/Lead.Tipo_Intermediario_Final__c';
import EMAIL_INTERMEDIARIO_FINAL_FIELD from '@salesforce/schema/Lead.Email_intermediario_final__c';
import SUCURSAL_FIELD from '@salesforce/schema/Lead.Sucursal__c';

const fields = [
    ID_FIELD,
    RUT_FIELD,
    DV_FIELD,
    NAME_FIELD,
    FIRSTNAME_FIELD,
    MIDDLENAME_FIELD,
    LASTNAME_FIELD,
    SALUDATION_FIELD,
    STATUS_FIELD,
    EMAIL_FIELD,
    SUB_ESTADO_FIELD,
    CARGO_FIELD,
    RENTA_FIELD,
    TELEFONO_1_FIELD,
    TELEFONO_2_FIELD,
    TELEFONO_3_FIELD,
    TELEFONO_4_FIELD,
    TELEFONO_5_FIELD,
    TELEFONO_6_FIELD,
    TELEFONO_7_FIELD,
    TELEFONO_8_FIELD,
    TELEFONO_ACTIVO_FIELD,
    DIRECCION_FIELD,
    COMUNA_FIELD,
    CIUDAD_FIELD,
    REGION_FIELD,
    FECHA_NACIMIENTO_FIELD,
    AGENTE_VENTA_FIELD,
    EJECUTIVO_POSTVENTA_FIELD,
    PERFIL_ASIGNACION_FIELD,
    FECHA_ENTREVISTA_FIELD,
    HORA_ENTREVISTA_FIELD,
    FECHA_CONCERTACION_FIELD,
    REPROGRAMACION_FIELD,
    TIPO_LINK_FIELD,
    TIPO_BASE_FIELD,
    NOMBRE_BASE_FIELD,
    TIPO_INTERMEDIARIO_FINAL_FIELD,
    EMAIL_INTERMEDIARIO_FINAL_FIELD,
    NOMBRE_INTERMEDIARIO_FINAL_FIELD,
    SUCURSAL_FIELD,
    TIPO_CLIENTE_FIELD,
    ORIGEN_FIELD,
    ACEPTA_CONTACTO_FUTURO_FIELD,
    OBSERVACION_FIELD,
    RUT_DV_FIELD,
    SUBJECT_LINK_FIELD
];

export default class Campos_prospecto_links extends LightningElement {

    objectApiName = LEAD_OBJECT;

    @api recordId;
    @api objectApiName;

    @track parameters = [];

    @wire(getRecord, {
        recordId: "$recordId", fields
    })
    lead;

    @track isValue_Phone_1 = false;
    @track isValue_Phone_2 = false;
    @track isValue_Phone_3 = false;
    @track isValue_Phone_4 = false;
    @track isValue_Phone_5 = false;
    @track isValue_Phone_6 = false;
    @track isValue_Phone_7 = false;
    @track isValue_Phone_8 = false;
    @track isValue_Telefono_Activo = false;
    @track isValue_Email = false;

    @track permisoEdicion = false;

    @track href_Phone_1 = '#';
    @track href_Phone_2 = '#';
    @track href_Phone_3 = '#';
    @track href_Phone_4 = '#';
    @track href_Phone_5 = '#';
    @track href_Phone_6 = '#';
    @track href_Phone_7 = '#';
    @track href_Phone_8 = '#';
    @track href_Telefono_Activo = '#';

    @track href_Email = '#';

    get CORREO_ELECTRONICO(){
        var email = getFieldValue(this.lead.data, EMAIL_FIELD);
        console.log('@@@@ '+email);

        if (email != null && email != '')
        {
            this.href_Email = 'mailto:'+email;
            this.isValue_Email = true;
        }

        return email;
    }

    get PHONE_1(){
        var phone = getFieldValue(this.lead.data, TELEFONO_1_FIELD);
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_1 = 'tel:'+phone;
            this.isValue_Phone_1 = true;
        }

        return phone;
    }

    get PHONE_2(){
        var phone = getFieldValue(this.lead.data, TELEFONO_2_FIELD);
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_2 = 'tel:'+phone;
            this.isValue_Phone_2 = true;
        }

        return phone;
    }

    get PHONE_3(){
        var phone = getFieldValue(this.lead.data, TELEFONO_3_FIELD);
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_3 = 'tel:'+phone;
            this.isValue_Phone_3 = true;
        }

        return phone;
    }

    get PHONE_4(){
        var phone = getFieldValue(this.lead.data, TELEFONO_4_FIELD) ;
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_4 = 'tel:'+phone;
            this.isValue_Phone_4 = true;
        }

        return phone;
    }

    get PHONE_5(){
        var phone = getFieldValue(this.lead.data, TELEFONO_5_FIELD) ;
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_5 = 'tel:'+phone;
            this.isValue_Phone_5 = true;
        }

        return phone;
    }

    get PHONE_6(){
        var phone = getFieldValue(this.lead.data, TELEFONO_6_FIELD) ;
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_6 = 'tel:'+phone;
            this.isValue_Phone_6 = true;
        }

        return phone;
    }

    get PHONE_7(){
        var phone = getFieldValue(this.lead.data, TELEFONO_7_FIELD) ;
        console.log('@@@@ '+phone);

        if (phone != null && phone != '')
        {
            this.href_Phone_7 = 'tel:'+phone;
            this.isValue_Phone_7 = true;
        }

        return phone;
    }

    get PHONE_8(){
        var phone = getFieldValue(this.lead.data, TELEFONO_8_FIELD) ;
        console.log('@@@@ '+phone);


        if (phone != null && phone != '')
        {
            this.href_Phone_8 = 'tel:'+phone;
            this.isValue_Phone_8 = true;
        }

        return phone;
    }

    get TELEFONO_ACTIVO(){
        var phone = getFieldValue(this.lead.data, TELEFONO_ACTIVO_FIELD) ;
        console.log('@@@@ '+phone);


        if (phone != null && phone != '')
        {
            this.href_Telefono_Activo = 'tel:'+phone;
            this.isValue_Telefono_Activo = true;
        }

        return phone;
    }

     get TELEFONO_ACTIVO(){
        var phone = getFieldValue(this.lead.data, TELEFONO_ACTIVO_FIELD) ;
        console.log('@@@@ '+phone);


        if (phone != null && phone != '')
        {
            this.href_Telefono_Activo = 'tel:'+phone;
            this.isValue_Telefono_Activo = true;
        }

        return phone;
    }

    @track modoEdicion = false;
    @api open_informacionPersonalProspecto;
    @api open_ubicacionProspecto;
    @api open_gestionProspecto;
    @api open_informacionEntrevista;
    @api open_informacionAdicional;
    @api open_informacionSistema;
    @track openChangeOwner = false;

    get sectionClass_informacionPersonalProspecto() {
        return this.open_informacionPersonalProspecto ? 'slds-section slds-is-open' : 'slds-section';
    }

    get sectionClass_ubicacionProspecto() {
        return this.open_ubicacionProspecto ? 'slds-section slds-is-open' : 'slds-section';
    }

    get sectionClass_gestionProspecto() {
        return this.open_gestionProspecto ? 'slds-section slds-is-open' : 'slds-section';
    }

    get sectionClass_informacionEntrevista() {
        return this.open_informacionEntrevista ? 'slds-section slds-is-open' : 'slds-section';
    }

    get sectionClass_informacionAdicional() {
        return this.open_informacionAdicional ? 'slds-section slds-is-open' : 'slds-section';
    }

    get sectionClass_informacionSistema() {
        return this.open_informacionSistema ? 'slds-section slds-is-open' : 'slds-section';
    }

    connectedCallback() {
        if (typeof this.open_informacionPersonalProspecto === 'undefined') this.open_informacionPersonalProspecto = true;
        if (typeof this.open_ubicacionProspecto === 'undefined') this.open_ubicacionProspecto = true;
        if (typeof this.open_gestionProspecto === 'undefined') this.open_gestionProspecto = true;
        if (typeof this.open_informacionEntrevista === 'undefined') this.open_informacionEntrevista = true;
        if (typeof this.open_informacionAdicional === 'undefined') this.open_informacionAdicional = true;
        if (typeof this.open_informacionSistema === 'undefined') this.open_informacionSistema = true;


        permission_specialfields().
        then (result => {
            let val = JSON.parse(JSON.stringify(result));
            console.log('@@@@ val'+val);
            this.permisoEdicion = val;
        })
    }

    handleClick_informacionPersonalProspecto() {
        this.open_informacionPersonalProspecto = !this.open_informacionPersonalProspecto;
    }

    handleClick_ubicacionProspecto() {
        this.open_ubicacionProspecto = !this.open_ubicacionProspecto;
    }

    handleClick_gestionProspecto() {
        this.open_gestionProspecto = !this.open_gestionProspecto;
    }

    handleClick_informacionEntrevista() {
        this.open_informacionEntrevista = !this.open_informacionEntrevista;
    }

    handleClick_informacionAdicional() {
        this.open_informacionAdicional = !this.open_informacionAdicional;
    }

    handleClick_informacionSistema() {
        this.open_informacionSistema = !this.open_informacionSistema;
    }

    handleClick_changeOwner() {
        this.openChangeOwner = true;
    }

    handleClick_closeChangeOwner(){
        this.openChangeOwner = false;
        this.newOwner = '';
    }

    @track newOwner;
    @track sendEmailNewOwner;

    handleCheckBox_sendEmailNewOwner(e)
    {
        this.sendEmailNewOwner  = e.detail.checked;
    }

    @track name = '';
    @track firstName = '';
    @track middleName = '';
    @track lastName = '';
    @track saludation = '';
    @track status = '';
    @track email = '';
    @track subEstado = '';
    @track cargo = '';
    @track renta = '';
    @track telefono_1 = '';
    @track telefono_2= '';
    @track telefono_3 = '';
    @track telefono_4 = '';
    @track telefono_5 = '';
    @track telefono_6 = '';
    @track telefono_7 = '';
    @track telefono_8 = '';
    @track telefono_activo = '';
    @track direccion = '';
    @track comuna = '';
    @track ciudad = '';
    @track region = '';
    @track fechaNacimiento = '';
    @track agenteVenta = '';
    @track ejecutivoPostVenta = '';
    @track perfilAsignacion = '';
    @track fechaEntrevista = '';
    @track horaEntrevista = '';
    @track fechaConcertacion = '';
    @track reprogramacion = '';
    @track original_reprogramacion = '';
    @track tipoLink = '';
    @track tipoBase = '';
    @track nombreBase = '';
    @track origen = '';
    @track aceptaContactoFuturo = '';
    @track observacion = '';
    @track subjectLink = '';
    @track tipoCliente = '';//
    @track tipoIntermediario = '';//
    @track nombreIntermediario = '';//
    @track emailIntermediario = '';//
    @track sucursal = '';//

    loadData()
    {
        this.name =  getFieldValue(this.lead.data, NAME_FIELD);
        this.firstName =  getFieldValue(this.lead.data, FIRSTNAME_FIELD);
        this.middleName =  getFieldValue(this.lead.data, MIDDLENAME_FIELD);
        this.lastName =  getFieldValue(this.lead.data, LASTNAME_FIELD);
        this.saludation =  getFieldValue(this.lead.data, SALUDATION_FIELD);
        this.fechaNacimiento  =  getFieldValue(this.lead.data, FECHA_NACIMIENTO_FIELD);
        this.cargo  =  getFieldValue(this.lead.data, CARGO_FIELD);
        this.renta  =  getFieldValue(this.lead.data, RENTA_FIELD);
        this.status  =  getFieldValue(this.lead.data, STATUS_FIELD);
        this.subEstado  =  getFieldValue(this.lead.data, SUB_ESTADO_FIELD);
        this.email  =  getFieldValue(this.lead.data, EMAIL_FIELD);
        this.telefono_1  =  getFieldValue(this.lead.data, TELEFONO_1_FIELD);
        this.telefono_2  =  getFieldValue(this.lead.data, TELEFONO_2_FIELD);
        this.telefono_3  =  getFieldValue(this.lead.data, TELEFONO_3_FIELD);
        this.telefono_4  =  getFieldValue(this.lead.data, TELEFONO_4_FIELD);
        this.telefono_5  =  getFieldValue(this.lead.data, TELEFONO_5_FIELD);
        this.telefono_6  =  getFieldValue(this.lead.data, TELEFONO_6_FIELD);
        this.telefono_7  =  getFieldValue(this.lead.data, TELEFONO_7_FIELD);
        this.telefono_8  =  getFieldValue(this.lead.data, TELEFONO_8_FIELD);
        this.telefono_activo = getFieldValue(this.lead.data, TELEFONO_ACTIVO_FIELD);
        this.direccion  =  getFieldValue(this.lead.data, DIRECCION_FIELD);
        this.comuna  =  getFieldValue(this.lead.data, COMUNA_FIELD);
        this.ciudad  =  getFieldValue(this.lead.data, CIUDAD_FIELD);
        this.region  =  getFieldValue(this.lead.data, REGION_FIELD);
        this.reprogramacion  =  getFieldValue(this.lead.data, REPROGRAMACION_FIELD);
        this.original_reprogramacion =  getFieldValue(this.lead.data, REPROGRAMACION_FIELD);
        this.aceptaContactoFuturo  =  getFieldValue(this.lead.data, ACEPTA_CONTACTO_FUTURO_FIELD);
        this.agenteVenta  =  getFieldValue(this.lead.data, AGENTE_VENTA_FIELD);
        this.ejecutivoPostVenta  =  getFieldValue(this.lead.data, EJECUTIVO_POSTVENTA_FIELD);
        this.perfilAsignacion  =  getFieldValue(this.lead.data, PERFIL_ASIGNACION_FIELD);
        this.fechaEntrevista  =  getFieldValue(this.lead.data, FECHA_ENTREVISTA_FIELD);
        this.tipoLink  =  getFieldValue(this.lead.data, TIPO_LINK_FIELD);
        this.horaEntrevista  =  getFieldValue(this.lead.data, HORA_ENTREVISTA_FIELD);
        this.tipoBase  =  getFieldValue(this.lead.data, TIPO_BASE_FIELD);
        this.fechaConcertacion  =  getFieldValue(this.lead.data, FECHA_CONCERTACION_FIELD);
        this.nombreBase  =  getFieldValue(this.lead.data, NOMBRE_BASE_FIELD);
        this.origen  =  getFieldValue(this.lead.data, ORIGEN_FIELD);
        this.observacion  =  getFieldValue(this.lead.data, OBSERVACION_FIELD);
        this.subjectLink = getFieldValue(this.lead.data, SUBJECT_LINK_FIELD);
        this.tipoCliente = getFieldValue(this.lead.data, TIPO_CLIENTE_FIELD);
        this.tipoIntermediario = getFieldValue(this.lead.data, TIPO_INTERMEDIARIO_FINAL_FIELD);
        this.nombreIntermediario = getFieldValue(this.lead.data, NOMBRE_INTERMEDIARIO_FINAL_FIELD);
        this.emailIntermediario = getFieldValue(this.lead.data, EMAIL_INTERMEDIARIO_FINAL_FIELD);
        this.sucursal = getFieldValue(this.lead.data, SUCURSAL_FIELD);
    }

    handleClick_editar() {
        this.loadData();
        this.modoEdicion = true;
    }

    handle_value_tipoCliente(e)
    {
        this.tipoCliente  = e.detail.value;
        console.log('@@@@ this.tipoCliente '+ this.tipoCliente);
    }

    handle_value_tipoIntermediario(e)
    {
        this.tipoIntermediario  = e.detail.value;
        console.log('@@@@ this.tipoIntermediario '+ this.tipoIntermediario);
    }

    handle_value_sucursal(e)
    {
        this.sucursal  = e.detail.value;
        console.log('@@@@ this.sucursal '+ this.sucursal);
    }

    handle_value_nombreIntermediario(e)
    {
        this.nombreIntermediario  = e.detail.value;
        console.log('@@@@ this.nombreIntermediario '+ this.nombreIntermediario);
    }

    handle_value_emailIntermediario(e)
    {
        this.emailIntermediario  = e.detail.value;
        console.log('@@@@ this.emailIntermediario '+ this.emailIntermediario);
    }

    handle_value_saludation(e)
    {
        this.saludation  = e.detail.value;
        console.log('@@@@ this.saludation '+ this.saludation);
    }

    handle_value_firstName(e)
    {
        this.firstName  = e.detail.value;
        console.log('@@@@ this.firstName '+ this.firstName);
    }

    handle_value_middleName(e)
    {
        this.middleName  = e.detail.value;
        console.log('@@@@ this.middleName '+ this.middleName);
    }

    handle_value_lastName(e)
    {
        this.lastName  = e.detail.value;
        console.log('@@@@ this.lastName '+ this.lastName);
    }

    handle_value_lastName(e)
    {
        this.lastName  = e.detail.value;
        console.log('@@@@ this.lastName '+ this.lastName);
    }

    handle_value_status(e)
    {
        this.status  = e.detail.value;
        console.log('@@@@ this.status '+ this.status);
    }

    handle_value_email(e)
    {
        this.email  = e.detail.value;
        console.log('@@@@ this.email '+ this.email);
    }

    handle_value_subEstado(e)
    {
        this.subEstado  = e.detail.value;
        console.log('@@@@ this.subEstado '+ this.subEstado);
    }

    handle_value_cargo(e)
    {
        this.cargo  = e.detail.value;
        console.log('@@@@ this.cargo '+ this.cargo);
    }

    handle_value_renta(e)
    {
        this.renta  = e.detail.value;
        console.log('@@@@ this.renta '+ this.renta);
    }

    handle_value_telefono_1(e)
    {
        this.telefono_1  = e.detail.value;
        console.log('@@@@ this.telefono_1 '+ this.telefono_1);
    }

    handle_value_telefono_2(e)
    {
        this.telefono_2  = e.detail.value;
        console.log('@@@@ this.telefono_2 '+ this.telefono_2);
    }

    handle_value_telefono_3(e)
    {
        this.telefono_3  = e.detail.value;
        console.log('@@@@ this.telefono_3 '+ this.telefono_3);
    }

    handle_value_telefono_4(e)
    {
        this.telefono_4  = e.detail.value;
        console.log('@@@@ this.telefono_4 '+ this.telefono_4);
    }

    handle_value_telefono_5(e)
    {
        this.telefono_5  = e.detail.value;
        console.log('@@@@ this.telefono_5 '+ this.telefono_5);
    }

    handle_value_telefono_6(e)
    {
        this.telefono_6  = e.detail.value;
        console.log('@@@@ this.telefono_6 '+ this.telefono_6);
    }

    handle_value_telefono_7(e)
    {
        this.telefono_7  = e.detail.value;
        console.log('@@@@ this.telefono_7 '+ this.telefono_7);
    }

    handle_value_telefono_8(e)
    {
        this.telefono_8  = e.detail.value;
        console.log('@@@@ this.telefono_8 '+ this.telefono_8);
    }

    handle_value_telefono_activo(e)
    {
        this.telefono_activo  = e.detail.value;
        console.log('@@@@ this.telefono_activo '+ this.telefono_activo);
    }

    handle_value_direccion(e)
    {
        this.direccion  = e.detail.value;
        console.log('@@@@ this.direccion '+ this.direccion);
    }

    handle_value_comuna(e)
    {
        this.comuna  = e.detail.value[0];
        console.log('@@@@ this.comuna '+ this.comuna);
    }

    handle_value_ciudad(e)
    {
        this.ciudad  = e.detail.value[0];
        console.log('@@@@ this.ciudad '+ this.ciudad);
    }

    handle_value_region(e)
    {
        this.region  = e.detail.value[0];
        console.log('@@@@ this.region '+ this.region);
    }

    handle_value_fechaNacimiento(e)
    {
        this.fechaNacimiento  = e.detail.value;
        console.log('@@@@ this.fechaNacimiento '+ this.fechaNacimiento);
    }

    handle_value_agenteVenta(e)
    {
        this.agenteVenta  = e.detail.value[0];
        console.log('@@@@ this.agenteVenta '+ this.agenteVenta);
    }

    handle_value_ejecutivoPostVenta(e)
    {
        this.ejecutivoPostVenta  = e.detail.value[0];
        console.log('@@@@ this.ejecutivoPostVenta '+ this.ejecutivoPostVenta);
    }

    handle_value_perfilAsignacion(e)
    {
        this.perfilAsignacion  = e.detail.value[0];
        console.log('@@@@ this.perfilAsignacion '+ this.perfilAsignacion);
    }

    handle_value_fechaEntrevista(e)
    {
        this.fechaEntrevista  = e.detail.value;
        console.log('@@@@ this.fechaEntrevista '+ this.fechaEntrevista);
    }

    handle_value_horaEntrevista(e)
    {
        this.horaEntrevista  = e.detail.value;
        console.log('@@@@ this.horaEntrevista '+ this.horaEntrevista);
    }

    handle_value_fechaConcertacion(e)
    {
        this.fechaConcertacion  = e.detail.value;
        console.log('@@@@ this.fechaConcertacion '+ this.fechaConcertacion);
    }

    handle_value_reprogramacion(e)
    {
        this.reprogramacion  = e.detail.value;
        console.log('@@@@ this.reprogramacion '+ this.reprogramacion);
    }

    handle_value_tipoLink(e)
    {
        this.tipoLink  = e.detail.value;
        console.log('@@@@ this.tipoLink '+ this.tipoLink);
    }

    handle_value_tipoBase(e)
    {
        this.tipoBase  = e.detail.value;
        console.log('@@@@ this.tipoBase '+ this.tipoBase);
    }

    handle_value_nombreBase(e)
    {
        this.nombreBase  = e.detail.value;
        console.log('@@@@ this.nombreBase '+ this.nombreBase);
    }

    handle_value_origen(e)
    {
        this.origen  = e.detail.value;
        console.log('@@@@ this.origen '+ this.origen);
    }

    handle_value_aceptaContactoFuturo(e)
    {
        this.aceptaContactoFuturo  = e.detail.value;
        console.log('@@@@ this.aceptaContactoFuturo '+ this.aceptaContactoFuturo);
    }

    handle_value_observacion(e)
    {
        this.observacion  = e.detail.value;
        console.log('@@@@ this.observacion '+ this.observacion);
    }

    handle_value_subjectLink(e)
    {
        this.subjectLink  = e.detail.value;
        console.log('@@@@ this.subjectLink '+ this.subjectLink);
    }

    handleClick_ver() {
        this.modoEdicion = false;
    }

    @track showLoading = false;

    handleClick_save() {

        var msj = 'Existen campos pendientes de completar: ';

        var formFields_status = Array.from(this.template.querySelectorAll('.validate_status'));
        var formFields_subestado = Array.from(this.template.querySelectorAll('.validate_subestado'));

        var validation_status = formFields_status[0].reportValidity();;
        var validation_subestado = formFields_subestado[0].reportValidity();

        console.log('@@@@@ validate_status  '+validation_status);
        console.log('@@@@@ validate_subestado '+validation_subestado);

        if (validation_status == false)
        {
            msj = msj + '* Estado del Prospecto ';
        }

        if (validation_subestado == false)
        {
            msj = msj + '* Sub - Estado del Prospecto ';
        }

        var validation_tipolink = true;
        var validation_tipobase = true;
        var validation_nombrebase = true;

        if (this.permisoEdicion == true)
        {
            var formFields_tipolink = Array.from(this.template.querySelectorAll('.validate_tipolink'));
            var formFields_tipobase = Array.from(this.template.querySelectorAll('.validate_tipobase'));
            var formFields_nombrebase = Array.from(this.template.querySelectorAll('.validate_nombrebase'));

            validation_tipolink = formFields_tipolink[0].reportValidity();;
            validation_tipobase = formFields_tipobase[0].reportValidity();;
            validation_nombrebase = formFields_nombrebase[0].reportValidity();

            console.log('@@@@@ validate_tipolink '+validation_tipolink);
            console.log('@@@@@ validate_tipobase '+validation_tipobase);
            console.log('@@@@@ validate_nombrebase '+validation_nombrebase);

            if (validation_tipolink == false)
            {
                msj = msj + '* Tipo de Link ';
            }

            if (validation_tipobase == false)
            {
                msj = msj+ '* Tipo de Base ';
            }

            if (validation_nombrebase == false)
            {
                msj = msj + '* Nombre de Base ';
            }
        }

        if (validation_status == false || validation_subestado == false || validation_tipolink == false || validation_tipobase == false || validation_nombrebase == false)
        {
            const evt = new ShowToastEvent({
                title: 'Actualizar Campos Prospecto',
                message: msj,
                variant: 'error',
            });
            this.dispatchEvent(evt);

        }
        else
        {
            this.showLoading = true;

            this.parameters.push({key:"f_firstName",value: this.firstName});
            this.parameters.push({key:"f_middleName",value: this.middleName});
            this.parameters.push({key:"f_lastName",value: this.lastName});
            this.parameters.push({key:"f_saludation",value: this.saludation});
            this.parameters.push({key:"f_fechaNacimiento",value: this.fechaNacimiento});
            this.parameters.push({key:"f_cargo",value: this.cargo});
            this.parameters.push({key:"f_renta",value: this.renta});
            this.parameters.push({key:"f_status",value: this.status});
            this.parameters.push({key:"f_subEstado",value: this.subEstado});
            this.parameters.push({key:"f_email",value: this.email});
            this.parameters.push({key:"f_telefono_1",value: this.telefono_1});
            this.parameters.push({key:"f_telefono_2",value: this.telefono_2});
            this.parameters.push({key:"f_telefono_3",value: this.telefono_3});
            this.parameters.push({key:"f_telefono_4",value: this.telefono_4});
            this.parameters.push({key:"f_telefono_5",value: this.telefono_5});
            this.parameters.push({key:"f_telefono_6",value: this.telefono_6});
            this.parameters.push({key:"f_telefono_7",value: this.telefono_7});
            this.parameters.push({key:"f_telefono_8",value: this.telefono_8});
            this.parameters.push({key:"f_direccion",value: this.direccion});
            this.parameters.push({key:"f_comuna",value: this.comuna});
            this.parameters.push({key:"f_ciudad",value: this.ciudad});
            this.parameters.push({key:"f_region",value: this.region});
            this.parameters.push({key:"f_reprogramacion",value: this.reprogramacion});
            this.parameters.push({key:"f_aceptaContactoFuturo",value: this.aceptaContactoFuturo});
            this.parameters.push({key:"f_agenteVenta",value: this.agenteVenta});
            this.parameters.push({key:"f_ejecutivoPostVenta",value: this.ejecutivoPostVenta});
            this.parameters.push({key:"f_perfilAsignacion",value: this.perfilAsignacion});
            this.parameters.push({key:"f_fechaEntrevista",value: this.fechaEntrevista});
            this.parameters.push({key:"f_tipoLink",value: this.tipoLink});
            this.parameters.push({key:"f_horaEntrevista",value: this.horaEntrevista});
            this.parameters.push({key:"f_tipoBase",value: this.tipoBase});
            this.parameters.push({key:"f_fechaConcertacion",value: this.fechaConcertacion});
            this.parameters.push({key:"f_nombreBase",value: this.nombreBase});
            this.parameters.push({key:"f_origen",value: this.origen});
            this.parameters.push({key:"f_observacion",value: this.observacion});
            this.parameters.push({key:"f_telefono_activo",value: this.telefono_activo});
            this.parameters.push({key:"f_subject_link",value: this.subjectLink});
            this.parameters.push({key:"f_tipoCliente",value: this.tipoCliente});
            this.parameters.push({key:"f_tipoIntermediario",value: this.tipoIntermediario});
            this.parameters.push({key:"f_sucursal",value: this.sucursal});
            this.parameters.push({key:"f_nombreIntermediario",value: this.nombreIntermediario});
            this.parameters.push({key:"f_emailIntermediario",value: this.emailIntermediario});

            var tparam = JSON.stringify(this.parameters);
            console.log('myMap  ' + this.parameters) ;

            update_fields({Id : this.recordId, parameters : tparam}).then(r => {
                if(r != false){

                    const evt = new ShowToastEvent({
                        title: 'Actualizar Campos Prospecto',
                        message: 'Los campos del Prospecto han sido exitosamente actualizados.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);

                    if(this.reprogramacion != this.original_reprogramacion)
                    {
                        create_task_Reprogramacion({Id : this.recordId, fechaRep : this.reprogramacion}).then(r => {
                            if(r != 'NULL' && r != 'ERROR'){

                            }
                            else{

                            }
                        })
                        .catch((error) => {

                        });
                    }

                    // this.showLoading = false;
                    // this.modoEdicion = false;
                    // refreshApex(this.lead);
                    setTimeout(function () {
                        this.showLoading = false;
                       window.location.reload();
                     }, 1000);  // After 1 sec
                }
                else{
                    const evt = new ShowToastEvent({
                        title: 'Actualizar Campos Prospecto',
                        message: 'Los campos del Prospecto NO han sido actualizados.',
                        variant: 'error',
                    });
                    // this.dispatchEvent(evt);
                    // this.modoEdicion = false;
                    // refreshApex(this.lead);

                    setTimeout(function () {
                        this.showLoading = false;
                       window.location.reload();
                     }, 1000);  // After 1 sec
                }
            })
            .catch((error) => {
               // this.message = 'ERROR RECIBIDO' + error.errorCode + ', ' +
                    'MENSAJE ' + error.body.message;
                    console.log(JSON.stringify(error));
                    const evt = new ShowToastEvent({
                        title: 'ERROR',
                        message: 'ERROR',
                        variant: 'error',
                    });
                    // this.dispatchEvent(evt);
                    // this.modoEdicion = false;
                    // refreshApex(this.lead);

                    console.log('@@@@ id  '+ Id);
                    setTimeout(function () {
                       this.showLoading = false;
                       window.location.reload();
                     }, 1000);  //  After 1 sec
            });
        }
    }



    handleClick_call_Telefono_1()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_1_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_2()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_2_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_3()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_3_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_4()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_4_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_5()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_5_FIELD);

        this.save_task_call(phone);
        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_6()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_6_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_7()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_7_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_8()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_8_FIELD);

        this.save_task_call(phone);

        // create_task_call({Id : this.recordId, telefono : phone}).then(r => {
        //     if(r != 'NULL' && r != 'ERROR'){
        //         setTimeout(function () {
        //         this.showLoading = false;
        //          window.location.reload();
        //         }, 1500);  // After 1.5 secs
        //     }
        //     else{
        //         setTimeout(function () {
        //             this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        //     }
        // })
        // .catch((error) => {
        //         setTimeout(function () {
        //            this.showLoading = false;
        //            window.location.reload();
        //          }, 1500);  // After 1.5 secs
        // });
    }

    handleClick_call_Telefono_Activo()
    {
        this.showLoading = true;

        var phone =  getFieldValue(this.lead.data, TELEFONO_ACTIVO_FIELD);

        this.save_task_call(phone);
    }

    save_task_call(phone)
    {
        create_task_call({Id : this.recordId, telefono : phone}).then(r => {
            if(r != 'NULL' && r != 'ERROR'){
                setTimeout(function () {
                this.showLoading = false;
                 window.location.reload();
                }, 800);  // After 0.8 secs
            }
            else{
                setTimeout(function () {
                    this.showLoading = false;
                   window.location.reload();
                 }, 800);  // After 0.8 secs
            }
        })
        .catch((error) => {
                setTimeout(function () {
                   this.showLoading = false;
                   window.location.reload();
                 }, 800);  // After 0.8 secs
        });
    }

    @track showLoading_changeOwner = false;

    handleClick_saveChangeOwner(){
        this.showLoading_changeOwner = true;
        update_owner({Id : this.recordId, newOwnerId : this.newOwner}).then(r => {

            if(r != false){

                const evt = new ShowToastEvent({
                    title: 'Actualizar Propietario Prospecto',
                    message: 'El propietario del Prospecto han sido exitosamente actualizados.',
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
                    title: 'Actualizar Propietario Prospecto',
                    message: 'El propietario del Prospecto NO ha sido exitosamente actualizados.',
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
    handleLookup = (event) => {
        let data = event.detail.data;

        if(data && data.record){
            console.log('@@@@ data  ' +  data.record.Id);
            this.newOwner = data.record.Id;
            console.log('@@@@ this.newOwner  ' +  this.newOwner);
            // populate the selected record in the correct parent Id field
            // this.allRecord[data.index][data.parentAPIName] = data.record.Id;
        }else{
            // clear the parent Id field
            //this.allRecord[data.index][data.parentAPIName] = undefined;
        }
    }
}