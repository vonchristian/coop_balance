module Offices
  class OfficeProgram < ApplicationRecord
    belongs_to :program,                    class_name: 'Cooperatives::Program'
    belongs_to :office,                     class_name: 'Cooperatives::Office'
    belongs_to :ledger, class_name: 'AccountingModule::Ledger'

    validates :program_id, uniqueness: { scope: :office_id }
  end
end
