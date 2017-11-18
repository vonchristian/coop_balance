class Voucher < ApplicationRecord
  include PgSearch
  enum status: [:disbursed, :cancelled]
  pg_search_scope :text_search, :against => [:number, :description]
  multisearchable against: [:number, :description]
  has_one :entry, class_name: "AccountingModule::Entry", as: :commercial_document
  belongs_to :voucherable, polymorphic: true
  belongs_to :payee, polymorphic: true
  delegate :name, :payable_amount, to: :voucherable, allow_nil: true
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy

  before_save :set_date

  def for_loan?
    voucherable_type == "LoansModule::Loan"
  end
  def for_purchases?
    voucherable_type == "StockRegistry"
  end
  def for_supplier?
    payee_type == "Supplier"
  end
  def for_employee?
    payee_type == "User"
  end

  def add_amounts(employee)
    self.voucher_amounts << employee.voucher_amounts
    employee.voucher_amounts.each do |v|
      v.commercial_document_id = nil
      v.commercial_document_type = nil
      v.save
    end
  end

  def self.generate_number_for(voucher)
    return  voucher.number = Voucher.last.number.succ if Voucher.exists?
    voucher.number = "000000000001"
  end



  private

  def set_date
    self.date ||= Time.zone.now
  end
end
