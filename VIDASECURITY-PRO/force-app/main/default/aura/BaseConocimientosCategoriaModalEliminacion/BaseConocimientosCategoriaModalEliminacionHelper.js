({
    eliminarCategoria: function(component, event) {
        var action = component.get("c.deleteCategory");
        var item = component.get("v.item");
        var itemId = component.get("v.itemId");
        action.setParams({ "identificador": itemId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (component.isValid() && state === "SUCCESS") {
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
                    this.mensaje(component, event, toastEvent, 'Error!', errorMessagesStr, true);
                else
                    this.mensaje(component, event, toastEvent, 'Exito!', 'Categoria Eliminada exitosamente', false);
            } else {
                this.mensaje(component, event, toastEvent, 'Error!', '!Ha ocurrido un Error en el servidor!');
            }
        });
        $A.enqueueAction(action);
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
                component.set("v.recordInfo", mensaje);
                 this.cerrarModalEliminarCategoria(component, mensaje, false);
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

    cerrarModalEliminarCategoria: function(component, mensaje, volverFormCategoria) {
        var recordInfo = mensaje;
        var itemId = component.get("v.itemId");
        var itemParentId = component.get("v.itemParentId");
        var cerrarModalEliminarCategoria = component.getEvent("cerrarModalEliminarCategoria");
        if(volverFormCategoria)
            cerrarModalEliminarCategoria.setParams({ "isOpenCategoria": true, "itemId": itemId, "itemParentId": itemParentId });
        else 
            cerrarModalEliminarCategoria.setParams({ "isOpenCategoria": false, "recordInfo": recordInfo });

        cerrarModalEliminarCategoria.fire();
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
    }
})