@IsTest
public class MarcaResponseTest {

  static testMethod void testParse() {
    String json = MarcaResponse.getExample();
    List<MarcaResponse> obj = MarcaResponse.parse(json);
    System.assert(obj != null);
  }
}