module MembershipsModule 
  class IncomeSource < ApplicationRecord
    belongs_to :income_source_category
    belongs_to :member

    validates :designation, :description, presence: true 
    def self.designations 
      return NullIncomeSource.new.designation if self.blank?

      pluck(:designation).join(",")
    end 
  end
end 