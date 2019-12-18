module TreasuryModule 
  module CashAccounts
    class DisbursementLineItem 
      include ActiveModel::Model
      
      attr_accessor :cart_id, :account_id, :amount, :cash_account_id, :employee_id 

      def process!
        if valid?
          ApplicationRecord.transaction do 
            create_amount 
            create_cash_amount
          end
          update_cash_amount
        end
      end

      private 

      def create_amount 
        find_cart.voucher_amounts.credit.create!(
          amount:      amount, 
          account_id:  account_id,
          cooperative: find_employee.cooperative,
          recorder:    find_employee
        )
      end

      def update_cash_amount
        TreasuryModule::CashAccounts::TotalCashAccountUpdater.new(cart: find_cart, cash_account: find_cash_account).update_amount!
      end
      
      def create_cash_amount
        return false if find_cart.voucher_amounts.find_by(account_id: cash_account_id).present?
       
        find_cart.voucher_amounts.debit.create!(
          amount:      amount,
          account_id:  cash_account_id,
          cooperative: find_employee.cooperative,
          recorder:    find_employee
        )
      end

      def find_cart 
        find_employee.carts.find(cart_id)
      end

      def total_amount
        find_cart.voucher_amounts.credit.total
      end

      def find_employee
        User.find(employee_id)
      end
      def find_office 
        find_employee.office 
      end
      def find_cash_account
        find_office.cash_accounts.find(cash_account_id)
      end
    end
  end
end