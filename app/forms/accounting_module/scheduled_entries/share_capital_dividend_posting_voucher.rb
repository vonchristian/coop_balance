module AccountingModule
  module ScheduledEntries
    class ShareCapitalDividendPostingVoucher
      include ActiveModel::Model
      attr_accessor :to_date, :cooperative_id, :account_number, :employee_id

      def process!
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end

      def find_voucher
        find_cooperative.vouchers.find_by(account_number: account_number)
      end

      private

      def create_voucher
        voucher = Voucher.new(
          account_number: account_number,
          payee: find_employee,
          preparer: find_employee,
          office: find_employee.office,
          cooperative: find_cooperative,
          description: "Journal entry for share capital dividend posting",
          number: "system",
          date: to_date
        )
        find_cooperative.share_capitals.each do |share_capital|
          voucher.voucher_amounts.debit.build(
            cooperative: find_cooperative,
            account: share_capital.share_capital_product_interest_payable_account,
            amount: share_capital.computed_interest(to_date: DateTime.parse(to_date))
          )
        end
        voucher.voucher_amounts.credit.build(
          cooperative: find_cooperative,
          account: share_capital.share_capital_product_paid_up_account,
          amount: share_capital.computed_interest(to_date: DateTime.parse(to_date))
        )
        voucher.save!
      end

      def find_cooperative
        Cooperative.find(cooperative_id)
      end

      def find_employee
        find_cooperative.users.find(employee_id)
      end
    end
  end
end
