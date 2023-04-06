public without sharing class RUTUtils {

	public static Boolean isValid(String rut){
		Boolean validacion = false;
		try {
			rut =  rut.toUpperCase();
			system.debug('rut: '+rut);
			integer rutAux = Integer.valueOf(rut.substring(0, rut.length() - 1));
			system.debug('rutAux: '+rutAux);
			string dv = string.valueOf(rut.charAt(rut.length() - 1));
			system.debug('dv: '+dv);
			integer m = 0, s = 1;
			for (; rutAux != 0; rutAux /= 10) {
				s = math.mod(s + math.mod(rutAux, 10) * (9 - math.mod(m++,6)), 11);
			}
			system.debug('s: '+s);
			system.debug('evaluado contra dv: '+string.valueOf((s != 0 ? s + 47 : 75)));
			if (dv == string.valueOf((s != 0 ? s + 47 : 75))) {
				validacion = true;
			}
		} catch (Exception e) {
			validacion = false;
		}
		return validacion;
	}
    
    	public static string getDigito(integer rut) {
		integer suma = 0, value = 0;
		integer multiplicador = 1;
		String salida = '';

		while (rut != 0) {
			multiplicador++;
			if (multiplicador == 8)
			multiplicador = 2;
			value = math.mod(rut,10);
			suma += value * multiplicador;
			rut = rut / 10;
		}
		
		value = math.mod(suma, 11);
		suma = 11 - value;
		system.debug('@@@@ suma --> '+suma);

		if (suma == 11)	{
			salida = '0';
		} else if (suma == 10) {
			salida = 'K';
		} else {
			salida = String.valueOf(suma);
		}

		system.debug('@@@@ salida --> '+salida);
		return salida;
	}

}