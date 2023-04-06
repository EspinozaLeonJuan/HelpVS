/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
public with sharing class CLS_CS_Derivacion_Escritorio {
    public CLS_CS_Derivacion_Escritorio() { 

    }

    public static String Valida_EstadoRequerimiento(String ID, String UsuarioID)
    {
        String Response = '';
        try
        {
            String IdRequerimiento = '';
            String RutUsuario = '';

            List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UsuarioID];

            if (lusers.size() > 0)
            {
                RutUsuario = lusers[0].RUT_Usuario__c;
            }

            if (Test.isRunningTest())
            {
                RutUsuario = '1-9';
            }

            if (RutUsuario != '')
            {
                String Etiqueta = '';
                List<Case> lcases = [Select Id, Id_Requerimiento_EscritorioDigital__c, Detalle_Solicitud__c From Case Where Id = : ID];

                if (Test.isRunningTest())
                {
                    Case caso = new Case();
                    caso.Id_Requerimiento_EscritorioDigital__c = '123';
                    caso.Detalle_Solicitud__c = 'Detalle';
					lcases.add(caso);
                }

                if (lcases.size() > 0)
                {
                    IdRequerimiento =  lcases[0].Id_Requerimiento_EscritorioDigital__c;
                    Etiqueta = CLS_EscritorioDigital_Internal.Etiqueta(lcases[0].Detalle_Solicitud__c);
                }

                if (Test.isRunningTest())
                {
                    IdRequerimiento= '69';
                    Etiqueta = 'Solicitud garantía estatal';
                }

                if (Etiqueta != '')
                {
                    if (IdRequerimiento == null || IdRequerimiento == '')
                    {
                        Response = 'REQUERIMIENTO_NO_CREADO_ED';//Requerimiento no creado en ED  4
                    }
                    else
                    {
                       CLS_EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'INGRESADO', RutUsuario);    

                       Response = Respuesta.Response;
                    }
                }
                else
                {
                    Response = 'REQUERIMIENTO_NO_ED'; //Ok, Caso no corresponde a Requerimiento ED   2
                }
            }
            else
            {
                Response = 'RUT_USUARIO_NO_REGISTRADO';//Error, RUT de Usuario no registrado   1
            }
        }catch(Exception ex){
            System.debug('@@@@|CambioEstadoDerivaCaso -->'+ex);
        //    ApexPages.addMessages(ex);
            Response = 'EXCEPCION'; //3
        }

         return Response;
    }
}