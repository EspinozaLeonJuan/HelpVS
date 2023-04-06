({
    loadCategorias: function(component) {

        var action = component.get("c.getCategorias");
        action.setCallback(this, function(response) {

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                component.set('v.recordError', null);
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
        var itemId = component.get("v.itemId");
        var items = component.get("v.items");
        var recordMode = component.get("v.recordMode");
        var cerrarModal = component.getEvent("cerrarModalCategoriaSelect");
        if (recordMode == 'chooseCategory')
            cerrarModal.setParams({ "items": items, "itemId": itemId, "isOpenCategoria": false, "isOpenCategoriaSelect": false, "isOpen": true });
        else if (recordMode == 'findCategory')
            cerrarModal.setParams({ "isOpenCategoria": false, "isOpenCategoriaSelect": false, "isOpen": false });
        else
            cerrarModal.setParams({ "itemId": itemId, "isOpenCategoria": true, "isOpenCategoriaSelect": false });
        cerrarModal.fire();
    },

    itemSelected: function(component, event) {
        var itemParentId = component.get("v.itemParentId");
        var itemId = component.get("v.itemId");
        if (itemParentId == itemId) {
            var toastEvent = $A.get("e.force:showToast");
            this.mensaje(component, null, toastEvent, "Error!", "Una Categoría no puede ser asignada a si misma, por favor elija otra");
        } else {
            var items = component.get("v.items");
            var cerrarModal = component.getEvent("cerrarModalCategoriaSelect");
            cerrarModal.setParams({ "items": items, "itemId": itemId, "itemParentId": itemParentId, "isOpenCategoria": true, "isOpenCategoriaSelect": false });
            cerrarModal.fire();
        }

    },

    chooseCategory: function(component, event) {
        var itemParentId = component.get("v.itemParentId");
        var itemId = component.get("v.itemId");
        var recordMode = component.get("v.recordMode");
        var items = component.get("v.items");
        var cerrarModal = component.getEvent("cerrarModalCategoriaSelect");
        var itemSelected = this.searchItem(component, itemParentId, items);
        var categorySolucion = itemSelected.label;
        cerrarModal.setParams({ "categorySolucion": categorySolucion, "items": items, "itemId": itemId, "itemParentId": itemParentId, "isOpenCategoria": false, "isOpenCategoriaSelect": false, "isOpen": true });
        cerrarModal.fire();
    },

    findCategory: function(component, event) {
        var itemParentId = component.get("v.itemParentId");
        var recordMode = component.get("v.recordMode");
        var cerrarModal = component.getEvent("cerrarModalCategoriaSelect");
        cerrarModal.setParams({ "itemParentId": itemParentId, "isOpenCategoria": false, "isOpenCategoriaSelect": false, "isOpen": false, "recordModeCategoriaSelect": recordMode });
        cerrarModal.fire();
    },

    searchItem: function(component, value, array) {
        var recordMode = component.get("v.recordMode");

        //busco en las categorias principales
        if (array != null) {
            for (var i = 0; i < array.length; i++) {
                if (array[i].name == value) {
                   return array[i];
                } else if (array[i].items != undefined && array[i].items.length > 0) {
                    var result = this.searchItem(component, value, array[i].items);
                    if (result != null){
                        return result;
                    }
                }
            }
        }

        return null;
    },

    mensaje: function(component, event, toastEvent, titulo, mensaje) {
        component.set('v.recordError', null);
        if (toastEvent) {
            toastEvent.setParams({ "title": titulo, "message": mensaje });
            toastEvent.fire();
        } else {
            component.set("v.recordError", mensaje);

        }

    },

    toogleMensaje: function(component) {
        component.set('v.display', 'display:block');
        setTimeout(function() {
            component.set('v.display', 'display:none');
            component.set("v.recordError", null);
        }, 5000);
    }

})