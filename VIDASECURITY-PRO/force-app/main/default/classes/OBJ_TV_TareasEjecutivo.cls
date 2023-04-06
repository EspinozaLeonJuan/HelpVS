/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-24-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-24-2020   Juan Espinoza León   Initial Version
**/
public class OBJ_TV_TareasEjecutivo implements Comparable{

    public String Rut {get; set;}

    public Id Id {get; set;}

    public Integer NumeroTareas {get; set;}


    public OBJ_TV_TareasEjecutivo(String rutEjecutivo, Id idEjecutivo, Integer numTareas)
    {
        this.Rut = rutEjecutivo;
        this.Id = idEjecutivo;
        this.NumeroTareas = numTareas;
    }

    public Integer compareTo(Object compareTo) {
        OBJ_TV_TareasEjecutivo compareToEmp = (OBJ_TV_TareasEjecutivo)compareTo;
        if (NumeroTareas == compareToEmp.NumeroTareas) return 0;
        if (NumeroTareas > compareToEmp.NumeroTareas) return 1;
        return -1;        
    } 

}