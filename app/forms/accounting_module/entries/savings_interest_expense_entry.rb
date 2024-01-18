module AccountingModule
  module Entries
    class SavingsInterestExpenseEntry
      include ActiveModel::Model

      attr_accessor :date, :employee_id, :description, :reference_number, :account_number

      validates :date, :description, :reference_number, :account_number, :employee_id, presence: true

      def process!
        create_voucher
      end

      def find_voucher
        find_office.vouchers.find_by!(account_number: account_number)
      end

      def create_voucher
        voucher = find_office.vouchers.build(
          account_number: account_number,
          payee: find_employee,
          preparer: find_employee,
          cooperative: find_employee.cooperative,
          description: description,
          reference_number: reference_number,
          date: date
        )

        find_office.savings.each do |saving|
          voucher.voucher_amounts.debit.build(
            account: saving.interest_expense_account,
            amount: computed_interest(saving)
          )
          voucher.voucher_amounts.credit.build(
            account: saving.liability_account,
            amount: computed_interest(saving)
          )
        end

        voucher.save!
      end

      def find_employee
        User.find(employee_id)
      end

      def find_office
        find_employee.office
      end

      def find_cooperative
        find_employee.cooperative
      end

      def computed_interest(saving)
        SavingsModule::InterestComputation.new(saving: saving).compute_interest!
      end
    end
  end
end
