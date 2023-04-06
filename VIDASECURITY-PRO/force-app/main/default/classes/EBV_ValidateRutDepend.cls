public class EBV_ValidateRutDepend {
    
    public class DepenOutput {
   	   	@InvocableVariable(required=true)
       	public boolean outRut;
  	}
  	public class DepenInput { 
      	@InvocableVariable(required=true)
      	public String rut;
  	}
  	@InvocableMethod(label='RUT DEPENDENT')
    public static List<DepenOutput> rutDependent (List<DepenInput> ruts){
        
       	List<DepenOutput> statusRut = new List<DepenOutput>();
      
        DepenOutput status = new DepenOutput();
        boolean valido = false;
        
     	Set<String> rutNumbers = new Set<String>();
       	String vrut;
      	for(DepenInput Inputs :ruts){
        	rutNumbers.add(Inputs.rut);
            vrut = Inputs.rut;
        }
        
         //Cleaning '-' and '.'
  		String cleanRUT = vrut
                .replace('.','')
                .replace('-','');
            
            //size RUT input
       	Integer result = cleanRUT.length();
        
       	if(result== 8 || result== 9){
         	valido = True;
       	}else{
          	valido = False;
       	}
            
      	status.outRut = valido;
       	statusRut.add(status);

  	return statusRut;	 
  
    }
      

}