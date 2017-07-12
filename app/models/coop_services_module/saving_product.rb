module CoopServicesModule
	class SavingProduct < ApplicationRecord
	  enum interest_recurrence:[:daily, :weekly, :monthly, :quarterly, :annually]
	  has_many :subscribers, class_name: "MembershipsModule::Saving"

	  validates :interest_rate, numericality: { greater_than: 0.01 }, presence: true
	  validates :interest_recurrence, presence: true
	  validates :name, presence: true, uniqueness: true
	  def post_interests_earned
	  	subscribers.each do |saving|
	  		InterestPosting.new.post_interests_earned(saving)
	  	end 
	  end 
	end
end