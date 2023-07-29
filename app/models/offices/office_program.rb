module Offices
  class OfficeProgram < ApplicationRecord
    belongs_to :program,                    class_name: 'Cooperatives::Program'
    belongs_to :office,                     class_name: 'Cooperatives::Office'
    belongs_to :level_one_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :ledger, class_name: 'AccountingModule::Ledger'
    validates :program_id, presence: true, uniqueness: { scope: :office_id }

  end
end
