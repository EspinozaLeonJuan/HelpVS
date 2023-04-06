/*
  @description       :
  @author            : Juan Espinoza León
  @group             :
  @last modified on  : 10-29-2022
  @last modified by  : Juan Espinoza León
*/
import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import changeStatus from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import CATEGORIA_FIELD from '@salesforce/schema/Case.CASO_Categoria__c';
import POLIZA_FIELD from '@salesforce/schema/Case.CASO_N_Poliza__c';
import POLIZA_NAME_FIELD from '@salesforce/schema/Case.CASO_Poliza_Asoc__c';
import CURRENTUSER_ID from '@salesforce/user/Id';
import HABILITADO_SINIESTRO_FIELD from '@salesforce/schema/User.Habilitado_Siniestros_Web__c';
import HABILITADO_RESCATE_FIELD from '@salesforce/schema/User.Habilitado_Rescates_Web__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import ID_REQUERIMIENTO_FIELD from '@salesforce/schema/Case.Id_Requerimiento_EscritorioDigital__c';
import RESPONSABLE_UR_FIELD from '@salesforce/schema/Case.CASO_Responsable_UR__c';
import CANAL_FIELD from '@salesforce/schema/Case.Canal__c';

import get_esCasoDerivable from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_esCasoDerivable';
import get_esDerivacionOptativa from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_esDerivacionOptativa';
import get_cambioEscritorioDigital from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.get_cambioEscritorioDigital';
import to_DerivateCase from '@salesforce/apex/CLS_CS_Gestion_CasoRequerimiento.DerivarCaso';

