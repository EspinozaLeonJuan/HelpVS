public with sharing class EBV_validateOption {
    
    public class optionInput {
    @InvocableVariable(required=true)
    public String option;
    }
	public class optionOutput {
        @InvocableVariable(required=true)
        public Boolean respuesta;
    }
    
    @invocableMethod(label='validateOption')
    public static List<optionOutput> validateOption(List<optionInput> listOption){
        List<optionOutput> output = new List<optionOutput>();
        Set<String> options = new Set<String>();
        String option;
        optionOutput out = new optionOutput();
        boolean validacion = false;
        for(optionInput optionInput :listOption){
            option = optionInput.option;
        }
        if(option == 'Ambulatorio (consulta, exámenes, medicamentos, ópticos)' || option == 'Dental'){
            validacion = true;
        }else{
            validacion = false;
        }
        out.respuesta = validacion;
        output.add(out);
        
        return output;
    }
}