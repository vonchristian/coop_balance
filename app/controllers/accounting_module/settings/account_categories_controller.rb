module AccountingModule
  module Settings
    class AccountCategoriesController < ApplicationController
      def new
        @account_category = current_cooperative.account_categories.build
      end
      def create
        @account_category = current_cooperative.account_categories.create(category_params)
        if @account_category.valid?
          @account_category.save!
          redirect_to accounting_module_settings_url, notice: 'Account saved successfully'
        else
          render :new
        end
      end
      
      def show
        @account_category = current_cooperative.account_categories.find(params[:id])
      end

      private
      def category_params
        params.require(:accounting_module_account_category).
        permit(:title, :category_type)
      end
    end
  end
end
