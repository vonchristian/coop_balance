module AccountingModule
  module AccountCategories
    class LevelOneAccountCategoriesController < ApplicationController
      def index
      end

      def new
        @level_one_account_category = AccountingModule::LevelOneAccountCategoryRegistration.new
      end

      def create
        @level_one_account_category = AccountingModule::LevelOneAccountCategoryRegistration.new(category_params)
        if @level_one_account_category.valid?
          @level_one_account_category.register!
          redirect_to accounting_module_level_one_account_categories_url, notice: 'Category created successfully.'
        else
          render :new
        end
      end

      private
      def category_params
        params.require(:accounting_module_level_one_account_category_registration).
        permit(:title, :code, :contra, :type, :office_id)
      end
    end
  end
end
