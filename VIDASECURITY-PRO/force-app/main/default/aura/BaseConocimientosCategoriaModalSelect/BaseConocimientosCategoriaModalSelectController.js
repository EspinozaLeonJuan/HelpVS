({  
    doInit: function(component, event, helper) {
        var itemId = component.get("v.itemId");
        var arrayItems = component.get("v.items");
        if(arrayItems==null || arrayItems == undefined){
            helper.loadCategorias(component);
            arrayItems = component.get("v.items");
        }

        if(itemId!=undefined && itemId!=null){
            var item = helper.searchItem(component, itemId, arrayItems);
            component.set("v.item", item);  
            component.set("v.itemId", itemId);      
        } 

    },
    handleSelect: function(component, event, helper) {
        var myName = event.getParam('name');
        console.log('myName');
        console.log(myName);
        var arrayItems = component.get("v.items");
        var itemResult = helper.searchItem(component, myName, arrayItems);     
        component.set("v.itemSelected", itemResult);
        component.set("v.itemParentId", itemResult.name);
        var recordMode = component.get("v.recordMode");
        if(recordMode=='findCategory')
            helper.findCategory(component, event);
    },
    cerrarModal: function(component, event, helper) {
        helper.cerrarModal(component);
    },

    selectCategory : function(component, event, helper){
        var recordMode = component.get("v.recordMode");
        if (recordMode == 'chooseCategory')
            try {
				helper.chooseCategory(component, event);

			} catch (error) {
  			console.error(error);
  // expected output: ReferenceError: nonExistentFunction is not defined
  // Note - error messages will vary depending on browser
}
                    	
        else if(recordMode=='selectParent')
            helper.itemSelected(component, event);
        else if(recordMode=='findCategory')
            helper.findCategory(component, event);
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