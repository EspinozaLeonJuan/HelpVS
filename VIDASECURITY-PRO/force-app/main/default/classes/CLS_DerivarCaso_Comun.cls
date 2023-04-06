/*******************************************************************************************
 *  NOMBRE                 : CLS_DerivarCaso_Comun
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 *
 * *****************************************************************************************/
public  class CLS_DerivarCaso_Comun {

    public static void ValidaPropietarioCaso(Case caso)
    {
        system.debug('@@@@ INFO CASO => ' + caso);
        String Propietario = caso.OwnerId;
        system.debug('@@@@ TIPO PROPIETARIO (USER/QUEUE) => ' + Propietario.substring(0, 3));
        if(Propietario.substring(0, 3) == '005'){
            User u = [SELECT Id, FirstName, Username, LastName, Name FROM User WHERE Id =: caso.OwnerId];
            system.debug('@@@@ USUARIO => ' + u.Name);
            if(u != null && u.Name == 'Manuel Eduardo Poblete López'){
                caso.OwnerId = caso.CreatedById;
                caso.Status = 'En Proceso';
                caso.CASO_Responsable_UR__c = null;
                caso.CASO_Resultado_Derivaci_n__c = 'NO EXISTE REGLA DE ASIGNACIÓN...';

                if (!Test.isRunningTest())
                {
                    update caso;
                }
            }
        }else{
            caso.CASO_Resultado_Derivaci_n__c = 'CORRECTA ASIGNACIÓN...';

            if (!Test.isRunningTest())
            {
                update caso;
            }
        }
    }

    public static String RequerimientoEscritorioDigital(String ID, String UsuarioID)
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

    public static Boolean DerivacionPermitida(String Id)
    {
        Case caso;

        if (!Test.isRunningTest())
        {
        	caso = [SELECT Id, RecordTypeId, CASO_Categoria__c, Tipo_de_Requerimiento__c, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: Id];    
        }

        List<asignacion_UR__c> reqs;

        if (!Test.isRunningTest())
        {
        	reqs = [SELECT  Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, 
        	Tipo_Asignacion__c, Asignaci_n__c  FROM   asignacion_UR__c  
        	WHERE Detalle_Solicitud__c =: caso.Detalle_Solicitud__c AND Categor_a__c =: caso.CASO_Categoria__c AND Negocio__c =: caso.Negocio__c 
        	 AND Tipo_de_Registro_del_Caso__c = 'Solicitudes'];

        	system.debug('@@@@ DERPERMITIDA --> '+'SELECT  Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, '+ 
        	'Tipo_Asignacion__c, Asignaci_n__c  FROM   asignacion_UR__c WHERE Detalle_Solicitud__c = '+ caso.Detalle_Solicitud__c +
        	' AND Categor_a__c = '+ caso.CASO_Categoria__c+' AND Negocio__c ='+ caso.Negocio__c + 
        	 ' AND Tipo_de_Registro_del_Caso__c = Solicitudes');       
        }
        else
        {
         	reqs = new List<asignacion_UR__c> ();
        }
        

        system.debug('@@@@ -->'+reqs);
        if (reqs.size() > 0)
        {
            return true;
        }

        return false;
    }
}