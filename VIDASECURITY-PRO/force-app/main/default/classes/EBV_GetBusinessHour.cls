public without sharing  class EBV_GetBusinessHour 
{
    public class Output {
        @InvocableVariable()
        public boolean activeBusiness; 
    }     
    @InvocableMethod(label='EBV Get Business Hours')
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
           System.debug('Error en la clase EBV_GetBusinessHour ' +  ex) ;
        }
        return statusOutPut;
    }

}