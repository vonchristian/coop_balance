
module ProgramSubscriptions
  class PaymentProcessing
    include ActiveModel::Model
    attr_accessor :program_subscription_id, :cash_account_id, :employee_id, :amount, :reference_number, :account_number, :date, :description, :member_id
    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :date, presence: true

    def save
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end
    def find_voucher
      Voucher.find_by(account_number: account_number)
    end
    private
    def create_voucher
      voucher = Voucher.new(
        payee:            find_member,
        office:           find_employee.office,
        cooperative:      find_employee.cooperative,
        preparer:         find_employee,
        description:      description,
        reference_number: reference_number,
        account_number:   account_number,
        date:             date)
      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account:     debit_account,
        amount:      amount)
      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account:     credit_account,
        amount:      amount)
      voucher.save!
    end

    def debit_account
     find_employee.cash_accounts.find(cash_account_id)
    end

    def credit_account
      find_program_subscription.program_account
    end

    def find_program_subscription
      MembershipsModule::ProgramSubscription.find(program_subscription_id)
    end
    def find_member
      Member.find(member_id)
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
