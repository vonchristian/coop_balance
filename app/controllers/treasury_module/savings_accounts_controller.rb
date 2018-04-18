module TreasuryModule
  class SavingsAccountsController < ApplicationController
   def index
      if params[:search].present?
        @savings_accounts = MembershipsModule::Saving.text_search(params[:search])
      else
        @savings_accounts = MembershipsModule::Saving.includes([:member, :saving_product]).all
      end
    end
    def show
      @savings_account = MembershipsModule::Saving.includes(entries: :recorder).find(params[:id])
    end
    def new
      @savings_account = Memberships::SavingsAccountOpening.new
    end
    def create
      @savings_account = Memberships::SavingsAccountOpening.new(savings_account_params)
      if @savings_account.valid?
        @savings_account.save
        redirect_to savings_accounts_url, notice: "Savings account saved successfully."
      else
        render :new
      end
    end

    private
    def savings_account_params
      params.require(:memberships_savings_account_opening).
      permit(:depositor_first_name,
             :depositor_last_name,
             :saving_product_id,
             :account_number,
             :amount,
             :or_number,
             :date, :employee_id
            )
    end

  end
end
