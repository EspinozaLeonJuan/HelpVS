/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-05-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_CS_ResponseLiquidacion {
    public Integer httpCode;
	public String httpMessage;
	public String moreInformation;
	public String internal_id;
	public String base64;


	public static CLS_CS_ResponseLiquidacion parse(String json) {
		return (CLS_CS_ResponseLiquidacion) System.JSON.deserialize(json, CLS_CS_ResponseLiquidacion.class);
	}
}