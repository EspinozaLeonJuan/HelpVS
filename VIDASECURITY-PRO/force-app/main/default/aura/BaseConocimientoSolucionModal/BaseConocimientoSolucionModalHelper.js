({
    init: function(component) {

        $(document).ready(function() {
            $('.slds-modal__content').css('overflow-y', 'auto'); 
            $('.slds-modal__content').css('min-height', screen.height * 0.80);
            $('.slds-modal__content').css('max-height', screen.height * 0.90);

            $("#modal-content").focus();
            $("#modal-content").keyup(function(event) {
                if (event.keyCode == 27) {
                    var cerrarModal = component.getEvent("cerrarModal");
                    cerrarModal.setParams({ "isOpen": false, "solucion": null });
                    cerrarModal.fire();
                }
            });

        });

        if (component.get('v.recordMode') == 'view') {
            $('div[role=toolbar]').css('display', 'none');
        }

        $('div.ql-editor.slds-rich-text-area__content.slds-text-color--weak.slds-grow').linkify({
            target: "_blank"
        });
        var mf = component.get('v.mapFieldsUpdateable');
        console.log('SM mapFieldsUpdateable');
        console.log(mf.SolutionNote);

    },
    guardarSolucion: function(component, event, metodo) {
        var action = component.get("c.saveSolution");
        var solucion = component.get("v.solucion");
        console.log('solucion a guardar : ' );
        console.log(solucion);
        action.setParams({ "solucion": solucion });
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
                solucion.sobjectType = 'Solution';
                component.set("v.solucion", solucion);

                if (hasErrors && errorMessages.length > 0)
                    this.mensaje(component, event, toastEvent, 'Error!', errorMessagesStr, hasErrors);
                else
                    this.mensaje(component, event, toastEvent, 'Exito!', 'Solucion Guardada exitosamente', false);

            } else {
                this.mensaje(component, event, toastEvent, 'Error!', action.getError(), true);
            }

        });
        $A.enqueueAction(action);

    },

    mensaje: function(component, event, toastEvent, titulo, mensaje, hasErrors) {
        if (toastEvent) {
            toastEvent.setParams({ "title": titulo, "message": mensaje });
            toastEvent.fire();
            if (!hasErrors){
                this.actualizarListado(component);
                this.cerrarModal(component, mensaje);
            }
        } else {
            if (hasErrors) {
                component.set("v.recordError", mensaje);
                this.toogleMensaje(component, 'v.display');
            } else {
                component.set("v.recordInfo", mensaje);
                this.actualizarListado(component);
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

    actualizarListado: function(component) {
        var actualizarListado = component.getEvent("actualizarListado");
        actualizarListado.fire();
    },

    cerrarModal: function(component, mensaje, isOpenCategoriaSelect) {
        var cerrarModal = component.getEvent("cerrarModal");
        var recordInfo = mensaje;
        var solutionName = component.find("SolutionName").get("v.value");
        var solutionNote = component.find("SolutionNote").get("v.value");
        var solutionIsPublished = component.find("SolutionPublished").get("v.checked");
        var solutionPublishedInPublicKb = component.find("SolutionPublishedInPublicKb").get("v.checked"); 
        var estados = component.find("estados").get("v.value"); 
        cerrarModal.setParams({ "solutionStatus" : estados, "solutionNote": solutionNote, "solutionName" : solutionName, "isPublished" : solutionIsPublished,  "isPublishedKb" : solutionPublishedInPublicKb, "recordModeCategoriaSelect":"chooseCategory", "isOpen": false, "recordInfo": recordInfo, "isOpenCategoriaSelect" : isOpenCategoriaSelect });
        cerrarModal.fire();
    },

    setUrlBySolucion: function(solucion) {
        var url = window.location.href;
        var urlPersonalizada = url.split(/[?#]/)[0];
        window.history.replaceState("", "Base Conocimientos", urlPersonalizada + "?recordMode=external&Id=" + solucion.Id);
    },

    deleteCategory : function(component, event){
        var solucion = component.get("v.solucion");
        solucion.Categoria_Solucion__c = null;
        component.set("v.solucion", solucion);
        component.set("v.categorySolucion", "");
    },

    showSpinner: function(component, event) {
        component.set("v.mostrarSpinner", true);
    },
    
    hideSpinner: function(component, event) {
        component.set("v.mostrarSpinner", false);
    }
})