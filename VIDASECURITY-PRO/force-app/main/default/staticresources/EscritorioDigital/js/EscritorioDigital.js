function verRequerimiento(IdRequerimiento, Persistencia, Rut) {          
   if (Persistencia > 0)
   {       
        var performance   = 'height=768px,width=1366px, center=yes, scrollbars=yes';
	   
        var url = "http://vidasecurity.valueweb.cl/TotalAgility/forms/vs-ed-dev/VS-ED-FormularioFirma.form?IDRequerimiento="+IdRequerimiento+"&Rut="+Rut+"&Persistencia="+Persistencia+"";	
        
		    var popUp = window.open(url, "_blank", performance);
		
		    if (popUp == null || typeof(popUp)=='undefined') {  
			      alert('Por favor deshabilita el bloqueador de ventanas emergentes y vuelve a hacer clic en "Detalle de Solicitud".');		
		    }
		    else {  		
			      popUp.focus();           
		    }
   }
   else
   {
	      alert('Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'); 
   }     
}
   
function crearSolicitud(IdRequerimiento, Persistencia, CasoId) {                    
    if (Persistencia == -6) 
    {   
        alert('Ha ocurrido un error de Comunicación con Escritorio Digital, la Solicitud no ha sido generada.');   
    } 
    else if (Persistencia == -1) 
    {
      alert('Error de Auntenticacion en Escritorio Digital.');         
    }
    else if (Persistencia == 0)           
    {
      alert('Ha ocurrido un error, la Solicitud no ha sido generada en Escritorio Digital.');         
    }
    else
    {       
      if (IdRequerimiento == -1)
       {
          alert('El RUT de Contratante utilizado en la Solicitud no se encuentra registrado en Escritorio Digital.');           
       }
       else if (IdRequerimiento == -2)
       {
           alert('El RUT de Contratante utilizado no posee beneficiarios asociados en Escritorio Digital que permitan satisfacer la solicitud realizada.');           
       }
       else
       {
          toBack();
       }
    }
}
		
function eliminarError(Persistencia) {                
 		if (Persistencia <= 0) { 
   		alert('Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'); 
 		}   
}

function actualizarSolicitud(Persistencia) {                    
   if (Persistencia != -6) {            
       if (Persistencia == -1) {
           alert('Error de Auntenticacion en Escritorio Digital.');         
       }
       else                       
       {
           alert('Ha ocurrido un error, la Solicitud no ha sido generada en Escritorio Digital.');         
       }
   } 
   else                       
   {
       alert('Ha ocurrido un error de Comunicación con Escritorio Digital, la Solicitud no ha sido generada.');         
   }     
}

function errorPersistencia(Persistencia) {                    
   if (Persistencia != -6) {            
       if (Persistencia == -1) {
           alert('Error de Auntenticacion en Escritorio Digital.');         
       }
       else                       
       {
           alert('Ha ocurrido un error, la Solicitud no ha sido generada en Escritorio Digital.');         
       }
   } 
   else                       
   {
       alert('Ha ocurrido un error de Comunicación con Escritorio Digital, la Solicitud no ha sido generada.');         
   }     
}

