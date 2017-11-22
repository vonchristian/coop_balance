module CoopConfigurationsModule
  class Section < ApplicationRecord
    belongs_to :branch_office
    validates :name, presence: true, uniqueness: true
  end
end
