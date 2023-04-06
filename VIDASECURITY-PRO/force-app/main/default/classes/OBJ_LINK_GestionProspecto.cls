/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-04-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class OBJ_LINK_GestionProspecto {
    public OBJ_LINK_GestionProspecto() {

    }

    public class Prospecto
    {
        public String Id { get; set;}

        public String RUT { get; set;}

        public Boolean isConverted { get; set;}

        public List<Campagna> Campagnas {get; set;}
    }

    public class Campagna
    {
        public String Id { get; set;}

        public String Member_Id { get; set;}

        public String Origen { get; set;}

        public String Name { get; set;}

        public String Type { get; set;}

        public Datetime CreatedDate { get; set;}
    }
}