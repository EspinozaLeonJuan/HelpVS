/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-07-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   12-07-2020   Juan Espinoza León   Initial Version
**/
global class CLS_CM_CierreParticipantesCampagna implements Schedulable {
    public CLS_CM_CierreParticipantesCampagna() {

    }

    global void execute(SchedulableContext ctx)
    {
        Cierre_PC_Televentas_Vigentes();
        Cierre_PC_Televentas_Anuladas();

        Cierre_PC_PostVenta_Vigentes();
        Cierre_PC_PostVenta_Anuladas();
    }


    public void Cierre_PC_Televentas_Vigentes()
    {
        //Cierre de Participantes Televenta
        Participantes_de_Campa_a__c[] members = [SELECT Id, Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, CreatedDate, Fecha_ltimo_Pago__c, Comentario__c FROM Participantes_de_Campa_a__c
                                                 WHERE RecordType.Name = 'Cobranzas Televenta' AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice') FOR UPDATE];//;AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice')];
        
        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};
        system.debug('@@@@ members ' + members);
        Integer cont = 0;
        for (Participantes_de_Campa_a__c member : members) {
            Date create = member.CreatedDate.date();//Date.newInstance(member.CreatedDate.yearh, day)
            Date fechaPago = member.Fecha_ltimo_Pago__c;
            Date fechaAnt = create.addDays(-4);
            /*system.debug('@@@@ CreatedDate ' + member.CreatedDate);
            system.debug('@@@@ Fecha_ltimo_Pago__c ' + member.Fecha_ltimo_Pago__c);
            system.debug('@@@@ create' + create);
            system.debug('@@@@ fechaAnt ' + fechaAnt); */
            if (fechaPago >= fechaAnt)
            {
                cont = cont + 1;
                member.Estado_Cierre__c = 'Finalizado';
                member.Comentario__c = 'Finalizado recaudando normalmente';
                system.debug('@@@@ Id ' + member.Id);
                members2.add(member);
            }
        }

        system.debug('@@@@ Registros a Finalizar ' + cont);
        upsert members2;
    }

    public void Cierre_PC_Televentas_Anuladas()
    {
        //Cierre de Participantes Televenta Anuladas
        Participantes_de_Campa_a__c[] members = [SELECT Id, Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c,
        CreatedDate, Fecha_ltimo_Pago__c, Comentario__c FROM Participantes_de_Campa_a__c
        WHERE RecordType.Name = 'Cobranzas Televenta' AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice') AND Poliza__r.Estatus__c = 'ANULADA' FOR UPDATE];

        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};

        system.debug('@@@@ members ' + members);

        for (Participantes_de_Campa_a__c member : members) {
            member.Estado_Cierre__c = 'Finalizado';
            member.Comentario__c = 'Se cierra por anulación de Póliza';
            members2.add(member);
        }

        upsert members2;
    }

    public void Cierre_PC_PostVenta_Vigentes()
    {
        //Cierre de Participantes PostVenta
        Participantes_de_Campa_a__c[] members = [SELECT Id, Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, CreatedDate, Fecha_ltimo_Pago__c, Comentario__c
        FROM Participantes_de_Campa_a__c WHERE RecordType.Name = 'Cobranzas PV' AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice') LIMIT 50 FOR UPDATE];

        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};
        system.debug('@@@@ members ' + members);
        Integer cont = 0;
        for (Participantes_de_Campa_a__c member : members) {
            Date create = member.CreatedDate.date();//Date.newInstance(member.CreatedDate.yearh, day)
            Date fechaPago = member.Fecha_ltimo_Pago__c;
            Date fechaAnt = create.addDays(-4);
            /*system.debug('@@@@ CreatedDate ' + member.CreatedDate);
            system.debug('@@@@ Fecha_ltimo_Pago__c ' + member.Fecha_ltimo_Pago__c);
            system.debug('@@@@ create' + create);
            system.debug('@@@@ fechaAnt ' + fechaAnt); */
            if (fechaPago >= fechaAnt)
            {
                cont = cont + 1;
                member.Estado_Cierre__c = 'Finalizado';
                member.Comentario__c = 'Finalizado recaudando normalmente';
                system.debug('@@@@ Id ' + member.Id);
                members2.add(member);
            }
        }

        system.debug('@@@@ Registros a Finalizar ' + cont);

        upsert members2;

    }

    public void Cierre_PC_PostVenta_Anuladas()
    {
        //Cierre de Participantes PostVenta Anuladas
        Participantes_de_Campa_a__c[] members = [SELECT Id, Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c,
        CreatedDate, Fecha_ltimo_Pago__c, Comentario__c FROM Participantes_de_Campa_a__c
        WHERE RecordType.Name = 'Cobranzas PV' AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice') AND Poliza__r.Estatus__c = 'ANULADA' LIMIT 400 FOR UPDATE];

        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};

        system.debug('@@@@ members ' + members);

        for (Participantes_de_Campa_a__c member : members) {
            member.Estado_Cierre__c = 'Finalizado';
            member.Comentario__c = 'Se cierra por anulación de Póliza';
            members2.add(member);
        }

        upsert members2;
    }


}