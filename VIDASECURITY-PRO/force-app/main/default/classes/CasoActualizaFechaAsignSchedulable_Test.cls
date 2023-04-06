@isTest
public class CasoActualizaFechaAsignSchedulable_Test {
	@isTest static void casoActualiza() {
		Test.startTest();
			CasoActualizaFechaAsignacionSchedulable trabajoProgramado = new CasoActualizaFechaAsignacionSchedulable();
			trabajoProgramado.execute(null);
		Test.stopTest();

	}
}