module AccountingModule
  module IocDistributions
    class IocToSavingFinder
      attr_reader :cart, :office

      def initialize(cart:)
        @cart     = cart
        @employee = @cart.employee
        @office   = @employee.office
      end

      def saving_ids
        savings_account_ids = []
        ids = cart.voucher_amounts.pluck(:account_id).uniq.compact.flatten
        savings_account_ids << office.savings.where(liability_account_id: ids).ids
        savings_account_ids.flatten.compact.uniq
      end

      def amount(saving)
        cart.voucher_amounts.where(account: saving.liability_account).total
      end

      delegate :account_owner_name, to: :saving

      def saving
        office.savings.find_by!(liability_account_id: voucher_amount.account_id)
      end
    end
  end
end
