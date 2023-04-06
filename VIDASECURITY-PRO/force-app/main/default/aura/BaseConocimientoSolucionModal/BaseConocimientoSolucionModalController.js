({
    scriptsLoaded: function(component, event, helper) {
        helper.init(component);
    },
    openModelConSolucion: function(component, event, helper) {
        var recordMode = component.get("v.recordMode");
        var solucion = component.get('v.solucion');
        if (recordMode == 'new' && ( solucion == null || solucion == undefined) ) {
            component.set("v.solucion", { 'sobjectType': 'Solution', 'Status' : '', 'IsPublished': true, 'SolutionName': '', 'SolutionNote': '', 'SolutionNumber': '', 'Categoria_Solucion__c': '' });
        } else if(recordMode!= 'new' && solucion != undefined && solucion.id != undefined){
            solucion = component.get('v.solucion');
            helper.setUrlBySolucion(solucion);
        }
        solucion = component.get('v.solucion');

        var estados = component.get("v.estados");
           
        if(estados!=undefined && estados.length > 0 && solucion.Status==undefined){
            solucion.Status = estados[0];
            component.set("v.solucion", solucion);
        }

    },

    cerrarModal: function(component, event, helper) {
        helper.cerrarModal(component);
    },

    handleSaveRecord: function(component, event, helper) {
        helper.guardarSolucion(component, event);
    },

    pressKey: function(component, event) {
        if (event.getParams().keyCode == 27) {
            helper.cerrarModal(component);
        }
    },

    habilitarContenido: function(component, event, helper) {
        component.set("v.recordMode", "edit");
    },

    selectCategory : function(component, event, helper){
    
        helper.cerrarModal(component, null, true);
    },

    deleteCategory : function(component, event, helper){
        helper.deleteCategory(component, event);
    },

    showSpinner: function(component, event, helper) {
        var countRequest = component.get('v.countRequest');
        if (countRequest == 0)
            helper.showSpinner(component, event);
        component.set('v.countRequest', countRequest + 1);
    },

    hideSpinner : function(component,event,helper){
        var countRequest = component.get('v.countRequest');
        component.set('v.countRequest', countRequest -1);
        countRequest = component.get('v.countRequest');
        if (countRequest == 0)
            helper.hideSpinner(component, event);
    }
})