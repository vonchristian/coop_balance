module CoopConfigurationsModule
  class Section < ApplicationRecord
    belongs_to :branch_office
  end
end
