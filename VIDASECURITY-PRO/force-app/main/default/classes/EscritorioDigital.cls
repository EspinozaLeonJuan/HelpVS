public class EscritorioDigital {
    
    public static String Requerimiento(String Tipo)
    {
        if (tipo == 'RRVVTIPO0001') {
            return 'Solicitud Pensión Sobrevivencia';             
        }
        else if(tipo == 'RRVVTIPO0002') {
            return'Solicitud Pensión Sobrevivencia';  
        }
        else if (tipo == 'RRVVTIPO0003') {
            return'Solicitud Pensión Sobrevivencia';
        } 
        else if (tipo == 'RRVVTIPO0004') {
            return 'Solicitud Pensión Sobrevivencia';
        } 
        else if (tipo == 'RRVVTIPO0005') {
            return 'Cuota Mortuoria'; 
        } 
        else if (tipo == 'RRVVTIPO0006') {
            return 'Mantención forma de pago'; 
        } 
        /*else if (tipo == 'RRVVTIPO0007') {
            return 'Mantención poder de cobro a tercero';
        } */
        else if (tipo == 'RRVVTIPO0008') {
            return 'Declaracion Beneficiarios Periodo Garantizado';  
        } 
       /* else if (tipo == 'RRVVTIPO0010') {
            return 'Solicitud Asignacion Familiar'; 
        } 
        else if (tipo == 'RRVVTIPO0011') {
           return 'Solicitud Asignacion Familiar';  
        } 
        else if (tipo == 'RRVVTIPO0012') {
           return 'Solicitud Asignacion Familiar';  
        }*/ 
        else if (tipo == 'RRVVTIPO0013') {
           return 'Solicitud Asignacion Familiar';  
        } 
        /*else if (tipo == 'RRVVTIPO0014') {
           return'Solicitud Asignacion Familiar';  
        } */
        /*else if (tipo == 'RRVVTIPO0015') {
           return'Declaración Ingresos nuevos beneficiarios';  
        } */
        else if (tipo == 'RRVVTIPO0016') {
           return 'Declaración Ingresos Actualización'; 
        } 
        else if (tipo == 'RRVVTIPO0017') {
           return 'Solicitud de Extinción'; 
        } 
        else if (tipo == 'RRVVTIPO0018') {
           return 'Solicitud de Extinción'; 
        } 
        else if (tipo == 'RRVVTIPO0019') {
           return 'Solicitud de Extinción';              
        } 
        else if (tipo == 'RRVVTIPO0020') {
           return 'Solicitud de Extinción';            
        } 
        else if (tipo == 'RRVVTIPO0021') {
           return 'Solicitud de Extinción';              
        }         
        else if (tipo == 'RRVVTIPO0022') {
           return 'Solicitud Garantía Estatal';            
        } 
        else if (tipo == 'RRVVTIPO0023') {
           return 'Solicitud Garantía Estatal';             
        } 
        else if (tipo == 'RRVVTIPO0024') {
            return 'Solicitud Garantía Estatal';             
        } 
        else if (tipo == 'RRVVTIPO0025') {
            return 'Solicitud Garantía Estatal'; 
        } 
        else if (tipo == 'RRVVTIPO0026') {
            return 'Solicitud Garantía Estatal';             
        } 
        else if (tipo == 'RRVVTIPO0027') {
            return 'Renuncia Garantía Estatal';              
        } 
        
        return '';
    }
    
    
    public static String Solicitante(String Tipo)
    {
        if (tipo == 'RRVVTIPO0001') {
            return  'Cónyuge';
        }
        else if(tipo == 'RRVVTIPO0002') {
            return  'Madre Filiación N/M';
        }
        else if (tipo == 'RRVVTIPO0003') {
            return  'Hijo menor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0004') {
            return  'Hijo mayor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0005') {
            return  'Persona o Entidad que realiza el gasto';
        } 
        else if (tipo == 'RRVVTIPO0006') {
            return  'Rentista Titular';
        } 
        /*else if (tipo == 'RRVVTIPO0007') {
            return  'Rentista Titular';
        } */
        else if (tipo == 'RRVVTIPO0008') {
            return  'Rentista Titular';
        } 
/*        
        else if (tipo == 'RRVVTIPO0010') {
            return  'Cónyuge';
        } 
        else if (tipo == 'RRVVTIPO0011') {
            return  'Hijo menor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0012') {
            return  'Hijo mayor de 18 años';
        } */
        else if (tipo == 'RRVVTIPO0013') {
            return  'Afiliado Titular';//Otros
        } 
     /*   else if (tipo == 'RRVVTIPO0014') {
            return  'Madre o Padre (Ascendente)';
        } */
      /*  else if (tipo == 'RRVVTIPO0015') {
            return  'Afiliado Titular';
        } */
        else if (tipo == 'RRVVTIPO0016') {
            return 'Afiliado Titular';
        } 
        else if (tipo == 'RRVVTIPO0017') {
            return 'Cónyuge';
        } 
        else if (tipo == 'RRVVTIPO0018') {
            return 'Hijo menor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0019') {
            return 'Hijo mayor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0020') {
            return 'Otros';
        } 
        else if (tipo == 'RRVVTIPO0021') {
            return 'Madre o Padre (Ascendente)';
        }         
        else if (tipo == 'RRVVTIPO0022') {
            return 'Afiliado Titular';
        } 
        else if (tipo == 'RRVVTIPO0023') {
            return 'Cónyuge';
        } 
        else if (tipo == 'RRVVTIPO0024') {
            return 'Madre Filiación N/M';
        } 
        else if (tipo == 'RRVVTIPO0025') {
            return 'Hijo menor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0026') {
            return 'Hijo mayor de 18 años';
        } 
        else if (tipo == 'RRVVTIPO0027') {
            return 'Afiliado Titular';
        } 
        
        return '';
    }
    
	public static String Formulario(String DetalleSolicitud)
    {
        if (DetalleSolicitud == 'Solicitud pensión sobrevivencia')
        {
           	return 'Solicitud Pensión Sobrevivencia';                  
        }
        else if  (DetalleSolicitud == 'Solicitud cuota mortuoria')
        {
       		return 'Cuota Mortuoria';            
        }
        else if  (DetalleSolicitud == 'Solicitud cambio pago pensión')
        {
            return 'Mantención forma de pago';         
        }
      /*  else if  (DetalleSolicitud == 'Solicitud de ingreso poder notarial')
        {
            return 'Mantención poder de cobro a tercero';
        }*/
        else if  (DetalleSolicitud == 'Solicitud periodo garantizado')
        {
            return 'Declaracion Beneficiarios Periodo Garantizado';
        }
        else if  (DetalleSolicitud == 'Solicitud de incorporación/ Renovación asignación familiar')
        {
			return 'Solicitud Asignacion Familiar'; 
        }
        else if  (DetalleSolicitud == 'Solicitud garantía estatal')
        {
			return 'Solicitud Garantía Estatal'; 
        }
        else if  (DetalleSolicitud == 'Solicitud de Extinción')
        {
			return 'Solicitud de Extinción'; 
        }
        /*else if  (DetalleSolicitud == 'Declaración Ingresos nuevos beneficiarios')
        {
			return 'Declaración Ingresos nuevos beneficiarios'; 
        }*/
        else if  (DetalleSolicitud == 'Declaración Ingresos Actualización')
        {
			return 'Renovación de Asignación Familiar'; 
        }
        else if (DetalleSolicitud == 'Renuncia Garantía Estatal')
        {
            return 'Renuncia Garantía Estatal';
        }
        
        return '';        
    }
    
    public static boolean ValidaSolicitud(String DetalleSolicitud)
    {
        if (DetalleSolicitud == 'Solicitud pensión sobrevivencia' ||
            DetalleSolicitud == 'Solicitud cuota mortuoria' ||
            DetalleSolicitud == 'Solicitud cambio pago pensión' ||
          //  DetalleSolicitud == 'Solicitud de ingreso poder notarial' ||
            DetalleSolicitud == 'Solicitud periodo garantizado' ||
            DetalleSolicitud == 'Solicitud de incorporación/ Renovación asignación familiar' ||
            DetalleSolicitud == 'Solicitud de Extinción' ||
           // DetalleSolicitud == 'Declaración Ingresos nuevos beneficiarios' ||
            DetalleSolicitud == 'Declaración Ingresos Actualización' ||
            DetalleSolicitud == 'Solicitud garantía estatal' ||
           DetalleSolicitud == 'Renuncia Garantía Estatal')
        {                                
            return true;
        }
               
        return false; 
    }
    
}