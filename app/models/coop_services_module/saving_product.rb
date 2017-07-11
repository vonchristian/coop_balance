class SavingProduct < ApplicationRecord
  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :annually]
  has_many :subscribers, class_name: "Saving"
  
  def post_interests_earned
  	subscribers.each do |saving|
  		InterestPosting.new.post_interests_earned(saving)
  	end 
  end 
end
