/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_GetBusinessHour {
    public class Output
    {
        @InvocableVariable()
        public boolean activeBusiness;
    }

    @InvocableMethod(label='Reembolso_GetBusinessHour')
    public static List<Output> processInput()
    {
        List<Output> statusOutPut = new List<Output>();
        try
        {
            Output status = new Output();
            status.activeBusiness = false;
            DateTime currentTime = System.now();

            BusinessHours bh = new BusinessHours();
            if(Schema.sObjectType.BusinessHours.isAccessible())
            {
                bh = [SELECT Id FROM BusinessHours WHERE Name = 'Predeterminado'];

                status.activeBusiness = BusinessHours.isWithin(bh.id, currentTime);
            }

            statusOutPut.add(status);
        }
        catch (Exception ex)
        {
           System.debug('Error en la clase WSP_COL_Reembolso_GetBusinessHour ' +  ex) ;
        }

        return statusOutPut;
    }
}