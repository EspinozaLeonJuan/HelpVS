/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-13-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global with sharing class API_ContactCenter_Response {
    
    public String IdCaso { get; set;}

    public String Url { get; set;}

    public Integer Prioridad { get; set;}

    public String Excepcion {get; set;}

    //public Boolean Creado {get; set;}

    public String Resultado {get; set;}
    /*
        NO : Opción no se encuentra disponible para su uso..
        OK :  Caso creado de forma exitosa.
        ER01: Debe ingresar un RUT.
        ER02: Debe ingresar un Id de Llamada
        ER03: Debe ingresar un telefono de entrada
        ER04: Debe ingresar un Id de Caso
        ER05: Debe ingresar un telefono de salida      
        ER06: Debe ingresar una opcion valida        
        ER07: RUT ingresado es inválido.
        ER08: RUT ingresado no encontrado (No ha sido encontrada Cuenta asociado al RUT ingresado).
        ER09: Cliente no tiene correo electrónico ingresado
        ER10: Cliente no tiene fecha de nacimiento ingresada
        ER11: Id de Caso ingresado no corresponde a un Caso existente.
        ER12: Error en la creacion de Caso.
        ER13: Error en la actualización de Caso.
    */

    public API_ContactCenter_Response()
    {
        this.IdCaso = '';
        this.Url = '';
        this.Prioridad = -1;
        this.Excepcion = '';
        this.Resultado = '';
    }
}