module CoopServicesModule
	class SavingProduct < ApplicationRecord
	  enum interest_recurrence:[:daily, :weekly, :monthly, :quarterly, :annually]

	  has_many :subscribers, class_name: "MembershipsModule::Saving"
	  belongs_to :account, class_name: "AccountingModule::Account"

	  validates :interest_rate, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
	  validates :interest_recurrence, presence: true
	  validates :name, presence: true, uniqueness: true
	  validates :account_id, presence: true

    delegate :name, to: :account, prefix: true

    def self.accounts
    	all.map{|a| a.account_name }
    end
	  def post_interests_earned
	  	subscribers.each do |saving|
	  		InterestPosting.new.post_interests_earned(saving)
	  	end
	  end
	end
end
