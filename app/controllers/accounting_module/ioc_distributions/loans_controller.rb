module AccountingModule
  module IocDistributions
    class LoansController < ApplicationController 
      def new
        if params[:search].present?
          @pagy, @loans           = pagy(current_office.loans.text_search(params[:search]))
        else 
          @pagy, @loans           = pagy(current_office.loans.includes(:borrower, :loan_product, :receivable_account))
        end
        @pagy, @voucher_amounts = pagy(current_cart.voucher_amounts)
        @pagy, @loans_with_payments    = pagy(current_office.loans.where(id: AccountingModule::IocDistributions::IocToLoanFinder.new(cart: current_cart).loan_ids).includes(:borrower, :receivable_account, :penalty_revenue_account, :interest_revenue_account))
        @voucher = AccountingModule::IocDistributions::IocVoucher.new 
      end 
      def destroy 
        @loan = current_office.loans.find(params[:id])
        current_cart.voucher_amounts.where(account_id: @loan.receivable_account).destroy_all
        current_cart.voucher_amounts.where(account_id: @loan.interest_revenue_account).destroy_all
        current_cart.voucher_amounts.where(account_id: @loan.penalty_revenue_account).destroy_all
        redirect_to new_accounting_module_ioc_distributions_loan_url, alert: "removed from cart."
      end 
    end 
  end 
end 