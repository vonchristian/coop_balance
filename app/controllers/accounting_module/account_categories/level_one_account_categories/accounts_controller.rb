module AccountingModule
  module AccountCategories
    module LevelOneAccountCategories
      class AccountsController < ApplicationController
        def index
          @category        = current_office.level_one_account_categories.find(params[:level_one_account_category_id])
          if params[:search].present?
            @pagy, @accounts = pagy(@category.accounts.text_search(params[:search]))
          else 
            @pagy, @accounts = pagy(@category.accounts)
          end 
        end
      end
    end
  end
end 
