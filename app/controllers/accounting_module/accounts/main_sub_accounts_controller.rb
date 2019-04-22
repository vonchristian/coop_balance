module AccountingModule
	module Accounts
		class MainSubAccountsController < ApplicationController

			def index
				@account = current_cooperative.accounts.find(params[:account_id])
				@main_sub_accounts = AccountingModule::Account.main_sub_accounts_for(account: @account)
				@sub_accounts = AccountingModule::Account.sub_accounts_for(account: @account)
			end

			def new
				@account = current_cooperative.accounts.find(params[:account_id])
				@main_sub_accounts = AccountingModule::Account.main_sub_accounts_for(account: @account)
				if params[:search].present?
					@sub_accounts = @account.type.constantize.where(main_account_id: nil).text_search(params[:search]).order(:code).paginate(:page => params[:page], :per_page => 30)
				else
					@sub_accounts = @account.type.constantize.where(main_account_id: nil).order(:code).paginate(:page => params[:page], :per_page => 30)
				end
				@grouping = AccountsGrouping.new
			end

			def create
				@account = current_cooperative.accounts.find(params[:account_id])
				@grouping = AccountsGrouping.new(sub_account_params)
				if @grouping.group!
					redirect_to new_accounting_module_account_main_sub_account_path(@account), notice: "Accounts: #{@grouping.find_accounts.uniq.pluck(:name).join(", ")} added to group."
				else
					render :new
				end
			end

			def destroy
				@account = current_cooperative.accounts.find(params[:account_id])
				@sub_account = current_cooperative.accounts.find(params[:id])
				@sub_account.update(main_account_id: nil)
				redirect_to new_accounting_module_account_main_sub_account_path(@account), notice: "Account removed from group."
			end

			private
			def sub_account_params
				params.require(:accounts_grouping).permit(
					:main_account_id,
					:cooperative_id,
					sub_account_ids: []
				)
			end
		end
	end
end