/**
 * Clone Quote para Comercial
 * @author: Brayan Mullor S.
 * @date: 24-06-2020
 */
public without sharing class CloneQuoteComercial {

    @AuraEnabled
    public static Boolean clonarCotizacion(Id quoteId) {

        Boolean result = false;

        User datosUsuario = [SELECT id, Profile.Name FROM User WHERE ID =: userinfo.getuserid()];
        string var = datosUsuario.Profile.Name;

        if (datosUsuario.Profile.Name == ComercialConstants.profileEjecutivoTecnico 
            || datosUsuario.Profile.Name == ComercialConstants.profileJefaturaTecnico){

                Quote quoteValid = [SELECT Id, Es_clone__c FROM Quote WHERE Id =: quoteId];                

                Quote quote = [SELECT Id, Name, IdCotizacionComercial__c, Tipo_Cotizacion__c, Cantidad_de_opciones__c,
                Total_N_titulares__c, Tabla_cargos__c, Sin_cuenta_ano_en_curso_proyectada__c,
                Sin_cuenta_presentada_con_ONR__c, Comision__c, Observacion_cierre_area_tecnica__c,
                Ranking_propuesta__c, Suscriptor__c, Cantidad_de_cotizaciones_clonadas__c,
                OpportunityId
                FROM Quote WHERE Id =: quoteId];

                List<Productos_comercial__c> prodQuote = [SELECT Id, Id_Cotizacion__c, N_Titulares__c, Precio__c, Productos__c
                                                            FROM Productos_comercial__c WHERE Id_Cotizacion__c =: quoteId];
                                                            
                List<Cargos_comercial__c> chargeQuote = [SELECT Id, Id_Cotizacion__c, Precio__c, Cargos__c                                                  
                                                            FROM Cargos_comercial__c WHERE Id_Cotizacion__c =: quoteId];

                Quote quoteClone = asignarDatosQuote(quote);

                if(quoteClone != null){
                    try{
                        insert quoteClone;

                        //Se asignan los productos a la quote clonada
                        if(!prodQuote.isEmpty()){
                            List<Productos_comercial__c> prodQuoteClone = new List<Productos_comercial__c>();
                            Productos_comercial__c product = new Productos_comercial__c();
                            for(Productos_comercial__c pr: prodQuote){
                                product.Id_Cotizacion__c = quoteClone.Id;
                                product.N_Titulares__c = pr.N_Titulares__c;
                                product.Precio__c = pr.Precio__c;
                                product.Productos__c = pr.Productos__c;
                                prodQuoteClone.add(product);
                                product = new Productos_comercial__c();
                            }

                            insert prodQuoteClone;
                        }
                        
                        //Se asignan los productos a la quote clonada
                        if(!chargeQuote.isEmpty()){
                            List<Cargos_comercial__c> chargeQuoteClone = new List<Cargos_comercial__c>();
                            Cargos_comercial__c charge = new Cargos_comercial__c();
                            for(Cargos_comercial__c ch: chargeQuote){
                                charge.Id_Cotizacion__c = quoteClone.Id;
                                charge.Precio__c = ch.Precio__c;
                                charge.Cargos__c = ch.Cargos__c;
                                chargeQuoteClone.add(charge);
                                charge = new Cargos_comercial__c();
                            }

                            insert chargeQuoteClone;
                        }

                        //Modificar correlativo de la nueva quote
                        Quote quoteToCorr;
                        if(quoteValid.Es_clone__c){
                            Cotizaciones_clonadas__c quoteFather = [SELECT Id, Id_cotizacion_padre__c FROM Cotizaciones_clonadas__c WHERE Id_cotizacion_clonada__c =: quoteId LIMIT 1];
                            quoteToCorr = [SELECT Id, Cantidad_de_cotizaciones_clonadas__c,IdCotizacionComercial__c FROM Quote WHERE Id =:quoteFather.Id_cotizacion_padre__c LIMIT 1]; 
                        } else{
                            quoteToCorr = [SELECT Id, Cantidad_de_cotizaciones_clonadas__c,IdCotizacionComercial__c FROM Quote WHERE Id =:quoteId LIMIT 1]; 
                        }
                        Integer quoteQuantity = 0;
                        if(String.isBlank(String.valueOf(quoteToCorr.Cantidad_de_cotizaciones_clonadas__c))){
                            quoteQuantity = 1;
                        } else {
                            quoteQuantity = Integer.valueOf(quoteToCorr.Cantidad_de_cotizaciones_clonadas__c) + 1;
                        }

                        quoteClone.IdCotizacionComercial__c = quoteToCorr.IdCotizacionComercial__c + '-' + String.valueOf(quoteQuantity);
                        quoteClone.Suscriptor__c = quote.Suscriptor__c;
                        quoteClone.Status = ComercialConstants.qtStatusTarificacion;
                        update quoteClone;
                        quoteToCorr.Cantidad_de_cotizaciones_clonadas__c = quoteQuantity;
                        update quoteToCorr;

                        //Cargar la lista relacionada de la quote padre

                        Cotizaciones_clonadas__c newClone = new Cotizaciones_clonadas__c(
                            Id_cotizacion_padre__c = quoteToCorr.Id,
                            Correlativo_cotizacion__c = quoteClone.IdCotizacionComercial__c,
                            Id_cotizacion_clonada__c = quoteClone.Id
                        );

                        insert newClone;

                        result = true;

                    } catch (Exception e){
                        throw new AuraHandledException('Error clonando la cotización,   ' + e);          
                    }
                }

                return result;

        } else {
            throw new AuraHandledException('Sólo los usuarios del área técnica pueden generar nuevas cotizaciones');   
        }
    }

    public static Quote asignarDatosQuote(Quote quote){
        Quote qt = new Quote(
            Name = quote.Name,
            Tipo_Cotizacion__c = quote.Tipo_Cotizacion__c,
            Cantidad_de_opciones__c = quote.Cantidad_de_opciones__c,
            Total_N_titulares__c = quote.Total_N_titulares__c,
            Tabla_cargos__c = quote.Tabla_cargos__c,
            Sin_cuenta_ano_en_curso_proyectada__c = quote.Sin_cuenta_ano_en_curso_proyectada__c,
            Sin_cuenta_presentada_con_ONR__c = quote.Sin_cuenta_presentada_con_ONR__c,
            Comision__c = quote.Comision__c,
            Observacion_cierre_area_tecnica__c = quote.Observacion_cierre_area_tecnica__c,
            Ranking_propuesta__c = quote.Ranking_propuesta__c,            
            OpportunityId = quote.OpportunityId,
            Es_clone__c = true
        );

        return qt;
    }
}