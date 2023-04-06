@isTest(SeeAllData=true)
private class CopiaAdjuntoDeCasoTest {

		static testMethod void myUnitTest() {
				ControlTest.CopiaAdjuntoDeCaso = true;
				ControlTest.CreaCasoVidaSecurity = true;
				Account account = Factory.cuenta.buildInsert();

				Case caso = new Case();
				caso.Subject = 'Caso de prueba';
				caso.AccountId = account.Id;
				insert caso;
				Attachment attachment = new Attachment(ParentId = caso.Id, Name = 'test.txt', Body = Blob.valueOf('ABC123'), ContentType = 'text/plain', Description = 'abc abc');

				Test.startTest();
				insert attachment;
				Test.stopTest();
				ControlTest.CreaCasoVidaSecurity = false;
				ControlTest.CopiaAdjuntoDeCaso = false;
		}

		static testMethod void duplicatedUpsert(){
			Account account = Factory.cuenta.buildInsert();
			Poliza__c poliza = new Poliza__c(
					IDVS__C = '57704753',
					AGENTE__C = '',
					APELLIDOS_ASEGURADO__C = 'ERICES FUENTS',
					CODIGO_AGENTE__C = '',
					CODIGO_DE_PRODUCTO__C = '1300',
					CODIGO_EJECUTIVO__C = '',
					CUENTA__C = account.Id,
					DV__C = '1',
					EDAD_AL_MOMENTO_DE_CONTRATAR__C = 52,
					EJECUTIVO_DE_CLIENTES__C = '',
					EMPRESA_ORIGEN__C = 'Vida Security',
					ESTATUS__C = 'ACTIVA',
					FECHA_ENTREGA_DE_LA_POLIZA__C = Date.valueOf('2003-07-14'),
					FECHA_SOMETIMIENTO__C = Date.valueOf('2003-08-01'),
					FORMA_DE_PAGO__C = 'DIRECTO',
					FRECUENCIA_DE_PAGO__C = 'M',
					IDPOLIZA__C = '1103769',
					MODALIDAD_APV__C = '',
					MONEDA_POLIZA__C = 'USP',
					N_POLIZA__C = 8142956,
					NAME = '8142956',
					NOMBRE_ASEGURADO__C = 'FRANCISCO GERARDO',
					NOMBRE_DE_PRODUCTO__C = 'P.F. ESPECIAL',
					PRIMA_TOTAL__C = 25.9419,
					PRIMA_ADICIONAL__C = 21.8619,
					PRIMA_EN_EXCESO__C = 0,
					PRIMA_MINIMA__C = 4.08,
					RUT_ASEGURADO__C = '6419110',
					SUCURSAL_EJECUTIVO_DE_CLIENTES__C = 'LYON  (PF)',
					VALOR_POLIZA__C = 0);
			upsert poliza Poliza__c.N_Poliza__c;
		}
}