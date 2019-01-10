class Beneficiary < ApplicationRecord
	belongs_to :member
  belongs_to :cooperative
	validates :full_name, :relationship, presence: true
end
