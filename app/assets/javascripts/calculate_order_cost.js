function calculateOrderTotalCost() {
  var discountAmount = document.getElementById('discount_amount').value;
  var totalCost = document.getElementById('total_cost').value;
  var cashTendered = document.getElementById('cash_tendered').value;

  var change = document.getElementById('change');
  var result = totalCost - discountAmount;
  var changeResult = cashTendered - result;
  change.value = changeResult;
  totalCostLessDiscount.value = result;
}
