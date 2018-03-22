class StoreFront < ApplicationRecord
  belongs_to :cooperative

  belongs_to :accounts_receivable_account,   class_name: "AccountingModule::Account"
  belongs_to :cost_of_goods_sold_account,    class_name: "AccountingModule::Account"
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account"
  belongs_to :sales_account,                 class_name: "AccountingModule::Account"
  belongs_to :sales_return_account,          class_name: "AccountingModule::Account"
  belongs_to :accounts_payable_account,      class_name: "AccountingModule::Account"
  belongs_to :spoilage_account,              class_name: "AccountingModule::Account"
  belongs_to :sales_discount_account,        class_name: "AccountingModule::Account"
  belongs_to :purchase_return_account,       class_name: "AccountingModule::Account"
  belongs_to :internal_use_account,          class_name: "AccountingModule::Account"



  has_many :entries,                         class_name: "AccountingModule::Entry",
                                             as: :origin
  validates :name, :address, :contact_number, presence: true
  validates :name, uniqueness: true
  validates :accounts_receivable_account_id,
            :cost_of_goods_sold_account_id,
            :merchandise_inventory_account_id,
            :sales_account_id,
            :sales_return_account_id,
            :accounts_payable_account_id,
            :spoilage_account_id,
            :sales_discount_account_id,
            :internal_use_account_id,
            :purchase_return_account_id,
            presence: true,
            uniqueness: true

  def self.accounts_receivable_balance(customer)
    all.map{|a| a.accounts_receivable_balance(customer) }.sum
  end

  def accounts_receivable_balance(customer)
    accounts_receivable_account.balance(commercial_document: customer)
  end
end
