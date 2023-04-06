({	
	doInit: function(component, event, helper) {

        var arrayItems = component.get("v.items");
        var itemId = component.get("v.itemId");
        var itemParentId = component.get("v.itemParentId");
        console.log("modal eliminacion items");
		console.log(arrayItems);
		console.log("modal eliminacion itemId");
		console.log(itemId);
		console.log("modal eliminacion itemParentId");
		console.log(itemParentId);
        if(itemId!=null && itemId!=undefined){
            var itemResult = helper.searchItem(component, itemId, arrayItems);
            console.log('itemResult');
            console.log(itemResult);
            if(itemResult!=undefined && itemResult!= null)
                component.set("v.item", itemResult);
        }
    },
	cerrarModalEliminarCategoria : function(component, event, helper) {
		helper.cerrarModalEliminarCategoria(component, null, true);
	},
	
	eliminarCategoria : function(component, event, helper) {
		helper.eliminarCategoria(component);
	}
})