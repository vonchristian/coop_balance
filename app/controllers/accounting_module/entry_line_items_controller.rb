module AccountingModule
  class EntryLineItemsController < ApplicationController
    def new
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new
      @voucher = Vouchers::VoucherProcessing.new
      @accounts = AccountingModule::Account.
      except_account(account_ids: LoansModule::Loan.receivable_accounts.ids).
      except_account(account_ids: LoansModule::Loan.interest_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.penalty_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.accrued_income_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::ShareCapital.equity_accounts.ids)
      if params[:commercial_document_type] && params[:commercial_document_id]
        @commercial_document = params[:commercial_document_type].constantize.find(params[:commercial_document_id])
      end
      @accounts = AccountingModule::Account.
      except_account(account_ids: LoansModule::Loan.receivable_accounts.ids).
      except_account(account_ids: LoansModule::Loan.interest_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.penalty_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.accrued_income_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::ShareCapital.equity_accounts.ids)
    end

    def create
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new(amount_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_accounting_module_entry_line_item_url, notice: "Amount added successfully"
      else
        render :new
      end
    end
    def destroy
      @amount = current_cooperative.voucher_amounts.find(params[:id])
      @amount.destroy
      redirect_to new_accounting_module_entry_line_item_url, notice: "removed successfully"
    end

    private
    def amount_params
      params.require(:accounting_module_entries_voucher_amount_processing).
      permit(:amount, :account_id, :description, :amount_type, :employee_id, :cart_id)
    end
  end
end
