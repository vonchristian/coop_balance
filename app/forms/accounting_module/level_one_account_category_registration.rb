module AccountingModule
  class LevelOneAccountCategoryRegistration
    include ActiveModel::Model
    TYPES = ['Asset', 'Liability', 'Equity', 'Revenue', 'Expense']

    attr_accessor :title, :code, :contra, :type, :office_id

    validates :title, :code, :type, :office_id, presence: true
    validates :type, inclusion: { in: TYPES }
    def register!
      if valid?
        ActiveRecord::Base.transaction do
          create_level_one_account_category
        end
      end
    end

    def normalized_type
      ("AccountingModule::AccountCategories::LevelOneAccountCategories::#{type}")
    end

    private
    def create_level_one_account_category
      find_office.level_one_account_categories.create!(
        title:  title,
        code:   code,
        type:   normalized_type,
        contra: contra
      )
    end

    def find_office
      Cooperatives::Office.find(office_id)
    end
  end
end
