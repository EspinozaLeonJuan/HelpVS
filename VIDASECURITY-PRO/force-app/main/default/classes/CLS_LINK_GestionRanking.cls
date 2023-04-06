/**
* @description : 
* @author : Juan Espinoza León
* @group : 
* @last modified on : 05-13-2021
* @last modified by : Juan Espinoza León
* Modifications Log 
* Ver Date Author Modification
* 1.0 02-05-2021 Juan Espinoza León Initial Version
**/
public class CLS_LINK_GestionRanking {

    public class Agente
    {
        public Contact info {get; set;}

        public Integer Asignado { get; set;}
    }   

    public CLS_LINK_GestionRanking() {

    }

    public static String linkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;
    
    public static void GestionarLinks(Date fechaAuditoria, Date fechaConteo)
    {
        System.debug('@@@@ Inicio asignar Links'); 
        List<Opportunity> Oportunidades = [select id, Fecha_Entrevista__c, Name, Agente_de_Venta__c, agente_asignado__c, asignacion_automatica__c from Opportunity where Renta__c >= 800000 and (Region1__c = null or Region1__c = '013') 
        and Ejecutivo_Post_Venta__c = null and Agente_de_Venta__c = null and StageName = 'Asignación' and RecordTypeId =: linkRecordType 
        and Fecha_de_Auditoria__c =: fechaAuditoria];

        System.debug('@@@@ Links size --> ' + Oportunidades.size());
        System.debug('@@@@ Links --> ' + Oportunidades); 
    
        Long links_cantidad_A = (Oportunidades.size() * 0.5).round(System.RoundingMode.HALF_UP);         
        Long links_cantidad_B = (Oportunidades.size() * 0.35).round(System.RoundingMode.HALF_UP);
        Long links_cantidad_C = (Oportunidades.size() * 0.15).round(System.RoundingMode.HALF_UP);
    
        System.debug('cantidadA ' + links_cantidad_A);
        System.debug('cantidadB ' + links_cantidad_B);
        System.debug('cantidadC ' + links_cantidad_C);
    
        List<Contact> agentes_A = [SELECT id ,LastName , (SELECT id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fechaConteo) FROM Contact WHERE Ranking_de_agente__c = 'A' AND Activo__c = true 
                                   AND Tipo_Cargo__c = 'Agente' ORDER BY LastName];
    
        List<Contact> agentes_B = [SELECT id ,LastName , (SELECT id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fechaConteo) FROM Contact WHERE Ranking_de_agente__c = 'B' AND Activo__c = true 
                                   AND Tipo_Cargo__c = 'Agente' ORDER BY  LastName];
    
        List<Contact> agentes_C = [SELECT id ,LastName , (SELECT id, Fecha_Link__c from Links__r where Fecha_Link__c >= : fechaConteo) FROM Contact WHERE Ranking_de_agente__c = 'C' AND Activo__c = true 
                                   AND Tipo_Cargo__c = 'Supervisor FFVV' ORDER BY LastName];
    
        List<Agente> lista_agentes_A = ordenaAgentes(agentes_A);
        System.debug('@@@@ agentes_A size --> ' + lista_agentes_A.size());
        List<Agente> lista_agentes_B = ordenaAgentes(agentes_B);
        System.debug('@@@@ agentes_B size --> ' + lista_agentes_B.size());
        List<Agente> lista_agentes_C = ordenaAgentes(agentes_C);
        System.debug('@@@@ agentes_C size --> ' + lista_agentes_C.size());
    
        //ASIGNAR OPORTUNIDAD A AGENTES DISPONIBLES A
        OBJ_LINK_GestionRanking gestionRanking_A = AsignacionLinks(Oportunidades, links_cantidad_A, lista_agentes_A, new List<Opportunity>(), new List<Link_Asignado__c>());
        //ASIGNAR OPORTUNIDAD A AGENTES DISPONIBLES B
        OBJ_LINK_GestionRanking gestionRanking_B = AsignacionLinks(gestionRanking_A.Oportunidades, links_cantidad_B, lista_agentes_B, gestionRanking_A.Actualizar_Oportunidades, gestionRanking_A.Registro_Links);
        //ASIGNAR OPORTUNIDAD A AGENTES DISPONIBLES C
        OBJ_LINK_GestionRanking gestionRanking_C = AsignacionLinks(gestionRanking_B.Oportunidades, links_cantidad_C, lista_agentes_C, gestionRanking_B.Actualizar_Oportunidades, gestionRanking_B.Registro_Links);

        if(gestionRanking_C.Registro_Links.size() > 0){
            insert gestionRanking_C.Registro_Links;
        }
    
        System.debug('@@@@ crearLinks --> ' + gestionRanking_C.Registro_Links);
    
        if(gestionRanking_C.Actualizar_Oportunidades.size() > 0){
            update gestionRanking_C.Actualizar_Oportunidades;
        } 
    
        System.debug('@@@@ actualizarOportunidad ' + gestionRanking_C.Actualizar_Oportunidades);
    }

