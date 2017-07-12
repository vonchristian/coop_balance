require 'rails_helper'

module MembershipsModule
  describe ProgramSubscription do
    context "associations" do 
    	it { is_expected.to belong_to :program }
    	it { is_expected.to belong_to :subscriber }
    	it { is_expected.to have_many :subscription_payments }
    end
  end
end
