function floor(number) {
  return Math.floor(number*Math.pow(10,2))/Math.pow(10,2);
}

function dosum() {
	var mi = (Math.pow(1+(document.calc.IR.value/100)/2,1/6)-1)
	var base = 1;
	var mbase = 1 + mi;
	for (i=0; i<document.calc.YR.value * 12; i++) {
		base = base * mbase;
	}
	document.calc.PI.value = floor(document.calc.LA.value * mi / ( 1 - (1/base)));
	document.calc.MT.value = floor(document.calc.AT.value / 12);
	document.calc.MI.value = floor(document.calc.AI.value / 1) + document.calc.HEAT.value/1;
	
	var dasum = document.calc.LA.value * mi / ( 1 - (1/base)) +
				document.calc.AT.value / 12 + 
				document.calc.AI.value / 1+
				document.calc.HEAT.value / 1;
	document.calc.MP.value = floor(dasum);
	document.calc.INRQ.value = floor(document.calc.MP.value / 3*10);
}