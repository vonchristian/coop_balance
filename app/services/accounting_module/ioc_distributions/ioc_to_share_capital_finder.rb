module AccountingModule
  module IocDistributions
    class IocToShareCapitalFinder
      attr_reader :cart, :office 

      def initialize(cart:)
        @cart     = cart
        @employee = @cart.employee
        @office   = @employee.office 
      end 

      def share_capital_ids
        share_capital_ids = []
        ids = cart.voucher_amounts.pluck(:account_id).uniq.compact.flatten
        share_capital_ids << office.share_capitals.where(equity_account_id: ids).ids
        share_capital_ids.flatten.compact.uniq

      end

      def amount(share_capital)
        cart.voucher_amounts.where(account: share_capital.share_capital_equity_account).total 
      end 

      def account_owner_name
        share_capital.account_owner_name
      end 
      def share_capital
        office.share_capitals.find_by!(equity_account_id: voucher_amount.account_id)
      end 
    end 
  end 
end 
