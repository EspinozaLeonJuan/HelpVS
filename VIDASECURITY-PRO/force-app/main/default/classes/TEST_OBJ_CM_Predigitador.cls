@IsTest 
public class TEST_OBJ_CM_Predigitador {
     @isTest static void go()
     {
         Test.startTest();
         OBJ_CM_Predigitador clase = new OBJ_CM_Predigitador();
         clase.rutUsuario = '';
         clase.dvUsuario = '';
         clase.idCanal = '';
         clase.rutContratante = '';
         clase.idCampana = '';
         clase.tipoFolio = '';
         clase.poliza = '';
         clase.idExterno = '';
         clase.totalInic = '';
         clase.preimpreso = '';
         clase.direccion = '';
         clase.mail = '';
         clase.fono = '';
         clase.celular = '';
         clase.codComuna = '';
         clase.codRegion = '';
         clase.codCiudad = '';
         clase.tipoCliente = '';
         clase.persistencia = '';
         clase.url = '';
         clase.plan= '';
         clase.rutAseguradoTitular = '';
         clase.direccionAsegT = '';
         clase.mailAsegT = '';
         clase.fonoAsegT = '';
         clase.celularAsegT = '';
         clase.codComunaAsegT = '';
         clase.codRegionAsegT = '';
         clase.codCiudadAsegT = ''; 
         Test.stopTest();
     }
    
      @isTest static void go_I()
     {
         Test.startTest();
         OBJ_CM_Predigitador clase = new OBJ_CM_Predigitador('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
         Test.stopTest();
     }
    
    @isTest static void go_II()
     {
         Test.startTest();
         OBJ_CM_Predigitador clase = new OBJ_CM_Predigitador('', '','','','','','','','','','','','','','','','','','','','','','','','');   
         Test.stopTest();
     }
}