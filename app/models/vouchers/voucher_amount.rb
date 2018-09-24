module Vouchers
  class VoucherAmount < ApplicationRecord
    enum amount_type: [:debit, :credit]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :voucher
    belongs_to :commercial_document, polymorphic: true
    delegate :name, to: :account, prefix: true
    belongs_to :amount_adjustment, class_name: "Vouchers::AmountAdjustment"
    validates  :amount, :account_id,  :amount_type, presence: true
    validates :amount, numericality: true


    def self.total
      sum(:amount)
    end

    def self.with_no_vouchers
      select{ |a| a.voucher.nil? }
    end
    def adjusted_amount
      if amount_adjustment && amount_adjustment.amount
        amount - amount_adjustment.amount
      elsif amount_adjustment && amount_adjustment.number_of_payments && amount_adjustment.number_of_payments > 0
        loan_application.amortization_schedules.order(date: :asc).first(number_of_payments).sum(&:interest)
      elsif amount_adjustment && amount_adjustment.percent
        amount * (amount_adjustment.percent / 100.0)
      else
        amount
      end
    end
    def self.balance_for_new_record
      balance = BigDecimal.new('0')
      self.all.each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end
  end
end
