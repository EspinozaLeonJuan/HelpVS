/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-08-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   03-01-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CM_Predigitador {
    public CTR_CM_Predigitador() {

    }

    public OBJ_CM_Predigitador PD_Digitador {get;  set;}

    public String Errores {get; set;}

    public Boolean ExisteError {get; set;}

    public Pagereference cargaDatosPreDigitador()
    {
        try
        {
            String Id = apexpages.currentpage().getparameters().get('CotizacionId');
            String SaludProtegida = apexpages.currentpage().getparameters().get('SaludProtegida');

            system.debug('@@@@ CotizadorId--> '+ Id);

            String rutUsuario, poliza = '',  totalUF = '', regValores = 'd';

            if(!Test.isRunningTest())
            {
                rutUsuario = [SELECT RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c;
            }
            else
            {
                rutUsuario = '12345123-2';
            }
            system.debug('@@@@ rut usuario --> '+rutUsuario);
            system.debug('@@@@ cotizacion Id --> '+Id);
            Cotizador_Express__c cotizacion = [SELECT Id, CampaignId__c, RUT_Contratante__c, Direccion__c,  Tipo_Folio__c, Poliza_Mandatoria__c, Email__c, Telefono__c, Celular__c,
                                                Codigo_Region__c, Estado__c, Codigo_Ciudad__c, Codigo_Comuna__c, Tipo_Cliente__c, TipoCotizacion__c, Prima_Nuevo_Producto__c,
                                                RUT_Asegurado__c, Nombres_Asegurado__c, Apellidos_Asegurado__c, Tipo_Campagna__c, Telefono_Contratante__c, Telefono_Asegurado__c, Email_Asegurado__c,
                                                RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Contrata__c, Email_Contratante_2__c, Plan__c,
                                                Direccion_Contratante__c, Comuna_Contratante__c, Ciudad_Contratante__c, Region_Contratante__c, Codigo_Comuna_Contratante__c,
                                                Codigo_Ciudad_Contratante__c, Codigo_Region_Contratante__c, Direccion_Tercero__c, Ciudad_Tercero__c, Comuna_Tercero__c, Region_Tercero__c, WS_Valor_UF__c,
                                                Codigo_Ciudad_Tercero__c, Codigo_Comuna_Tercero__c, Codigo_Region_Tercero__c
                                                FROM Cotizador_Express__c  WHERE  Id =: Id];

            system.debug('@@@@ cotizacion --> '+cotizacion);

            this.ExisteError = false;
            this.Errores = '';
            //if (rutUsuario)
            try {
                String testRUT = rutUsuario.split('-')[0];
                String testDV = rutUsuario.split('-')[1];
            }
            catch (Exception ex) {
                Errores = Errores + 'RUT de Usuario nulo o incorrecto.';
            }

            if (String.isNotBlank(cotizacion.Poliza_Mandatoria__c))
            {
                poliza = cotizacion.Poliza_Mandatoria__c;
            }

            if (cotizacion.Tipo_Campagna__c == 'Salud Protegida' )
            {
                if(cotizacion.Prima_Nuevo_Producto__c != null)
                {
                    totalUF = String.valueOf(cotizacion.Prima_Nuevo_Producto__c).replace('.', regValores);
                }
                else {
                    totalUF = '0';
                    Errores = Errores + 'Valor Prima nuevo Producto nulo.';
                }

                if (cotizacion.Contrata__c == 'T')
                {
                    try {
                        String testRUT = cotizacion.RUT_Tercero__c.split('-')[0];
                        String testDV = cotizacion.RUT_Tercero__c.split('-')[1];
                    }
                    catch (Exception ex) {
                        Errores = Errores + 'RUT Tercero nulo o incorrecto.';
                    }
                }
            }
            else if (cotizacion.Tipo_Campagna__c == 'Televenta - APEG')
            {
                totalUF =  String.valueOf(cotizacion.WS_Valor_UF__c).replace('.', regValores);
            }
            else if(cotizacion.Tipo_Campagna__c == 'Televenta - Oncológico'){

                Decimal total = Decimal.valueOf(cotizacion.WS_Valor_UF__c);
                system.debug('@@@@ l99 TOTAL UF => ' + cotizacion.WS_Valor_UF__c);
                List<Cotizador_Express__c> asegurados = [SELECT Id, ParentId__c, WS_Valor_UF__c FROM Cotizador_Express__c WHERE ParentId__c =: cotizacion.Id];

                for (Cotizador_Express__c ase : asegurados)
                {
                    total = total + Decimal.valueOf(ase.WS_Valor_UF__c);
                }

                totalUF =  String.valueOf(total).replace('.', regValores);
            }

            system.debug('@@@@ VALOR TOTAL UF => ' + totalUF);

            this.PD_Digitador = new OBJ_CM_Predigitador();

            if(String.isBlank(Errores))
            {
                String persistencia = String.valueOf(CLS_CM_CotizadorExpress_Consume.obtienePersistencia());
                if (cotizacion.Tipo_Campagna__c == 'Televenta - APEG' || cotizacion.Tipo_Campagna__c == 'Televenta - Oncológico')
                {
                    this.PD_Digitador = new OBJ_CM_Predigitador(persistencia, rutUsuario.split('-')[0], rutUsuario.split('-')[1], cotizacion.RUT_Contratante__c.split('-')[0], cotizacion.CampaignId__c,
                    cotizacion.Tipo_Folio__c, cotizacion.Poliza_Mandatoria__c, totalUF, cotizacion.Direccion__c, cotizacion.Email__c,
                    cotizacion.Telefono__c, cotizacion.Celular__c, cotizacion.Codigo_Comuna__c, cotizacion.Codigo_Region__c, cotizacion.Codigo_Ciudad__c, cotizacion.Tipo_Cliente__c);
                }
                else if (cotizacion.Tipo_Campagna__c == 'Salud Protegida')
                {
                    if (cotizacion.Contrata__c == 'C')
                    {
                        this.PD_Digitador = new OBJ_CM_Predigitador(persistencia, rutUsuario.split('-')[0], rutUsuario.split('-')[1], cotizacion.RUT_Contratante__c.split('-')[0], cotizacion.CampaignId__c,
                            cotizacion.Tipo_Folio__c, cotizacion.Poliza_Mandatoria__c, totalUF, cotizacion.Direccion_Contratante__c, cotizacion.Email_Contratante_2__c,
                            cotizacion.Telefono_Contratante__c, cotizacion.Telefono_Contratante__c, cotizacion.Codigo_Comuna_Contratante__c, cotizacion.Codigo_Region_Contratante__c, cotizacion.Codigo_Ciudad_Contratante__c, cotizacion.Tipo_Cliente__c,
                            cotizacion.RUT_Asegurado__c.split('-')[0], cotizacion.Plan__c, cotizacion.Direccion__c, cotizacion.Email_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Codigo_Comuna__c,
                            cotizacion.Codigo_Ciudad__c, cotizacion.Codigo_Region__c);
                    }
                    else if (cotizacion.Contrata__c == 'T')
                    {
                        this.PD_Digitador = new OBJ_CM_Predigitador(persistencia, rutUsuario.split('-')[0], rutUsuario.split('-')[1], cotizacion.RUT_Tercero__c.split('-')[0], cotizacion.CampaignId__c,
                            cotizacion.Tipo_Folio__c, cotizacion.Poliza_Mandatoria__c, totalUF, cotizacion.Direccion_Tercero__c, cotizacion.Correo_Electronico_Tercero__c,
                            cotizacion.Telefono_Tercero__c, cotizacion.Telefono_Tercero__c, cotizacion.Codigo_Comuna_Tercero__c, cotizacion.Codigo_Region_Tercero__c, cotizacion.Codigo_Ciudad_Tercero__c, cotizacion.Tipo_Cliente__c,
                            cotizacion.RUT_Asegurado__c.split('-')[0], cotizacion.Plan__c, cotizacion.Direccion__c, cotizacion.Email_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Codigo_Comuna__c,
                            cotizacion.Codigo_Ciudad__c, cotizacion.Codigo_Region__c);
                    }
                    else if (cotizacion.Contrata__c == 'A')
                    {
                        this.PD_Digitador = new OBJ_CM_Predigitador(persistencia, rutUsuario.split('-')[0], rutUsuario.split('-')[1], cotizacion.RUT_Asegurado__c.split('-')[0], cotizacion.CampaignId__c,
                            cotizacion.Tipo_Folio__c, cotizacion.Poliza_Mandatoria__c, totalUF, cotizacion.Direccion__c, cotizacion.Email_Asegurado__c,
                            cotizacion.Telefono_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Codigo_Comuna__c, cotizacion.Codigo_Region__c, cotizacion.Codigo_Ciudad__c, cotizacion.Tipo_Cliente__c,
                            cotizacion.RUT_Asegurado__c.split('-')[0], cotizacion.Plan__c, cotizacion.Direccion__c, cotizacion.Email_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Telefono_Asegurado__c, cotizacion.Codigo_Comuna__c,
                            cotizacion.Codigo_Ciudad__c, cotizacion.Codigo_Region__c);
                    }
                }

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ INFORMACION => xxx ' + PD_Digitador.idCanal + ' - ' + PD_Digitador.persistencia));

                if (cotizacion.Estado__c != 'Procesado')
                {
                    cotizacion.Estado__c = 'Procesado';
                    update cotizacion;
                }
            }
            else {
                this.ExisteError = true;
            }

            system.debug('@@@@ PD_Digitador => ' + PD_Digitador);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ EXCEPCION => xxx ' + ex.getMessage() + ' - ' + ex.getLineNumber()));
            system.debug('@@@@ ERROR ABRIR PRE-DIGITADOR => ' + ex + '; LÍNEA => ' + ex.getLineNumber());
        }

        return null;
    }
}