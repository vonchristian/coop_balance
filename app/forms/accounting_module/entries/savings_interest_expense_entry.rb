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
        Voucher.find_by(account_number: account_number)
      end

      def create_voucher
        voucher = Voucher.new(
          account_number:   account_number,
          payee:            find_employee,
          preparer:         find_employee,
          office:           find_employee.office,
          cooperative:      find_employee.cooperative,
          description:      description,
          reference_number: reference_number,
          date:             date
        )
        find_cooperative.savings.has_minimum_balances.each do |saving|
          voucher.voucher_amounts.debit.build(
            cooperative: find_employee.cooperative,
            account: saving.interest_expense_account,
            amount: saving.computed_interest(to_date: date),
            commercial_document: saving)
          voucher.voucher_amounts.credit.build(
            cooperative:         find_employee.cooperative,
            account:             saving.saving_product_account,
            amount:              saving.computed_interest(to_date: date),
            commercial_document: saving
          )
        end
        voucher.save!
      end
      def find_employee
        User.find(employee_id)
      end
      def find_cooperative
        find_employee.cooperative
      end
    end
  end
end
