/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 09-20-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_COL_Response_Token_VT {

    public static String parse(String json)
    {
		return (String) System.JSON.deserialize(json, String.class);
	}
}