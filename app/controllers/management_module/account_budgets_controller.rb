module ManagementModule
  class AccountBudgetsController < ApplicationController
    def index
      @expenses = current_cooperative.accounts.expenses.active
      @revenues = current_cooperative.accounts.revenues.active
    end

    def new
      @accounts = if params[:search].present?
                    current_cooperative.accounts.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
                  else
                    current_cooperative.accounts.all.paginate(page: params[:page], per_page: 25)
                  end
      @account_budget = AccountBudgetProcessing.new
    end

    def create
      @account_budget = AccountBudgetProcessing.new(account_budget_params)
      if @account_budget.valid?
        @account_budget.process!
        redirect_to new_management_module_account_budget_url, notice: 'Budget set successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def account_budget_params
      params.require(:account_budget_processing).permit(:account_id, :year, :proposed_amount)
    end
  end
end
