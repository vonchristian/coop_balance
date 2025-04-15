module SavingsAccounts
  class Closing
    include ActiveModel::Model
    attr_accessor :savings_account_id, :amount, :closing_account_fee,
                  :reference_number, :date, :recorder_id, :cash_account_id, :account_number

    validates :amount, presence: true, numericality: true
    validates :reference_number, :date, :cash_account_id, presence: true
    validate :amount_less_than_current_cash_on_hand?
    validate :amount_is_less_than_balance?

    def process!
      return unless valid?

      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    def find_voucher
      TreasuryModule::Voucher.find_by(account_number: account_number)
    end

    private

    def find_savings_account
      DepositsModule::Saving.find_by(id: savings_account_id)
    end

    def create_voucher
      voucher =  TreasuryModule::Voucher.new(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: "Closing of savings account",
        reference_number: reference_number,
        account_number: account_number,
        date: date,
        payee: find_savings_account.depositor
      )
      voucher.voucher_amounts.debit.build(
        account: debit_account,
        amount: find_savings_account.balance
      )
      voucher.voucher_amounts.credit.build(
        account: cash_account,
        amount: amount
      )
      if !closing_account_fee.nil? && !closing_account_fee.to_d.zero?
        voucher.voucher_amounts.credit.build(
          account: closing_fee_account,
          amount: closing_account_fee
        )
      end
      voucher.save!
    end

    def closing_fee_account
      find_savings_account.closing_account
    end

    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def debit_account
      find_savings_account.liability_account
    end

    def find_employee
      User.find(recorder_id)
    end

    def amount_is_less_than_balance?
      errors[:amount] << "Amount exceeded balance" if amount.to_f > find_savings_account.balance
    end

    def amount_less_than_current_cash_on_hand?
      errors[:amount] << "Amount exceeded current cash on hand" if amount.to_f > cash_account.balance
    end
  end
end
