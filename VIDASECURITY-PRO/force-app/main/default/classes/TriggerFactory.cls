/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:		
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    27/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public with sharing class TriggerFactory{
    private static Boolean isExtender;
    private static String dispatcherHandlerTypeName;
    /*
    * @description: Este es el método de entrada a la TriggerFactory Invoca la creación del Dispatcher para el objeto y en caso positivo, ejecuta el enrutador
    * @param Schema.sObjectType soType
    */
    public static void createTriggerDispatcher(Schema.sObjectType soType){
        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if( dispatcher == null ){
			//throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);
			System.debug('##Trigger Incativo.');
        }else{
            execute(dispatcher);
        }
    }
    /*
    * @description: Este método enruta hacia el método adecuado del Dispatcher toda la información del trigger (maps, lists y booleans) se almacena en una
    * nueva instancia de clase que los métodos enrutados reciben. Al inicio de cada bloque (before triggers y after triggers) se invocan
    * métodos donde podremos llevar a cabo funciones de carácter transversal (bulkBefore() y bulkAfter())
    * Finalmente, tenemos un método de ejecución final (andFinally) donde realizar funciones de housekeeping, logging, etc.
    */
    private static void execute(ITriggerDispatcher dispatcher) {
        TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.isBefore, Trigger.isAfter, Trigger.isDelete, Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting, getExtender(), Trigger.operationType, getDispatcherHandlerTypeName() );
        if( getExtender() ){
            if( Trigger.isBefore ){
                //Tratamiento del bulk y ejecución de funciones transversales
                dispatcher.bulkBefore();
                if( Trigger.isDelete ){
                    dispatcher.beforeDelete(tp);
                }
                else if( Trigger.isInsert ){
                    dispatcher.beforeInsert(tp);
                }
                else if( Trigger.isUpdate ){
                    dispatcher.beforeUpdate(tp);
                }
            }
            else{// After trigger events
                //Tratamiento del bulk y ejecución de funciones transversales
                dispatcher.bulkAfter();
                if( Trigger.isDelete ){
                    dispatcher.afterDelete(tp);
                }
                else if( Trigger.isInsert ){
                    dispatcher.afterInsert(tp);
                }
                else if( Trigger.isUpdate ){
                    dispatcher.afterUpdate(tp);
                }
            }
            //Función de Housekeeping
            dispatcher.andFinally();
        }else{
            dispatcher.execute( tp );
        }
    }
    /*
    * @description: Este método es de los más interesantes, y donde el autor introduce novedades:
    * 1. Utiliza una convención de nombres para invocar las clases Dispatcher
    * 2. Con esta convención y con las capacidades de Apex de instanciar clases
    * mediante el nombre, se crean los Dispatcher y se desacopla por completo la TriggerFactory del Dispatcher
    */
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType){
        String originalTypeName = soType.getDescribe().getName();
        String nameTriggerSettings = originalTypeName;
        Map<String,TriggersSettings__mdt> mTriggerSettings = UtilityClass.getTriggerSettings();
        Type obType = null;
        
        if( originalTypeName.toLowerCase().endsWith('__c') ){
            Integer index = originalTypeName.toLowerCase().indexOf('__c');
            nameTriggerSettings = originalTypeName.substring(0, index).replace('_','');
        }
        
        if( mTriggerSettings.containsKey( nameTriggerSettings ) ){
            TriggersSettings__mdt oTriggerSettings = mTriggerSettings.get( nameTriggerSettings );
            
            if( oTriggerSettings.Active__c ){
                setDispatcherHandlerTypeName( oTriggerSettings.ClassTriggerDispacherHandler__c );
                setExtender( oTriggerSettings.Extender__c );
                //Instanciación mediante el nombre de la clase, que se obtiene en tiempo de ejecución
        		//Observar la creación de tipo y la creación de la instancia con el cast
                obType = Type.forName( getDispatcherHandlerTypeName() );
            }
        }
        ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
        return dispatcher;
    }
    /** 
     * @description: 
    */
    public static void setExtender(Boolean ext){
        isExtender = ext;
    }
    /** 
     * @description: 
    */
    public static Boolean getExtender(){
        return isExtender;
    }
    /** 
     * @description: 
    */
    public static void setDispatcherHandlerTypeName(String dispatcherHandler){
        dispatcherHandlerTypeName = dispatcherHandler;
    }
    /** 
     * @description: 
    */
    public static String getDispatcherHandlerTypeName(){
        return dispatcherHandlerTypeName;
    }
}