    public static List<Agente> ordenaAgentes(List<Contact> agentes)
    {
        Contact temp = null;
    //ORDENAR LISTA DE AGENTES C POR CANTIDAD DE OPORTUNIDADES 
        for (Integer i = 0; i < agentes.size() ; i++) 
        {
            for (Integer j = i + 1; j < agentes.size(); j++) {             
                if (agentes[i].Links__r.size() > agentes[j].Links__r.size()) 
                { 
                    temp = agentes[i];
                    agentes[i] = agentes[j];
                    agentes[j] = temp;
                }
            }
        } 

        List<Agente> lista_agentes = new List<Agente>();

        for (Contact agente : agentes)
        {
            Agente kgb = new Agente();
            kgb.Asignado = 0;
            kgb.info = agente;
            lista_agentes.add(kgb);
        }

        return lista_agentes;
    }
    
    public static OBJ_LINK_GestionRanking AsignacionLinks(List<Opportunity> Oportunidades, Long links_cantidad, List<Agente> agentes, List<Opportunity> actualizarOportunidades, List<Link_Asignado__c> crearLinks)
    {
        OBJ_LINK_GestionRanking salida = new OBJ_LINK_GestionRanking();
        salida.Actualizar_Oportunidades = actualizarOportunidades;
        salida.Registro_Links = crearLinks;
        salida.Oportunidades = new List<Opportunity>();
        // Integer removerAgente = 0;
        Integer contarAsignacion = 0;

        Integer Asignacion = 1;

        Integer contarAsignacionTmp = 0;

        for(Integer i = 0; i < Oportunidades.size(); i++)
        {
            if(contarAsignacion < links_cantidad)
            {
                for(Agente agente : agentes){ 
                //SI TIENE ENTREVISTA VALIDAR QUE TENGA DISPONIBILIDAD 
                    System.debug('@@@@ agente : ' + agente);
                    System.debug('@@@@ agente.Links__r.size() : ' + agente.info.Links__r.size());
                   
                    if (agente.Asignado < Asignacion)
                    {
                        if(agente.info.Links__r.size() > 0)
                        {
                            boolean tieneEntrevistaDia = false;
                            for(Link_Asignado__c link : agente.info.Links__r)
                            {
                                //valida fecha de entrevista dentro de oportunidad contra los links que ya tiene asignado el agente
                                if(link.Fecha_Link__c == Oportunidades[i].Fecha_Entrevista__c){
                                    tieneEntrevistaDia = true; 
                                    break;
                                }
                            }
                        
                            if(tieneEntrevistaDia == false)//si no tiene entrevista para el dia de la entrevista del nuevo link procede a asignar link a a agente
                            {
                                System.debug('obtenerLinks (sin entrevistas): ' + Oportunidades[i] + ' -> ' + agente.info.LastName);
                                Oportunidades[i].Agente_de_Venta__c = agente.info.Id;
                                Oportunidades[i].agente_asignado__c = true;
                                Oportunidades[i].asignacion_automatica__c = true;
                                salida.Actualizar_Oportunidades.add(Oportunidades[i]);
                                salida.Registro_Links.add(new Link_Asignado__c(Id_Oportunidad__c = Oportunidades[i].Id, Name = Oportunidades[i].Name, Contacto__c = agente.info.Id, Fecha_Link__c = Oportunidades[i].Fecha_Entrevista__c));
                                //agentes.remove(removerAgente);
                                agente.Asignado = Asignacion;
                                break;
                            }
                        }
                        else
                        {//SI NO TIENE ENTREVISTAS ASIGNAR
                            System.debug('obtenerLinks: ' + Oportunidades[i] + ' -> ' + agente.info.LastName);
                            Oportunidades[i].Agente_de_Venta__c = agente.info.Id;
                            Oportunidades[i].agente_asignado__c = true;
                            Oportunidades[i].asignacion_automatica__c = true;
                            salida.Actualizar_Oportunidades.add(Oportunidades[i]);
                            salida.Registro_Links.add(new Link_Asignado__c(Id_Oportunidad__c = Oportunidades[i].Id, Name = Oportunidades[i].Name, Contacto__c = agente.info.Id, Fecha_Link__c = Oportunidades[i].Fecha_Entrevista__c));
                            //agentes.remove(removerAgente);
                            agente.Asignado = Asignacion;
                            break;
                        }
                    }
                  //  removerAgente++;
               }
            }

            if(Oportunidades[i].Agente_de_Venta__c != null)
            {
                contarAsignacion++; 
                contarAsignacionTmp++;
            }
            else
            {//oportunidad no fue asignada
                salida.Oportunidades.add(Oportunidades[i]);
            }

            if (contarAsignacionTmp == agentes.size())
            {
                Asignacion++;
                contarAsignacionTmp = 0;
            }
        }
    
        return salida;
    }
}