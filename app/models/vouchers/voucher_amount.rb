module Vouchers
  class VoucherAmount < ApplicationRecord
    enum amount_type: [:debit, :credit]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :voucher
    belongs_to :recorder, class_name: "User", foreign_key: 'recorder_id'
    belongs_to :commercial_document, polymorphic: true
    belongs_to :amount_adjustment, class_name: "Vouchers::AmountAdjustment"

    delegate :name, to: :account, prefix: true

    validates :amount, :account_id, :amount_type, presence: true
    validates :amount, numericality: true

    def self.total
      sum(:amount)
    end

    def self.for_account(args={})
      where(account: args[:account])
    end

    def self.excluding_account(args={})
      where.not(account: args[:account])
    end

    def self.total_cash_amount
      for_account(account: Employees::EmployeeCashAccount.cash_accounts).sum(:amount)
    end

    def self.with_no_vouchers
      select{ |a| a.voucher.nil? }
    end

    def adjusted_amount
      if amount_adjustment
        amount_adjustment.adjusted_amount(voucher_amount: self)
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
