function CalcLTT(form, Price) 	{
	if (Price < 55000.01) {
		form.LTT.value = Price * 0.005;
	} else if (Price > 55000) {
		if (Price < 250000.01) {
			form.LTT.value = (Price * 0.010) - 275;
		} else if (Price < 400000.01) {
			form.LTT.value = (Price * 0.015) - 1525;
		} else {
			form.LTT.value = (Price * 0.020) - 3525;
		}
	}

}
