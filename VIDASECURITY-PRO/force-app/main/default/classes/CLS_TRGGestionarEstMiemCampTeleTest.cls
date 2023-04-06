/*******************************************************************************************
 *  NOMBRE                 : CLS_TRGGestionarEstMiemCampTeleTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 17/07/2018 - G.PINTO	        - Creación Clase
 *  1.1     - 21/11/2018 - H.NORAMBUENA     - Actualización a nuevos estados tareas onco
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_TRGGestionarEstMiemCampTeleTest {
     static testMethod void GestorMiembroCampana(){
        
        try{
    		Test.startTest();
    	    Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
      		
            String RecordTypeVenta='';
                
                RecordTypeVenta=[select id from RecordType where name='Campaña - Televenta Oncológico'].id;
                if (RecordTypeVenta==null)
                {
                    RecordTypeVenta='';
                }
            
            Campaign campa = new Campaign();
            campa.Status='En Curso';
            campa.IsActive=false;
            campa.Name='Campana Prueba';
            campa.RecordTypeId=RecordTypeVenta;
            
            insert campa;
            
            campa.IsActive=true;
            
            update campa;
            
            
            
            
            
            
            Test.stopTest();
        }
         catch(Exception ex)
         {
            Test.stopTest();
         }
     }
    

}