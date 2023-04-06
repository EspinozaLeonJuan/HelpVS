/*******************************************************************************************
 *  NOMBRE                 : TareasEjecutivoTeleventa
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - Genera Tareas Campaña Televenta
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
public class TareasEjecutivoTeleventa implements Comparable{
        
    public Integer numTareas;
    public String rutEjecutivo;
    public Id idEjecutivo;
    
    public TareasEjecutivoTeleventa(Integer numTareas, String rutEjecutivo, Id idEjecutivo){
        this.numTareas = numTareas;
        this.rutEjecutivo = rutEjecutivo;
        this.idEjecutivo = idEjecutivo;
    }
    
    // Se incorpora de método de comparación de carga...
    public Integer compareTo(Object compareTo) {
        TareasEjecutivoTeleventa compareToEmp = (TareasEjecutivoTeleventa)compareTo;
        if (numTareas == compareToEmp.numTareas) return 0;
        if (numTareas > compareToEmp.numTareas) return 1;
        return -1;        
    }        
    
}