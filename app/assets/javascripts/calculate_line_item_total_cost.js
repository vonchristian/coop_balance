function calculateLineItemTotalCost() {
  var quantity = document.getElementById('line_item_quantity').value;
  var unitCost = document.getElementById('line_item_unit_cost').value;

  var totalCost = document.getElementById('line_item_total_cost');
  var result = quantity * unitCost;
  totalCost.value = result;
}

