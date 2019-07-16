module AccountingModule
  module Settings
    class SubCategoriesController < ApplicationController
      def new
        @account_category = current_cooperative.account_categories.find(params[:account_category_id])
        @sub_category = @account_category.sub_categories.build
      end
      def create
        @account_category = current_cooperative.account_categories.find(params[:account_category_id])
        @sub_category = @account_category.sub_categories.create(sub_category_params)
        if @sub_category.valid?
          @sub_category.save!
          redirect_to accounting_module_account_category_path(@account_category), notice: 'Sub category created successfully'
        else
          render :new
        end
      end

      private
      def sub_category_params
        params.require(:accounting_module_account_category).
        permit(:title, :category_type, :cooperative_id, :code)
      end
    end
  end
end
