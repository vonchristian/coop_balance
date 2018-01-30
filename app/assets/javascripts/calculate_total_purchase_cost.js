function calculateTotalPurchaseCost() {
  var quantity = document.getElementById('stock_quantity').value;
  var purchaseCost = document.getElementById('stock_purchase_cost').value;

  var totalPurchaseCost = document.getElementById('stock_total_purchase_cost');
  var myResult = quantity * purchaseCost;
  totalPurchaseCost.value = myResult;
}
