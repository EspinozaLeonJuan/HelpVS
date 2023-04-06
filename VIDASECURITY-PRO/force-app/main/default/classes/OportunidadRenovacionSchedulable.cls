global class OportunidadRenovacionSchedulable  implements Schedulable{
    
    global void execute(SchedulableContext ctx) 
    {
        CrearOportunidadRenovacion.creaOppRenovacion();
    }
}