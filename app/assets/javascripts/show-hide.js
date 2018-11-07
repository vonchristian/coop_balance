  var amount_based = document.getElementById('loans_module_loan_products_loan_product_charge_charge_type_amount_based');
  var percent_based = document.getElementById('loans_module_loan_products_loan_product_charge_charge_type_percent_based');
  var charge_amount = document.getElementById('loans_module_loan_products_loan_product_charge_amount');
  var charge_rate = document.getElementById('loans_module_loan_products_loan_product_charge_rate');

  amount_based.onchange = function() {
   	if(this.checked) {
    	charge_amount.style['display'] = 'block';
   	} else {
     	charge_rate.style['display'] = 'none';
   	}
  };