/*******************************************************************************************
 *  NOMBRE                 : CLS_ProcesoAsignacionResponsableCasos
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
global class CLS_ProcesoAsignacionResponsableCasos {

    //Procedimiento para asignar dinámicamente un caso a UN RESPONSABLE de un ára resolutora...
    
    public void AsignarCaso(Case caso){
        try{
            if(caso != null){
                system.debug('@@@@@ CASO => ' + caso);
                Case c = [SELECT
                         		Id,
                         		OwnerId,
                          		Tipo_de_Requerimiento__c,
                          		Negocio__c,
                          		CASO_Categoria__c,
                          		Detalle_Solicitud__c,
                                Fecha_Derivacion_UR__c                         		
                          FROM
                         		Case
                          WHERE
                         		Id =: caso.Id AND CASO_Responsable_UR__c = NULL];
                 
                system.debug('@@@@ CASO ACTUALIZADO => ' + c);
                system.debug('@@@@ ID => ' + c.Id);
                system.debug('@@@@ OWNERID => ' + c.OwnerId);
                system.debug('@@@@ TIPO REQUERIMIENTO => ' + c.Tipo_de_Requerimiento__c);
                system.debug('@@@@ NEGOCIO => ' + c.Negocio__c);
                system.debug('@@@@ CATEGORIA => ' + c.CASO_Categoria__c);
                system.debug('@@@@ DETALLE SOLICITUD => ' + c.Detalle_Solicitud__c);
                
                string area = c.OwnerId;
                area = area.substring(0, area.length()-3);
                system.debug('@@@@ PROPIETARIO CASO => ' + area);
                
                //Validar tipificación en tabla asignaciones UR
                List<asignacion_UR__c> Asignaciones = new List<asignacion_UR__c>();
                Asignaciones = [SELECT 
                                		Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, Tipo_Asignacion__c, Asignaci_n__c
                                FROM 
                                		asignacion_UR__c
                                WHERE 
                               			OwnerId =: c.OwnerId AND // Verifica propietarios del caso con propietario de asignación
                                		Tipo_de_Registro_del_Caso__c = 'Solicitudes' AND
                                        Negocio__c =: c.Negocio__c AND 
                                        Categor_a__c =: c.CASO_Categoria__c AND 
                                        Detalle_Solicitud__c =: c.Detalle_Solicitud__c];
                
                System.debug('@@@@ ASIGNACIONES => ' + Asignaciones);
                
                //Validamos cantidad de registros o combinaciones capturadas desde objteo Asingaciones UR con los criterios del caso tratado...
                if(Asignaciones.size() > 0){
                    system.debug('@@@@ ASIGNACIONES RECUPERADAS => ' + Asignaciones);
                        
                    List<SelectOption> lst = new List<SelectOption>();
                    //List<Usuario_Backup__c> UsuariosFinales = new List<Usuario_Backup__c>();
                    Usuario_Backup__c ufinNew=null;
                    integer nMaxCasos = 10000000;
                    String EntitlementIdAsignacion = '';
                    
                    for(asignacion_UR__c a : Asignaciones){
                        
                        Usuario_Backup__c Usuarios = new Usuario_Backup__c();
                        Usuarios = [SELECT 
                                    Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Rut__c, UBAC_Email__c, 
                                    UBAC_Perfil__c, UBAC_ID_Cola_UR__c, UBAC_Carga_Actual__c , UBAC_Casos_Asignados__c, 
                                    UBAC_Total_Casos_rea__c, UBAC_No_Recibir_Casos__c 
                                    FROM 
                                    Usuario_Backup__c
                                    WHERE 
                                    Id =: a.Responsable__c AND UBAC_No_Recibir_Casos__c = false ORDER BY UBAC_Casos_Asignados__c ASC];
                        
                        
                        if(Usuarios != null){
                            //UsuariosFinales.add(Usuarios);
                            //lst.add(new SelectOption(String.valueOf(Usuarios.UBAC_Casos_Asignados__c),String.valueOf(Usuarios.Id)));
                            //
                            if (a.Tipo_Asignacion__c =='Igualdad') //Solo toma en cuenta casos No Cerrados
                            {
                                integer NCasos = [SELECT COUNT() FROM Case WHERE CASO_Responsable_UR__c =: Usuarios.Id AND (Status = 'En Proceso' OR Status = 'Back Office' OR Status = 'Revisión' )];
                                
                                if ( nMaxCasos > NCasos )
                                {
                                    nMaxCasos = NCasos;
                                    ufinNew = Usuarios;    
                                    EntitlementIdAsignacion = a.Asignaci_n__c;
                                }
                            }
                            else if (a.Tipo_Asignacion__c =='Automática' ) //Total de Casos
                            {
                                if ( nMaxCasos > Usuarios.UBAC_Casos_Asignados__c )
                                {
                                    nMaxCasos = Usuarios.UBAC_Casos_Asignados__c.intValue();
                                    ufinNew = Usuarios;    
                                    EntitlementIdAsignacion = a.Asignaci_n__c;
                                }
                            }
                            else //Otra asignacion por el momento 
                            {
                                if ( nMaxCasos > Usuarios.UBAC_Casos_Asignados__c )
                                {
                                    nMaxCasos = Usuarios.UBAC_Casos_Asignados__c.intValue();
                                    ufinNew = Usuarios;    
                                    EntitlementIdAsignacion = a.Asignaci_n__c;
                                }
                            }
                        }							
                    } 

                    if (c.Fecha_Derivacion_UR__c == null)//registra fecha de primera derivacion
                    {
                        c.Fecha_Derivacion_UR__c = Datetime.now();// 
                    }
                                                                    
                    //system.debug('@@@@ USUARIOS BACKUP FILTRADOS => ' + UsuariosFinales);
                    
                    if(ufinNew != null){
                        
                        c.CASO_Responsable_UR__c = ufinNew.Id;
                        c.Id_Responsable_UR__c = ufinNew.Id;

                        system.debug('@@@@ ASIGNACIONES SLA MAYOR A 1 => ' + EntitlementIdAsignacion);
                        c.EntitlementId = EntitlementIdAsignacion;
                        c.Fecha_Asignacion_UR__c = Datetime.now();
                        update c;
                        actualizaFechaCierre(c);
                        
                        integer NCasosArea = [SELECT
                                              COUNT()
                                              FROM
                                              Case
                                              WHERE
                                              OwnerId =: c.OwnerId];
                        
                        ufinNew.UBAC_Casos_Asignados__c = ufinNew.UBAC_Casos_Asignados__c + 1;
                        ufinNew.UBAC_Total_Casos_rea__c = NCasosArea;
                        update ufinNew;

                        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(c.Id_Responsable_UR__c, 'Back Office', '');                         
                    }                                              
                    
                }
                else{                    
                     c.EntitlementId = '5500H000000gu3a';
                     update c;
                     actualizaFechaCierre(c);
                        
                    ////
                     system.debug('@@@@ ASIGNACIONES SIN REGISTROS RECUPERADOS => ' + Asignaciones);
                }
            }
        }catch(Exception ex){
            system.debug('@@@@@ ERROR  ASIGNACIÓN RESPONSABLE UR => ' + ex);
        }
    }

    public void ReasignarCaso(String Id)
    {
        try {
            system.debug('@@@@@ CASO ID => ' + Id);
            Case c = [SELECT Id, Fecha_Asignacion_UR__c, Email_Responsable_UR__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, Fecha_Derivacion_UR__c
                        FROM Case 
                        WHERE Id =: Id];
                    
            Usuario_Backup__c UBck =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: c.Id_Responsable_UR__c];                    

            if (c.Fecha_Derivacion_UR__c == null)//registra fecha de primera derivacion
            {
                c.Fecha_Derivacion_UR__c = Datetime.now();// 
            }
                
            if (UBck != null)
            {
                c.Fecha_Asignacion_UR__c = Datetime.now();
                c.Email_Responsable_UR__c = UBck.UBAC_Email__c;	
                c.CASO_Responsable_UR__c = c.Id_Responsable_UR__c;
            }

            Update c;

            CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(c.Id_Responsable_UR__c, 'Back Office', c.Status);
        } catch (Exception ex) {
           
        }
    }
    
    private void actualizaFechaCierre(Case c){
        try{
            
            List<CaseMilestone> cmsToUpdate = [select Id, TargetDate, MilestoneType.Name from CaseMilestone where caseId =: c.id limit 1]; 
    		if (cmsToUpdate.isEmpty() == false){
        		for (CaseMilestone cm : cmsToUpdate){
            		Datetime dt = (Datetime) cm.TargetDate;
					c.Fecha_Cierre_Tope__c = dt.date();
	        	    update c;
            	}
        
	        }
        
        }catch(Exception ex){
            system.debug('@@@@@ ERROR  actualizaFechaCierre => ' + ex);
        }
    }
}