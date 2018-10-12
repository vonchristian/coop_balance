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
  end
end
