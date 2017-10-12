class Supplier < ApplicationRecord
  has_many :raw_material_stocks
  has_many :addresses, as: :addressable
  has_many :delivered_stocks, class_name: "StoreModule::ProductStock"
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
  has_many :stock_registries, class_name: "StockRegistry"
  has_many :vouchers, through: :stock_registries
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  def name 
    business_name 
  end

  def owner_name
    [first_name, last_name].join(" ")
  end
  def balance
    deliveries_total - payments_total
  end
  def payments_total
    vouchers.disbursed.sum(&:payable_amount)
  end
  def deliveries_total
    entries.supplier_delivery.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
  end
  def create_entry_for(voucher)
    accounts_payable =  AccountingModule::Liability.find_by(name: 'Accounts Payable-Trade')
    merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")
    entry = AccountingModule::Entry.supplier_delivery.new(commercial_document: self,  :description => "delivered stocks", recorder_id: voucher.user_id, entry_date: voucher.date)
    debit_amount = AccountingModule::DebitAmount.new(amount: voucher.payable_amount, account: merchandise_inventory)
    credit_amount = AccountingModule::CreditAmount.new(amount: voucher.payable_amount, account: accounts_payable)
    entry.debit_amounts << debit_amount
    entry.credit_amounts << credit_amount
    entry.save 
  end

end
