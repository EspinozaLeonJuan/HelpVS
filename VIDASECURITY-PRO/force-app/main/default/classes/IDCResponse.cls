public with sharing class IDCResponse {

    public void IDCResponse(){
        
    }

    public Integer Codmsg { get; set; }
    public String Mensaje { get; set; }
    public Integer Ncuomax { get; set; }
    public Integer Nmonmax { get; set; }
    public Integer Nplamax { get; set; }
    public Decimal Nvaluf { get; set; }
    public Decimal Ntasanull { get; set; }
    public Decimal Pzabruuf { get; set; }
    public Integer Totaldesc { get; set; }
    
    // public class Response{
    //     Integer Codigo {get;set;}
    //     String Descripcion {get;set;}
    // }
    // public class Exception{
    //     String httpCode {get; set;}
    //     String httpMessage {get; set;}
    //     String moreInformation {get; set;}
    // }
}