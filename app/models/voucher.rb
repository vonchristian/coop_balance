class Voucher < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, :against => [:number, :description]
  multisearchable against: [:number, :description]
  has_one :entry, class_name: "AccountingModule::Entry", as: :commercial_document
  belongs_to :voucherable, polymorphic: true
  belongs_to :payee, polymorphic: true
  delegate :payable_amount, to: :voucherable, allow_nil: true
  has_many :voucher_amounts, dependent: :destroy
  before_save :set_date

  after_commit :set_number, on: [:create, :update]
  def self.disbursed
    all.select{|a| a.disbursed? }
  end
  def disbursed?
    entry.present?
  end
  def for_loan?
    voucherable_type == "LoansModule::Loan"
  end
  def for_purchases?
    voucherable_type == "StockRegistry"
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
        


  private
  def set_number 
    self.number = self.id.first(12).gsub("-", "")
  end
  def set_date
    self.date ||= Time.zone.now
  end
end
