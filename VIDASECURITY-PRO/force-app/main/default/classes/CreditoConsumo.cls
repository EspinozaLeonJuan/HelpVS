public with sharing class CreditoConsumo {
    
    public Decimal montoMaximo { get; set;}
    public Integer numCuotas { get; set;}
    public Decimal montoCuota { get; set;}
    
    public CreditoConsumo() {
        montoMaximo = 0;
        numCuotas = 0;
        montoCuota = 0;
    }

    public CreditoConsumo(Decimal montoMaximo, Integer numCuotas, Decimal montoCuota) {
        this.montoMaximo = montoMaximo;
        this.numCuotas = numCuotas;
        this.montoCuota = montoCuota;
    }

    public Boolean getCreditAvailable(){
        return (montoMaximo != 0 && numCuotas != 0 && montoCuota != 0);
    }
}