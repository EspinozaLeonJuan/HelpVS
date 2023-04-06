@IsTest
public class MarcaRequestTest {

  static testMethod void testParse() {
    String json = MarcaRequest.getExample();
    List<MarcaRequest> obj = MarcaRequest.parse(json);
    System.assert(obj != null);
  }
}