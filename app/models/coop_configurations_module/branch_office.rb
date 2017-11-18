module CoopConfigurationsModule
  class BranchOffice < ApplicationRecord
    belongs_to :cooperative
    has_many :sections, class_name: "CoopConfigurationsModule::Section"
    validates :branch_name, presence: true, uniqueness: true
    validates :contact_number, presence: true
    validates :address, presence: true
  end
end
