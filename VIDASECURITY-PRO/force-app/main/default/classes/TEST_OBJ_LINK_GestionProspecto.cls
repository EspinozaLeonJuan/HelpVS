/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 02-17-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_OBJ_LINK_GestionProspecto {



    @isTest static void go()
     {
         Test.startTest();
         OBJ_LINK_GestionProspecto.Prospecto prospecto = new OBJ_LINK_GestionProspecto.Prospecto();
         prospecto.Id = '';
         prospecto.RUT = '';
         prospecto.isConverted = false;
         prospecto.Campagnas = new List<OBJ_LINK_GestionProspecto.Campagna>();

         OBJ_LINK_GestionProspecto.Campagna campagna = new OBJ_LINK_GestionProspecto.Campagna();
         campagna.Id = '';
         campagna.Member_Id = '';
         campagna.Origen = '';
         campagna.Name = '';
         campagna.Type = '';
         campagna.CreatedDate =  Datetime.newInstance(2022, 2, 17);
         Test.stopTest();
     }
}