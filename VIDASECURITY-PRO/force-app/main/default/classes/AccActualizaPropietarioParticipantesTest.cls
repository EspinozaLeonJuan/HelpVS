/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccActualizaPropietarioParticipantesTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccActualizaPropietarioParticipantes_tst.testExecute')){return;}
        /**********************************************************************************/
        Test.startTest();
        UserGeneration usuarioAdmin1 = (UserGeneration)Fabricate.usuarioAdmin().adminNombre('nombre1','apellido1','alia1','12321').save();
        UserGeneration usuarioAdmin2 = (UserGeneration)Fabricate.usuarioAdmin().adminNombre('nombre2','apellido2','alia2','32123').save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Id idUsuario1 = (Id)usuarioAdmin1.get().get('Id');
        System.debug('##usuarioAdmin1: ' + idUsuario1 );
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .generico('name1', 'lastname1', '16355278', '7', (Id)usuarioAdmin1.get().get('Id') )
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('OwnerId', idUsuario1 )
            .save();
        
        Date myDate = Date.today().addMonths(-4);

        PolizaFabricate poliza = Fabricate.poliza().setCuenta( cuenta );
		poliza.set('Fecha_Entrega_de_la_Poliza__c', Date.today().addDays(7) );
        poliza.set('Frecuencia_de_Pago__c', 'M');
        poliza.set('Con_o_Sin_Ahorro__c', 'Con Ahorro');
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('Fecha_Ultimo_Pago__c', myDate);
		poliza.set('Prima_Minima__c', 0.864000 );
		poliza.set('Valor_Poliza__c', 0);
		poliza.save();
        
        Id idCampana = (Id)campana.get().get('Id');
        Id idPersonContact = (Id)cuenta.get().get('PersonContactId');
        String nombreContacto = (String)cuenta.get().get('Name');
        Id idPoliza = (Id)poliza.get().get('Id');
        Id idOwner = (Id)cuenta.get().get('OwnerId');
        Id idCuenta = (Id)cuenta.get().get('Id');

        ParticipanteCampangaGeneration participanteCampanga1 = (ParticipanteCampangaGeneration)Fabricate.participanteCampagna().generico('Poliza test 1', idCampana, idPersonContact, 'ACTIVA', nombreContacto, idPoliza, idOwner, idCuenta, '1').save();
        ParticipanteCampangaGeneration participanteCampanga2 = (ParticipanteCampangaGeneration)Fabricate.participanteCampagna().generico('Poliza test 2', idCampana, idPersonContact, 'ACTIVA', nombreContacto, idPoliza, idOwner, idCuenta, '1').save();
        
        Set<Id> setIdsParticipantesCampana = new Set<Id>();
        setIdsParticipantesCampana.add((Id)participanteCampanga1.get().get('Id'));
        setIdsParticipantesCampana.add((Id)participanteCampanga2.get().get('Id'));

        List<Participantes_de_Campa_a__c> lParticipantesCampana = [
            SELECT Id , OwnerId, Cuenta__c, Cuenta__r.OwnerId
            FROM Participantes_de_Campa_a__c
            WHERE Id IN: setIdsParticipantesCampana ];
        
        //cuenta.set('OwnerId', ).save();
        System.debug('##lParticipantesCampana: ' + lParticipantesCampana );
        List<Participantes_de_Campa_a__c> lParticipantes = new List<Participantes_de_Campa_a__c>();
        Participantes_de_Campa_a__c oParticipantesCampana1 = lParticipantesCampana[0];
        Participantes_de_Campa_a__c oParticipantesCampana2 = lParticipantesCampana[0];
        oParticipantesCampana1.OwnerId = UserInfo.getUserId();// (Id)usuarioAdmin2.get().get('Id');
        lParticipantes.add( oParticipantesCampana1 );
        oParticipantesCampana2.OwnerId = UserInfo.getUserId();
        lParticipantes.add( oParticipantesCampana2 );
        
        AccActualizaPropietarioParticipantes.execute( lParticipantes );

        Test.stopTest();
    }
}