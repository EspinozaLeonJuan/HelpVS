({
    goToRecord: function(component, event, helper) {
        var parametroSolucionModal = component.getEvent("parametroSolucionModal");
        var solucion = component.get("v.solucion");
        var eventSource;
        if (event != null)
            eventSource = event.getSource().get("v.name");
        parametroSolucionModal.setParams({ "solucion": solucion, "recordMode": eventSource });
        parametroSolucionModal.fire();

    },

    irAlRegistro: function(component, event, helper) {
        var parametroSolucionModal = component.getEvent("parametroSolucionModal");
        var solucion = component.get("v.solucion");
        var eventSource = "view";
        parametroSolucionModal.setParams({ "solucion": solucion, "recordMode": eventSource });
        parametroSolucionModal.fire();

    },

    deleteRecord: function(component, event, helper) {
        var eliminarSolucion = component.getEvent("eliminarSolucion");
        var solucion = component.get("v.solucion");
        eliminarSolucion.setParams({ "solucion": solucion });
        eliminarSolucion.fire();

    },

    scriptsLoaded: function(component, event, helper) {
        $(document).ready(function() {
            $(".wrapper").dotdotdot({
                ellipsis: '... '
            });
        });

    }


})