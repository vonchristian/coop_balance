module AccountingModule
  module AccountCategories
    class LevelTwoAccountCategoriesController < ApplicationController
      def index
      end

      def new
        @level_two_account_category = AccountingModule::LevelTwoAccountCategoryRegistration.new
      end

      def create
        @level_two_account_category = AccountingModule::LevelTwoAccountCategoryRegistration.new(category_params)
        if @level_two_account_category.valid?
          @level_two_account_category.register!
          redirect_to accounting_module_level_two_account_categories_url, notice: 'Category created successfully.'
        else
          render :new
        end
      end

      private
      def category_params
        params.require(:accounting_module_level_two_account_category_registration).
        permit(:title, :code, :contra, :type, :office_id, :level_three_account_category_id)
      end
    end
  end
end
