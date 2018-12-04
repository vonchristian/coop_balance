module Vouchers
  class VoucherAmount < ApplicationRecord
      monetize :amount_cents, as: :amount, numericality: true
            }
    enum amount_type: [:debit, :credit]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :voucher
    belongs_to :cooperative
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication", optional: true
    belongs_to :recorder, class_name: "User", foreign_key: 'recorder_id'
    belongs_to :commercial_document, polymorphic: true
    has_many :amount_adjustments, class_name: "Vouchers::AmountAdjustment", dependent: :destroy

    delegate :name, to: :account, prefix: true
    delegate :entry, to: :voucher, allow_nil: true

    validates :account_id, :amount_type, presence: true

    def self.total
      sum(&:adjusted_amount)
    end

    def recent_amount_adjustment
      amount_adjustments.recent
    end

    def self.for_account(args={})
      where(account: args[:account])
    end

    def self.excluding_account(args={})
      where.not(account: args[:account])
    end

    def self.accounts
      accounts = pluck(:account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.total_cash_amount
      for_account(account: Employees::EmployeeCashAccount.cash_accounts).total
    end

    def self.with_no_vouchers
      select{ |a| a.voucher.nil? }
    end

    def adjusted_amount
      if recent_amount_adjustment.present?
        recent_amount_adjustment.adjusted_amount(adjustable: self)
      else
        amount.amount
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
