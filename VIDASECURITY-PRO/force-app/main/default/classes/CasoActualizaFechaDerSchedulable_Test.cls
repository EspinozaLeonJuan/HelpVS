/**
 * @File Name          : CasoActualizaFechaDerSchedulable_Test.cls
 * @Description        : 
 * @Author             : Juan Espinoza León
 * @Group              : 
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 9/3/2019, 5:26:53 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/3/2019   Juan Espinoza León     Initial Version
**/
@isTest
public class CasoActualizaFechaDerSchedulable_Test {
	@isTest static void casoActualiza() {
		Test.startTest();
			CasoActualizaFechaDerivacionSchedulable trabajoProgramado = new CasoActualizaFechaDerivacionSchedulable();
			trabajoProgramado.execute(null);
		Test.stopTest();

	}
}