module AccountingModule
  class CreditAmountsController < ApplicationController
    def edit
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @entry = @amount.entry
      @accounts = AccountingModule::Account.
      except_account(account_ids: LoansModule::Loan.receivable_accounts.ids).
      except_account(account_ids: LoansModule::Loan.interest_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.penalty_revenue_accounts.ids).
      except_account(account_ids: LoansModule::Loan.accrued_income_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::Saving.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.liability_accounts.ids).
      except_account(account_ids: MembershipsModule::TimeDeposit.interest_expense_accounts.ids).
      except_account(account_ids: MembershipsModule::ShareCapital.equity_accounts.ids).
      except_account(account_ids: MembershipsModule::ShareCapital.interest_on_capital_accounts.ids)
    end
    def update
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @amount.update(amount_params)
      if @amount.save
        redirect_to accounting_module_entry_url(@amount.entry), notice: "Amount updated successfully"
      else
        render :edit
      end
    end

    private
    def amount_params
      params.require(:accounting_module_credit_amount).permit(:amount, :account_id)
    end
  end
end
