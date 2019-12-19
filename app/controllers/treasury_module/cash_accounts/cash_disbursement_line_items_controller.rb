module TreasuryModule
  module CashAccounts
    class CashDisbursementLineItemsController < ApplicationController
      def new
        authorize [:treasury_module, :cash_disbursement]
        @cash_account           = current_office.accounts.find(params[:cash_account_id])
        @disbursement_line_item = TreasuryModule::CashAccounts::DisbursementLineItem.new
        @disbursement           = Vouchers::VoucherProcessing.new
        
        if params[:payee_type] && params[:payee_id]
          @payee  = params[:payee_type].constantize.find_by(id: params[:payee_id])
          
          current_cart.update(customer: @payee)
        end 

        if params[:payee_search]
          @pagy, @payees = pagy(current_office.member_memberships.text_search(params[:payee_search]))
        end

        if params[:account_id].present?
          @account = current_office.accounts.find_by(id: params[:account_id])
        end

        if params[:search].present?
          @account = current_office.accounts.find_by(id: params[:account_id])
          @pagy, @accounts = pagy(current_office.accounts.text_search(params[:search]))
        end
      end

      def create
        authorize [:treasury_module, :cash_disbursement]

        @cash_account           = current_office.accounts.find(params[:cash_account_id])
        @disbursement_line_item = TreasuryModule::CashAccounts::DisbursementLineItem.new(disbursement_params)
        if @disbursement_line_item.valid?
          @disbursement_line_item.process!
          redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "Added successfully"
        else
          render :new
        end
      end

      private
      def disbursement_params
        params.require(:treasury_module_cash_accounts_disbursement_line_item).
        permit(:amount, :account_id, :employee_id, :cash_account_id, :cart_id)
      end
    end
  end
end
