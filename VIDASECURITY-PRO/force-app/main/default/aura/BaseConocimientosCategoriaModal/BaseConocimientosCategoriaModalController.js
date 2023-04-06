({
    doInit: function(component, event, helper) {
        helper.loadCategorias(component);
        var arrayItems = component.get("v.items");
        var itemId = component.get("v.itemId");
        var itemParentId = component.get("v.itemParentId");
        if(itemId!=null && itemId!=undefined){
            var itemResult = helper.searchItem(component, itemId, arrayItems);
            if(itemResult!=undefined && itemResult!= null){
                component.set("v.itemId", itemResult.identificador);
                component.set("v.itemSelected", itemResult);
                component.set("v.recordItem", itemResult);
            } else {
                component.set("v.recordItem", {identificador: null , label: ''});
                component.set("v.itemSelected", {identificador: null , label: ''});
            }
            
            var itemParent = helper.searchItem(component, itemParentId, arrayItems);
            helper.setParent(component, event, helper, itemParent);
        } else {
            component.set("v.recordItem", {identificador: null , label: ''});
            component.set("v.itemSelected", {identificador: null , label: ''});
        }

        helper.setTitle(component);
    },
    handleSelect: function(component, event, helper) {
        var name = event.getParam('name');
        var arrayItems = component.get("v.items");
        var itemResult = helper.searchItem(component, name, arrayItems);        
        var itemParent;
        if(itemResult!=undefined && itemResult!=null){
            component.set("v.itemSelected", itemResult);
            component.set("v.itemId", itemResult.identificador);
            component.set("v.recordItem", itemResult);
            itemParent = helper.searchItem(component, itemResult.parentId, arrayItems);
            helper.setParent(component, event, helper, itemParent);
        } else {
            component.set("v.recordItem", {identificador: null , label: ''});
            component.set("v.itemSelected", {identificador: null , label: ''});
        }
    },

    cerrarModal: function(component, event, helper) {
        helper.cerrarModal(component);
    },

    cerraModalEliminarCategoria: function(component, event, helper) {
        component.set("v.deseaEliminarCategoria", false);
    },

    newCategory: function(component, event, helper) {
        var itemSelected = component.get("v.itemSelected");
        component.set("v.recordItem", {identificador: null , label: ''});
        if(itemSelected!=undefined && itemSelected!=null)
            component.set("v.recordItemParent", itemSelected);
        else 
            component.set("v.recordItemParent", {identificador: null , label: ''});

        component.set("v.recordMode", "new");

    },

    editCategory: function(component, event, helper) {
        component.set("v.recordMode", "edit");
    },

    editParentCategory: function(component, event, helper) {
        helper.openModalCategoriaSelect(component);
    },

    deleteParentCategory : function(component, event, helper){
        component.set("v.recordItemParent", {identificador: null , label: ''});
    },

    guardarCategoria : function(component, event, helper){     
        var categoryValue = component.find("CategoryName").get("v.value");
        var categoryId = component.find("CategoryName").get("v.id");
        var categoryParentId = component.find("CategoryNameParent").get("v.id");
        helper.guardarCategoria(component, event, categoryValue, categoryId, categoryParentId);
    },

    eliminarCategoria: function(component, event, helper) {
        var categoryId = component.find("CategoryName").get("v.id");
        var items = component.get("v.items");
        var categoryParentId = component.find("CategoryNameParent").get("v.id");

        helper.eliminarCategoria(component, event, categoryId, categoryParentId, items);
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