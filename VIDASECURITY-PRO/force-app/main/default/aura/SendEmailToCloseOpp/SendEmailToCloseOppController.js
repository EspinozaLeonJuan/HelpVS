({
	doInit : function(component) {
		var action = component.get("c.sendEmail");
        action.setParams({ oppId : component.get("v.recordId") });

		action.setCallback(this, function(response) {
			
            var state = response.getState();
            var result = response.getReturnValue();
				if(result == "0"){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Exito!",
						"message": "El correo se ha enviado satisfactoriamente.",
						"type": "success",
					});
					window.setTimeout(
						$A.getCallback(function() {
							toastEvent.fire();
						}), 2000
					);
					$A.get("e.force:closeQuickAction").fire();
				}
				if(result == "1"){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error",
						"message": "No hay correo de suscriptor asociado en las cotizaciones.",
						"type" : "error",
					});
					window.setTimeout(
						$A.getCallback(function() {
							toastEvent.fire();
						}), 2000
					);
					$A.get("e.force:closeQuickAction").fire();
				}
				if(result == "2"){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error",
						"message": "No hay cotizaciones en estado de tarificación.",
						"type" : "error",
					});
					window.setTimeout(
						$A.getCallback(function() {
							toastEvent.fire();
						}), 2000
					);
					$A.get("e.force:closeQuickAction").fire();
				}
				
        });


	    $A.enqueueAction(action);

	}
})