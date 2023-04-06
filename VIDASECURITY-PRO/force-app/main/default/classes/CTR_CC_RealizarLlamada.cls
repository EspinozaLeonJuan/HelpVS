/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-06-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class CTR_CC_RealizarLlamada {
   
    public String requestLabel { get; set; }

    public String Code { get; set; }

    public String IdTarea { get; set; }

    OBJ_WS_CC_RealizaLlamada Llamada { get; set; }

    public String CoL { get; set; }

    public String CoLId { get; set; }


    public CTR_CC_RealizarLlamada()
    {

    }

    public PAR_EXT_WS_RealizaLlamada call { get; set;}

    public Object postCall(){
        System.debug('--- CTR_CC_LlamadaAgente.postCall BEGIN');
        try 
        {
            this.call = new PAR_EXT_WS_RealizaLlamada();
            this.call.Rut =  apexpages.currentpage().getparameters().get('RUT');
            this.call.Desde = apexpages.currentpage().getparameters().get('Anexo');
            this.call.Hasta = apexpages.currentpage().getparameters().get('NumeroLlamada');
            this.call.Usuario = apexpages.currentpage().getparameters().get('Usuario');
            this.call.Id = apexpages.currentpage().getparameters().get('Id');
            this.IdTarea = apexpages.currentpage().getparameters().get('IdTarea');
            this.CoL = apexpages.currentpage().getparameters().get('CoL');
            this.CoLId = apexpages.currentpage().getparameters().get('CoLId');

            system.debug('@@@@ call '+this.call);
            System.HttpRequest request = EXT_WS_CC_RealizaLLamada.postCall(call);
            System.debug('@@@@ request --> '+ request);
            Continuation cont = getContinuation(request); 
            return cont;
            
        } catch (Exception e) {
           // System.debug(e);
           // PageUtils.addError(e);
            //return redirectoToStd();
            System.debug(e);
            //return PageUtils.addError(e);
            return null;//cambiar por pagina de error 
        }
    }

    private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- CTR_CC_LlamadaAgente.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(40);
        ctx.continuation.continuationMethod = 'checkPostCall';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);

        this.requestLabel = ctx.requestLabel;
        
        System.debug('@@@@ response --> '+ System.Continuation.getResponse(this.requestLabel));
        return ctx.continuation;
    }

    public Object checkPostCall(){
        System.debug('--- CTR_CC_LlamadaAgente.checkPostCall BEGIN');
        
        try { 
            HttpResponse response;
        
            if (!Test.isRunningTest())
            {
                response = System.Continuation.getResponse(this.requestLabel);
            }
            else
            {
                response = new HttpResponse();
                response.setBody('');
                response.setStatus('222');
                response.setStatusCode(202);
            }
            
            System.debug('@@@@ response --> '+ response);
            this.Llamada  = new OBJ_WS_CC_RealizaLlamada();

            this.Llamada.StatusCode = response.getStatusCode();
            this.Llamada.Status = response.getStatus();
            this.Llamada.Body = response.getBody();

            System.debug('@@@@  this.Llamada.StatusCode --> '+  this.Llamada.StatusCode);
            System.debug('@@@@ this.Llamada.Status --> '+ this.Llamada.Status);
            System.debug('@@@@ this.Llamada.Body --> '+ this.Llamada.Body);

            if (this.CoL == 'C')
            {
                String LogId = CLS_CC_LogContactCenter.InsertLog_Account(this.CoLId, this.IdTarea, 9, this.call.Desde, this.call.Hasta,'', this.llamada.Body); 
            }
            else  if (this.CoL == 'L')
            {
                String LogId = CLS_CC_LogContactCenter.InsertLog_Lead(this.CoLId, this.IdTarea, 9, this.call.Desde, this.call.Hasta,'', this.llamada.Body);
            }

            if (this.IdTarea != '0')
            {
                Task tareaUpdate = [SELECT Id, Status FROM Task WHERE Id =: this.IdTarea];

                if (this.Llamada.StatusCode == 201)
                {
                    this.Llamada.Message = 'Llamada Realizada Correctamente.';
                    tareaUpdate.Status = 'Completada';
                }
                else if (this.Llamada.StatusCode == 400)
                {
                    this.Llamada.Message = 'No se puede realizar la llamada. Request incorrecto.';
                    tareaUpdate.Status = 'Descartada';
                }
                else if (this.Llamada.StatusCode == 428)
                {
                    this.Llamada.Message = 'No se puede realizar la llamada. Favor verifique si se encuentra conectado a la central telefonica o el origen es un anexo válido.';
                    tareaUpdate.Status = 'Descartada';
                }
                else if (this.Llamada.StatusCode == 500)
                {
                    this.Llamada.Message = 'No se puede realizar la llamada. Ha ocurrido un error.';
                    tareaUpdate.Status = 'Descartada';
                }
                
                update tareaUpdate;
            }

            PageReference page = new PageReference('/apex/SEC_VF_CC_LlamadaResultado');
            page.getParameters().put('Code', String.valueOf(this.Llamada.StatusCode));
            page.setRedirect(true);         
            return page; 
            
        } catch (Exception e) {
            System.debug(e);
            //return PageUtils.addError(e);
            return null;//cambiar por pagina de error 
        }
       
    }


    public Pagereference loadResponse()
    {
        this.Code = apexpages.currentpage().getparameters().get('Code');
        
        return null;
    }

}