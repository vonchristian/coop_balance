module AccountingModule
  module AccountCategories
    module LevelThreeAccountCategories
      class SettingsController < ApplicationController
        def index
          @category = current_office.level_three_account_categories.find(params[:level_three_account_category_id])
        end
      end
    end
  end
end
