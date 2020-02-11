module TimeDeposits
  class WithdrawalLineItemProcessing
    include ActiveModel::Model
    attr_accessor :time_deposit_id, :employee_id, :amount, :interest,  :or_number, :account_number, :date, :offline_receipt, :cash_account_id, :account_number

    validates :amount, :interest,  presence: true, numericality: { greater_than: 0.01 }
    validates :or_number, :employee_id, presence: true

    def process!
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    def find_voucher
      Voucher.find_by(account_number: account_number)
    end

    def find_time_deposit
      MembershipsModule::TimeDeposit.find(time_deposit_id)
    end
    def find_employee
      User.find(employee_id)
    end
    private
    def create_voucher
      voucher = Voucher.new(
        payee:            find_time_deposit.depositor,
        office:           find_employee.office,
        cooperative:      find_employee.cooperative,
        preparer:         find_employee,
        description:      "Time deposit withdrawal.",
        reference_number: or_number,
        account_number:   account_number,
        date:             date)
      voucher.voucher_amounts.debit.build(
        account: debit_account,
        amount: amount.to_f)
      
      voucher.voucher_amounts.debit.build(
        account: interest_account,
        amount: interest.to_f)
      voucher.voucher_amounts.credit.build(
        account: cash_account,
        amount:  amount.to_f + interest.to_f)
      voucher.save!
    end

    def set_time_deposit_as_withdrawn
      find_time_deposit.update(withdrawn: true)
    end

    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def debit_account
      find_time_deposit.liability_account
    end

    def interest_account
      find_time_deposit.interest_expense_account
    end

    def principal_amount_not_more_than_balance
      errors[:amount] << "Must be less than or equal to balance." if amount.to_f > find_time_deposit.balance
    end
  end
end
