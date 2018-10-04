class Beneficiary < ApplicationRecord
	belongs_to :member
	validates :full_name, :relationship, presence: true
end
