({
    loadCategorias: function(component) {

        var action = component.get("c.getCategorias");
        action.setCallback(this, function(response) {

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                component.set('v.error', null);
                var result = response.getReturnValue();
                component.set("v.items", result);

            } else if (state === 'ERROR') {
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

    cerrarModal: function(component, mensaje) {
        var cerrarModal = component.getEvent("cerrarModalCategoria");
        if (mensaje != undefined && mensaje != null)
            cerrarModal.setParams({ "isOpenCategoria": false, "isOpenCategoriaSelect": false, "recordInfo": mensaje });
        else
            cerrarModal.setParams({ "isOpenCategoria": false, "isOpenCategoriaSelect": false });
        cerrarModal.fire();
    },

    openModalCategoriaSelect: function(component) {
        var itemId = component.get("v.itemId");
        var items = component.get("v.items");
        var cerrarModal = component.getEvent("cerrarModalCategoria");
        cerrarModal.setParams({ "items": items, "isOpenCategoria": false, "isOpenCategoriaSelect": true, "recordModeCategoriaSelect": "selectParent", "itemId": itemId });
        cerrarModal.fire();
    },

    searchItem: function(component, value, array) {
        //busco en las categorias principales
        if (array != null) {
            for (var i = 0; i < array.length; i++) {
                if (array[i].name == value) {
                    return array[i];
                } else if (array[i].items != undefined && array[i].items.length > 0) {
                    var result = this.searchItem(component, value, array[i].items);
                    if (result != null)
                        return result;
                }

            }
        }

        return null;
    },

    setParent: function(component, event, helper, itemParent) {
        if (itemParent != undefined && itemParent != null)
            component.set("v.recordItemParent", itemParent);
        else
            component.set("v.recordItemParent", { identificador: null, label: '' });
        component.set("v.recordMode", "edit");
    },

    setTitle: function(component) {
        var recordMode = component.get("v.recordMode");
        if (recordMode == "manage")
            component.set("v.titleModal", "Administración de categorías");
        else
            component.set("v.titleModal", "Seleccione una categoría");
    },

    guardarCategoria: function(component, event, categoryValue, categoryId, categoryParentId) {


        if (this.isValidNameCategory(categoryValue)) {
            var action = component.get("c.saveCategory");
            action.setParams({ "identificador": categoryId, "parentId": categoryParentId, "label": categoryValue });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                if (state === "SUCCESS") {
                    component.set('v.recordError', null);
                    var returnValue = response.getReturnValue();
                    var hasErrors = returnValue.hasErrors == undefined ? false : returnValue.hasErrors;
                    var errorMessages = returnValue.errorMessages == undefined ? [] : returnValue.errorMessages;
                    var errorMessagesStr = '';
                    if (hasErrors && errorMessages.length > 0) {
                        errorMessagesStr = '\n';
                        for (var i = 0; i < errorMessages.length; i++) {
                            errorMessagesStr += errorMessages[i] + '\n';
                        }
                    }
                    if (hasErrors && errorMessages.length > 0)
                        this.mensaje(component, event, toastEvent, 'Error!', errorMessagesStr, hasErrors);
                    else
                        this.mensaje(component, event, toastEvent, 'Exito!', 'Categoria Guardada exitosamente', false);
                } else if (state === 'ERROR') {
                    console.log('ERROR');
                    //console.log(response);
                    this.mensaje(component, null, toastEvent, "Error!", " Ha ocurrido un error!!.", true);
                }
            });
            $A.enqueueAction(action);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            this.mensaje(component, null, toastEvent, "Error!", "Debe ingresar un nombre valido para la categoría", true);
        }

    },

    mensaje: function(component, event, toastEvent, titulo, mensaje, hasErrors) {
        if (toastEvent) {
            toastEvent.setParams({ "title": titulo, "message": mensaje });
            toastEvent.fire();
        } else {
            if (hasErrors) {
                component.set("v.recordError", mensaje);
                this.toogleMensaje(component, 'v.display');
            } else {
                this.cerrarModal(component, mensaje);
            }


        }

    },

    toogleMensaje: function(component, contenedor) {
        component.set(contenedor, 'display:block');
        setTimeout(function() {
            component.set('v.display', 'display:none');
            component.set("v.recordError", null);
        }, 5000);
    },

    isValidNameCategory: function(name) {
        var respuesta = true;
        if (name == undefined || name == null || name == '')
            respuesta = false;
        return respuesta;
    },

    eliminarCategoria: function(component, event, itemId, parentId, items) {
        var eliminarSolucion = component.getEvent("eliminarCategoria");
        eliminarSolucion.setParams({ "items": items, "itemId": itemId, "isOpenCategoria": false, "itemParentId": parentId });
        eliminarSolucion.fire();
    },

    showSpinner: function(component, event) {
        component.set("v.mostrarSpinner", true);
    },
        
    hideSpinner: function(component, event) {
        component.set("v.mostrarSpinner", false);
    }

})