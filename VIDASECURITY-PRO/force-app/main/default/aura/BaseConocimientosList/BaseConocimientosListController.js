({
    doInit: function(component, event, helper) {
        var next = false;
        var prev = false;
        helper.loadSoluciones(component, next, prev);
        helper.loadEstadosSolucion(component);
        helper.loadCategorias(component);
        component.set("v.isOpen", false);
        component.set("v.isOpenCategoria", false);
        var parametros = helper.definirParametros(component);
        if (parametros != undefined) {
            if (helper.tamanoObjeto(parametros) > 1 && parametros["sfdc.override"] == null)
                helper.loadSolucionById(component, parametros["Id"], parametros["recordMode"])
            else if (parametros["sfdc.override"] != null)
                helper.recargarPagina();
        }
    },
    busqueda: function(component, event, helper) {
        var next = false;
        var prev = false;
        component.set("v.recordModeCategoriaSelect", "");
        helper.loadSoluciones(component, next, prev);
    },

    cleanSearch: function(component, event, helper) {
        var next = false;
        var prev = false;
        component.set("v.recordModeCategoriaSelect", "");
        var textoBusqueda = component.get("v.textoBusqueda");
        if (textoBusqueda == undefined || textoBusqueda == "")
            helper.loadSoluciones(component, next, prev);
        else
            component.set("v.textoBusqueda", "");

    },

    openModalCategoriaSelect: function(component, event, helper) {
        component.set("v.isOpenCategoriaSelect", true);
        component.set("v.recordModeCategoriaSelect", "findCategory");
    },

    openModel: function(component, event, helper) {
        component.set("v.recordMode", 'new');
        component.set("v.isOpen", true);
        component.set("v.itemId", "");
        component.set("v.itemParentId", "");
        component.set("v.categorySolucion", "");
        component.set("v.solucion", { 'sobjectType': 'Solution', 'Status': '', 'IsPublishedInPublicKb': false, 'IsPublished': true, 'SolutionName': '', 'SolutionNote': '', 'SolutionNumber': '', 'Categoria_Solucion__c': '' });
    },
    openModelCategoria: function(component, event, helper) {
        component.set("v.recordModeCategoria", 'manage');
        component.set("v.isOpenCategoria", true);
    },
    openModelConSolucion: function(component, event, helper) {
        var solucion = event.getParam("solucion");
        var recordMode = event.getParam("recordMode");
        component.set("v.solucion", solucion);
        component.set("v.recordMode", recordMode);
        component.set("v.isOpen", true);
    },
    next: function(component, event, helper) {
        var next = true;
        var prev = false;
        var offset = component.get("v.offset");
        var recordModeCategoriaSelect = component.get("v.recordModeCategoriaSelect");
        if (recordModeCategoriaSelect == 'findCategory')
            helper.loadSolucionesByCategoria(component, next, prev, offset);
        else
            helper.loadSoluciones(component, next, prev, offset);
    },
    previous: function(component, event, helper) {
        var next = false;
        var prev = true;
        var offset = component.get("v.offset");
        var recordModeCategoriaSelect = component.get("v.recordModeCategoriaSelect");
        if (recordModeCategoriaSelect == 'findCategory')
            helper.loadSolucionesByCategoria(component, next, prev, offset);
        else
            helper.loadSoluciones(component, next, prev, offset);
    },
    actualizarListado: function(component, event, helper) {
        var next = false;
        var prev = false;
        helper.loadSoluciones(component, next, prev);
    },
    closeModel: function(component, event, helper) {
        var recordMode = component.get("v.recordMode");

        var recordInfo = event.getParam("recordInfo");
        var isOpen = event.getParam("isOpen");
        var isOpenCategoriaSelect = event.getParam("isOpenCategoriaSelect");
        var recordModeCategoriaSelect = event.getParam("recordModeCategoriaSelect");
        var solutionNote = event.getParam("solutionNote");
        var solutionName = event.getParam("solutionName");
        var isPublished = event.getParam("isPublished");
        var isPublishedKb = event.getParam("isPublishedKb");
        var solutionStatus = event.getParam("solutionStatus");
        component.set("v.isOpen", isOpen);

        if (recordMode == 'new')
            component.set("v.solucion", { 'sobjectType': 'Solution', 'Status': solutionStatus, 'IsPublishedInPublicKb': isPublishedKb, 'IsPublished': isPublished, 'SolutionName': solutionName, 'SolutionNote': solutionNote, 'SolutionNumber': '', 'Categoria_Solucion__c': '' });

        if (isOpenCategoriaSelect) {
            component.set("v.isOpenCategoriaSelect", isOpenCategoriaSelect);
            component.set("v.recordModeCategoriaSelect", recordModeCategoriaSelect);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            if (!toastEvent) {
                component.set('v.recordInfo', recordInfo);
                helper.toogleMensaje(component);
            }
        }
    },
    closeModelCategoria: function(component, event, helper) {
        helper.closeModelCategoria(component, event);
    },
    eliminarSolucion: function(component, event, helper) {
        var solucion = event.getParam("solucion");
        component.set("v.solucion", solucion);
        component.set("v.deseaEliminar", true);
    },
    eliminarCategoria: function(component, event, helper) {
        helper.eliminarCategoria(component, event);
    },
    cerrarModalEliminarSolucion: function(component, event, helper) {
        component.set("v.deseaEliminar", false);
        var recordInfo = event.getParam("recordInfo");
        component.set('v.recordInfo', recordInfo);
        helper.toogleMensaje(component);

    },
    cerrarModalEliminarCategoria: function(component, event, helper) {
        helper.cerrarModalEliminarCategoria(component, event);

    },
    cerrarModalCategoriaSelect: function(component, event, helper) {
        helper.cerrarModalCategoriaSelect(component, event);
    },
    cambioPaginacion: function(component, event, helper) {
        var next = false;
        var prev = false;
        helper.loadSoluciones(component, next, prev);
    },

    showSpinner: function(component, event, helper) {
        var countRequest = component.get('v.countRequest');
        if (countRequest == 0)
            helper.showSpinner(component, event);
        component.set('v.countRequest', countRequest + 1);
    },

    hideSpinner: function(component, event, helper) {
        var countRequest = component.get('v.countRequest');
        component.set('v.countRequest', countRequest - 1);
        countRequest = component.get('v.countRequest');
        if (countRequest == 0)
            helper.hideSpinner(component, event);
    }

})