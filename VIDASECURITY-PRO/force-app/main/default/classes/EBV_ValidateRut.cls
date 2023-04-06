public with sharing class EBV_ValidateRut
{
   	public class Output {
   	   	@InvocableVariable(required=true)
       	public boolean outRut;
  	}
  	public class Input { 
      	@InvocableVariable(required=true)
      	public String rut;
  	}
    
  	@InvocableMethod(label='EBV Get RUT')
        public static List<Output> getRutValidate (List<Input> ruts){
        
       	List<Output> statusRut = new List<Output>();
      
        Output status = new Output();
        boolean existe = false;
        String last;

        try {
		
        Set<String> rutNumbers = new Set<String>();
        String vrut;
        for(Input Inputs :ruts){
            rutNumbers.add(Inputs.rut);
            vrut = Inputs.rut;
        }
        
        //Cleaning '-' and '.'
        String cleanRUT = vrut
            .replace('.','')
            .replace('-','');
        
        //size RUT input
        Integer result = cleanRUT.length();
        
        //get the last number RUT
            if(result==9){
        	last = cleanRUT.substring(0, 8);
            }else{
            	last = cleanRUT.substring(0, 7);
        	}
        
      
        if(Schema.sObjectType.Account.isAccessible())
        {
        	Account r = [SELECT Rut_contacto__pc , DV_contacto__pc FROM Account WHERE Rut_contacto__pc =: last ];
                
            //concatenate rut and dv
            String conca = String.valueOf(r.Rut_contacto__pc) + String.valueOf(r.DV_contacto__pc);
            
            system.debug(conca + ' ---------------------------------');
            if( cleanRUT == conca && (result == 8 || result == 9) ) {
                existe = True;
            }else{
                existe = False;
            }
            
            status.outRut = existe;
            statusRut.add(status);
                       
        }
            
            
        } 
        catch (Exception ex ) 
        {
            System.debug( 'EBV_ValidateRut ' + ex);
            
        }
            
        
        
        return statusRut;
	}
    
}