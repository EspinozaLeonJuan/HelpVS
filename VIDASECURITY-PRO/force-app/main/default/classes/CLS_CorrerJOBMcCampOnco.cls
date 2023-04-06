/*******************************************************************************************
 *  NOMBRE                 : CLS_CorrerJOBMcCampOnco
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - Permite ejecutar APEX JOB para procesar MC
 * 							 Campaña Oncológico planificada.
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
global class CLS_CorrerJOBMcCampOnco {

    //@InvocableMethod(label='Procesa MC Oncológico' description='Permite procesar MC cargados en campañas planificadas de oncológico...')
    global static void procesarMCCampOnco(List<Campaign> lCampana){
        
        try{
            
            Integer tamLote = 1;
            if(lCampana.size() > 0){
                String IdCampana = lCampana[0].Id;
                CLS_ProcesoBatchMCTeleventaOncologico j_MConco = new CLS_ProcesoBatchMCTeleventaOncologico(IdCampana);     
                Id IdJobs = Database.executeBatch(j_MConco, tamLote);
            }
          
        }catch(System.Exception ex){
            System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
        }
        
    }
    
}