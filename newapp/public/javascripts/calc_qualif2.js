<!--SCRIPT LANGUAGE="JAVASCRIPT"-->

function clearColumn(form, nColumn) {
        form[("txtDownPayment" + nColumn)].value = "";
        form[("txtFirstMortgage" + nColumn)].value = "";
        form[("txtCMHC" + nColumn)].value = "";
        form[("txtFinancing" + nColumn)].value = "";
        form[("txtPI" + nColumn)].value = "";
        form[("txtExpenses" + nColumn)].value = "";
        form[("txtTotal" + nColumn)].value = "";
        form[("txtIncome" + nColumn)].value = "";
}

function clearResults(form) {
        var nCounter = 0;
        for (nCounter = 1; nCounter <=3; nCounter++) {
                clearColumn(form, nCounter);
        }
}

function checkForm(form) {
        var nCounter = 0;
        var sResult = 0;
        var nResult = -1;
        var nIndex = 0;
        
        for (nCounter = 1; nCounter <= 3; nCounter++) {
                if ((form[("cboPercentDown" + nCounter)].options[form[("cboPercentDown" + nCounter)].selectedIndex].value == "") || 
                        (form[("cboPercentDown" + nCounter)].options[form[("cboPercentDown" + nCounter)].selectedIndex].value == "other")) {
                        while ((nResult < 5) || (nResult > 100)) {
                                sResult = prompt(decodeMsg("DOWNPAYMENT_PERCENT"), "5");
                                if (sResult == null) {
                                        alert("DOWNPAYMENT_REQUIRED");
                                        sResult = "0";
                                } else {
                                        if (sResult.indexOf(".") > 0) sResult = sResult.substring(0, sResult.indexOf(".") + 3);
                                        nResult = Number(filterNum("0" + sResult));
                                        if ((nResult < 5) || (nResult > 100)) {
                                                alert("INVALID_DOWNPAYMENT")
                                        }
                                }
                        }
        
                        if (form[("cboPercentDown" + nCounter)].options[form[("cboPercentDown" + nCounter)].selectedIndex].value == "other") {
                                nIndex = form[("cboPercentDown" + nCounter)].selectedIndex + 1;
                        } else {
                                nIndex = form[("cboPercentDown" + nCounter)].selectedIndex;
                        }
                        form[("cboPercentDown" + nCounter)].options[nIndex].value = nResult;
                        form[("cboPercentDown" + nCounter)].options[nIndex].text = nResult + "%";
                        form[("cboPercentDown" + nCounter)].selectedIndex = nIndex;
                }
        }
        validateNum(form.txtPrice,0,1000,9999999,true);
        validateNum(form.txtRate,3,1,100);
        validateNum(form.txtHeating,0,0,99999,true);
        validateNum(form.txtTax,0,0,99999,true);
        validateNum(form.txtOther,0,0,99999,true);
        validateNum(form.txtGDS,2,1,100);

        if ((form.txtPrice.value != "") &&
                (form.txtRate.value != "") &&
                (form.txtGDS.value != "")) {
                return true;
        } else {
                return false;
        }
}

function CMHCRate(PercentDown) {
  var CMHC_LV = 100 - PercentDown;
  var CMHC_multiplier;

  if (CMHC_LV <= 80) {    //20%
    CMHC_multiplier = 0;
  } else {
    if (CMHC_LV <= 85) {  //15%
      CMHC_multiplier = 1.75;
    } else if (CMHC_LV <= 90) { //10%
      CMHC_multiplier = 2.0;
    } else if (CMHC_LV <= 95) { // 5%
      CMHC_multiplier = 2.75;
    } else {                    //0%
      CMHC_multiplier = 3.10;
    }
    
    switch($('amortization').value) {
      case '30':
        CMHC_multiplier += 0.2;
        break;
      case '35':
        CMHC_multiplier += 0.4;
        break;
      case '40':
        CMHC_multiplier += 0.6;
        break;
    }
  }
    
  return CMHC_multiplier;


}

function mortgagePayment(nAmount, nRate, nAmort) {
        var nAmortMonths = nAmort * 12;
        var nPaymentsPer6Months = 6;    

        return (nAmount / ( (1 / ( Math.pow((1 + nRate / 200), (1 / nPaymentsPer6Months ))  - 1) ) * (1 - Math.pow((1 + nRate / 200), (-nAmortMonths / nPaymentsPer6Months)) ) ) );     
}

