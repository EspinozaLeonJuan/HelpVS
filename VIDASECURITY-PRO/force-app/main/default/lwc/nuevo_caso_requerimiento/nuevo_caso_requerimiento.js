/*
  @description       :
  @author            : Juan Espinoza León
  @group             :
  @last modified on  : 12-29-2022
  @last modified by  : Juan Espinoza León
*/

import { LightningElement , api,wire,track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';

import ID_FIELD from '@salesforce/schema/Case.Id';
import ACCOUNTID_FIELD from '@salesforce/schema/Case.AccountId';
import NEGOCIO_FIELD from '@salesforce/schema/Case.Negocio__c';
import CANAL_FIELD from '@salesforce/schema/Case.Canal__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';

import getPolizas from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.getPolizas';
// import getPolizas_Colectivos from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.getPolizas_Colectivos';

import get_pickList_Categorias from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_Categorias';
import get_pickList_DetalleSolicitud from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleSolicitud';
import get_pickList_DetalleRescate from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleRescate';
import get_pickList_DetalleConfiguracion from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleConfiguracion';
import get_pickList_CantidadMesesSuspendido from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_CantidadMesesSuspendido';
import create_CasoRequerimiento_Solicitud from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Solicitud';

//VASS (SB): 23122022
import get_pickList_DetalleErrorLiquidacion from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_Detalle_Error_Liquidacion';
//-----FIN-----//

import get_pickList_Conceptos from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_Conceptos';
import create_CasoRequerimiento_Consulta from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Consulta';
import getOptionsProtocolo from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.getOptionsProtocolo';
import getIsProtocoloAtencion from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.getIsProtocoloAtencion';

import get_pickList_Productos from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_Productos';
import get_pickList_TipoOperacion from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_TipoOperacion';
import get_pickList_DetalleOperacion from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleOperacion';
import create_CasoRequerimiento_Reclamo from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Reclamo';


export default class Gestion_caso_requerimiento extends LightningElement {

    @api recordId;
    @api objectApiName;


    objectApiName = CASE_OBJECT;

    /* Load Account.Owner.Email for custom rendering */
    @wire(getRecord, {
        recordId: "$recordId",
        fields: [
             ID_FIELD, ACCOUNTID_FIELD, NEGOCIO_FIELD, DESCRIPTION_FIELD, CANAL_FIELD
            ]
      })
      record;



    @track tipoCaso = '';

    get options() {
        return [
            { label: 'Consultas', value: 'Consultas' },
            { label: 'Reclamos', value: 'Reclamos' },
            { label: 'Solicitudes', value: 'Solicitudes' },
        ];
    }

    handleChechBox_Tipp_Caso(e) {
        this.tipoCaso  = e.detail.value;
        console.log('@@@@ ' + this.tipoCaso );
    }

    @track openmodel_create_solicitud = false;
    @track openmodel_create_consulta = false;
    @track openmodel_create_reclamo = false;

    @track showLoading = false;

    @track polizaValue;
    @track polizas;

    @track categoriaValue;
    @track categorias;

    @track detalleSolicitudValue;
    @track detallesSolicitud;

    //VASS (SB): 23122022
    @track detalleErrorSolicitudValue;
    @track detallesErrorSolicitud;
    @track es_error_solicitud  = false;
    //-----FIN-----//

    @track detalleRescateValue;
    @track detallesRescate;
    @track es_detalle_rescate = false;

    @track detalleConfiguracionValue;
    @track detallesConfiguracion;
    @track es_detalle_configuracion = false;

    @track fechaInicioSuspensionValue;
    @track mesesSuspensionValue;
    @track mesesSuspension;
    @track es_suspension_prima  = false;

    @track esProblemaValue;
    @track cierreCasoValue;
    @track descripcionValue;

    @track conceptoValue;
    @track conceptos;

    @track productoValue;
    @track productos;

    @track tipoOperacionValue;
    @track tiposOperacion;

    @track detalleOperacionValue;
    @track detallesOperacion;

    @track respuestaEmailValue;
    @track respuestaCartaValue;

    @track esProtocoloAtencionValue = '';

    @track protocoloAtencion;

    @track optionsProtocolo = [];
    @track optionSelect = '';

    openmodal_create() {

        console.log('#### ' + this.tipoCaso );
        if (this.tipoCaso == 'Solicitudes')
        {
            this.init_create_Solicitud();

            this.openmodel_create_solicitud = true;

        }else if (this.tipoCaso == 'Reclamos')
        {
            this.init_create_Reclamo();

            this.openmodel_create_reclamo = true;
        }
        else if (this.tipoCaso == 'Consultas')
        {
            this.init_create_Consulta();

            this.openmodel_create_consulta = true;
        }
        else if (this.tipoCaso == '')
        {
            const evt = new ShowToastEvent({
                title: 'Nuevo Caso Requerimiento',
                message: 'Debe seleccionar un Tipo de Caso.',
                variant: 'error',
            });

            this.dispatchEvent(evt);
        }
    }

//##region modal comun

    Load_polizas_caso(accountId, negocio, canal) {

        console.log('@@@@ AccountId --> '+accountId);
        console.log('@@@@ Negocio --> '+negocio);
        console.log('@@@@ Canal --> '+canal);

        getPolizas({AccountId : accountId, Negocio : negocio, Canal : canal}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.Name, value: rv.Id });
                console.log('@@@@  --> '+rv.Name + '  @@  '+ rv.Id );
            });
            // LWC array tracking workaround
            this.polizas = [...values];
        });
    }

    handlePicklist_Poliza_Change(e) {
        this.showLoading = true;
        this.polizaValue  = e.detail.value;
        console.log('@@@@ ' + this.polizaValue );
        setTimeout(() => { this.showLoading = false;}, 1500);
    }

    handleCheckBox_esProblema_Change(e)
    {
        this.showLoading = true;
        this.esProblemaValue  = e.detail.checked;
        console.log('@@@@ ' + this.esProblemaValue );
        this.showLoading = false;
    }

    handleCheckBox_cierreCaso_Change(e)
    {
        this.showLoading = true;
        this.cierreCasoValue  = e.detail.checked;
        console.log('@@@@ ' + this.cierreCasoValue );
        this.showLoading = false;
    }

    handle_Descripcion_Change(e)
    {
        this.descripcionValue = e.detail.value;
        console.log('descripcionValue  --> '+this.descripcionValue);
    }

    //##end region modal comun


    //##region modal create solicitud


    init_create_Solicitud()
    {
        this.polizaValue = '';
        this.polizas = [];

        this.categoriaValue = '';
        this.categorias = [];

        this.detalleSolicitudValue = '';
        this.detallesSolicitud = [];

        //VASS (SB):23122022
        this.detalleErrorSolicitudValue = '';
        this.detallesErrorSolicitud = [];
        this.es_error_solicitud = false;
        //----FIN----//

        this.detalleRescateValue = '';
        this.detallesRescate = [];
        this.es_detalle_rescate = false;

        this.detalleConfiguracionValue = '';
        this.detallesConfiguracion  = [];
        this.es_detalle_configuracion = false;

        this.fechaInicioSuspensionValue = '';
        this.mesesSuspensionValue = '';
        this.mesesSuspension = [];
        this.es_suspension_prima  = false;

        this.esProblemaValue = '';
        this.cierreCasoValue = '';
        this.descripcionValue = getFieldValue(this.record.data, DESCRIPTION_FIELD);

        var accountId = getFieldValue(this.record.data, ACCOUNTID_FIELD);
        var negocio =  getFieldValue(this.record.data, NEGOCIO_FIELD);
        var canal = getFieldValue(this.record.data, CANAL_FIELD);

        this.Load_polizas_caso(accountId, negocio, canal);

        get_pickList_Categorias({Negocio : negocio}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.categorias = [...values];
        });
    }


    handlePicklist_Categoria_Change(e) {
        this.showLoading = true;
        this.categoriaValue  = e.detail.value;
        this.detalleSolicitudValue  = '';
        console.log('@@@@ ' + this.categoriaValue );

        get_pickList_DetalleSolicitud({Categoria : this.categoriaValue }).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.detallesSolicitud = [...values];
            this.showLoading = false;
        });
    }


    handlePicklist_DetalleSolicitud_Change(e)
    {   //VASS (SB): 23122022
        this.es_error_solicitud = false;
        //----FIN-----//
        this.showLoading = true;
        this.detalleSolicitudValue  = e.detail.value;
        console.log('@@@@ ' + this.detalleSolicitudValue );

        this.es_detalle_rescate = false;
        this.es_detalle_configuracion  = false;
        this.es_suspension_prima  = false;

        this.detalleConfiguracionValue = '';
        this.detallesConfiguracion = [];

        this.detalleRescateValue = '';
        this.detallesRescate  = [];
        //VASS (SB):23122022
        if (this.detalleSolicitudValue == 'Error de liquidación')
        {
            get_pickList_DetalleErrorLiquidacion({}).then(r => {
                let values = [];
                r.forEach(rv => {
                    // from APEX
                    values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                    console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                });
                // LWC array tracking workaround
                this.detallesErrorSolicitud = [...values];
                this.showLoading = false;
            });
            this.es_error_solicitud = true;
        }
        //-----FIN-----//
        if (this.detalleSolicitudValue == 'Solicitud de suspensión de primas')
        {
            get_pickList_CantidadMesesSuspendido({}).then(r => {
                let values = [];
                r.forEach(rv => {
                    // from APEX
                    values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                    console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                });
                // LWC array tracking workaround
                this.mesesSuspension = [...values];
                this.showLoading = false;
            });
            this.es_suspension_prima = true;
        }
        else
        {
            get_pickList_DetalleRescate({DetalleSolicitud : this.detalleSolicitudValue }).then(r => {
                let values = [];
                r.forEach(rv => {
                    // from APEX
                    values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                    console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                });
                // LWC array tracking workaround
                this.detallesRescate = [...values];

                if (this.detallesRescate.length > 0)
                {
                    this.es_detalle_rescate = true;
                }
                this.showLoading = false;
            });

            get_pickList_DetalleConfiguracion({DetalleSolicitud : this.detalleSolicitudValue }).then(r => {
                let values = [];
                r.forEach(rv => {
                    // from APEX
                    values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                    console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
                });
                // LWC array tracking workaround
                this.detallesConfiguracion = [...values];

                if (this.detallesConfiguracion.length > 0)
                {
                    this.es_detalle_configuracion = true;
                }
                 this.showLoading = false;
            });
        }
    }
    //VASS(SB):23122022
    handlePicklist_DetalleErrorLiquidacionChange(e)
    {
        this.showLoading = true;
        this.detalleErrorSolicitudValue  = e.detail.value;
        console.log('@@@@ ' + this.detalleErrorSolicitudValue );
        this.showLoading = false;
    }
    //-----FIN-----//
    handlePicklist_DetalleRescate_Change(e)
    {
        this.showLoading = true;
        this.detalleRescateValue  = e.detail.value;
        console.log('@@@@ ' + this.detalleRescateValue );
        this.showLoading = false;
    }

    handlePicklist_DetalleConfiguracion_Change(e)
    {
        this.showLoading = true;
        this.detalleConfiguracionValue  = e.detail.value;
        console.log('@@@@ ' + this.detalleConfiguracionValue );
        this.showLoading = false;
    }

    handlePicklist_MesesSuspension_Change(e)
    {
        this.showLoading = true;
        this.mesesSuspensionValue  = e.detail.value;
        console.log('@@@@ ' + this.mesesSuspensionValue );
        this.showLoading = false;
    }




    closeModal_create_solicitud() {
        this.openmodel_create_solicitud = false
    }


    create_solicitud() {

        const isInputsCorrect = [...this.template.querySelectorAll('.validate')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        console.log('@@@@ isInputsCorrect' +isInputsCorrect);
        this.showLoading = true;
        var parentId =  getFieldValue(this.record.data, ID_FIELD);

        console.log('@@@@ esProblema' +this.esProblemaValue);
        console.log('@@@@ cierreCaso' +this.cierreCasoValue);

        if (isInputsCorrect == true)
        {
            create_CasoRequerimiento_Solicitud({parentId : parentId, polizaId : this.polizaValue, categoria : this.categoriaValue , detalleSolicitud : this.detalleSolicitudValue , detalleRescate : this.detalleRescateValue, detalleConfiguracion : this.detalleConfiguracionValue, fechaSuspension : this.fechaInicioSuspensionValue,  mesesSuspension : this.mesesSuspensionValue, esProblema : this.esProblemaValue, cierreCaso : this.cierreCasoValue, descripcion : this.descripcionValue, errorLiquidacion : this.detalleErrorSolicitudValue}) .then(r => {
                if(r != 'ERROR'){
                    this.showLoading = false;
                    this.openmodel_close = false
                    const evt = new ShowToastEvent({
                        title: 'Creación de Caso Solicitud',
                        message: 'El Caso Solicitud ha sido exitosamente creado.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    console.log('@@@@ id  '+r);
                    setTimeout(function () {
                        window.location = "/"+r;
                    }, 1500);  // After 1.5 secs
                }
                else{
                    this.showLoading = false;
                    const evt = new ShowToastEvent({
                        title: 'Creación de Caso Solicitud',
                        message: 'El Caso Solicitud no ha sido creado.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            })
            .catch((error) => {
                this.showLoading = false;
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
        else{
            this.showLoading = false;
            const evt = new ShowToastEvent({
                title: 'Creación de Caso Solicitud',
                message: 'Existen campos obligatorios que no se encuentran ingresados.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

     //##region modal create solicitud

     //##region modal create consultas
    init_create_Consulta()
    {
        this.polizaValue = '';
        this.polizas = [];

        this.conceptoValue = '';
        this.conceptos = [];

        this.esProblemaValue = '';
        this.cierreCasoValue = '';

        //aca validacion de protocolo
        this.esProtocoloAtencionValue = ''; //inicia seleccionado, si false no aparece drop siguiente
        this.protocoloAtencion = '';
        this.optionsProtocolo = [];
        this.optionSelect = '';
        this.descripcionValue = getFieldValue(this.record.data, DESCRIPTION_FIELD);

        var accountId = getFieldValue(this.record.data, ACCOUNTID_FIELD);
        var negocio =  getFieldValue(this.record.data, NEGOCIO_FIELD);
        var canal = getFieldValue(this.record.data, CANAL_FIELD);

        this.Load_polizas_caso(accountId, negocio, canal);

        get_pickList_Conceptos({Negocio : negocio}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.conceptos = [...values];
        });

        getOptionsProtocolo({}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.Id, value: rv.Name });
                console.log('@@@@  --> '+rv.Id + '  @@  '+ rv.Name );
            });
            // LWC array tracking workaround
            this.optionsProtocolo = [...values];
        });


    }

    closeModal_create_consulta() {
        this.openmodel_create_consulta = false
    }


    handlePicklist_Concepto_Change(e) {
        this.showLoading = true;
        this.conceptoValue  = e.detail.value;
        getIsProtocoloAtencion({Concepto : this.conceptoValue}).then(result => {
            this.protocoloAtencion = result;
            if (this.protocoloAtencion == true)
            {
                this.esProtocoloAtencionValue = true;
            }
            console.log('@@@@  this.protocoloAtencion --> ' +this.protocoloAtencion );
            console.log('@@@@  this.esProtocoloAtencionValue --> ' +this.esProtocoloAtencionValue );

        });

        console.log('@@@@ ' + this.conceptoValue );
        setTimeout(() => { this.showLoading = false;}, 1000);
    }

    create_consulta() {

        const isInputsCorrect = [...this.template.querySelectorAll('.validate')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        console.log('@@@@ isInputsCorrect' +isInputsCorrect);
        this.showLoading = true;
        var parentId =  getFieldValue(this.record.data, ID_FIELD);

        console.log('@@@@ esProblema' +this.esProblemaValue);
        console.log('@@@@ cierreCaso' +this.cierreCasoValue);

        if (isInputsCorrect == true)
        {
            create_CasoRequerimiento_Consulta({parentId : parentId, polizaId : this.polizaValue, concepto : this.conceptoValue, esProblema : this.esProblemaValue, cierreCaso : this.cierreCasoValue, descripcion : this.descripcionValue,
                esProtocolo : this.esProtocoloAtencionValue, autoAtencion : this.optionSelect}) .then(r => {
                if(r != 'ERROR'){
                    this.showLoading = false;
                    this.openmodel_close = false
                    const evt = new ShowToastEvent({
                        title: 'Creación de Caso Consulta',
                        message: 'El Caso Consulta ha sido exitosamente creado.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    console.log('@@@@ id  '+r);
                    setTimeout(function () {
                        window.location = "/"+r;
                    }, 1500);  // After 1.5 secs
                }
                else{
                    this.showLoading = false;
                    const evt = new ShowToastEvent({
                        title: 'Creación de Caso Consulta',
                        message: 'El Caso Consulta no ha sido creado.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            })
            .catch((error) => {
                this.showLoading = false;
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
        else{
            this.showLoading = false;
            const evt = new ShowToastEvent({
                title: 'Creación de Caso Consulta',
                message: 'Existen campos obligatorios que no se encuentran ingresados.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

    handleCheckBox_esProtocolo_Change(e)
    {
       // this.showLoading = true;
       this.esProtocoloAtencionValue  = e.detail.checked;
       console.log('@@@@  this.esProtocoloAtencionValue --> ' +this.esProtocoloAtencionValue );
    }

    handlePicklist_OptionProtocolo_Change(e)
    {
        // this.showLoading = true;
        this.optionSelect  = e.detail.value;
        console.log('@@@@  this.optionSelect --> ' +this.optionSelect );
    }



        //##region modal create consultas

     //##region modal create reclamos

    init_create_Reclamo()
    {
        this.polizaValue = '';
        this.polizas = [];

        this.productoValue = '';
        this.productos = [];

        this.tipoOperacionValue = '';
        this.tiposOperacion = [];

        this.detalleOperacionValue = '';
        this.detallesOperacion = [];

        this.esProblemaValue = '';
        this.respuestaEmailValue = '';
        this.respuestaCartaValue = '';

        this.descripcionValue = getFieldValue(this.record.data, DESCRIPTION_FIELD);

        var accountId = getFieldValue(this.record.data, ACCOUNTID_FIELD);
        var negocio =  getFieldValue(this.record.data, NEGOCIO_FIELD);
        var canal = getFieldValue(this.record.data, CANAL_FIELD);

        this.Load_polizas_caso(accountId, negocio, canal);

        get_pickList_Productos({Negocio : negocio}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.productos = [...values];
        });
    }

    closeModal_create_reclamo() {
        this.openmodel_create_reclamo = false
    }


    handlePicklist_Producto_Change(e) {
        this.showLoading = true;
        this.productoValue  = e.detail.value;
        console.log('@@@@ ' + this.productoValue );

        this.tipoOperacionValue = '';
        this.tiposOperacion = [];

        get_pickList_TipoOperacion({Producto : this.productoValue}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.tiposOperacion = [...values];
            this.showLoading = false;
        });
    }

    handlePicklist_TipoOperacion_Change(e) {
        this.showLoading = true;
        this.tipoOperacionValue  = e.detail.value;
        console.log('@@@@ ' + this.tipoOperacionValue );

        this.detalleOperacionValue = '';
        this.detallesOperacion = [];

        get_pickList_DetalleOperacion({TipoOperacion : this.tipoOperacionValue}).then(r => {
            let values = [];
            r.forEach(rv => {
                // from APEX
                values.push({label: rv.custFldlabel, value: rv.custFldvalue });
                console.log('@@@@  --> '+rv.custFldlabel + '  @@  '+ rv.custFldvalue );
            });
            // LWC array tracking workaround
            this.detallesOperacion = [...values];
            this.showLoading = false;
        });
    }

    handlePicklist_DetalleOperacion_Change(e) {
        this.showLoading = true;
        this.detalleOperacionValue  = e.detail.value;
        console.log('@@@@ ' + this.detalleOperacionValue );
        setTimeout(() => { this.showLoading = false;}, 1500);
    }


    handleCheckBox_respuestaCarta_Change(e)
    {
        this.showLoading = true;
        this.respuestaCartaValue  = e.detail.checked;
        console.log('@@@@ ' + this.respuestaCartaValue );
        this.showLoading = false;
    }

    handleCheckBox_respuestaEmail_Change(e)
    {
        this.showLoading = true;
        this.respuestaEmailValue  = e.detail.checked;
        console.log('@@@@ ' + this.respuestaEmailValue );
        this.showLoading = false;
    }


    create_reclamo() {

        const isInputsCorrect = [...this.template.querySelectorAll('.validate')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        console.log('@@@@ isInputsCorrect' +isInputsCorrect);
        this.showLoading = true;
        var parentId =  getFieldValue(this.record.data, ID_FIELD);

        console.log('@@@@ esProblema' +this.esProblemaValue);
        console.log('@@@@ cierreCaso' +this.cierreCasoValue);

        var error = false;

        if (this.respuestaEmailValue == false && this.respuestaCartaValue == false)
        {
            error = true;
            this.showLoading = false;
            const evt = new ShowToastEvent({
                title: 'Creación de Caso Reclamo',
                message: 'Debe seleccionar una Opción de Respuesta asociada al Caso.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }

        if (error == false)
        {
            if (isInputsCorrect == true)
            {
                create_CasoRequerimiento_Reclamo({parentId : parentId, polizaId : this.polizaValue, producto : this.productoValue, tipoOperacion : this.tipoOperacionValue, detalleOperacion : this.detalleOperacionValue, respuestaCarta : this.respuestaCartaValue, respuestaEmail : this.respuestaEmailValue, esProblema : this.esProblemaValue,  descripcion : this.descripcionValue}) .then(r => {
                    if(r != 'ERROR'){
                        this.showLoading = false;
                        this.openmodel_close = false
                        const evt = new ShowToastEvent({
                            title: 'Creación de Caso Reclamo',
                            message: 'El Caso Reclamo ha sido exitosamente creado.',
                            variant: 'success',
                        });
                        this.dispatchEvent(evt);
                        console.log('@@@@ id  '+r);
                        setTimeout(function () {
                            window.location = "/"+r;
                        }, 1500);  // After 1.5 secs
                    }
                    else{
                        this.showLoading = false;
                        const evt = new ShowToastEvent({
                            title: 'Creación de Caso Reclamo',
                            message: 'El Caso Reclamo no ha sido creado.',
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    }
                })
                .catch((error) => {
                    this.showLoading = false;
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
            else{
                this.showLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Creación de Caso Reclamo',
                    message: 'Existen campos obligatorios que no se encuentran ingresados.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        }

    }
        //##region modal create reclamos


}