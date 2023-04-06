/**
* VASS
* @author           Jessica Gómez
* @email: 			jessica.gomez@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    08/11/2021     Jessica Gómez JMGR 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
public class CategoriaPolizaHelperTest {
    
    static testMethod void testCategorias(){
        if(!TestVerificationService.ShouldExecute('CategoriaPolizaHelperTest.testCategorias')){return;}
        List<Categoria_de_Poliza__c> lstCategorias = CategoriaPolizaHelper.categorias;
    }
}