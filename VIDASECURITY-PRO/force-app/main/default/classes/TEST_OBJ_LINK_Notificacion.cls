/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-05-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-06-2021   Juan Espinoza León   Initial Version
**/
@istest
public with sharing class TEST_OBJ_LINK_Notificacion {
    public TEST_OBJ_LINK_Notificacion() {

    }

    @isTest
    public static void  Execution() {

        Test.startTest();

        OBJ_LINK_Notificacion objeto = new OBJ_LINK_Notificacion();


        objeto.Supervisor_Id = '00D0000000000XX';

        objeto.Supervisor_Name = '';

        objeto.Supervisor_Email = '';

        objeto.Agente_Id = '00D0000000000XX';

        objeto.Agente_Name = '';

        objeto.Agente_Email = '';

    //public String Agente_Ciudad {get; set;}

    objeto.Entrevista_Fecha = '';

    objeto.Entrevista_Hora = '';

    //objeto.Oportunidad_Entrevista_Fecha  = new Date(2021,02,07)

    //objeto.Oportunidad_Entrevista_Hora = new Time(11,11,11);

    objeto.Oportunidad_Name = '';

    objeto.Oportunidad_FechaNacimiento = '';

    objeto.Oportunidad_CodigoLink = '1';

    objeto.Oportunidad_Telefono = '';

    objeto.Oportunidad_Renta = '';

    objeto.Oportunidad_Direccion = '';

    objeto.Oportunidad_Cargo = '';

    objeto.Oportunidad_Comuna = '';

    objeto.Oportunidad_Observacion = '';

    objeto.Titulo_Mensaje_Agente = '';

    objeto.Mensaje_Agente = '';


    Test.stopTest();


    }

}