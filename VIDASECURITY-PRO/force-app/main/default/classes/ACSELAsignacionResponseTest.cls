@IsTest
public class ACSELAsignacionResponseTest {

  static testMethod void testParse() {
    String json = ACSELAsignacionResponse.getExample();
    List<ACSELAsignacionResponse> obj = ACSELAsignacionResponse.parse(json);
    System.assert(obj != null);
  }
}