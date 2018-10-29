module SavingsAccounts
  class Closing
    include ActiveModel::Model
    attr_accessor :savings_account_id, :amount, :closing_account_fee,
    :reference_number, :date, :recorder_id, :cash_account_id, :account_number

    validates :amount, presence: true, numericality: true
    validates :reference_number, presence: true
    validate :amount_less_than_current_cash_on_hand?
    validate :amount_is_less_than_balance?

    def process!
      if valid?
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end
    end

    def find_voucher
      Voucher.find_by(account_number: account_number)
    end

    private

    def find_savings_account
      MembershipsModule::Saving.find_by_id(savings_account_id)
    end

    def create_voucher
      voucher = Voucher.new(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: 'Closing of savings account',
        number: reference_number,
        account_number: account_number,
        date: date,
        payee: find_savings_account.depositor
      )
        voucher.voucher_amounts.debit.build(
          account: debit_account,
          amount: find_savings_account.balance,
          commercial_document: find_savings_account
        )
        voucher.voucher_amounts.credit.build(
          account: cash_account,
          amount: amount,
          commercial_document: find_savings_account
        )
        voucher.voucher_amounts.credit.build(
          account: closing_fee_account,
            amount: closing_account_fee,
            commercial_document: find_savings_account
          )
        voucher.save!
    end


    def closing_fee_account
      CoopConfigurationsModule::SavingsAccountConfig.default_closing_account
    end

    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def debit_account
      find_savings_account.saving_product_account
    end

    def find_employee
      User.find(recorder_id)
    end

    def amount_is_less_than_balance?
      errors[:amount] << "Amount exceeded balance"  if amount.to_f > find_savings_account.balance
    end

    def amount_less_than_current_cash_on_hand?
      errors[:amount] << "Amount exceeded current cash on hand" if amount.to_f > cash_account.balance
    end
  end

end