class PurchaseForm
  include ActiveModel::Model
  attr_accessor :delivery_date, :reference_number, :supplier_id, :quantity, :raw_material_id, :unit_cost, :total_cost, :has_freight, :freight_in, :discounted, :discount_amount, :recorder_id

  def save
    ActiveRecord::Base.transaction do
      create_raw_material_stocks
      create_entry
    end
  end

  def find_raw_material
    RawMaterial.find_by(id: raw_material_id)
  end

  def create_raw_material_stocks
    find_raw_material.raw_material_stocks.create(unit_cost: unit_cost, total_cost: total_cost, delivery_date: delivery_date, supplier_id: supplier_id, quantity: quantity, has_freight: has_freight, freight_in: freight_in, discounted: discounted, discount_amount: discount_amount )
  end

  def find_stock
    RawMaterialStock.find_by(unit_cost: unit_cost, total_cost: total_cost, delivery_date: delivery_date, supplier_id: supplier_id, quantity: quantity)
  end

  def create_entry
       #Credit PURCHASE ENTRY##
    # if  !discounted? && !has_freight?
      AccountingDepartment::Entry.create!(entry_type: 'supplier_delivery', commercial_document_id: supplier_id, commercial_document_type: "Supplier",  entry_date: delivery_date, description: "purchase of raw materials from supplier", debit_amounts_attributes: [amount: find_stock.total_purchase_cost, account: AccountingDepartment::Account.find_by(name: "Raw Materials Inventory")], credit_amounts_attributes:[amount: find_stock.total_purchase_cost, account: AccountingDepartment::Account.find_by(name: 'Accounts Payable-Trade')],  recorder_id: recorder_id)
    # elsif self.credit? && discounted? && !has_freight?
    #   Accounting::Entry.create!(stock_id: self.id, commercial_document_id: self.supplier.id, commercial_document_type: self.supplier.class, date: self.date, description: "Credit Purchase of stocks with discount of #{self.discount_amount}", debit_amounts_attributes: [amount: self.purchase_price, account: "Merchandise Inventory"], credit_amounts_attributes:[amount: self.purchase_price, account: 'Accounts Payable-Trade'],  employee_id: self.employee_id)
    # elsif self.credit? && !discounted? && has_freight?
    #   Accounting::Entry.create!(stock_id: self.id, commercial_document_id: self.supplier.id, commercial_document_type: self.supplier.class, date: self.date, description: "Credit Purchase of stocks with freight in of #{self.freight_amount}", debit_amounts_attributes: [amount: self.purchase_price, account: "Merchandise Inventory"], credit_amounts_attributes:[amount: self.purchase_price, account: 'Accounts Payable-Trade'],  employee_id: self.employee_id)
    # elsif self.credit? && discounted? && has_freight?
    #   Accounting::Entry.create!(stock_id: self.id, commercial_document_id: self.supplier.id, commercial_document_type: self.supplier.class, date: self.date, description: "Credit Purchase of stocks with discount of #{self.discount_amount} and freight in of #{self.freight_amount}", debit_amounts_attributes: [amount: self.purchase_price, account: "Merchandise Inventory"], credit_amounts_attributes:[amount: self.purchase_price, account: 'Accounts Payable-Trade'],  employee_id: self.employee_id)
  #  end
  end
end
