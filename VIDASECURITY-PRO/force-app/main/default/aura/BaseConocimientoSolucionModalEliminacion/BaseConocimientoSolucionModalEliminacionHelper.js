({
	eliminarSolucion: function(component, event) {
		var action = component.get("c.deleteSolution");
		action.setParams({ "solucion": component.get("v.solucion") });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnValue = response.getReturnValue();
				var solucion = returnValue.solucion == undefined ? returnValue : returnValue.solucion;
				var hasErrors = returnValue.hasErrors == undefined ? false : returnValue.hasErrors;
				var errorMessages = returnValue.errorMessages == undefined ? [] : returnValue.errorMessages;
				var errorMessagesStr = '';
				if (hasErrors && errorMessages.length > 0) {
					errorMessagesStr = '\n';
					for (var i = 0; i < errorMessages.length; i++) {
						errorMessagesStr += errorMessages[i] + '\n';
					}
				}
				var toastEvent = $A.get("e.force:showToast");
				component.set("v.solucion", solucion);
				if (hasErrors && errorMessages.length > 0)
					this.mensaje(component, event, toastEvent, 'Error!', errorMessagesStr, true);
				else
					this.mensaje(component, event, toastEvent, 'Exito!', 'Solucion Eliminada exitosamente', false);
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
				this.actualizarListado(component);
				this.cerrarModalEliminarSolucion(component, mensaje);
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

	actualizarListado: function(component) {
		var actualizarListado = component.getEvent("actualizarListado");
		actualizarListado.fire();
	},

	cerrarModalEliminarSolucion: function(component, mensaje) {
		var recordInfo = mensaje;
		var cerrarModalEliminarSolucion = component.getEvent("cerrarModalEliminarSolucion");
		cerrarModalEliminarSolucion.setParams({ "isOpen": false, "solucion": null, "recordInfo": recordInfo });
		cerrarModalEliminarSolucion.fire();
	}
})