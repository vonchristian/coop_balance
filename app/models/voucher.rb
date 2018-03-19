class Voucher < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, :against => [:number, :description]
  multisearchable against: [:number, :description]

  has_one :entry,            class_name: "AccountingModule::Entry", as: :commercial_document
  belongs_to :payee,         polymorphic: true
  belongs_to :preparer,      class_name: "User", foreign_key: 'preparer_id'
  belongs_to :disburser,     class_name: "User", foreign_key: 'disburser_id'
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy

  delegate :full_name, :current_occupation, to: :preparer, prefix: true
  delegate :full_name, :current_occupation, to: :disburser, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true
  delegate :avatar, to: :payee, allow_nil: true

  before_save :set_default_date

  def self.payees
    User.all + Supplier.all + Member.all
  end

  def self.unused
    disbursed.select { |a| a.payee_id.nil? }
  end

  def self.disbursed(options={})
    if options[:from_date] && options[:to_date]
      date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
      includes([:entry]).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
    else
      all
    end
  end

  def disbursed?
    entry.present?
  end

  def add_amounts(payee)
    self.voucher_amounts << payee.voucher_amounts
    payee.voucher_amounts.each do |v|
      v.commercial_document_id = nil
      v.commercial_document_type = nil
      v.save
    end
  end

  def self.generate_number_for(voucher)
    return  voucher.number = Voucher.order(created_at: :asc).last.number.succ if Voucher.exists? && Voucher.order(created_at: :asc).last.number.present?
    voucher.number = "000000000001"
  end

  def valid_for?(cart)
    cart.total_cost == self.entry.debit_amounts.total && self.commercial_document.nil?
  end

  private
  def set_default_date
    self.date ||= Time.zone.now
  end
end
