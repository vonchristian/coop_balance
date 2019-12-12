module AccountingModule
  class Amount < ApplicationRecord
    audited
    monetize :amount_cents, as: :amount, numericality: true

    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: true
    belongs_to :commercial_document, polymorphic: true, optional: true, touch: true

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
    def self.cash_amounts
      with_cash_accounts
    end

    def self.total_cash_amount
      where(account: Employees::EmployeeCashAccount.cash_accounts).total
    end

    def self.for_recorder(args={})
      joins(:entry).where('entries.recorder_id' => args[:recorder_id])
    end


    def self.entered_on(args={})
      current_date = Date.current
      from_date  = args[:from_date] || current_date - 999.years
      to_date    = args[:to_date]   || current_date
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      not_cancelled.where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end

    def self.for_loans
      where(commercial_document_type: "LoansModule::Loan")
    end

    def debit?
      type == "AccountingModule::DebitAmount"
    end

    def credit?
      type == "AccountingModule::CreditAmount"
    end

    def self.total
      total = not_cancelled.pluck(:amount_cents).sum
      Money.new(total).amount
    end

    def self.balance(args={})
      balance_finder(args).new(args.merge(amounts: self)).compute
    end

    def self.balance_for_new_record
      balance = BigDecimal('0')
      self.all.each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end

    def account_code
      account.code
    end

    private
    def self.balance_finder(args={})
      if args.present?
        klass = args.compact.keys.sort.map{ |key| key.to_s.titleize }.join.gsub(" ", "")
      else
        klass = "DefaultBalanceFinder"
      end
      ("AccountingModule::BalanceFinders::" + klass).constantize
    end
  end
end
