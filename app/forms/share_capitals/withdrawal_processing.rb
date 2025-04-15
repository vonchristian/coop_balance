module ShareCapitals
  class WithdrawalProcessing
    include ActiveModel::Model
    attr_accessor :share_capital_id, :amount, :date, :reference_number, :description, :employee_id, :account_number, :cash_account_id

    validates :share_capital_id, :amount, :date, :reference_number, :description, :employee_id, :account_number, :cash_account_id, presence: true
    def process!
      return unless valid?

      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    private

    def create_voucher
      voucher =  TreasuryModule::Voucher.new(
        cooperative: find_employee.cooperative,
        account_number: account_number,
        office: find_employee.office,
        preparer: find_employee,
        date: date,
        description: description,
        reference_number: reference_number,
        payee: find_share_capital.subscriber
      )
      voucher.voucher_amounts.debit.build(account: find_share_capital.share_capital_equity_account, amount: amount)
      voucher.voucher_amounts.credit.build(account: cash_account, amount: amount)
      voucher.save!
    end

    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def find_employee
      User.find(employee_id)
    end

    def find_share_capital
      find_employee.office.share_capitals.find(share_capital_id)
    end
  end
end