export default class Gestion_caso_solicitud extends LightningElement {
    objectApiName = CASE_OBJECT;

    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: [
                 ID_FIELD,
                 STATUS_FIELD,
                 CATEGORIA_FIELD,
                 POLIZA_FIELD,
                 POLIZA_NAME_FIELD,
                 ID_REQUERIMIENTO_FIELD,
                 RESPONSABLE_UR_FIELD,
                 CANAL_FIELD
                ]
    })
    record;

    @wire(getRecord, {
        recordId: CURRENTUSER_ID,
        fields: [
            HABILITADO_SINIESTRO_FIELD,
            HABILITADO_RESCATE_FIELD
                ]
    })
    userData;

    @wire(get_cambioEscritorioDigital , {IdCaso :  '$recordId'})
    infoEscritorioDigital;

    @wire(get_esCasoDerivable , {IdCaso :  '$recordId'})
    esCasoDerivable;

    @wire(get_esDerivacionOptativa , {IdCaso :  '$recordId'})
    esCasoDerivacionOptativa;

    @track  openmodel_toderivate = false;

    @track  template_toderivate_optativa = false;
    //@track  openmodel_toderivate = false;
    @track button_toDerivar;
    @track motivoDerivacion = '';

    @track requerimientoEscritorio;

    @track button_siniestro = false;
    @track button_rescate = false;

    @track button_escritorio_digital = false;

    @track button_derivar_crear_requerimiento = false;

    @track button_derivar_eliminar_requerimiento = false;

    @track button_derivar_ver_requerimiento = false;

    @track button_derivar = false;

    @track showLoading = false;

    get showOption_Apertura() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        if (statusCase == 'Cerrado')
        {
            return true;
        }
        else
        {
            return false;
        }
    }

   /* connectedCallback()
    {
        console.log('@@@@ loadData ');
        var data_ed = JSON.stringify(this.infoEscritorioDigital);
        console.log('@@@@  data * ed --> '+data_ed);

        var response_ed = JSON.parse(data_ed);
        console.log('@@@@  response.data  ed --> '+ response_ed.data);

        this.requerimientoEscritorio = response_ed.data;
        console.log('@@@@ this.requerimientoEscritorio --> '+ this.requerimientoEscritorio);

        if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_ED')
        {
            this.button_escritorio_digital = false;
            this.button_derivar_crear_requerimiento = false;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_CREADO_ED')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_crear_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'RUT_USUARIO_NO_REGISTRADO')
        {
            this.button_escritorio_digital = false;
            this.button_derivar_crear_requerimiento = false;
        }
        else if (this.requerimientoEscritorio == 'CAMBIO_ESTADO_OK')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_ESTADO_INGRESADO')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_ESTADO_FINALIZADO')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'PENDIENTE_DOCUMENTOS_VALUETECH')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_CARGADO_VALUETECH')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'VALUETECH_ERROR')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'CAMBIO_ESTADO_ERROR')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'RUT_USUARIO_NO_REGISTRADO')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'EXCEPCION')
        {
            this.button_escritorio_digital = true;
            this.button_derivar_eliminar_requerimiento =  true;
            this.button_derivar_ver_requerimiento = true;
        }
    }
 */
    /* Para visualizacion de botones template base */

    get showOption_Cierre() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);

        if (responsableUR == null)
            responsableUR = '';

        if (statusCase == 'Cerrado' || statusCase == 'Rechazado' || statusCase == 'En Revisión' || statusCase == 'Back Office' ||  (statusCase != 'En Proceso' && responsableUR != ''))
        {
            return false;
        }
        else
        {
            return true;
        }
    }


    get showOption_addDocRepository()
    {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);
        var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);

        if (responsableUR == null)
            responsableUR = '';

        //if (statusCase == 'Cerrado' || statusCase == 'Rechazado' || statusCase == 'Back Office' ||  (statusCase != 'En Proceso' && (responsableUR != '')) )
        if (statusCase == 'Cerrado' || statusCase == 'Rechazado'  )  {
            return false;
        }

        return true;
    }

    /* Para visualizacion de botones template base */
    get showOption_DerivarCaso() {
        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);

        var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);

        console.log('@@@@ 214  statusCase  --> '+statusCase);
        console.log('@@@@ 215 responsableUR --> '+responsableUR);

        if (responsableUR == null)
            responsableUR = '';

        if (statusCase == 'Cerrado' || statusCase == 'Rechazado' || statusCase == 'Back Office' ||  (statusCase != 'En Proceso' && (responsableUR != '')) )
        {
            return false;
        }

        var data_der = JSON.stringify(this.esCasoDerivable);
        console.log('@@@@  data ed --> '+data_der);

        var response_der = JSON.parse(data_der);
        console.log('@@@@  response.data  ed --> '+ response_der.data);

        var esDerivable  = response_der.data;
        console.log('@@@@ esDerivable --> '+ esDerivable);

        var isTrueSet = (esDerivable === 'true');

        console.log('@@@@ isTrueSet --> '+ isTrueSet);

        if (isTrueSet == true)
        {
            this.button_derivar = true;

            if (this.button_derivar_eliminar_requerimiento == true)
            {
                this.button_derivar = false;
            }

            return true;
        }
    }


    /* Para visualizacion de botones template base */
    get showOption_SiniestroRescate() {

        console.log('currentuserId : '+CURRENTUSER_ID);

        var opcionRescate  = getFieldValue(this.userData.data, HABILITADO_RESCATE_FIELD);
        console.log('opcionRescate : '+opcionRescate);
     //   var isTrueSet_Rescate = (opcionRescate == 'true');
       // console.log('isTrueSet_Rescate  '+ isTrueSet_Rescate);
        this.button_rescate = opcionRescate;

        var opcionSiniestro  = getFieldValue(this.userData.data, HABILITADO_SINIESTRO_FIELD);
        console.log('opcionSiniestro : '+opcionSiniestro);
      //  var isTrueSet_Siniestro = (opcionSiniestro == 'true');
       // console.log('isTrueSet_Siniestro  '+ isTrueSet_Siniestro);
        this.button_siniestro = opcionSiniestro;

        //console.log('IdPersistencia_Rescate  '+IdPersistencia_Rescate);
        console.log('button_siniestro  '+ this.button_siniestro);
        console.log('button_rescate  '+ this.button_rescate);
        if (this.button_rescate == true || this.button_siniestro == true)
        {
            var categoria  = getFieldValue(this.record.data, CATEGORIA_FIELD);
            console.log('@@@@ categoria  '+categoria);
            if (categoria == 'Siniestros/Rescates' || categoria == 'Siniestros/ Rescates F')
            {
                return true;
            }
        }

        return false;
    }


      /* Para visualizacion de botones template base */
    get showOption_EscritorioDigital() {

        var statusCase  = getFieldValue(this.record.data, STATUS_FIELD);
        var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);

        if (responsableUR == null)
            responsableUR = '';

        var salida = true;

        if (statusCase == 'Cerrado' || statusCase == 'Rechazado' || statusCase == 'Back Office' ||  (statusCase != 'En Proceso' && (responsableUR != '')) )
        {
            salida = false;
        }

        if (salida == false)
        {
            return salida;
        }

        console.log('@@@@ loadData ');
        var data_ed = JSON.stringify(this.infoEscritorioDigital);
        console.log('@@@@  data * ed --> '+data_ed);

        var response_ed = JSON.parse(data_ed);
        console.log('@@@@  response.data  ed --> '+ response_ed.data);

        this.requerimientoEscritorio = response_ed.data;
        console.log('@@@@ this.requerimientoEscritorio --> '+ this.requerimientoEscritorio);

        if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_ED')
        {
            salida = false;
            this.button_derivar_crear_requerimiento = false;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_CREADO_ED')
        {
            salida = true;
            this.button_derivar_crear_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'RUT_USUARIO_NO_REGISTRADO')
        {
            salida = false;
            this.button_derivar_crear_requerimiento = false;
        }
        else if (this.requerimientoEscritorio == 'CAMBIO_ESTADO_OK')
        {
            //salida = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_ESTADO_INGRESADO')
        {
            //salida = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_ESTADO_FINALIZADO')
        {
            //salida = true;
            this.button_derivar_crear_requerimiento = false;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'PENDIENTE_DOCUMENTOS_VALUETECH')
        {
            //salida = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_CARGADO_VALUETECH')
        {
            //salida = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'VALUETECH_ERROR')
        {
            //salida = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'CAMBIO_ESTADO_ERROR')
        {
           // salida = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'RUT_USUARIO_NO_REGISTRADO')
        {
            //salida = true;
            this.button_derivar_eliminar_requerimiento = true;
            this.button_derivar_ver_requerimiento = true;
        }
        else if (this.requerimientoEscritorio == 'EXCEPCION')
        {
            //salida = true;
            this.button_derivar_eliminar_requerimiento =  true;
            this.button_derivar_ver_requerimiento = true;
        }

        return salida;
    }
    //##region cierre de caso

    @track openmodel_close = false;

    openmodal_close() {
        this.openmodel_close = true
    }

    closeModal_close() {
        this.openmodel_close = false
    }

    saveMethod_close() {
        var updateParentStatus = false; // para cambiar estado del caso padre relacionado

        //canal seguro covid
        var canal  = getFieldValue(this.record.data, CANAL_FIELD);

        /*if (canal == 'SEGURO COVID')
        {
            updateParentStatus = true;
        }*/
        //canal seguro covid

       this.showLoading = true;
        changeStatus({Id : this.recordId, Status : 'Cerrado', UpdateParent : updateParentStatus })
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Solicitud',
                    message: 'El Caso de Solicitud ha sido exitosamente cerrado.',
                    variant: 'success',
                });
                this.openmodel_close = false
                this.dispatchEvent(evt);

                setTimeout(function () {
                    window.location.reload();
                }, 1000);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Cierre de Caso Solicitud',
                    message: 'El Caso Solicitud no ha sido cerrado.',
                    variant: 'error',
                });
                //this.openmodel_close = false
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
             //   this.openmodel_close = false
                this.dispatchEvent(evt);
        });
        this.showLoading = false;

    }
    //##region cierre de caso


    //##region reabrir caso

    @track openmodel_reopen = false;

    openmodal_reopen() {
        this.openmodel_reopen = true
    }

    closeModal_reopen() {
        this.openmodel_reopen = false
    }

    saveMethod_reopen() {
        var updateParentStatus = false; // para cambiar estado del caso padre relacionado

        //canal seguro covid
        var canal  = getFieldValue(this.record.data, CANAL_FIELD);

        if (canal == 'SEGURO COVID')
        {
            updateParentStatus = true;
        }
        //canal seguro covid

        this.showLoading = true;
        changeStatus({Id : this.recordId, Status : 'En Proceso', UpdateParent : updateParentStatus })
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Solicitud',
                    message: 'El Caso Solicitud ha sido exitosamente reabierto.',
                    variant: 'success',
                });
                this.openmodel_reopen = false;
                this.dispatchEvent(evt);

                setTimeout(function () {
                    window.location.reload();
                }, 1000);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Reapertura de Caso Solicitud',
                    message: 'El Caso Solicitud no ha sido reabierto.',
                    variant: 'error',
                });
                //this.openmodel_reopen = false;
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
                //this.openmodel_reopen = false;
                this.dispatchEvent(evt);
        });
        this.showLoading = false;
    }
    //##region reabrir caso

     //##region derivacion de casos

    to_derivarCaso()
    {
        console.log('@@@@ to_DerivateCase');
        console.log('@@@@ to_DerivateCase Motivo '+ this.motivoDerivacion);
        console.log('@@@@ to_DerivateCase this.recordId'+ this.recordId);
        this.showLoading = true;

        to_DerivateCase({Id : this.recordId,  Motivo :  this.motivoDerivacion})
        .then(r => {
            if(r== true){
                const evt = new ShowToastEvent({
                    title: 'Derivar Caso Solicitud',
                    message: 'El Caso Solicitud ha sido exitosamente derivado.',
                    variant: 'success',
                });
                this.openmodel_toderivate = false;
                this.dispatchEvent(evt);

                setTimeout(function () {
                    window.location.reload();
                }, 1500);  // After 1.5 secs
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Derivar Caso Solicitud',
                    message: 'El Caso Solicitud no ha sido derivado.',
                    variant: 'error',
                });
              //  this.openmodel_toderivate = false;
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
            //    this.openmodel_toderivate = false;
                this.dispatchEvent(evt);
        });

        this.showLoading = false;

    }

    closeModal_derivarCaso() {
        this.openmodel_toderivate = false;
    }

    closeModal_derivarCaso_Optativo() {
        this.motivoDerivacion = '';
        this.openmodel_toderivate_optativa = false;
    }

    openmodal_derivarCaso()
    {
        console.log('@@@@ requerimientoEscritorio   -> '+ this.requerimientoEscritorio);

        var estadoCaso  = getFieldValue(this.record.data, STATUS_FIELD);
        console.log('@@@@ estadoCaso   -> '+ estadoCaso);

        var despliegueOpciones = true;

        if (estadoCaso == 'Cerrado' )
        {
            const evt = new ShowToastEvent({
                title: 'Derivar Caso a Bandeja UR',
                message: 'No se puede Derivar el Caso ya que este se encuentra en Estado Cerrado.',
                variant: 'error',
            });

            this.dispatchEvent(evt);
            despliegueOpciones = false;
        }
        else if (estadoCaso == 'Rechazado' )
        {
            const evt = new ShowToastEvent({
                title: 'Derivar Caso a Bandeja UR',
                message: 'No se puede Derivar el Caso ya que este se encuentra en Estado Rechazado.',
                variant: 'error',
            });

            this.dispatchEvent(evt);
            despliegueOpciones = false;
        }
        else if (estadoCaso == 'Back Office' )
        {
            const evt = new ShowToastEvent({
                title: 'Derivar Caso a Bandeja UR',
                message: 'No se puede Derivar el Caso ya que este se encuentra en Estado Back Office.',
                variant: 'error',
            });

            this.dispatchEvent(evt);
            despliegueOpciones = false;
        }
        else if (estadoCaso == 'En Proceso')
        {
            var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);

            if (responsableUR != null && responsableUR != '')
            {
                const evt = new ShowToastEvent({
                    title: 'Derivar Caso a Bandeja UR',
                    message: 'No se puede Derivar el Caso ya que este se encuentra en Proceso de Derivación.',
                    variant: 'error',
                });

                this.dispatchEvent(evt);

                despliegueOpciones = false;
            }
        }

        console.log('@@@@ 323.despliegueOpciones  --> '+ despliegueOpciones);

        if (despliegueOpciones == true)
        {
            var data_do = JSON.stringify(this.esCasoDerivacionOptativa);
            console.log('@@@@  data do --> '+ data_do);

            var response_do = JSON.parse(data_do);
            console.log('@@@@  response.data do --> '+ response_do.data);

            var esDerivacionOptativa = response_do.data;

            var isTrueSet = (esDerivacionOptativa === 'true');

            if (isTrueSet == true && this.button_derivar_eliminar_requerimiento == false)
            {
                const evt = new ShowToastEvent({
                    title: 'Derivar Caso a Bandeja UR',
                    message: 'El Caso seleccionado puede ser resuelto sin la necesidad de ser Derivado al area correspondiente.',
                    variant: 'warning',
                    mode: 'dismissable'
                });

                this.dispatchEvent(evt);

                this.template_toderivate_optativa = true;
            }


            if (this.button_derivar_crear_requerimiento == true)
            {
                const evt = new ShowToastEvent({
                    title: 'Derivar Caso a Bandeja UR',
                    message: 'Para el Caso a Derivar no existe un Requerimiento de Escritorio Digital asociado.',
                    variant: 'info',
                     //mode: 'sticky'
                    mode: 'dismissable'
                });

                this.dispatchEvent(evt);
            }

            if (this.button_derivar_eliminar_requerimiento == true)
            {
                console.log('@@@@  this.requerimientoEscritorio  '+this.requerimientoEscritorio);

                if (this.requerimientoEscritorio == 'PENDIENTE_DOCUMENTOS_VALUETECH')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'Existen en Valuetech documentos pendientes asociados al Requerimiento de Escritorio Digital generado para el Caso seleccionado.',
                        variant: 'error',
                       //mode: 'sticky'
                       mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }
                else if (this.requerimientoEscritorio == 'REQUERIMIENTO_NO_CARGADO_VALUETECH')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'El Requerimiento de Escritorio Digital asociado al Caso no ha sido ingresado en Valuetech.',
                        variant: 'error',
                        //mode: 'sticky'
                        mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }
                else if (this.requerimientoEscritorio == 'VALUETECH_ERROR')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.',
                        variant: 'error',
                        //mode: 'sticky'
                        mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }
                else if (this.requerimientoEscritorio == 'CAMBIO_ESTADO_ERROR')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.',
                        variant: 'error',
                        //mode: 'dismissable'
                        mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }
                else if (this.requerimientoEscritorio == 'RUT_USUARIO_NO_REGISTRADO')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'El usuario actual no tiene registrado un RUT válido en Salesforce.',
                        variant: 'error',
                        //mode: 'sticky'
                        mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }
                else if (this.requerimientoEscritorio == 'EXCEPCION')
                {
                    const evt = new ShowToastEvent({
                        title: 'Derivar Caso a Bandeja UR',
                        message: 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.',
                        variant: 'error',
                        //mode: 'sticky'
                        mode: 'dismissable'
                    });

                    this.dispatchEvent(evt);
                }

                this.template_toderivate_optativa = false;
            }

            this.openmodel_toderivate = true;
        }

        console.log('@@@@ this.openmodel_toderivate_optativa '+this.openmodel_toderivate_optativa);
        console.log('@@@@ this.openmodel_toderivate '+this.openmodel_toderivate);
    }

    crearRequerimientoEscritorio()
    {
        this.openmodel_toderivate = false;
        var seleccion = confirm("¿ Desea crear un nuevo Requerimiento de Escritorio Digital asociado al Caso ?");

        if (seleccion)
        {
            var idCase = getFieldValue(this.record.data, ID_FIELD);
            var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;

            console.log('URL : '+url);

            var popUp = window.open(url, "_blank");
//            "Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");

            if (popUp == null || typeof(popUp)=='undefined') {
                alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
            }
            else {
                popUp.focus();
            }
        }
    }

    verRequerimientoEscritorio()
    {
        this.openmodel_toderivate = false;
        var idCase = getFieldValue(this.record.data, ID_FIELD);

        var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;

        console.log('URL : '+url);

        var popUp = window.open(url, "_blank");

//c/gestion_caso_solicitud            "Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");

        if (popUp == null || typeof(popUp)=='undefined') {
            alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
        }
        else {
            popUp.focus();
        }


    }
    //##end region derivacion de casos



    //##region repositorio documentos
    addDocRepository()
    {
        var idCase = getFieldValue(this.record.data, ID_FIELD);
        var url = "/apex/SEC_VF_CS_UploadValuetech?Id="+idCase+"&From=caso_nativo";

        var popUp = window.open(url, "_blank");
//        "Carga Adjunto a Repositorio de Documentos", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=1150, height=400, top = 350, left = 500");

        if (popUp == null || typeof(popUp)=='undefined') {
            alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
        }
        else {
            popUp.focus();
        }
    }

    //##region repositorio documentos


    //##region consulta siniestros / rescates



    toRescateWeb()
    {
        //var polizaId  = getFieldValue(this.record.data, POLIZA_FIELD);
        var poliza  = getFieldValue(this.record.data, POLIZA_NAME_FIELD);

        if (poliza == null || poliza == '')
        {
            const evt = new ShowToastEvent({
                title: 'Acceso a Rescates Web',
                message: 'Para acceder a Consultar Rescates asociados a la Cuenta, debe seleccionar una Póliza dentro del Caso Solicitud.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
        else
        {
            var idCase = getFieldValue(this.record.data, ID_FIELD);
           // document.location = "/apex/VIE_CasoConsultaRescates?id="+idCase;

          //  var url = "/apex/VIE_CasoConsultaRescates?id="+idCase;
            var url = "/apex/SEC_VF_CS_Consulta?id="+idCase+"&tipo=R";

            var popUp = window.open(url, "_blank");

            if (popUp == null || typeof(popUp)=='undefined') {
                alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
            }
            else {
                popUp.focus();
            }

        }
    }


    toSiniestrosWeb()
    {
       // var polizaId  = getFieldValue(this.record.data, POLIZA_FIELD);
        var poliza  = getFieldValue(this.record.data, POLIZA_NAME_FIELD);

        if (poliza == null || poliza == '')
        {
            const evt = new ShowToastEvent({
                title: 'Acceso a Siniestros Web',
                message: 'Para acceder a Consultar Siniestros asociados a la Cuenta, debe seleccionar una Póliza dentro del Caso Solicitud.',
                variant: 'error',
            });

            this.dispatchEvent(evt);
        }
        else
        {
            var idCase = getFieldValue(this.record.data, ID_FIELD);
            var url = "/apex/SEC_VF_CS_Consulta?id="+idCase+"&tipo=S";
            var popUp = window.open(url, "_blank");

            if (popUp == null || typeof(popUp)=='undefined') {
                alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
            }
            else {
                popUp.focus();
            }
        }
    }


    toEscritorioDigital()
    {
       // var polizaId  = getFieldValue(this.record.data, POLIZA_FIELD);
        var requerimientoId  = getFieldValue(this.record.data, ID_REQUERIMIENTO_FIELD);
        var responsableUR  = getFieldValue(this.record.data, RESPONSABLE_UR_FIELD);
        var estadoCaso  = getFieldValue(this.record.data, STATUS_FIELD);
        var idCase = getFieldValue(this.record.data, ID_FIELD);

        if (requerimientoId != null && requerimientoId != '')
        {
           // document.location = "/apex/SEC_VF_ED_VerRequerimiento?id="+idCase;
            var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;

            console.log('URL : '+url);

            var popUp = window.open(url,"_blank");
//            "Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");

            if (popUp == null || typeof(popUp)=='undefined') {
                alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
            }
            else {
                popUp.focus();
            }
        }
        else
        {
            if ( estadoCaso == 'Cerrado' )
            {
                const evt = new ShowToastEvent({
                    title: 'Acceso a Escritorio Digital',
                    message: 'No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en Estado Cerrado.',
                    variant: 'error',
                });

                this.dispatchEvent(evt);
            }
            else if ( estadoCaso == 'Rechazado' )
            {
                const evt = new ShowToastEvent({
                    title: 'Acceso a Escritorio Digital',
                    message: 'No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en Estado Rechazado.',
                    variant: 'error',
                });

                this.dispatchEvent(evt);
            }
            else if ( estadoCaso == 'Back Office' )
            {
                const evt = new ShowToastEvent({
                    title: 'Acceso a Escritorio Digital',
                    message: 'No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en proceso de Derivación (Back Office).',
                    variant: 'error',
                });

                this.dispatchEvent(evt);
            }
            else if ( estadoCaso == 'En Proceso')
            {
                if (responsableUR != null && responsableUR != '')
                {
                    const evt = new ShowToastEvent({
                        title: 'Acceso a Escritorio Digital',
                        message: 'No se puede generar Requerimiento en Escritorio Digital ya que el Caso se encuentra en proceso de Derivación (En Proceso).',
                        variant: 'error',
                    });

                    this.dispatchEvent(evt);
                }
                else
                {
                    var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;

                    console.log('URL : '+url);

                    var popUp = window.open(url,"_blank");
//                    "Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");

                    if (popUp == null || typeof(popUp)=='undefined') {
                        alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
                    }
                    else {
                        popUp.focus();
                    }
                }
            }
            else
            {
                var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;

                console.log('URL : '+url);

                var popUp = window.open(url,"_blank");
//                "Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");

                if (popUp == null || typeof(popUp)=='undefined') {
                    alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');
                }
                else {
                    popUp.focus();
                }
                /*var url =  "/apex/SEC_VF_CS_EscritorioDigital?id="+idCase;
                console.log('URL : '+url);
               // window.open(url ,"_blank", '');
               window.open(url,"Requerimiento Escritorio Digital", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=850, height=400, top = 350, left = 500");*/
            }
        }
    }


    ingresoMotivoDerivacion(event){
        this.motivoDerivacion = event.target.value;
     }


}