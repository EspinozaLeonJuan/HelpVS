j$ = jQuery.noConflict();
    
    function windowResize() { 
        var width= j$("[id$='pag']").width() + 20; 
        var height= j$("[id$='pag']").height() + 100;
        window.resizeTo(width,height); 
    }
    
    // previo al unload, prompt al usuario de ventana cerrada
    var message = "Debe cerrar la ventana desde la botonera o las opciones ingresadas no serán guardadas.";
    window.onbeforeunload = function(event) {
        var e = e || window.event;
        if (e) {
            e.returnValue = message; 
        }
        
        return message;
    };
    
    // unload, desbloquea panel totalpack al cerrar ventana
    window.onunload = cerrarVentana; 
    function cerrarVentana() { window.opener.fRegresoPopup(); }
    
    j$(document).ready(function() {
        windowResize();
    });