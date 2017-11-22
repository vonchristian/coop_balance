module CoopConfigurationsModule
  class BranchOffice < ApplicationRecord
    enum branch_type: [:main_office, :satellite_office]
    belongs_to :cooperative
    has_many :sections, class_name: "CoopConfigurationsModule::Section"
    has_many :entries, class_name: "AccountingModule::Entry"
    validates :branch_name, presence: true, uniqueness: true
    validates :contact_number, presence: true
    validates :address, presence: true
    def name
      branch_name
    end
  end
end
