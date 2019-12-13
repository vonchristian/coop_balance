module AccountingModule
  module AccountCategories
    module LevelOneAccountCategories
      class SettingsController < ApplicationController
        def index
          @category = current_office.level_one_account_categories.find(params[:level_one_account_category_id])
        end
      end
    end
  end
end 
