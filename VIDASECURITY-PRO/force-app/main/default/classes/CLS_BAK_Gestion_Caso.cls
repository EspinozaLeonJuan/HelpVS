/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-30-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_BAK_Gestion_Caso {
    public CLS_BAK_Gestion_Caso() {

    }

    public class Nodo
    {
        public String Id {get; set;}

        public String Name {get; set;}
    }

    public static  List<CLS_BAK_Gestion_Caso.Nodo> getListBandejaUR()
    {
        List<CLS_BAK_Gestion_Caso.Nodo> listaOut = new List<CLS_BAK_Gestion_Caso.Nodo>();

        CLS_BAK_Gestion_Caso.Nodo nd;

        List<OBJ_BandejaUR_Configuracion__c> colaboraciones = [SELECT Id, Colaboracion_Reclamo__c, Id_Cola__c, Nombre_Cola__c, Usuario__c, Usuario__r.Name, Usuario__r.UserName FROM OBJ_BandejaUR_Configuracion__c WHERE Colaboracion_Reclamo__c = true];

        for (OBJ_BandejaUR_Configuracion__c colaboracion : colaboraciones)
        {
            nd = new CLS_BAK_Gestion_Caso.Nodo();
            nd.Id = colaboracion.Id_Cola__c;
            nd.Name = colaboracion.Nombre_Cola__c;
            listaOut.add(nd);
        }

        return listaOut;
    }


}