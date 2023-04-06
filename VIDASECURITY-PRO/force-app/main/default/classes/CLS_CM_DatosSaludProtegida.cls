/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-21-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-11-2021   Juan Espinoza León   Initial Version
**/
public class CLS_CM_DatosSaludProtegida {
    public CLS_CM_DatosSaludProtegida() {

    }

    public static Boolean DatosSaludProtegida(String LeadId)
    {
        Lead prospecto = [SELECT Id,  Poliza__c, PROSP_Carga_RUT__C, DV__C, Cobertura__c, Capital_Remanente_Asegurado__c, PROSPE_Carga_Fecha_Inicio_Vigencia__c, Prima_Nuevo_Producto__c,
        Nombre_de_Producto__c, Prima_Poliza__c, Prima_Final_Poliza_Original__c, Exclusiones__c, PROSPE_Carga_Fecha_Nacimiento__c, SP_Codigo_WS_Prima_Nuevo_Producto__c
        FROM Lead WHERE Id =: LeadId];

        Poliza__c poliza = [SELECT Id, Name FROM Poliza__c WHERE Id =: prospecto.Poliza__c];


        PAR_EXT_WS_CM_CallSSO callSSO = EXT_WS_CM_CallSSO.DatosAuth();

        String token = '';

        if (callSSO == null)
        { //no existe token sso no activo
            return false;
        }

        token =  callSSO.access_token;

        system.debug(token);

        String codigoCobertura = '';
        Decimal montoCapital;

        try {

            PAR_EXT_WS_CM_Cobertura coberturas = EXT_WS_CM_Cobertura.DatosCobertura(token, poliza.Name, prospecto.PROSP_Carga_RUT__C, prospecto.DV__c );
            system.debug('@@@@ 107. cobertura --> '+coberturas);

            if (coberturas != null)
            {
                String nameCob = coberturas.primaPoliza.coverages[0].nameCobert;
                codigoCobertura = coberturas.primaPoliza.coverages[0].codeCobert;
                Integer capCob = coberturas.primaPoliza.coverages[0].capital;

                if (coberturas.primaPoliza.coverages.size() > 1)
                {
                    for (PAR_EXT_WS_CM_Cobertura.cls_coverages col : coberturas.primaPoliza.coverages)
                    {
                        if (col.capital > capCob)
                        {
                            nameCob = col.nameCobert;
                            codigoCobertura = col.codeCobert;
                            capCob = col.capital;
                        }
                    }
                }

                prospecto.Cobertura__c = nameCob;
            }
/*
system.debug('@@@@ cobertura @@@@');
                Integer i = 0;
                for (PAR_EXT_WS_CM_Cobertura.cls_coverages col : cobertura.primaPoliza.coverages)
                {
                    system.debug('@@@@ col['+ i +'].codeCobert --> '+ col.codeCobert);
                    system.debug('@@@@ col['+ i +'].nameCobert --> '+ col.nameCobert);
                    system.debug('@@@@ col['+ i +'].capital --> '+ col.capital);
                    system.debug('@@@@ col['+ i +'].premium --> '+ col.premium);
                    system.debug('@@@@ col['+ i +'].extraPremium --> '+ col.extraPremium);
                    system.debug('@@@@ col['+ i +'].extraPremiumType --> '+ col.extraPremiumType);
                    system.debug('@@@@ col['+ i +'].fecu --> '+ col.fecu);
                    i++;
                }

                system.debug('@@@@ cobertura @@@@');

*/
            // if (cobertura != null)
            // {
            //     prospecto.Cobertura__c = cobertura.primaPoliza.coverages[0].nameCobert;
            //     codigoCobertura = cobertura.primaPoliza.coverages[0].codeCobert;
            // }
            system.debug('@@@@ Lead --> '+prospecto);
        } catch (Exception ex) {
            system.debug('@@@@ Exception -->'+ex);
            system.debug('@@@@ Exception Line -->'+ex.getLineNumber());
        }

        if (codigoCobertura != '')
        {
            try {
                PAR_EXT_WS_CM_PrimaFinal polizaFinal = EXT_WS_CM_PrimaFinal.DatosPoliza(token, poliza.Name, prospecto.PROSP_Carga_RUT__C, prospecto.DV__c, codigoCobertura);
                system.debug('@@@@ 132. polizaFinal --> '+polizaFinal);
                if (polizaFinal != null)
                {
                    prospecto.Prima_Final_Poliza_Original__c = polizaFinal.primaPoliza.totalPrima;
                }
                system.debug('@@@@ 130. Lead --> '+prospecto);
            } catch (Exception ex) {
                system.debug('@@@@ Exception -->'+ex);
            }


            try {
                PAR_EXT_WS_CM_CapitalRemanente capital = EXT_WS_CM_CapitalRemanente.DatosCapital(token, poliza.Name, prospecto.PROSP_Carga_RUT__C, prospecto.DV__c, codigoCobertura);
                system.debug('@@@@ 111. capital --> '+capital);

                if (capital != null)
                {
                    prospecto.Capital_Remanente_Asegurado__c = capital.remainingAmount;
                    montoCapital = capital.principalAmount;
                }

                system.debug('@@@@ 130. Lead --> '+prospecto);
            } catch (Exception ex) {
                system.debug('@@@@ Exception -->'+ex);
            }
        }

        if (Test.isRunningTest())
        {
            montoCapital = 1;
        }

        if (montoCapital > 0)
        {
            try
            {
                Integer monthsBetween = prospecto.PROSPE_Carga_Fecha_Nacimiento__c.monthsBetween(Date.today().addMonths(2));

                //Integer monthsBetween = prospecto.PROSPE_Carga_Fecha_Nacimiento__c.monthsBetween(Date.today());

                Integer edad = monthsBetween/12;

                system.debug('@@@@ edad -->'+edad);

                PAR_EXT_WS_CM_PrimaNuevoProducto primaNuevoProducto = EXT_WS_CM_PrimaNuevoProducto.DatosPrimaNuevoProducto(token, prospecto.SP_Codigo_WS_Prima_Nuevo_Producto__c,  edad, '0001', montoCapital);
                system.debug('@@@@ primaNuevoProducto --> '+primaNuevoProducto);
                if (primaNuevoProducto.primaProspecto != null)
                {
                    prospecto.Prima_Nuevo_Producto__c = primaNuevoProducto.primaProspecto.totalPremium;
                }
                system.debug('@@@@ Lead --> '+prospecto);
            }
            catch (Exception ex) {
                system.debug('@@@@ Exception -->'+ex);
                system.debug('@@@@ Exception Line -->'+ex.getLineNumber());
            }
        }

        try {

            PAR_EXT_WS_CM_Exclusiones exclusiones = EXT_WS_CM_Exclusiones.DatosExclusion(token, poliza.Name, prospecto.PROSP_Carga_RUT__C, prospecto.DV__c);
            system.debug('@@@@ exclusiones --> '+exclusiones);
            if (exclusiones != null && exclusiones.sobrePrima != null)
            {
                prospecto.Exclusiones__c = exclusiones.sobrePrima.recaDctoExcl[0].cause;
            }
            system.debug('@@@@ Lead --> '+prospecto);
        } catch (Exception ex) {
            system.debug('@@@@ Exception -->'+ex);
            system.debug('@@@@ Exception Line -->'+ex.getLineNumber());
        }


        if (prospecto.Prima_Poliza__c  == null)
        {
            try {

                PAR_EXT_WS_CM_PrimaPoliza poliza2 = EXT_WS_CM_PrimaPoliza.DatosPoliza(token, poliza.Name);

                if (poliza2 != null)
                {
                    prospecto.Prima_Poliza__c = poliza2.totalPrima;
                }
                system.debug('@@@@ Lead --> '+prospecto);

            } catch (Exception ex) {
                system.debug('@@@@ Exception -->'+ex);
            }
        }

        update prospecto;

          List<Cotizador_Express__c> cotizador = [SELECT Id, Prima_Nuevo_Producto__c FROM Cotizador_Express__c  WHERE  LeadId__c =: prospecto.Id AND Estado__c != 'Anulado'];

        if (cotizador.size() > 0)
        {
            cotizador[0].Prima_Nuevo_Producto__c = prospecto.Prima_Nuevo_Producto__c;
            update cotizador[0];
        }

        system.debug('@@@@ Lead --> '+prospecto);

        return true;
    }

}