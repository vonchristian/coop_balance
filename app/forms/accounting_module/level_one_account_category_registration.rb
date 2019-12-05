module AccountingModule
  class LevelOneAccountCategoryRegistration
    include ActiveModel::Model

    attr_accessor :title, :code, :contra, :type, :office_id, :level_two_account_category_id

    validates :title, :code, :type, :office_id, presence: true
    validates :type, inclusion: { in: AccountingModule::Account::TYPES }
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
        title:                         title,
        code:                          code,
        type:                          normalized_type,
        contra:                        contra,
        level_two_account_category_id: level_two_account_category_id
      )
    end

    def find_office
      Cooperatives::Office.find(office_id)
    end
  end
end
