module BankAccounts
  class DepositLineItemProcessing
    include ActiveModel::Model
    attr_accessor :bank_account_id, :employee_id, :amount, :description,
                  :reference_number, :account_number, :date,
                  :offline_receipt, :cash_account_id, :account_number, :payee_id

    validates :amount, presence: true, numericality: { greater_than: 0.01 }
    validates :reference_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        create_deposit_voucher
      end
    end

    def find_voucher
      TreasuryModule::Voucher.find_by(account_number: account_number)
    end

    def find_bank_account
      BankAccount.find(bank_account_id)
    end

    def find_employee
      User.find(employee_id)
    end

    private

    def create_deposit_voucher
      voucher = TreasuryModule::Voucher.new(
        payee: find_payee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: description,
        reference_number: reference_number,
        account_number: account_number,
        date: date
      )
      voucher.voucher_amounts.debit.build(
        account: debit_account,
        amount: amount
      )
      voucher.voucher_amounts.credit.build(
        account: credit_account,
        amount: amount
      )
      voucher.save!
    end

    def find_payee
      User.find(payee_id)
    end

    def credit_account
      AccountingModule::Account.find(cash_account_id)
    end

    def debit_account
      find_bank_account.cash_account
    end
  end
end
