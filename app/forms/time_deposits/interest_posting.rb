module TimeDeposits
  class InterestPosting
    include ActiveModel::Model

    attr_accessor :date, :reference_number, :description, :amount, :time_deposit_id, :employee_id, :account_number

    validates :date, :reference_number, :description, :amount, :time_deposit_id, :employee_id, :account_number, presence: true

    def find_voucher
      find_office.vouchers.find_by(account_number: account_number)
    end

    def process!
      return unless valid?

      ApplicationRecord.transaction do
        create_voucher
      end
    end

    private

    def create_voucher
      voucher = find_office.vouchers.build(
        account_number: account_number,
        payee: find_time_deposit.depositor,
        preparer: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: description,
        reference_number: reference_number,
        date: date
      )

      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account: find_time_deposit.liability_account,
        amount: amount
      )

      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account: find_time_deposit.interest_expense_account,
        amount: amount
      )
      voucher.save!
    end

    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_time_deposit
      find_office.time_deposits.find(time_deposit_id)
    end
  end
end