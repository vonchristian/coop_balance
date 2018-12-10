module AccountingModule
  class Amount < ApplicationRecord
    audited
    monetize :amount_cents, as: :amount, numericality: true
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'
    belongs_to :commercial_document, polymorphic: true, optional: true

    validates :type, :amount, :entry, :account, presence: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :reference_number, :description, :entry_date,  to: :entry
    delegate :name, to: :recorder, prefix: true

    def self.not_cancelled
      joins(:entry).where('entries.cancelled' => false)
    end
    def self.cancelled
      joins(:entry).where('entries.cancelled' => true)
    end
    def self.for_account(args={})
      where(account_id: args[:account_id])
    end

    def self.excluding_account(args={})
      where.not(account_id: args[:account_id])
    end

    def self.without_cash_accounts
      excluding_account(account_id: Employees::EmployeeCashAccount.cash_accounts.ids)
    end

    def self.accounts
      accounts = pluck(:account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.with_cash_accounts
      for_account(account_id: Employees::EmployeeCashAccount.cash_accounts.ids)
    end


    def self.total_cash_amount
      where(account: Employees::EmployeeCashAccount.cash_accounts).total
    end

    def self.for_recorder(args={})
      joins(:entry).where('entries.recorder_id' => args[:recorder_id])
    end

    def self.for_commercial_document(args={})
      where(commercial_document: args[:commercial_document])
    end

    def self.entered_on(args={})
      from_date = args[:from_date] || Date.today - 999.years
      to_date = args[:to_date] || Date.today
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      not_cancelled.where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end

    def self.loan_principal_amount(args={})
      account_ids = LoansModule::LoanProduct.accounts.ids
      if args[:loan].present?
        where(commercial_document: args[:loan]).where(account_id: account_ids).total
      else
        where(account_id: account_ids).total
      end
    end
    def self.for_loans
      where(commercial_document_type: "LoansModule::Loan")
    end

    def self.loan_interest_amount(args={})
      account_ids = LoansModule::LoanProduct.interest_revenue_accounts.ids
      if args[:loan].present?
        where(commercial_document: args[:loan]).where(account_id: account_ids).total
      else
        where(account_id: account_ids).total
      end
    end

    def self.loan_penalty_amount(args={})
      account_ids = LoansModule::LoanProduct.penalty_revenue_accounts.ids
      if args[:loan].present?
        where(commercial_document: args[:loan]).where(account_id: account_ids).total
      else
        where(account_id: account_ids).total
      end
    end
    def self.total_loan_payment(args={})
      loan_principal_amount(args) +
      loan_interest_amount(args) +
      loan_penalty_amount(args)
    end

    def debit?
      type == "AccountingModule::DebitAmount"
    end

    def credit?
      type == "AccountingModule::CreditAmount"
    end

    def self.total
      all.map{ |a| a.amount.amount }.sum
    end
  end
end
