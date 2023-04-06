import { LightningElement , api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import {refreshApex} from '@salesforce/apex';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import LEAD_OBJECT from '@salesforce/schema/Lead';
import TIPO_MAILING_FIELD from '@salesforce/schema/Lead.Tipo_Mailing__c';
import NOMBRE_PRODUCTO_EN_CAMPA_A_FIELD from '@salesforce/schema/Lead.Nombre_producto_en_campa_a__c';
import NUMERO_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Numero_Poliza_Campagna__c';
import FECHA_INICIO_VIGENCIA_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Fecha_inicio_vigencia_Poliza_Campagna__c';
import PERIODICIDAD_PAGO_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Periodicidad_pago_Poliza_Campagna__c';
import MEDIO_PAGO_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Medio_Pago_Poliza_Campagna__c';
import CAPITAL_FALLECIMIENTO_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Capital_Fallecimiento_Poliza_Campagna__c';
import PRIMA_POLIZA_CAMPAGNA_FIELD from '@salesforce/schema/Lead.Prima_Poliza_Campagna__c';
import SIMULACION_1_FIELD from '@salesforce/schema/Lead.Simulacion_1__c';
import SIMULACION_2_FIELD from '@salesforce/schema/Lead.Simulacion_2__c';
import SIMULACION_3_FIELD from '@salesforce/schema/Lead.Simulacion_3__c';
import SIMULACION_4_FIELD from '@salesforce/schema/Lead.Simulacion_4__c';
import SIMULACION_5_FIELD from '@salesforce/schema/Lead.Simulacion_5__c';
import SIMULACION_6_FIELD from '@salesforce/schema/Lead.Simulacion_6__c';
import SUPUESTO_SIMULACION_1_FIELD from '@salesforce/schema/Lead.Supuesto_simulacion_1__c';
import SUPUESTO_SIMULACION_2_FIELD from '@salesforce/schema/Lead.Supuesto_simulacion_2__c';
import SUPUESTO_SIMULACION_3_FIELD from '@salesforce/schema/Lead.Supuesto_simulacion_3__c';
import ULTIMO_PRODUCTO_CONTRATADO_FIELD from '@salesforce/schema/Lead.Ultimo_producto_contratado__c';
import NUMERO_ULTIMA_POLIZA_CONTRATADA_FIELD from '@salesforce/schema/Lead.Numero_ultima_Poliza_contratada__c';
import FECHA_INICIO_VIGENCIA_ULTIMA_POLIZA_CONT_FIELD from '@salesforce/schema/Lead.Fecha_inicio_vigencia_ultima_Poliza_cont__c';
import PERIODICIDAD_PAGO_ULTIMA_POLIZA_CONTR_FIELD from '@salesforce/schema/Lead.Periodicidad_pago_ultima_Poliza_contr__c';
import MEDIO_PAGO_ULTIMA_POLIZA_CONTR_FIELD from '@salesforce/schema/Lead.Medio_Pago_ultima_Poliza_contr__c';
import CAPITAL_FALLECIMIENTO_ULTIMA_POLIZA_CONT_FIELD from '@salesforce/schema/Lead.Capital_fallecimiento_ultima_Poliza_cont__c';
import PRIMA_ULTIMA_POLIZA_CONTRATADA_FIELD from '@salesforce/schema/Lead.Prima_ultima_Poliza_contratada__c';
import AUMENTO_POTENCIAL_DE_PRIMA_FIELD from '@salesforce/schema/Lead.Aumento_potencial_de_prima__c';
import PRODUCTO_RECOMENDADO_FIELD from '@salesforce/schema/Lead.Producto_recomendado__c';
import CAPITAL_RECOMENDADO_FIELD from '@salesforce/schema/Lead.Capital_recomendado__c';
import COBERTURA_RECOMENDADA_FIELD from '@salesforce/schema/Lead.Cobertura_recomendada__c';
import PRIMA_PRODUCTO_COBERTURA_RECOMENDADA_FIELD from '@salesforce/schema/Lead.Prima_producto_cobertura_recomendada__c';
import SUPUESTOS_1_FIELD from '@salesforce/schema/Lead.Supuestos_1__c';
import SUPUESTOS_2_FIELD from '@salesforce/schema/Lead.Supuestos_2__c';
import SUPUESTOS_3_FIELD from '@salesforce/schema/Lead.Supuestos_3__c';
import DEPOSITO_ESPORADICO_O_CONVENIDO_ULTIMOS_FIELD from '@salesforce/schema/Lead.Deposito_esporadico_o_convenido_ultimos__c';
import PERIODO_1_FIELD from '@salesforce/schema/Lead.Periodo_1__c';
import MONTO_TOTAL_DEPOSITO_ESPORADICO_1_FIELD from '@salesforce/schema/Lead.Monto_total_deposito_esporadico_1__c';
import MONTO_PROMEDIO_DEPOSITO_ESPORADICO_1_FIELD from '@salesforce/schema/Lead.Monto_promedio_deposito_esporadico_1__c';
import PERIODO_2_FIELD from '@salesforce/schema/Lead.Periodo_2__c';
import MONTO_TOTAL_DEPOSITO_ESPORADICO_2_FIELD from '@salesforce/schema/Lead.Monto_total_deposito_esporadico_2__c';
import MONTO_PROMEDIO_DEPOSITO_ESPORADICO_2_FIELD from '@salesforce/schema/Lead.Monto_promedio_deposito_esporadico_2__c';
import PERIODO_3_FIELD from '@salesforce/schema/Lead.Periodo_3__c';
import MONTO_TOTAL_DEPOSITO_ESPORADICO_3_FIELD from '@salesforce/schema/Lead.Monto_total_deposito_esporadico_3__c';
import MONTO_PROMEDIO_DEPOSITO_ESPORADICO_3_FIELD from '@salesforce/schema/Lead.Monto_promedio_deposito_esporadico_3__c';
import INFORMACION_ADICIONAL_1_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_1__c';
import INFORMACION_ADICIONAL_2_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_2__c';
import INFORMACION_ADICIONAL_3_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_3__c';
import INFORMACION_ADICIONAL_4_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_4__c';
import INFORMACION_ADICIONAL_5_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_5__c';
import INFORMACION_ADICIONAL_6_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_6__c';
import INFORMACION_ADICIONAL_7_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_7__c';
import INFORMACION_ADICIONAL_8_FIELD from '@salesforce/schema/Lead.Informacion_Adicional_8__c';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import update_custom_fields from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.update_custom_fields';
import permission_specialfields from '@salesforce/apex/CLS_LEAD_Gestion_ProspectoLinks.permission_specialfields';

const fields = [
                  ID_FIELD,
                  TIPO_MAILING_FIELD,
                  NOMBRE_PRODUCTO_EN_CAMPA_A_FIELD,
                  NUMERO_POLIZA_CAMPAGNA_FIELD,
                  FECHA_INICIO_VIGENCIA_POLIZA_CAMPAGNA_FIELD,
                  PERIODICIDAD_PAGO_POLIZA_CAMPAGNA_FIELD,
                  MEDIO_PAGO_POLIZA_CAMPAGNA_FIELD,
                  CAPITAL_FALLECIMIENTO_POLIZA_CAMPAGNA_FIELD,
                  PRIMA_POLIZA_CAMPAGNA_FIELD,
                  SIMULACION_1_FIELD,
                  SIMULACION_2_FIELD,
                  SIMULACION_3_FIELD,
                  SIMULACION_4_FIELD,
                  SIMULACION_5_FIELD,
                  SIMULACION_6_FIELD,
                  SUPUESTO_SIMULACION_1_FIELD,
                  SUPUESTO_SIMULACION_2_FIELD,
                  SUPUESTO_SIMULACION_3_FIELD,
                  ULTIMO_PRODUCTO_CONTRATADO_FIELD,
                  NUMERO_ULTIMA_POLIZA_CONTRATADA_FIELD,
                  FECHA_INICIO_VIGENCIA_ULTIMA_POLIZA_CONT_FIELD,
                  PERIODICIDAD_PAGO_ULTIMA_POLIZA_CONTR_FIELD,
                  MEDIO_PAGO_ULTIMA_POLIZA_CONTR_FIELD,
                  CAPITAL_FALLECIMIENTO_ULTIMA_POLIZA_CONT_FIELD,
                  PRIMA_ULTIMA_POLIZA_CONTRATADA_FIELD,
                  AUMENTO_POTENCIAL_DE_PRIMA_FIELD,
                  PRODUCTO_RECOMENDADO_FIELD,
                  CAPITAL_RECOMENDADO_FIELD,
                  COBERTURA_RECOMENDADA_FIELD,
                  PRIMA_PRODUCTO_COBERTURA_RECOMENDADA_FIELD,
                  SUPUESTOS_1_FIELD,
                  SUPUESTOS_2_FIELD,
                  SUPUESTOS_3_FIELD,
                  DEPOSITO_ESPORADICO_O_CONVENIDO_ULTIMOS_FIELD,
                  PERIODO_1_FIELD,
                  MONTO_TOTAL_DEPOSITO_ESPORADICO_1_FIELD,
                  MONTO_PROMEDIO_DEPOSITO_ESPORADICO_1_FIELD,
                  PERIODO_2_FIELD,
                  MONTO_TOTAL_DEPOSITO_ESPORADICO_2_FIELD,
                  MONTO_PROMEDIO_DEPOSITO_ESPORADICO_2_FIELD,
                  PERIODO_3_FIELD,
                  MONTO_TOTAL_DEPOSITO_ESPORADICO_3_FIELD,
                  MONTO_PROMEDIO_DEPOSITO_ESPORADICO_3_FIELD,
                  INFORMACION_ADICIONAL_1_FIELD,
                  INFORMACION_ADICIONAL_2_FIELD,
                  INFORMACION_ADICIONAL_3_FIELD,
                  INFORMACION_ADICIONAL_4_FIELD,
                  INFORMACION_ADICIONAL_5_FIELD,
                  INFORMACION_ADICIONAL_6_FIELD,
                  INFORMACION_ADICIONAL_7_FIELD,
                  INFORMACION_ADICIONAL_8_FIELD
                ];

export default class Campos_personalizados_prospecto_links extends LightningElement {

    objectApiName = LEAD_OBJECT;


    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: "$recordId", fields
      })
      lead;

    @track tipo_mailing = '';
    @track nombre_producto_campagna = '';
    @track numero_poliza_campagna = '';
    @track fecha_inicio_vigencia_poliza_campagna = '';
    @track periodicidad_pago_poliza_campagna = '';
    @track medio_pago_poliza_campagna = '';
    @track capital_fallecimiento_poliza_campagna = '';
    @track prima_poliza_campagna = '';
    @track simulacion_1 = '';
    @track simulacion_2 = '';
    @track simulacion_3 = '';
    @track simulacion_4 = '';
    @track simulacion_5 = '';
    @track simulacion_6 = '';
    @track supuesto_simulacion_1 = '';
    @track supuesto_simulacion_2 = '';
    @track supuesto_simulacion_3 = '';
    @track ultimo_producto_contratado = '';
    @track numero_ultima_poliza_contratada = '';
    @track fecha_inicio_vigencia_ultima_poliza_cont = '';
    @track periodicidad_pago_ultima_poliza_contr = '';
    @track medio_pago_ultima_poliza_contr = '';
    @track capital_fallecimiento_ultima_poliza_cont = '';
    @track prima_ultima_poliza_contratada = '';
    @track aumento_potencial_de_prima = '';
    @track producto_recomendado = '';
    @track capital_recomendado = '';
    @track cobertura_recomendada = '';
    @track prima_producto_cobertura_recomendada = '';
    @track supuestos_1 = '';
    @track supuestos_2 = '';
    @track supuestos_3 = '';
    @track deposito_esporadico_o_convenido_ultimos = false;
    @track periodo_1 = '';
    @track monto_total_deposito_esporadico_1 = '';
    @track monto_promedio_deposito_esporadico_1 = '';
    @track periodo_2 = '';
    @track monto_total_deposito_esporadico_2 = '';
    @track monto_promedio_deposito_esporadico_2 = '';
    @track periodo_3 = '';
    @track monto_total_deposito_esporadico_3 = '';
    @track monto_promedio_deposito_esporadico_3 = '';
    @track informacion_adicional_1 = '';
    @track informacion_adicional_2 = '';
    @track informacion_adicional_3 = '';
    @track informacion_adicional_4 = '';
    @track informacion_adicional_5 = '';
    @track informacion_adicional_6 = '';
    @track informacion_adicional_7 = '';
    @track informacion_adicional_8 = '';

    @track modo_view = true;
    @track modo_edit = false;

    @track permisoEdicion = false;

    @track showLoading = false;

    connectedCallback() {

        permission_specialfields().
        then (result => {
            let val = JSON.parse(JSON.stringify(result));
            console.log('@@@@ val'+val);
            this.permisoEdicion = val;
        })
    }

    get isNotNull_Tipo_Mailing(){

        var data = getFieldValue(this.lead.data, TIPO_MAILING_FIELD);

        if(data != null && data != ''){
            this.tipo_mailing = data;
            console.log('@@@@  -->  this.tipo_mailing  --> '+ this.tipo_mailing);
            return true;
        }

        return false;
    }

    get isNotNull_Nombre_producto_en_campa_a(){

        var data = getFieldValue(this.lead.data, NOMBRE_PRODUCTO_EN_CAMPA_A_FIELD);

        this.nombre_producto_campagna = '';
        if(data != null && data != ''){
            this.nombre_producto_campagna = data;
            console.log('@@@@  -->  this.nombre_producto_campagna  --> '+ this.nombre_producto_campagna);
            return true;
        }

        return false;
    }

    get isNotNull_Numero_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, NUMERO_POLIZA_CAMPAGNA_FIELD);

      //  this.numero_poliza_campagna = '';
        if(data != null && data != ''){
            this.numero_poliza_campagna = data;
            return true;
        }

        console.log('@@@@  -->  this.isNotNull_Numero_Poliza_Campagna  --> '+ this.numero_poliza_campagna);

        return false;
    }

    get isNotNull_Fecha_inicio_vigencia_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, FECHA_INICIO_VIGENCIA_POLIZA_CAMPAGNA_FIELD);

        if(data != null && data != ''){
            this.fecha_inicio_vigencia_poliza_campagna = data;
            return true;
        }

        return false;
    }

    get isNotNull_Periodicidad_pago_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, PERIODICIDAD_PAGO_POLIZA_CAMPAGNA_FIELD);

        if(data != null && data != ''){
            this.periodicidad_pago_poliza_campagna = data;
            return true;
        }

        return false;
    }

    get isNotNull_Medio_Pago_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, MEDIO_PAGO_POLIZA_CAMPAGNA_FIELD);

        if(data != null && data != ''){
            this.medio_pago_poliza_campagna = data;
            return true;
        }

        return false;
    }

    get isNotNull_Capital_Fallecimiento_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, CAPITAL_FALLECIMIENTO_POLIZA_CAMPAGNA_FIELD);

        if(data != null && data != ''){
            this.capital_fallecimiento_poliza_campagna = data;
            return true;
        }

        return false;
    }

    get isNotNull_Prima_Poliza_Campagna(){

        var data = getFieldValue(this.lead.data, PRIMA_POLIZA_CAMPAGNA_FIELD);

        if(data != null && data != ''){
            this.prima_poliza_campagna = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_1(){

        var data = getFieldValue(this.lead.data, SIMULACION_1_FIELD);

        if(data != null && data != ''){
            this.simulacion_1 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_2(){

        var data = getFieldValue(this.lead.data, SIMULACION_2_FIELD);

        if(data != null && data != ''){
            this.simulacion_2 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_3(){

        var data = getFieldValue(this.lead.data, SIMULACION_3_FIELD);

        if(data != null && data != ''){
            this.simulacion_3 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_4(){

        var data = getFieldValue(this.lead.data, SIMULACION_4_FIELD);

        if(data != null && data != ''){
            this.simulacion_4 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_5(){

        var data = getFieldValue(this.lead.data, SIMULACION_5_FIELD);

        if(data != null && data != ''){
            this.simulacion_5 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Simulacion_6(){

        var data = getFieldValue(this.lead.data, SIMULACION_6_FIELD);

        if(data != null && data != ''){
            this.simulacion_6 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Supuesto_simulacion_1__c(){

        var data = getFieldValue(this.lead.data, SUPUESTO_SIMULACION_1_FIELD);

        if(data != null && data != ''){
            this.supuesto_simulacion_1 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Supuesto_simulacion_2__c(){

        var data = getFieldValue(this.lead.data, SUPUESTO_SIMULACION_2_FIELD);

        if(data != null && data != ''){
            this.supuesto_simulacion_2 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Supuesto_simulacion_3__c(){

        var data = getFieldValue(this.lead.data, SUPUESTO_SIMULACION_3_FIELD);

        if(data != null && data != ''){
            this.supuesto_simulacion_3 = data;
            return true;
        }

        return false;
    }

    get isNotNull_Ultimo_producto_contratado(){

        var data = getFieldValue(this.lead.data, ULTIMO_PRODUCTO_CONTRATADO_FIELD);

        if(data != null && data != ''){
            this.ultimo_producto_contratado = data;
            return true;
        }

        return false;
    }



    get isNotNull_Numero_ultima_Poliza_contratada(){

      var data = getFieldValue(this.lead.data, NUMERO_ULTIMA_POLIZA_CONTRATADA_FIELD);

      if(data != null && data != ''){
          this.numero_ultima_poliza_contratada = data;
          return true;
      }

      return false;
    }


    get isNotNull_Fecha_inicio_vigencia_ultima_Poliza_cont(){

      var data = getFieldValue(this.lead.data, FECHA_INICIO_VIGENCIA_ULTIMA_POLIZA_CONT_FIELD);

      if(data != null && data != ''){
          this.fecha_inicio_vigencia_ultima_poliza_cont = data;
          return true;
      }

      return false;
    }


    get isNotNull_Periodicidad_pago_ultima_Poliza_contr(){

        var data = getFieldValue(this.lead.data, PERIODICIDAD_PAGO_ULTIMA_POLIZA_CONTR_FIELD);

        if(data != null && data != ''){
            this.periodicidad_pago_ultima_poliza_contr = data;
            return true;
        }

        return false;
    }

    get isNotNull_Medio_Pago_ultima_Poliza_contr(){

        var data = getFieldValue(this.lead.data, MEDIO_PAGO_ULTIMA_POLIZA_CONTR_FIELD);

        if(data != null && data != ''){
            this.medio_pago_ultima_poliza_contr = data;
            return true;
        }

        return false;
    }

    get isNotNull_Capital_fallecimiento_ultima_Poliza_cont(){

      var data = getFieldValue(this.lead.data, CAPITAL_FALLECIMIENTO_ULTIMA_POLIZA_CONT_FIELD);

      if(data != null && data != ''){
          this.capital_fallecimiento_ultima_poliza_cont = data;
          return true;
      }

      return false;
    }

    get isNotNull_Prima_ultima_Poliza_contratada(){

      var data = getFieldValue(this.lead.data, PRIMA_ULTIMA_POLIZA_CONTRATADA_FIELD);

      if(data != null && data != ''){
          this.prima_ultima_poliza_contratada = data;
          return true;
      }

      return false;
    }

    get isNotNull_Aumento_potencial_de_prima(){

      var data = getFieldValue(this.lead.data, AUMENTO_POTENCIAL_DE_PRIMA_FIELD);

      if(data != null && data != ''){
          this.aumento_potencial_de_prima = data;
          return true;
      }

      return false;
    }

    get isNotNull_Producto_recomendado(){

      var data = getFieldValue(this.lead.data, PRODUCTO_RECOMENDADO_FIELD);

      if(data != null && data != ''){
          this.producto_recomendado = data;
          return true;
      }

      return false;
    }

    get isNotNull_Capital_recomendado(){

      var data = getFieldValue(this.lead.data, CAPITAL_RECOMENDADO_FIELD);

      if(data != null && data != ''){
          this.capital_recomendado = data;
          return true;
      }

      return false;
    }

    get isNotNull_Cobertura_recomendada(){

      var data = getFieldValue(this.lead.data, COBERTURA_RECOMENDADA_FIELD);

      if(data != null && data != ''){
          this.cobertura_recomendada = data;
          return true;
      }

      return false;
    }

    get isNotNull_Prima_producto_cobertura_recomendada(){

      var data = getFieldValue(this.lead.data, PRIMA_PRODUCTO_COBERTURA_RECOMENDADA_FIELD);

      if(data != null && data != ''){
          this.prima_producto_cobertura_recomendada = data;
          return true;
      }

      return false;
    }

    get isNotNull_Supuestos_1(){

      var data = getFieldValue(this.lead.data, SUPUESTOS_1_FIELD);

      if(data != null && data != ''){
          this.supuestos_1 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Supuestos_2(){

      var data = getFieldValue(this.lead.data, SUPUESTOS_2_FIELD);

      if(data != null && data != ''){
          this.supuestos_2 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Supuestos_3(){

      var data = getFieldValue(this.lead.data, SUPUESTOS_3_FIELD);

      if(data != null && data != ''){
          this.supuestos_3 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Deposito_esporadico_o_convenido_ultimos(){

      var data = getFieldValue(this.lead.data, DEPOSITO_ESPORADICO_O_CONVENIDO_ULTIMOS_FIELD);

      if(data != null && data != ''){
        this.deposito_esporadico_o_convenido_ultimos = data;
          return true;
      }

      return false;
    }

    get isNotNull_Periodo_1(){

      var data = getFieldValue(this.lead.data, PERIODO_1_FIELD);

      if(data != null && data != ''){
          this.periodo_1 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Monto_total_deposito_esporadico_1(){

      var data = getFieldValue(this.lead.data, MONTO_TOTAL_DEPOSITO_ESPORADICO_1_FIELD);

      if(data != null && data != ''){
          this.monto_total_deposito_esporadico_1 = data;
          return true;
      }

      return false;
    }


    get isNotNull_Monto_promedio_deposito_esporadico_1(){

      var data = getFieldValue(this.lead.data, MONTO_PROMEDIO_DEPOSITO_ESPORADICO_1_FIELD);

      if(data != null && data != ''){
          this.monto_promedio_deposito_esporadico_1 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Periodo_2(){

      var data = getFieldValue(this.lead.data, PERIODO_2_FIELD);

      if(data != null && data != ''){
          this.periodo_2 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Monto_total_deposito_esporadico_2(){

      var data = getFieldValue(this.lead.data, MONTO_TOTAL_DEPOSITO_ESPORADICO_2_FIELD);

      if(data != null && data != ''){
          this.monto_total_deposito_esporadico_2 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Monto_promedio_deposito_esporadico_2(){

      var data = getFieldValue(this.lead.data, MONTO_PROMEDIO_DEPOSITO_ESPORADICO_2_FIELD);

      if(data != null && data != ''){
          this.monto_promedio_deposito_esporadico_2 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Periodo_3(){

      var data = getFieldValue(this.lead.data, PERIODO_3_FIELD);

      if(data != null && data != ''){
          this.periodo_3 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Monto_total_deposito_esporadico_3(){

      var data = getFieldValue(this.lead.data, MONTO_TOTAL_DEPOSITO_ESPORADICO_3_FIELD);

      if(data != null && data != ''){
          this.monto_total_deposito_esporadico_3 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Monto_promedio_deposito_esporadico_3(){

      var data = getFieldValue(this.lead.data, MONTO_PROMEDIO_DEPOSITO_ESPORADICO_3_FIELD);

      if(data != null && data != ''){
          this.monto_promedio_deposito_esporadico_3 = data;
          return true;
      }

      return false;
    }


    get isNotNull_Informacion_Adicional_1(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_1_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_1 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_2(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_2_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_2 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_3(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_3_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_3 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_4(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_4_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_4 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_5(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_5_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_5 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_6(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_6_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_6 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_7(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_7_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_7 = data;
          return true;
      }

      return false;
    }

    get isNotNull_Informacion_Adicional_8(){

      var data = getFieldValue(this.lead.data, INFORMACION_ADICIONAL_8_FIELD);

      if(data != null && data != ''){
          this.informacion_adicional_8 = data;
          return true;
      }

      return false;
    }

    event_tipo_mailing(event){
        this.tipo_mailing = event.target.value;
        console.log('@@@@  this.tipo_mailing  -->  '+ this.tipo_mailing);
    }

    event_nombre_producto_campagna(event){
        this.nombre_producto_campagna = event.target.value;
        console.log('@@@@  this.nombre_producto_campagna  -->  '+ this.nombre_producto_campagna);
    }

    event_numero_poliza_campagna(event){
        this.numero_poliza_campagna = event.target.value;
        console.log('@@@@  this.numero_poliza_campagna  -->  '+ this.numero_poliza_campagna);
    }

    event_fecha_inicio_vigencia_poliza_campagna(event){
        this.fecha_inicio_vigencia_poliza_campagna = event.target.value;
        console.log('@@@@  this.fecha_inicio_vigencia_poliza_campagna  -->  '+ this.fecha_inicio_vigencia_poliza_campagna);
    }

    event_periodicidad_pago_poliza_campagna(event){
        this.periodicidad_pago_poliza_campagna = event.target.value;
        console.log('@@@@  this.periodicidad_pago_poliza_campagna  -->  '+ this.periodicidad_pago_poliza_campagna);
    }

    event_medio_pago_poliza_campagna(event){
        this.medio_pago_poliza_campagna = event.target.value;
        console.log('@@@@  this.medio_pago_poliza_campagna  -->  '+ this.medio_pago_poliza_campagna);
    }

    event_capital_fallecimiento_poliza_campagna(event){
        this.capital_fallecimiento_poliza_campagna = event.target.value;
        console.log('@@@@  this.capital_fallecimiento_poliza_campagna  -->  '+ this.capital_fallecimiento_poliza_campagna);
    }

    event_prima_poliza_campagna(event){
        this.prima_poliza_campagna = event.target.value;
        console.log('@@@@  this.prima_poliza_campagna  -->  '+ this.prima_poliza_campagna);
    }

    event_simulacion_1(event){
        this.simulacion_1 = event.target.value;
        console.log('@@@@  this.simulacion_1  -->  '+ this.simulacion_1);
    }

    event_simulacion_2(event){
        this.simulacion_2 = event.target.value;
        console.log('@@@@  this.simulacion_1  -->  '+ this.simulacion_1);
    }

    event_simulacion_3(event){
        this.simulacion_3 = event.target.value;
        console.log('@@@@  this.simulacion_3  -->  '+ this.simulacion_3);
    }

    event_simulacion_4(event){
        this.simulacion_4 = event.target.value;
        console.log('@@@@  this.simulacion_4  -->  '+ this.simulacion_4);
    }

    event_simulacion_5(event){
        this.simulacion_5 = event.target.value;
        console.log('@@@@  this.simulacion_5  -->  '+ this.simulacion_5);
    }

    event_simulacion_6(event){
        this.simulacion_6 = event.target.value;
        console.log('@@@@  this.simulacion_6  -->  '+ this.simulacion_6);
    }

    event_supuesto_simulacion_1(event){
        this.supuesto_simulacion_1 = event.target.value;
        console.log('@@@@  this.supuesto_simulacion_1  -->  '+ this.supuesto_simulacion_1);
    }

    event_supuesto_simulacion_2(event){
        this.supuesto_simulacion_2 = event.target.value;
        console.log('@@@@  this.supuesto_simulacion_2  -->  '+ this.supuesto_simulacion_2);
    }

    event_supuesto_simulacion_3(event){
        this.supuesto_simulacion_3 = event.target.value;
        console.log('@@@@  this.supuesto_simulacion_3  -->  '+ this.supuesto_simulacion_3);
    }

    event_ultimo_producto_contratado(event){
        this.ultimo_producto_contratado = event.target.value;
        console.log('@@@@  this.ultimo_producto_contratado  -->  '+ this.ultimo_producto_contratado);
    }

    event_numero_ultima_poliza_contratada(event){
        this.numero_ultima_poliza_contratada = event.target.value;
        console.log('@@@@  this.numero_ultima_poliza_contratada  -->  '+ this.numero_ultima_poliza_contratada);
    }

    event_fecha_inicio_vigencia_ultima_poliza_cont(event){
        this.fecha_inicio_vigencia_ultima_poliza_cont = event.target.value;
        console.log('@@@@  this.fecha_inicio_vigencia_ultima_poliza_cont  -->  '+ this.fecha_inicio_vigencia_ultima_poliza_cont);
    }

    event_periodicidad_pago_ultima_poliza_contr(event){
        this.periodicidad_pago_ultima_poliza_contr = event.target.value;
        console.log('@@@@  this.periodicidad_pago_ultima_poliza_contr  -->  '+ this.periodicidad_pago_ultima_poliza_contr);
    }

    event_medio_pago_ultima_poliza_contr(event){
        this.medio_pago_ultima_poliza_contr = event.target.value;
        console.log('@@@@  this.medio_pago_ultima_poliza_contr  -->  '+ this.medio_pago_ultima_poliza_contr);
    }

    event_capital_fallecimiento_ultima_poliza_cont(event){
        this.capital_fallecimiento_ultima_poliza_cont = event.target.value;
        console.log('@@@@  this.capital_fallecimiento_ultima_poliza_cont  -->  '+ this.capital_fallecimiento_ultima_poliza_cont);
    }

    event_prima_ultima_poliza_contratada(event){
        this.prima_ultima_poliza_contratada = event.target.value;
        console.log('@@@@  this.prima_ultima_poliza_contratada  -->  '+ this.prima_ultima_poliza_contratada);
    }

    event_aumento_potencial_de_prima(event){
        this.aumento_potencial_de_prima = event.target.value;
        console.log('@@@@  this.aumento_potencial_de_prima  -->  '+ this.aumento_potencial_de_prima);
    }

    event_producto_recomendado(event){
        this.producto_recomendado = event.target.value;
        console.log('@@@@  this.producto_recomendado  -->  '+ this.producto_recomendado);
    }

    event_capital_recomendado(event){
        this.capital_recomendado = event.target.value;
        console.log('@@@@  this.capital_recomendado  -->  '+ this.capital_recomendado);
    }

    event_cobertura_recomendada(event){
        this.cobertura_recomendada = event.target.value;
        console.log('@@@@  this.cobertura_recomendada  -->  '+ this.cobertura_recomendada);
    }

    event_prima_producto_cobertura_recomendada(event){
        this.prima_producto_cobertura_recomendada = event.target.value;
        console.log('@@@@  this.prima_producto_cobertura_recomendada  -->  '+ this.prima_producto_cobertura_recomendada);
    }

    event_supuestos_1(event){
        this.supuestos_1 = event.target.value;
        console.log('@@@@  this.supuestos_1  -->  '+ this.supuestos_1);
    }

    event_supuestos_2(event){
        this.supuestos_2 = event.target.value;
        console.log('@@@@  this.supuestos_2  -->  '+ this.supuestos_2);
    }

    event_supuestos_3(event){
        this.supuestos_3 = event.target.value;
        console.log('@@@@  this.supuestos_3  -->  '+ this.supuestos_3);
    }

    event_deposito_esporadico_o_convenido_ultimos(event){
        this.deposito_esporadico_o_convenido_ultimos = event.target.value;
        console.log('@@@@  this.deposito_esporadico_o_convenido_ultimos  -->  '+ this.deposito_esporadico_o_convenido_ultimos);
    }

    event_periodo_1(event){
        this.periodo_1 = event.target.value;
        console.log('@@@@  this.periodo_1  -->  '+ this.periodo_1);
    }

    event_monto_total_deposito_esporadico_1(event){
        this.monto_total_deposito_esporadico_1 = event.target.value;
        console.log('@@@@  this.monto_total_deposito_esporadico_1  -->  '+ this.monto_total_deposito_esporadico_1);
    }

    event_monto_promedio_deposito_esporadico_1(event){
        this.monto_promedio_deposito_esporadico_1 = event.target.value;
        console.log('@@@@  this.monto_promedio_deposito_esporadico_1  -->  '+ this.monto_promedio_deposito_esporadico_1);
    }

    event_periodo_2(event){
        this.periodo_2 = event.target.value;
        console.log('@@@@  this.periodo_2  -->  '+ this.periodo_2);
    }

    event_monto_total_deposito_esporadico_2(event){
        this.monto_total_deposito_esporadico_2 = event.target.value;
        console.log('@@@@  this.monto_total_deposito_esporadico_2  -->  '+ this.monto_total_deposito_esporadico_2);
    }

    event_monto_promedio_deposito_esporadico_2(event){
        this.monto_promedio_deposito_esporadico_2 = event.target.value;
        console.log('@@@@  this.monto_promedio_deposito_esporadico_2  -->  '+ this.monto_promedio_deposito_esporadico_2);
    }

    event_periodo_3(event){
        this.periodo_3 = event.target.value;
        console.log('@@@@  this.periodo_3  -->  '+ this.periodo_3);
    }

    event_monto_total_deposito_esporadico_3(event){
        this.monto_total_deposito_esporadico_3 = event.target.value;
        console.log('@@@@  this.monto_total_deposito_esporadico_3  -->  '+ this.monto_total_deposito_esporadico_3);
    }

    event_monto_promedio_deposito_esporadico_3(event){
        this.monto_promedio_deposito_esporadico_3 = event.target.value;
        console.log('@@@@  this.monto_promedio_deposito_esporadico_3  -->  '+ this.monto_promedio_deposito_esporadico_3);
    }

    event_informacion_adicional_1(event){
        this.informacion_adicional_1 = event.target.value;
        console.log('@@@@  this.informacion_adicional_1  -->  '+ this.informacion_adicional_1);
    }

    event_informacion_adicional_2(event){
        this.informacion_adicional_2 = event.target.value;
        console.log('@@@@  this.informacion_adicional_2  -->  '+ this.informacion_adicional_2);
    }

    event_informacion_adicional_3(event){
        this.informacion_adicional_3 = event.target.value;
        console.log('@@@@  this.informacion_adicional_3  -->  '+ this.informacion_adicional_3);
    }

    event_informacion_adicional_4(event){
        this.informacion_adicional_4 = event.target.value;
        console.log('@@@@  this.informacion_adicional_4  -->  '+ this.informacion_adicional_4);
    }

    event_informacion_adicional_5(event){
        this.informacion_adicional_5 = event.target.value;
        console.log('@@@@  this.informacion_adicional_5  -->  '+ this.informacion_adicional_5);
    }

    event_informacion_adicional_6(event){
        this.informacion_adicional_6 = event.target.value;
        console.log('@@@@  this.informacion_adicional_6  -->  '+ this.informacion_adicional_6);
    }

    event_informacion_adicional_7(event){
        this.informacion_adicional_7 = event.target.value;
        console.log('@@@@  this.informacion_adicional_7  -->  '+ this.informacion_adicional_7);
    }

    event_informacion_adicional_8(event){
        this.informacion_adicional_8 = event.target.value;
        console.log('@@@@  this.informacion_adicional_8  -->  '+ this.informacion_adicional_8);
    }

    to_modo_edit()
    {
        this.modo_view = false;
        this.modo_edit = true;
    }

    to_modo_view()
    {
        this.modo_view = true;
        this.modo_edit = false;
    }


    @track parameters = [];

    save_changes()
    {
        this.showLoading = true;
        this.parameters.push({key:"f_tipo_mailing",value: this.tipo_mailing});
        this.parameters.push({key:"f_nombre_producto_campagna",value: this.nombre_producto_campagna});
        this.parameters.push({key:"f_numero_poliza_campagna",value: this.numero_poliza_campagna});
        this.parameters.push({key:"f_fecha_inicio_vigencia_poliza_campagna",value: this.fecha_inicio_vigencia_poliza_campagna});
        this.parameters.push({key:"f_periodicidad_pago_poliza_campagna",value: this.periodicidad_pago_poliza_campagna});
        this.parameters.push({key:"f_medio_pago_poliza_campagna",value: this.medio_pago_poliza_campagna});
        this.parameters.push({key:"f_capital_fallecimiento_poliza_campagna",value: this.capital_fallecimiento_poliza_campagna});
        this.parameters.push({key:"f_prima_poliza_campagna",value: this.prima_poliza_campagna});
        this.parameters.push({key:"f_simulacion_1",value: this.simulacion_1});
        this.parameters.push({key:"f_simulacion_2",value: this.simulacion_2});
        this.parameters.push({key:"f_simulacion_3",value: this.simulacion_3});
        this.parameters.push({key:"f_simulacion_4",value: this.simulacion_4});
        this.parameters.push({key:"f_simulacion_5",value: this.simulacion_5});
        this.parameters.push({key:"f_simulacion_6",value: this.simulacion_6});
        this.parameters.push({key:"f_supuesto_simulacion_1",value: this.supuesto_simulacion_1});
        this.parameters.push({key:"f_supuesto_simulacion_2",value: this.supuesto_simulacion_2});
        this.parameters.push({key:"f_supuesto_simulacion_3",value: this.supuesto_simulacion_3});
        this.parameters.push({key:"f_ultimo_producto_contratado",value: this.ultimo_producto_contratado});
        this.parameters.push({key:"f_numero_ultima_poliza_contratada",value: this.numero_ultima_poliza_contratada});
        this.parameters.push({key:"f_fecha_inicio_vigencia_ultima_poliza_cont",value: this.fecha_inicio_vigencia_ultima_poliza_cont});
        this.parameters.push({key:"f_periodicidad_pago_ultima_poliza_contr",value: this.periodicidad_pago_ultima_poliza_contr});
        this.parameters.push({key:"f_medio_pago_ultima_poliza_contr",value: this.medio_pago_ultima_poliza_contr});
        this.parameters.push({key:"f_capital_fallecimiento_ultima_poliza_cont",value: this.capital_fallecimiento_ultima_poliza_cont});
        this.parameters.push({key:"f_prima_ultima_poliza_contratada",value: this.prima_ultima_poliza_contratada});
        this.parameters.push({key:"f_aumento_potencial_de_prima",value: this.aumento_potencial_de_prima});
        this.parameters.push({key:"f_producto_recomendado",value: this.producto_recomendado});
        this.parameters.push({key:"f_capital_recomendado",value: this.capital_recomendado});
        this.parameters.push({key:"f_cobertura_recomendada",value: this.cobertura_recomendada});
        this.parameters.push({key:"f_prima_producto_cobertura_recomendada",value: this.prima_producto_cobertura_recomendada});
        this.parameters.push({key:"f_supuestos_1",value: this.supuestos_1});
        this.parameters.push({key:"f_supuestos_2",value: this.supuestos_2});
        this.parameters.push({key:"f_supuestos_3",value: this.supuestos_3});
        this.parameters.push({key:"f_deposito_esporadico_o_convenido_ultimos",value: this.deposito_esporadico_o_convenido_ultimos});
        this.parameters.push({key:"f_periodo_1",value: this.periodo_1});
        this.parameters.push({key:"f_monto_total_deposito_esporadico_1",value: this.monto_total_deposito_esporadico_1});
        this.parameters.push({key:"f_monto_promedio_deposito_esporadico_1",value: this.monto_promedio_deposito_esporadico_1});
        this.parameters.push({key:"f_periodo_2",value: this.periodo_2});
        this.parameters.push({key:"f_monto_total_deposito_esporadico_2",value: this.monto_total_deposito_esporadico_2});
        this.parameters.push({key:"f_monto_promedio_deposito_esporadico_2",value: this.monto_promedio_deposito_esporadico_2});
        this.parameters.push({key:"f_periodo_3",value: this.periodo_3});
        this.parameters.push({key:"f_monto_total_deposito_esporadico_3",value: this.monto_total_deposito_esporadico_3});
        this.parameters.push({key:"f_monto_promedio_deposito_esporadico_3",value: this.monto_promedio_deposito_esporadico_3});
        this.parameters.push({key:"f_informacion_adicional_1",value: this.informacion_adicional_1});
        this.parameters.push({key:"f_informacion_adicional_2",value: this.informacion_adicional_2});
        this.parameters.push({key:"f_informacion_adicional_3",value: this.informacion_adicional_3});
        this.parameters.push({key:"f_informacion_adicional_4",value: this.informacion_adicional_4});
        this.parameters.push({key:"f_informacion_adicional_5",value: this.informacion_adicional_5});
        this.parameters.push({key:"f_informacion_adicional_6",value: this.informacion_adicional_6});
        this.parameters.push({key:"f_informacion_adicional_7",value: this.informacion_adicional_7});
        this.parameters.push({key:"f_informacion_adicional_8",value: this.informacion_adicional_8});

        // var ID = getFieldValue(this.lead.data, ID_FIELD);

        var tparam = JSON.stringify(this.parameters);
        console.log('myMap  ' + this.parameters) ;
        update_custom_fields({Id : this.recordId, parameters : tparam}).then(r => {
            if(r != false){

                const evt = new ShowToastEvent({
                    title: 'Actualizar Campos personalizados Prospecto',
                    message: 'Los campos personalizados del Prospecto han sido exitosamente actualizados.',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                // refreshApex(this.lead);
                // this.showLoading = false;
                // this.modo_view = true;
                // this.modo_edit = false;

                setTimeout(function () {
                    this.showLoading = false;
                   window.location.reload();
                 }, 1000);  // After 1 sec
            }
            else{

                const evt = new ShowToastEvent({
                    title: 'Actualizar Campos personalizados Prospecto',
                    message: 'Los campos personalizados del Prospecto NO han sido exitosamente actualizados.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
                // refreshApex(this.lead);
                // this.showLoading = false;
                // this.modo_view = true;
                // this.modo_edit = false;
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
                    message: 'ERROR',//+ JSON.stringify(error),
                    variant: 'error',
                });
                this.dispatchEvent(evt);
                // refreshApex(this.lead);
                // this.showLoading = false;
                // this.modo_view = true;
                // this.modo_edit = false;
                setTimeout(function () {
                    this.showLoading = false;
                   window.location.reload();
                 }, 1000);  // After 1 sec
        });


//        this.modo_view = true;
  //      this.modo_edit = false;
    }



}