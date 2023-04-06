public with sharing class DecimalOutputTextController {
	
	public String valueFormatted { set; get {
			if (this.numberDecimalValue == null)
				this.numberDecimalValue = 0;
			if (this.valueNotFormatted == null)
				return '--';
			return doFormatting(this.valueNotFormatted, this.numberDecimalValue, '.', ',');
		}
	}
	public Decimal valueNotFormatted {set; get;}
	public Integer numberDecimalValue {set; get;}
	public Boolean isTrailingZeros {set; get;}
	
	public DecimalOutputTextController() {}
	
	public String decimalTrailingZeros(String decimalNumber, String dSep) {
		if (decimalNumber.contains(dSep)){
			decimalNumber = decimalNumber.replaceAll('0*$', '');
			decimalNumber = decimalNumber.replaceAll(dSep + '$', '');
		}
		return decimalNumber;
	}
	
	public String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
		String s, tmp;
		Integer i = 4 + dec;
		// If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
		if(dec==0){
			i--;
		}
		s = val.setScale(dec).toPlainString().replace(tSep, dSep);
		while(s.length() > i) {
			tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
			s = tmp;
			i += 4;
		}
		// If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
		if (s.substring(0,1) == '-') {
			if (s.substring(1,2) == tSep) {
				s = '-' + s.substring(2);
			}
		}
		// Borramos el separador de miles.
		// s = s.replace(tSep, '');
		
		if (this.isTrailingZeros != null && this.isTrailingZeros)
			return decimalTrailingZeros(s, dSep);
		return s;
	}
	
	
}