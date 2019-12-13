module AccountingModule
  module AccountCategories
    class LevelOneAccountCategoriesController < ApplicationController
      def index
        @pagy, @categories = pagy(current_office.level_one_account_categories)
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

      def show
        @category = current_office.level_one_account_categories.find(params[:id])
      end

      def edit
        @category = current_office.level_one_account_categories.find(params[:id])
      end

      def update
        @category = current_office.level_one_account_categories.find(params[:id])
        @category.update(update_category_params)
        if @category.valid?
          @category.save!
          redirect_to accounting_module_level_one_account_category_url(@category), notice: 'Category updated successfully.'
        else
          render :edit
        end
      end

      private
      def category_params
        params.require(:accounting_module_level_one_account_category_registration).
        permit(:title, :code, :contra, :type, :office_id, :level_two_account_category_id)
      end
      
      def update_category_params
        params.require(@category.class.to_s.underscore.gsub("/", "_").to_sym).
        permit(:title, :code, :contra, :type, :level_two_account_category_id)
      end
    end
  end
end
