({
    loadSoluciones: function(cmp, next, prev, offset) {

        var action = cmp.get("c.getSolutions");
        var textoBusqueda = cmp.get("v.textoBusqueda");
        var paginacion = cmp.get("v.paginacion");
        var busqueda;
        if (textoBusqueda != undefined)
            busqueda = textoBusqueda.split(' ');

        offset = offset || 0;
        action.setParams({
            "busqueda": busqueda,
            "next": next,
            "prev": prev,
            "off": offset,
            "pag": paginacion
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                cmp.set('v.error', null);
                var result = response.getReturnValue();
                cmp.set('v.offset', result.offst);
                cmp.set('v.soluciones', result.solutions);
                cmp.set('v.listaSoluciones', result.solutions);
                cmp.set('v.next', result.hasnext);
                cmp.set('v.prev', result.hasprev);
                cmp.set('v.totalSoluciones', result.total);
                cmp.set('v.isSolutionEditable', result.editable);
                cmp.set('v.isSolutionCreatable', result.creatable);
                cmp.set('v.isSolutionAccesible', result.accesible);
                cmp.set('v.isSolutionDeleteable', result.deletable);
                cmp.set('v.isCategoryEditable', result.categoryEditable);
                cmp.set('v.isCategoryCreatable', result.categoryCreatable);
                cmp.set('v.isCategoryAccesible', result.categoryAccesible);
                cmp.set('v.isCategoryDeleteable', result.categoryDeletable);
                cmp.set('v.mapFieldsAccesibility', result.mapFieldsAccesibility);
                cmp.set('v.mapFieldsUpdateable', result.mapFieldsUpdateable);
                console.log('mapFieldsUpdateable');
                console.log(result.mapFieldsUpdateable);


         } else if (state === 'ERROR') {
                var errors = response.getError();
                var errorMessagesStr = '\n';
                if (errors) {
                    for (var i = 0; i < errors.length; i++)
                        errorMessagesStr += errors[i].message + '\n';
                } else
                    errorMessagesStr = " Ha ocurrido un error!!.";
                this.mensaje(cmp, null, toastEvent, "Error!", errorMessagesStr);
            }

        });
        $A.enqueueAction(action);
    },

    loadSolucionesByCategoria: function(cmp, next, prev, offset) {

        var action = cmp.get("c.getSolutionsByCategory");
        var categoryId = cmp.get("v.itemParentId");
        var paginacion = cmp.get("v.paginacion");

        offset = offset || 0;
        action.setParams({
            "categoriaId": categoryId,
            "next": next,
            "prev": prev,
            "off": offset,
            "pag": paginacion
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                cmp.set('v.error', null);
                var result = response.getReturnValue();

                cmp.set('v.offset', result.offst);
                cmp.set('v.soluciones', result.solutions);
                cmp.set('v.listaSoluciones', result.solutions);
                cmp.set('v.next', result.hasnext);
                cmp.set('v.prev', result.hasprev);
                cmp.set('v.totalSoluciones', result.total);
                cmp.set('v.isSolutionEditable', result.editable);
                cmp.set('v.isSolutionCreatable', result.creatable);
                cmp.set('v.isSolutionAccesible', result.accesible);
                cmp.set('v.isSolutionDeleteable', result.deletable);
                cmp.set('v.isCategoryEditable', result.categoryEditable);
                cmp.set('v.isCategoryCreatable', result.categoryCreatable);
                cmp.set('v.isCategoryAccesible', result.categoryAccesible);
                cmp.set('v.isCategoryDeleteable', result.categoryDeletable);

            } else if (state === 'ERROR') {
                var errors = response.getError();
                var errorMessagesStr = '\n';
                if (errors) {
                    for (var i = 0; i < errors.length; i++)
                        errorMessagesStr += errors[i].message + '\n';
                } else
                    errorMessagesStr = " Ha ocurrido un error!!.";
                this.mensaje(cmp, null, toastEvent, "Error!", errorMessagesStr);
            }

        });
        $A.enqueueAction(action);
    },

    loadCategorias: function(cmp) {

        var action = cmp.get("c.getCategorias");
        action.setCallback(this, function(response) {

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                cmp.set('v.error', null);
                var result = response.getReturnValue();

            } else if (state === 'ERROR') {

                var errors = response.getError();
                var errorMessagesStr = '\n';
                if (errors) {
                    for (var i = 0; i < errors.length; i++)
                        errorMessagesStr += errors[i].message + '\n';
                } else
                    errorMessagesStr = " Ha ocurrido un error!!.";
                this.mensaje(cmp, null, toastEvent, "Error!", errorMessagesStr);
            }

        });
        $A.enqueueAction(action);
    },

    loadSolucionById: function(cmp, Id, recordMode) {

        var action = cmp.get("c.getSolutionByID");
        action.setParams({
            "id": Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                cmp.set('v.error', null);
                var solucion = response.getReturnValue();
                cmp.set('v.recordMode', recordMode);
                cmp.set('v.solucion', solucion);
                cmp.set('v.isOpen', true);

            } else if (state === 'ERROR') {

                var errors = response.getError();
                var errorMessagesStr = '\n';
                if (errors) {
                    for (var i = 0; i < errors.length; i++)
                        errorMessagesStr += errors[i].message + '\n';
                } else
                    errorMessagesStr = " Ha ocurrido un error!!.";
                this.mensaje(cmp, null, toastEvent, "Error!", errorMessagesStr);

            }

        });
        $A.enqueueAction(action);
    },

    loadEstadosSolucion: function(component) {
        var action = component.get("c.getEstadosSolucion");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.estados', result);
            } else {

                var errors = response.getError();
                var errorMessagesStr = '\n';
                if (errors) {
                    for (var i = 0; i < errors.length; i++)
                        errorMessagesStr += errors[i].message + '\n';
                } else
                    errorMessagesStr = " Ha ocurrido un error!!.";
                this.mensaje(component, null, toastEvent, "Error!", errorMessagesStr);
            }
        });
        $A.enqueueAction(action);
    },

    /*loadEtiquetasSolucion: function(component) {
        var action = component.get("c.getEtiquetasSolucion");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.etiquetas', result);
            } else {
                this.mensaje(component, null, toastEvent, "Error!", " Ha ocurrido un error!!.");
            }
        });
        $A.enqueueAction(action);
    },*/

    mensaje: function(component, event, toastEvent, titulo, mensaje) {
        component.set('v.error', null);
        if (toastEvent) {
            toastEvent.setParams({ "title": titulo, "message": mensaje });
            toastEvent.fire();
        } else {
            component.set("v.error", mensaje);

        }

    },

    listadoEtiquetas: function(component) {
        var listado = component.get('v.etiquetas');
        var etiquetasRecord = component.get('v.solucion.Etiquetas__c');
        if (etiquetasRecord != undefined) {
            var tags = etiquetasRecord.split(';');
            for (i = 0; i < tags.length; i++) {
                if (listado.indexOf(tags[i]) == -1) {
                    listado.push(tags[i]);
                }
            }
            component.set('v.etiquetas', listado);
        }

    },

    toogleMensaje: function(component) {
        component.set('v.display', 'display:block');
        setTimeout(function() {
            component.set('v.display', 'display:none');
            component.set("v.recordError", null);
            component.set("v.recordInfo", null);
        }, 5000);
    },

    definirParametros: function(component) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var sParameterName;
        var i;
        var parametros = {};
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName != undefined && sParameterName != "")
                parametros[sParameterName[0]] = sParameterName[1];

        }
        return parametros;
    },

    tamanoObjeto: function(object) {
        var object_size = 0;
        if (object != null) {
            var keys = Object.keys(object);
            for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
                if (object.hasOwnProperty(key)) {
                    object_size++;
                }
            }
        }
        return object_size;
    },

    recargarPagina: function() {
        var url = window.location.href;
        var urlPersonalizada = url.split(/[?#]/)[0];
        location.href = urlPersonalizada + "?";
    },

    closeModelCategoria: function(component, event) {
        var isOpenCategoria = event.getParam("isOpenCategoria");
        var isOpenCategoriaSelect = event.getParam("isOpenCategoriaSelect");
        var recordModeCategoriaSelect = event.getParam("recordModeCategoriaSelect");
        var itemId = event.getParam("itemId");
        var itemParentId = event.getParam("itemParentId");
        var items = event.getParam("items");
        var recordInfo = event.getParam("recordInfo");
        var toastEvent = $A.get("e.force:showToast");

        component.set("v.itemParentId", itemParentId);
        component.set("v.itemId", itemId);
        component.set("v.items", items);
        component.set("v.recordModeCategoriaSelect", recordModeCategoriaSelect);
        component.set("v.isOpenCategoria", isOpenCategoria);
        component.set("v.isOpenCategoriaSelect", isOpenCategoriaSelect);

        if (recordInfo != null && recordInfo != undefined && !toastEvent) {
            component.set("v.recordInfo", recordInfo);
            this.toogleMensaje(component);
        }
    },

    cerrarModalCategoriaSelect: function(component, event, helper) {
        var isOpen = event.getParam("isOpen");
        var isOpenCategoria = event.getParam("isOpenCategoria");
        var isOpenCategoriaSelect = event.getParam("isOpenCategoriaSelect");
        var itemId = event.getParam("itemId");
        var itemParentId = event.getParam("itemParentId");
        var items = event.getParam("items");
        var categorySolucion = event.getParam("categorySolucion");
        var recordModeCategoriaSelect = event.getParam("recordModeCategoriaSelect");
        if (isOpen) {
            var solucion = component.get("v.solucion");
            if (solucion != null)
                solucion.Categoria_Solucion__c = itemParentId;
            component.set("v.solucion", solucion);
        }
        if (categorySolucion != null && categorySolucion != undefined)
            component.set("v.categorySolucion", categorySolucion);
        component.set("v.items", items);
        component.set("v.itemParentId", itemParentId);
        component.set("v.itemId", itemId);
        component.set("v.isOpenCategoria", isOpenCategoria);
        component.set("v.isOpenCategoriaSelect", isOpenCategoriaSelect);
        component.set("v.isOpen", isOpen);

        if (recordModeCategoriaSelect == "findCategory")
            this.loadSolucionesByCategoria(component, false, false, 0);
    },

    eliminarCategoria: function(component, event) {
        var itemId = event.getParam("itemId");
        var itemParentId = event.getParam("itemParentId");
        var items = event.getParam("items");
        var isOpenCategoria = event.getParam("isOpenCategoria");
        component.set("v.itemId", itemId);
        component.set("v.itemParentId", itemParentId);
        component.set("v.items", items);
        component.set("v.isOpenCategoria", isOpenCategoria);
        component.set("v.deseaEliminarCategoria", true);
    },

    cerrarModalEliminarCategoria: function(component, event) {
        var itemId = event.getParam("itemId");
        var itemParentId = event.getParam("itemParentId");
        var isOpenCategoria = event.getParam("isOpenCategoria");
        var recordInfo = event.getParam("recordInfo");
        component.set("v.itemId", itemId);
        component.set("v.itemParentId", itemParentId);
        component.set("v.isOpenCategoria", isOpenCategoria);
        component.set("v.deseaEliminarCategoria", false);
        if (recordInfo != null && recordInfo != undefined) {
            component.set("v.recordInfo", recordInfo);
            this.toogleMensaje(component);
        }
    },

    showSpinner: function(component, event) {
        component.set("v.mostrarSpinner", true);
    },
    
    hideSpinner: function(component, event) {
        component.set("v.mostrarSpinner", false);
    },

})