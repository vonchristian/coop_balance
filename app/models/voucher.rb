class Voucher < ApplicationRecord
  include PgSearch
  enum status: [:disbursed, :cancelled]
  pg_search_scope :text_search, :against => [:number, :description]
  multisearchable against: [:number, :description]
  has_one :entry, class_name: "AccountingModule::Entry", as: :commercial_document
  belongs_to :voucherable, polymorphic: true
  belongs_to :payee, polymorphic: true
  belongs_to :preparer, class_name: "User", foreign_key: 'preparer_id'
  belongs_to :disburser, class_name: "User", foreign_key: 'disburser_id'
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy

  delegate :name, :payable_amount, to: :voucherable, allow_nil: true
  delegate :full_name, :current_occupation, to: :preparer, prefix: true
  delegate :full_name, :current_occupation, to: :disburser, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true

  before_save :set_date

  def add_amounts(payee)
    self.voucher_amounts << payee.voucher_amounts
    payee.voucher_amounts.each do |v|
      v.commercial_document_id = nil
      v.commercial_document_type = nil
      v.save
    end
  end

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


  def self.generate_number_for(voucher)
    return  voucher.number = Voucher.order(created_at: :asc).last.number.succ if Voucher.exists? && Voucher.order(created_at: :asc).last.number.present?
    voucher.number = "000000000001"
  end

  private
  def set_date
    self.date ||= Time.zone.now
  end
end