function currencyString(nNumber) {
        nNumDec = 2;
        if (nNumber > 999999) nNumDec = 0;
        var str = "" + Math.round(nNumber * Math.pow(10,nNumDec));
        while (str.length <= nNumDec) {
                str = "0" + str;
        }
        var decpoint = str.length - nNumDec;
        var result = commaFmt(str.substring(0,decpoint) + "." + str.substring(decpoint,str.length));
        if (result.charAt(result.length - 1) == ".") result = result.substring(0, result.length - 1);
        return result;


}

function doCalcOnForm(form) {
        //var form = document.forms[0];
        var bCMHCAlert = true;
        var nDownPayment = 0;
        var nFirstMortgage = 0;
        var nCMHCPremium = 0;
        var nTotalFinancing = 0;
        var nPayment = 0;
        var nExpenses = 0;
        var nTotal = 0;
        var nIncome = 0;
        if (checkForm(form)) {
                var nCounter = 0;
                for (nCounter = 1; nCounter <= 3; nCounter++) {
                        if (Number(form[("cboPercentDown" + nCounter)].options[form[("cboPercentDown" + nCounter)].selectedIndex].value) < 10) {
//                                if (Number(filterNum(form.txtPrice.value)) > Number(form.cboLocation.options[form.cboLocation.selectedIndex].value)) {
//                                        if (bCMHCAlert) alert(decodeMsg("LOCATION_REQUIREMENT", form.cboLocation.options[form.cboLocation.selectedIndex].value));
//                                        bCMHCAlert = false;
//                                        clearColumn(form, nCounter);
//                                        continue;
//                                }
                        }
                        // calculate downpayment
                        nDownPayment = (filterNum(form.txtPrice.value)) * (Number(form[("cboPercentDown" + nCounter)].options[form[("cboPercentDown" + nCounter)].selectedIndex].value) / 100);
                        form[("txtDownPayment" + nCounter)].value = currencyString(nDownPayment);
                        if (nDownPayment == 0) {
                        	form.txtGDS.value = 40;
                        }
                        // calculate first mortgage value
                        nFirstMortgage = (filterNum(form.txtPrice.value) - nDownPayment);
                        form[("txtFirstMortgage" + nCounter)].value = currencyString(nFirstMortgage);
                        // calculate CMHC Premium
                        nCMHCPremium = CMHCRate(Number($("percent_down_" + nCounter).value)) * nFirstMortgage / 100;
                        form[("txtCMHC" + nCounter)].value = currencyString(nCMHCPremium);
                        nTotalFinancing = nFirstMortgage + nCMHCPremium;
                        form[("txtFinancing" + nCounter)].value = currencyString(nTotalFinancing);
                        nPayment = mortgagePayment(nTotalFinancing, Number(form.txtRate.value), (Number(form.cboAmortization.options[form.cboAmortization.selectedIndex].value)));
                        form[("txtPI" + nCounter)].value = currencyString(nPayment);
                        nExpenses = ( (Number(filterNum(form.txtHeating.value)) + Number(filterNum(form.txtTax.value)) ) /12 + Number(filterNum(form.txtOther.value))/12 );
                        form[("txtExpenses" + nCounter)].value = currencyString(nExpenses);
                        nTotal = nExpenses + nPayment;
                        form[("txtTotal" + nCounter)].value = currencyString(nTotal);
                        nIncome = nTotal * 12 / (Number(form.txtGDS.value) / 100);
                        form[("txtIncome" + nCounter)].value = currencyString(nIncome);
                }
        } else {
                clearResults(form);
        }

}
// 0% down - 3.10% 25yr amortization
//           3.30   30yr
//           3.50   35
//           3.70   40
// 
// 
// 
// 
// 5% down - 2.75% at 25yr amortization
//           2.95 at 30 yr
//           3.15 at 35
//           3.35 at 40
// 
// 10 % down - 2.00% at 25 yr
//             2.20     30
//             2.40     35  
//             2.60     40
// 
// 15% down -  1.75 % 25yr am
//             1.95   30
//             2.10   35
//             2.30    40


