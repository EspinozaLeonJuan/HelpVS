@IsTest
public class ACSELAsignacionTest {

  static testMethod void testParse() {
    String json = ACSELAsignacion.getExample();
    List<ACSELAsignacion> obj = ACSELAsignacion.parse(json);
    System.assert(obj != null);
  }
}