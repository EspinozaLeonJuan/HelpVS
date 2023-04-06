/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 01-18-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   01-05-2021   Juan Espinoza León   Initial Version
**/
global class VSL_AsignacionDeRanking Implements Schedulable{
    
    global void execute(SchedulableContext ctx)
    {
        asignarLinks();
    }
    
    global void asignarLinks(){
        
        System.debug('@@@@ Inicio asignar Links');
        //DECLARACIONES
        List<Opportunity> actualizarOportunidad = new List<Opportunity>();
        List<Link_Asignado__c> crearLinks = new List<Link_Asignado__c>();
        List<Opportunity> linkRestantesA = new List<Opportunity>();
        List<Opportunity> linkRestantesB = new List<Opportunity>();
        Date fecha = System.today().addDays(-7);
        Contact temp = null;
        
        //Date fechaLinks = System.today().addDays(-7);
        //CONSULTAS
        String linkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;
        List<Opportunity> obtenerLinks = [select id, Fecha_Entrevista__c, Name, Agente_de_Venta__c from Opportunity where Tipo_Link__c='Bases Normales' and Renta__c > 800000 and Region1__c = '013'
                                          and Ejecutivo_Post_Venta__c = null and Agente_de_Venta__c = null and StageName = 'Asignación' and RecordTypeId =: linkRecordType 
                                          and Fecha_de_Auditoria__c = today];
                                          //and Fecha_de_Auditoria__c >: fechaLinks];
        
        System.debug('obtenerLinks size  --> ' + obtenerLinks.size());

        System.debug('obtenerLinks l:39 --> ' + obtenerLinks);       


        List<Contact> obtenerAgenteA = [select id ,LastName , (select id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fecha) from contact where Ranking_de_agente__c = 'A' and Activo__c = true 
                                        and Tipo_Cargo__c = 'Agente' order by LastName];
        List<Contact> obtenerAgenteB = [select id ,LastName , (select id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fecha) from contact where Ranking_de_agente__c = 'B' and Activo__c = true 
                                        and Tipo_Cargo__c = 'Agente' order by LastName];
        List<Contact> obtenerAgenteC = [select id ,LastName , (select id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fecha) from contact where Ranking_de_agente__c = 'C' and Activo__c = true 
                                        and Tipo_Cargo__c = 'Supervisor FFVV' order by LastName];
        
         System.debug('@@@@ obtenerAgenteA size --> ' + obtenerAgenteA.size());
         System.debug('@@@@ obtenerAgenteA --> ' + obtenerAgenteA);

         System.debug('@@@@ obtenerAgenteB size --> ' + obtenerAgenteB.size());
         System.debug('@@@@ obtenerAgenteB --> ' + obtenerAgenteB);

         System.debug('@@@@ obtenerAgenteC size --> ' + obtenerAgenteC.size());
         System.debug('@@@@ obtenerAgenteC --> ' + obtenerAgenteC);
        
        Long cantidadA = (obtenerLinks.size() * 0.5).round(System.RoundingMode.HALF_UP);  
        Long cantidadB = (obtenerLinks.size() * 0.35).round(System.RoundingMode.HALF_UP);
        Long cantidadC = (obtenerLinks.size() * 0.15).round(System.RoundingMode.HALF_UP);
        
        System.debug('cantidadA ' + cantidadA);
        System.debug('cantidadB ' + cantidadB);
        System.debug('cantidadC ' + cantidadC);
        
        //ORDENAR LISTA DE AGENTES A POR CANTIDAD DE OPORTUNIDADES 
        for (Integer i = 0; i < obtenerAgenteA.size() ; i++) 
        {
            for (Integer j = i + 1; j < obtenerAgenteA.size(); j++) { 
                if (obtenerAgenteA[i].Links__r.size() > obtenerAgenteA[j].Links__r.size()) 
                { 
                    temp = obtenerAgenteA[i];
                    obtenerAgenteA[i] = obtenerAgenteA[j];
                    obtenerAgenteA[j] = temp;
                }
            }
        } 
        
        //ORDENAR LISTA DE AGENTES B POR CANTIDAD DE OPORTUNIDADES
        for (Integer i = 0; i < obtenerAgenteB.size() ; i++) 
        {
            for (Integer j = i + 1; j < obtenerAgenteB.size(); j++) { 
                if (obtenerAgenteB[i].Links__r.size() > obtenerAgenteB[j].Links__r.size()) 
                { 
                    temp = obtenerAgenteB[i];
                    obtenerAgenteB[i] = obtenerAgenteB[j];
                    obtenerAgenteB[j] = temp;
                }
            }
        } 
        
        
        //ORDENAR LISTA DE AGENTES C POR CANTIDAD DE OPORTUNIDADES        
        for (Integer i = 0; i < obtenerAgenteC.size() ; i++) 
        {
            for (Integer j = i + 1; j < obtenerAgenteC.size(); j++) { 
                if (obtenerAgenteC[i].Links__r.size() > obtenerAgenteC[j].Links__r.size()) 
                { 
                    temp = obtenerAgenteC[i];
                    obtenerAgenteC[i] = obtenerAgenteC[j];
                    obtenerAgenteC[j] = temp;
                }
            }
        } 
        
        
        //ASIGNAR OPORTUNIDAD A AGENTES DISPONIBLES A
        Integer removerAgenteA = 0;
        Integer contarAsignacionA = 0;
        for(Integer i = 0; i < obtenerLinks.size(); i++){
            if(contarAsignacionA < cantidadA){
                for(Contact agenteA : obtenerAgenteA){  
                    //SI TIENE ENTREVISTA VALIDAR QUE TENGA DISPONIBILIDAD   
                    if(agenteA.Links__r.size() > 0){
                        boolean tieneEntrevista = false;
                        for(Link_Asignado__c link : agenteA.Links__r){
                            if(link.Fecha_Link__c == obtenerLinks[i].Fecha_Entrevista__c){
                                tieneEntrevista = true;           
                            }
                        }
                        if(tieneEntrevista == false){
                            System.debug('obtenerLinks: ' + obtenerLinks[i] + ' -> ' + agenteA.LastName);
                            obtenerLinks[i].Agente_de_Venta__c = agenteA.Id;
                            actualizarOportunidad.add(obtenerLinks[i]);
                            crearLinks.add(new Link_Asignado__c(Name = obtenerLinks[i].Name, Contacto__c = agenteA.Id, Fecha_Link__c = obtenerLinks[i].Fecha_Entrevista__c));
                            obtenerAgenteA.remove(removerAgenteA);
                            break;
                        }
                    }else{//SI NO TIENE ENTREVISTAS ASIGNAR
                        System.debug('obtenerLinks: ' + obtenerLinks[i] + ' -> ' + agenteA.LastName);
                        obtenerLinks[i].Agente_de_Venta__c = agenteA.Id;
                        actualizarOportunidad.add(obtenerLinks[i]);
                        crearLinks.add(new Link_Asignado__c(Name = obtenerLinks[i].Name, Contacto__c = agenteA.Id, Fecha_Link__c = obtenerLinks[i].Fecha_Entrevista__c));
                        obtenerAgenteA.remove(removerAgenteA);
                        break;
                    }
                    removerAgenteA++;
                }
            }
            if(obtenerLinks[i].Agente_de_Venta__c != null){
                contarAsignacionA++;  
            }else{
                linkRestantesA.add(obtenerLinks[i]);
            }
        }

        System.debug('@@@@ obtenerLinks l:147 --> ' + obtenerLinks);       
        
        System.debug('@@@@ linkRestantesA ' + linkRestantesA.size());
        
        System.debug('@@@@ crearLinks l 152 --> ' + crearLinks);

        //ASIGNAR OPORTUNIDAD A AGENTES DISPONIBLES B
        Integer removerAgenteB = 0;
        Integer contarAsignacionB = 0;
        for(Integer i = 0; i < linkRestantesA.size(); i++){ 
            if(contarAsignacionB < cantidadB){
                for(Contact agenteB : obtenerAgenteB){  
                    //SI TIENE ENTREVISTA VALIDAR QUE TENGA DISPONIBILIDAD
                    if(agenteB.Links__r.size() > 0){
                        boolean tieneEntrevista = false;
                        for(Link_Asignado__c link : agenteB.Links__r){
                            if(link.Fecha_Link__c == linkRestantesA[i].Fecha_Entrevista__c){
                                tieneEntrevista = true;           
                            }     
                        }
                        if(tieneEntrevista == false){
                            System.debug('linkRestantesA: ' + linkRestantesA[i] + ' -> ' + agenteB.LastName);
                            linkRestantesA[i].Agente_de_Venta__c = agenteB.Id;
                            actualizarOportunidad.add(linkRestantesA[i]);
                            crearLinks.add(new Link_Asignado__c(Name = linkRestantesA[i].Name, Contacto__c = agenteB.Id, Fecha_Link__c = linkRestantesA[i].Fecha_Entrevista__c));
                            obtenerAgenteB.remove(removerAgenteB);
                            break;
                        }
                    }else{//SI NO TIENE ENTREVISTAS ASIGNAR
                        System.debug('linkRestantesA: ' + linkRestantesA[i] + ' -> ' + agenteB.LastName);
                        linkRestantesA[i].Agente_de_Venta__c = agenteB.Id;
                        actualizarOportunidad.add(linkRestantesA[i]);
                        crearLinks.add(new Link_Asignado__c(Name = linkRestantesA[i].Name, Contacto__c = agenteB.Id, Fecha_Link__c = linkRestantesA[i].Fecha_Entrevista__c));
                        obtenerAgenteB.remove(removerAgenteB);
                        break;
                    }
                    removerAgenteB++;
                }   
            }
            if(linkRestantesA[i].Agente_de_Venta__c != null){
                contarAsignacionB++;
            }else{
                linkRestantesB.add(linkRestantesA[i]); 
            }
        }

        System.debug('@@@@ linkRestantesA l 191 --> ' + linkRestantesA);
       
        
        //ASIGNAR OPORTUNIDAD A AGENTES C
        Integer contarAsignacionC = 0;
        for(Integer i = 0; i < linkRestantesB.size(); i++){ 
            if(contarAsignacionC == obtenerAgenteC.size()){
                contarAsignacionC = 0;
            }  
            linkRestantesB[i].Agente_de_Venta__c = obtenerAgenteC[contarAsignacionC].Id; 
            actualizarOportunidad.add(linkRestantesB[i]);
            contarAsignacionC++;    
        }
        
        if(crearLinks.size() > 0){
            insert crearLinks;
        }

        System.debug('@@@@ crearLinks l 209 --> ' + crearLinks);
       
        if(actualizarOportunidad.size() > 0){
            update actualizarOportunidad;
        }    

        System.debug('@@@@ actualizarOportunidad l 212 --> ' + actualizarOportunidad);
    }
}