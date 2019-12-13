module AccountingModule
  module AccountCategories
    class LevelTwoAccountCategoriesController < ApplicationController
      def index
        @pagy, @categories = pagy(current_office.level_two_account_categories)
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

      def show
        @category = current_office.level_two_account_categories.find(params[:id])
      end

      def edit
        @category = current_office.level_two_account_categories.find(params[:id])
      end

      def update
        @category = current_office.level_two_account_categories.find(params[:id])
        @category.update(update_category_params)
        if @category.valid?
          @category.save!
          redirect_to accounting_module_level_two_account_category_url(@category), notice: 'Category updated successfully'
        else
          render :edit
        end
      end

      private
      def category_params
        params.require(:accounting_module_level_two_account_category_registration).
        permit(:title, :code, :contra, :type, :office_id, :level_three_account_category_id)
      end

      def update_category_params
        params.require(@category.class.to_s.underscore.gsub("/", "_").to_sym).
        permit(:title, :code, :type, :contra, :level_three_account_category_id)
      end
    end
  end
end
