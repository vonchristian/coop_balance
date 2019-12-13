module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class SettingsController < ApplicationController
        def index
          @category = current_office.level_two_account_categories.find(params[:level_two_account_category_id])
        end
      end
    end
  end
end 
